#
# Cookbook Name:: rpmbuild
# Recipe:: default
#
# Copyright 2010, John E. Vincent <lusis.org+github.com@gmail.com>
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

case node.platform
when "centos", "redhat", "fedora"
  %w[rpm-build gcc gcc-c++ kernel-devel].each do |rpm|
    package "#{rpm}" do
      action :install
    end
  end

  node[:rpmbuild][:additional_packages].each do |additional|
    package "#{additional}" do
      action :install
    end
  end

  user "#{node[:rpmbuild][:user]}" do
    comment "#{node[:rpmbuild][:gecos]}"
    system true
    action [ :create, :modify, :manage ]
    supports :manage_home => true
    shell "/bin/bash"
    home "#{node[:rpmbuild][:home_dir]}"
  end

  %w[SRPMS SPECS RPMS/i386 RPMS/x86_64 BUILD SOURCES].each do |dir|
    directory "#{node[:rpmbuild][:build_dir]}/#{dir}" do 
      owner node[:rpmbuild][:user]
      group node[:rpmbuild][:user]
      mode 0700
      recursive true
    end
  end

  directory "#{node[:rpmbuild][:tmp_dir]}" do
    owner node[:rpmbuild][:user]
    group node[:rpmbuild][:user]
    mode 0700
    recursive true
  end

  template "rpmmacros" do
    path "#{node[:rpmbuild][:home_dir]}/.rpmmacros"
    source "rpmmacros.erb"
    owner node[:rpmbuild][:user]
    group node[:rpmbuild][:user]
    mode 0750
  end
else
  log("This recipe is only useful on RedHat derivatives")
end
