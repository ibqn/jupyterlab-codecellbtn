# python stage

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

# node stage

FROM node:10.16-alpine as node_base
WORKDIR /app

COPY src /app/src
COPY style /app/style
COPY package.json package-lock.json tsconfig.json tslint.json /app/

RUN npm install && npm run build

# jupyterlab with extension

FROM python:3.6-alpine
WORKDIR /app

RUN apk add libzmq

COPY --from=base /wheels /wheels
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache /wheels/*
COPY function-plot.ipynb /app

COPY --from=node_base /app/package.json /app
COPY --from=node_base /app/lib  /app/lib

RUN apk add --update nodejs nodejs-npm

RUN jupyter labextension link .

EXPOSE 80

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--port", "80", "--ip=0.0.0.0"]
