class AdminMailer < ApplicationMailer

  def complete
    @status = params[:status]
    puts "In mailer, status: #{@status}"
    puts "Total: #{@status.total}"
    puts "Failures: #{@status.failures}"

    mail(from: 'noreply@appeal-tax-tribunal.service.gov.uk',
         to: params[:to],
         subject: "GLiMR Record Generation Complete")
  end

end
