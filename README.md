CloudFoundry UAA OmniAuth Strategy
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


Warning: Unlike the omniauth-oauth2 gem, this gem does not support the oauth2 'state' security parameter.
