# docker-tor-browser
Tor-Browser with all latest version of utilities in minimal [Alpine Linux](https://alpinelinux.org) container, which take less than 350 MB

also you can choose Tor-Browser [language](Dockerfile#L2) and specify that you don't want to use [Librefox](https://github.com/intika/Librefox) config [(using by default)](Dockerfile#L3)

### build:
`docker build -t tor-browser github.com/kzwg63tf/docker-tor-browser`

### preparation:
`xhost +local:docker` allow docker to open window

### running:
```
docker run --rm -dit \
    --device /dev/snd \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    tor-browser
```
 * __--device /dev/snd__ - mount sound devices
 * __/tmp/.X11-unix__ - path to x11 control directory
 
optianaly you can add:

`-v $HOME/Downloads/Tor:/tor/Browser/Downloads`

for downloading something from Tor-Browser
 
