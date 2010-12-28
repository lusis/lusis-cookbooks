# Example usage

## Create a passwords databag with an item

	mkdir data_bags/passwords
	echo '{"id":"foopass","data":"myfoopassword"}' > data_bags/passwords/foopass.json

## Run the rake task to encrypt and upload the data
	rake encrypt_databag[foopass]

	Found item: foopass. Encrypting
	Encrypted data is bpVIN1zQ/3kmxF33xZV8fA==
	Uploading to Chef server
	INFO: Updated data_bag_item[foopass_crypted.json]

## Add the cookbooks to the run list

	knife node run_list add mynode "recipe[databag_decrypt]"
	knife node run_list add mynode "recipe[test_decrypt]"

## Create the default password file on the client

	echo 'I encrypt with this' > /tmp/decode.txt

## Check the results on the same client

	[Mon, 27 Dec 2010 22:56:47 -0500] INFO: Starting Chef Run (Version 0.9.12)
	[Mon, 27 Dec 2010 22:56:48 -0500] INFO: Storing updated cookbooks/test_decrypt/recipes/default.rb in the cache.
	[Mon, 27 Dec 2010 22:56:48 -0500] INFO: Reading passphrase from passfile: /tmp/decode.txt
	[Mon, 27 Dec 2010 22:56:48 -0500] INFO: Decrypted password is: myfoopassword
	[Mon, 27 Dec 2010 22:56:48 -0500] INFO: Chef Run complete in 1.399341 seconds
	[Mon, 27 Dec 2010 22:56:48 -0500] INFO: cleaning the checksum cache
	[Mon, 27 Dec 2010 22:56:48 -0500] INFO: Running report handlers
	[Mon, 27 Dec 2010 22:56:48 -0500] INFO: Report handlers complete

