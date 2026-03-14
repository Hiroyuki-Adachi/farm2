import{Color as t}from"@kurkle/color";function e(){}const n=(()=>{let t=0;return()=>t++})();
/**
 * Returns true if `value` is neither null nor undefined, else returns false.
 * @param value - The value to test.
 * @since 2.7.0
 */function o(t){return t===null||t===void 0}
/**
 * Returns true if `value` is an array (including typed arrays), else returns false.
 * @param value - The value to test.
 * @function
 */function r(t){if(Array.isArray&&Array.isArray(t))return true;const e=Object.prototype.toString.call(t);return e.slice(0,7)==="[object"&&e.slice(-6)==="Array]"}
/**
 * Returns true if `value` is an object (excluding null), else returns false.
 * @param value - The value to test.
 * @since 2.7.0
 */function s(t){return t!==null&&Object.prototype.toString.call(t)==="[object Object]"}
/**
 * Returns true if `value` is a finite number, else returns false
 * @param value  - The value to test.
 */function i(t){return(typeof t==="number"||t instanceof Number)&&isFinite(+t)}
/**
 * Returns `value` if finite, else returns `defaultValue`.
 * @param value - The value to return if defined.
 * @param defaultValue - The value to return if `value` is not finite.
 */function a(t,e){return i(t)?t:e}
/**
 * Returns `value` if defined, else returns `defaultValue`.
 * @param value - The value to return if defined.
 * @param defaultValue - The value to return if `value` is undefined.
 */function c(t,e){return typeof t==="undefined"?e:t}const l=(t,e)=>typeof t==="string"&&t.endsWith("%")?parseFloat(t)/100:+t/e;const u=(t,e)=>typeof t==="string"&&t.endsWith("%")?parseFloat(t)/100*e:+t
/**
 * Calls `fn` with the given `args` in the scope defined by `thisArg` and returns the
 * value returned by `fn`. If `fn` is not a function, this method returns undefined.
 * @param fn - The function to call.
 * @param args - The arguments with which `fn` should be called.
 * @param [thisArg] - The value of `this` provided for the call to `fn`.
 */;function f(t,e,n){if(t&&typeof t.call==="function")return t.apply(n,e)}function h(t,e,n,o){let i,a,c;if(r(t)){a=t.length;if(o)for(i=a-1;i>=0;i--)e.call(n,t[i],i);else for(i=0;i<a;i++)e.call(n,t[i],i)}else if(s(t)){c=Object.keys(t);a=c.length;for(i=0;i<a;i++)e.call(n,t[c[i]],c[i])}}
/**
 * Returns true if the `a0` and `a1` arrays have the same content, else returns false.
 * @param a0 - The array to compare
 * @param a1 - The array to compare
 * @private
 */function d(t,e){let n,o,r,s;if(!t||!e||t.length!==e.length)return false;for(n=0,o=t.length;n<o;++n){r=t[n];s=e[n];if(r.datasetIndex!==s.datasetIndex||r.index!==s.index)return false}return true}
/**
 * Returns a deep copy of `source` without keeping references on objects and arrays.
 * @param source - The value to clone.
 */function p(t){if(r(t))return t.map(p);if(s(t)){const e=Object.create(null);const n=Object.keys(t);const o=n.length;let r=0;for(;r<o;++r)e[n[r]]=p(t[n[r]]);return e}return t}function g(t){return["__proto__","prototype","constructor"].indexOf(t)===-1}function b(t,e,n,o){if(!g(t))return;const r=e[t];const i=n[t];s(r)&&s(i)?y(r,i,o):e[t]=p(i)}function y(t,e,n){const o=r(e)?e:[e];const i=o.length;if(!s(t))return t;n=n||{};const a=n.merger||b;let c;for(let e=0;e<i;++e){c=o[e];if(!s(c))continue;const r=Object.keys(c);for(let e=0,o=r.length;e<o;++e)a(r[e],t,c,n)}return t}function x(t,e){return y(t,e,{merger:m})}function m(t,e,n){if(!g(t))return;const o=e[t];const r=n[t];s(o)&&s(r)?x(o,r):Object.prototype.hasOwnProperty.call(e,t)||(e[t]=p(r))}function w(t,e,n,o){e!==void 0&&console.warn(t+': "'+n+'" is deprecated. Please use "'+o+'" instead')}const v={"":t=>t,x:t=>t.x,y:t=>t.y};function M(t){const e=t.split(".");const n=[];let o="";for(const t of e){o+=t;if(o.endsWith("\\"))o=o.slice(0,-1)+".";else{n.push(o);o=""}}return n}function k(t){const e=M(t);return t=>{for(const n of e){if(n==="")break;t=t&&t[n]}return t}}function _(t,e){const n=v[e]||(v[e]=k(e));return n(t)}function O(t){return t.charAt(0).toUpperCase()+t.slice(1)}const P=t=>typeof t!=="undefined";const T=t=>typeof t==="function";const S=(t,e)=>{if(t.size!==e.size)return false;for(const n of t)if(!e.has(n))return false;return true};
/**
 * @param e - The event
 * @private
 */function C(t){return t.type==="mouseup"||t.type==="click"||t.type==="contextmenu"}const I=Math.PI;const j=2*I;const R=j+I;const W=Number.POSITIVE_INFINITY;const A=I/180;const B=I/2;const D=I/4;const N=I*2/3;const L=Math.log10;const z=Math.sign;function E(t,e,n){return Math.abs(t-e)<n}function H(t){const e=Math.round(t);t=E(t,e,t/1e3)?e:t;const n=Math.pow(10,Math.floor(L(t)));const o=t/n;const r=o<=1?1:o<=2?2:o<=5?5:10;return r*n}function F(t){const e=[];const n=Math.sqrt(t);let o;for(o=1;o<n;o++)if(t%o===0){e.push(o);e.push(t/o)}n===(n|0)&&e.push(n);e.sort(((t,e)=>t-e)).pop();return e}function Q(t){return typeof t==="symbol"||typeof t==="object"&&t!==null&&!(Symbol.toPrimitive in t||"toString"in t||"valueOf"in t)}function q(t){return!Q(t)&&!isNaN(parseFloat(t))&&isFinite(t)}function $(t,e){const n=Math.round(t);return n-e<=t&&n+e>=t}function K(t,e,n){let o,r,s;for(o=0,r=t.length;o<r;o++){s=t[o][n];if(!isNaN(s)){e.min=Math.min(e.min,s);e.max=Math.max(e.max,s)}}}function V(t){return t*(I/180)}function G(t){return t*(180/I)}
/**
 * Returns the number of decimal places
 * i.e. the number of digits after the decimal point, of the value of this Number.
 * @param x - A number.
 * @returns The number of decimal places.
 * @private
 */function J(t){if(!i(t))return;let e=1;let n=0;while(Math.round(t*e)/e!==t){e*=10;n++}return n}function Y(t,e){const n=e.x-t.x;const o=e.y-t.y;const r=Math.sqrt(n*n+o*o);let s=Math.atan2(o,n);s<-.5*I&&(s+=j);return{angle:s,distance:r}}function U(t,e){return Math.sqrt(Math.pow(e.x-t.x,2)+Math.pow(e.y-t.y,2))}function X(t,e){return(t-e+R)%j-I}function Z(t){return(t%j+j)%j}function tt(t,e,n,o){const r=Z(t);const s=Z(e);const i=Z(n);const a=Z(s-r);const c=Z(i-r);const l=Z(r-s);const u=Z(r-i);return r===s||r===i||o&&s===i||a>c&&l<u}
