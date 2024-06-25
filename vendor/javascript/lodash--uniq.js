import{_ as r}from"./_/52b82883.js";import"./_/202e3ffb.js";import"./_/9e9ce10f.js";import"./_/70a2d34d.js";import"./_/58273e1c.js";import"./isFunction.js";import"./_/052e9e66.js";import"./_/e65ed236.js";import"./_/b15bba73.js";import"./isObject.js";import"./eq.js";import"./_/38d0670d.js";import"./_/fb0913df.js";import"./_baseIndexOf.js";import"./_/845c0fe8.js";import"./_/d1de5e0a.js";import"./_/0329f27f.js";import"./_/88299394.js";import"./noop.js";import"./_/2eee999b.js";var t={};var i=r;
/**
 * Creates a duplicate-free version of an array, using
 * [`SameValueZero`](http://ecma-international.org/ecma-262/7.0/#sec-samevaluezero)
 * for equality comparisons, in which only the first occurrence of each element
 * is kept. The order of result values is determined by the order they occur
 * in the array.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Array
 * @param {Array} array The array to inspect.
 * @returns {Array} Returns the new duplicate free array.
 * @example
 *
 * _.uniq([2, 1, 2]);
 * // => [2, 1]
 */function uniq(r){return r&&r.length?i(r):[]}t=uniq;var o=t;export{o as default};

