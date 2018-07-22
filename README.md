Cloud Foundry UAA OmniAuth Strategy
==================================

OmniAuth strategy for authenticating users using the CloudFoundry UAA server.

Add the following to your `Gemfile`:

```text
gem 'omniauth-uaa-oauth2'
```

For example usage see:

* the `examples/config.ru` sample code
* https://github.com/starkandwayne/ultimate-guide-to-uaa-examples/tree/master/ruby/omniauth-login-only
* https://github.com/starkandwayne/ultimate-guide-to-uaa-examples/tree/master/ruby/omniauth-login-and-uaa-api-calls
* https://github.com/starkandwayne/ultimate-guide-to-uaa-examples/tree/master/ruby/resource-server-wrapper-ui

Warning: Unlike the `omniauth-oauth2` gem, this gem does not support the oauth2 'state' security parameter.

Your `omniauth-uaa-oauth2` client application will need a corresponding UAA client registered that includes the `authorization_code` authorization grant type, and redirect URIs back to the full URL to your application's `/auth/cloudfoundry/callback` endpoint. For example:

```text
uaa create-client omniauth-login-only -s omniauth-login-only \
  --authorized_grant_types authorization_code,refresh_token \
  --scope openid \
  --redirect_uri http://localhost:9292/auth/cloudfoundry/callback,http://127.0.0.1:9292/auth/cloudfoundry/callback
```