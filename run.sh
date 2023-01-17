#!/bin/sh

PHUSION_SERVICE="${PHUSION:-false}"
case ${PHUSION_SERVICE} in
true)
      cd /home/app/
      case ${DOCKER_STATE} in
        migrate)
          echo "Running migrate"
          bundle exec rake db:migrate
          ;;
        create)
          echo "Running create"
          bundle exec rake db:create
          bundle exec rake db:migrate
          bundle exec rake db:seed
          ;;
      esac
    echo "running as service"
    bundle exec puma -p $PUMA_PORT
    ;;
*)
      case ${DOCKER_STATE} in
        migrate)
          echo "Running migrate"
          bundle exec rake db:migrate
          ;;
        create)
          echo "Running create"
          bundle exec rake db:create
          bundle exec rake db:migrate
          bundle exec rake db:seed
          ;;
      esac
    echo "normal startup"
    bundle exec puma -p $PUMA_PORT
    ;;

    sed -i 's/LocalSocketGroup clamav/LocalSocketGroup appgroup/g' /etc/clamav/clamd.conf
    clamd
esac
