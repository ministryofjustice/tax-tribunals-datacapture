class AdminMailer < ApplicationMailer

  def complete
    mail(from: 'noreply@appeal-tax-tribunal.service.gov.uk' 
         to: params[:to],
         subject: "GLiMR Record Generation Complete")
  end

end
