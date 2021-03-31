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
        isLowIE = $('html').hasClass('lte-ie9'),
        maxFilesize;

    Dropzone.autoDiscover = false;

    self.$form = $('#' + self.form_id);
    self.$fileList = $(self.uploaded_files);
    maxFilesize = parseInt(self.$form.data('max-filesize'))

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
      parallelUploads: 10,
      maxFilesize: maxFilesize,
      acceptedFiles: self.$form.data('accepted-files'),
      autoProcessQueue: true,
      addRemoveLinks: false,
      createImageThumbnails: false,
      previewTemplate: previewTemplate,
      uploadMultiple: false,
      forceFallback: false,
      headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},

      dictCancelUploadConfirmation: moj.t('moj.Modules.dropzoneStrings.confirmCancelUpload'),
      dictInvalidFileType: moj.t('moj.Modules.dropzoneStrings.invalidFileType'),
      dictFileTooBig: moj.t('moj.Modules.dropzoneStrings.fileTooBig').replace('XXX', maxFilesize),

      success: function (file, response) {
        self.removeDropzonePreview(file);
        self.addFileToList(response);
        self.fileGAEvent('upload');
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

    $(document).on('keydown', 'a.faux-link, .dz-clickable', function(e) {
      if(e.keyCode === 13 || e.keyCode === 32) { // pressed RETURN or SPACE
        e.preventDefault();
        self.$form.trigger('click');
      }
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

            self.fileGAEvent('delete');
          });
        }
      });
    }
  },

  addFileToList: function(file) {
    var self = this;

    self.$fileList.find('.no-files').hide();
    self.$fileList.append('<li class="file js-only">' + file.name + ' <a href="#" data-delete-name="'+file.encoded_name+'" class="govuk-button govuk-button--secondary">' + moj.t('moj.Modules.dropzoneStrings.docUploadRemoveFile') + '</a></li>');
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

  fileGAEvent: function(eventAction) {
    var eventData = {
      hitType: 'event',
      eventCategory: 'document upload',
      eventAction: eventAction,
      eventLabel: 'supporting document'
    };

    ga('send', eventData);
  }
};
