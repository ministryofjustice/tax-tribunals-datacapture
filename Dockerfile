FROM employmenttribunal.azurecr.io/ruby-nodejs-onbuild:2.6.6

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

# Application specific variables

ENV GLIMR_API_URL                replace_this_at_build_time
ENV EXTERNAL_URL                 replace_this_at_build_time
ENV PAYMENT_ENDPOINT             replace_this_at_build_time
ENV MOJ_FILE_UPLOADER_ENDPOINT   replace_this_at_build_time
ENV TAX_TRIBUNALS_DOWNLOADER_URL replace_this_at_build_time
ENV SENTRY_DSN                   replace_this_at_build_time
ENV GOVUK_NOTIFY_API_KEY         replace_this_at_build_time
ENV GTM_TRACKING_ID              replace_this_at_build_time
ENV TAX_TRIBUNAL_EMAIL           replace_this_at_build_time
ENV ZENDESK_USERNAME             replace_this_at_build_time
ENV ZENDESK_TOKEN                replace_this_at_build_time
ENV UPLOAD_PROBLEMS_REPORT_AUTH_USER            replace_this_at_build_time
ENV UPLOAD_PROBLEMS_REPORT_AUTH_DIGEST          replace_this_at_build_time
ENV NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID        replace_this_at_build_time
ENV NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID    replace_this_at_build_time
ENV NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID      replace_this_at_build_time
ENV NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID       replace_this_at_build_time
ENV NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID           replace_this_at_build_time
ENV NOTIFY_RESET_PASSWORD_TEMPLATE_ID           replace_this_at_build_time
ENV NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID          replace_this_at_build_time

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# fix to address http://tzinfo.github.io/datasourcenotfound - PET ONLY
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && \
    apt-get install -qy yarn tzdata libcurl4-gnutls-dev libxrender-dev libfontconfig libxext6 libjpeg-turbo8 shared-mime-info --no-install-recommends && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -fr *Release* *Sources* *Packages* && \
    truncate -s 0 /var/log/*log

ENV PUMA_PORT 8000
EXPOSE $PUMA_PORT

COPY yarn.lock ./

RUN bash -c "yarn install --check-files"

RUN bash -c "bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=required_but_does_not_matter_for_assets"

# Copy fonts and images (without digest) along with the digested ones,
# as there are some hardcoded references in the `govuk-frontend` files
# that will not be able to use the rails digest mechanism.
RUN cp node_modules/govuk-frontend/govuk/assets/fonts/*  public/assets/govuk-frontend/govuk/assets/fonts
RUN cp node_modules/govuk-frontend/govuk/assets/images/* public/assets/govuk-frontend/govuk/assets/images

# adding daily export cron job
ADD daily-export /etc/cron.d/

# running app as a servive
ENV PHUSION true
RUN mkdir /etc/service/app
COPY run.sh /etc/service/app/run
RUN chmod +x /etc/service/app/run