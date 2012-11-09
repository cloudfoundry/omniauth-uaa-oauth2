#--
# Cloud Foundry 2012.02.03 Beta
# Copyright (c) [2009-2012] VMware, Inc. All Rights Reserved.
#
# This product is licensed to you under the Apache License, Version 2.0 (the "License").
# You may not use this product except in compliance with the License.
#
# This product includes a number of subcomponents with
# separate copyright notices and license terms. Your use of these
# subcomponents is subject to the terms and conditions of the
# subcomponent's license, as noted in the LICENSE file.
#++

require 'uaa'
require 'omniauth'
require 'timeout'
require 'securerandom'

module OmniAuth
  module Strategies
    class CloudFoundry
      include OmniAuth::Strategy

      args [:client_id, :client_secret]

      option :name, "cloudfoundry"
      option :auth_server_url, nil
      option :token_server_url, nil
      option :scope, nil
      option :async_calls, false

      attr_accessor :access_token

      def client
        options.token_server_url ||= options.auth_server_url
        token_issuer ||= CF::UAA::TokenIssuer.new(options.auth_server_url,
                                                   options.client_id,
                                                   options.client_secret,
                                                   options.token_server_url)
        log :info, "Client: #{options.client_id} auth_server: #{options.auth_server_url} token_server: #{options.token_server_url}"
        token_issuer.async = options.async_calls if EM && EM.reactor_running?
        token_issuer.logger = OmniAuth.logger
        token_issuer
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def request_phase
        authcode_uri = client.authcode_uri(callback_url, options.scope)
        log :info, "Redirect URI #{authcode_uri}"
        session['redir_uri'] = authcode_uri
        redirect authcode_uri
      end

      def authorize_params
        params = options.authorize_params.merge(options.authorize_options.inject({}){|h,k| h[k.to_sym] = options[k] if options[k]; h})
        if OmniAuth.config.test_mode
          @env ||= {}
          @env['rack.session'] ||= {}
        end
        params
      end

      def token_params
        options.token_params.merge(options.token_options.inject({}){|h,k| h[k.to_sym] = options[k] if options[k]; h})
      end

      def callback_phase
        self.access_token = build_access_token(request.query_string)
        self.access_token = refresh(access_token) if expired?(access_token)
        log :debug, "Got access token #{access_token.inspect}"

        super
      end

      credentials do
        {
          'token' => access_token.auth_header,
          'refresh_token' => access_token.info[:refresh_token],
          'authorized_scopes' => access_token.info[:scope]
        }
      end

      uid{ raw_info[:user_id] || raw_info[:email] }

      info do
        prune!({
          :name       => raw_info[:name],
          :email      => raw_info[:email],
          :first_name => raw_info[:given_name],
          :last_name  => raw_info[:family_name]
        })
      end

      extra do
        hash = {}
        hash[:raw_info] = raw_info unless skip_info?
        prune! hash
      end

      def raw_info
        @raw_info ||= CF::UAA::Misc.whoami(options.token_server_url, self.access_token.auth_header)
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def build_access_token(query_string)
        log :info, "Fetching access token"
        client.authcode_grant(session.delete('redir_uri'), query_string)
      end

      def refresh(access_token)
        log :info, "Refreshing access token"
        client.refresh_token_grant(access_token.info[:refresh_token])
      end

      def expired?(access_token)
        access_token = access_token.auth_header if access_token.respond_to? :auth_header
        expiry = CF::UAA::TokenCoder.decode(access_token.split()[1], nil, nil, false)[:expires_at]		
        expiry.is_a?(Integer) && expiry <= Time.now.to_i
      end
    end
  end
end
