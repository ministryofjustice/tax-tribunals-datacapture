class Admin::GenerateGlimrRecordsComplete
  def on_complete(status, options)
    puts "Delivering summary mailer, to: #{options['to']}, status: #{status}"
    AdminMailer
      .with(to: options['to'], status: status)
      .complete.deliver_now
  end
end