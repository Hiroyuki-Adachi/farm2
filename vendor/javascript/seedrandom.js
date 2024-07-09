import t from"./lib/alea.js";import n from"./lib/xor4096.js";import"crypto";import e from"./seedrandom.js";var r="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var o={};var i={exports:o};(function(t,n,e){function XorGen(t){var n=this||r,e="";n.x=0;n.y=0;n.z=0;n.w=0;n.next=function(){var t=n.x^n.x<<11;n.x=n.y;n.y=n.z;n.z=n.w;return n.w^=n.w>>>19^t^t>>>8};t===(0|t)?n.x=t:e+=t;for(var o=0;o<e.length+64;o++){n.x^=0|e.charCodeAt(o);n.next()}}function copy(t,n){n.x=t.x;n.y=t.y;n.z=t.z;n.w=t.w;return n}function impl(t,n){var e=new XorGen(t),r=n&&n.state,prng=function(){return(e.next()>>>0)/4294967296};prng.double=function(){do{var t=e.next()>>>11,n=(e.next()>>>0)/4294967296,r=(t+n)/(1<<21)}while(0===r);return r};prng.int32=e.next;prng.quick=prng;if(r){"object"==typeof r&&copy(r,e);prng.state=function(){return copy(e,{})}}return prng}n&&n.exports?n.exports=impl:e&&e.amd?e((function(){return impl})):(this||r).xor128=impl})(o,i,false);var a=i.exports;var f="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var u={};var l={exports:u};(function(t,n,e){function XorGen(t){var n=this||f,e="";n.next=function(){var t=n.x^n.x>>>2;n.x=n.y;n.y=n.z;n.z=n.w;n.w=n.v;return(n.d=n.d+362437|0)+(n.v=n.v^n.v<<4^(t^t<<1))|0};n.x=0;n.y=0;n.z=0;n.w=0;n.v=0;t===(0|t)?n.x=t:e+=t;for(var r=0;r<e.length+64;r++){n.x^=0|e.charCodeAt(r);r==e.length&&(n.d=n.x<<10^n.x>>>4);n.next()}}function copy(t,n){n.x=t.x;n.y=t.y;n.z=t.z;n.w=t.w;n.v=t.v;n.d=t.d;return n}function impl(t,n){var e=new XorGen(t),r=n&&n.state,prng=function(){return(e.next()>>>0)/4294967296};prng.double=function(){do{var t=e.next()>>>11,n=(e.next()>>>0)/4294967296,r=(t+n)/(1<<21)}while(0===r);return r};prng.int32=e.next;prng.quick=prng;if(r){"object"==typeof r&&copy(r,e);prng.state=function(){return copy(e,{})}}return prng}n&&n.exports?n.exports=impl:e&&e.amd?e((function(){return impl})):(this||f).xorwow=impl})(u,l,false);var x=l.exports;var c="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var p={};var s={exports:p};(function(t,n,e){function XorGen(t){var n=this||c;n.next=function(){var t=n.x,e=n.i,r,o,i;r=t[e];r^=r>>>7;o=r^r<<24;r=t[e+1&7];o^=r^r>>>10;r=t[e+3&7];o^=r^r>>>3;r=t[e+4&7];o^=r^r<<7;r=t[e+7&7];r^=r<<13;o^=r^r<<9;t[e]=o;n.i=e+1&7;return o};function init(t,n){var e,r,o=[];if(n===(0|n))r=o[0]=n;else{n=""+n;for(e=0;e<n.length;++e)o[7&e]=o[7&e]<<15^n.charCodeAt(e)+o[e+1&7]<<13}while(o.length<8)o.push(0);for(e=0;e<8&&0===o[e];++e);r=8==e?o[7]=-1:o[e];t.x=o;t.i=0;for(e=256;e>0;--e)t.next()}init(n,t)}function copy(t,n){n.x=t.x.slice();n.i=t.i;return n}function impl(t,n){null==t&&(t=+new Date);var e=new XorGen(t),r=n&&n.state,prng=function(){return(e.next()>>>0)/4294967296};prng.double=function(){do{var t=e.next()>>>11,n=(e.next()>>>0)/4294967296,r=(t+n)/(1<<21)}while(0===r);return r};prng.int32=e.next;prng.quick=prng;if(r){r.x&&copy(r,e);prng.state=function(){return copy(e,{})}}return prng}n&&n.exports?n.exports=impl:e&&e.amd?e((function(){return impl})):(this||c).xorshift7=impl})(p,s,false);var v=s.exports;var d="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var h={};var y={exports:h};(function(t,n,e){function XorGen(t){var n=this||d,e="";n.next=function(){var t=n.b,e=n.c,r=n.d,o=n.a;t=t<<25^t>>>7^e;e=e-r|0;r=r<<24^r>>>8^o;o=o-t|0;n.b=t=t<<20^t>>>12^e;n.c=e=e-r|0;n.d=r<<16^e>>>16^o;return n.a=o-t|0};n.a=0;n.b=0;n.c=2654435769|0;n.d=1367130551;if(t===Math.floor(t)){n.a=t/4294967296|0;n.b=0|t}else e+=t;for(var r=0;r<e.length+20;r++){n.b^=0|e.charCodeAt(r);n.next()}}function copy(t,n){n.a=t.a;n.b=t.b;n.c=t.c;n.d=t.d;return n}function impl(t,n){var e=new XorGen(t),r=n&&n.state,prng=function(){return(e.next()>>>0)/4294967296};prng.double=function(){do{var t=e.next()>>>11,n=(e.next()>>>0)/4294967296,r=(t+n)/(1<<21)}while(0===r);return r};prng.int32=e.next;prng.quick=prng;if(r){"object"==typeof r&&copy(r,e);prng.state=function(){return copy(e,{})}}return prng}n&&n.exports?n.exports=impl:e&&e.amd?e((function(){return impl})):(this||d).tychei=impl})(h,y,false);var b=y.exports;var m={};var w=t;var g=a;var z=x;var G=v;var T=n;var X=b;var j=e;j.alea=w;j.xor128=g;j.xorwow=z;j.xorshift7=G;j.xor4096=T;j.tychei=X;m=j;var k=m;export default k;