/**
 * Limit `value` between `min` and `max`
 * @param value
 * @param min
 * @param max
 * @private
 */function et(t,e,n){return Math.max(e,Math.min(n,t))}
/**
 * @param {number} value
 * @private
 */function nt(t){return et(t,-32768,32767)}
/**
 * @param value
 * @param start
 * @param end
 * @param [epsilon]
 * @private
 */function ot(t,e,n,o=1e-6){return t>=Math.min(e,n)-o&&t<=Math.max(e,n)+o}function rt(t,e,n){n=n||(n=>t[n]<e);let o=t.length-1;let r=0;let s;while(o-r>1){s=r+o>>1;n(s)?r=s:o=s}return{lo:r,hi:o}}
/**
 * Binary search
 * @param table - the table search. must be sorted!
 * @param key - property name for the value in each entry
 * @param value - value to find
 * @param last - lookup last index
 * @private
 */const st=(t,e,n,o)=>rt(t,n,o?o=>{const r=t[o][e];return r<n||r===n&&t[o+1][e]===n}:o=>t[o][e]<n)
/**
 * Reverse binary search
 * @param table - the table search. must be sorted!
 * @param key - property name for the value in each entry
 * @param value - value to find
 * @private
 */;const it=(t,e,n)=>rt(t,n,(o=>t[o][e]>=n))
/**
 * Return subset of `values` between `min` and `max` inclusive.
 * Values are assumed to be in sorted order.
 * @param values - sorted array of values
 * @param min - min value
 * @param max - max value
 */;function at(t,e,n){let o=0;let r=t.length;while(o<r&&t[o]<e)o++;while(r>o&&t[r-1]>n)r--;return o>0||r<t.length?t.slice(o,r):t}const ct=["push","pop","shift","splice","unshift"];function lt(t,e){if(t._chartjs)t._chartjs.listeners.push(e);else{Object.defineProperty(t,"_chartjs",{configurable:true,enumerable:false,value:{listeners:[e]}});ct.forEach((e=>{const n="_onData"+O(e);const o=t[e];Object.defineProperty(t,e,{configurable:true,enumerable:false,value(...e){const r=o.apply(this,e);t._chartjs.listeners.forEach((t=>{typeof t[n]==="function"&&t[n](...e)}));return r}})}))}}function ut(t,e){const n=t._chartjs;if(!n)return;const o=n.listeners;const r=o.indexOf(e);r!==-1&&o.splice(r,1);if(!(o.length>0)){ct.forEach((e=>{delete t[e]}));delete t._chartjs}}
/**
 * @param items
 */function ft(t){const e=new Set(t);return e.size===t.length?t:Array.from(e)}function ht(t,e,n){return e+" "+t+"px "+n}const dt=function(){return typeof window==="undefined"?function(t){return t()}:window.requestAnimationFrame}();function pt(t,e){let n=[];let o=false;return function(...r){n=r;if(!o){o=true;dt.call(window,(()=>{o=false;t.apply(e,n)}))}}}function gt(t,e){let n;return function(...o){if(e){clearTimeout(n);n=setTimeout(t,e,o)}else t.apply(this,o);return e}}const bt=t=>t==="start"?"left":t==="end"?"right":"center";const yt=(t,e,n)=>t==="start"?e:t==="end"?n:(e+n)/2;const xt=(t,e,n,o)=>{const r=o?"left":"right";return t===r?n:t==="center"?(e+n)/2:e};function mt(t,e,n){const r=e.length;let s=0;let i=r;if(t._sorted){const{iScale:a,vScale:c,_parsed:l}=t;const u=t.dataset&&t.dataset.options?t.dataset.options.spanGaps:null;const f=a.axis;const{min:h,max:d,minDefined:p,maxDefined:g}=a.getUserBounds();if(p){s=Math.min(st(l,f,h).lo,n?r:st(e,f,a.getPixelForValue(h)).lo);if(u){const t=l.slice(0,s+1).reverse().findIndex((t=>!o(t[c.axis])));s-=Math.max(0,t)}s=et(s,0,r-1)}if(g){let t=Math.max(st(l,a.axis,d,true).hi+1,n?0:st(e,f,a.getPixelForValue(d),true).hi+1);if(u){const e=l.slice(t-1).findIndex((t=>!o(t[c.axis])));t+=Math.max(0,e)}i=et(t,s,r)-s}else i=r-s}return{start:s,count:i}}
