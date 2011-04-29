Description
===========
This cookbook is a minimal version of the full Noah cookbook. It only provides resources and providers for using Noah in your cookbooks

Requirements
============

Attributes
==========
* `path`
    Full URL to the resource in Noah
* `timeout`
    How long we wait before timing out
* `data` _(optional)_
    Should I actually look for some value or just if the path exists?
* `retry_interval`
    How long to wait between retries
* `on_failure`
    either `:retry` or `:pass`
    If there's a failure in communicating with Noah or the result does not exist, how should we proceed?

Usage
=====
Right now only the block resource is provided. I'm working on adding resources for application/service/configuration/host to the mix.

```ruby
noahlite_block "wait for dbmaster" do
  path            "http://localhost:5678/ephemerals/foo"
  timeout         600
  data            "someval1"
  retry_interval  5
  on_failure      :retry
end
```

In the following log output you can see the result of running the cookbook in the following scenario:

* Noah is offline
* Noah comes online but the data value is incorrect
* Data value is now correct
* We continue on

```
[Fri, 29 Apr 2011 14:01:24 -0400] DEBUG: Loading Recipe noahlite::test via include_recipe
[Fri, 29 Apr 2011 14:01:24 -0400] DEBUG: Found recipe test in cookbook noahlite
[Fri, 29 Apr 2011 14:01:24 -0400] DEBUG: loading from cookbook_path: /home/jvincent/development/chef-repo/solo-cookbooks
[Fri, 29 Apr 2011 14:01:24 -0400] DEBUG: Converging node jvincent-MacBookPro
[Fri, 29 Apr 2011 14:01:24 -0400] DEBUG: Processing noahlite_block[wait for dbmaster] on jvincent-MacBookPro
[Fri, 29 Apr 2011 14:01:24 -0400] INFO: Noah server unreachable. Retrying every 5 seconds
[Fri, 29 Apr 2011 14:01:29 -0400] INFO: Noah server unreachable. Retrying every 5 seconds
[Fri, 29 Apr 2011 14:01:34 -0400] INFO: Noah server unreachable. Retrying every 5 seconds
[Fri, 29 Apr 2011 14:01:39 -0400] INFO: Noah server unreachable. Retrying every 5 seconds
[Fri, 29 Apr 2011 14:01:44 -0400] DEBUG: Data returned does not match expected. Retrying in 5
[Fri, 29 Apr 2011 14:01:49 -0400] DEBUG: Data returned does not match expected. Retrying in 5
[Fri, 29 Apr 2011 14:01:54 -0400] DEBUG: Resource ready. Continuing
[Fri, 29 Apr 2011 14:01:54 -0400] DEBUG: Resource ready. Continuing
[Fri, 29 Apr 2011 14:01:54 -0400] DEBUG: Resource ready. Continuing
[Fri, 29 Apr 2011 14:01:54 -0400] DEBUG: Resource ready. Continuing
[Fri, 29 Apr 2011 14:01:54 -0400] INFO: Chef Run complete in 30.068499602 seconds
[Fri, 29 Apr 2011 14:01:54 -0400] INFO: cleaning the checksum cache
[Fri, 29 Apr 2011 14:01:54 -0400] INFO: Running report handlers
[Fri, 29 Apr 2011 14:01:54 -0400] INFO: Report handlers complete
[Fri, 29 Apr 2011 14:01:54 -0400] DEBUG: Exiting
```
