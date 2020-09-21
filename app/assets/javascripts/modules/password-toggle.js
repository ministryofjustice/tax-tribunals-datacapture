'use strict';

moj.Modules.passwordToggle = {
  password_element: 'input[name="user[password]"]',
  link_class: 'js-toggle-password',

  init: function() {
    var self = this,
        $toggleablePasswords = $(self.password_element);

    if($toggleablePasswords.length) {
      self.injectLinks($toggleablePasswords);
      self.bindEvents();
    }
  },

  bindEvents: function() {
    var self = this;

    $(document).on('click', '.' + self.link_class, function(e) {
      var $el = $(e.target),
          tag = $el.prop('tagName').toLowerCase();

      if(tag === 'a') {
        $el = $el.closest('p');
      }
      e.preventDefault();
      $el.find('.toggle').toggleClass('govuk-!-display-none');
      self.togglePassword($el);
    });
  },

  injectLinks: function($els) {
    var self = this;

    $els.after(
        '<p class="' + self.link_class + '">' +
        '<a href="#" class="show toggle govuk-link">' + moj.Modules.showPasswordText + '</a>' +
        '<a href="#" class="govuk-!-display-none hide toggle govuk-link">' + moj.Modules.hidePasswordText + '</a>' +
        '</p>'
    );
  },

  togglePassword: function($link) {
    var self = this,
        $el = $link.siblings(self.password_element),
        elType = $el.attr('type'),
        newType = (elType === 'password' ? 'text' : 'password');

    $el.attr('type', newType);
  }
};
