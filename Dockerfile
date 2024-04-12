# https://github.com/pddg/latex-docker

FROM ubuntu:20.04

ARG TEXLIVE_VERSION=2024

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="/usr/local/texlive/bin:$PATH"
ENV LC_ALL=C

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    make \
    perl && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp 
RUN curl -L -o install-tl-unx.tar.gz https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz 
RUN zcat < install-tl-unx.tar.gz | tar xf - \
    && cd install-tl-*/ 
RUN perl ./install-tl --no-interaction 

RUN tlmgr update --self && \
    tlmgr install \
    collection-bibtexextra \
    collection-fontsrecommended \
    collection-langenglish \
    collection-langjapanese \
    collection-latexextra \
    collection-latexrecommended \
    collection-luatex \
    collection-mathscience \
    collection-plaingeneric \
    collection-xetex \
    latexmk \
    latexdiff

WORKDIR /workdir

COPY .latexmkrc /
COPY .latexmkrc /root/
