import{_ as r}from"./_/fdfcc43e.js";import{_ as t}from"./_/7781ca7a.js";import i from"./toInteger.js";import o from"./toString.js";import"./eq.js";import"./isArrayLike.js";import"./isFunction.js";import"./_/052e9e66.js";import"./_/e65ed236.js";import"./_/b15bba73.js";import"./isObject.js";import"./isLength.js";import"./_isIndex.js";import"./toFinite.js";import"./toNumber.js";import"./_/83742462.js";import"./_/69d56582.js";import"./isSymbol.js";import"./isObjectLike.js";import"./_/e4fbb684.js";import"./_arrayMap.js";import"./isArray.js";var s={};var m=r,p=t,e=i,j=o;
/**
 * Repeats the given string `n` times.
 *
 * @static
 * @memberOf _
 * @since 3.0.0
 * @category String
 * @param {string} [string=''] The string to repeat.
 * @param {number} [n=1] The number of times to repeat the string.
 * @param- {Object} [guard] Enables use as an iteratee for methods like `_.map`.
 * @returns {string} Returns the repeated string.
 * @example
 *
 * _.repeat('*', 3);
 * // => '***'
 *
 * _.repeat('abc', 2);
 * // => 'abcabc'
 *
 * _.repeat('abc', 0);
 * // => ''
 */function repeat(r,t,i){t=(i?p(r,t,i):void 0===t)?1:e(t);return m(j(r),t)}s=repeat;var a=s;export{a as default};

