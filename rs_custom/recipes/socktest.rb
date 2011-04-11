
socktest_ports = node[:rs_custom][:socktest_ports]

template "/usr/lib/collectd/socktest.rb" do
  source "collectd_socktest_plugin.rb.erb"
  owner "root"
  group "root"
  mode "0755"
end

socktest_ports.each do |port|
  template "/etc/collectd/conf/socktest_#{port}.conf" do
    source "etc_collectd_conf_socktest.erb"
    variables :port => port
    owner "root"
    group "root"
    mode "0755"
  end
end
