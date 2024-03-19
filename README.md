
# Solution Documentation

In order to maintain simplicity and focus, I prioritize streamlined and efficient coding practices. This means I only incorporate the essential elements necessary to fulfill the requirements of the challenge at hand.

This foundational architecture, while minimal, is designed with scalability in mind, permitting seamless extension and adaptation for increasingly complex scenarios in the future.

## Considerations

One of the Security Checks is to _"Ban the user if the CF-IPCountry header value is not in the Redis country whitelist"_. But it don't specify if the __Redis country whitelist__ should be populated with some Country Codes.

When the whitelist is empty the method `banned_country?` will always return `true`, so the user will always be Ban. If you want avoid this behaviour you can add values to the whitelist like this `RedisService.add_to_whitelist(key: 'country_whitelist', value: 'ES')`. And to remove it from the whitelist use `RedisService.remove_from_whitelist(key: 'country_whitelist', value: 'ES')`.

As the requirements say _"If VPNAPI check fails (rate limit, server error), consider the check as passed"_, I have put the proper conditions to handle this, returning a mocked response in this cases. But I also leave the code commented as should be in a real scenario.

Regarding the _re-routing of logs to other data sources_, the `IntegrityLogger` sevice can write on an external log or database log. This can be configure in _config/initializers/logger_config.rb_.

Right now the external logger writes in a text file located in _log/integrity.log_, but in the future the `IntegrityLogger` could implement other external services for logging (like Sentry, Datadog, etc.), by calling the appropriate SDK or API within the `external_log` method.


# Boot the API

To facilitate the launch of the api I created a `Makefile` with all the necessary commands to interact with the app.

For booting the app enter:
- `make install`
- `make start`

To run the test suite:
- `make test`

To run the linterns:
- `make lint`

To see all the available commads enter:
- `make help`

To check the coverage (currently 100%):
- `open coverage/index.html`


# README

**Ruby version**

- 3.2.2

**System dependencies**

- docker-compose
- Rails 7
- Postgres
- Redis


