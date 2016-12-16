server '52.199.246.46', user: 'jun', roles: %w{app db web}

set :ssh_options, keys: '~/.ssh/Webserver_key_rsa'
