class ForwardedPrefixMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    prefix = normalize_prefix(env['HTTP_X_FORWARDED_PREFIX'])
    return @app.call(env) if prefix.nil?

    env['SCRIPT_NAME'] = prefix

    path_info = env['PATH_INFO'].to_s
    env['PATH_INFO'] = '/' if path_info.empty?

    @app.call(env)
  end

  private

  def normalize_prefix(value)
    path = value.to_s.strip
    return nil if path.empty? || path == '/'

    normalized = path.start_with?('/') ? path : "/#{path}"
    normalized.sub(%r{/*\z}, '')
  end
end
