/**
 * @license
 * Copyright 2009 The Closure Library Authors
 * Copyright 2020 Daniel Wirtz / The long.js Authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 */
var i=null;try{i=new WebAssembly.Instance(new WebAssembly.Module(new Uint8Array([0,97,115,109,1,0,0,0,1,13,2,96,0,1,127,96,4,127,127,127,127,1,127,3,7,6,0,1,1,1,1,1,6,6,1,127,1,65,0,11,7,50,6,3,109,117,108,0,1,5,100,105,118,95,115,0,2,5,100,105,118,95,117,0,3,5,114,101,109,95,115,0,4,5,114,101,109,95,117,0,5,8,103,101,116,95,104,105,103,104,0,0,10,191,1,6,4,0,35,0,11,36,1,1,126,32,0,173,32,1,173,66,32,134,132,32,2,173,32,3,173,66,32,134,132,126,34,4,66,32,135,167,36,0,32,4,167,11,36,1,1,126,32,0,173,32,1,173,66,32,134,132,32,2,173,32,3,173,66,32,134,132,127,34,4,66,32,135,167,36,0,32,4,167,11,36,1,1,126,32,0,173,32,1,173,66,32,134,132,32,2,173,32,3,173,66,32,134,132,128,34,4,66,32,135,167,36,0,32,4,167,11,36,1,1,126,32,0,173,32,1,173,66,32,134,132,32,2,173,32,3,173,66,32,134,132,129,34,4,66,32,135,167,36,0,32,4,167,11,36,1,1,126,32,0,173,32,1,173,66,32,134,132,32,2,173,32,3,173,66,32,134,132,130,34,4,66,32,135,167,36,0,32,4,167,11])),{}).exports}catch(i){}
/**
 * Constructs a 64 bit two's-complement integer, given its low and high 32 bit values as *signed* integers.
 *  See the from* functions below for more convenient ways of constructing Longs.
 * @exports Long
 * @class A Long class for representing a 64 bit two's-complement integer value.
 * @param {number} low The low (signed) 32 bits of the long
 * @param {number} high The high (signed) 32 bits of the long
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @constructor
 */function Long(i,t,n){
/**
   * The low 32 bits as a signed value.
   * @type {number}
   */
this.low=0|i;
/**
   * The high 32 bits as a signed value.
   * @type {number}
   */this.high=0|t;
/**
   * Whether unsigned or not.
   * @type {boolean}
   */this.unsigned=!!n}
/**
 * An indicator used to reliably determine if an object is a Long or not.
 * @type {boolean}
 * @const
 * @private
 */Long.prototype.__isLong__;Object.defineProperty(Long.prototype,"__isLong__",{value:true});
/**
 * @function
 * @param {*} obj Object
 * @returns {boolean}
 * @inner
 */function isLong(i){return true===(i&&i.__isLong__)}
/**
 * @function
 * @param {*} value number
 * @returns {number}
 * @inner
 */function ctz32(i){var t=Math.clz32(i&-i);return i?31-t:t}
/**
 * Tests if the specified object is a Long.
 * @function
 * @param {*} obj Object
 * @returns {boolean}
 */Long.isLong=isLong;
/**
 * A cache of the Long representations of small integer values.
 * @type {!Object}
 * @inner
 */var t={};
/**
 * A cache of the Long representations of small unsigned integer values.
 * @type {!Object}
 * @inner
 */var n={};
/**
 * @param {number} value
 * @param {boolean=} unsigned
 * @returns {!Long}
 * @inner
 */function fromInt(i,r){var s,e,h;if(r){i>>>=0;if(h=0<=i&&i<256){e=n[i];if(e)return e}s=fromBits(i,0,true);h&&(n[i]=s);return s}i|=0;if(h=-128<=i&&i<128){e=t[i];if(e)return e}s=fromBits(i,i<0?-1:0,false);h&&(t[i]=s);return s}
