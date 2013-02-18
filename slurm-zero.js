(function (slurm) {
  "use strict";

  slurm.parse = function (input) {
    var x = [], m;
    while (input.length > 0) {
      m = input.match(/^\s*(;[^\n])*/);
      if (m[0].length === 0) {
        if (m = input.match(/^\(/)) {
          var x_ = [];
          x.push(x_);
          x_.parent = x;
          x = x_;
        } else if (m = input.match(/^\)/)) {
          var p = x.parent;
          delete x.parent;
          x = p;
        } else if (m = input.match(/^"([^"]*)"/)) {
          x.push({ string: m[1] });
        } else if (m = input.match(/^[^\s;"\(\)]+/)) {
          var n = parseFloat(m[0]);
          x.push(isNaN(n) ? m[0] : n);
        }
      }
      input = input.substr(m[0].length);
    }
    return x && x.length === 1 && Array.isArray(x[0]) && x[0];
  };

}(typeof exports === "object" ? exports : this.slurm = {}));
