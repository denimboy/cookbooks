
#
# Compile from source as written up by Depesz in
#   http://www.depesz.com/index.php/2010/02/26/installing-postgresql/
#

case node[:platform]
when "arch"
  lis = %w{gcc python libxml2 tcl make}
when "centos"
  lis = %w{gcc readline-devel zlib-devel libxml2-devel tcl-devel python-devel}
when "debian"
  lis = %w{apt-get install bzip2 build-essential libreadline-dev zlib1g-dev libxml2-dev tcl-dev python-dev}
when "fedora"
  lis = %w{gcc perl-core readline-devel zlib-devel libxml2-devel tcl-devel python-devel}
when "ubuntu"
  lis = %w{ build-essential libreadline-dev zlib1g-dev libxml2-dev tcl-dev python-dev libperl-dev}
when "suse"
  lis = %w{zypper install gcc make readline-devel zlib-devel openssl-devel libxml2-devel tcl-devel python-devel}
else
  lis = %w{}
end

lis.each do |pkg|
  package pkg
end


group "pgdba" do
  action :create
end

user "pgdba" do
  comment "System account for running PostgreSQL"
  gid "pgdba"
  home "/home/pgdba"
  shell "/bin/bash"
end

#base = %{/tmp}
#dest = "#{base}/postgresql-8.4.2"
#tar = #{dest}.tar.bz2
remote_file "/tmp/postgresql-8.4.8.tar.bz" do
  source "http://wwwmaster.postgresql.org/redir/198/h/source/v8.4.8/postgresql-8.4.8.tar.bz2"
  not_if { File.exists?("/tmp/postgresql-8.4.8.tar.bz2") }
end

execute "untar" do
  cwd "/tmp"
  command %{tar xjf /tmp/postgresql-8.4.8.tar.bz}
#  not_if { File.exists?("/tmp/postgresql-8.4.8"}) }  
end

template "/tmp/postgresql-8.4.8/my.configure.sh" do
  source "my.configure.erb"
  mode "0700"
end

bash "Compile Postgres" do
  cwd "/tmp/postgresql-8.4.8/"
  code <<-EOH
    ./my.configure.sh
    make
    make install
    cd contrib
    make
    make install
    cd ..
  EOH
#  not_if { File.exists?("#{node[:postgresql][:install_path]}/bin/postgres") }
end


