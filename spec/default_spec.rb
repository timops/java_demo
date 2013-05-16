require_relative 'spec_helper'

describe 'java_demo::default' do
  chef_run = mChefSpec::ChefRunner.new(log_level: :error, cookbook_path: COOKBOOK_PATH, platform: 'ubuntu', version: '12.04') do |node|
    node.set['mysql']['server_debian_password'] = 'password'
    node.set['mysql']['server_root_password'] = 'password'
    node.set['mysql']['server_repl_password'] = 'password'
  end
  chef_run.converge 'java_demo::default' 
  it 'should include the mysql::server recipe' do
    chef_run.should include_recipe 'mysql::server'
  end
  it 'should include the mysql::ruby recipe' do
    chef_run.should include_recipe 'mysql::ruby'
  end 
  it 'should include the tomcat::default recipe' do
    chef_run.should include_recipe 'tomcat::default'
  end
  it 'should include the java_demo::db recipe' do
    chef_run.should include_recipe 'java_demo::db'
  end
end
