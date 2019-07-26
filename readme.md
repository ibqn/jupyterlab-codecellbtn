# jupyterlab-ext

![screenshot](screenshot.png)


## Prerequisites
Install `JupyterLab`
```shell
bash jupyter.bash
```
## Installation
```shell
jupyter labextension install @ibqn/jupyterlab_codebtn
```

## Development
For a development install do the following in the repository directory:
```shell
npm install
npm run build
jupyter labextension link .
```
To rebuild the package and the JupyterLab app:
```shell
npm run build
jupyter lab build
```

Build docker container
```shell
docker build --tag=jupyterlab_ext .
```
and launch it
```shell
docker run -p 9999:80 jupyterlab_ext
```