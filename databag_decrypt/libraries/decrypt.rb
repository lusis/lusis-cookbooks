begin
  Gem.clear_paths
  require 'encrypted_strings'
rescue LoadError
  Chef::Log.error("Missing gem 'encrypted_strings'")
end

module Lusis
  module DBIDecrypt
    def item_decrypt(item)
      pp = passphrase
      begin
        data = item.to_s.decrypt(:symmetric, :algorithm => 'blowfish', :password => pp)
        data
      rescue OpenSSL::CipherError
        Chef::Log.error("Bad passphrase used for decryption")
      end
    end

    private
    def passphrase
    Chef::Log.info("Reading passphrase from #{node[:databag_decrypt][:passphrase_type]}: #{node[:databag_decrypt][:passphrase_location]}")
      case node[:databag_decrypt][:passphrase_type]
      when "passfile"
        begin
          # Read the first line of the password file
          passphrase = File.open(node[:databag_decrypt][:passphrase_location], "r").readlines[0].chomp
          passphrase
        rescue
          Chef::Log.error("Unable to read password file: #{node[:databag_decrypt][:passphrase_location]}")
        end
      when "url"
        begin
          require 'net/http'
          require 'uri'
          passphrase = Net::HTTP.get_print URI.parse(node[:databag_decrypt][:passphrase_location])
          passphrase
        rescue
          Chef::Log.error("Unable to connect to passphrase url: #{node[:databag_decrypt][:passphrase_location]}")
        end
      end
    end
  end
end
