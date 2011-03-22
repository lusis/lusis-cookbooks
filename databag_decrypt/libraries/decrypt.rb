begin
  Gem.clear_paths
  require 'encrypted_strings'
rescue LoadError
  Chef::Log.error("Missing gem 'encrypted_strings'")
end

module Lusis
  module DBIDecrypt
    OpenSSLCipherError = OpenSSL::Cipher.const_defined?(:CipherError) ? OpenSSL::Cipher::CipherError : OpenSSL::CipherError
    def item_decrypt(item)
      pp = passphrase
      begin
        data = item.to_s.decrypt(:symmetric, :algorithm => 'blowfish', :password => pp)
        data
      rescue OpenSSLCipherError
        Chef::Log.error("Bad passphrase used for decryption")
      end
    end

    private
    def passphrase
    Chef::Log.debug("Reading passphrase from #{node[:databag_decrypt][:passphrase_type]}: #{node[:databag_decrypt][:passphrase_location]}")
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
          require 'open-uri'
          passphrase = open(node[:databag_decrypt][:passphrase_location]).read
          passphrase[-1] == "\n" ? passphrase.chop : passphrase
        rescue
          Chef::Log.error("Unable to connect to passphrase url: #{node[:databag_decrypt][:passphrase_location]}")
        end
      end
    end
  end
end
