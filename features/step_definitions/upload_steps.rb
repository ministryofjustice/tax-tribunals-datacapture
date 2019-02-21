UPLOAD_EXAMPLES = "#{File.dirname(__FILE__)}/../support/uploads"

# These are for 'standard' uploads. See `dropzone_helpers.rb` for steps and
# supporting code for use with dropzone-enabled uploads.
Then(/^I drop "(.*?)"$/) do |filename|
  puts UPLOAD_EXAMPLES
  support_documents_page.drop_in_dropzone("#{UPLOAD_EXAMPLES}/#{filename}")
  sleep(1)
end

Then(/^I attach a file explaining my grounds$/) do
  attach_file(
    'steps_details_grounds_for_appeal_form[grounds_for_appeal_document]',
    "#{UPLOAD_EXAMPLES}/grounds_for_appeal.docx"
  )
end

Then(/^I attach a file with a virus$/) do
  attach_file(
    'steps_details_grounds_for_appeal_form[grounds_for_appeal_document]',
    "#{UPLOAD_EXAMPLES}/eicar.com.txt"
  )
end
