# SnippetMan

An app to manage private gists

## Dependencies

`Ruby 2.5.1`

`Rails ~> 5.2.1`

## Getting started

run 

```
bundle install
```

Register for a new application to get client id and secret at [here](https://github.com/settings/applications/new)

create a .env file in project root and add the values provided. See example in [env](./.env.example)

### To run application in development

```
bin/rails s
```

### To run application in production

Compile assets
```
bin/rake assets:precompile
```

Ensure tests are passing
```
bin/rails test
```

Start server
```
bin/rails s -e production
```

Note: This project has set the static assets to be served from within the project and hence the following setting
```
config.public_file_server.enabled = true
```
in [`/config/environments/production.rb`](/config/environments/production.rb)

This setting will probably change for deployment and serving assets from another CDN or webservers like Apache or NGINX and will require additional configurations.