/**
 * Checks if the scale ranges have changed.
 * @param {object} meta - dataset meta.
 * @returns {boolean}
 * @private
 */function wt(t){const{xScale:e,yScale:n,_scaleRanges:o}=t;const r={xmin:e.min,xmax:e.max,ymin:n.min,ymax:n.max};if(!o){t._scaleRanges=r;return true}const s=o.xmin!==e.min||o.xmax!==e.max||o.ymin!==n.min||o.ymax!==n.max;Object.assign(o,r);return s}const vt=t=>t===0||t===1;const Mt=(t,e,n)=>-Math.pow(2,10*(t-=1))*Math.sin((t-e)*j/n);const kt=(t,e,n)=>Math.pow(2,-10*t)*Math.sin((t-e)*j/n)+1;const _t={linear:t=>t,easeInQuad:t=>t*t,easeOutQuad:t=>-t*(t-2),easeInOutQuad:t=>(t/=.5)<1?.5*t*t:-.5*(--t*(t-2)-1),easeInCubic:t=>t*t*t,easeOutCubic:t=>(t-=1)*t*t+1,easeInOutCubic:t=>(t/=.5)<1?.5*t*t*t:.5*((t-=2)*t*t+2),easeInQuart:t=>t*t*t*t,easeOutQuart:t=>-((t-=1)*t*t*t-1),easeInOutQuart:t=>(t/=.5)<1?.5*t*t*t*t:-.5*((t-=2)*t*t*t-2),easeInQuint:t=>t*t*t*t*t,easeOutQuint:t=>(t-=1)*t*t*t*t+1,easeInOutQuint:t=>(t/=.5)<1?.5*t*t*t*t*t:.5*((t-=2)*t*t*t*t+2),easeInSine:t=>1-Math.cos(t*B),easeOutSine:t=>Math.sin(t*B),easeInOutSine:t=>-.5*(Math.cos(I*t)-1),easeInExpo:t=>t===0?0:Math.pow(2,10*(t-1)),easeOutExpo:t=>t===1?1:1-Math.pow(2,-10*t),easeInOutExpo:t=>vt(t)?t:t<.5?.5*Math.pow(2,10*(t*2-1)):.5*(2-Math.pow(2,-10*(t*2-1))),easeInCirc:t=>t>=1?t:-(Math.sqrt(1-t*t)-1),easeOutCirc:t=>Math.sqrt(1-(t-=1)*t),easeInOutCirc:t=>(t/=.5)<1?-.5*(Math.sqrt(1-t*t)-1):.5*(Math.sqrt(1-(t-=2)*t)+1),easeInElastic:t=>vt(t)?t:Mt(t,.075,.3),easeOutElastic:t=>vt(t)?t:kt(t,.075,.3),easeInOutElastic(t){const e=.1125;const n=.45;return vt(t)?t:t<.5?.5*Mt(t*2,e,n):.5+.5*kt(t*2-1,e,n)},easeInBack(t){const e=1.70158;return t*t*((e+1)*t-e)},easeOutBack(t){const e=1.70158;return(t-=1)*t*((e+1)*t+e)+1},easeInOutBack(t){let e=1.70158;return(t/=.5)<1?t*t*((1+(e*=1.525))*t-e)*.5:.5*((t-=2)*t*((1+(e*=1.525))*t+e)+2)},easeInBounce:t=>1-_t.easeOutBounce(1-t),easeOutBounce(t){const e=7.5625;const n=2.75;return t<1/n?e*t*t:t<2/n?e*(t-=1.5/n)*t+.75:t<2.5/n?e*(t-=2.25/n)*t+.9375:e*(t-=2.625/n)*t+.984375},easeInOutBounce:t=>t<.5?_t.easeInBounce(t*2)*.5:_t.easeOutBounce(t*2-1)*.5+.5};function Ot(t){if(t&&typeof t==="object"){const e=t.toString();return e==="[object CanvasPattern]"||e==="[object CanvasGradient]"}return false}function Pt(e){return Ot(e)?e:new t(e)}function Tt(e){return Ot(e)?e:new t(e).saturate(.5).darken(.1).hexString()}const St=["x","y","borderWidth","radius","tension"];const Ct=["color","borderColor","backgroundColor"];function It(t){t.set("animation",{delay:void 0,duration:1e3,easing:"easeOutQuart",fn:void 0,from:void 0,loop:void 0,to:void 0,type:void 0});t.describe("animation",{_fallback:false,_indexable:false,_scriptable:t=>t!=="onProgress"&&t!=="onComplete"&&t!=="fn"});t.set("animations",{colors:{type:"color",properties:Ct},numbers:{type:"number",properties:St}});t.describe("animations",{_fallback:"animation"});t.set("transitions",{active:{animation:{duration:400}},resize:{animation:{duration:0}},show:{animations:{colors:{from:"transparent"},visible:{type:"boolean",duration:0}}},hide:{animations:{colors:{to:"transparent"},visible:{type:"boolean",easing:"linear",fn:t=>t|0}}}})}function jt(t){t.set("layout",{autoPadding:true,padding:{top:0,right:0,bottom:0,left:0}})}const Rt=new Map;function Wt(t,e){e=e||{};const n=t+JSON.stringify(e);let o=Rt.get(n);if(!o){o=new Intl.NumberFormat(t,e);Rt.set(n,o)}return o}function At(t,e,n){return Wt(e,n).format(t)}const Bt={values(t){return r(t)?t:""+t},numeric(t,e,n){if(t===0)return"0";const o=this.chart.options.locale;let r;let s=t;if(n.length>1){const e=Math.max(Math.abs(n[0].value),Math.abs(n[n.length-1].value));(e<1e-4||e>1e15)&&(r="scientific");s=Dt(t,n)}const i=L(Math.abs(s));const a=isNaN(i)?1:Math.max(Math.min(-1*Math.floor(i),20),0);const c={notation:r,minimumFractionDigits:a,maximumFractionDigits:a};Object.assign(c,this.options.ticks.format);return At(t,o,c)},logarithmic(t,e,n){if(t===0)return"0";const o=n[e].significand||t/Math.pow(10,Math.floor(L(t)));return[1,2,3,5,10,15].includes(o)||e>.8*n.length?Bt.numeric.call(this,t,e,n):""}};function Dt(t,e){let n=e.length>3?e[2].value-e[1].value:e[1].value-e[0].value;Math.abs(n)>=1&&t!==Math.floor(t)&&(n=t-Math.floor(t));return n}var Nt={formatters:Bt};function Lt(t){t.set("scale",{display:true,offset:false,reverse:false,beginAtZero:false,bounds:"ticks",clip:true,grace:0,grid:{display:true,lineWidth:1,drawOnChartArea:true,drawTicks:true,tickLength:8,tickWidth:(t,e)=>e.lineWidth,tickColor:(t,e)=>e.color,offset:false},border:{display:true,dash:[],dashOffset:0,width:1},title:{display:false,text:"",padding:{top:4,bottom:4}},ticks:{minRotation:0,maxRotation:50,mirror:false,textStrokeWidth:0,textStrokeColor:"",padding:3,display:true,autoSkip:true,autoSkipPadding:3,labelOffset:0,callback:Nt.formatters.values,minor:{},major:{},align:"center",crossAlign:"near",showLabelBackdrop:false,backdropColor:"rgba(255, 255, 255, 0.75)",backdropPadding:2}});t.route("scale.ticks","color","","color");t.route("scale.grid","color","","borderColor");t.route("scale.border","color","","borderColor");t.route("scale.title","color","","color");t.describe("scale",{_fallback:false,_scriptable:t=>!t.startsWith("before")&&!t.startsWith("after")&&t!=="callback"&&t!=="parser",_indexable:t=>t!=="borderDash"&&t!=="tickBorderDash"&&t!=="dash"});t.describe("scales",{_fallback:"scale"});t.describe("scale.ticks",{_scriptable:t=>t!=="backdropPadding"&&t!=="callback",_indexable:t=>t!=="backdropPadding"})}const zt=Object.create(null);const Et=Object.create(null);function Ht(t,e){if(!e)return t;const n=e.split(".");for(let e=0,o=n.length;e<o;++e){const o=n[e];t=t[o]||(t[o]=Object.create(null))}return t}function Ft(t,e,n){return typeof e==="string"?y(Ht(t,e),n):y(Ht(t,""),e)}class Defaults{constructor(t,e){this.animation=void 0;this.backgroundColor="rgba(0,0,0,0.1)";this.borderColor="rgba(0,0,0,0.1)";this.color="#666";this.datasets={};this.devicePixelRatio=t=>t.chart.platform.getDevicePixelRatio();this.elements={};this.events=["mousemove","mouseout","click","touchstart","touchmove"];this.font={family:"'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",size:12,style:"normal",lineHeight:1.2,weight:null};this.hover={};this.hoverBackgroundColor=(t,e)=>Tt(e.backgroundColor);this.hoverBorderColor=(t,e)=>Tt(e.borderColor);this.hoverColor=(t,e)=>Tt(e.color);this.indexAxis="x";this.interaction={mode:"nearest",intersect:true,includeInvisible:false};this.maintainAspectRatio=true;this.onHover=null;this.onClick=null;this.parsing=true;this.plugins={};this.responsive=true;this.scale=void 0;this.scales={};this.showLine=true;this.drawActiveElementsOnTop=true;this.describe(t);this.apply(e)}set(t,e){return Ft(this,t,e)}get(t){return Ht(this,t)}describe(t,e){return Ft(Et,t,e)}override(t,e){return Ft(zt,t,e)}route(t,e,n,o){const r=Ht(this,t);const i=Ht(this,n);const a="_"+e;Object.defineProperties(r,{[a]:{value:r[e],writable:true},[e]:{enumerable:true,get(){const t=this[a];const e=i[o];return s(t)?Object.assign({},e,t):c(t,e)},set(t){this[a]=t}}})}apply(t){t.forEach((t=>t(this)))}}var Qt=new Defaults({_scriptable:t=>!t.startsWith("on"),_indexable:t=>t!=="events",hover:{_fallback:"interaction"},interaction:{_scriptable:false,_indexable:false}},[It,jt,Lt]);
