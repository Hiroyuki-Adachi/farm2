FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーン / 言語 / Ruby / Rust PATH
ENV TZ=Asia/Tokyo \
    LANG=C.UTF-8 \
    RUBY_VERSION=4.0.2 \
    PATH="/root/.cargo/bin:${PATH}"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 開発とデバッグ向けの基本ツールを含めてインストール
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential libpq-dev git curl tzdata \
      libsqlite3-dev sqlite3 zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
      libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common \
      libffi-dev ca-certificates gnupg vim \
      patch bubblewrap ripgrep jq less procps iproute2 iputils-ping openssh-client && \
    rm -rf /var/lib/apt/lists/*

# コンテナ内のUID差異で git が "dubious ownership" を出しにくくする
RUN git config --system --add safe.directory /farm2

# 最新版 Node.js をインストール
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
WORKDIR /tmp
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# Rust のインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Ruby のインストール
RUN curl -O https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-$RUBY_VERSION.tar.gz
RUN tar xzvf ruby-$RUBY_VERSION.tar.gz
WORKDIR /tmp/ruby-$RUBY_VERSION
RUN ./configure --enable-yjit && make && make install

# アプリケーションディレクトリを作成
RUN mkdir /farm2

# ホストの設定ファイルをコピー
COPY Gemfile Gemfile.lock /farm2/
WORKDIR /farm2

# bundle install
RUN gem update --system
RUN gem install bundler
RUN bundle install
