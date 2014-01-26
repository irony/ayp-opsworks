node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs application #{application} as it is not a node.js app")
    next
  end

  Chef::Log.debug("node[:nodeconfig]")
  Chef::Log.debug(node[:nodeconfig])
  Chef::Log.debug("node[:nodeconfig].to_json")
  Chef::Log.debug(node[:nodeconfig].to_json)

  template "#{deploy[:deploy_to]}/shared/node_modules/config/index.js" do
    cookbook 'opsworks_nodejs'
    source 'opsworks.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :config => node[:config].to_hash,
      :database => node[:mongodb],
      :memcached => deploy[:memcached],
      :layers => node[:opsworks][:layers],
      :logentriesToken => node[:logentries][node[:opsworks][:instance][:hostname]]
    )
  end
end
