FROM ministryofjustice/ruby:2.3.3-webapp-onbuild

ENV PUMA_PORT 3000

ENV DATABASE_URL                 replace_this_at_build_time
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

RUN touch /etc/inittab

# Prevent apt-get from failing to fetch updates for the removed jessie-updates suite
RUN echo "deb http://deb.debian.org/debian jessie main" > /etc/apt/sources.list
# Add alternative source which includes the removed debian-security suite
RUN echo "deb http://security.debian.org/debian-security jessie/updates main" > /etc/apt/sources.list.d/jessie-alt-repo.list

RUN apt-get update && apt-get install -y && apt-get install libcurl4-gnutls-dev -y

EXPOSE $PUMA_PORT

RUN bundle exec rake assets:precompile RAILS_ENV=production       SECRET_KEY_BASE=required_but_does_not_matter_for_assets

ENTRYPOINT ["./run.sh"]
