REDIS_POOL_SIZE = ENV.fetch("REDIS_POOL_SIZE", 10).to_i
REDIS_POOL_TIMEOUT = ENV.fetch("REDIS_POOL_TIMEOUT", 5).to_i
REDIS_URL = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")

# Connection pool configuration
RedisConnectionPool = ConnectionPool.new(size: REDIS_POOL_SIZE, timeout: REDIS_POOL_TIMEOUT) do
  Redis.new(url: REDIS_URL)
end
