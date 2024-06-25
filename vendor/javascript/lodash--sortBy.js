import{_ as r}from"./_/4dae2565.js";import{_ as t}from"./_/5f98df2a.js";import s from"./_baseRest.js";import{_ as i}from"./_/7781ca7a.js";import"./_/0d4c4e14.js";import"./_/e65ed236.js";import"./_/b15bba73.js";import"./isArguments.js";import"./_/052e9e66.js";import"./isObjectLike.js";import"./isArray.js";import"./_arrayMap.js";import"./_/1041f72c.js";import"./_/bc3c29ea.js";import"./isSymbol.js";import"./_stringToPath.js";import"./memoize.js";import"./_/9e9ce10f.js";import"./_/70a2d34d.js";import"./_/58273e1c.js";import"./isFunction.js";import"./isObject.js";import"./eq.js";import"./_/38d0670d.js";import"./toString.js";import"./_/e4fbb684.js";import"./_toKey.js";import"./_baseIteratee.js";import"./_/8ebfb7da.js";import"./_/28307068.js";import"./_Stack.js";import"./_/af3602f5.js";import"./_/202e3ffb.js";import"./_/8ae180c0.js";import"./_/2d8124ce.js";import"./_/2eee999b.js";import"./_/daaca3a5.js";import"./_/bd638668.js";import"./_arrayFilter.js";import"./stubArray.js";import"./keys.js";import"./_/d533f765.js";import"./_/c8441f51.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/dcdb9fca.js";import"./_/9f64fdae.js";import"./_/27d5b997.js";import"./_/1d469fdd.js";import"./_/d2b8ecf6.js";import"./isArrayLike.js";import"./_getTag.js";import"./_Promise.js";import"./_/88299394.js";import"./_/7efbe7b0.js";import"./_/2bd9b4ce.js";import"./_/56083916.js";import"./_/c4c1a0d8.js";import"./get.js";import"./hasIn.js";import"./_/70531f52.js";import"./identity.js";import"./property.js";import"./_baseProperty.js";import"./_/59eaf1c8.js";import"./_/de2b55d3.js";import"./_baseForOwn.js";import"./_/d603d993.js";import"./_/ae1a03d5.js";import"./_/3edfb04c.js";import"./_/cf78169b.js";import"./_overRest.js";import"./_apply.js";import"./_/ead8ed36.js";import"./constant.js";import"./_/d35a7fd6.js";var o={};var m=r,p=t,j=s,e=i;
/**
 * Creates an array of elements, sorted in ascending order by the results of
 * running each element in a collection thru each iteratee. This method
 * performs a stable sort, that is, it preserves the original sort order of
 * equal elements. The iteratees are invoked with one argument: (value).
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Collection
 * @param {Array|Object} collection The collection to iterate over.
 * @param {...(Function|Function[])} [iteratees=[_.identity]]
 *  The iteratees to sort by.
 * @returns {Array} Returns the new sorted array.
 * @example
 *
 * var users = [
 *   { 'user': 'fred',   'age': 48 },
 *   { 'user': 'barney', 'age': 36 },
 *   { 'user': 'fred',   'age': 30 },
 *   { 'user': 'barney', 'age': 34 }
 * ];
 *
 * _.sortBy(users, [function(o) { return o.user; }]);
 * // => objects for [['barney', 36], ['barney', 34], ['fred', 48], ['fred', 30]]
 *
 * _.sortBy(users, ['user', 'age']);
 * // => objects for [['barney', 34], ['barney', 36], ['fred', 30], ['fred', 48]]
 */var _=j((function(r,t){if(null==r)return[];var s=t.length;s>1&&e(r,t[0],t[1])?t=[]:s>2&&e(t[0],t[1],t[2])&&(t=[t[0]]);return p(r,m(t,1),[])}));o=_;var a=o;export{a as default};

