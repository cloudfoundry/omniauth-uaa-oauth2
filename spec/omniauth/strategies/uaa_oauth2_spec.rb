require 'spec_helper'
require 'omniauth-uaa-oauth2'

describe OmniAuth::Strategies::Cloudfoundry do
  def app; lambda{|env| [200, {}, ["Hello."]]} end

  before :each do
    OmniAuth.config.test_mode = true
    @request = double('Request')
    @request.stub(:params) { {} }
    @request.stub(:cookies) { {} }
    @request.stub(:env) { {} }
  end

  after do
    OmniAuth.config.test_mode = false
  end

  subject do
    args = ['app', 'appclientsecret', @options || {}].compact
    OmniAuth::Strategies::Cloudfoundry.new(app, *args).tap do |strategy|
      strategy.stub(:request) { @request }
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      subject.callback_path.should eq('/auth/cloudfoundry/callback')
    end
  end

  describe 'set auth and token server' do
    it 'should set the right auth and token server' do
      @options = {:auth_server_url => 'https://login.cloudfoundry.com'}
      subject.client
      subject.auth_server_url.should eq('https://login.cloudfoundry.com')
      subject.token_server_url.should eq('https://login.cloudfoundry.com')
    end

    it 'should set the right auth and token server if independently set' do
      @options = {:auth_server_url => 'https://login.cloudfoundry.com', :token_server_url => 'https://uaa.cloudfoundry.com'}
      subject.client
      subject.auth_server_url.should eq('https://login.cloudfoundry.com')
      subject.token_server_url.should eq('https://uaa.cloudfoundry.com')
    end

    it 'should set the right auth and token server' do
      @options = {:auth_server_url => 'login.cloudfoundry.com'}
      subject.client
      subject.auth_server_url.should eq('https://login.cloudfoundry.com')
      subject.token_server_url.should eq('https://login.cloudfoundry.com')
    end
  end

  describe '#callback_phase' do
    context 'when the callback request contains an error message' do
      it 'makes a call to #fail! with the error and a CallbackError' do
        @request.stub(:params) do
          {
            'error'             => 'access_denied',
            'error_description' => 'User denied access',
            'state'             => 'some-state-value'
          }
        end

        subject.should_receive(:fail!).with('access_denied', instance_of(OmniAuth::Strategies::Cloudfoundry::CallbackError))
        subject.callback_phase
      end
    end
  end

  describe 'set scopes' do
    it 'should set the right scopes if requested' do
      @options = {:auth_server_url => 'https://login.cloudfoundry.com', :token_server_url => 'https://uaa.cloudfoundry.com', :scope => "openid cloud_controller.read"}
      subject.client
      subject.options[:scope].should eq("openid cloud_controller.read")
    end

    it 'should not set any scopes if not requested' do
      @options = {:auth_server_url => 'https://login.cloudfoundry.com', :token_server_url => 'https://uaa.cloudfoundry.com'}
      subject.client
      subject.options[:scope].should eq(nil)
    end
  end
end
