var EndTimer, root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

EndTimer = (function() {
  function EndTimer(endCallback, minutesDelay, now, secondsCallback) {
  var checkFunction, millisecondsDelay;
  if (!now) {
  now = new Date();
}
millisecondsDelay = minutesDelay * 60 * 1000;
this.endTime = new Date(now.getTime() + millisecondsDelay);
this.secondsCallback = secondsCallback;
checkFunction = ((function(_this) {
  return function() {
    var timeLeft;
  if (_this.secondsCallback) {
  timeLeft = _this.millisecondsLeft();
    _this.secondsCallback(timeLeft);
}
return _this.checkEndTimeReached();
};
})(this));
this.intervalId = setInterval(checkFunction, 1000);
this.endCallback = endCallback;
}

EndTimer.prototype.checkEndTimeReached = function() {
  var now;
now = new Date();
if (now >= this.endTime) {
  this.stopTimer();
  return this.triggerEnd();
}
};

EndTimer.prototype.stopTimer = function() {
return clearInterval(this.intervalId);
};

EndTimer.prototype.triggerEnd = function() {
return this.endCallback();
};

EndTimer.prototype.millisecondsLeft = function() {
return this.endTime - new Date();
};

return EndTimer;

})();

root.EndTimer = EndTimer;
