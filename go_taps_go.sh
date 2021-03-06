#!/usr/bin/env bash

set -e

curl `heroku pg:backups public-url` > heroku.dump
bundle exec rake db:drop && bundle exec rake db:create
pg_restore -d lula_dev heroku.dump
