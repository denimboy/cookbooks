#
# Installs REE using RVM.  Makes REE default ruby
#

require_recipe "rvm"

bash "install REE in RVM" do
  user "root"
  code "rvm install ree"
  not_if "rvm list | grep ree"
end

bash "make REE the default ruby" do
  user "root"
  code "rvm --default ree"
end
