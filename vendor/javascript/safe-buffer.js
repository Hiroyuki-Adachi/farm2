import r from"buffer";var e={};var f=r;var o=f.Buffer;function copyProps(r,e){for(var f in r)e[f]=r[f]}if(o.from&&o.alloc&&o.allocUnsafe&&o.allocUnsafeSlow)e=f;else{copyProps(f,e);e.Buffer=SafeBuffer}function SafeBuffer(r,e,f){return o(r,e,f)}SafeBuffer.prototype=Object.create(o.prototype);copyProps(o,SafeBuffer);SafeBuffer.from=function(r,e,f){if("number"===typeof r)throw new TypeError("Argument must not be a number");return o(r,e,f)};SafeBuffer.alloc=function(r,e,f){if("number"!==typeof r)throw new TypeError("Argument must be a number");var u=o(r);void 0!==e?"string"===typeof f?u.fill(e,f):u.fill(e):u.fill(0);return u};SafeBuffer.allocUnsafe=function(r){if("number"!==typeof r)throw new TypeError("Argument must be a number");return o(r)};SafeBuffer.allocUnsafeSlow=function(r){if("number"!==typeof r)throw new TypeError("Argument must be a number");return f.SlowBuffer(r)};var u=e;const n=e.Buffer;export default u;export{n as Buffer};

