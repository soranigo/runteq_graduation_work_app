#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /runteq_graduation_work_app/tmp/pids/server.pid

# 本番環境の場合のみマイグレーションを実行
if [ "$RAILS_ENV" = "production" ]; then
  echo "Running database migrations..."
  bundle exec rails db:migrate
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"