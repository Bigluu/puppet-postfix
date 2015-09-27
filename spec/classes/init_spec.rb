require 'spec_helper'

describe 'postfix' do
  context 'supported operating systems' do
    ['Debian'].each do |osfamily|
      describe "postfix class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('postfix') }
        it { is_expected.to contain_class('postfix::params') }
        it { is_expected.to contain_class('postfix::install').that_comes_before('postfix::config') }
        it { is_expected.to contain_class('postfix::config') }
        it { is_expected.to contain_class('postfix::service').that_subscribes_to('postfix::config') }

        it { is_expected.to contain_service('postfix') }
        it { is_expected.to contain_package('postfix').with_ensure('installed') }


        it { is_expected.to contain_file('/etc/postfix/master.cf') }
        it { is_expected.to contain_file('/etc/postfix/main.cf') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'postfix class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('postfix') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
  context 'postfix specific parameters' do
    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistid => 'Ubuntu',
      :lsbdistcodename => 'trusty',
    }}
    describe 'postfix with mysql support' do
      let(:params) {{
        :use_mysql   => true,
        :db_host     => 'localhost',
        :db_name     => 'mydb',
        :db_user     => 'myuser',
        :db_password => 'mysecret_passw',
      }}
      it { is_expected.to contain_package('postfix-mysql').with_ensure('installed') }
      it { is_expected.to contain_file('/etc/postfix/mysql-virtual-alias-maps.cf') \
           .with_content(/^user = myuser$/)
           .with_content(/^hosts = localhost$/)
           .with_content(/^password = mysecret_passw$/)
           .with_content(/^dbname = mydb$/)
      }
      it { is_expected.to contain_file('/etc/postfix/mysql-virtual-mailbox-domains.cf') }
      it { is_expected.to contain_file('/etc/postfix/mysql-virtual-mailbox-maps.cf') }
    end
    describe 'postfix with custom main.cf settings' do
      let(:params) {{
        :main_settings => {
          'mydestination' => 'myhost.mydomain.com',
        }
      }}
      it { is_expected.to contain_file('/etc/postfix/main.cf') \
           .with_content(/^mydestination = myhost.mydomain.com$/)
      }
    end
    describe 'postfix with custom master.cf settings' do
      let(:params) {{
        :master_settings => {
          'myservice' => {
            'srv_type' => 'inet',
            'srv_private' => 'n',
            'srv_command' => 'myserviced',
          },
          'anotherservice' => {
            'srv_type' => 'unix',
            'srv_chroot' => 'n',
            'srv_command' => 'anotherserviced',
            'srv_arguments' => ['-o myvar=foo',],
          },
        }
      }}
      it { is_expected.to contain_file('/etc/postfix/master.cf') \
           .with_content(/^myservice inet n - - - - myserviced$/)
           .with_content(/^anotherservice unix - - n - - anotherserviced$/)
           .with_content(/^\s*-o myvar=foo$/)
      }
    end
  end
end
