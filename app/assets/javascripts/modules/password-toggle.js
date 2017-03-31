'use strict';

moj.Modules.passwordToggle = {
  element_class: 'js-toggleable-password',
  link_class: 'js-toggle-password',

  init: function() {
    var self = this,
        $toggleablePasswords = $('.' + self.element_class);

    if($toggleablePasswords.length) {
      self.injectLinks($toggleablePasswords);
      self.bindEvents();
    }
  },

  bindEvents: function() {
    var self = this;

    $(document).on('click', '.' + self.link_class, function(e) {
      e.preventDefault();
      $('.' + self.link_class + ' .toggle').toggleClass('js-hidden');
      self.togglePassword($(e.target));
    });
  },

  injectLinks: function($els) {
    var self = this;

    $els.after('<p class="' + self.link_class + '"><span class="show toggle">Show</span><span class="hide toggle js-hidden">Hide</span> password</p>');
  },

  togglePassword: function($link) {
    var self = this,
        $el = $link.siblings('.' + self.element_class),
        elType = $el.attr('type'),
        newType = (elType === 'password' ? 'text' : 'password');

    $el.attr('type', newType);
  }
};
