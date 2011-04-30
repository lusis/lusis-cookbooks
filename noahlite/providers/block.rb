#
# Author:: John E. Vincent (<lusis.org+github.com@gmail.com>)
# Cookbook Name:: noahlite
#
# Copyright (c) 2010 John E. Vincent
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

require 'timeout'
require 'net/http'
require 'uri'
require 'json'

action :wait_for do
  begin
    timeout(new_resource.timeout) do
      Chef::Log.info("Watching #{new_resource.path}. Timeout in #{new_resource.timeout} seconds")
      wait_for_result
    end
  rescue Timeout::Error
    Chef::Application.fatal!("Noah server did not return a result in the specified time")
  rescue Errno::ECONNREFUSED
    if new_resource.on_failure == :retry
      Chef::Log.info("Noah server unreachable. Retrying every #{new_resource.retry_interval} seconds")
      sleep new_resource.retry_interval
      retry
    elsif new_resource.on_failure == :pass
      Chef::Log.info("Noah server unreachable. Continuing")
    else
      Chef::Application.fatal!("Noah server unreachable. Stopping")
    end
  end
end

private
def get_result
  uri = URI.parse(new_resource.path)
  resp = Net::HTTP.get_response(uri)
  resp
end

def wait_for_result
  resp = get_result
  case resp.code
  when "500"
    Chef::Application.fatal!("Noah server returned a fatal error (#{resp.code}): #{resp.body}")
  when "404"
    Chef::Log.debug("Got 404 from Noah server")
    Chef::Log.info("Resource not found. Sleeping")
    sleep new_resource.retry_interval until get_result.code == "200"
    check_result(resp.body) if new_resource.data
    Chef::Log.debug("Resource ready. Continuing")
  when "200"
    Chef::Log.info("Resource path found.")
    check_result(resp.body) if new_resource.data
    Chef::Log.debug("Resource ready. Continuing")
  else
    Chef::Application.fatal!("Noah server returned an unknown status (#{resp.code}): #{resp.body}")
  end
end

def check_result(data)
  if data != new_resource.data
    Chef::Log.info("Resource found but data does not match. Sleeping")
    Chef::Log.debug("Data returned does not match expected. Retrying in #{new_resource.retry_interval}")
    sleep new_resource.retry_interval
    wait_for_result
  else
    Chef::Log.info("Resource ready. Continuing")
  end
end


