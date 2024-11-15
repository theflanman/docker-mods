# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy AS buildstage

# set up deps
RUN apt update 
RUN apt install -y git
RUN apt install -y clang cmake yasm

# clone svt-av1-psy
WORKDIR /opt
RUN git clone https://github.com/gianni-rosato/svt-av1-psy.git
WORKDIR /opt/svt-av1-psy/Build/linux
RUN ./build.sh --native --shared --release --enable-lto

RUN find ../..

RUN ./build.sh --help

FROM scratch

LABEL maintainer="theflanman"

# Add files from buildstage
COPY --from=buildstage /opt/svt-av1-psy/Bin/Release/libSvtAv1Enc* /usr/lib/jellyfin-ffmpeg/lib