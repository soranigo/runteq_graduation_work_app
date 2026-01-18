#!/bin/bash
set -e

# Sidekiqをバックグラウンドで起動
bundle exec sidekiq &

# Railsサーバーをフォアグラウンドで起動
exec bundle exec rails server -b 0.0.0.0