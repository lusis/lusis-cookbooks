#
# Author:: John E. Vincent (<lusis.org+github.com@gmail.com>)
# Cookbook Name:: noahlite
#
# Copyright (c) 2010 Basho Technologies, Inc.
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
def initialize(*args)
  super
  @action = :wait_for
end

actions :wait_for

#attribute :path, :kind_of => [String], :name_attribute => true
attribute :path, :kind_of => [String], :name_attribute => true, :required => true
# how long to wait for
attribute :timeout, :kind_of => [Integer], :default => 60
attribute :data, :kind_of => [String]
attribute :retry_interval, :kind_of => [Integer], :default => 3
attribute :on_failure, :kind_of => [Symbol], :default => :retry
