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

    if (!self.$form.length) {
      return;
    }
    if(isLowIE) {
      $('.js-only').remove();
      $('.no-js-only').removeClass('no-js-only');
      return;
    }

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
      },

      renameFilename: function (filename) {
        return self.uniqueFilename(filename);
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
    self.$fileList.append('<li class="file js-only">'
      + file.name + ' <a href="#" data-name="'+file.name+'" data-delete-name="'+file.encoded_name+'">Remove</a></li>'
    );
  },

  removeDropzonePreview: function(file) {
    var self = this;

    $(file.previewElement).fadeOut(200, function() {
      $(file.previewElement).remove();
      if(!self.$form.find('.dz-preview').length) {
        self.$form.removeClass('dz-started dz-drag-hover');
      }
    });
  },

  uniqueFilename: function(filename) {
    var self = this;
    var fileList = self.$fileList.find('li.js-only a').map(function() {
      return $(this).data('name');
    });

    while ($.inArray(filename, fileList) !== -1) {
      // A duplicate uploaded filename (case-sensitive) was found
      filename = self.appendToFilename(filename, '(1)');
    }

    return filename;
  },

  appendToFilename: function(filename, string) {
    var dotIndex = filename.lastIndexOf('.');

    if (dotIndex !== -1) {
      return filename.substring(0, dotIndex) + string + filename.substring(dotIndex);
    }

    return filename + string;
  }
};
