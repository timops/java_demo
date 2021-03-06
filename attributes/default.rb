#
# Cookbook Name:: java_demo
# Attributes:: default
#
# Copyright (C) 2013 Tim Green
# 
# All rights reserved - Do Not Redistribute
#

# mysql cookbook overrides
override['mysql']['server_root_password'] = 'password'
override['mysql']['bind_address'] = 'localhost'
override['mysql']['port'] = 3306
override['mysql']['grants_path'] = '/etc/mysql/grants.sql'
override['mysql']['conf_dir'] = '/etc/mysql'


# tomcat cookbook overrides
override['tomcat']['config_dir'] = '/etc/tomcat6'
override['tomcat']['context_dir'] = "#{tomcat['config_dir']}/Catalina/localhost"
override['tomcat']['webapp_dir'] = '/var/lib/tomcat6/webapps'
override['tomcat']['user'] = 'tomcat6'

# java_demo attributes
default['database']['mysql'] = {
  'host'     => 'localhost',
  'database' => 'dbapp_production',
  'username' => 'root',
  'password' => node['mysql']['server_root_password']
}

default['java_demo']['db_attrs'] = {
  'driver'   => 'com.mysql.jdbc.Driver',
  'adapter'  => 'mysql',
  'app_name' => 'dbapp',
  'db_name'  => default['database']['mysql']['database'],
  'username' => 'dbapp',
  'password' => 'password',
  'hostname' => default['database']['mysql']['host'],
  'port'     => 3306
}

# s3 lwrp used to retrieve the artifact when the host lives in ec2
if attribute?('ec2')
  default['java_demo']['scm_provider'] = Chef::Provider::File::Deploy
  default['java_demo']['artifact_repo'] = '/tmp'
else
  default['java_demo']['scm_provider'] = Chef::Provider::RemoteFile::Deploy
  default['java_demo']['artifact_repo'] = 'http://33.33.33.10/artifacts'
end

# directory that the war files get deployed to
default['java_demo']['app_dir'] = '/tmp/releases'
# artifact location
default['java_demo']['repo_src'] = "#{default['java_demo']['artifact_repo']}/dbapp-0.0.1-SNAPSHOT.war"

# s3 attrs
override['s3_file']['bucket'] = 'tgopc'
override['s3_file']['remote_path'] = '/dbapp.war'
override['s3_file']['aws_access_key_id'] = 'AKIAJWNKCT25JSBQWWSA'
override['s3_file']['aws_secret_access_key'] = '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'
