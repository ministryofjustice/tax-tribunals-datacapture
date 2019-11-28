FROM employmenttribunal.azurecr.io/ruby25-onbuild:0.4

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


# fix to address http://tzinfo.github.io/datasourcenotfound - PET ONLY
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && \
    apt-get install -qy tzdata libcurl4-gnutls-dev libxrender-dev libfontconfig --no-install-recommends && apt-get clean && \
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

