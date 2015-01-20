# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "sanditiffin"
client_key               "#{current_dir}/sanditiffin.pem"
validation_client_name   "tlatc-validator"
validation_key           "#{current_dir}/tlatc-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/tlatc"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