/**
 * Returns a Long representing the given 32 bit integer value.
 * @function
 * @param {number} value The 32 bit integer in question
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @returns {!Long} The corresponding Long value
 */Long.fromInt=fromInt;
/**
 * @param {number} value
 * @param {boolean=} unsigned
 * @returns {!Long}
 * @inner
 */function fromNumber(i,t){if(isNaN(i))return t?a:f;if(t){if(i<0)return a;if(i>=o)return c}else{if(i<=-u)return w;if(i+1>=u)return v}return i<0?fromNumber(-i,t).neg():fromBits(i%h|0,i/h|0,t)}
/**
 * Returns a Long representing the given value, provided that it is a finite number. Otherwise, zero is returned.
 * @function
 * @param {number} value The number in question
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @returns {!Long} The corresponding Long value
 */Long.fromNumber=fromNumber;
/**
 * @param {number} lowBits
 * @param {number} highBits
 * @param {boolean=} unsigned
 * @returns {!Long}
 * @inner
 */function fromBits(i,t,n){return new Long(i,t,n)}
/**
 * Returns a Long representing the 64 bit integer that comes by concatenating the given low and high bits. Each is
 *  assumed to use 32 bits.
 * @function
 * @param {number} lowBits The low 32 bits
 * @param {number} highBits The high 32 bits
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @returns {!Long} The corresponding Long value
 */Long.fromBits=fromBits;
/**
 * @function
 * @param {number} base
 * @param {number} exponent
 * @returns {number}
 * @inner
 */var r=Math.pow;
/**
 * @param {string} str
 * @param {(boolean|number)=} unsigned
 * @param {number=} radix
 * @returns {!Long}
 * @inner
 */function fromString(i,t,n){if(0===i.length)throw Error("empty string");if("number"===typeof t){n=t;t=false}else t=!!t;if("NaN"===i||"Infinity"===i||"+Infinity"===i||"-Infinity"===i)return t?a:f;n=n||10;if(n<2||36<n)throw RangeError("radix");var s;if((s=i.indexOf("-"))>0)throw Error("interior hyphen");if(0===s)return fromString(i.substring(1),t,n).neg();var e=fromNumber(r(n,8));var h=f;for(var o=0;o<i.length;o+=8){var u=Math.min(8,i.length-o),g=parseInt(i.substring(o,o+u),n);if(u<8){var l=fromNumber(r(n,u));h=h.mul(l).add(fromNumber(g))}else{h=h.mul(e);h=h.add(fromNumber(g))}}h.unsigned=t;return h}
/**
 * Returns a Long representation of the given string, written using the specified radix.
 * @function
 * @param {string} str The textual representation of the Long
 * @param {(boolean|number)=} unsigned Whether unsigned or not, defaults to signed
 * @param {number=} radix The radix in which the text is written (2-36), defaults to 10
 * @returns {!Long} The corresponding Long value
 */Long.fromString=fromString;
/**
 * @function
 * @param {!Long|number|string|!{low: number, high: number, unsigned: boolean}} val
 * @param {boolean=} unsigned
 * @returns {!Long}
 * @inner
 */function fromValue(i,t){return"number"===typeof i?fromNumber(i,t):"string"===typeof i?fromString(i,t):fromBits(i.low,i.high,"boolean"===typeof t?t:i.unsigned)}
/**
 * Converts the specified value to a Long using the appropriate from* function for its type.
 * @function
 * @param {!Long|number|string|!{low: number, high: number, unsigned: boolean}} val Value
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @returns {!Long}
 */Long.fromValue=fromValue;
/**
 * @type {number}
 * @const
 * @inner
 */var s=65536;
/**
 * @type {number}
 * @const
 * @inner
 */var e=1<<24;
/**
 * @type {number}
 * @const
 * @inner
 */var h=s*s;
/**
 * @type {number}
 * @const
 * @inner
 */var o=h*h;
/**
 * @type {number}
 * @const
 * @inner
 */var u=o/2;
/**
 * @type {!Long}
 * @const
 * @inner
 */var g=fromInt(e);
