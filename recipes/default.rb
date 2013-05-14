
node['ssh_keys']['users'].each do |user,config|
  if node['etc']['passwd'][user]
    ssh_dir = "#{node['etc']['passwd'][user]['dir']}/.ssh"
  else
    ssh_dir = config['ssh_dir']
  end

  directory ssh_dir do
    owner user
    group user
    recursive true
  end

  config.reject { |k,v| k == 'ssh_dir' }.each do |name, key|
    file "#{ssh_dir}/#{name}" do
      content key
      owner user
      group user
      mode name.match(/\.pub$/) ? 00644 : 00600
    end
  end
end
