import*as t from"console-control-strings";import{_ as e,a as i}from"./_/b96d91fa.js";import*as s from"aproba";import*as r from"has-unicode";import*as a from"color-support";import*as h from"signal-exit";import o from"process";import"object-assign";import"wide-align";import"string-width";import"strip-ansi";import"util";var n="default"in t?t.default:t;var u="default"in s?s.default:s;var l={};var d=n;var _=e;var p=u;var f=l=function(t,e,i){i||(i=80);p("OAN",[t,e,i]);this.showing=false;this.theme=t;this.width=i;this.template=e};f.prototype={};f.prototype.setTheme=function(t){p("O",[t]);this.theme=t};f.prototype.setTemplate=function(t){p("A",[t]);this.template=t};f.prototype.setWidth=function(t){p("N",[t]);this.width=t};f.prototype.hide=function(){return d.gotoSOL()+d.eraseLine()};f.prototype.hideCursor=d.hideCursor;f.prototype.showCursor=d.showCursor;f.prototype.show=function(t){var e=Object.create(this.theme);for(var i in t)e[i]=t[i];return _(this.width,this.template,e).trim()+d.color("reset")+d.eraseLine()+d.gotoSOL()};var c=l;var g="default"in a?a.default:a;var m={};var v=g;m=v().hasBasic;var w=m;var y={};y=setInterval;var b=y;var T={};var x=o;T=x;var C=T;var G={};var R=o;var O=C;try{G=R.nextTick}catch(t){G=O.nextTick}var k=G;var E="default"in r?r.default:r;var S="default"in h?h.default:h;var W={};var $=c;var U=E;var I=w;var z=S;var A=i;var F=b;var j=C;var q=k;W=Gauge;function callWith(t,e){return function(){return e.call(t)}}function Gauge(t,e){var i,s;if(t&&t.write){s=t;i=e||{}}else if(e&&e.write){s=e;i=t||{}}else{s=j.stderr;i=t||e||{}}this._status={spun:0,section:"",subsection:""};this._paused=false;this._disabled=true;this._showing=false;this._onScreen=false;this._needsRedraw=false;this._hideCursor=null==i.hideCursor||i.hideCursor;this._fixedFramerate=null==i.fixedFramerate?!/^v0\.8\./.test(j.version):i.fixedFramerate;this._lastUpdateAt=null;this._updateInterval=null==i.updateInterval?50:i.updateInterval;this._themes=i.themes||A;this._theme=i.theme;var r=this._computeTheme(i.theme);var a=i.template||[{type:"progressbar",length:20},{type:"activityIndicator",kerning:1,length:1},{type:"section",kerning:1,default:""},{type:"subsection",kerning:1,default:""}];this.setWriteTo(s,i.tty);var h=i.Plumbing||$;this._gauge=new h(r,a,this.getWidth());this._$$doRedraw=callWith(this,this._doRedraw);this._$$handleSizeChange=callWith(this,this._handleSizeChange);this._cleanupOnExit=null==i.cleanupOnExit||i.cleanupOnExit;this._removeOnExit=null;i.enabled||null==i.enabled&&this._tty&&this._tty.isTTY?this.enable():this.disable()}Gauge.prototype={};Gauge.prototype.isEnabled=function(){return!this._disabled};Gauge.prototype.setTemplate=function(t){this._gauge.setTemplate(t);this._showing&&this._requestRedraw()};Gauge.prototype._computeTheme=function(t){t||(t={});if("string"===typeof t)t=this._themes.getTheme(t);else if(t&&(0===Object.keys(t).length||null!=t.hasUnicode||null!=t.hasColor)){var e=null==t.hasUnicode?U():t.hasUnicode;var i=null==t.hasColor?I:t.hasColor;t=this._themes.getDefault({hasUnicode:e,hasColor:i,platform:t.platform})}return t};Gauge.prototype.setThemeset=function(t){this._themes=t;this.setTheme(this._theme)};Gauge.prototype.setTheme=function(t){this._gauge.setTheme(this._computeTheme(t));this._showing&&this._requestRedraw();this._theme=t};Gauge.prototype._requestRedraw=function(){this._needsRedraw=true;this._fixedFramerate||this._doRedraw()};Gauge.prototype.getWidth=function(){return(this._tty&&this._tty.columns||80)-1};Gauge.prototype.setWriteTo=function(t,e){var i=!this._disabled;i&&this.disable();this._writeTo=t;this._tty=e||t===j.stderr&&j.stdout.isTTY&&j.stdout||t.isTTY&&t||this._tty;this._gauge&&this._gauge.setWidth(this.getWidth());i&&this.enable()};Gauge.prototype.enable=function(){if(this._disabled){this._disabled=false;this._tty&&this._enableEvents();this._showing&&this.show()}};Gauge.prototype.disable=function(){if(!this._disabled){if(this._showing){this._lastUpdateAt=null;this._showing=false;this._doRedraw();this._showing=true}this._disabled=true;this._tty&&this._disableEvents()}};Gauge.prototype._enableEvents=function(){this._cleanupOnExit&&(this._removeOnExit=z(callWith(this,this.disable)));this._tty.on("resize",this._$$handleSizeChange);if(this._fixedFramerate){this.redrawTracker=F(this._$$doRedraw,this._updateInterval);this.redrawTracker.unref&&this.redrawTracker.unref()}};Gauge.prototype._disableEvents=function(){this._tty.removeListener("resize",this._$$handleSizeChange);this._fixedFramerate&&clearInterval(this.redrawTracker);this._removeOnExit&&this._removeOnExit()};Gauge.prototype.hide=function(t){if(this._disabled)return t&&j.nextTick(t);if(!this._showing)return t&&j.nextTick(t);this._showing=false;this._doRedraw();t&&q(t)};Gauge.prototype.show=function(t,e){this._showing=true;if("string"===typeof t)this._status.section=t;else if("object"===typeof t){var i=Object.keys(t);for(var s=0;s<i.length;++s){var r=i[s];this._status[r]=t[r]}}null!=e&&(this._status.completed=e);this._disabled||this._requestRedraw()};Gauge.prototype.pulse=function(t){this._status.subsection=t||"";this._status.spun++;this._disabled||this._showing&&this._requestRedraw()};Gauge.prototype._handleSizeChange=function(){this._gauge.setWidth(this._tty.columns-1);this._requestRedraw()};Gauge.prototype._doRedraw=function(){if(!this._disabled&&!this._paused){if(!this._fixedFramerate){var t=Date.now();if(this._lastUpdateAt&&t-this._lastUpdateAt<this._updateInterval)return;this._lastUpdateAt=t}if(!this._showing&&this._onScreen){this._onScreen=false;var e=this._gauge.hide();this._hideCursor&&(e+=this._gauge.showCursor());return this._writeTo.write(e)}if(this._showing||this._onScreen){if(this._showing&&!this._onScreen){this._onScreen=true;this._needsRedraw=true;this._hideCursor&&this._writeTo.write(this._gauge.hideCursor())}if(this._needsRedraw&&!this._writeTo.write(this._gauge.show(this._status))){this._paused=true;this._writeTo.on("drain",callWith(this,(function(){this._paused=false;this._doRedraw()})))}}}};var L=W;export{L as default};

