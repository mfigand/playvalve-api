class RedisService
  def self.redis(&block)
    RedisConnectionPool.with(&block)
  end

  def self.whitelisted?(key:, value:)
    redis do |client|
      client.sismember(key, value)
    end
  end

  def self.add_to_whitelist(key:, value:)
    redis do |client|
      client.sadd(key, value)
    end
  end

  def self.remove_from_whitelist(key:, value:)
    redis do |client|
      client.srem(key, value)
    end
  end

  def self.cache_result(key:, value:, expires_in: 24.hours)
    redis do |client|
      client.set(key, value.to_json, ex: expires_in)
    end
  end

  def self.get_cached_result(key:)
    redis do |client|
      value = client.get(key)
      value ? JSON.parse(value) : nil
    end
  end
end
