# ベースとなるイメージを指定
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンを設定（これをしないと、ビルド時にタイムゾーンの設定を求められる）
ENV TZ=Asia/Tokyo \
    LANG=C.UTF-8 \
    RUBY_VERSION=4.0.2 \
    PATH="/root/.cargo/bin:${PATH}"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev git curl tzdata \
    libsqlite3-dev sqlite3 zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
    libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common \
    libffi-dev ca-certificates gnupg vim

#最新版nodejsをインストール
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
WORKDIR /tmp
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install nodejs

# Rustのインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Rubyのインストール
RUN curl -O https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-$RUBY_VERSION.tar.gz
RUN tar xzvf ruby-$RUBY_VERSION.tar.gz
WORKDIR /tmp/ruby-$RUBY_VERSION
RUN ./configure --enable-yjit && make && make install

# アプリケーションディレクトリを作成
RUN mkdir /farm2

# ホストの設定ファイルをコピー
COPY Gemfile Gemfile.lock /farm2/
WORKDIR /farm2

# バンドルインストール
RUN gem update --system
RUN gem install bundler
RUN bundle install

