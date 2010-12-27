#
# Cookbook Name:: java
# Recipe:: sun
#
# Copyright 2010, John E. Vincent
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

case node.kernel.machine
when "x86_64"
  java_rpm_arch = 'amd64'
when /i[0-9][0-9][0-9]/
  java_rpm_arch = 'i586'
else
  log("Unable to determine arch for rpm package")
end

node.run_state[:java_pkgs] = value_for_platform(
  ["debian","ubuntu"] => {
    "default" => ["sun-java6-jdk"]
  },
  "default" => ["jdk"]
)

case node.platform
when "debian","ubuntu"
  include_recipe "apt"
 
  template "/etc/apt/sources.list.d/canonical.com.list" do
    mode "0644"
    source "canonical.com.list.erb"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
when "centos", "redhat", "fedora"
  case node["jdk"]["format"]
    when "tar"
      # do something with a tarball
    when "rpm"
      cookbook_file "/var/tmp/jdk-#{node["jdk"]["rpm_version"]}-linux-#{java_rpm_arch}.rpm" do
        source "jdk-#{node["jdk"]["rpm_version"]}-linux-#{java_rpm_arch}.rpm"
        action :create_if_missing
      end

      rpm_package "jdk-#{node["jdk"]["rpm_version"]}-linux-#{java_rpm_arch}" do
        source "/var/tmp/jdk-#{node["jdk"]["rpm_version"]}-linux-#{java_rpm_arch}.rpm"
        action :install
      end
    end
else
  Chef::Log.error("Installation of Sun Java packages are only supported on Debian/Ubuntu at this time.")
end