/**
 * Converts the given font object into a CSS font string.
 * @param font - A font object.
 * @return The CSS font string. See https://developer.mozilla.org/en-US/docs/Web/CSS/font
 * @private
 */function qt(t){return!t||o(t.size)||o(t.family)?null:(t.style?t.style+" ":"")+(t.weight?t.weight+" ":"")+t.size+"px "+t.family}function $t(t,e,n,o,r){let s=e[r];if(!s){s=e[r]=t.measureText(r).width;n.push(r)}s>o&&(o=s);return o}function Kt(t,e,n,o){o=o||{};let s=o.data=o.data||{};let i=o.garbageCollect=o.garbageCollect||[];if(o.font!==e){s=o.data={};i=o.garbageCollect=[];o.font=e}t.save();t.font=e;let a=0;const c=n.length;let l,u,f,h,d;for(l=0;l<c;l++){h=n[l];if(h===void 0||h===null||r(h)){if(r(h))for(u=0,f=h.length;u<f;u++){d=h[u];d===void 0||d===null||r(d)||(a=$t(t,s,i,a,d))}}else a=$t(t,s,i,a,h)}t.restore();const p=i.length/2;if(p>n.length){for(l=0;l<p;l++)delete s[i[l]];i.splice(0,p)}return a}
/**
 * Returns the aligned pixel value to avoid anti-aliasing blur
 * @param chart - The chart instance.
 * @param pixel - A pixel value.
 * @param width - The width of the element.
 * @returns The aligned pixel value.
 * @private
 */function Vt(t,e,n){const o=t.currentDevicePixelRatio;const r=n!==0?Math.max(n/2,.5):0;return Math.round((e-r)*o)/o+r}function Gt(t,e){if(e||t){e=e||t.getContext("2d");e.save();e.resetTransform();e.clearRect(0,0,t.width,t.height);e.restore()}}function Jt(t,e,n,o){Yt(t,e,n,o,null)}function Yt(t,e,n,o,r){let s,i,a,c,l,u,f,h;const d=e.pointStyle;const p=e.rotation;const g=e.radius;let b=(p||0)*A;if(d&&typeof d==="object"){s=d.toString();if(s==="[object HTMLImageElement]"||s==="[object HTMLCanvasElement]"){t.save();t.translate(n,o);t.rotate(b);t.drawImage(d,-d.width/2,-d.height/2,d.width,d.height);t.restore();return}}if(!(isNaN(g)||g<=0)){t.beginPath();switch(d){default:r?t.ellipse(n,o,r/2,g,0,0,j):t.arc(n,o,g,0,j);t.closePath();break;case"triangle":u=r?r/2:g;t.moveTo(n+Math.sin(b)*u,o-Math.cos(b)*g);b+=N;t.lineTo(n+Math.sin(b)*u,o-Math.cos(b)*g);b+=N;t.lineTo(n+Math.sin(b)*u,o-Math.cos(b)*g);t.closePath();break;case"rectRounded":l=g*.516;c=g-l;i=Math.cos(b+D)*c;f=Math.cos(b+D)*(r?r/2-l:c);a=Math.sin(b+D)*c;h=Math.sin(b+D)*(r?r/2-l:c);t.arc(n-f,o-a,l,b-I,b-B);t.arc(n+h,o-i,l,b-B,b);t.arc(n+f,o+a,l,b,b+B);t.arc(n-h,o+i,l,b+B,b+I);t.closePath();break;case"rect":if(!p){c=Math.SQRT1_2*g;u=r?r/2:c;t.rect(n-u,o-c,2*u,2*c);break}b+=D;case"rectRot":f=Math.cos(b)*(r?r/2:g);i=Math.cos(b)*g;a=Math.sin(b)*g;h=Math.sin(b)*(r?r/2:g);t.moveTo(n-f,o-a);t.lineTo(n+h,o-i);t.lineTo(n+f,o+a);t.lineTo(n-h,o+i);t.closePath();break;case"crossRot":b+=D;case"cross":f=Math.cos(b)*(r?r/2:g);i=Math.cos(b)*g;a=Math.sin(b)*g;h=Math.sin(b)*(r?r/2:g);t.moveTo(n-f,o-a);t.lineTo(n+f,o+a);t.moveTo(n+h,o-i);t.lineTo(n-h,o+i);break;case"star":f=Math.cos(b)*(r?r/2:g);i=Math.cos(b)*g;a=Math.sin(b)*g;h=Math.sin(b)*(r?r/2:g);t.moveTo(n-f,o-a);t.lineTo(n+f,o+a);t.moveTo(n+h,o-i);t.lineTo(n-h,o+i);b+=D;f=Math.cos(b)*(r?r/2:g);i=Math.cos(b)*g;a=Math.sin(b)*g;h=Math.sin(b)*(r?r/2:g);t.moveTo(n-f,o-a);t.lineTo(n+f,o+a);t.moveTo(n+h,o-i);t.lineTo(n-h,o+i);break;case"line":i=r?r/2:Math.cos(b)*g;a=Math.sin(b)*g;t.moveTo(n-i,o-a);t.lineTo(n+i,o+a);break;case"dash":t.moveTo(n,o);t.lineTo(n+Math.cos(b)*(r?r/2:g),o+Math.sin(b)*g);break;case false:t.closePath();break}t.fill();e.borderWidth>0&&t.stroke()}}
/**
 * Returns true if the point is inside the rectangle
 * @param point - The point to test
 * @param area - The rectangle
 * @param margin - allowed margin
 * @private
 */function Ut(t,e,n){n=n||.5;return!e||t&&t.x>e.left-n&&t.x<e.right+n&&t.y>e.top-n&&t.y<e.bottom+n}function Xt(t,e){t.save();t.beginPath();t.rect(e.left,e.top,e.right-e.left,e.bottom-e.top);t.clip()}function Zt(t){t.restore()}function te(t,e,n,o,r){if(!e)return t.lineTo(n.x,n.y);if(r==="middle"){const o=(e.x+n.x)/2;t.lineTo(o,e.y);t.lineTo(o,n.y)}else r==="after"!==!!o?t.lineTo(e.x,n.y):t.lineTo(n.x,e.y);t.lineTo(n.x,n.y)}function ee(t,e,n,o){if(!e)return t.lineTo(n.x,n.y);t.bezierCurveTo(o?e.cp1x:e.cp2x,o?e.cp1y:e.cp2y,o?n.cp2x:n.cp1x,o?n.cp2y:n.cp1y,n.x,n.y)}function ne(t,e){e.translation&&t.translate(e.translation[0],e.translation[1]);o(e.rotation)||t.rotate(e.rotation);e.color&&(t.fillStyle=e.color);e.textAlign&&(t.textAlign=e.textAlign);e.textBaseline&&(t.textBaseline=e.textBaseline)}function oe(t,e,n,o,r){if(r.strikethrough||r.underline){const s=t.measureText(o);const i=e-s.actualBoundingBoxLeft;const a=e+s.actualBoundingBoxRight;const c=n-s.actualBoundingBoxAscent;const l=n+s.actualBoundingBoxDescent;const u=r.strikethrough?(c+l)/2:l;t.strokeStyle=t.fillStyle;t.beginPath();t.lineWidth=r.decorationWidth||2;t.moveTo(i,u);t.lineTo(a,u);t.stroke()}}function re(t,e){const n=t.fillStyle;t.fillStyle=e.color;t.fillRect(e.left,e.top,e.width,e.height);t.fillStyle=n}function se(t,e,n,s,i,a={}){const c=r(e)?e:[e];const l=a.strokeWidth>0&&a.strokeColor!=="";let u,f;t.save();t.font=i.string;ne(t,a);for(u=0;u<c.length;++u){f=c[u];a.backdrop&&re(t,a.backdrop);if(l){a.strokeColor&&(t.strokeStyle=a.strokeColor);o(a.strokeWidth)||(t.lineWidth=a.strokeWidth);t.strokeText(f,n,s,a.maxWidth)}t.fillText(f,n,s,a.maxWidth);oe(t,n,s,f,a);s+=Number(i.lineHeight)}t.restore()}
