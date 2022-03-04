class Admin::GenerateGlimrRecordsComplete
  def on_complete(status, options)
    puts "Delivering summary mailer"
    @status = status
    AdminMailer.with(to: options[:to]).complete.deliver_now
  end
end