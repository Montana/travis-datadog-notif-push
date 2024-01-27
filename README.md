# travis-datadog-notif-push
Travis CI + Datadog notification push for Lockheed Martin using Chef via:

```yaml
   - eval "$(/opt/chefdk/bin/chef shell-init bash)"
   - chef gem install coveralls -v '0.8.19'
   - chef gem install json_spec -v '~> 1.1.4'
   - chef gem install chef-handler-datadog
```
Then of course all the complex things with env vars, etc etc. 