/**
 * Add a path of a rectangle with rounded corners to the current sub-path
 * @param ctx - Context
 * @param rect - Bounding rect
 */function ie(t,e){const{x:n,y:o,w:r,h:s,radius:i}=e;t.arc(n+i.topLeft,o+i.topLeft,i.topLeft,1.5*I,I,true);t.lineTo(n,o+s-i.bottomLeft);t.arc(n+i.bottomLeft,o+s-i.bottomLeft,i.bottomLeft,I,B,true);t.lineTo(n+r-i.bottomRight,o+s);t.arc(n+r-i.bottomRight,o+s-i.bottomRight,i.bottomRight,B,0,true);t.lineTo(n+r,o+i.topRight);t.arc(n+r-i.topRight,o+i.topRight,i.topRight,0,-B,true);t.lineTo(n+i.topLeft,o)}const ae=/^(normal|(\d+(?:\.\d+)?)(px|em|%)?)$/;const ce=/^(normal|italic|initial|inherit|unset|(oblique( -?[0-9]?[0-9]deg)?))$/;
/**
 * Converts the given line height `value` in pixels for a specific font `size`.
 * @param value - The lineHeight to parse (eg. 1.6, '14px', '75%', '1.6em').
 * @param size - The font size (in pixels) used to resolve relative `value`.
 * @returns The effective line height in pixels (size * 1.2 if value is invalid).
 * @see https://developer.mozilla.org/en-US/docs/Web/CSS/line-height
 * @since 2.7.0
 */function le(t,e){const n=(""+t).match(ae);if(!n||n[1]==="normal")return e*1.2;t=+n[2];switch(n[3]){case"px":return t;case"%":t/=100;break}return e*t}const ue=t=>+t||0;function fe(t,e){const n={};const o=s(e);const r=o?Object.keys(e):e;const i=s(t)?o?n=>c(t[n],t[e[n]]):e=>t[e]:()=>t;for(const t of r)n[t]=ue(i(t));return n}
/**
 * Converts the given value into a TRBL object.
 * @param value - If a number, set the value to all TRBL component,
 *  else, if an object, use defined properties and sets undefined ones to 0.
 *  x / y are shorthands for same value for left/right and top/bottom.
 * @returns The padding values (top, right, bottom, left)
 * @since 3.0.0
 */function he(t){return fe(t,{top:"y",right:"x",bottom:"y",left:"x"})}
/**
 * Converts the given value into a TRBL corners object (similar with css border-radius).
 * @param value - If a number, set the value to all TRBL corner components,
 *  else, if an object, use defined properties and sets undefined ones to 0.
 * @returns The TRBL corner values (topLeft, topRight, bottomLeft, bottomRight)
 * @since 3.0.0
 */function de(t){return fe(t,["topLeft","topRight","bottomLeft","bottomRight"])}
/**
 * Converts the given value into a padding object with pre-computed width/height.
 * @param value - If a number, set the value to all TRBL component,
 *  else, if an object, use defined properties and sets undefined ones to 0.
 *  x / y are shorthands for same value for left/right and top/bottom.
 * @returns The padding values (top, right, bottom, left, width, height)
 * @since 2.7.0
 */function pe(t){const e=he(t);e.width=e.left+e.right;e.height=e.top+e.bottom;return e}
/**
 * Parses font options and returns the font object.
 * @param options - A object that contains font options to be parsed.
 * @param fallback - A object that contains fallback font options.
 * @return The font object.
 * @private
 */function ge(t,e){t=t||{};e=e||Qt.font;let n=c(t.size,e.size);typeof n==="string"&&(n=parseInt(n,10));let o=c(t.style,e.style);if(o&&!(""+o).match(ce)){console.warn('Invalid font style specified: "'+o+'"');o=void 0}const r={family:c(t.family,e.family),lineHeight:le(c(t.lineHeight,e.lineHeight),n),size:n,style:o,weight:c(t.weight,e.weight),string:""};r.string=qt(r);return r}
/**
 * Evaluates the given `inputs` sequentially and returns the first defined value.
 * @param inputs - An array of values, falling back to the last value.
 * @param context - If defined and the current value is a function, the value
 * is called with `context` as first argument and the result becomes the new input.
 * @param index - If defined and the current value is an array, the value
 * at `index` become the new input.
 * @param info - object to return information about resolution in
 * @param info.cacheable - Will be set to `false` if option is not cacheable.
 * @since 2.7.0
 */function be(t,e,n,o){let s=true;let i,a,c;for(i=0,a=t.length;i<a;++i){c=t[i];if(c!==void 0){if(e!==void 0&&typeof c==="function"){c=c(e);s=false}if(n!==void 0&&r(c)){c=c[n%c.length];s=false}if(c!==void 0){o&&!s&&(o.cacheable=false);return c}}}}
/**
 * @param minmax
 * @param grace
 * @param beginAtZero
 * @private
 */function ye(t,e,n){const{min:o,max:r}=t;const s=u(e,(r-o)/2);const i=(t,e)=>n&&t===0?0:t+e;return{min:i(o,-Math.abs(s)),max:i(r,s)}}function xe(t,e){return Object.assign(Object.create(t),e)}
/**
 * Creates a Proxy for resolving raw values for options.
 * @param scopes - The option scopes to look for values, in resolution order
 * @param prefixes - The prefixes for values, in resolution order.
 * @param rootScopes - The root option scopes
 * @param fallback - Parent scopes fallback
 * @param getTarget - callback for getting the target for changed values
 * @returns Proxy
 * @private
 */function me(t,e=[""],n,o,r=()=>t[0]){const s=n||t;typeof o==="undefined"&&(o=Be("_fallback",t));const i={[Symbol.toStringTag]:"Object",_cacheable:true,_scopes:t,_rootScopes:s,_fallback:o,_getTarget:r,override:n=>me([n,...t],e,s,o)};return new Proxy(i,{deleteProperty(e,n){delete e[n];delete e._keys;delete t[0][n];return true},get(n,o){return _e(n,o,(()=>Ae(o,e,t,n)))},getOwnPropertyDescriptor(t,e){return Reflect.getOwnPropertyDescriptor(t._scopes[0],e)},getPrototypeOf(){return Reflect.getPrototypeOf(t[0])},has(t,e){return De(t).includes(e)},ownKeys(t){return De(t)},set(t,e,n){const o=t._storage||(t._storage=r());t[e]=o[e]=n;delete t._keys;return true}})}
