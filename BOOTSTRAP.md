Bootstrap notes ===============

All work has been done with Chef 12.0.3 on OS X as the workstation. YMMV as regards a
different Chef version or different workstation OS, minor modification may prove necessary.
I recommend using a linux VM as a Chef workstation with the latest chef version installed
using the omnibus installer, everything should work as described.

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
The following command will bootstrap a Xen VM, setting its node name, chef environment,
and run_list. 

The chef-centos.rb template is based on the default bootstrap template in Chef 12.03,
found at knife/bootstrap/chef-full.erb within the chef installation directory, with some 
additional hostname fixes.

```
$ knife bootstrap [ip] -x root -P [passwd] -N [FQDN] -E [chef env] -t [template] -r [run_list] --secret-file /dev/tty
```

- _ip_:       IP address of node being bootstrapped
- _passwd_:   Password for root on the node being bootstrapped
- _FQDN_:   
  * It is important to set the fully qualified hostname as the chef node name, e.g.  haproxysvc01.pssea.office
  * The bootstrap template will use this name to set the hostname correctly (using the hostname 
  command and /etc/hosts file) so 'hostname -f' works and ohai gets the correct information the 
  first time
  * the host name (excluding domain name) must be 15 characters or less, this is a NETBIOS limitation
- _chef env_: dev, test or production
- _template_: Full path to location of template, e.g. ~/chef-repo/.chef/bootstrap/chef-centos.rb
- _run_list_: e.g. (including quotes) 'role[haproxy-service]'
- _secret file_: This is used to decrypt encrypted data bags the node needs. Specifying the file as /dev/tty on a linux or OS X system allows one to paste it in to the bootstrap session; note that you won't be prompted. Type control-d to end input. The contents pasted in will be saved in /etc/chef/encrypted/data_bag_secret.

Example:
```
$ knife bootstrap 10.17.0.230 -x root -P '<password>' -N centos4.pssea.office -E dev -t ~/chef-repo/.chef/bootstrap/chef-centos.erb --run-list 'role[haproxy-service]' --secret-file /dev/tty
Connecting to 10.17.0.230
somelinesofsecretdatapastedinherefromyoursecretsvault
Loremipsumdolorsitamet,consecteturadipiscingelit.Cura
itureleifendlacinialigula,nonfinibuseratpulvina quis.
Utmaximusleovelfringillafringilla.Utsitametelitex.123
<control-d>
10.17.0.230 Starting first Chef Client run...
10.17.0.230 Running handlers complete
10.17.0.230 Chef Client finished ...
```

Encrypted data bags
-------------------

