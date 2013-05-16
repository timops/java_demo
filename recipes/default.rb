#
# Cookbook Name:: java_demo
# Recipe:: default
#
# Copyright (C) 2013 Tim Green
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'mysql::server'
include_recipe 'mysql::ruby'
include_recipe 'tomcat::default'

# database creation/management
include_recipe 'java_demo::db'

db_attrs = node['java_demo']['db_attrs'] 

# retrieve artifact from s3
if attribute?('ec2')
  s3_file File.join(node['java_demo']['artifact_repo'], "dbapp-0.0.1-SNAPSHOT.war") do
    remote_path node['s3_file']['remote_path']
    bucket node['s3_file']['bucket']
    aws_access_key_id node['s3_file']['aws_access_key_id']
    aws_secret_access_key node['s3_file']['aws_secret_access_key']
    action :create
  end
end

application db_attrs['app_name'] do
  # where do we get the file from?  can also change this to a http URL (jenkins, TODO)
  scm_provider node['java_demo']['scm_provider']
  repository node['java_demo']['repo_src']
  path node['java_demo']['app_dir']
  owner node['tomcat']['user']

  java_webapp do
    #context_template 'context.xml.erb'
    #database_master_role 'database_master'
    database do
      driver db_attrs['driver']
      adapter db_attrs['adapter']
      database db_attrs['db_name'] 
      username db_attrs['username']
      password db_attrs['password']
      host db_attrs['hostname']
      port db_attrs['port']
     
      max_active 50
      max_idle 30
      max_wait 10000
    end
  end
  tomcat
end
