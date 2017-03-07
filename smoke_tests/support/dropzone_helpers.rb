require 'securerandom'

Then(/^I drop "(.*?)"$/) do |filename|
	drop_in_dropzone("#{UPLOAD_EXAMPLES}/#{filename}")
end

# This handles both 'standard' checkboxes and the checkboxes on the
# documents_checklist page. I decided to put it here, instead of in
# `common.rb`, as the bulk of it relates to those checkboxes.
Then(/^I check "([^"]*)"$/) do |checkbox|
	case checkbox
  # Capybara is unable to target the checkboxes by label on the documents_checklist page. I *think* this is because they
  # are embedded in the label/form.
	when 'Original notice letter'
		page.execute_script "$('#steps_details_documents_checklist_form_original_notice_provided').prop('checked', true);"
	when 'Review conclusion letter'
		page.execute_script "$('#steps_details_documents_checklist_form_review_conclusion_provided').check('checked', true);"
	else
		check(checkbox)
	end
end

def drop_in_dropzone(file_path)
  # The fake input needs a unique css id for each instance, otherwise the
  # dropzone upload fails.
  id_diff = SecureRandom.uuid
  page.execute_script <<-JS
    fakeFileInput = window.$('<input/>').attr(
      {id: "fakeFileInput#{id_diff}", type:'file'}
    ).appendTo('body');
  JS
  attach_file("fakeFileInput#{id_diff}", file_path)
  page.execute_script("var fileList = [fakeFileInput.get(0).files[0]]")
  page.execute_script <<-JS
    var e = jQuery.Event('drop', { dataTransfer : { files : [fakeFileInput.get(0).files[0]] } });
    $('.dropzone')[0].dropzone.listeners[0].events.drop(e);
  JS
end
