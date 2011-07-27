
#
# Compile from source as written up by Depesz in
#   http://www.depesz.com/index.php/2010/02/26/installing-postgresql/
#

# Install prereqs
case node[:platform]
when "arch"
  prereqs = %w{gcc python libxml2 tcl make}
when "centos"
  prereqs = %w{gcc readline-devel zlib-devel libxml2-devel tcl-devel python-devel}
when "debian"
  prereqs = %w{apt-get install bzip2 build-essential libreadline-dev zlib1g-dev libxml2-dev tcl-dev python-dev}
when "fedora"
  prereqs = %w{gcc perl-core readline-devel zlib-devel libxml2-devel tcl-devel python-devel}
when "ubuntu"
  prereqs = %w{ build-essential libreadline-dev zlib1g-dev libxml2-dev tcl-dev python-dev libperl-dev}
when "suse"
  prereqs = %w{zypper install gcc make readline-devel zlib-devel openssl-devel libxml2-devel tcl-devel python-devel}
else
  prereqs = %w{}
end

prereqs.each do |pkg|
  package pkg
end

# Create postgres DBA user
group "#{node[:postgres][:dba]}" do
  action :create
end

user "#{node[:postgres][:dba]}" do
  comment "System account for running PostgreSQL"
  gid "#{node[:postgres][:dba]}"
  home "#{node[:postgres][:basedir]}-#{node[:postgres][:version]}/home"
  shell "/bin/bash"
end

directory "#{node[:postgres][:basedir]}-#{node[:postgres][:version]}/home" do
  owner node[:postgres][:dba]
  mode "0750"
  recursive true
  action :create
end

template "#{node[:postgres][:basedir]}-#{node[:postgres][:version]}/home/.profile" do
  source "dot_profile.erb"
  owner node[:postgres][:dba]
  mode "0644"
  action :create
end

# Fetch postgres source
remote_file "/root/postgresql-#{node[:postgres][:version]}.tar.bz" do
  source "http://wwwmaster.postgresql.org/redir/198/h/source/v#{node[:postgres][:version]}/postgresql-#{node[:postgres][:version]}.tar.bz2"
  not_if { File.exists?("/root/postgresql-#{node[:postgres][:version]}.tar.bz2") or
    File.exists?("/root/postgresql-#{node[:postgres][:version]}") }
end

execute "untar postgres source" do
  cwd "/root"
  command %{tar xjf /root/postgresql-#{node[:postgres][:version]}.tar.bz}
  not_if { File.exists?("/root/postgresql-#{node[:postgres][:version]}") }  
end

# Configure and compile
template "/root/postgresql-#{node[:postgres][:version]}/my.configure.sh" do
  source "my.configure.erb"
  mode "0700"
end

# see http://www.postgresql.org/docs/9.0/interactive/install-procedure.html
bash "Compile Postgres" do
  cwd "/root/postgresql-#{node[:postgres][:version]}/"
  code <<-EOH
    ./my.configure.sh
    make world
    make install-world
    #cd contrib
    #make
    #make install
    #cd ..
  EOH
  not_if { File.exists?("#{node[:postgres][:basedir]}-#{node[:postgres][:version]}/bin/postgres") }
end

template "#{node[:postgres][:basedir]}-#{node[:postgres][:version]}/bin/pg-env.sh" do
  source "pg-env.sh.erb"
  owner node[:postgres][:dba]
  mode "0644"
  action :create
end