/**
 * @type {!Long}
 * @inner
 */var f=fromInt(0);
/**
 * Signed zero.
 * @type {!Long}
 */Long.ZERO=f;
/**
 * @type {!Long}
 * @inner
 */var a=fromInt(0,true);
/**
 * Unsigned zero.
 * @type {!Long}
 */Long.UZERO=a;
/**
 * @type {!Long}
 * @inner
 */var l=fromInt(1);
/**
 * Signed one.
 * @type {!Long}
 */Long.ONE=l;
/**
 * @type {!Long}
 * @inner
 */var m=fromInt(1,true);
/**
 * Unsigned one.
 * @type {!Long}
 */Long.UONE=m;
/**
 * @type {!Long}
 * @inner
 */var d=fromInt(-1);
/**
 * Signed negative one.
 * @type {!Long}
 */Long.NEG_ONE=d;
/**
 * @type {!Long}
 * @inner
 */var v=fromBits(-1,2147483647,false);
/**
 * Maximum signed value.
 * @type {!Long}
 */Long.MAX_VALUE=v;
/**
 * @type {!Long}
 * @inner
 */var c=fromBits(-1,-1,true);
/**
 * Maximum unsigned value.
 * @type {!Long}
 */Long.MAX_UNSIGNED_VALUE=c;
/**
 * @type {!Long}
 * @inner
 */var w=fromBits(0,-2147483648,false);
/**
 * Minimum signed value.
 * @type {!Long}
 */Long.MIN_VALUE=w;var L=Long.prototype;
/**
 * Converts the Long to a 32 bit integer, assuming it is a 32 bit integer.
 * @this {!Long}
 * @returns {number}
 */L.toInt=function toInt(){return this.unsigned?this.low>>>0:this.low};
/**
 * Converts the Long to a the nearest floating-point representation of this value (double, 53 bit mantissa).
 * @this {!Long}
 * @returns {number}
 */L.toNumber=function toNumber(){return this.unsigned?(this.high>>>0)*h+(this.low>>>0):this.high*h+(this.low>>>0)};
/**
 * Converts the Long to a string written in the specified radix.
 * @this {!Long}
 * @param {number=} radix Radix (2-36), defaults to 10
 * @returns {string}
 * @override
 * @throws {RangeError} If `radix` is out of range
 */L.toString=function toString(i){i=i||10;if(i<2||36<i)throw RangeError("radix");if(this.isZero())return"0";if(this.isNegative()){if(this.eq(w)){var t=fromNumber(i),n=this.div(t),s=n.mul(t).sub(this);return n.toString(i)+s.toInt().toString(i)}return"-"+this.neg().toString(i)}var e=fromNumber(r(i,6),this.unsigned),h=this;var o="";while(true){var u=h.div(e),g=h.sub(u.mul(e)).toInt()>>>0,f=g.toString(i);h=u;if(h.isZero())return f+o;while(f.length<6)f="0"+f;o=""+f+o}};
/**
 * Gets the high 32 bits as a signed integer.
 * @this {!Long}
 * @returns {number} Signed high bits
 */L.getHighBits=function getHighBits(){return this.high};
/**
 * Gets the high 32 bits as an unsigned integer.
 * @this {!Long}
 * @returns {number} Unsigned high bits
 */L.getHighBitsUnsigned=function getHighBitsUnsigned(){return this.high>>>0};
/**
 * Gets the low 32 bits as a signed integer.
 * @this {!Long}
 * @returns {number} Signed low bits
 */L.getLowBits=function getLowBits(){return this.low};
/**
 * Gets the low 32 bits as an unsigned integer.
 * @this {!Long}
 * @returns {number} Unsigned low bits
 */L.getLowBitsUnsigned=function getLowBitsUnsigned(){return this.low>>>0};
