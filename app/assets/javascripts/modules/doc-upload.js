'use strict';

moj.Modules.docUpload = {
  form_id: 'dz_doc_upload',
  uploaded_files: '.uploaded-files',
  preview_template: '.dz-file-preview',
  $form: null,
  $fileList: null,

  init: function() {
    var self = this,
        previewTemplate,
        dzOptions,
        isLowIE = $('html').hasClass('lte-ie9');

    Dropzone.autoDiscover = false;

    self.$form = $('#' + self.form_id);
    self.$fileList = $(self.uploaded_files);

    if (!self.$form.length || isLowIE) { return; }

    // Hide the non-js uploader and show the dropzone one
    $('.show-when-js-is-loaded').removeClass('js-hidden');
    $('.hide-when-js-is-loaded').addClass('js-hidden');

    previewTemplate = $(self.preview_template).remove()[0].outerHTML;

    dzOptions = {
      url: '/uploader/supporting_documents/documents',
      paramName: 'document',
      maxFilesize: parseInt(self.$form.data('max-filesize')),
      acceptedFiles: self.$form.data('accepted-files'),
      autoProcessQueue: true,
      addRemoveLinks: true,
      createImageThumbnails: false,
      previewTemplate: previewTemplate,
      dictRemoveFile: 'Remove',
      uploadMultiple: false,
      forceFallback: false,
      headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},

      success: function (file, response) {
        self.removeDropzonePreview(file);
        self.addFileToList(response);
      }
    };

    self.$form.dropzone(dzOptions);

    self.bindEvents();
  },

  bindEvents: function() {
    var self = this;

    $(document).on('click', 'li.file a', function(e) {
      e.preventDefault();
      self.removeFileFromList(e.target);
    });
  },

  removeFileFromList: function(link) {
    var self = this,
        name = $(link).data('delete-name'),
        $el = $(link).closest('li');

    if (name) {
      $.ajax({
        type: 'DELETE',
        url: '/uploader/supporting_documents/documents/' + name,
        contentType: 'application/json',
        dataType: 'json',

        success: function(data) {
          $el.fadeOut(400, function() {
            $el.remove();

            if(!self.$fileList.find('.file').length) {
              self.$fileList.find('.no-files').show();
            }
          });
        }
      });
    }
  },

  addFileToList: function(file) {
    var self = this;

    self.$fileList.find('.no-files').hide();
    self.$fileList.append('<li class="file">' + file.name + ' <a href="#" data-delete-name="'+file.encoded_name+'">Remove</a></li>');
  },

  removeDropzonePreview: function(file) {
    var self = this;

    $(file.previewElement).fadeOut(200, function() {
      $(file.previewElement).remove();
      if(!self.$form.find('.dz-preview').length) {
        self.$form.removeClass('dz-started dz-drag-hover');
      }
    });
  }
};
