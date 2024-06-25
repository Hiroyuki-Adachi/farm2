import{_ as r}from"./_/70531f52.js";import"./_/bc3c29ea.js";import"./isArray.js";import"./isSymbol.js";import"./_/052e9e66.js";import"./_/e65ed236.js";import"./_/b15bba73.js";import"./isObjectLike.js";import"./_stringToPath.js";import"./memoize.js";import"./_/9e9ce10f.js";import"./_/70a2d34d.js";import"./_/58273e1c.js";import"./isFunction.js";import"./isObject.js";import"./eq.js";import"./_/38d0670d.js";import"./toString.js";import"./_/e4fbb684.js";import"./_arrayMap.js";import"./isArguments.js";import"./_isIndex.js";import"./isLength.js";import"./_toKey.js";var t={};var s=Object.prototype;var i=s.hasOwnProperty;
/**
 * The base implementation of `_.has` without support for deep paths.
 *
 * @private
 * @param {Object} [object] The object to query.
 * @param {Array|string} key The key to check.
 * @returns {boolean} Returns `true` if `key` exists, else `false`.
 */function baseHas$1(r,t){return null!=r&&i.call(r,t)}t=baseHas$1;var o=t;var m={};var p=o,e=r;
/**
 * Checks if `path` is a direct property of `object`.
 *
 * @static
 * @since 0.1.0
 * @memberOf _
 * @category Object
 * @param {Object} object The object to query.
 * @param {Array|string} path The path to check.
 * @returns {boolean} Returns `true` if `path` exists, else `false`.
 * @example
 *
 * var object = { 'a': { 'b': 2 } };
 * var other = _.create({ 'a': _.create({ 'b': 2 }) });
 *
 * _.has(object, 'a');
 * // => true
 *
 * _.has(object, 'a.b');
 * // => true
 *
 * _.has(object, ['a', 'b']);
 * // => true
 *
 * _.has(other, 'a');
 * // => false
 */function has(r,t){return null!=r&&e(r,t,p)}m=has;var j=m;export{j as default};

