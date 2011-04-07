
define :ufw_rule, :action => 'allow', :proto => 'tcp', :from => 'any', :to => 'any', "port" => 'any' do
  execute "modify ufw rule" do
    command %{ufw #{params[:action]} proto #{params[:proto]} from #{params[:from]} to #{params[:to]} port #{params[:port]}}
  end
  execute "ufw reload" do
    command "ufw reload"
  end
end
