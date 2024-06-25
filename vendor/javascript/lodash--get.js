import{_ as r}from"./_/1041f72c.js";import"./_/bc3c29ea.js";import"./isArray.js";import"./isSymbol.js";import"./_/052e9e66.js";import"./_/e65ed236.js";import"./_/b15bba73.js";import"./isObjectLike.js";import"./_stringToPath.js";import"./memoize.js";import"./_/9e9ce10f.js";import"./_/70a2d34d.js";import"./_/58273e1c.js";import"./isFunction.js";import"./isObject.js";import"./eq.js";import"./_/38d0670d.js";import"./toString.js";import"./_/e4fbb684.js";import"./_arrayMap.js";import"./_toKey.js";var t={};var i=r;
/**
 * Gets the value at `path` of `object`. If the resolved value is
 * `undefined`, the `defaultValue` is returned in its place.
 *
 * @static
 * @memberOf _
 * @since 3.7.0
 * @category Object
 * @param {Object} object The object to query.
 * @param {Array|string} path The path of the property to get.
 * @param {*} [defaultValue] The value returned for `undefined` resolved values.
 * @returns {*} Returns the resolved value.
 * @example
 *
 * var object = { 'a': [{ 'b': { 'c': 3 } }] };
 *
 * _.get(object, 'a[0].b.c');
 * // => 3
 *
 * _.get(object, ['a', '0', 'b', 'c']);
 * // => 3
 *
 * _.get(object, 'a.b.c', 'default');
 * // => 'default'
 */function get(r,t,o){var s=null==r?void 0:i(r,t);return void 0===s?o:s}t=get;var o=t;export{o as default};

