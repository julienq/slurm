(function (slurm) {
  "use strict";

  var A = Array.prototype;

  if (typeof Function.prototype.bind !== "function") {
    Function.prototype.bind = function (x) {
      var f = this;
      var args = A.slice.call(arguments, 1);
      return function () {
        return f.apply(x, args.concat(A.slice.call(arguments)));
      };
    };
    Function.prototype.bind.native = false;
  }

  // DOM

  // Known XML namespaces and their prefixes for use with create_element below.
  // For convenience both "html" and "xhtml" are defined as prefixes for XHTML.
  slurm.ns = {
    slurm: "http://slurm.romulusetrem.us",
    f: "http://slurm.romulusetrem.us/function",
    t: "http://slurm.romulusetrem.us/type",
    v: "http://slurm.romulusetrem.us/variable",
    html: "http://www.w3.org/1999/xhtml",
    svg: "http://www.w3.org/2000/svg",
    xhtml: "http://www.w3.org/1999/xhtml",
    xlink: "http://www.w3.org/1999/xlink",
    xml: "http://www.w3.org/1999/xml",
    xmlns: "http://www.w3.org/2000/xmlns/"
  };

  // Append a child node `ch` to `node`. If it is a string, create a text
  // node with the string as content; if it is an array, append all elements of
  // the array; if it is not a Node, then simply ignore it.
  slurm.append_child = function (node, ch) {
    if (typeof ch === "string") {
      node.appendChild(node.ownerDocument.createTextNode(ch));
    } else if (ch instanceof Array) {
      ch.forEach(function (ch_) {
        flexo.append_child(node, ch_);
      });
    } else if (ch instanceof window.Node) {
      node.appendChild(ch);
    }
  }

  // Simple way to create elements, giving ns, id and classes directly within
  // the name of the element (e.g. svg:rect#background.test) If id is defined,
  // it must follow the element name and precede the class names; in this
  // shorthand syntax, the id cannot contain a period. The second argument may
  // be an object giving the attribute definitions (including id and class, if
  // the shorthand syntax is not suitable) Beware of calling this function with
  // `this` set to the target document.
  slurm.create_element = function (name, attrs) {
    var contents;
    if (typeof attrs === "object" && !(attrs instanceof Node)) {
      contents = A.slice.call(arguments, 2);
    } else {
      contents = A.slice.call(arguments, 1);
      attrs = {};
    }
    var classes = name.trim().split(".");
    name = classes.shift();
    if (classes.length > 0) {
      attrs["class"] =
        (attrs.hasOwnProperty("class") ? attrs["class"] + " " : "")
        + classes.join(" ");
    }
    var m = name.match(/^(?:([^:]+):)?([^#]+)(?:#(.+))?$/);
    if (m) {
      var ns = (m[1] && slurm.ns[m[1].toLowerCase()]) ||
        this.documentElement.namespaceURI;
      var elem = ns ? this.createElementNS(ns, m[2]) : this.createElement(m[2]);
      if (m[3]) {
        attrs.id = m[3];
      }
      Object.keys(attrs).forEach(function (a) {
        if (attrs[a] !== null && attrs[a] !== undefined && attrs[a] !== false) {
          var sp = a.split(":");
          var ns = sp[1] && slurm.ns[sp[0].toLowerCase()];
          if (ns) {
            elem.setAttributeNS(ns, sp[1], attrs[a]);
          } else {
            elem.setAttribute(a, attrs[a]);
          }
        }
      });
      contents.forEach(function (ch) {
        slurm.append_child(elem, ch);
      });
      return elem;
    }
  };

  // Shorthand to create elements, e.g. slurm.$("svg#main.content")
  slurm.$ = function () {
    return slurm.create_element.apply(window.document, arguments);
  };

  // Shorthand to create a document fragment
  slurm.$$ = function () {
    var fragment = window.document.createDocumentFragment();
    A.forEach.call(arguments, function (ch) {
      slurm.append_child(fragment, ch);
    });
    return fragment;
  }

}(this.slurm = {}));