/**
 * Returns an Proxy for resolving option values with context.
 * @param proxy - The Proxy returned by `_createResolver`
 * @param context - Context object for scriptable/indexable options
 * @param subProxy - The proxy provided for scriptable options
 * @param descriptorDefaults - Defaults for descriptors
 * @private
 */function we(t,e,n,o){const r={_cacheable:false,_proxy:t,_context:e,_subProxy:n,_stack:new Set,_descriptors:ve(t,o),setContext:e=>we(t,e,n,o),override:r=>we(t.override(r),e,n,o)};return new Proxy(r,{deleteProperty(e,n){delete e[n];delete t[n];return true},get(t,e,n){return _e(t,e,(()=>Oe(t,e,n)))},getOwnPropertyDescriptor(e,n){return e._descriptors.allKeys?Reflect.has(t,n)?{enumerable:true,configurable:true}:void 0:Reflect.getOwnPropertyDescriptor(t,n)},getPrototypeOf(){return Reflect.getPrototypeOf(t)},has(e,n){return Reflect.has(t,n)},ownKeys(){return Reflect.ownKeys(t)},set(e,n,o){t[n]=o;delete e[n];return true}})}function ve(t,e={scriptable:true,indexable:true}){const{_scriptable:n=e.scriptable,_indexable:o=e.indexable,_allKeys:r=e.allKeys}=t;return{allKeys:r,scriptable:n,indexable:o,isScriptable:T(n)?n:()=>n,isIndexable:T(o)?o:()=>o}}const Me=(t,e)=>t?t+O(e):e;const ke=(t,e)=>s(e)&&t!=="adapters"&&(Object.getPrototypeOf(e)===null||e.constructor===Object);function _e(t,e,n){if(Object.prototype.hasOwnProperty.call(t,e)||e==="constructor")return t[e];const o=n();t[e]=o;return o}function Oe(t,e,n){const{_proxy:o,_context:s,_subProxy:i,_descriptors:a}=t;let c=o[e];T(c)&&a.isScriptable(e)&&(c=Pe(e,c,t,n));r(c)&&c.length&&(c=Te(e,c,t,a.isIndexable));ke(e,c)&&(c=we(c,s,i&&i[e],a));return c}function Pe(t,e,n,o){const{_proxy:r,_context:s,_subProxy:i,_stack:a}=n;if(a.has(t))throw new Error("Recursion detected: "+Array.from(a).join("->")+"->"+t);a.add(t);let c=e(s,i||o);a.delete(t);ke(t,c)&&(c=je(r._scopes,r,t,c));return c}function Te(t,e,n,o){const{_proxy:r,_context:i,_subProxy:a,_descriptors:c}=n;if(typeof i.index!=="undefined"&&o(t))return e[i.index%e.length];if(s(e[0])){const n=e;const o=r._scopes.filter((t=>t!==n));e=[];for(const s of n){const n=je(o,r,t,s);e.push(we(n,i,a&&a[t],c))}}return e}function Se(t,e,n){return T(t)?t(e,n):t}const Ce=(t,e)=>t===true?e:typeof t==="string"?_(e,t):void 0;function Ie(t,e,n,o,r){for(const s of e){const e=Ce(n,s);if(e){t.add(e);const s=Se(e._fallback,n,r);if(typeof s!=="undefined"&&s!==n&&s!==o)return s}else if(e===false&&typeof o!=="undefined"&&n!==o)return null}return false}function je(t,e,n,o){const r=e._rootScopes;const s=Se(e._fallback,n,o);const i=[...t,...r];const a=new Set;a.add(o);let c=Re(a,i,n,s||n,o);if(c===null)return false;if(typeof s!=="undefined"&&s!==n){c=Re(a,i,s,c,o);if(c===null)return false}return me(Array.from(a),[""],r,s,(()=>We(e,n,o)))}function Re(t,e,n,o,r){while(n)n=Ie(t,e,n,o,r);return n}function We(t,e,n){const o=t._getTarget();e in o||(o[e]={});const i=o[e];return r(i)&&s(n)?n:i||{}}function Ae(t,e,n,o){let r;for(const s of e){r=Be(Me(s,t),n);if(typeof r!=="undefined")return ke(t,r)?je(n,o,t,r):r}}function Be(t,e){for(const n of e){if(!n)continue;const e=n[t];if(typeof e!=="undefined")return e}}function De(t){let e=t._keys;e||(e=t._keys=Ne(t._scopes));return e}function Ne(t){const e=new Set;for(const n of t)for(const t of Object.keys(n).filter((t=>!t.startsWith("_"))))e.add(t);return Array.from(e)}function Le(t,e,n,o){const{iScale:r}=t;const{key:s="r"}=this._parsing;const i=new Array(o);let a,c,l,u;for(a=0,c=o;a<c;++a){l=a+n;u=e[l];i[a]={r:r.parse(_(u,s),l)}}return i}const ze=Number.EPSILON||1e-14;const Ee=(t,e)=>e<t.length&&!t[e].skip&&t[e];const He=t=>t==="x"?"y":"x";function Fe(t,e,n,o){const r=t.skip?e:t;const s=e;const i=n.skip?e:n;const a=U(s,r);const c=U(i,s);let l=a/(a+c);let u=c/(a+c);l=isNaN(l)?0:l;u=isNaN(u)?0:u;const f=o*l;const h=o*u;return{previous:{x:s.x-f*(i.x-r.x),y:s.y-f*(i.y-r.y)},next:{x:s.x+h*(i.x-r.x),y:s.y+h*(i.y-r.y)}}}function Qe(t,e,n){const o=t.length;let r,s,i,a,c;let l=Ee(t,0);for(let u=0;u<o-1;++u){c=l;l=Ee(t,u+1);if(c&&l)if(E(e[u],0,ze))n[u]=n[u+1]=0;else{r=n[u]/e[u];s=n[u+1]/e[u];a=Math.pow(r,2)+Math.pow(s,2);if(!(a<=9)){i=3/Math.sqrt(a);n[u]=r*i*e[u];n[u+1]=s*i*e[u]}}}}function qe(t,e,n="x"){const o=He(n);const r=t.length;let s,i,a;let c=Ee(t,0);for(let l=0;l<r;++l){i=a;a=c;c=Ee(t,l+1);if(!a)continue;const r=a[n];const u=a[o];if(i){s=(r-i[n])/3;a[`cp1${n}`]=r-s;a[`cp1${o}`]=u-s*e[l]}if(c){s=(c[n]-r)/3;a[`cp2${n}`]=r+s;a[`cp2${o}`]=u+s*e[l]}}}function $e(t,e="x"){const n=He(e);const o=t.length;const r=Array(o).fill(0);const s=Array(o);let i,a,c;let l=Ee(t,0);for(i=0;i<o;++i){a=c;c=l;l=Ee(t,i+1);if(c){if(l){const t=l[e]-c[e];r[i]=t!==0?(l[n]-c[n])/t:0}s[i]=a?l?z(r[i-1])!==z(r[i])?0:(r[i-1]+r[i])/2:r[i-1]:r[i]}}Qe(t,r,s);qe(t,s,e)}function Ke(t,e,n){return Math.max(Math.min(t,n),e)}function Ve(t,e){let n,o,r,s,i;let a=Ut(t[0],e);for(n=0,o=t.length;n<o;++n){i=s;s=a;a=n<o-1&&Ut(t[n+1],e);if(s){r=t[n];if(i){r.cp1x=Ke(r.cp1x,e.left,e.right);r.cp1y=Ke(r.cp1y,e.top,e.bottom)}if(a){r.cp2x=Ke(r.cp2x,e.left,e.right);r.cp2y=Ke(r.cp2y,e.top,e.bottom)}}}}function Ge(t,e,n,o,r){let s,i,a,c;e.spanGaps&&(t=t.filter((t=>!t.skip)));if(e.cubicInterpolationMode==="monotone")$e(t,r);else{let n=o?t[t.length-1]:t[0];for(s=0,i=t.length;s<i;++s){a=t[s];c=Fe(n,a,t[Math.min(s+1,i-(o?0:1))%i],e.tension);a.cp1x=c.previous.x;a.cp1y=c.previous.y;a.cp2x=c.next.x;a.cp2y=c.next.y;n=a}}e.capBezierPoints&&Ve(t,n)}function Je(){return typeof window!=="undefined"&&typeof document!=="undefined"}function Ye(t){let e=t.parentNode;e&&e.toString()==="[object ShadowRoot]"&&(e=e.host);return e}function Ue(t,e,n){let o;if(typeof t==="string"){o=parseInt(t,10);t.indexOf("%")!==-1&&(o=o/100*e.parentNode[n])}else o=t;return o}const Xe=t=>t.ownerDocument.defaultView.getComputedStyle(t,null);function Ze(t,e){return Xe(t).getPropertyValue(e)}const tn=["top","right","bottom","left"];function en(t,e,n){const o={};n=n?"-"+n:"";for(let r=0;r<4;r++){const s=tn[r];o[s]=parseFloat(t[e+"-"+s+n])||0}o.width=o.left+o.right;o.height=o.top+o.bottom;return o}const nn=(t,e,n)=>(t>0||e>0)&&(!n||!n.shadowRoot)