/**
 * Gets the number of bits needed to represent the absolute value of this Long.
 * @this {!Long}
 * @returns {number}
 */L.getNumBitsAbs=function getNumBitsAbs(){if(this.isNegative())return this.eq(w)?64:this.neg().getNumBitsAbs();var i=0!=this.high?this.high:this.low;for(var t=31;t>0;t--)if(0!=(i&1<<t))break;return 0!=this.high?t+33:t+1};
/**
 * Tests if this Long's value equals zero.
 * @this {!Long}
 * @returns {boolean}
 */L.isZero=function isZero(){return 0===this.high&&0===this.low};
/**
 * Tests if this Long's value equals zero. This is an alias of {@link Long#isZero}.
 * @returns {boolean}
 */L.eqz=L.isZero;
/**
 * Tests if this Long's value is negative.
 * @this {!Long}
 * @returns {boolean}
 */L.isNegative=function isNegative(){return!this.unsigned&&this.high<0};
/**
 * Tests if this Long's value is positive or zero.
 * @this {!Long}
 * @returns {boolean}
 */L.isPositive=function isPositive(){return this.unsigned||this.high>=0};
/**
 * Tests if this Long's value is odd.
 * @this {!Long}
 * @returns {boolean}
 */L.isOdd=function isOdd(){return 1===(1&this.low)};
/**
 * Tests if this Long's value is even.
 * @this {!Long}
 * @returns {boolean}
 */L.isEven=function isEven(){return 0===(1&this.low)};
/**
 * Tests if this Long's value equals the specified's.
 * @this {!Long}
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.equals=function equals(i){isLong(i)||(i=fromValue(i));return(this.unsigned===i.unsigned||this.high>>>31!==1||i.high>>>31!==1)&&(this.high===i.high&&this.low===i.low)};
/**
 * Tests if this Long's value equals the specified's. This is an alias of {@link Long#equals}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.eq=L.equals;
/**
 * Tests if this Long's value differs from the specified's.
 * @this {!Long}
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.notEquals=function notEquals(i){return!this.eq(i)};
/**
 * Tests if this Long's value differs from the specified's. This is an alias of {@link Long#notEquals}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.neq=L.notEquals;
/**
 * Tests if this Long's value differs from the specified's. This is an alias of {@link Long#notEquals}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.ne=L.notEquals;
/**
 * Tests if this Long's value is less than the specified's.
 * @this {!Long}
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.lessThan=function lessThan(i){return this.comp(i)<0};
/**
 * Tests if this Long's value is less than the specified's. This is an alias of {@link Long#lessThan}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.lt=L.lessThan;
/**
 * Tests if this Long's value is less than or equal the specified's.
 * @this {!Long}
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.lessThanOrEqual=function lessThanOrEqual(i){return this.comp(i)<=0};
/**
 * Tests if this Long's value is less than or equal the specified's. This is an alias of {@link Long#lessThanOrEqual}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.lte=L.lessThanOrEqual;
/**
 * Tests if this Long's value is less than or equal the specified's. This is an alias of {@link Long#lessThanOrEqual}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.le=L.lessThanOrEqual;
/**
 * Tests if this Long's value is greater than the specified's.
 * @this {!Long}
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.greaterThan=function greaterThan(i){return this.comp(i)>0};
/**
 * Tests if this Long's value is greater than the specified's. This is an alias of {@link Long#greaterThan}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.gt=L.greaterThan;
/**
 * Tests if this Long's value is greater than or equal the specified's.
 * @this {!Long}
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.greaterThanOrEqual=function greaterThanOrEqual(i){return this.comp(i)>=0};
/**
 * Tests if this Long's value is greater than or equal the specified's. This is an alias of {@link Long#greaterThanOrEqual}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.gte=L.greaterThanOrEqual;
/**
 * Tests if this Long's value is greater than or equal the specified's. This is an alias of {@link Long#greaterThanOrEqual}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {boolean}
 */L.ge=L.greaterThanOrEqual;
