#
# Cookbook Name:: s3client
#

#Install deps
case node.platform
when "debian", "ubuntu"
  include_recipe "apt"
  packages = ['libxml2-dev','libxslt-dev']
  packages.each do |pkg|
    package pkg do
      action :install
    end
  end
when "centos", "redhat", "fedora"
  packages = ['libxml2-devel','libxslt-devel']
  packages.each do |pkg|
    package pkg do
      action :install
    end
  end
else
  Chef::Log.error("Can't install on #{node.platform} yet.")
end

gem_package "aws-s3" do
  action :install
end
