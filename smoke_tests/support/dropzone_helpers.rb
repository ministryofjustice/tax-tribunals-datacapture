require 'securerandom'

Then(/^I drop "(.*?)"$/) do |filename|
  drop_in_dropzone("#{UPLOAD_EXAMPLES}/#{filename}")
  sleep(1)
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
