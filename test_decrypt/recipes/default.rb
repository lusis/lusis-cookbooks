include_recipe "databag_decrypt::default"

password = search(:passwords, "id:svnpass").first

decrypted_password = item_decrypt(password[:data])
Chef::Log.info("Decrypted password is: #{decrypted_password}")
