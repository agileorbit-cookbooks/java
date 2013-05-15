# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Recipe:: openjdk
#
# Copyright 2010-2011, Opscode, Inc.
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

java_location = Opscode::OpenJDK.new(node).java_location

include_recipe 'java::set_java_home'

if platform_family?('debian', 'rhel', 'fedora')

  bash 'update-java-alternatives' do
    code <<-EOH
      update-alternatives --install /usr/bin/java java #{java_location} 1061;
      update-alternatives--set java #{node['java']['java_home']}/bin/java
    EOH
    action :nothing
  end

end

node['java']['openjdk_packages'].each do |pkg|
  package pkg do
    action :install
    notifies :run, 'bash[update-java-alternatives]', :immediately if platform_family?('debian', 'rhel', 'fedora')
  end
end
