#!/bin/bash
bundle check || bundle install

# bin/rake db:create
# bin/rake db:migrate

# -d, Daemonize process
# -L, path to writable logfile
# -C, path to YAML config file
# -e, Application environment
# -q, queues type order
# bundle exec sidekiq -d -q default -q mailers #-e production

sidekiq