/**
 * @param e
 * @param canvas
 * @returns Canvas position
 */;function on(t,e){const n=t.touches;const o=n&&n.length?n[0]:t;const{offsetX:r,offsetY:s}=o;let i=false;let a,c;if(nn(r,s,t.target)){a=r;c=s}else{const t=e.getBoundingClientRect();a=o.clientX-t.left;c=o.clientY-t.top;i=true}return{x:a,y:c,box:i}}
/**
 * Gets an event's x, y coordinates, relative to the chart area
 * @param event
 * @param chart
 * @returns x and y coordinates of the event
 */function rn(t,e){if("native"in t)return t;const{canvas:n,currentDevicePixelRatio:o}=e;const r=Xe(n);const s=r.boxSizing==="border-box";const i=en(r,"padding");const a=en(r,"border","width");const{x:c,y:l,box:u}=on(t,n);const f=i.left+(u&&a.left);const h=i.top+(u&&a.top);let{width:d,height:p}=e;if(s){d-=i.width+a.width;p-=i.height+a.height}return{x:Math.round((c-f)/d*n.width/o),y:Math.round((l-h)/p*n.height/o)}}function sn(t,e,n){let o,r;if(e===void 0||n===void 0){const s=t&&Ye(t);if(s){const t=s.getBoundingClientRect();const i=Xe(s);const a=en(i,"border","width");const c=en(i,"padding");e=t.width-c.width-a.width;n=t.height-c.height-a.height;o=Ue(i.maxWidth,s,"clientWidth");r=Ue(i.maxHeight,s,"clientHeight")}else{e=t.clientWidth;n=t.clientHeight}}return{width:e,height:n,maxWidth:o||W,maxHeight:r||W}}const an=t=>Math.round(t*10)/10;function cn(t,e,n,o){const r=Xe(t);const s=en(r,"margin");const i=Ue(r.maxWidth,t,"clientWidth")||W;const a=Ue(r.maxHeight,t,"clientHeight")||W;const c=sn(t,e,n);let{width:l,height:u}=c;if(r.boxSizing==="content-box"){const t=en(r,"border","width");const e=en(r,"padding");l-=e.width+t.width;u-=e.height+t.height}l=Math.max(0,l-s.width);u=Math.max(0,o?l/o:u-s.height);l=an(Math.min(l,i,c.maxWidth));u=an(Math.min(u,a,c.maxHeight));l&&!u&&(u=an(l/2));const f=e!==void 0||n!==void 0;if(f&&o&&c.height&&u>c.height){u=c.height;l=an(Math.floor(u*o))}return{width:l,height:u}}
/**
 * @param chart
 * @param forceRatio
 * @param forceStyle
 * @returns True if the canvas context size or transformation has changed.
 */function ln(t,e,n){const o=e||1;const r=an(t.height*o);const s=an(t.width*o);t.height=an(t.height);t.width=an(t.width);const i=t.canvas;if(i.style&&(n||!i.style.height&&!i.style.width)){i.style.height=`${t.height}px`;i.style.width=`${t.width}px`}if(t.currentDevicePixelRatio!==o||i.height!==r||i.width!==s){t.currentDevicePixelRatio=o;i.height=r;i.width=s;t.ctx.setTransform(o,0,0,o,0,0);return true}return false}const un=function(){let t=false;try{const e={get passive(){t=true;return false}};if(Je()){window.addEventListener("test",null,e);window.removeEventListener("test",null,e)}}catch(t){}return t}();
