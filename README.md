chef-campy-handler
==================

Simple campfire chef handler built on top fo campy gem http://fnichol.github.io/campy/

How to use
==================

Simplest way is to use it with [chef_handler](https://github.com/opscode-cookbooks/chef_handler)

If you have some kind of base role, then just add:

```ruby
include_recipe "chef_handler"
```
to the very top of your base role recipe 

then we need to upload our handler to the target machine, so chef-client could find and use it. I didn't really like the idea of putting my handler into chef_handler cookbook's files folder, since we treat community cookbooks as external not modifiable etries which are managed by bundler like tools for chef ( librarian-chef and like).

For that reason we put handler file (campfire.rb) to the base role files folder ( ex files/default/handlers/campfire.rb) and upload it using cookbook_file resource:

```ruby
cookbook_file "#{node['chef_handler']['handler_path']}/campfire.rb" do
  source "handlers/campfire.rb"
  mode 0755
  action :nothing
end.run_action(:create)
```

*If you are curious about action :nothing and run_action(:create) stuff - then you should check out this [link](http://docs.opscode.com/resource_common_compile.html)*

Next we install campy gem since we use it as campfire communtication library

```ruby
chef_gem('campy'){action :nothing}.run_action(:install)
```
*notice the use of chef_gem. This is important because we are going to utilize newly installed gem withing the same chef-client run. Usually you do it when other recipes have some dependencies which we need to install upfront (like our handler)*

Final step is to initialize handler with proper campfire credentials using chef_handler LWRP

```ruby
chef_handler 'Chef::Handler::Campfire' do
  action :enable
  arguments :subdomain => '', :token => '', :room_id => ''
  source "#{node['chef_handler']['handler_path']}/campfire.rb"
end
```

You need to find those 3 arguments on campfire site.

Thats about it!
