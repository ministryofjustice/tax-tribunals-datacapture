FROM employmenttribunal.azurecr.io/ruby25-nodejs-onbuild:0.3

# Adding argument support for ping.json
ARG APP_VERSION=unknown
ARG APP_BUILD_DATE=unknown
ARG APP_GIT_COMMIT=unknown
ARG APP_BUILD_TAG=unknown

# Setting up ping.json variables
ENV APP_VERSION ${APP_VERSION}
ENV APP_BUILD_DATE ${APP_BUILD_DATE}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

# fix to address http://tzinfo.github.io/datasourcenotfound - PET ONLY
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && \
    apt-get install -qy tzdata libcurl4-gnutls-dev --no-install-recommends && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -fr *Release* *Sources* *Packages* && \
    truncate -s 0 /var/log/*log

ENV PUMA_PORT 8000
EXPOSE $PUMA_PORT

RUN bash -c "bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=required_but_does_not_matter_for_assets"

# running app as a servive
ENV PHUSION true
RUN mkdir /etc/service/app
COPY run.sh /etc/service/app/run
RUN chmod +x /etc/service/app/run