/**
 * Compares this Long's value with the specified's.
 * @this {!Long}
 * @param {!Long|number|string} other Other value
 * @returns {number} 0 if they are the same, 1 if the this is greater and -1
 *  if the given one is greater
 */L.compare=function compare(i){isLong(i)||(i=fromValue(i));if(this.eq(i))return 0;var t=this.isNegative(),n=i.isNegative();return t&&!n?-1:!t&&n?1:this.unsigned?i.high>>>0>this.high>>>0||i.high===this.high&&i.low>>>0>this.low>>>0?-1:1:this.sub(i).isNegative()?-1:1};
/**
 * Compares this Long's value with the specified's. This is an alias of {@link Long#compare}.
 * @function
 * @param {!Long|number|string} other Other value
 * @returns {number} 0 if they are the same, 1 if the this is greater and -1
 *  if the given one is greater
 */L.comp=L.compare;
/**
 * Negates this Long's value.
 * @this {!Long}
 * @returns {!Long} Negated Long
 */L.negate=function negate(){return!this.unsigned&&this.eq(w)?w:this.not().add(l)};
/**
 * Negates this Long's value. This is an alias of {@link Long#negate}.
 * @function
 * @returns {!Long} Negated Long
 */L.neg=L.negate;
/**
 * Returns the sum of this and the specified Long.
 * @this {!Long}
 * @param {!Long|number|string} addend Addend
 * @returns {!Long} Sum
 */L.add=function add(i){isLong(i)||(i=fromValue(i));var t=this.high>>>16;var n=65535&this.high;var r=this.low>>>16;var s=65535&this.low;var e=i.high>>>16;var h=65535&i.high;var o=i.low>>>16;var u=65535&i.low;var g=0,f=0,a=0,l=0;l+=s+u;a+=l>>>16;l&=65535;a+=r+o;f+=a>>>16;a&=65535;f+=n+h;g+=f>>>16;f&=65535;g+=t+e;g&=65535;return fromBits(a<<16|l,g<<16|f,this.unsigned)};
/**
 * Returns the difference of this and the specified Long.
 * @this {!Long}
 * @param {!Long|number|string} subtrahend Subtrahend
 * @returns {!Long} Difference
 */L.subtract=function subtract(i){isLong(i)||(i=fromValue(i));return this.add(i.neg())};
/**
 * Returns the difference of this and the specified Long. This is an alias of {@link Long#subtract}.
 * @function
 * @param {!Long|number|string} subtrahend Subtrahend
 * @returns {!Long} Difference
 */L.sub=L.subtract;
/**
 * Returns the product of this and the specified Long.
 * @this {!Long}
 * @param {!Long|number|string} multiplier Multiplier
 * @returns {!Long} Product
 */L.multiply=function multiply(t){if(this.isZero())return this;isLong(t)||(t=fromValue(t));if(i){var n=i.mul(this.low,this.high,t.low,t.high);return fromBits(n,i.get_high(),this.unsigned)}if(t.isZero())return this.unsigned?a:f;if(this.eq(w))return t.isOdd()?w:f;if(t.eq(w))return this.isOdd()?w:f;if(this.isNegative())return t.isNegative()?this.neg().mul(t.neg()):this.neg().mul(t).neg();if(t.isNegative())return this.mul(t.neg()).neg();if(this.lt(g)&&t.lt(g))return fromNumber(this.toNumber()*t.toNumber(),this.unsigned);var r=this.high>>>16;var s=65535&this.high;var e=this.low>>>16;var h=65535&this.low;var o=t.high>>>16;var u=65535&t.high;var l=t.low>>>16;var m=65535&t.low;var d=0,v=0,c=0,L=0;L+=h*m;c+=L>>>16;L&=65535;c+=e*m;v+=c>>>16;c&=65535;c+=h*l;v+=c>>>16;c&=65535;v+=s*m;d+=v>>>16;v&=65535;v+=e*l;d+=v>>>16;v&=65535;v+=h*u;d+=v>>>16;v&=65535;d+=r*m+s*l+e*u+h*o;d&=65535;return fromBits(c<<16|L,d<<16|v,this.unsigned)};
