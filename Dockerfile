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
    wget \
    libfontconfig1-dev \
    libfreetype6-dev \
    ghostscript \
    perl && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/install-tl-unx && \
    curl -L https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${TEXLIVE_VERSION}/install-tl-unx.tar.gz \
    | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
    > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
    -profile /tmp/install-tl-unx/texlive.profile && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linux /usr/local/texlive/bin

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
