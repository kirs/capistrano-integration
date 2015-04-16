require 'bundler/setup'
require 'droplet_kit'
require 'net/scp'
require 'net/ssh'
require 'pry'

DROPLET_NAME = "capistrano-rails"

token = ENV['DO_ACCESS_TOKEN']
raise "empty token" if token.blank?
client = DropletKit::Client.new(access_token: token)
key = client.ssh_keys.all.to_a.last

all = client.droplets.all
if existing = all.find { |d| d.name == DROPLET_NAME }
  puts "deleting #{existing}"
  client.droplets.delete(id: existing.id)
end

droplet = DropletKit::Droplet.new(name: DROPLET_NAME, region: 'nyc2', image: 'ubuntu-14-04-x64', size: '512mb', ssh_keys: [key.id])
created = client.droplets.create(droplet)

found = nil
loop do
  found = client.droplets.find(id: created.id)

  if found.status != "new"
    break
  else
    puts "VM is not available yet"
    sleep 10
  end
end

host = found.networks.v4[0].ip_address

binding.pry
Net::SCP.upload!(host, "root", "./script.sh", "/tmp/setup")

Net::SSH.start(host, 'root') do |ssh|
  ssh.exec!("chmod +x /tmp/setup")

  stdout = ""
  ssh.exec!("/tmp/setup") do |channel, stream, data|
    puts data
    stdout << data if stream == :stdout
  end
  puts stdout
end

puts "host: #{host}"
