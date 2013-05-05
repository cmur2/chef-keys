
node['keys']['users'].each do |user,config|
  ssh_dir = "#{node['etc']['passwd'][user]['dir']}/.ssh"

  directory ssh_dir do
    owner user
    group user
    recursive true
  end

  config.each do |name, key|
    file "#{ssh_dir}/#{name}" do
      content key
      owner user
      group user
      mode name.match(/\.pub$/) ? 00644 : 00600
    end
  end
end
