"use strict";

moj.Modules.sessionTimeout = {
  config: {
    // The modal container to show/hide when session timeout is approaching
    $modalContainer: "#timeout-dialog",
    // The element that contains the amount of time remaining shown to the user
    $remainingElement: "#timeout-dialog-remaining",
    // The length of time until a session expires (converts minutes to ms)
    sessionLength: moj.Modules.sessionLength * 60 * 1000,
    // Show the modal when there is this much time left (converts minutes to ms)
    sessionWarnWhenRemaining: moj.Modules.sessionWarnWhenRemaining * 60 * 1000,
    // URLs
    pingUrl: '/session/ping',
    destroySessionUrl: '/session',
    expiredUrl: '/errors/invalid_session',
    abortedUrl: '/',
    // i18n for minutes/seconds/expired
    inString: "in",
    secondsSingularString: "second",
    secondsPluralString: "seconds",
    minutesSingularString: "minute",
    minutesPluralString: "minutes",
    expiredString: "now"
  },

  // The time at which the session expires, (re-)set in startTimer()
  endOfSessionTime: null,

  // The timeout timer when the session expires, (re-)set in startTimer()
  endOfSessionTimeoutTimer: null,

  // The last focused element before the modal is shown
  lastFocus: null,

  init: function() {
    var self = this;

    // Return if there is no container (the container is only shown if there is an active session)
    if(!$(self.config.$modalContainer).length) return;

    // Do not initialise if the timeout variables haven't been set properly
    if(isNaN(moj.Modules.sessionLength) || isNaN(moj.Modules.sessionWarnWhenRemaining)) return;

    // Bind buttons in modal
    $(self.config.$modalContainer + " .extend").click(function() {
      self.extend();
    });
    $(self.config.$modalContainer + " .abort").click(function() {
      self.abort();
    });

    // Set the initial timeout
    self.startTimer();
  },

  showModal: function() {
    this.lastFocus = document.activeElement;
    $(this.config.$modalContainer).show();
    $(this.config.$modalContainer).find("button.extend").focus();
  },

  hideModal: function() {
    $(this.config.$modalContainer).hide();
    this.lastFocus.focus();
  },

  startTimer: function() {
    var self = this;
    
    var now = new Date();
    self.endOfSessionTime = new Date(now.getTime() + self.config.sessionLength);

    // Set the timeout for showing the modal dialog
    var warnAfter = self.config.sessionLength - self.config.sessionWarnWhenRemaining;
    setTimeout(function() { self.showModal(); }, warnAfter);

    // Cancel and reset the timeout for forcing session expiry
    clearTimeout(self.endOfSessionTimeoutTimer);
    self.endOfSessionTimeoutTimer = setTimeout(function() { self.forceAbort(); }, self.config.sessionLength);

    // Update remaining time every half second so we avoid "jumping" over seconds
    setInterval(function() { self.updateTimeRemaining(); }, 500);
  },

  updateTimeRemaining: function() {
    var now = new Date();
    var remainingString = this.timeString(this.endOfSessionTime - now);

    $(this.config.$remainingElement).html(remainingString);
  },

  timeString: function(timeDifference) {
    var diffSeconds = Math.floor(timeDifference / 1000);

    if(diffSeconds <= 0) return this.config.expiredString;

    if(diffSeconds > 60) {
      var diffMinutes = Math.round(diffSeconds / 60);
      var word = diffMinutes === 1 ? this.config.minutesSingularString : this.config.minutesPluralString;
      return this.config.inString + " " + diffMinutes + " " + word;
    } else {
      var word = diffSeconds === 1 ? this.config.secondsSingularString : this.config.secondsPluralString;
      return this.config.inString + " " + diffSeconds + " " + word;
    }
  },

  extend: function() {
    var self = this;

    $.get(self.config.pingUrl).done(function() {
      // Queue up another warning for when the session is due to expire again
      self.startTimer();
    }).fail(function() {
      // Assume session has expired if we cannot ping
      window.location.href = self.config.expiredUrl; 
    });

    self.hideModal();
  },

  abort: function() {
    var self = this;

    $.ajax({
      url: this.config.destroySessionUrl,
      type: "DELETE",
      dataType: "json"
    }).done(function() {
      window.location.href = self.config.abortedUrl;
    }).fail(function() {
      window.location.href = self.config.expiredUrl;
    });
  },

  forceAbort: function() {
    var self = this;

    $.ajax({
      url: this.config.destroySessionUrl,
      type: "DELETE",
      dataType: "json"
    }).always(function() {
      window.location.href = self.config.expiredUrl;
    });
  }
};
