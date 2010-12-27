#
# Cookbook Name:: java
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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

default["jdk"]["format"] = "rpm"
default["jdk"]["install_flavor"] = "sun"
default["jdk"]["major_version"] = "6"
default["jdk"]["minor_version"] = "23"

default["jdk"]["rpm_version"] = node["jdk"]["major_version"] + "u" + node["jdk"]["minor_version"]


case platform
when "centos","redhat","fedora"
  set["java"]["java_home"] = "/usr/java/jdk1.#{node["jdk"]["major_version"]}.0_#{node["jdk"]["minor_version"]}"
else
	set["java"]["java_home"] = "/usr/lib/jvm/default-java"
end
