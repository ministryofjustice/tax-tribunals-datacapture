FROM ruby:3.2.2-alpine3.17

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
ENV TAX_TRIBUNALS_DOWNLOADER_URL replace_this_at_build_time
ENV SENTRY_DSN                   replace_this_at_build_time
ENV GOVUK_NOTIFY_API_KEY         replace_this_at_build_time
ENV GTM_TRACKING_ID              replace_this_at_build_time
ENV TAX_TRIBUNAL_EMAIL           replace_this_at_build_time
ENV ZENDESK_USERNAME             replace_this_at_build_time
ENV ZENDESK_TOKEN                replace_this_at_build_time
ENV  UPLOAD_PROBLEMS_REPORT_AUTH_USER                 replace_this_at_build_time
ENV  UPLOAD_PROBLEMS_REPORT_AUTH_DIGEST               replace_this_at_build_time
ENV  ADMIN_USERNAME                                   replace_this_at_build_time
ENV  ADMIN_PASSWORD                                   replace_this_at_build_time
ENV  NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID             replace_this_at_build_time
ENV  NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID         replace_this_at_build_time
ENV  NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID                replace_this_at_build_time
ENV  NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID               replace_this_at_build_time
ENV  NOTIFY_RESET_PASSWORD_TEMPLATE_ID                replace_this_at_build_time
ENV  NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID           replace_this_at_build_time
ENV  NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID            replace_this_at_build_time
ENV  NOTIFY_REPORT_PROBLEM_TEMPLATE_ID                replace_this_at_build_time
ENV  REPORT_PROBLEM_EMAIL_ADDRESS                     replace_this_at_build_time
ENV  NOTIFY_SEND_APPLICATION_DETAIL_TEMPLATE_ID       replace_this_at_build_time
ENV  NOTIFY_SEND_APPLICATION_DETAIL_TEXT_TEMPLATE_ID       replace_this_at_build_time
ENV  NOTIFY_CASE_CONFIRMATION_CY_TEMPLATE_ID          replace_this_at_build_time
ENV  NOTIFY_FTT_CASE_NOTIFICATION_CY_TEMPLATE_ID      replace_this_at_build_time
ENV  NOTIFY_NEW_CASE_SAVED_CY_TEMPLATE_ID             replace_this_at_build_time
ENV  NOTIFY_CHANGE_PASSWORD_CY_TEMPLATE_ID            replace_this_at_build_time
ENV  NOTIFY_RESET_PASSWORD_CY_TEMPLATE_ID             replace_this_at_build_time
ENV  NOTIFY_CASE_FIRST_REMINDER_CY_TEMPLATE_ID        replace_this_at_build_time
ENV  NOTIFY_CASE_LAST_REMINDER_CY_TEMPLATE_ID         replace_this_at_build_time
ENV  NOTIFY_REPORT_PROBLEM_CY_TEMPLATE_ID             replace_this_at_build_time
ENV  NOTIFY_SEND_APPLICATION_DETAIL_CY_TEMPLATE_ID    replace_this_at_build_time
ENV  NOTIFY_SEND_APPLICATION_DETAIL_CY_TEXT_TEMPLATE_ID       replace_this_at_build_time

# Chromium onwards is latest Chromium (100) package
# for Puppeteer for Grover
RUN apk --no-cache add --virtual build-deps \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  git \
  curl \
&& apk --no-cache add \
  postgresql-client \
  shared-mime-info \
  linux-headers \
  xz-libs \
  tzdata \
  nodejs \
  yarn \
  less \
  chromium \
  nss \
  freetype \
  harfbuzz \
  ca-certificates \
  ttf-freefont \
  clamav \
  clamav-daemon

RUN freshclam
RUN mkdir -p var/run/clamav && \
 chmod -R 777 /var/run/clamav && \
 mkdir -p var/log/clamav && \
 chmod -R 777 /var/log/clamav && \
 mkdir -p var/lib/clamav

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# ensure everything is executable
RUN chmod +x /usr/local/bin/*

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

RUN chown -R appuser:appgroup /var/lib/clamav /var/log/clamav /var/run/clamav /etc/clamav

ENV PUMA_PORT 8000
EXPOSE $PUMA_PORT

RUN mkdir -p /home/app
WORKDIR /home/app
COPY Gemfile* .ruby-version ./

RUN gem install bundler -v 2.3.15 && \
    bundle config set frozen 'true' && \
    bundle config without test:development && \
    bundle install

COPY . .

RUN yarn install --check-files

RUN bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=required_but_does_not_matter_for_assets

# Copy fonts and images (without digest) along with the digested ones,
# as there are some hardcoded references in the `govuk-frontend` files
# that will not be able to use the rails digest mechanism.
RUN cp node_modules/govuk-frontend/govuk/assets/fonts/*  public/assets/govuk-frontend/govuk/assets/fonts
RUN cp node_modules/govuk-frontend/govuk/assets/images/* public/assets/govuk-frontend/govuk/assets/images

## adding cron jobs
ADD daily-export /etc/periodic/daily

RUN chmod +x /etc/periodic/daily/*

## Set up sidekiq
COPY run_sidekiq.sh /home/app/run_sidekiq
RUN chmod +x /home/app/run_sidekiq

# running app as a service
ENV PHUSION true
COPY run.sh /home/app/run
RUN chmod +x /home/app/run
CMD ["./run"]