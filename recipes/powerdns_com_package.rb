version = node[:pdns][:powerdns_com_package][:version]

remote_file "#{Chef::Config[:file_cache_path]}/pdns-static_#{version}.deb" do
  source "http://downloads.powerdns.com/releases/deb/pdns-static_#{version}.deb"
  action :create_if_missing
end

dpkg_package 'pdns' do
  source "#{Chef::Config[:file_cache_path]}/pdns-static_#{version}.deb"
  options '--force-confdef'
end

template '/etc/powerdns/pdns.conf' do
  source 'pdns.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[pdns]'
end

service 'pdns' do
  action [ :enable, :start ]
end
