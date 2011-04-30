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

require 'json'
require 'uri'
require 'net/http'
require 'timeout'

action :create do
  connect_and_do("create")
end

action :delete do
  connect_and_do("delete")
end

private
def connect_and_do(action)
  @net_timeout = new_resource.timeout
  @retry_interval = new_resource.retry_interval
  @app_name = new_resource.name
  @on_failure = new_resource.on_failure
  @noah_server = new_resource.noah_server
  @noah_port = new_resource.noah_port
  begin
    timeout(@net_timeout) do
      Chef::Log.info("Calling #{action} on application #{@app_name} in Noah")
      @http = Net::HTTP.new(@noah_server, @noah_port)
      method("#{action}_application").call
    end
  rescue Timeout::Error
    Chef::Application.fatal!("Noah server did not return a result in the allotted time")
  rescue Errno::ECONNREFUSED
    if @on_failure == :retry
      Chef::Log.info("Noah server unreachable, Retrying in #{@retry_interval} seconds")
      sleep @retry_interval
      retry
    elsif @on_failure == :pass
      Chef::Log.info("Noah server unreachable. Skipping")
    else
      Chef::Application.fatal!("Noah server unreachable. Failing")
    end
  end
end

def create_application
  Chef::Log.debug("Ohai. I made yu somefing")
  msg = {:name => @app_name}
  req = Net::HTTP::Put.new("/applications/#{@app_name}")
  req.body = msg.to_json
  handle_response(@http.request(req))
end

def delete_application
  Chef::Log.debug("Ohai. I deleted dis...")
  req = Net::HTTP::Delete.new("/applications/#{@app_name}")
  handle_response(@http.request(req))  
end

def handle_response(res)
  data = JSON.parse(res.body)
  case res.code
  when "500"
    Chef::Application.fatal!("Noah server returned an error (#{res.code}): #{data["error_message"]}") unless @on_failure == :pass
    Chef::Log.warn("Noah returned #{res.code}. Ignoring")
  when "404"
    # The only way this would happen on create is if Noah routes were broken
    Chef::Application.fatal!("Noah server returned an error (#{res.code}): #{data["error_message"]}") unless @on_failure == :pass
    Chef::Log.warn("Noah returned #{res.code}. Ignoring")
  when "200"
    Chef::Log.info("Application #{@app_name} #{data["action"]} successfully!")
    Chef::Log.debug("Message respone: #{res.body}")
  else
    # It's impossible to see this since everything in Noah is either 200,404 or 500....
    Chef::Application.fatal!("Noah server returned an error (#{res.code}): #{data["error_message"]}") unless @on_failure == :pass
    Chef::Log.warn("Noah returned #{res.code}. Ignoring")
  end
end