/**
 * Returns the product of this and the specified Long. This is an alias of {@link Long#multiply}.
 * @function
 * @param {!Long|number|string} multiplier Multiplier
 * @returns {!Long} Product
 */L.mul=L.multiply;
/**
 * Returns this Long divided by the specified. The result is signed if this Long is signed or
 *  unsigned if this Long is unsigned.
 * @this {!Long}
 * @param {!Long|number|string} divisor Divisor
 * @returns {!Long} Quotient
 */L.divide=function divide(t){isLong(t)||(t=fromValue(t));if(t.isZero())throw Error("division by zero");if(i){if(!this.unsigned&&-2147483648===this.high&&-1===t.low&&-1===t.high)return this;var n=(this.unsigned?i.div_u:i.div_s)(this.low,this.high,t.low,t.high);return fromBits(n,i.get_high(),this.unsigned)}if(this.isZero())return this.unsigned?a:f;var s,e,h;if(this.unsigned){t.unsigned||(t=t.toUnsigned());if(t.gt(this))return a;if(t.gt(this.shru(1)))return m;h=a}else{if(this.eq(w)){if(t.eq(l)||t.eq(d))return w;if(t.eq(w))return l;var o=this.shr(1);s=o.div(t).shl(1);if(s.eq(f))return t.isNegative()?l:d;e=this.sub(t.mul(s));h=s.add(e.div(t));return h}if(t.eq(w))return this.unsigned?a:f;if(this.isNegative())return t.isNegative()?this.neg().div(t.neg()):this.neg().div(t).neg();if(t.isNegative())return this.div(t.neg()).neg();h=f}e=this;while(e.gte(t)){s=Math.max(1,Math.floor(e.toNumber()/t.toNumber()));var u=Math.ceil(Math.log(s)/Math.LN2),g=u<=48?1:r(2,u-48),v=fromNumber(s),c=v.mul(t);while(c.isNegative()||c.gt(e)){s-=g;v=fromNumber(s,this.unsigned);c=v.mul(t)}v.isZero()&&(v=l);h=h.add(v);e=e.sub(c)}return h};
/**
 * Returns this Long divided by the specified. This is an alias of {@link Long#divide}.
 * @function
 * @param {!Long|number|string} divisor Divisor
 * @returns {!Long} Quotient
 */L.div=L.divide;
/**
 * Returns this Long modulo the specified.
 * @this {!Long}
 * @param {!Long|number|string} divisor Divisor
 * @returns {!Long} Remainder
 */L.modulo=function modulo(t){isLong(t)||(t=fromValue(t));if(i){var n=(this.unsigned?i.rem_u:i.rem_s)(this.low,this.high,t.low,t.high);return fromBits(n,i.get_high(),this.unsigned)}return this.sub(this.div(t).mul(t))};
/**
 * Returns this Long modulo the specified. This is an alias of {@link Long#modulo}.
 * @function
 * @param {!Long|number|string} divisor Divisor
 * @returns {!Long} Remainder
 */L.mod=L.modulo;
/**
 * Returns this Long modulo the specified. This is an alias of {@link Long#modulo}.
 * @function
 * @param {!Long|number|string} divisor Divisor
 * @returns {!Long} Remainder
 */L.rem=L.modulo;
/**
 * Returns the bitwise NOT of this Long.
 * @this {!Long}
 * @returns {!Long}
 */L.not=function not(){return fromBits(~this.low,~this.high,this.unsigned)};
/**
 * Returns count leading zeros of this Long.
 * @this {!Long}
 * @returns {!number}
 */L.countLeadingZeros=function countLeadingZeros(){return this.high?Math.clz32(this.high):Math.clz32(this.low)+32};
/**
 * Returns count leading zeros. This is an alias of {@link Long#countLeadingZeros}.
 * @function
 * @param {!Long}
 * @returns {!number}
 */L.clz=L.countLeadingZeros;
