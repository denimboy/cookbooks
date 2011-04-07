
#
# Configure default firewall.
#   Drop incoming, allow outgoing
#   Allow incoming SSH from everywhere
#

execute "ufw logging medium" do
  command %{ufw logging medium}
end

execute "ufw default deny incoming" do
  command %{ufw default deny incoming}
end

execute "ufw default allow outgoing" do
  command %{ufw default allow outgoing}
end

execute "ufw allow ssh" do
  command %{ufw allow proto tcp from any to any port 22}
end

execute "ufw enable" do
  command %{yes | ufw enable}
end
