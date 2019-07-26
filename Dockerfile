FROM python:3.6-alpine as base
WORKDIR /app

RUN apk add build-base libzmq musl-dev zeromq-dev

# install dependencies
RUN apk --update add --no-cache \
    lapack-dev \
    gcc \
    freetype-dev

# install dependencies
RUN apk add --no-cache --virtual .build-deps \
    gfortran \
    g++ \
    libstdc++ \
    linux-headers \
    libpng-dev

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

COPY freezed-requirements.txt  /app/

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r /app/freezed-requirements.txt



FROM python:3.6-alpine
WORKDIR /app

RUN apk add libzmq

COPY --from=base /wheels /wheels
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache /wheels/*
COPY function-plot.ipynb /app

EXPOSE 80

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--port", "80", "--ip=0.0.0.0"]
