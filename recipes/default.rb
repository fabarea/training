#
# Author:: Fabien Udriot (<fabien.udriot@typo3.org>)
# Cookbook Name:: training
# Recipe:: default
#
# Copyright 2013, Fabien Udriot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#########################
# packages
#########################

package 'rubygems'
gem_package 'ruby-shadow'

#########################
# System
#########################

# openssl passwd -1 ""

people = {
  'fabien' => '$1$yiArweBu$2b57XclFDdB9v7hIHxusN0',
  'fiacre' => '$1$x2ZkZVkM$FDWdaxbxHydaawThgZn3V.'
}

people.each do |username, password|

  user username do
    supports :manage_home => true
    home "/home/#{username}"
    password password
    shell '/bin/bash'
  end

  group username do
    members [username]
  end

  directory "/home/#{username}/public_html" do
    owner username
    group username
    recursive true
  end
end


#########################
# Services
#########################

include_recipe "apache2"
include_recipe "database::mysql"
include_recipe "mysql::server"

apache_module "userdir"


# define mysql connection parameters
mysql_connection_info = {
  :host => "localhost",
  :username => "root",
  :password => node['mysql']['server_root_password']
}

people.each do |username, password|

# create the database
  mysql_database username do
    connection mysql_connection_info
    action :create
  end

# create database user
  mysql_database_user username do
    connection mysql_connection_info
    password username
    database_name username
    privileges [:select, :update, :insert, :create, :alter, :drop, :delete]
    action :grant
  end
end
