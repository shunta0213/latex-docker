FROM paperist/texlive-ja@sha256:9d3931d8daf03eef4131ad187d4a0d6bae6b8f1a79ce8220685760ab9ebad7d3

ENV DEBIAN_FRONTEND=noninteractive

# add japanese mirror
RUN echo "deb http://ftp.jp.debian.org/debian/ bookworm main contrib non-free non-free-firmware" > "/etc/apt/sources.list"

# Install base packages
RUN apt-get update && apt-get install -y \
    git \
    locales \
    curl \
    # fonts
    ttf-mscorefonts-installer \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && node --version \
    && npm --version \
    && rm -rf /var/lib/apt/lists/*

# Install Python and its build dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    && python3 --version \
    && pip3 --version \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

RUN mkdir -p /usr/local/ssl/certs \
    && ln -s /etc/ssl/certs /usr/local/ssl/certs

RUN cpan -i App::cpanminus \
    && cpanm YAML::Tiny \
    && cpanm File::HomeDir

RUN tlmgr update --self --all

RUN tlmgr install \
    latexindent \
    luacode \
    luatexja \
    geometry \
    biblatex \
    biber \
    physics2 \
    fixdif \
    derivative \
    dvipng
