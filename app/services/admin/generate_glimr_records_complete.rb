class Admin::GenerateGlimrRecordsComplete
  def on_complete(status, options)
    Rails.logger.info "Delivering summary mailer, to: #{options['to']}, status: #{status.total} total, #{status.failures} failures"
    NotifyMailer.glimr_batch_complete(options['to'], status).deliver_now
  end
end