'use strict';

/**
 * IE non-JS enabled browsers requires the letter checkboxes to be inside the form.
 * This module will move (when JS is enabled) the checkboxes above the dropzone area,
 * and a polyfill will make them work with IE browsers.
 */

moj.Modules.docUploadCheckboxes = {
  element_class: '.supplied_letters_checkboxes',
  containerId: '#supplied_letters_placeholder',

  init: function () {
    var cbElement = $(this.element_class),
        container = $(this.containerId),
        $form;

    if (cbElement.length && container.length) {

      $form = $(cbElement).eq(0).closest('form');
      container.replaceWith(cbElement);

      $form.on('submit', function(e) {
        e.preventDefault();
        cbElement.clone().hide().prependTo($form);
        $form.unbind('submit');
        $form.trigger('submit');
      });
    }
  }
};
