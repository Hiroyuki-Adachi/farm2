var e={};function propagate(e,t,n){if(arguments.length<3){n=t;t=e;e=void 0}const r="object"===typeof e;e&&!r&&(e=[e]);if(r)return explicitPropagate(e,t,n);const shouldPropagate=t=>void 0===e||e.includes(t);const i=t.emit;t.emit=(e,...r)=>{const o=i.call(t,e,...r);let c=false;shouldPropagate(e)&&(c=n.emit(e,...r));return o||c};function end(){t.emit=i}return{end:end}}e=propagate;function explicitPropagate(e,t,n){let r;let i;if(Array.isArray(e)){r=e;i=e}else{r=Object.keys(e);i=r.map((function(t){return e[t]}))}const o=i.map((function(e){return function(){const t=Array.prototype.slice.call(arguments);t.unshift(e);n.emit.apply(n,t)}}));o.forEach(register);return{end:end};function register(e,n){t.on(r[n],e)}function unregister(e,n){t.removeListener(r[n],e)}function end(){o.forEach(unregister)}}var t=e;export default t;

