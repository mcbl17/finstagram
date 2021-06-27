configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  if Sinatra::Application.development?
    set :database, {
    adapter: "sqlite3",
    database: "db/db.sqlite3"
  }
  else
    db_url = "postgres://whrclyekxnerpa:af1d8b28ee0b9262686a706c68da3bd9e0fc54ee802407c8fd2a288f7acc357b@ec2-34-202-54-225.compute-1.amazonaws.com:5432/d41bv2gkdjbs1f"
    db = URI.parse(ENV['DATABASE_URL'] || db_url)
    set :database {
      adapter: "postgresql",
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..=1],
      encoding: 'utf8'
    }
  end
  
  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end
