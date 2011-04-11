
recipe "rs_custom::socktest", "Setup port monitoring via collectd"

attribute "rs_customn/socktest_ports",
  :display_name => "Socktest Ports",
  :description => "Determine which ports the socktest collectd monitor plugin will monitor.",
  :required => "optional",
  :recipes => [ "rs_custom::socktest", ]
