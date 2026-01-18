Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }
end

# タイムゾーンを明示的に設定
Sidekiq.configure_server do |config|
  config.on(:startup) do
    # Sidekiqサーバー起動時にタイムゾーンを設定
    Time.zone = "Tokyo"
  end
end
