#
# Installs jruby via RVM.
#

require_recipe "rvm"
require_recipe "java::default"

bash "install JRUBY in RVM" do
  user "root"
  code "rvm install jruby"
  not_if "rvm list | grep jruby"
end