/**
 * The "used" size is the final value of a dimension property after all calculations have
 * been performed. This method uses the computed style of `element` but returns undefined
 * if the computed style is not expressed in pixels. That can happen in some cases where
 * `element` has a size relative to its parent and this last one is not yet displayed,
 * for example because of `display: none` on a parent node.
 * @see https://developer.mozilla.org/en-US/docs/Web/CSS/used_value
 * @returns Size in pixels or undefined if unknown.
 */function fn(t,e){const n=Ze(t,e);const o=n&&n.match(/^(\d+)(\.\d+)?px$/);return o?+o[1]:void 0}function hn(t,e,n,o){return{x:t.x+n*(e.x-t.x),y:t.y+n*(e.y-t.y)}}function dn(t,e,n,o){return{x:t.x+n*(e.x-t.x),y:o==="middle"?n<.5?t.y:e.y:o==="after"?n<1?t.y:e.y:n>0?e.y:t.y}}function pn(t,e,n,o){const r={x:t.cp2x,y:t.cp2y};const s={x:e.cp1x,y:e.cp1y};const i=hn(t,r,n);const a=hn(r,s,n);const c=hn(s,e,n);const l=hn(i,a,n);const u=hn(a,c,n);return hn(l,u,n)}const gn=function(t,e){return{x(n){return t+t+e-n},setWidth(t){e=t},textAlign(t){return t==="center"?t:t==="right"?"left":"right"},xPlus(t,e){return t-e},leftForLtr(t,e){return t-e}}};const bn=function(){return{x(t){return t},setWidth(t){},textAlign(t){return t},xPlus(t,e){return t+e},leftForLtr(t,e){return t}}};function yn(t,e,n){return t?gn(e,n):bn()}function xn(t,e){let n,o;if(e==="ltr"||e==="rtl"){n=t.canvas.style;o=[n.getPropertyValue("direction"),n.getPropertyPriority("direction")];n.setProperty("direction",e,"important");t.prevTextDirection=o}}function mn(t,e){if(e!==void 0){delete t.prevTextDirection;t.canvas.style.setProperty("direction",e[0],e[1])}}function wn(t){return t==="angle"?{between:tt,compare:X,normalize:Z}:{between:ot,compare:(t,e)=>t-e,normalize:t=>t}}function vn({start:t,end:e,count:n,loop:o,style:r}){return{start:t%n,end:e%n,loop:o&&(e-t+1)%n===0,style:r}}function Mn(t,e,n){const{property:o,start:r,end:s}=n;const{between:i,normalize:a}=wn(o);const c=e.length;let{start:l,end:u,loop:f}=t;let h,d;if(f){l+=c;u+=c;for(h=0,d=c;h<d;++h){if(!i(a(e[l%c][o]),r,s))break;l--;u--}l%=c;u%=c}u<l&&(u+=c);return{start:l,end:u,loop:f,style:t.style}}function kn(t,e,n){if(!n)return[t];const{property:o,start:r,end:s}=n;const i=e.length;const{compare:a,between:c,normalize:l}=wn(o);const{start:u,end:f,loop:h,style:d}=Mn(t,e,n);const p=[];let g=false;let b=null;let y,x,m;const w=()=>c(r,m,y)&&a(r,m)!==0;const v=()=>a(s,y)===0||c(s,m,y);const M=()=>g||w();const k=()=>!g||v();for(let t=u,n=u;t<=f;++t){x=e[t%i];if(!x.skip){y=l(x[o]);if(y!==m){g=c(y,r,s);b===null&&M()&&(b=a(y,r)===0?t:n);if(b!==null&&k()){p.push(vn({start:b,end:t,loop:h,count:i,style:d}));b=null}n=t;m=y}}}b!==null&&p.push(vn({start:b,end:f,loop:h,count:i,style:d}));return p}function _n(t,e){const n=[];const o=t.segments;for(let r=0;r<o.length;r++){const s=kn(o[r],t.points,e);s.length&&n.push(...s)}return n}function On(t,e,n,o){let r=0;let s=e-1;if(n&&!o)while(r<e&&!t[r].skip)r++;while(r<e&&t[r].skip)r++;r%=e;n&&(s+=r);while(s>r&&t[s%e].skip)s--;s%=e;return{start:r,end:s}}function Pn(t,e,n,o){const r=t.length;const s=[];let i=e;let a=t[e];let c;for(c=e+1;c<=n;++c){const n=t[c%r];if(n.skip||n.stop){if(!a.skip){o=false;s.push({start:e%r,end:(c-1)%r,loop:o});e=i=n.stop?c:null}}else{i=c;a.skip&&(e=c)}a=n}i!==null&&s.push({start:e%r,end:i%r,loop:o});return s}function Tn(t,e){const n=t.points;const o=t.options.spanGaps;const r=n.length;if(!r)return[];const s=!!t._loop;const{start:i,end:a}=On(n,r,s,o);if(o===true)return Sn(t,[{start:i,end:a,loop:s}],n,e);const c=a<i?a+r:a;const l=!!t._fullLoop&&i===0&&a===r-1;return Sn(t,Pn(n,i,c,l),n,e)}function Sn(t,e,n,o){return o&&o.setContext&&n?Cn(t,e,n,o):e}function Cn(t,e,n,o){const r=t._chart.getContext();const s=In(t.options);const{_datasetIndex:i,options:{spanGaps:a}}=t;const c=n.length;const l=[];let u=s;let f=e[0].start;let h=f;function d(t,e,o,r){const s=a?-1:1;if(t!==e){t+=c;while(n[t%c].skip)t-=s;while(n[e%c].skip)e+=s;if(t%c!==e%c){l.push({start:t%c,end:e%c,loop:o,style:r});u=r;f=e%c}}}for(const t of e){f=a?f:t.start;let e=n[f%c];let s;for(h=f+1;h<=t.end;h++){const a=n[h%c];s=In(o.setContext(xe(r,{type:"segment",p0:e,p1:a,p0DataIndex:(h-1)%c,p1DataIndex:h%c,datasetIndex:i})));jn(s,u)&&d(f,h-1,t.loop,u);e=a;u=s}f<h-1&&d(f,h-1,t.loop,u)}return l}function In(t){return{backgroundColor:t.backgroundColor,borderCapStyle:t.borderCapStyle,borderDash:t.borderDash,borderDashOffset:t.borderDashOffset,borderJoinStyle:t.borderJoinStyle,borderWidth:t.borderWidth,borderColor:t.borderColor}}function jn(t,e){if(!e)return false;const n=[];const o=function(t,e){if(!Ot(e))return e;n.includes(e)||n.push(e);return n.indexOf(e)};return JSON.stringify(t,o)!==JSON.stringify(e,o)}function Rn(t,e,n){return t.options.clip?t[n]:e[n]}function Wn(t,e){const{xScale:n,yScale:o}=t;return n&&o?{left:Rn(n,e,"left"),right:Rn(n,e,"right"),top:Rn(o,e,"top"),bottom:Rn(o,e,"bottom")}:e}function An(t,e){const n=e._clip;if(n.disabled)return false;const o=Wn(e,t.chartArea);return{left:n.left===false?0:o.left-(n.left===true?0:n.left),right:n.right===false?t.width:o.right+(n.right===true?0:n.right),top:n.top===false?0:o.top-(n.top===true?0:n.top),bottom:n.bottom===false?t.height:o.bottom+(n.bottom===true?0:n.bottom)}}export{nt as $,it as A,st as B,Ut as C,Y as D,rn as E,pe as F,h as G,B as H,fn as I,un as J,Ye as K,pt as L,cn as M,Je as N,F as O,I as P,ge as Q,bt as R,yt as S,Nt as T,a as U,f as V,ye as W,et as X,G as Y,$t as Z,ft as _,be as a,p as a$,Vt as a0,Xt as a1,se as a2,Zt as a3,zt as a4,y as a5,O as a6,x as a7,Et as a8,T as a9,kn as aA,yn as aB,Yt as aC,xn as aD,xt as aE,mn as aF,U as aG,e as aH,H as aI,$ as aJ,E as aK,J as aL,K as aM,L as aN,Kt as aO,rt as aP,at as aQ,W as aR,R as aS,D as aT,A as aU,N as aV,X as aW,w as aX,b as aY,m as aZ,M as a_,we as aa,me as ab,ve as ac,n as ad,gt as ae,ln as af,Gt as ag,S as ah,An as ai,d as aj,C as ak,Z as al,fe as am,ot as an,te as ao,ee as ap,dn as aq,pn as ar,hn as as,Ge as at,Tn as au,_n as av,Jt as aw,he as ax,de as ay,ie as az,r as b,ht as b0,Tt as b1,Ze as b2,Ot as b3,Fe as b4,$e as b5,qt as b6,le as b7,Pt as c,Qt as d,_t as e,i as f,xe as g,_ as h,s as i,P as j,o as k,lt as l,j as m,tt as n,l as o,u as p,At as q,dt as r,z as s,V as t,ut as u,c as v,mt as w,wt as x,q as y,Le as z};
//# sourceMappingURL=MwoWUuIu.js.map
