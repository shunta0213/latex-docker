FROM paperist/texlive-ja:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.anyenv/bin:$PATH"

# propmpt
COPY ./.prompt ~/.prompt
RUN echo 'source ~/.prompt' >> ~/.bashrc

# add japanese mirror
RUN echo "deb http://ftp.jp.debian.org/debian/ bookworm main contrib non-free non-free-firmware" > "/etc/apt/sources.list"

RUN apt update && apt upgrade \
    && apt install -y \
    git \
    locales \
    # fonts
    ttf-mscorefonts-installer \
    # pyenv requirements
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

RUN git clone https://github.com/anyenv/anyenv ~/.anyenv \
    && echo 'eval "$(anyenv init -)"' >> ~/.bashrc \
    && export PATH="$HOME/.anyenv/bin:$PATH" \
    && echo y | anyenv install --init \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

RUN mkdir -p /usr/local/ssl/certs \
    && ln -s /etc/ssl/certs /usr/local/ssl/certs

RUN anyenv install nodenv
RUN anyenv install pyenv

RUN cpan -i App::cpanminus \
    && cpanm YAML::Tiny \
    && cpanm File::HomeDir


RUN tlmgr install \
    latexindent \
    luacode \
    luatexja \
    geometry