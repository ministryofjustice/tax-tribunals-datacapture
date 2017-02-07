'use strict';

moj.Modules.docUpload = {
  form_id: 'dz_doc_upload',
  uploaded_files: '.uploaded-files',
  preview_template: '.dz-file-preview',
  $form: null,
  $fileList: null,

  config: {
    maxFilesize: null,
    acceptedFiles: null
  },

  init: function() {
    var self = this,
        previewTemplate,
        dzOptions;

    Dropzone.autoDiscover = false;

    self.$form = $('#' + self.form_id);
    self.$fileList = $(self.uploaded_files);

    if (!self.$form.length) { return; }

    previewTemplate = $(self.preview_template).remove()[0].outerHTML;

    dzOptions = {
      url: '/documents',
      paramName: 'document',
      maxFilesize: parseInt(self.config.maxFilesize),
      acceptedFiles: self.config.acceptedFiles,
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
        url: '/documents/' + name,
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
