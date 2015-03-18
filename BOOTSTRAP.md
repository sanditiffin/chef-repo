Bootstrap notes
===============

All work has been done with Chef 12.0.3 on OS X as the workstation. YMMV as regards a
different Chef version or different workstation OS, minor modification may prove necessary.

```
$ knife --version
Chef: 12.0.3
```

Knife configs
-------------
Make sure you have a good knife.rb file configured, e.g. as below.
(with CHEF_USER or USER set in the environment for this knife.rb)
```
current_dir = File.dirname(__FILE__)
user = ENV['CHEF_USER'] || ENV['USER']
node_name                user
client_key               "#{ENV['HOME']}/.chef/#{user}.pem"
validation_client_name   "payscale-validator"
validation_key           "#{ENV['HOME']}/.chef/payscale-validator.pem"
chef_server_url          "https://chef.underpaid.com/organizations/payscale"
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntax_check_cache"
cookbook_path            ["#{current_dir}/../cookbooks"]
cookbook_copyright       "PayScale, Inc."
cookbook_email           "psdev@payscale.com"
knife[:editor] =         "<path to desired editor>"
```
Bootstrap command
-----------------
```
$ knife bootstrap [ip] -x root -P [passwd] -N [FQDN] -E [chef env] -t [template] -r [run_list]
```

ip:       ip address of node being bootstrapped
passwd:   password for root on the node being bootstrapped
FQDN:   
* important to set the fully qualified hostname as the chef node name, e.g.  haproxysvc01.pssea.office
* the bootstrap template will use this name to set the hostname correctly (using the hostname 
  command and /etc/hosts file) so 'hostname -f' works and ohai gets the correct information the 
  first time
chef env: dev, test or production
template: full path to location of template, e.g. ~/chef-repo/.chef/bootstrap/chef-centos.rb
run_list: e.g. 'role[haproxy-service]'
