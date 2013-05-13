#
# Cookbook Name:: java_demo
# Recipe:: db
#
# Copyright (C) 2013 Tim Green
# 
# All rights reserved - Do Not Redistribute
#

db_attrs = node['java_demo']['db_attrs'] 

cookbook_file 'schema' do
  backup false
  path "#{node['mysql']['conf_dir']}/schema.sql"
  action :create
  source 'schema.sql'
end

template node['mysql']['grants_path'] do
  source 'app_grants.sql.erb' 
  action :create
  variables({
    :database => node['database']['mysql']['host'],
    :username => node['database']['mysql']['username'], 
    :password => node['database']['mysql']['password']
  })
end

mysql_database_user db_attrs['db_name'] do
  connection node['database']['mysql']
  password db_attrs['username']
  action :create
end

mysql_database db_attrs['db_name'] do
  connection node['database']['mysql']
  action :create
end

mysql_database db_attrs['db_name'] do
  connection node['database']['mysql']
  sql { ::File.open(node['mysql']['grants_path']).read }
  action :query
end

mysql_database db_attrs['db_name'] do
  connection node['database']['mysql']
  sql { ::File.open("#{node['mysql']['conf_dir']}/schema.sql").read }
  action :query
end
