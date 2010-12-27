maintainer        "John E. Vincent"
maintainer_email  "lusis.org+github.com@gmail.com"
license           "Apache 2.0"
description       "Installs Java JDK"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"
depends "apt"
%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end
recipe "jdk", "Installs JDK to provide Java"
