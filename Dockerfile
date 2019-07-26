# python stage

FROM python:3.6-alpine as base

WORKDIR /app

# install dependencies
RUN apk add \
        build-base \
        libzmq \
        musl-dev \
        zeromq-dev && \
    apk --update add --no-cache \
        lapack-dev \
        gcc \
        freetype-dev && \
    apk add --no-cache --virtual .build-deps \
        gfortran \
        g++ \
        libstdc++ \
        linux-headers \
        libpng-dev

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

COPY . .

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip wheel --no-cache-dir --no-deps \
        --wheel-dir /wheels -r ./freezed-requirements.txt

# jupyterlab with extension

FROM python:3.6-alpine

WORKDIR /app

RUN apk add --no-cache libzmq lapack freetype && \
    apk add --update --no-cache nodejs nodejs-npm

COPY --from=base /wheels /wheels

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache /wheels/*

COPY . .

RUN npm install -g npm && \
    npm install && \
    npm run build

RUN jupyter labextension link .

EXPOSE 80

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--port", "80", "--ip=0.0.0.0"]
