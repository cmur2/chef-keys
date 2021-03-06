require 'chefspec'
begin require 'chefspec/deprecations'; rescue LoadError; end

describe 'keys::default' do
  let(:chef_runner) do
    cb_path = [Pathname.new(File.join(File.dirname(__FILE__), '..', '..')).cleanpath.to_s, 'spec/support/cookbooks']
    ChefSpec::ChefRunner.new(:cookbook_path => cb_path)
  end

  let(:chef_run) do
    chef_runner.converge 'keys::default'
  end
  
  it 'creates .ssh directory in home dir' do
    chef_runner.node.set['ssh_keys']['users'] = {
      'foo-0815' => {},
      'bar-0815' => {}
    }
    chef_runner.node.set['etc']['passwd']['foo-0815']['dir'] = '/home/foo'
    chef_runner.node.set['etc']['passwd']['bar-0815']['dir'] = '/not-in-home/bar'
    chef_run = chef_runner.converge 'keys::default'
    expect(chef_run).to create_directory '/home/foo/.ssh'
    expect(chef_run).to create_directory '/not-in-home/bar/.ssh'
  end

  it 'creates public keys' do
    chef_runner.node.set['ssh_keys']['users'] = {
      'foo-0815' => {
        'id_rsa.pub' => "ssh-rsa blub\n"
      }
    }
    chef_runner.node.set['etc']['passwd']['foo-0815']['dir'] = '/home/foo'
    chef_run = chef_runner.converge 'keys::default'
    expect(chef_run).to create_file_with_content '/home/foo/.ssh/id_rsa.pub', 'ssh-rsa'
  end
  
  it 'creates private keys' do
    chef_runner.node.set['ssh_keys']['users'] = {
      'foo-0815' => {
        'id_rsa' => "-----BEGIN RSA PRIVATE KEY-----\nblub\n"
      }
    }
    chef_runner.node.set['etc']['passwd']['foo-0815']['dir'] = '/home/foo'
    chef_run = chef_runner.converge 'keys::default'
    expect(chef_run).to create_file_with_content '/home/foo/.ssh/id_rsa', '-----BEGIN RSA PRIVATE KEY-----'
  end
end
