require "uri"

def read_secret(name, default = nil)
  path = ENV.fetch("#{name}_FILE", File.join("/run/secrets", name))
  return File.read(path).strip if File.file?(path)

  ENV.fetch(name, default)
end

public_url = ENV.fetch("PUBLIC_URL", "http://localhost").sub(%r{/\z}, "")
public_host = URI(public_url).host || "localhost"
db_host = ENV.fetch("DB_HOST", "mariadb")
db_port = ENV.fetch("DB_PORT", "3306")
db_name = ENV.fetch("DB_NAME", "archivesspace")
db_user = ENV.fetch("DB_USER", "archivesspace")
db_password = read_secret("ARCHIVESSPACE_DB_PASSWORD", ENV.fetch("DB_PASSWORD", "changeme"))

AppConfig[:db_url] = "jdbc:mysql://#{db_host}:#{db_port}/#{db_name}?useUnicode=true&characterEncoding=UTF-8&user=#{db_user}&password=#{db_password}&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
AppConfig[:solr_url] = "http://solr:8983/solr/archivesspace"

AppConfig[:frontend_proxy_url] = "#{public_url}/staff"
AppConfig[:public_proxy_url] = public_url

AppConfig[:global_email_from_address] = ENV.fetch("SMTP_FROM", "noreply@#{public_host}")
AppConfig[:email_delivery_method] = :smtp
AppConfig[:email_perform_deliveries] = true
AppConfig[:email_raise_delivery_errors] = true
AppConfig[:email_smtp_settings] = {
  address: ENV.fetch("SMTP_HOST", "host.docker.internal"),
  port: ENV.fetch("SMTP_PORT", "25").to_i,
  domain: public_host,
  enable_starttls_auto: false
}

AppConfig[:enable_oai] = false
