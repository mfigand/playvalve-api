
# Solution Documentation

In order to maintain simplicity and focus, I prioritize streamlined and efficient coding practices. This means I only incorporate the essential elements necessary to fulfill the requirements of the challenge at hand.

This foundational architecture, while minimal, is designed with scalability in mind, permitting seamless extension and adaptation for increasingly complex scenarios in the future.

## Considerations

One of the Security Checks is to _Ban the user if the CF-IPCountry header value is not in the Redis country whitelist_. But it don't specify if the _Redis country whitelist_ should be populated with some country codes.

When the whitelist is empty the method `banned_country?` will always return `true`. If you want do add values to the whitelist you could do it like this `RedisService.add_to_whitelist(key: 'country_whitelist', value: 'ES')`.

As the requirements say _If VPNAPI check fails (rate limit, server error), consider the check as passed_ I have put the proper conditions to handle this, mocking the response in this cases. But I also leave the code commented as should be in a real scenario.

Regarding the _re-routing of logs to other data sources_, the `IntegrityLogger` sevice can write on an external log or database log. This can be configure in _config/initializers/logger_config.rb_.

Right now the external logger is a text file located in _log/integrity.log_ but in the future the IntegrityLogger could implement other external services for logging (like Sentry, Datadog, etc.), by calling the appropriate SDK or API within the `external_log` method.


# README

* Ruby version

- 3.2.2

* System dependencies

- docker-compose
- Rails 7
- Postgres
- Redis

* Boot the API

**With docker-compose**

- docker-compose build
- docker-compose up

* Configuration

- Environment variables seted in .env file

* Database creation

- docker-compose run api bundle exec rails db:create db:migrate

* Database initialization

- docker-compose run api bundle exec rails db:migrate

* How to run the test suite

- docker-compose run api bundle exec rspec
- check the coverage with `open coverage/index.html`

* How to run the linterns

- docker-compose run api bundle exec rubocop


