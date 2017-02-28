'use strict';

moj.Modules.customRadioToggles = {
  config: {
    toggleableClass: 'toggleable',
    $targetElement: null, // the element to be shown or to hide
    $showElements: [],    // collection of elements that triggers the showing of the target element
    $hideElements: []     // collection of elements that triggers the hiding of the target element
  },

  init: function () {
    var self = this;

    if($('.' + self.config.toggleableClass).length) {
      self.config.$targetElement = $('.' + self.config.toggleableClass).eq(0);
      self.config.$showElements = $(self.config.$targetElement.data('show-elements'));
      self.config.$hideElements = $(self.config.$targetElement.data('hide-elements'));

      this.hideElementUnlessRelevant();
      this.bindEvents();
    }
  },

  bindEvents: function () {
    var self = this;

    self.config.$showElements.each(function () {
      $(this).on('click', function () { self.showElement() });
    });

    self.config.$hideElements.each(function () {
      $(this).on('click', function () { self.hideElementUnlessRelevant() });
    });
  },

  showElement: function () {
    this.config.$targetElement.show();
  },

  hideElementUnlessRelevant: function () {
    if (this.config.$showElements.filter($(':checked')).length) { return }

    this.config.$targetElement.find('input').val('');
    this.config.$targetElement.hide();
  }
};
