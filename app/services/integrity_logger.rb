class IntegrityLogger
  def initialize(options = {})
    @options = options
  end

  def log
    # here you can switch between different methods of logging based on configuration
    if Rails.configuration.use_external_logging
      external_log
    else
      database_log
    end
  end

  private

  attr_reader :options

  def database_log
    IntegrityLog.create(
      idfa: options[:idfa],
      ban_status: options[:ban_status],
      ip: options[:ip],
      rooted_device: options[:rooted_device],
      country: options[:country],
      proxy: options[:proxy],
      vpn: options[:vpn]
    )
  end

  def external_log
    # Here we log messages to a file, but it could implement
    # a logging to an external service or another data source (Sentry, Datadog, etc.)
    logger = Logger.new("/playvalve_api/log/integrity.log")
    logger.info("[#{Time.current}] - IntegrityLog #{options}")
  end
end
