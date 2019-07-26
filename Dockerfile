# jupyterlab with extension

FROM alpine:latest

ENV PYTHONUNBUFFERED 1

WORKDIR /app

# install build dependencies
RUN apk update && \
        apk add \
        ca-certificates \
        python3 \
        libzmq  \
        lapack \
        libpng \
        freetype \
        nodejs nodejs-npm \
    && apk --update add --no-cache --virtual=build_dependencies \
        python3-dev \
        musl-dev \
        zeromq-dev \
        lapack-dev \
        gcc \
        make \
        freetype-dev \
        gfortran \
        g++ \
        libstdc++ \
        linux-headers \
        libpng-dev \
    && ln -s /usr/include/locale.h /usr/include/xlocale.h

COPY . .

RUN python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir --upgrade -r ./freezed-requirements.txt \
    && npm install -g npm \
    && npm install \
    && npm run build \
    && apk del --purge -r build_dependencies \
    && rm -rf /var/cache/apk/*  \
    && jupyter labextension link . \
    && mkdir /notebooks  \
    && mv *.ipynb /notebooks

EXPOSE 80
VOLUME /notebooks

CMD ["jupyter", "lab", "--allow-root", "--no-browser", \
     "--port", "80", "--ip", "0.0.0.0", \
     "--notebook-dir", "/notebooks"]