/**
 * Returns count trailing zeros of this Long.
 * @this {!Long}
 * @returns {!number}
 */L.countTrailingZeros=function countTrailingZeros(){return this.low?ctz32(this.low):ctz32(this.high)+32};
/**
 * Returns count trailing zeros. This is an alias of {@link Long#countTrailingZeros}.
 * @function
 * @param {!Long}
 * @returns {!number}
 */L.ctz=L.countTrailingZeros;
/**
 * Returns the bitwise AND of this Long and the specified.
 * @this {!Long}
 * @param {!Long|number|string} other Other Long
 * @returns {!Long}
 */L.and=function and(i){isLong(i)||(i=fromValue(i));return fromBits(this.low&i.low,this.high&i.high,this.unsigned)};
/**
 * Returns the bitwise OR of this Long and the specified.
 * @this {!Long}
 * @param {!Long|number|string} other Other Long
 * @returns {!Long}
 */L.or=function or(i){isLong(i)||(i=fromValue(i));return fromBits(this.low|i.low,this.high|i.high,this.unsigned)};
/**
 * Returns the bitwise XOR of this Long and the given one.
 * @this {!Long}
 * @param {!Long|number|string} other Other Long
 * @returns {!Long}
 */L.xor=function xor(i){isLong(i)||(i=fromValue(i));return fromBits(this.low^i.low,this.high^i.high,this.unsigned)};
/**
 * Returns this Long with bits shifted to the left by the given amount.
 * @this {!Long}
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Shifted Long
 */L.shiftLeft=function shiftLeft(i){isLong(i)&&(i=i.toInt());return 0===(i&=63)?this:i<32?fromBits(this.low<<i,this.high<<i|this.low>>>32-i,this.unsigned):fromBits(0,this.low<<i-32,this.unsigned)};
/**
 * Returns this Long with bits shifted to the left by the given amount. This is an alias of {@link Long#shiftLeft}.
 * @function
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Shifted Long
 */L.shl=L.shiftLeft;
/**
 * Returns this Long with bits arithmetically shifted to the right by the given amount.
 * @this {!Long}
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Shifted Long
 */L.shiftRight=function shiftRight(i){isLong(i)&&(i=i.toInt());return 0===(i&=63)?this:i<32?fromBits(this.low>>>i|this.high<<32-i,this.high>>i,this.unsigned):fromBits(this.high>>i-32,this.high>=0?0:-1,this.unsigned)};
/**
 * Returns this Long with bits arithmetically shifted to the right by the given amount. This is an alias of {@link Long#shiftRight}.
 * @function
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Shifted Long
 */L.shr=L.shiftRight;
/**
 * Returns this Long with bits logically shifted to the right by the given amount.
 * @this {!Long}
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Shifted Long
 */L.shiftRightUnsigned=function shiftRightUnsigned(i){isLong(i)&&(i=i.toInt());return 0===(i&=63)?this:i<32?fromBits(this.low>>>i|this.high<<32-i,this.high>>>i,this.unsigned):fromBits(32===i?this.high:this.high>>>i-32,0,this.unsigned)};
/**
 * Returns this Long with bits logically shifted to the right by the given amount. This is an alias of {@link Long#shiftRightUnsigned}.
 * @function
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Shifted Long
 */L.shru=L.shiftRightUnsigned;
/**
 * Returns this Long with bits logically shifted to the right by the given amount. This is an alias of {@link Long#shiftRightUnsigned}.
 * @function
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Shifted Long
 */L.shr_u=L.shiftRightUnsigned;
/**
 * Returns this Long with bits rotated to the left by the given amount.
 * @this {!Long}
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Rotated Long
 */L.rotateLeft=function rotateLeft(i){var t;isLong(i)&&(i=i.toInt());if(0===(i&=63))return this;if(32===i)return fromBits(this.high,this.low,this.unsigned);if(i<32){t=32-i;return fromBits(this.low<<i|this.high>>>t,this.high<<i|this.low>>>t,this.unsigned)}i-=32;t=32-i;return fromBits(this.high<<i|this.low>>>t,this.low<<i|this.high>>>t,this.unsigned)};
/**
 * Returns this Long with bits rotated to the left by the given amount. This is an alias of {@link Long#rotateLeft}.
 * @function
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Rotated Long
 */L.rotl=L.rotateLeft;
/**
 * Returns this Long with bits rotated to the right by the given amount.
 * @this {!Long}
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Rotated Long
 */L.rotateRight=function rotateRight(i){var t;isLong(i)&&(i=i.toInt());if(0===(i&=63))return this;if(32===i)return fromBits(this.high,this.low,this.unsigned);if(i<32){t=32-i;return fromBits(this.high<<t|this.low>>>i,this.low<<t|this.high>>>i,this.unsigned)}i-=32;t=32-i;return fromBits(this.low<<t|this.high>>>i,this.high<<t|this.low>>>i,this.unsigned)};
/**
 * Returns this Long with bits rotated to the right by the given amount. This is an alias of {@link Long#rotateRight}.
 * @function
 * @param {number|!Long} numBits Number of bits
 * @returns {!Long} Rotated Long
 */L.rotr=L.rotateRight;
/**
 * Converts this Long to signed.
 * @this {!Long}
 * @returns {!Long} Signed long
 */L.toSigned=function toSigned(){return this.unsigned?fromBits(this.low,this.high,false):this};
/**
 * Converts this Long to unsigned.
 * @this {!Long}
 * @returns {!Long} Unsigned long
 */L.toUnsigned=function toUnsigned(){return this.unsigned?this:fromBits(this.low,this.high,true)};
/**
 * Converts this Long to its byte representation.
 * @param {boolean=} le Whether little or big endian, defaults to big endian
 * @this {!Long}
 * @returns {!Array.<number>} Byte representation
 */L.toBytes=function toBytes(i){return i?this.toBytesLE():this.toBytesBE()};
/**
 * Converts this Long to its little endian byte representation.
 * @this {!Long}
 * @returns {!Array.<number>} Little endian byte representation
 */L.toBytesLE=function toBytesLE(){var i=this.high,t=this.low;return[255&t,t>>>8&255,t>>>16&255,t>>>24,255&i,i>>>8&255,i>>>16&255,i>>>24]};
/**
 * Converts this Long to its big endian byte representation.
 * @this {!Long}
 * @returns {!Array.<number>} Big endian byte representation
 */L.toBytesBE=function toBytesBE(){var i=this.high,t=this.low;return[i>>>24,i>>>16&255,i>>>8&255,255&i,t>>>24,t>>>16&255,t>>>8&255,255&t]};
/**
 * Creates a Long from its byte representation.
 * @param {!Array.<number>} bytes Byte representation
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @param {boolean=} le Whether little or big endian, defaults to big endian
 * @returns {Long} The corresponding Long value
 */Long.fromBytes=function fromBytes(i,t,n){return n?Long.fromBytesLE(i,t):Long.fromBytesBE(i,t)};
/**
 * Creates a Long from its little endian byte representation.
 * @param {!Array.<number>} bytes Little endian byte representation
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @returns {Long} The corresponding Long value
 */Long.fromBytesLE=function fromBytesLE(i,t){return new Long(i[0]|i[1]<<8|i[2]<<16|i[3]<<24,i[4]|i[5]<<8|i[6]<<16|i[7]<<24,t)};
/**
 * Creates a Long from its big endian byte representation.
 * @param {!Array.<number>} bytes Big endian byte representation
 * @param {boolean=} unsigned Whether unsigned or not, defaults to signed
 * @returns {Long} The corresponding Long value
 */Long.fromBytesBE=function fromBytesBE(i,t){return new Long(i[4]<<24|i[5]<<16|i[6]<<8|i[7],i[0]<<24|i[1]<<16|i[2]<<8|i[3],t)};export{Long as default};

