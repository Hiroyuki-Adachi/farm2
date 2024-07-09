import*as t from"@tensorflow/tfjs-core";import{backend as e,tidy as s,zerosLike as n,onesLike as i,where as a,tensor1d as r,scalar as o,serialization as l,zeros as u,ones as h,mul as c,randomUniform as p,truncatedNormal as d,eye as g,util as m,linalg as f,variableGrads as y,cast as b,dispose as w,memory as S,env as C,add as z,div as N,keep as k,nextFrame as v,train as A,clone as x,argMax as I,reshape as L,Tensor as D,Optimizer as T,io as E,abs as R,sum as $,relu as M,clipByValue as O,leakyRelu as F,prelu as _,elu as P,greater as U,sub as B,logSumExp as W,exp as V,transpose as j,notEqual as q,any as G,greaterEqual as H,moments as J,image as Z,stack as K,tensor as Y,range as X,unstack as Q,expandDims as tt,denseBincount as et,max as st,min as nt}from"@tensorflow/tfjs-core";import{c as it,V as at,N as rt,d as ot,s as lt,t as ut,R as ht,a as ct,A as pt,b as dt,e as gt,f as mt,u as ft,r as yt,p as bt,i as wt,g as St,h as Ct,j as zt,k as Nt,m as kt}from"../_/GKKh8bbh.js";import"@tensorflow/tfjs-core/dist/register_all_gradients";import{deserialize as vt}from"./layers/serialization.js";import{convertTsToPythonic as At,convertPythonicToTs as xt}from"./utils/serialization_utils.js";
/**
 * @license
 * Copyright 2022 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class LruCache{constructor(t){this.maxEntries=t||100;this.cache=new Map}get(t){let e;if(this.cache.has(t)){e=this.cache.get(t);this.cache.delete(t);this.cache.set(t,e)}return e}put(t,e){if(this.cache.has(t))this.cache.delete(t);else if(this.cache.size>=this.maxEntries){const t=this.cache.keys().next().value;this.cache.delete(t)}this.cache.set(t,e)}getMaxEntries(){return this.maxEntries}setMaxEntries(t){if(t<0)throw new Error(`The maxEntries of LRU caches must be at least 0, but got ${t}.`);if(this.maxEntries>t)for(let e=0;e<this.maxEntries-t;e++){const t=this.cache.keys().next().value;this.cache.delete(t)}this.maxEntries=t}}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */let It=0;function getNextUniqueTensorId(){return It++}const Lt={};
/**
 * Provides a unique UID given a string prefix.
 *
 * @param prefix
 */function getUid(t=""){t in Lt||(Lt[t]=0);Lt[t]+=1;return t+Lt[t].toString()}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const Dt=["channelsFirst","channelsLast"];const Tt=["nearest","bilinear"];const Et=["valid","same","causal"];const Rt=["max","avg"];const $t=["sum","mul","concat","ave"];
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
const Mt=new Map;function checkDataFormat(t){it(Dt,"DataFormat",t)}function checkInterpolationFormat(t){it(Tt,"InterpolationFormat",t)}function checkPaddingMode(t){it(Et,"PaddingMode",t)}function checkPoolMode(t){it(Rt,"PoolMode",t)}const Ot=[];const Ft="/";function nameScope(t,e){Ot.push(t);try{const t=e();Ot.pop();return t}catch(t){Ot.pop();throw t}}function currentNameScopePrefix(){return Ot.length===0?"":Ot.join(Ft)+Ft}
/**
 * Get the name a Tensor (or Variable) would have if not uniqueified.
 * @param tensorName
 * @return Scoped name string.
 */function getScopedTensorName(t){if(!isValidTensorName(t))throw new Error("Not a valid tensor name: '"+t+"'");return currentNameScopePrefix()+t}
/**
 * Get unique names for Tensors and Variables.
 * @param scopedName The fully-qualified name of the Tensor, i.e. as produced by
 *  `getScopedTensorName()`.
 * @return A unique version of the given fully scoped name.
 *   If this is the first time that the scoped name is seen in this session,
 *   then the given `scopedName` is returned unaltered.  If the same name is
 *   seen again (producing a collision), an incrementing suffix is added to the
 *   end of the name, so it takes the form 'scope/name_1', 'scope/name_2', etc.
 */function getUniqueTensorName(t){if(!isValidTensorName(t))throw new Error("Not a valid tensor name: '"+t+"'");Mt.has(t)||Mt.set(t,0);const e=Mt.get(t);Mt.set(t,Mt.get(t)+1);if(e>0){const s=`${t}_${e}`;Mt.set(s,1);return s}return t}const _t=new RegExp(/^[A-Za-z0-9][-A-Za-z0-9\._\/]*$/);
/**
 * Determine whether a string is a valid tensor name.
 * @param name
 * @returns A Boolean indicating whether `name` is a valid tensor name.
 */function isValidTensorName(t){return!!t.match(_t)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function isInteger(t){return t===parseInt(t.toString(),10)}
/**
 * Calculate the product of an array of numbers.
 * @param array The array to calculate the product over.
 * @param begin Beginning index, inclusive.
 * @param end Ending index, exclusive.
 * @return The product.
 */function arrayProd(t,e,s){e==null&&(e=0);s==null&&(s=t.length);let n=1;for(let i=e;i<s;++i)n*=t[i];return n}
/**
 * Compute minimum value.
 * @param array
 * @return minimum value.
 */function min(t){if(t.length===0)return Number.NaN;let e=Number.POSITIVE_INFINITY;for(let s=0;s<t.length;s++){const n=t[s];n<e&&(e=n)}return e}
/**
 * Compute maximum value.
 * @param array
 * @return maximum value
 */function max(t){if(t.length===0)return Number.NaN;let e=Number.NEGATIVE_INFINITY;for(let s=0;s<t.length;s++){const n=t[s];n>e&&(e=n)}return e}
/**
 * Compute sum of array.
 * @param array
 * @return The sum.
 */
/**
 * Generate an array of integers in [begin, end).
 * @param begin Beginning integer, inclusive.
 * @param end Ending integer, exclusive.
 * @returns Range array.
 * @throws ValueError, iff `end` < `begin`.
 */
function range(t,e){if(e<t)throw new at(`end (${e}) < begin (${t}) is forbidden.`);const s=[];for(let n=t;n<e;++n)s.push(n);return s}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */let Pt;function epsilon(){Pt==null&&(Pt=e().epsilon());return Pt}
/**
 * Sets the value of the fuzz factor used in numeric expressions.
 * @param e New value of epsilon.
 */function imageDataFormat(){return"channelsLast"}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Casts a tensor to a different dtype and returns it.
 * @param x Input tensor.
 * @param dtype String: 'float32'|'int32'|'bool'.
 * @returns Tensor of the specified `dtype`.
 */
function cast(e,s){return t.cast(e,s)}
/**
 * Adds a 1-sized dimension at index "axis".
 * @param x Input tensor.
 * @param axis Position where to add the new axis.
 * @returns Result of the dimension expansion.
 */function expandDims(e,s=-1){const n=e.shape.slice();s<0&&(s=n.length+s+1);n.splice(s,0,1);return t.reshape(e,n)}
/**
 * Repeats a 2D tensor.
 *
 * If `x` has shape `[samples, dim]` and `n` is 2, for example, the output
 * will have shape `[samples, 2, dim]`.
 *
 * @param x Input tensor.
 * @param n Integer, number of times to repeat.
 * @returns The result of the repeat operation.
 * @throws ValueError: If input tensor is not 2D.
 */function repeat(t,e){return s((()=>{if(t.shape.length!==2)throw new at(`repeat() expects a rank-2 tensor, but received a rank-${t.shape.length} tensor.`);const s=expandDims(t,1);return tile(s,[1,e,1])}))}
/**
 * Flatten a Tensor into 1D.
 * @param x Input tensor.
 * @return The result of the flattening `x`.
 */function flatten$1(e){const s=[arrayProd(e.shape)];return t.reshape(e,s)}
/**
 * Turn a nD tensor into a 2D tensor with same 0th dimension.
 * In other words, it flattens each data samples of a batch.
 *
 * @param x The tensor to flatten. The rank of this tensor is required to be 2
 *   or higher.
 * @return The result of the flattening.
 */function batchFlatten(e){if(e.rank<=1)throw new at(`batchFlatten requires a minimum rank of 2. Got rank: ${e.rank}.`);const s=[e.shape[0],arrayProd(e.shape,1)];return t.reshape(e,s)}
/**
 * Do slicing along the first axis.
 * @param array input `tf.Tensor`.
 * @param start starting index, inclusive.
 * @param size size of the slice along the first axis.
 * @returns result of the slicing.
 * @throws ValueError: If `array` is of an unsupported subtype of `tf.Tensor`.
 */function sliceAlongFirstAxis(e,n,i){return s((()=>{switch(e.rank){case 1:return t.slice1d(e,n,i);case 2:return t.slice2d(e,[n,0],[i,e.shape[1]]);case 3:return t.slice3d(e,[n,0,0],[i,e.shape[1],e.shape[2]]);case 4:return t.slice4d(e,[n,0,0,0],[i,e.shape[1],e.shape[2],e.shape[3]]);case 5:return t.slice(e,[n,0,0,0,0],[i,e.shape[1],e.shape[2],e.shape[3],e.shape[4]]);case 6:return t.slice(e,[n,0,0,0,0,0],[i,e.shape[1],e.shape[2],e.shape[3],e.shape[4],e.shape[5]]);default:throw new at(`sliceAlongFirstAxis() received an unsupported tensor rank: ${e.rank}`)}}))}
/**
 * Do slicing along the last axis.
 * @param array input `tf.Tensor`.
 * @param start starting index, inclusive.
 * @param size size of the slice along the last axis.
 * @returns result of the slicing.
 * @throws ValueError: If `array` is of an unsupported subtype of `tf.Tensor`.
 */function sliceAlongLastAxis(e,n,i){return s((()=>{switch(e.rank){case 1:return t.slice1d(e,n,i);case 2:return t.slice2d(e,[0,n],[e.shape[0],i]);case 3:return t.slice3d(e,[0,0,n],[e.shape[0],e.shape[1],i]);case 4:return t.slice4d(e,[0,0,0,n],[e.shape[0],e.shape[1],e.shape[2],i]);default:throw new at(`sliceAlongLastAxis() received an unsupported tensor rank: ${e.rank}`)}}))}
/**
 * Do slicing along the sepcified axis.
 * @param array input `tf.Tensor`.
 * @param start starting index, inclusive.
 * @param size of the slice along the chosen axis.
 * @param choose an axis.
 * @returns result of the slicing.
 * @throws ValueError: If `array` is of an unsupported subtype of `tf.Tensor`.
 */function sliceAlongAxis(e,n,i,a){return s((()=>{switch(e.rank){case 1:return t.slice1d(e,n,i);case 2:switch(a){case 1:return sliceAlongFirstAxis(e,n,i);case 2:return sliceAlongLastAxis(e,n,i);default:throw new at(`The axis is not within the rank of the tensor ${a}`)}case 3:switch(a){case 1:return sliceAlongFirstAxis(e,n,i);case 2:return t.slice3d(e,[0,n,0],[e.shape[0],i,e.shape[2]]);case 3:return sliceAlongLastAxis(e,n,i);default:throw new at(`The axis is not within the rank of the tensor ${a}`)}case 4:switch(a){case 1:return sliceAlongFirstAxis(e,n,i);case 2:return t.slice4d(e,[0,n,0,0],[e.shape[0],i,e.shape[2],e.shape[3]]);case 3:return t.slice4d(e,[0,0,n,0],[e.shape[0],e.shape[1],i,e.shape[3]]);case 4:return sliceAlongLastAxis(e,n,i);default:throw new at(`The axis is not within the rank of the tensor ${a}`)}default:throw new at(`sliceAlongLastAxis() received an unsupported tensor rank: ${e.rank}`)}}))}
/**
 * Concatenates a list of tensors alongside the specified axis.
 * @param tensors `Array` of tensors to concatenate.
 * @param axis Concatenation axis.
 * @returns The result of the concatenation.
 */function concatenate$2(e,s=-1){let n;if(s<0){n=e[0].rank;s=n!==0?n:0}s===e[0].rank&&(s=-1);return t.concat(e,s)}
/**
 * Concatenate two arrays along the first dimension.
 * @param a The 1st `tf.Tensor` to concatenate.
 * @param b The 2nd `tf.Tensor` to concatenate.
 * @returns Result of the concatenation.
 * @throws ValueError: If `a` is of an unsupported subtype of `tf.Tensor`.
 */function concatAlongFirstAxis(e,s){switch(e.rank){case 1:return t.concat1d([e,s]);case 2:return t.concat2d([e,s],0);case 3:return t.concat3d([e,s],0);case 4:return t.concat4d([e,s],0);default:throw new at(`concatAlongFirstAxis() received an unsupported tensor rank: ${e.rank}`)}}
/**
 * Creates a tensor by tiling `x` by `n`.
 * @param x A tensor.
 * @param n An Array of integers or a single integer. If an Array, the length
 *   must be the same as the number of dimensions in `x`. If a single integer,
 *   it will be treated as an Array of length 1.
 */function tile(e,s){Array.isArray(s)||(s=[s]);if(e.rank!==s.length)throw new at(`The length of input n (${s.length}) does not match the number of dimensions in input x (${e.rank})`);return t.tile(e,s)}
/**
 * Get a tensor with normal distribution of values.
 *
 * @param shape Shape of the tensor.
 * @param mean mean value of the normal distribution.
 * @param stddev standard deviation of the normal distribution.
 * @param dtype
 * @param seed
 * @return The normal tensor.
 */function randomNormal$1(e,s=0,n=1,i,a){return t.randomNormal(e,s,n,i,a)}
/**
 * Multiply two tensors and returns the result as a tensor.
 *
 * For 2D tensors, this is equivalent to matrix multiplication (matMul).
 * For tensors of higher ranks, it follows the Theano behavior,
 * (e.g. `(2, 3) * (4, 3, 5) -> (2, 4, 5)`).  From the Theano documentation:
 *
 * For N dimensions it is a sum product over the last axis of x and the
 * second-to-last of y:
 *
 * @param a A tensor of at least rank 2.
 * @param b A tensor of at least rank 2.
 * @param activation (optional) A string identifying the activation
 *   function.
 * @return Result of the dot operation.
 */function dot$1(e,s,n,i){if(e.rank<2||s.rank<2)throw new rt(`dot requires both inputs to be rank >= 2 but got x shape = ${e.shape} and y shape = ${s.shape}`);if(s.rank>=3){const t=e.shape.slice(-1)[0];const n=s.shape.slice(-2)[0];if(t!==n)throw new rt(`If rank y >= 3, then the second last dim of y must equal the last dim of x but got x shape = ${e.shape} and  y shape = ${s.shape}`)}if(e.rank===2&&s.rank===2){const a=false;const r=false;return t.fused.matMul({a:e,b:s,transposeA:a,transposeB:r,bias:i?reshapeBias(e.rank,i,imageDataFormat()):null,activation:n})}{const a=e.shape.slice();const r=a.pop();e=t.reshape(e,[-1,r]);const o=s.shape.slice();const l=o.pop();const u=o.pop();const h=[...o,l];const c=Array.from({length:s.rank},((t,e)=>e===0?s.rank-2:e<=s.rank-2?e-1:e));s=t.reshape(t.transpose(s,c),[u,-1]);const p=[...a,...h];const d=false;const g=false;return t.reshape(t.fused.matMul({a:e,b:s,transposeA:d,transposeB:g,bias:i?reshapeBias(e.rank,i,imageDataFormat()):null,activation:n}),p)}}
/**
 * Compute the sign Tensor of an input Tensor.
 *
 * Elements of the input `tf.Tensor` that are === 0 are mapped to 0.
 * Elements of the input `tf.Tensor` that are > 0 are mapped to 1.
 * Elements of the input `tf.Tensor` that are < 0 are mapped to -1.
 *
 * @param x Input `tf.Tensor`.
 * @return The sign `tf.Tensor`.
 */
/**
 * Retrieves the elements of indices `indices` in the tensor `reference`.
 * @param reference A tensor.
 * @param indices An integer tensor of indices or an `Array` of integers.
 * @param axis Axis along which to perform the gather operation.
 * @returns The result of the gathering as a tensor.
 */
function gather(e,n,i){return s((()=>{n=Array.isArray(n)?r(n,"int32"):t.cast(n,"int32");return t.gather(e,n,i)}))}
/**
 * Element-wise square.
 * @param x Input tensor.
 * @return element-wise x^2
 */function square(e){return t.mul(e,e)}
/**
 * Element-wise exponentiation.
 *
 * Porting Note: In PyKeras, `a` (the exponent) is a Python integer, which
 *   takes advatnage of the backend's (e.g., TensorFlow's) automatic
 * conversion to tensor. Here we allow `a` to be either a number or a tensor.
 *
 * @param x The base tensor.
 * @param a The exponent, tensor or number. If a number, it is rounded to the
 *   nearest integer and converted to a tensor.
 * @returns A tensor of the same shape as `x`.
 */function reshapeBias(e,s,n){const i=s.shape;if(s.rank!==1&&s.rank!==e)throw new at(`Unexpected bias dimensions: ${s.rank}; expected it to be 1 or ${e}`);if(e===5){if(n==="channelsFirst")return i.length===1?t.reshape(s,[1,i[0],1,1,1]):t.reshape(s,[1,i[3],i[0],i[1],i[2]]);if(n==="channelsLast")return i.length===1?t.reshape(s,[1,1,1,1,i[0]]):t.reshape(s,[1].concat(i))}else if(e===4){if(n==="channelsFirst")return i.length===1?t.reshape(s,[1,i[0],1,1]):t.reshape(s,[1,i[2],i[0],i[1]]);if(n==="channelsLast")return i.length===1?t.reshape(s,[1,1,1,i[0]]):t.reshape(s,[1].concat(i))}else if(e===3){if(n==="channelsFirst")return i.length===1?t.reshape(s,[1,i[0],1]):t.reshape(s,[1,i[1],i[0]]);if(n==="channelsLast")return i.length===1?t.reshape(s,[1,1,i[0]]):t.reshape(s,[1].concat(i))}else if(e<3)return s;throw new at(`Unsupported input rank by biasAdd: ${s.rank}`)}
/**
 * Add a bias to a tensor.
 *
 * @param x The tensor to add the bias to.
 * @param bias The bias to add to `x`. Must be 1D or the same rank as `x`.
 * @return Result of the bias adding.
 * @throws ValueError: If the rank of `bias` is incorrect.
 */function biasAdd(e,n,i){return s((()=>{i==null&&(i=imageDataFormat());checkDataFormat(i);return t.add(e,reshapeBias(e.rank,n,i))}))}
/**
 * Exponential linear unit (ELU).
 * @param x A tensor or variable to compute the activation function for.
 * @param alpha: A scalar, a scaling factor for the negative section.
 * @return Output of the ELU operation.
 */function elu$1(e,s=1){if(s!==1)throw new rt(`Support for alpha values other than 1 (${s}) is not implemented yet.`);return t.elu(e)}
/**
 * Softsign of a tensor.
 *
 * Defined as x / (abs(x) + 1), element-wise.
 *
 * @param x: Input.
 * @returns Output.
 */function softsign(e){return s((()=>t.div(e,t.add(t.abs(e),1))))}
/**
 * Sets entries in `x` to zero at random, while scaling the entire tensor.
 *
 * @param x input tensor.
 * @param level fraction of the entries in the tensor that will be set to 0.
 * @param noiseShape shape of randomly generated keep/drop flags, must be
 *   broadcastable to the shape of `x`. Optional.
 * @param seed random seed to ensure determinism. Optional.
 * @returns Result of the dropout operation.
 */function dropout$1(e,n,i,a){return s((()=>t.dropout(e,n,i,a)))}
/**
 * Element-wise, segment-wise linear approximation of sigmoid.
 *
 * Returns `0.` if `x < -2.5`, `1.` if `x > 2.5`.
 * In `-2.5 <= x <= 2.5`, returns `0.2 * x + 0.5`.
 *
 * @param x Input tensor.
 * @returns Output tensor.
 */function hardSigmoid(e){return s((()=>{const s=t.add(.5,t.mul(.2,e));return t.clipByValue(s,0,1)}))}
/**
 * Invoke `x` in the training phase, and `alt` otherwise.
 *
 * Porting Note: We do not create placeholder tensors for the `training`
 * boolean flag here, because there is no such thing in the TF.js imperative
 * backend.
 *
 * @param x The function to invoke iff `training` is `true`.
 * @param alt The function to invoke iff `training` is `false`.
 * @param training Boolean flag for whether training phase is active.
 * @returns The return value of `x()` if `training` is `true`, or the return
 *   value of `alt()` if `training` is `false`.
 */function inTrainPhase(t,e,s=false){return s?t():e()}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const Ut=["fanIn","fanOut","fanAvg"];const Bt=["normal","uniform","truncatedNormal"];
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
function checkFanMode(t){it(Ut,"FanMode",t)}function checkDistribution(t){it(Bt,"Distribution",t)}class Initializer extends l.Serializable{fromConfigUsesCustomObjects(){return false}getConfig(){return{}}}class Zeros extends Initializer{apply(t,e){return u(t,e)}}Zeros.className="Zeros";l.registerClass(Zeros);class Ones extends Initializer{apply(t,e){return h(t,e)}}Ones.className="Ones";l.registerClass(Ones);class Constant extends Initializer{constructor(t){super();if(typeof t!=="object")throw new at(`Expected argument of type ConstantConfig but got ${t}`);if(t.value===void 0)throw new at(`config must have value set but got ${t}`);this.value=t.value}apply(t,e){return s((()=>c(o(this.value),h(t,e))))}getConfig(){return{value:this.value}}}Constant.className="Constant";l.registerClass(Constant);class RandomUniform extends Initializer{constructor(t){super();this.DEFAULT_MINVAL=-.05;this.DEFAULT_MAXVAL=.05;this.minval=t.minval||this.DEFAULT_MINVAL;this.maxval=t.maxval||this.DEFAULT_MAXVAL;this.seed=t.seed}apply(t,e){return p(t,this.minval,this.maxval,e,this.seed)}getConfig(){return{minval:this.minval,maxval:this.maxval,seed:this.seed}}}RandomUniform.className="RandomUniform";l.registerClass(RandomUniform);class RandomNormal extends Initializer{constructor(t){super();this.DEFAULT_MEAN=0;this.DEFAULT_STDDEV=.05;this.mean=t.mean||this.DEFAULT_MEAN;this.stddev=t.stddev||this.DEFAULT_STDDEV;this.seed=t.seed}apply(t,e){e=e||"float32";if(e!=="float32"&&e!=="int32")throw new rt(`randomNormal does not support dType ${e}.`);return randomNormal$1(t,this.mean,this.stddev,e,this.seed)}getConfig(){return{mean:this.mean,stddev:this.stddev,seed:this.seed}}}RandomNormal.className="RandomNormal";l.registerClass(RandomNormal);class TruncatedNormal extends Initializer{constructor(t){super();this.DEFAULT_MEAN=0;this.DEFAULT_STDDEV=.05;this.mean=t.mean||this.DEFAULT_MEAN;this.stddev=t.stddev||this.DEFAULT_STDDEV;this.seed=t.seed}apply(t,e){e=e||"float32";if(e!=="float32"&&e!=="int32")throw new rt(`truncatedNormal does not support dType ${e}.`);return d(t,this.mean,this.stddev,e,this.seed)}getConfig(){return{mean:this.mean,stddev:this.stddev,seed:this.seed}}}TruncatedNormal.className="TruncatedNormal";l.registerClass(TruncatedNormal);class Identity extends Initializer{constructor(t){super();this.gain=t.gain!=null?t.gain:1}apply(t,e){return s((()=>{if(t.length!==2||t[0]!==t[1])throw new at("Identity matrix initializer can only be used for 2D square matrices.");return c(this.gain,g(t[0]))}))}getConfig(){return{gain:this.gain}}}Identity.className="Identity";l.registerClass(Identity);
/**
 * Computes the number of input and output units for a weight shape.
 * @param shape Shape of weight.
 * @param dataFormat data format to use for convolution kernels.
 *   Note that all kernels in Keras are standardized on the
 *   CHANNEL_LAST ordering (even when inputs are set to CHANNEL_FIRST).
 * @return An length-2 array: fanIn, fanOut.
 */function computeFans(t,e="channelsLast"){let s;let n;checkDataFormat(e);if(t.length===2){s=t[0];n=t[1]}else if([3,4,5].indexOf(t.length)!==-1){if(e==="channelsFirst"){const e=arrayProd(t,2);s=t[1]*e;n=t[0]*e}else if(e==="channelsLast"){const e=arrayProd(t,0,t.length-2);s=t[t.length-2]*e;n=t[t.length-1]*e}}else{const e=arrayProd(t);s=Math.sqrt(e);n=Math.sqrt(e)}return[s,n]}class VarianceScaling extends Initializer{constructor(t){super();if(t.scale<0)throw new at(`scale must be a positive float. Got: ${t.scale}`);this.scale=t.scale==null?1:t.scale;this.mode=t.mode==null?"fanIn":t.mode;checkFanMode(this.mode);this.distribution=t.distribution==null?"normal":t.distribution;checkDistribution(this.distribution);this.seed=t.seed}apply(t,e){const s=computeFans(t);const n=s[0];const i=s[1];let a=this.scale;this.mode==="fanIn"?a/=Math.max(1,n):this.mode==="fanOut"?a/=Math.max(1,i):a/=Math.max(1,(n+i)/2);if(this.distribution==="normal"){const s=Math.sqrt(a);e=e||"float32";if(e!=="float32"&&e!=="int32")throw new rt(`${this.getClassName()} does not support dType ${e}.`);return d(t,0,s,e,this.seed)}{const s=Math.sqrt(3*a);return p(t,-s,s,e,this.seed)}}getConfig(){return{scale:this.scale,mode:this.mode,distribution:this.distribution,seed:this.seed}}}VarianceScaling.className="VarianceScaling";l.registerClass(VarianceScaling);class GlorotUniform extends VarianceScaling{
/**
     * Constructor of GlorotUniform
     * @param scale
     * @param mode
     * @param distribution
     * @param seed
     */
constructor(t){super({scale:1,mode:"fanAvg",distribution:"uniform",seed:t==null?null:t.seed})}getClassName(){return VarianceScaling.className}}GlorotUniform.className="GlorotUniform";l.registerClass(GlorotUniform);class GlorotNormal extends VarianceScaling{
/**
     * Constructor of GlorotNormal.
     * @param scale
     * @param mode
     * @param distribution
     * @param seed
     */
constructor(t){super({scale:1,mode:"fanAvg",distribution:"normal",seed:t==null?null:t.seed})}getClassName(){return VarianceScaling.className}}GlorotNormal.className="GlorotNormal";l.registerClass(GlorotNormal);class HeNormal extends VarianceScaling{constructor(t){super({scale:2,mode:"fanIn",distribution:"normal",seed:t==null?null:t.seed})}getClassName(){return VarianceScaling.className}}HeNormal.className="HeNormal";l.registerClass(HeNormal);class HeUniform extends VarianceScaling{constructor(t){super({scale:2,mode:"fanIn",distribution:"uniform",seed:t==null?null:t.seed})}getClassName(){return VarianceScaling.className}}HeUniform.className="HeUniform";l.registerClass(HeUniform);class LeCunNormal extends VarianceScaling{constructor(t){super({scale:1,mode:"fanIn",distribution:"normal",seed:t==null?null:t.seed})}getClassName(){return VarianceScaling.className}}LeCunNormal.className="LeCunNormal";l.registerClass(LeCunNormal);class LeCunUniform extends VarianceScaling{constructor(t){super({scale:1,mode:"fanIn",distribution:"uniform",seed:t==null?null:t.seed})}getClassName(){return VarianceScaling.className}}LeCunUniform.className="LeCunUniform";l.registerClass(LeCunUniform);class Orthogonal extends Initializer{constructor(t){super();this.DEFAULT_GAIN=1;this.ELEMENTS_WARN_SLOW=2e3;this.gain=t.gain==null?this.DEFAULT_GAIN:t.gain;this.seed=t.seed}apply(t,e){return s((()=>{if(t.length<2)throw new rt("Shape must be at least 2D.");if(e!=="int32"&&e!=="float32"&&e!==void 0)throw new TypeError(`Unsupported data type ${e}.`);e;const s=m.sizeFromShape(t.slice(0,-1));const n=t[t.length-1];const i=s*n;i>this.ELEMENTS_WARN_SLOW&&console.warn(`Orthogonal initializer is being called on a matrix with more than ${this.ELEMENTS_WARN_SLOW} (${i}) elements: Slowness may result.`);const a=[Math.max(n,s),Math.min(n,s)];const r=randomNormal$1(a,0,1,e,this.seed);const l=f.qr(r,false);let u=l[0];const h=l[1];const p=h.flatten().stridedSlice([0],[Math.min(n,s)*Math.min(n,s)],[Math.min(n,s)+1]);u=c(u,p.sign());s<n&&(u=u.transpose());return c(o(this.gain),u.reshape(t))}))}getConfig(){return{gain:this.gain,seed:this.seed}}}Orthogonal.className="Orthogonal";l.registerClass(Orthogonal);const Wt={constant:"Constant",glorotNormal:"GlorotNormal",glorotUniform:"GlorotUniform",heNormal:"HeNormal",heUniform:"HeUniform",identity:"Identity",leCunNormal:"LeCunNormal",leCunUniform:"LeCunUniform",ones:"Ones",orthogonal:"Orthogonal",randomNormal:"RandomNormal",randomUniform:"RandomUniform",truncatedNormal:"TruncatedNormal",varianceScaling:"VarianceScaling",zeros:"Zeros"};function deserializeInitializer(t,e={}){return ot(t,l.SerializationMap.getMap().classNameMap,e,"initializer")}function serializeInitializer(t){return lt(t)}function getInitializer(t){if(typeof t==="string"){const e=t in Wt?Wt[t]:t;if(e==="GlorotNormal")return new GlorotNormal;if(e==="GlorotUniform")return new GlorotUniform;if(e==="HeNormal")return new HeNormal;if(e==="HeUniform")return new HeUniform;if(e==="LeCunNormal")return new LeCunNormal;if(e==="LeCunUniform")return new LeCunUniform;{const t={};t.className=e;t.config={};return deserializeInitializer(t)}}return t instanceof Initializer?t:deserializeInitializer(t)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function isArrayOfShapes(t){return Array.isArray(t)&&Array.isArray(t[0])}
/**
 * Special case of normalizing shapes to lists.
 *
 * @param x A shape or list of shapes to normalize into a list of Shapes.
 * @return A list of Shapes.
 */function normalizeShapeList(t){return t.length===0?[]:Array.isArray(t[0])?t:[t]}
/**
 * Helper function to obtain exactly one Tensor.
 * @param xs: A single `tf.Tensor` or an `Array` of `tf.Tensor`s.
 * @return A single `tf.Tensor`. If `xs` is an `Array`, return the first one.
 * @throws ValueError: If `xs` is an `Array` and its length is not 1.
 */function getExactlyOneTensor(t){let e;if(Array.isArray(t)){if(t.length!==1)throw new at(`Expected Tensor length to be 1; got ${t.length}`);e=t[0]}else e=t;return e}
/**
 * Helper function to obtain exactly on instance of Shape.
 *
 * @param shapes Input single `Shape` or Array of `Shape`s.
 * @returns If input is a single `Shape`, return it unchanged. If the input is
 *   an `Array` containing exactly one instance of `Shape`, return the instance.
 *   Otherwise, throw a `ValueError`.
 * @throws ValueError: If input is an `Array` of `Shape`s, and its length is not
 *   1.
 */function getExactlyOneShape(t){if(Array.isArray(t)&&Array.isArray(t[0])){if(t.length===1){t;return t[0]}throw new at(`Expected exactly 1 Shape; got ${t.length}`)}return t}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Count the elements in an Array of LayerVariables.
 *
 * @param weights: The LayerVariables of which the constituent numbers are to
 *   be counted.
 * @returns A count of the elements in all the LayerVariables
 */function countParamsInWeights(t){let e=0;for(const s of t)s.shape.length===0?e+=1:e+=s.shape.reduce(((t,e)=>t*e));return e}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const Vt="Variable";class LayerVariable{
/**
     * Construct Variable from a `tf.Tensor`.
     *
     * If not explicitly named, the Variable will be given a name with the
     * prefix 'Variable'. Variable names are unique. In the case of name
     * collision, suffixies '_<num>' will be added to the name.
     *
     * @param val Initial value of the Variable.
     * @param name Name of the variable. If `null` or `undefined` is provided, it
     *   will default a name with the prefix 'Variable'.
     * @param constraint Optional, projection function to be applied to the
     * variable after optimize updates
     * @throws ValueError if `name` is `null` or `undefined`.
     */
constructor(e,s="float32",n=Vt,i=true,a=null){this.dtype=s==null?"float32":s;this.shape=e.shape;this.id=getNextUniqueTensorId();n=n==null?Vt:n;this.originalName=getScopedTensorName(n);this.name=getUniqueTensorName(this.originalName);this.trainable_=i;this.constraint=a;this.val=t.variable(e,this.trainable_,this.name,this.dtype)}read(){this.assertNotDisposed();return this.val}
/**
     * Update the value of the Variable.
     *
     * @param newVal: The new value to update to. Must be consistent with the
     *   dtype and shape of the Variable.
     * @return This Variable.
     */write(t){this.assertNotDisposed();checkShapesMatch(this.val,t);if(this.val.id!==t.id){this.val.assign(t);this.constraint!=null&&this.val.assign(this.constraint.apply(this.val))}return this}dispose(){this.assertNotDisposed();this.val.dispose()}assertNotDisposed(){if(this.val.isDisposed)throw new Error(`LayersVariable ${this.name} is already disposed.`)}get trainable(){return this.trainable_}set trainable(t){this.trainable_=t;this.val.trainable=t}}function checkShapesMatch(t,e){if(t.shape.toString()!==e.shape.toString())throw new Error("Shape mismatch: "+JSON.stringify(t.shape)+" vs. "+JSON.stringify(e.shape))}
/**
 * Create a Variable.
 * @param x The initial value of the `Variable`.
 * @param dtype optional, the type of the variable.
 * @param name optional, the name of the variable, default provided by
 * Variable.
 * @param constraint optional, a constraint to be applied after every update.
 * @return The newly instantiated `Variable`.
 */
/**
 * Get the values of an array of Variables.
 *
 * @param tensors An `Array` of `Variable`s to get the values of.
 * @return The values of the inputs, as an `Array` of`tf.Tensor`s.
 */
function batchGetValue(t){return t.map((t=>t.read()))}
/**
 * Update the value of multiple Variables at once.
 *
 * @param variablesAndValues An `Array`, each element is of type
 *   [Variable, Tensor]. The first item is the
 *   `Variable` of which the value is to be updated. The second item
 *   carries the new value.
 */function batchSetValue(t){t.forEach((t=>{const e=t[0];e.write(t[1])}))}
/**
 * Returns the gradients of `variables` w.r.t. the return value of `lossFn`.
 * @param lossFn A function which returns a Scalar to be used as the function
 *   value (i.e., numerator) for differentiation.
 * @param variables List of variables to be used as the independent variables
 *   (i.e., denominator) for differentiation.
 * @returns An Array of gradients tensors.
 */
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
class InputSpec{constructor(t){this.dtype=t.dtype;this.shape=t.shape;t.shape!=null?this.ndim=t.shape.length:this.ndim=t.ndim;this.maxNDim=t.maxNDim;this.minNDim=t.minNDim;this.axes=t.axes||{}}}class SymbolicTensor{
/**
     *
     * @param dtype
     * @param shape
     * @param sourceLayer The Layer that produced this symbolic tensor.
     * @param inputs The inputs passed to sourceLayer's __call__() method.
     * @param nodeIndex
     * @param tensorIndex
     * @param callArgs The keyword arguments passed to the __call__() method.
     * @param name
     * @param outputTensorIndex The index of this tensor in the list of outputs
     *   returned by apply().
     */
constructor(t,e,s,n,i,a,r){this.dtype=t;this.shape=e;this.sourceLayer=s;this.inputs=n;this.callArgs=i;this.outputTensorIndex=r;this.id=getNextUniqueTensorId();if(a!=null){this.originalName=getScopedTensorName(a);this.name=getUniqueTensorName(this.originalName)}this.rank=e.length}}let jt=0;class Node{constructor(t,e){this.callArgs=e;this.id=jt++;this.outboundLayer=t.outboundLayer;this.inboundLayers=t.inboundLayers;this.nodeIndices=t.nodeIndices;this.tensorIndices=t.tensorIndices;this.inputTensors=t.inputTensors;this.outputTensors=t.outputTensors;this.inputMasks=t.inputMasks;this.outputMasks=t.outputMasks;this.inputShapes=t.inputShapes;this.outputShapes=t.outputShapes;for(const e of t.inboundLayers)e!=null&&e.outboundNodes.push(this);t.outboundLayer.inboundNodes.push(this)}getConfig(){const t=[];for(const e of this.inboundLayers)e!=null?t.push(e.name):t.push(null);return{outboundLayer:this.outboundLayer?this.outboundLayer.name:null,inboundLayers:t,nodeIndices:this.nodeIndices,tensorIndices:this.tensorIndices}}}let qt=0;class Layer extends l.Serializable{constructor(t={}){super();this._callHook=null;this._addedWeightNames=[];this._stateful=false;this.id=qt++;this.activityRegularizer=null;this.inputSpec=null;this.supportsMasking=false;this._trainableWeights=[];this._nonTrainableWeights=[];this._losses=[];this._updates=[];this._built=false;this.inboundNodes=[];this.outboundNodes=[];let e=t.name;if(!e){const t=this.getClassName();e=ut(t)+"_"+getUid(t)}this.name=e;this.trainable_=t.trainable==null||t.trainable;if(t.inputShape!=null||t.batchInputShape!=null){let e;if(t.batchInputShape!=null)e=t.batchInputShape;else if(t.inputShape!=null){let s=null;t.batchSize!=null&&(s=t.batchSize);e=[s].concat(t.inputShape)}this.batchInputShape=e;let s=t.dtype;s==null&&(s=t.inputDType);s==null&&(s="float32");this.dtype=s}t.weights!=null?this.initialWeights=t.weights:this.initialWeights=null;this._refCount=null;this.fastWeightInitDuringBuild=false}
/**
     * Converts a layer and its index to a unique (immutable type) name.
     * This function is used internally with `this.containerNodes`.
     * @param layer The layer.
     * @param nodeIndex The layer's position (e.g. via enumerate) in a list of
     *   nodes.
     *
     * @returns The unique name.
     */static nodeKey(t,e){return t.name+"_ib-"+e.toString()}
/**
     * Returns this.inboundNode at index nodeIndex.
     *
     * Porting note: This is a replacement for _get_node_attribute_at_index()
     * @param nodeIndex
     * @param attrName The name of the attribute related to request for this node.
     */getNodeAtIndex(t,e){if(this.inboundNodes.length===0)throw new ht(`The layer has never been called and thus has no defined ${e}.`);if(this.inboundNodes.length<=t)throw new at(`Asked to get ${e} at node ${t}, but the layer has only ${this.inboundNodes.length} inbound nodes.`);return this.inboundNodes[t]}
/**
     * Retrieves the input tensor(s) of a layer at a given node.
     *
     * @param nodeIndex Integer, index of the node from which to retrieve the
     *   attribute. E.g. `nodeIndex=0` will correspond to the first time the layer
     *   was called.
     *
     * @return A tensor (or list of tensors if the layer has multiple inputs).
     */getInputAt(t){return ct(this.getNodeAtIndex(t,"input").inputTensors)}
/**
     * Retrieves the output tensor(s) of a layer at a given node.
     *
     * @param nodeIndex Integer, index of the node from which to retrieve the
     *   attribute. E.g. `nodeIndex=0` will correspond to the first time the layer
     *   was called.
     *
     * @return A tensor (or list of tensors if the layer has multiple outputs).
     */getOutputAt(t){return ct(this.getNodeAtIndex(t,"output").outputTensors)}get input(){if(this.inboundNodes.length>1)throw new pt(`Layer ${this.name} has multiple inbound nodes, hence the notion of "layer input" is ill-defined. Use \`getInputAt(nodeIndex)\` instead.`);if(this.inboundNodes.length===0)throw new pt(`Layer ${this.name} is not connected, no input to return.`);return ct(this.getNodeAtIndex(0,"input").inputTensors)}get output(){if(this.inboundNodes.length===0)throw new pt(`Layer ${this.name} has no inbound nodes.`);if(this.inboundNodes.length>1)throw new pt(`Layer ${this.name} has multiple inbound nodes, hence the notion of "layer output" is ill-defined. Use \`getOutputAt(nodeIndex)\` instead.`);return ct(this.getNodeAtIndex(0,"output").outputTensors)}get losses(){return this._losses}calculateLosses(){return this.losses.map((t=>t()))}get updates(){return this._updates}get built(){return this._built}set built(t){this._built=t}get trainable(){return this.trainable_}set trainable(t){this._trainableWeights.forEach((e=>e.trainable=t));this.trainable_=t}get trainableWeights(){return this.trainable_?this._trainableWeights.filter((t=>t.trainable)):[]}set trainableWeights(t){this._trainableWeights=t}get nonTrainableWeights(){return this.trainable?this._trainableWeights.filter((t=>!t.trainable)).concat(this._nonTrainableWeights):this._trainableWeights.concat(this._nonTrainableWeights)}set nonTrainableWeights(t){this._nonTrainableWeights=t}get weights(){return this.trainableWeights.concat(this.nonTrainableWeights)}get stateful(){return this._stateful}resetStates(){if(!this.stateful)throw new Error("Cannot call the resetStates() method of a non-stateful Layer object.")}
/**
     * Checks compatibility between the layer and provided inputs.
     *
     * This checks that the tensor(s) `input`
     * verify the input assumptions of the layer
     * (if any). If not, exceptions are raised.
     *
     * @param inputs Input tensor or list of input tensors.
     *
     * @exception ValueError in case of mismatch between
     *   the provided inputs and the expectations of the layer.
     */assertInputCompatibility(t){const e=dt(t);if(this.inputSpec==null||this.inputSpec.length===0)return;const s=dt(this.inputSpec);if(e.length!==s.length)throw new at(`Layer ${this.name} expects ${s.length} inputs, but it received ${e.length} input tensors. Input received: ${t}`);for(let t=0;t<e.length;t++){const n=e[t];const i=s[t];if(i==null)continue;const a=n.rank;if(i.ndim!=null&&a!==i.ndim)throw new at(`Input ${t} is incompatible with layer ${this.name}: expected ndim=${i.ndim}, found ndim=${a}`);if(i.maxNDim!=null&&a>i.maxNDim)throw new at(`Input ${t} is incompatible with layer ${this.name}: expected max_ndim=${i.maxNDim}, found ndim=${a}`);if(i.minNDim!=null&&a<i.minNDim)throw new at(`Input ${t} is incompatible with layer ${this.name}: expected min_ndim=${i.minNDim}, found ndim=${a}.`);if(i.dtype!=null&&n.dtype!==i.dtype)throw new at(`Input ${t} is incompatible with layer ${this.name} : expected dtype=${i.dtype}, found dtype=${n.dtype}.`);if(i.axes){const e=n.shape;for(const s in i.axes){const n=Number(s);const a=i.axes[s];const r=n>=0?e[n]:e[e.length+n];if(a!=null&&[a,null].indexOf(r)===-1)throw new at(`Input ${t} is incompatible with layer ${this.name}: expected axis ${n} of input shape to have value ${a} but got shape ${e}.`)}}if(i.shape!=null)for(let e=0;e<i.shape.length;++e){const s=i.shape[e];const a=n.shape[e];if(s!=null&&a!=null&&s!==a)throw new at(`Input ${t} is incompatible with layer ${this.name}: expected shape=${i.shape}, found shape=${n.shape}.`)}}}
/**
     * This is where the layer's logic lives.
     *
     * @param inputs Input tensor, or list/tuple of input tensors.
     * @param kwargs Additional keyword arguments.
     *
     * @return A tensor or list/tuple of tensors.
     */call(t,e){return t}invokeCallHook(t,e){this._callHook!=null&&this._callHook(t,e)}
/**
     * Set call hook.
     * This is currently used for testing only.
     * @param callHook
     */setCallHook(t){this._callHook=t}clearCallHook(){this._callHook=null}
/**
     * Builds or executes a `Layer`'s logic.
     *
     * When called with `tf.Tensor`(s), execute the `Layer`'s computation and
     * return Tensor(s). For example:
     *
     * ```js
     * const denseLayer = tf.layers.dense({
     *   units: 1,
     *   kernelInitializer: 'zeros',
     *   useBias: false
     * });
     *
     * // Invoke the layer's apply() method with a `tf.Tensor` (with concrete
     * // numeric values).
     * const input = tf.ones([2, 2]);
     * const output = denseLayer.apply(input);
     *
     * // The output's value is expected to be [[0], [0]], due to the fact that
     * // the dense layer has a kernel initialized to all-zeros and does not have
     * // a bias.
     * output.print();
     * ```
     *
     * When called with `tf.SymbolicTensor`(s), this will prepare the layer for
     * future execution.  This entails internal book-keeping on shapes of
     * expected Tensors, wiring layers together, and initializing weights.
     *
     * Calling `apply` with `tf.SymbolicTensor`s are typically used during the
     * building of non-`tf.Sequential` models. For example:
     *
     * ```js
     * const flattenLayer = tf.layers.flatten();
     * const denseLayer = tf.layers.dense({units: 1});
     *
     * // Use tf.layers.input() to obtain a SymbolicTensor as input to apply().
     * const input = tf.input({shape: [2, 2]});
     * const output1 = flattenLayer.apply(input);
     *
     * // output1.shape is [null, 4]. The first dimension is the undetermined
     * // batch size. The second dimension comes from flattening the [2, 2]
     * // shape.
     * console.log(JSON.stringify(output1.shape));
     *
     * // The output SymbolicTensor of the flatten layer can be used to call
     * // the apply() of the dense layer:
     * const output2 = denseLayer.apply(output1);
     *
     * // output2.shape is [null, 1]. The first dimension is the undetermined
     * // batch size. The second dimension matches the number of units of the
     * // dense layer.
     * console.log(JSON.stringify(output2.shape));
     *
     * // The input and output can be used to construct a model that consists
     * // of the flatten and dense layers.
     * const model = tf.model({inputs: input, outputs: output2});
     * ```
     *
     * @param inputs a `tf.Tensor` or `tf.SymbolicTensor` or an Array of them.
     * @param kwargs Additional keyword arguments to be passed to `call()`.
     *
     * @return Output of the layer's `call` method.
     *
     * @exception ValueError error in case the layer is missing shape information
     *   for its `build` call.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */
apply(t,e){e=e||{};this.assertNotDisposed();const s=dt(t);const n=checkAllSymbolic(t);const i=checkNoneSymbolic(t);if(n===i)throw new at("Arguments to apply() must be all SymbolicTensors or all Tensors");return nameScope(this.name,(()=>{if(!this.built){this.assertInputCompatibility(t);const e=[];for(const s of dt(t))e.push(s.shape);this.build(ct(e));this.built=true;this.initialWeights&&this.setWeights(this.initialWeights);this._refCount===null&&i&&(this._refCount=1)}this.assertInputCompatibility(t);if(i){let n=this.call(t,e);this.supportsMasking&&this.setMaskMetadata(t,n);const i=dt(n);const a=[];for(let t of i){s.indexOf(t)!==-1&&(t=t.clone());a.push(t)}n=ct(a);if(this.activityRegularizer!=null)throw new rt("Layer invocation in the presence of activity regularizer(s) is not supported yet.");return n}{const s=collectInputShape(t);const n=this.computeOutputShape(s);let i;const a=guessOutputDType(t);this.warnOnIncompatibleInputShape(Array.isArray(t)?s[0]:s);i=n!=null&&n.length>0&&Array.isArray(n[0])?n.map(((s,n)=>new SymbolicTensor(a,s,this,dt(t),e,this.name,n))):new SymbolicTensor(a,n,this,dt(t),e,this.name);this.addInboundNode(t,i,null,null,s,n,e);this._refCount++;if(this.activityRegularizer!=null)throw new rt("Layer invocation in the presence of activity regularizer(s) is not supported yet.");return i}}))}
/**
     * Check compatibility between input shape and this layer's batchInputShape.
     *
     * Print warning if any incompatibility is found.
     *
     * @param inputShape Input shape to be checked.
     */warnOnIncompatibleInputShape(t){if(this.batchInputShape!=null)if(t.length!==this.batchInputShape.length)console.warn(`The rank of the input tensor provided (shape: ${JSON.stringify(t)}) does not match that of the batchInputShape (${JSON.stringify(this.batchInputShape)}) of the layer ${this.name}`);else{let e=false;this.batchInputShape.forEach(((s,n)=>{s!=null&&t[n]!=null&&t[n]!==s&&(e=true)}));e&&console.warn(`The shape of the input tensor (${JSON.stringify(t)}) does not match the expectation of layer ${this.name}: ${JSON.stringify(this.batchInputShape)}`)}}
/**
     * Retrieves the output shape(s) of a layer.
     *
     * Only applicable if the layer has only one inbound node, or if all inbound
     * nodes have the same output shape.
     *
     * @returns Output shape or shapes.
     * @throws AttributeError: if the layer is connected to more than one incoming
     *   nodes.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */get outputShape(){if(this.inboundNodes==null||this.inboundNodes.length===0)throw new pt(`The layer ${this.name} has never been called and thus has no defined output shape.`);const t=[];for(const e of this.inboundNodes){const s=JSON.stringify(e.outputShapes);t.indexOf(s)===-1&&t.push(s)}if(t.length===1){const t=this.inboundNodes[0].outputShapes;return Array.isArray(t)&&Array.isArray(t[0])&&t.length===1?t[0]:t}throw new pt(`The layer ${this.name} has multiple inbound nodes with different output shapes. Hence the notion of "output shape" is ill-defined for the layer.`)}
/**
     * Counts the total number of numbers (e.g., float32, int32) in the
     * weights.
     *
     * @returns An integer count.
     * @throws RuntimeError: If the layer is not built yet (in which case its
     *   weights are not defined yet.)
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */countParams(){if(!this.built)throw new ht(`You tried to call countParams() on ${this.name}, but the layer is not built yet. Build it first by calling build(batchInputShape).`);return countParamsInWeights(this.weights)}
/**
     * Creates the layer weights.
     *
     * Must be implemented on all layers that have weights.
     *
     * Called when apply() is called to construct the weights.
     *
     * @param inputShape A `Shape` or array of `Shape` (unused).
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */build(t){this.built=true}
/**
     * Returns the current values of the weights of the layer.
     *
     * @param trainableOnly Whether to get the values of only trainable weights.
     * @returns Weight values as an `Array` of `tf.Tensor`s.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */getWeights(t=false){return batchGetValue(t?this.trainableWeights:this.weights)}
/**
     * Sets the weights of the layer, from Tensors.
     *
     * @param weights a list of Tensors. The number of arrays and their shape
     *   must match number of the dimensions of the weights of the layer (i.e.
     *   it should match the output of `getWeights`).
     *
     * @exception ValueError If the provided weights list does not match the
     *   layer's specifications.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */setWeights(t){s((()=>{const e=this.weights;if(e.length!==t.length)throw new at(`You called setWeights(weights) on layer "${this.name}" with a weight list of length ${t.length}, but the layer was expecting ${e.length} weights. Provided weights: ${t}...`);if(e.length===0)return;const s=[];const n=batchGetValue(e);for(let i=0;i<n.length;++i){const a=n[i];const r=e[i];const o=t[i];if(!m.arraysEqual(a.shape,o.shape))throw new at(`Layer weight shape ${a.shape} not compatible with provided weight shape ${o.shape}`);s.push([r,o])}batchSetValue(s)}))}
/**
     * Adds a weight variable to the layer.
     *
     * @param name Name of the new weight variable.
     * @param shape The shape of the weight.
     * @param dtype The dtype of the weight.
     * @param initializer An initializer instance.
     * @param regularizer A regularizer instance.
     * @param trainable Whether the weight should be trained via backprop or not
     *   (assuming that the layer itself is also trainable).
     * @param constraint An optional trainable.
     * @return The created weight variable.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */addWeight(t,e,s,n,i,a,r,o){if(this._addedWeightNames.indexOf(t)!==-1)throw new at(`Duplicate weight name ${t} for layer ${this.name}`);this._addedWeightNames.push(t);s==null&&(s="float32");this.fastWeightInitDuringBuild&&(n=o!=null?o():getInitializer("zeros"));const l=n.apply(e,s);const u=new LayerVariable(l,s,t,a,r);l.dispose();i!=null&&this.addLoss((()=>i.apply(u.read())));a==null&&(a=true);a?this._trainableWeights.push(u):this._nonTrainableWeights.push(u);return u}
/**
     * Set the fast-weight-initialization flag.
     *
     * In cases where the initialized weight values will be immediately
     * overwritten by loaded weight values during model loading, setting
     * the flag to `true` saves unnecessary calls to potentially expensive
     * initializers and speeds up the loading process.
     *
     * @param value Target value of the flag.
     */setFastWeightInitDuringBuild(t){this.fastWeightInitDuringBuild=t}addLoss(t){if(!(t==null||Array.isArray(t)&&t.length===0)){t=dt(t);this._losses!==void 0&&this._losses!==null&&this.losses.push(...t)}}
/**
     * Computes the output shape of the layer.
     *
     * Assumes that the layer will be built to match that input shape provided.
     *
     * @param inputShape A shape (tuple of integers) or a list of shape tuples
     *   (one per output tensor of the layer). Shape tuples can include null for
     *   free dimensions, instead of an integer.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */computeOutputShape(t){return t}
/**
     * Computes an output mask tensor.
     *
     * @param inputs Tensor or list of tensors.
     * @param mask Tensor or list of tensors.
     *
     * @return null or a tensor (or list of tensors, one per output tensor of the
     * layer).
     */computeMask(t,e){if(!this.supportsMasking){if(e!=null){if(!Array.isArray(e))throw new TypeError(`Layer ${this.name} does not support masking, but was passed an inputMask.`);e.forEach((t=>{if(t!=null)throw new TypeError(`Layer ${this.name} does not support masking, but was passed an inputMask.`)}))}return null}return e}setMaskMetadata(t,e,s){if(!this.supportsMasking)return;const n=this.computeMask(t,s);const i=dt(e);const a=dt(n);if(i.length!==a.length)throw new Error(`${this.name} outputs ${i.length} tensors but ${i.length} masks for those tensors`);for(let t=0;t<i.length;t++)i[t].kerasMask=a[t]}
/**
     * Internal method to create an inbound node for the layer.
     *
     * @param inputTensors List of input tensors.
     * @param outputTensors List of output tensors.
     * @param inputMasks List of input masks (a mask can be a tensor, or null).
     * @param outputMasks List of output masks (a mask can be a tensor, or null).
     * @param inputShapes List of input shape tuples.
     * @param outputShapes List of output shape tuples.
     * @param kwargs Dictionary of keyword arguments that were passed to the
     *   `call` method of the layer at the call that created the node.
     */addInboundNode(t,e,s,n,i,a,r=null){const o=dt(t);e=dt(e);s=dt(s);n=dt(n);i=normalizeShapeList(i);a=normalizeShapeList(a);const l=[];const u=[];const h=[];for(const t of o){l.push(t.sourceLayer);u.push(t.nodeIndex);h.push(t.tensorIndex)}new Node({outboundLayer:this,inboundLayers:l,nodeIndices:u,tensorIndices:h,inputTensors:o,outputTensors:e,inputMasks:s,outputMasks:n,inputShapes:i,outputShapes:a},r);for(let t=0;t<e.length;t++){e[t].sourceLayer=this;e[t].nodeIndex=this.inboundNodes.length-1;e[t].tensorIndex=t}}
/**
     * Returns the config of the layer.
     *
     * A layer config is a TS dictionary (serializable)
     * containing the configuration of a layer.
     * The same layer can be reinstantiated later
     * (without its trained weights) from this configuration.
     *
     * The config of a layer does not include connectivity
     * information, nor the layer class name.  These are handled
     * by 'Container' (one layer of abstraction above).
     *
     * Porting Note: The TS dictionary follows TS naming standards for
     * keys, and uses tfjs-layers type-safe Enums.  Serialization methods
     * should use a helper function to convert to the pythonic storage
     * standard. (see serialization_utils.convertTsToPythonic)
     *
     * @returns TS dictionary of configuration.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */getConfig(){const t={name:this.name,trainable:this.trainable};this.batchInputShape!=null&&(t.batchInputShape=this.batchInputShape);this.dtype!=null&&(t.dtype=this.dtype);return t}
/**
     * Dispose the weight variables that this Layer instance holds.
     *
     * @returns {number} Number of disposed variables.
     */disposeWeights(){this.weights.forEach((t=>t.dispose()));return this.weights.length}assertNotDisposed(){if(this._refCount===0)throw new Error(`Layer '${this.name}' is already disposed.`)}
/**
     * Attempt to dispose layer's weights.
     *
     * This method decreases the reference count of the Layer object by 1.
     *
     * A Layer is reference-counted. Its reference count is incremented by 1
     * the first item its `apply()` method is called and when it becomes a part
     * of a new `Node` (through calling the `apply()` method on a
     * `tf.SymbolicTensor`).
     *
     * If the reference count of a Layer becomes 0, all the weights will be
     * disposed and the underlying memory (e.g., the textures allocated in WebGL)
     * will be freed.
     *
     * Note: If the reference count is greater than 0 after the decrement, the
     * weights of the Layer will *not* be disposed.
     *
     * After a Layer is disposed, it cannot be used in calls such as `apply()`,
     * `getWeights()` or `setWeights()` anymore.
     *
     * @returns A DisposeResult Object with the following fields:
     *   - refCountAfterDispose: The reference count of the Container after this
     *     `dispose()` call.
     *   - numDisposedVariables: Number of `tf.Variable`s (i.e., weights) disposed
     *     during this `dispose()` call.
     * @throws {Error} If the layer is not built yet, or if the layer has already
     *   been disposed.
     *
     * @doc {heading: 'Models', 'subheading': 'Classes'}
     */dispose(){if(!this.built)throw new Error(`Cannot dispose Layer ${this.name} because it has not been built yet.`);if(this._refCount===null)throw new Error(`Cannot dispose Layer ${this.name} because it has not been used yet.`);this.assertNotDisposed();let t=0;--this._refCount===0&&(t=this.disposeWeights());return{refCountAfterDispose:this._refCount,numDisposedVariables:t}}}
/**
 * Collects the input shape(s) of a list of `tf.Tensor`s or
 * `tf.SymbolicTensor`s.
 *
 * TODO(michaelterry): Update PyKeras docs (backport).
 *
 * @param inputTensors List of input tensors (or single input tensor).
 *
 * @return List of shape tuples (or single tuple), one tuple per input.
 */function collectInputShape(t){t=dt(t);const e=[];for(const s of t)e.push(s.shape);return ct(e)}
/**
 * Guesses output dtype based on inputs.
 *
 * At present, just returns 'float32' for any input.
 *
 * @param inputTensors List of input tensors (or single input tensor).
 *
 * @return The guessed DType. At present, always returns 'float32'.
 */function guessOutputDType(t){return"float32"}
/**
 * Returns the list of input tensors necessary to compute `tensor`.
 *
 * Output will always be a list of tensors (potentially with 1 element).
 *
 * @param tensor The tensor to start from.
 * @param layer Origin layer of the tensor.
 * @param nodeIndex Origin node index of the tensor.
 *
 * @return Array of input tensors.
 */function getSourceInputs(t,e,s){if(e==null||s!=null&&s>0){e=t.sourceLayer;s=t.nodeIndex}if(e.inboundNodes.length===0)return[t];{const t=e.inboundNodes[s];if(t.inboundLayers.length===0)return t.inputTensors;{const e=[];for(let s=0;s<t.inboundLayers.length;s++){const n=t.inputTensors[s];const i=t.inboundLayers[s];const a=t.nodeIndices[s];const r=getSourceInputs(n,i,a);for(const t of r)e.indexOf(t)===-1&&e.push(t)}return e}}}function checkAllSymbolic(t){let e=true;for(const s of dt(t))if(!(s instanceof SymbolicTensor)){e=false;break}return e}function checkNoneSymbolic(t){let e=true;for(const s of dt(t))if(s instanceof SymbolicTensor){e=false;break}return e}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class InputLayer extends Layer{constructor(t){super({dtype:t.dtype,name:t.name!=null?t.name:getUid("input").toString()});t.batchSize==null&&(t.batchSize=null);t.sparse==null&&(t.sparse=false);this.trainable=false;this.built=true;this.sparse=t.sparse;if(t.inputShape!=null&&t.batchInputShape!=null)throw new at("Only provide the inputShape OR batchInputShape argument to inputLayer, not both at the same time.");let e=t.batchInputShape;if(e==null){if(t.inputShape==null)throw new at("An InputLayer should be passed either a `batchInputShape` or an `inputShape`.");e=[t.batchSize].concat(t.inputShape)}else if(t.batchSize!=null)throw new at("Cannot specify batchSize if batchInputShape is specified when creating an InputLayer.");const s=t.dtype||"float32";this.batchInputShape=e;this.dtype=s;this.inputSpec=[{shape:e}];const n=new SymbolicTensor(this.dtype,this.batchInputShape,this,[],{},this.name);n.nodeIndex=0;n.tensorIndex=0;new Node({outboundLayer:this,inboundLayers:[],nodeIndices:[],tensorIndices:[],inputTensors:[n],outputTensors:[n],inputMasks:[null],outputMasks:[null],inputShapes:[e],outputShapes:[e]})}apply(t,e){throw new at(`Cannot pass any input to an InputLayer's apply() method. InputLayer name: ${this.name}`)}dispose(){return{refCountAfterDispose:this._refCount,numDisposedVariables:0}}getConfig(){return{batchInputShape:this.batchInputShape,dtype:this.dtype,sparse:this.sparse,name:this.name}}}InputLayer.className="InputLayer";l.registerClass(InputLayer);function Input(t){if(t.batchShape==null&&t.shape==null)throw new Error("Please provide to Input either a `shape` or a `batchShape` argument. Note that `shape` does not include the batch dimension.");if(t.batchShape!=null&&t.shape!=null)throw new at("Please provide either a `shape` or `batchShape` argument to Input, but not both.");let e=t.batchShape;t.shape!=null&&e==null&&(e=[null].concat(t.shape));let s=t.dtype;s==null&&(s="float32");const n=new InputLayer({batchInputShape:e,name:t.name,dtype:s,sparse:t.sparse});const i=n.inboundNodes[0].outputTensors;return i[0]}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function assertFeedCompatibility(t,e){if(t.dtype==null||t.dtype===e.dtype)return e;try{return b(e,t.dtype)}catch(s){throw new at(`The dtype of the feed (${e.dtype}) can not be cast to the dtype of the key '${t.name}' (${t.dtype}).`)}}class FeedDict{
/**
     * Constructor, optionally does copy-construction.
     * @param feeds An Array of `Feed`s, or another `FeedDict`, in which case
     *   copy-construction will be performed.
     */
constructor(t){this.id2Value={};this.id2Mask={};this.name2Id={};if(t instanceof FeedDict)for(const e in t.id2Value){this.id2Value[e]=t.id2Value[e];e in t.id2Mask&&(this.id2Mask[e]=t.id2Mask[e])}else{if(t==null)return;for(const e of t)this.add(e.key,e.value)}}
/**
     * Add a key-value pair to the FeedDict.
     *
     * @param key The key of the feed.
     * @param value The value of the tensor feed.
     * @param mask The value of the mask feed (optional).
     * @returns This `FeedDict`.
     * @throws ValueError: If the key `SymbolicTensor` already exists in the
     *   `FeedDict`.
     */add(t,e,s){if(this.id2Value[t.id]!=null)throw new at(`Duplicate key: name=${t.name}, id=${t.id}`);this.id2Value[t.id]=assertFeedCompatibility(t,e);this.name2Id[t.name]=t.id;s!=null&&(this.id2Mask[t.id]=s);return this}
/**
     * Add a Feed to the FeedDict.
     * @param feed The new `Feed` to add.
     * @returns This `FeedDict`.
     */addFeed(t){this.add(t.key,t.value)}
/**
     * Probe whether a key already exists in the FeedDict.
     * @param key
     */hasKey(t){return this.id2Value[t.id]!=null}names(){return Object.keys(this.name2Id)}
/**
     * Get the feed value for given key.
     * @param key The SymbolicTensor, or its name (as a string), of which the
     *     value is sought.
     * @returns If `key` exists, the corresponding feed value.
     * @throws ValueError: If `key` does not exist in this `FeedDict`.
     */getValue(t){if(t instanceof SymbolicTensor){if(this.id2Value[t.id]==null)throw new at(`Nonexistent key: ${t.name}`);return this.id2Value[t.id]}{const e=this.name2Id[t];if(e==null)throw new at(`Feed dict has no SymbolicTensor name: ${t}`);return this.id2Value[e]}}
/**
     * Get the feed mask for given key.
     * @param key The SymbolicTensor, or its name (as a string), of which the
     *     value is sought.
     * @returns If `key` exists, the corresponding feed mask.
     * @throws ValueError: If `key` does not exist in this `FeedDict`.
     */getMask(t){if(t instanceof SymbolicTensor){if(this.id2Value[t.id]==null)throw new at(`Nonexistent key: ${t.name}`);return this.id2Mask[t.id]}{const e=this.name2Id[t];if(e==null)throw new at(`Feed dict has no SymbolicTensor name: ${t}`);return this.id2Mask[e]}}disposeMasks(){this.id2Mask!=null&&w(this.id2Mask)}}const Gt=new LruCache;const Ht=new LruCache;function updateCacheMaxEntries(t){Gt!=null&&Gt.setMaxEntries(t);Ht!=null&&Ht.setMaxEntries(t)}
/**
 * Execute a SymbolicTensor by using concrete feed values.
 *
 * A `SymbolicTensor` object is a node in a computation graph of TF.js
 * Layers. The object is backed by a source layer and input
 * `SymbolicTensor`s to the source layer. This method evaluates
 * the `call()` method of the source layer, using concrete values of the
 * inputs obtained from either
 * * `feedDict`, if the input key exists in `feedDict`, or else,
 * * a recursive call to `execute()` itself.
 *
 * @param x: The `SymbolicTensor` to execute.
 * @param feedDict: The feed values, as base condition of the recursion.
 *   execution.
 * @param kwargs: Optional keyword arguments.
 * @param probe: A probe object (of interface `ExecutionProbe`) used for
 *   testing memory footprint of `execute` calls.
 * @returns Result of the execution.
 * @throws ValueError: If any `SymbolicTensor`s from `InputLayer`s
 *   encountered during the execution lacks a feed value in `feedDict`.
 */function execute(t,e,s,n){const i=s!=null&&s.training;const a=Array.isArray(t);const r=a?t:[t];const o=r.map((t=>t.name));const l=[];const u=e.names();for(const t of o)u.indexOf(t)!==-1?l.push(e.getValue(t)):l.push(null);if(n!=null){n.maxNumTensors=-Infinity;n.minNumTensors=Infinity}const h=o.join(",")+"|"+e.names().sort().join(",");let c=Gt.get(h);let p;if(c==null){const t=getTopologicalSortAndRecipientCounts(r,e);c=t.sorted;p=t.recipientCounts;Gt.put(h,c);Ht.put(h,p)}p={};i||Object.assign(p,Ht.get(h));const d=new FeedDict(e);for(let t=0;t<c.length;++t){if(n!=null){const t=S().numTensors;t>n.maxNumTensors&&(n.maxNumTensors=t);t<n.minNumTensors&&(n.minNumTensors=t)}const a=c[t];const r=a.sourceLayer;if(r instanceof InputLayer)continue;const u=[];const h=[];const g=[];let m=false;for(const t of a.inputs){const s=d.getValue(t);const n=d.getMask(t);u.push(s);h.push(n);n!=null&&(m=true);if(!i){p[t.name]--;p[t.name]!==0||e.hasKey(t)||o.indexOf(t.name)!==-1||s.isDisposed||t.sourceLayer.stateful===true||g.push(s)}}if(m){s=s||{};s.mask=h[0]}const f=dt(r.apply(u,s));let y=null;r.supportsMasking&&(y=r.computeMask(u,h));const b=getNodeOutputs(a);const C=Array.isArray(b)?b:[b];for(let t=0;t<C.length;++t){d.hasKey(C[t])||d.add(C[t],f[t],Array.isArray(y)?y[0]:y);const e=o.indexOf(C[t].name);e!==-1&&(l[e]=f[t])}i||w(g)}d.disposeMasks();return a?l:l[0]}
/**
 * Sort the `SymbolicTensor`s topologically, for an array of fetches.
 *
 * This function calls getTopologicalSortAndRecipientCountsForOneFetch and
 * merges their results.
 *
 * @param fetch The array of fetches requested. Must be a non-empty array.
 * @param feedDict The dictionary of fed values.
 * @returns sorted: Topologically-sorted array of SymbolicTensors.
 *   recipientCounts: Recipient counts for all SymbolicTensors in `sorted`.
 */function getTopologicalSortAndRecipientCounts(t,e){m.assert(t!=null&&t.length>0,(()=>"Expected at least one fetch, got none"));let s=[];let n={};if(t.length===1){const i=getTopologicalSortAndRecipientCountsForOneFetch(t[0],e);s=i.sorted;n=i.recipientMap}else{const i=new Set;for(const a of t){const{sorted:t,recipientMap:r}=getTopologicalSortAndRecipientCountsForOneFetch(a,e);for(const e of t)if(!i.has(e.name)){s.push(e);i.add(e.name)}for(const t in r){n[t]==null&&(n[t]=new Set);r[t].forEach((e=>n[t].add(e)))}}}return{sorted:s,recipientCounts:recipientMap2Counts(n)}}function recipientMap2Counts(t){const e={};for(const s in t)e[s]=t[s].size;return e}
/**
 * Sort the `SymbolicTensor`s topologically, for a single fetch.
 *
 * This helper function processes the upstream SymbolicTensors of a single
 * fetch.
 *
 * @param fetch The single fetch requested.
 * @param feedDict The dictionary of fed values.
 * @returns sorted: Topologically-sorted array of SymbolicTensors.
 *   recipientMap: Recipient names for all SymbolicTensors in `sorted`.
 */function getTopologicalSortAndRecipientCountsForOneFetch(t,e){const s=new Set;const n=[];const i={};for(const t of e.names())s.add(t);const a=[];const r=[];a.push(t);while(a.length>0){const t=a[a.length-1];if(s.has(t.name)){a.pop();continue}const e=r[r.length-1]===a.length-1;if(t.inputs.length===0||e){a.pop();n.push(t);s.add(t.name);e&&r.pop()}else{r.push(a.length-1);for(const e of t.inputs){i[e.name]==null&&(i[e.name]=new Set);i[e.name].add(t.name);s.has(e.name)||a.push(e)}}}return{sorted:n,recipientMap:i}}
/**
 * Get the symbolic output tensors of the node to which a given fetch belongs.
 * @param fetch The fetched symbolic tensor.
 * @returns The Array of symbolic tensors output by the node to which `fetch`
 *   belongs.
 */function getNodeOutputs(t){let e;if(t.sourceLayer.inboundNodes.length===1)e=t.sourceLayer.output;else{let s=null;for(let e=0;e<t.sourceLayer.inboundNodes.length;++e)for(const n of t.sourceLayer.inboundNodes[e].outputTensors)if(n.id===t.id){s=e;break}e=t.sourceLayer.getOutputAt(s)}return e}
/**
 * @license
 * Copyright 2022 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Jt=C();Jt.registerFlag("TOPOLOGICAL_SORT_CACHE_MAX_ENTRIES",(()=>100),updateCacheMaxEntries);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function calcL2Norms(e,n){return s((()=>t.sqrt(t.sum(t.mul(e,e),n,true))))}class Constraint extends l.Serializable{getConfig(){return{}}}class MaxNorm extends Constraint{constructor(t){super();this.defaultMaxValue=2;this.defaultAxis=0;this.maxValue=t.maxValue!=null?t.maxValue:this.defaultMaxValue;this.axis=t.axis!=null?t.axis:this.defaultAxis}apply(e){return s((()=>{const s=calcL2Norms(e,this.axis);const n=t.clipByValue(s,0,this.maxValue);return t.mul(e,t.div(n,t.add(epsilon(),s)))}))}getConfig(){return{maxValue:this.maxValue,axis:this.axis}}}MaxNorm.className="MaxNorm";l.registerClass(MaxNorm);class UnitNorm extends Constraint{constructor(t){super();this.defaultAxis=0;this.axis=t.axis!=null?t.axis:this.defaultAxis}apply(e){return s((()=>t.div(e,t.add(epsilon(),calcL2Norms(e,this.axis)))))}getConfig(){return{axis:this.axis}}}UnitNorm.className="UnitNorm";l.registerClass(UnitNorm);class NonNeg extends Constraint{apply(e){return t.relu(e)}}NonNeg.className="NonNeg";l.registerClass(NonNeg);class MinMaxNorm extends Constraint{constructor(t){super();this.defaultMinValue=0;this.defaultMaxValue=1;this.defaultRate=1;this.defaultAxis=0;this.minValue=t.minValue!=null?t.minValue:this.defaultMinValue;this.maxValue=t.maxValue!=null?t.maxValue:this.defaultMaxValue;this.rate=t.rate!=null?t.rate:this.defaultRate;this.axis=t.axis!=null?t.axis:this.defaultAxis}apply(e){return s((()=>{const s=calcL2Norms(e,this.axis);const n=t.add(t.mul(this.rate,t.clipByValue(s,this.minValue,this.maxValue)),t.mul(1-this.rate,s));return t.mul(e,t.div(n,t.add(epsilon(),s)))}))}getConfig(){return{minValue:this.minValue,maxValue:this.maxValue,rate:this.rate,axis:this.axis}}}MinMaxNorm.className="MinMaxNorm";l.registerClass(MinMaxNorm);const Zt={maxNorm:"MaxNorm",minMaxNorm:"MinMaxNorm",nonNeg:"NonNeg",unitNorm:"UnitNorm"};function serializeConstraint(t){return lt(t)}function deserializeConstraint(t,e={}){return ot(t,l.SerializationMap.getMap().classNameMap,e,"constraint")}function getConstraint(t){if(t==null)return null;if(typeof t==="string"){const e=t in Zt?Zt[t]:t;const s={className:e,config:{}};return deserializeConstraint(s)}return t instanceof Constraint?t:deserializeConstraint(t)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function maxNorm(t){return new MaxNorm(t)}function unitNorm(t){return new UnitNorm(t)}function nonNeg(){return new NonNeg}function minMaxNorm(t){return new MinMaxNorm(t)}var Kt=Object.freeze(Object.defineProperty({__proto__:null,maxNorm:maxNorm,minMaxNorm:minMaxNorm,nonNeg:nonNeg,unitNorm:unitNorm},Symbol.toStringTag,{value:"Module"}));
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function zeros(){return new Zeros}function ones(){return new Ones}function constant(t){return new Constant(t)}function randomUniform(t){return new RandomUniform(t)}function randomNormal(t){return new RandomNormal(t)}function truncatedNormal(t){return new TruncatedNormal(t)}function identity(t){return new Identity(t)}function varianceScaling(t){return new VarianceScaling(t)}function glorotUniform(t){return new GlorotUniform(t)}function glorotNormal(t){return new GlorotNormal(t)}function heNormal(t){return new HeNormal(t)}function heUniform(t){return new HeUniform(t)}function leCunNormal(t){return new LeCunNormal(t)}function leCunUniform(t){return new LeCunUniform(t)}function orthogonal(t){return new Orthogonal(t)}var Yt=Object.freeze(Object.defineProperty({__proto__:null,constant:constant,glorotNormal:glorotNormal,glorotUniform:glorotUniform,heNormal:heNormal,heUniform:heUniform,identity:identity,leCunNormal:leCunNormal,leCunUniform:leCunUniform,ones:ones,orthogonal:orthogonal,randomNormal:randomNormal,randomUniform:randomUniform,truncatedNormal:truncatedNormal,varianceScaling:varianceScaling,zeros:zeros},Symbol.toStringTag,{value:"Module"}));
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Turn any Scalar values in a Logs object into actual number values.
 *
 * @param logs The `Logs` object to be resolved in place.
 */async function resolveScalarsInLogs(t){if(t==null)return;const e=[];const s=[];const n=[];for(const i in t){const a=t[i];if(typeof a!=="number"){const t=a;e.push(t.data());s.push(i);n.push(t)}}if(e.length>0){const i=await Promise.all(e);for(let e=0;e<i.length;++e)t[s[e]]=i[e][0];w(n)}}
/**
 * Dispose all Tensors in an UnresolvedLogs object.
 *
 * @param logs An `UnresolvedLogs` object potentially containing `tf.Tensor`s in
 *   places where the values can be `tf.Tensor` or `number`.
 */function disposeTensorsInLogs(t){if(t!=null)for(const e in t){const s=t[e];typeof s!=="number"&&s.dispose()}}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */var Xt;(function(t){t[t.SILENT=0]="SILENT";t[t.VERBOSE=1]="VERBOSE"})(Xt||(Xt={}));const Qt=125;class BaseCallback{constructor(){this.validationData=null}setParams(t){this.params=t}async onEpochBegin(t,e){}async onEpochEnd(t,e){}async onBatchBegin(t,e){}async onBatchEnd(t,e){}async onTrainBegin(t){}async onTrainEnd(t){}setModel(t){}}class CallbackList{
/**
     * Constructor of CallbackList.
     * @param callbacks Array of `Callback` instances.
     * @param queueLength Queue length for keeping running statistics over
     *   callback execution time.
     */
constructor(t,e=10){t==null&&(t=[]);this.callbacks=t;this.queueLength=e}append(t){this.callbacks.push(t)}setParams(t){for(const e of this.callbacks)e.setParams(t)}setModel(t){for(const e of this.callbacks)e.setModel(t)}
/**
     * Called at the start of an epoch.
     * @param epoch Index of epoch.
     * @param logs Dictionary of logs.
     */async onEpochBegin(t,e){e==null&&(e={});for(const s of this.callbacks)await s.onEpochBegin(t,e)}
/**
     * Called at the end of an epoch.
     * @param epoch Index of epoch.
     * @param logs Dictionary of logs.
     */async onEpochEnd(t,e){e==null&&(e={});for(const s of this.callbacks)await s.onEpochEnd(t,e)}
/**
     * Called  right before processing a batch.
     * @param batch Index of batch within the current epoch.
     * @param logs Dictionary of logs.
     */async onBatchBegin(t,e){e==null&&(e={});for(const s of this.callbacks)await s.onBatchBegin(t,e)}
/**
     * Called at the end of a batch.
     * @param batch Index of batch within the current epoch.
     * @param logs Dictionary of logs.
     */async onBatchEnd(t,e){e==null&&(e={});for(const s of this.callbacks)await s.onBatchEnd(t,e)}
/**
     * Called at the beginning of training.
     * @param logs Dictionary of logs.
     */async onTrainBegin(t){t==null&&(t={});for(const e of this.callbacks)await e.onTrainBegin(t)}
/**
     * Called at the end of training.
     * @param logs Dictionary of logs.
     */async onTrainEnd(t){t==null&&(t={});for(const e of this.callbacks)await e.onTrainEnd(t)}}class BaseLogger extends BaseCallback{constructor(){super()}async onEpochBegin(t){this.seen=0;this.totals={}}async onBatchEnd(t,e){e==null&&(e={});const n=e.size==null?0:e.size;this.seen+=n;for(const t in e){const i=e[t];if(typeof i==="number"){this.totals.hasOwnProperty(t)||(this.totals[t]=0);this.totals[t]=this.totals[t]+i*n}else{let e;t in this.totals?e=this.totals[t]:this.totals[t]=0;const a=s((()=>z(this.totals[t],c(i,n))));this.totals[t]=a;e!=null&&e.dispose()}}}async onEpochEnd(t,e){if(e!=null)for(const t of this.params.metrics)this.totals[t]!=null&&(typeof this.totals[t]==="number"?e[t]=this.totals[t]/this.seen:s((()=>{const s=c(N(1,this.seen),this.totals[t]);e[t]=s;this.totals[t].dispose();k(e[t])})))}}class History extends BaseCallback{async onTrainBegin(t){this.epoch=[];this.history={}}async onEpochEnd(t,e){e==null&&(e={});this.epoch.push(t);for(const t in e){this.history[t]==null&&(this.history[t]=[]);this.history[t].push(e[t])}}async syncData(){const t=[];const e=[];const s=[];for(const n in this.history){const i=this.history[n];for(let a=0;a<i.length;++a)if(typeof i[a]!=="number"){const r=i[a];t.push(r.data());e.push(n);s.push(a)}}const n=await Promise.all(t);for(let t=0;t<n.length;++t){const i=this.history[e[t]][s[t]];i.dispose();this.history[e[t]][s[t]]=n[t][0]}}}class CustomCallback extends BaseCallback{constructor(t,e){super();this.currentEpoch=0;this.nowFunc=t.nowFunc;this.nextFrameFunc=t.nextFrameFunc||v;this.yieldEvery=e||"auto";this.yieldEvery==="auto"&&(this.yieldEvery=Qt);if(this.yieldEvery==="never"&&t.onYield!=null)throw new Error("yieldEvery is `never` but you provided an `onYield` callback. Either change `yieldEvery` or remove the callback");m.isNumber(this.yieldEvery)&&(this.maybeWait=gt(this.maybeWait.bind(this),this.yieldEvery,this.nowFunc));this.trainBegin=t.onTrainBegin;this.trainEnd=t.onTrainEnd;this.epochBegin=t.onEpochBegin;this.epochEnd=t.onEpochEnd;this.batchBegin=t.onBatchBegin;this.batchEnd=t.onBatchEnd;this.yield=t.onYield}async maybeWait(t,e,s){const n=[];if(this.yield!=null){await resolveScalarsInLogs(s);n.push(this.yield(t,e,s))}n.push(this.nextFrameFunc());await Promise.all(n)}async onEpochBegin(t,e){this.currentEpoch=t;if(this.epochBegin!=null){await resolveScalarsInLogs(e);await this.epochBegin(t,e)}}async onEpochEnd(t,e){const s=[];if(this.epochEnd!=null){await resolveScalarsInLogs(e);s.push(this.epochEnd(t,e))}this.yieldEvery==="epoch"&&s.push(this.nextFrameFunc());await Promise.all(s)}async onBatchBegin(t,e){if(this.batchBegin!=null){await resolveScalarsInLogs(e);await this.batchBegin(t,e)}}async onBatchEnd(t,e){const s=[];if(this.batchEnd!=null){await resolveScalarsInLogs(e);s.push(this.batchEnd(t,e))}this.yieldEvery==="batch"?s.push(this.nextFrameFunc()):m.isNumber(this.yieldEvery)&&s.push(this.maybeWait(this.currentEpoch,t,e));await Promise.all(s)}async onTrainBegin(t){if(this.trainBegin!=null){await resolveScalarsInLogs(t);await this.trainBegin(t)}}async onTrainEnd(t){if(this.trainEnd!=null){await resolveScalarsInLogs(t);await this.trainEnd(t)}}}function standardizeCallbacks(t,e){t==null&&(t={});if(t instanceof BaseCallback)return[t];if(Array.isArray(t)&&t[0]instanceof BaseCallback)return t;const s=dt(t);return s.map((t=>new CustomCallback(t,e)))}class CallbackConstructorRegistry{constructor(){}
/**
     * Register a tf.LayersModel.fit() callback constructor.
     *
     * The registered callback constructor will be used to instantiate
     * callbacks for every tf.LayersModel.fit() call afterwards.
     *
     * @param verbosityLevel Level of verbosity at which the `callbackConstructor`
     *   is to be reigstered.
     * @param callbackConstructor A no-arg constructor for `tf.Callback`.
     * @throws Error, if the same callbackConstructor has been registered before,
     *   either at the same or a different `verbosityLevel`.
     */static registerCallbackConstructor(t,e){m.assert(t>=0&&Number.isInteger(t),(()=>`Verbosity level is expected to be an integer >= 0, but got ${t}`));CallbackConstructorRegistry.checkForDuplicate(e);CallbackConstructorRegistry.constructors[t]==null&&(CallbackConstructorRegistry.constructors[t]=[]);CallbackConstructorRegistry.constructors[t].push(e)}static checkForDuplicate(t){for(const e in CallbackConstructorRegistry.constructors){const s=CallbackConstructorRegistry.constructors[+e];s.forEach((e=>{if(e===t)throw new at("Duplicate callback constructor.")}))}}static clear(){CallbackConstructorRegistry.constructors={}}
/**
     * Create callbacks using the registered callback constructors.
     *
     * Given `verbosityLevel`, all constructors registered at that level or above
     * will be called and the instantiated callbacks will be used.
     *
     * @param verbosityLevel: Level of verbosity.
     */static createCallbacks(t){const e=[];for(const s in CallbackConstructorRegistry.constructors){const n=+s;t>=n&&e.push(...CallbackConstructorRegistry.constructors[n])}return e.map((t=>new t))}}CallbackConstructorRegistry.constructors={};function configureCallbacks(t,e,s,n,i,a,r,o,l){const u=new History;const h=[new BaseLogger,...CallbackConstructorRegistry.createCallbacks(e)];t!=null&&h.push(...t);h.push(u);const c=new CallbackList(h);c.setParams({epochs:s,initialEpoch:n,samples:i,steps:a,batchSize:r,verbose:e,doValidation:o,metrics:l});return{callbackList:c,history:u}}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Normalizes a tensor wrt the L2 norm alongside the specified axis.
 * @param x
 * @param axis Axis along which to perform normalization.
 */function l2Normalize(e,n){return s((()=>{e.dtype!=="float32"&&(e=t.cast(e,"float32"));const s=t.sum(square(e),n,true);const i=t.fill(s.shape,epsilon());const a=t.sqrt(t.maximum(s,i));return t.div(e,a)}))}function meanSquaredError$1(e,n){return s((()=>t.mean(square(t.sub(n,e)),-1)))}function meanAbsoluteError$1(e,n){return s((()=>t.mean(t.abs(t.sub(n,e)),-1)))}function meanAbsolutePercentageError$1(e,n){return s((()=>{const s=t.sub(e,n);const i=t.clipByValue(t.abs(e),epsilon(),Number.MAX_VALUE);const a=t.abs(t.div(s,i));return t.mul(100,t.mean(a,-1))}))}function meanSquaredLogarithmicError(e,n){return s((()=>{const s=t.clipByValue(n,epsilon(),Number.MAX_VALUE);const i=t.log(t.add(1,s));const a=t.clipByValue(e,epsilon(),Number.MAX_VALUE);const r=t.log(t.add(1,a));return t.mean(square(t.sub(i,r)),-1)}))}function squaredHinge(e,n){return s((()=>{const s=t.maximum(0,t.sub(1,t.mul(e,n)));return t.mean(square(s),-1)}))}function hinge(e,n){return s((()=>{const s=t.maximum(0,t.sub(1,t.mul(e,n)));return t.mean(s,-1)}))}function categoricalHinge(e,n){return s((()=>{const s=t.sum(t.mul(e,n),-1);const i=t.max(t.mul(t.sub(1,e),n),-1);return t.maximum(0,t.add(1,t.sub(i,s)))}))}function logcosh(e,n){return s((()=>{const s=Math.log(2);const i=t.sub(n,e);const a=t.sub(t.add(i,t.softplus(t.mul(-2,i))),s);return t.mean(a,-1)}))}function categoricalCrossentropy$2(e,n,i=false){return s((()=>{if(i)n=t.softmax(n);else{const e=t.sum(n,n.shape.length-1,true);n=t.div(n,e)}n=t.clipByValue(n,epsilon(),1-epsilon());return t.neg(t.sum(t.mul(t.cast(e,"float32"),t.log(n)),n.shape.length-1))}))}
/**
 * Categorical crossentropy with integer targets.
 *
 * @param target An integer tensor.
 * @param output A tensor resulting from a softmax (unless `fromLogits` is
 *  `true`, in which case `output` is expected to be the logits).
 * @param fromLogits Boolean, whether `output` is the result of a softmax, or is
 *   a tensor of logits.
 */function sparseCategoricalCrossentropy$1(e,n,i=false){return s((()=>{const s=t.cast(t.floor(flatten$1(e)),"int32");n=t.clipByValue(n,epsilon(),1-epsilon());const a=n.shape;const r=t.reshape(t.oneHot(s,a[a.length-1]),a);return categoricalCrossentropy$2(r,n,i)}))}
/**
 * From TensorFlow's implementation in nn_impl.py:
 *
 * For brevity, let `x = logits`, `z = labels`.  The logistic loss is
 *      z * -log(sigmoid(x)) + (1 - z) * -log(1 - sigmoid(x))
 *    = z * -log(1 / (1 + exp(-x))) + (1 - z) * -log(exp(-x) / (1 + exp(-x)))
 *    = z * log(1 + exp(-x)) + (1 - z) * (-log(exp(-x)) + log(1 + exp(-x)))
 *    = z * log(1 + exp(-x)) + (1 - z) * (x + log(1 + exp(-x))
 *    = (1 - z) * x + log(1 + exp(-x))
 *    = x - x * z + log(1 + exp(-x))
 * For x < 0, to avoid overflow in exp(-x), we reformulate the above
 *      x - x * z + log(1 + exp(-x))
 *    = log(exp(x)) - x * z + log(1 + exp(-x))
 *    = - x * z + log(1 + exp(x))
 * Hence, to ensure stability and avoid overflow, the implementation uses this
 * equivalent formulation
 *    max(x, 0) - x * z + log(1 + exp(-abs(x)))
 *
 * @param labels The labels.
 * @param logits The logits.
 */function sigmoidCrossEntropyWithLogits(e,n){if(!m.arraysEqual(e.shape,n.shape))throw new at(`logits and labels must have the same shape, but got shapes ${JSON.stringify(e.shape)} and ${JSON.stringify(n.shape)}`);return s((()=>{const s=t.relu(n);const i=t.neg(t.abs(n));return t.add(t.sub(s,t.mul(n,e)),t.log1p(t.exp(i)))}))}function binaryCrossentropy$2(e,n){return s((()=>{let s;s=t.clipByValue(n,epsilon(),1-epsilon());s=t.log(t.div(s,t.sub(1,s)));return t.mean(sigmoidCrossEntropyWithLogits(e,s),-1)}))}function kullbackLeiblerDivergence(e,n){return s((()=>{const s=t.clipByValue(e,epsilon(),1);const i=t.clipByValue(n,epsilon(),1);return t.sum(t.mul(e,t.log(t.div(s,i))),-1)}))}function poisson(e,n){return s((()=>{const s=t.log(t.add(epsilon(),n));return t.mean(t.sub(n,t.mul(e,s)),-1)}))}function cosineProximity$1(e,n){return s((()=>{const s=l2Normalize(e,-1);const i=l2Normalize(n,-1);const a=t.mul(s,i);return t.neg(t.sum(a,-1))}))}const te={meanSquaredError:meanSquaredError$1,meanAbsoluteError:meanAbsoluteError$1,meanAbsolutePercentageError:meanAbsolutePercentageError$1,meanSquaredLogarithmicError:meanSquaredLogarithmicError,squaredHinge:squaredHinge,hinge:hinge,categoricalHinge:categoricalHinge,logcosh:logcosh,categoricalCrossentropy:categoricalCrossentropy$2,sparseCategoricalCrossentropy:sparseCategoricalCrossentropy$1,binaryCrossentropy:binaryCrossentropy$2,kullbackLeiblerDivergence:kullbackLeiblerDivergence,poisson:poisson,cosineProximity:cosineProximity$1};function get$1(t){if(typeof t==="string"){if(t in te)return te[t];let e=`Unknown loss ${t}`;t.toLowerCase().includes("softmaxcrossentropy")&&(e=`Unknown loss ${t}. Use "categoricalCrossentropy" as the string name for tf.losses.softmaxCrossEntropy`);throw new at(e)}return t}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function binaryAccuracy$1(e,n){return s((()=>{const s=t.mul(.5,t.onesLike(n));const i=cast(t.greater(n,s),e.dtype);return t.mean(t.equal(e,i),-1)}))}function categoricalAccuracy$1(e,n){return s((()=>cast(t.equal(t.argMax(e,-1),t.argMax(n,-1)),"float32")))}function truePositives(e,n){return s((()=>t.cast(t.sum(t.logicalAnd(t.equal(e,1),t.equal(n,1))),"float32")))}function falseNegatives(e,n){return s((()=>t.cast(t.sum(t.logicalAnd(t.equal(e,1),t.equal(n,0))),"float32")))}function falsePositives(e,n){return s((()=>t.cast(t.sum(t.logicalAnd(t.equal(e,0),t.equal(n,1))),"float32")))}function precision$1(e,n){return s((()=>{const s=truePositives(e,n);const i=falsePositives(e,n);const a=t.add(s,i);return t.cast(t.where(t.greater(a,0),t.div(s,a),0),"float32")}))}function recall$1(e,n){return s((()=>{const s=truePositives(e,n);const i=falseNegatives(e,n);const a=t.add(s,i);return t.cast(t.where(t.greater(a,0),t.div(s,a),0),"float32")}))}function binaryCrossentropy$1(t,e){return binaryCrossentropy$2(t,e)}function sparseCategoricalAccuracy$1(e,s){e.rank===s.rank&&(e=t.squeeze(e,[e.rank-1]));s=t.argMax(s,-1);s.dtype!==e.dtype&&(s=t.cast(s,e.dtype));return t.cast(t.equal(e,s),"float32")}const ee=meanSquaredError$1;const se=meanSquaredError$1;const ne=meanAbsoluteError$1;const ie=meanAbsoluteError$1;const ae=meanAbsolutePercentageError$1;const re=meanAbsolutePercentageError$1;const oe=categoricalCrossentropy$2;const le=cosineProximity$1;const ue=sparseCategoricalCrossentropy$1;const he={binaryAccuracy:binaryAccuracy$1,categoricalAccuracy:categoricalAccuracy$1,precision:precision$1,categoricalCrossentropy:oe,sparseCategoricalCrossentropy:ue,mse:ee,MSE:se,mae:ne,MAE:ie,mape:ae,MAPE:re,cosine:le};function get(t){if(typeof t==="string"&&t in he)return he[t];if(typeof t!=="string"&&t!=null)return t;throw new at(`Unknown metric ${t}`)}
/**
 * Get the shortcut function name.
 *
 * If the fn name is a string,
 *   directly return the string name.
 * If the function is included in metricsMap or lossesMap,
 *   return key of the map.
 *   - If the function relative to multiple keys,
 *     return the first found key as the function name.
 *   - If the function exists in both lossesMap and metricsMap,
 *     search lossesMap first.
 * If the function is not included in metricsMap or lossesMap,
 *   return the function name.
 *
 * @param fn loss function, metric function, or short cut name.
 * @returns Loss or Metric name in string.
 */function getLossOrMetricName(t){mt(t!==null,`Unknown LossOrMetricFn ${t}`);if(typeof t==="string")return t;{let e;for(const s of Object.keys(te))if(te[s]===t){e=s;break}if(e!==void 0)return e;for(const s of Object.keys(he))if(he[s]===t){e=s;break}return e!==void 0?e:t.name}}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function getOptimizer(t){const e={Adagrad:()=>A.adagrad(.01),Adadelta:()=>A.adadelta(1,.95,epsilon()),Adam:()=>A.adam(.001,.9,.999,epsilon()),Adamax:()=>A.adamax(.002,.9,.999,epsilon(),0),RMSProp:()=>A.rmsprop(.001,.9,0,epsilon()),SGD:()=>A.sgd(.01)};e.adagrad=e.Adagrad;e.adadelta=e.Adadelta;e.adam=e.Adam;e.adamax=e.Adamax;e.rmsprop=e.RMSProp;e.sgd=e.SGD;if(t in e)return e[t]();throw new at(`Unknown Optimizer ${t}`)}
/**
 * @license
 * Copyright 2019 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const ce=1048576;
/**
 * Check validity of user-defined metadata.
 *
 * @param userDefinedMetadata
 * @param modelName Name of the model that the user-defined metadata belongs to.
 *   Used during construction of error messages.
 * @param checkSize Whether to check the size of the metadata is under
 *   recommended limit. Default: `false`. If `true`, will try stringify the
 *   JSON object and print a console warning if the serialzied size is above the
 *   limit.
 * @throws Error if `userDefinedMetadata` is not a plain JSON object.
 */function checkUserDefinedMetadata(t,e,s=false){if(t==null||typeof t!=="object"||Object.getPrototypeOf(t)!==Object.prototype||!plainObjectCheck(t))throw new Error("User-defined metadata is expected to be a JSON object, but is not.");if(s){const s=JSON.stringify(t);s.length>ce&&console.warn(`User-defined metadata of model "${e}" is too large in size (length=${s.length} when serialized). It is not recommended to store such large objects in user-defined metadata. Please make sure its serialized length is <= ${ce}.`)}}
/**
 * Check if an input is plain JSON object or any valid subfield of it.
 *
 * @param x The input to be checked.
 * @param assertObject Whether to assert `x` is a JSON object, i.e., reject
 *   cases of arrays and primitives.
 * @return Returns `true` if and only if `x` is a plain JSON object,
 *   a JSON-valid primitive including string, number, boolean and null,
 *   or an array of the said types.
 */function plainObjectCheck(t){if(t===null)return true;if(typeof t==="object"){if(Object.getPrototypeOf(t)===Object.prototype){const e=Object.keys(t);for(const s of e){if(typeof s!=="string")return false;if(!plainObjectCheck(t[s]))return false}return true}if(Array.isArray(t)){for(const e of t)if(!plainObjectCheck(e))return false;return true}return false}{const e=typeof t;return e==="string"||e==="number"||e==="boolean"}}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Print the summary of a LayersModel object.
 *
 * @param model tf.LayersModel instance.
 * @param lineLength Total length of printed lines. Set this to adapt to the
 *   display to different terminal or console sizes.
 * @param positions Relative or absolute positions of log elements in each
 *   line. Each number corresponds to right-most (i.e., ending) position of a
 *   column.
 *   If not provided, defaults to `[0.45, 0.85, 1]` for sequential-like
 *   models and `[0.33, 0.55, 0.67, 1]` for non-sequential like models.
 * @param printFn Print function to use.
 *   It will be called on each line of the summary. You can provide a custom
 *   function in order to capture the string summary. Defaults to `console.log`.
 */function printSummary(t,e,s,n=console.log){const i=isModelSequentialLike(t);const a=["Layer (type)","Input Shape","Output shape","Param #"];if(i){e=e||90;s=s||[.32,.61,.89,1]}else{e=e||115;s=s||[.24,.48,.7,.8,1]}s[s.length-1]<=1&&(s=s.map((t=>Math.floor(e*t))));let r;if(!i){a.push("Receives inputs");r=[];for(const e in t.nodesByDepth)r.push(...t.nodesByDepth[e])}n("_".repeat(e));printRow(a,s,n);n("=".repeat(e));const o=t.layers;for(let t=0;t<o.length;++t){i?printLayerSummary(o[t],s,n):printLayerSummaryWithConnections(o[t],s,r,n);n((t===o.length-1?"=":"_").repeat(e))}t.checkTrainableWeightsConsistency();const l=countTrainableParams(t);const u=countParamsInWeights(t.nonTrainableWeights);n(`Total params: ${l+u}`);n(`Trainable params: ${l}`);n(`Non-trainable params: ${u}`);n("_".repeat(e))}function countTrainableParams(t){let e;e=t.collectedTrainableWeights!=null?countParamsInWeights(t.collectedTrainableWeights):countParamsInWeights(t.trainableWeights);return e}function isModelSequentialLike(t){let e=true;const s=[];const n=[];for(const e in t.nodesByDepth)s.push(t.nodesByDepth[e]);for(const t of s){if(t.length>1||t.length===1&&t[0].inboundLayers.length>1){e=false;break}n.push(...t)}if(e)for(const s of t.layers){let t=false;for(const i of s.inboundNodes)if(n.indexOf(i)!==-1){if(t){e=false;break}t=true}if(!e)break}return e}function printRow(t,e,s=console.log){let n="";for(let s=0;s<t.length;++s){s>0&&(n=n.slice(0,n.length-1)+" ");n+=t[s];n=n.slice(0,e[s]);n+=" ".repeat(e[s]-n.length)}s(n)}
/**
 * Prints a summary for a single Layer, without connectivity information.
 *
 * @param layer: Layer instance to print.
 */function printLayerSummary(t,e,s){let n;let i;try{i=t.inboundNodes.map((t=>JSON.stringify(t.inputShapes))).join(",")}catch(t){i="multiple"}try{n=JSON.stringify(t.outputShape)}catch(t){n="multiple"}const a=t.name;const r=t.getClassName();const o=[`${a} (${r})`,i,n,t.countParams().toString()];printRow(o,e,s)}function printLayerSummaryWithConnections(t,e,s,n){let i;let a;try{a=t.inboundNodes.map((t=>JSON.stringify(t.inputShapes))).join(",")}catch(t){a="multiple"}try{i=JSON.stringify(t.outputShape)}catch(t){i="multiple"}const r=[];for(const e of t.inboundNodes)if(!(s!=null&&s.length>0&&s.indexOf(e)===-1))for(let t=0;t<e.inboundLayers.length;++t){const s=e.inboundLayers[t].name;const n=e.nodeIndices[t];const i=e.tensorIndices[t];r.push(`${s}[${n}][${i}]`)}const o=t.name;const l=t.getClassName();const u=r.length===0?"":r[0];const h=[`${o} (${l})`,a,i,t.countParams().toString(),u];printRow(h,e,n);for(let t=1;t<r.length;++t)printRow(["","","","",r[t]],e,n)}
/** @license See the LICENSE file. */const pe="4.20.0";
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const isKerasSavedModelFormat=t=>{const e=Object.keys(t);if(e.length===0)return false;const s=e[0].split("/");return!isNaN(parseInt(s[s.length-1],10))};class Container extends Layer{constructor(t){super({});this.containerNodes=new Set;this.name=t.name;if(this.name==null){const t=this.getClassName().toLowerCase();this.name=getUid(t)}this.supportsMasking=false;this.trainable_=true;Array.isArray(t.inputs)?this.inputs=t.inputs.slice():this.inputs=[t.inputs];Array.isArray(t.outputs)?this.outputs=t.outputs.slice():this.outputs=[t.outputs];if(ft(this.inputs).length!==this.inputs.length)throw new at(`The list of inputs passed to the model is redundant. All inputs should only appear once. Found: ${this.inputs.map((t=>t.name))}`);ft(this.outputs).length!==this.outputs.length&&console.warn(`The list of outputs passed to the model is redundant. All outputs should only appear once. Found: ${this.outputs.map((t=>t.name))}`);this.inputLayers=[];this.inputLayersNodeIndices=[];this.inputLayersTensorIndices=[];this.outputLayers=[];this.outputLayersNodeIndices=[];this.outputLayersTensorIndices=[];this.layers=[];this.internalContainerRefs=[];for(const t of this.outputs){const e=t.sourceLayer;const s=t.nodeIndex;const n=t.tensorIndex;this.outputLayers.push(e);this.outputLayersNodeIndices.push(s);this.outputLayersTensorIndices.push(n)}for(const t of this.inputs){const e=t.sourceLayer;const s=t.nodeIndex;const n=t.tensorIndex;mt(s===0,"input layer has >1 nodes");mt(n===0,"input layer has >1 tensors");this.inputLayers.push(e);this.inputLayersNodeIndices.push(s);this.inputLayersTensorIndices.push(n)}this.inputNames=[];this.outputNames=[];this.feedInputShapes=[];this.feedInputNames=[];this.feedOutputNames=[];for(let e=0;e<this.inputLayers.length;e++){const s=this.inputLayers[e];if(!(s instanceof InputLayer))throw new TypeError(`Input layers to a LayersModel must be InputLayer objects. Received inputs: ${t.inputs}. Input ${e} (0-based) originates from layer type ${s.getClassName()}.`);this.inputNames.push(s.name);this.feedInputShapes.push(s.batchInputShape);this.feedInputNames.push(s.name)}for(const t of this.outputLayers)this.outputNames.push(t.name);this.internalInputShapes=this.inputs.map((t=>t.shape));this.internalOutputShapes=this.outputs.map((t=>t.shape));const e={};const s={};const n={};const i={};const a={};const r=[];
/**
         * Builds a map of the graph of layers.
         *
         * This recursively updates the map `layerIndices`,
         * the list `nodesInDecreasingDepth` and the set `containerNodes`.
         *
         * @param tensor Some tensor in a graph.
         * @param finishedNodes Set of nodes whose subgraphs have been traversed
         *         completely. Useful to prevent duplicated work.
         * @param nodesInProgress Set of nodes that are currently active on the
         *         recursion stack. Useful to detect cycles.
         * @param layer Layer from which `tensor` comes from. If not provided,
         *   will be obtained from tensor.sourceLayer.
         * @param nodeIndex Node index from which `tensor` comes from.
         * @param tensorIndex TensorIndex from which `tensor` comes from.
         *
         * @exception RuntimeError if a cycle is detected.
         */const buildMapOfGraph=(t,e,s,n,i,o)=>{if(n==null||i==null||o==null){n=t.sourceLayer;i=t.nodeIndex;o=t.tensorIndex}const l=n.inboundNodes[i];if(s.indexOf(l)!==-1)throw new ht(`The tensor ${t.name} at layer "${n.name}" is part of a cycle.`);if(e.indexOf(l)!==-1)return;this.containerNodes.add(Container.nodeKey(n,i));n.id in a||(a[n.id]=Object.keys(a).length);s.indexOf(l)===-1&&s.push(l);const u=l.inboundLayers.length;for(let t=0;t<u;t++){const n=l.inputTensors[t];const i=l.inboundLayers[t];const a=l.nodeIndices[t];const r=l.tensorIndices[t];buildMapOfGraph(n,e,s,i,a,r)}e.push(l);while(s.indexOf(l)>=0)s.splice(s.indexOf(l),1);r.push(l)};const o=[];const l=[];for(const t of this.outputs)buildMapOfGraph(t,o,l);const u=r.slice().reverse();for(const t of u){s[t.id]=t;t.id in e||(e[t.id]=0);let a=e[t.id];const r=n[t.outboundLayer.id]==null?0:n[t.outboundLayer.id];a=Math.max(a,r);n[t.outboundLayer.id]=a;i[t.outboundLayer.id]=t.outboundLayer;e[t.id]=a;for(let n=0;n<t.inboundLayers.length;n++){const i=t.inboundLayers[n];const r=t.nodeIndices[n];const o=i.inboundNodes[r];const l=e[o.id]==null?0:e[o.id];e[o.id]=Math.max(a+1,l);s[o.id]=o}}const h={};for(const t in e){const n=e[t];n in h||(h[n]=[]);h[n].push(s[t])}const c={};for(const t in n){const e=n[t];e in c||(c[e]=[]);c[e].push(i[t])}let p=Object.keys(c).map((t=>parseInt(t,10))).sort(yt);this.layers=[];for(const t of p){const e=c[t];e.sort(((t,e)=>{const s=a[t.id];const n=a[e.id];return s<n?-1:s>n?1:0}));for(const t of e){t instanceof Container&&this.internalContainerRefs.push(t);this.layers.push(t)}}this.layersByDepth=c;p=Object.keys(h).map((t=>parseInt(t,10))).sort(yt);const d=this.inputs.slice();const g=[];for(const t of p)for(const e of h[t]){const t=e.outboundLayer;if(t!=null){for(const s of e.inputTensors)if(d.indexOf(s)===-1)throw new ht(`Graph disconnected: cannot obtain value for tensor ${s} at layer "${t.name}". The following previous layers were accessed without issue: ${g}`);for(const t of e.outputTensors)d.push(t);g.push(t.name)}}this.nodesByDepth=h;const m=this.layers.map((t=>t.name));for(const t of m){const e=m.filter((e=>e===t)).length;if(e!==1)throw new ht(`The name "${t}" is used ${e} times in the model. All layer names should be unique. Layer names: `+JSON.stringify(m))}this.outboundNodes=[];this.inboundNodes=[];new Node({outboundLayer:this,inboundLayers:[],nodeIndices:[],tensorIndices:[],inputTensors:this.inputs,outputTensors:this.outputs,inputMasks:this.inputs.map((t=>null)),outputMasks:this.outputs.map((t=>null)),inputShapes:this.inputs.map((t=>t.shape)),outputShapes:this.outputs.map((t=>t.shape))});this.built=true;this._refCount=1}assertNotDisposed(){if(this._refCount===0)throw new Error(`Container '${this.name}' is already disposed.`)}
/**
     * Attempt to dispose a LayersModel's weights.
     *
     * This method decrease the reference count of the LayersModel object by 1.
     *
     * A LayersModel is reference-counted. Its reference count is incremented by 1
     * when it is first constructed and when it is used as a Layer of another
     * LayersModel.
     *
     * If the reference count of a LayersModel becomes 0, the `dispose` method of
     * all its constituent `Layer`s will be called.
     *
     * Note: If the reference count is greater than 0 after the decrement, the
     * `dispose` method of its constituent `Layer`s will *not* be called.
     *
     * After a LayersModel is disposed, it cannot be used in calls such as
     * 'predict`, `evaluate` or `fit` anymore.
     *
     * @returns A DisposeResult Object with the following fields:
     *   - refCountAfterDispose: The reference count of the LayersModel after this
     *     `dispose()` call.
     *   - numDisposedVariables: Number of `tf.Variable`s (i.e., weights) disposed
     *     during this `dispose()` call.
     * @throws {Error} If the layer is not built yet, or if the LayersModel has
     *   already been disposed.
     */dispose(){this.assertNotDisposed();const t={refCountAfterDispose:null,numDisposedVariables:0};if(--this._refCount===0){for(const e of this.layers)t.numDisposedVariables+=e.dispose().numDisposedVariables;for(const e of this.internalContainerRefs)t.numDisposedVariables+=e.dispose().numDisposedVariables}t.refCountAfterDispose=this._refCount;return t}get trainable(){return this.trainable_}set trainable(t){this.layers.forEach((e=>{e._trainableWeights.forEach((e=>e.trainable=t))}));this.trainable_=t}get trainableWeights(){if(this._trainableWeights.length>0)throw new at("Container instance unexpectedly contains _trainableWeights.The trainable weights of a Container are a union of the trainable weights of its consituent Layers. Its own _trainableWeights must remain an empty Array.");if(!this.trainable)return[];let t=[];for(const e of this.layers)t=t.concat(e.trainableWeights);return t}get nonTrainableWeights(){const t=[];for(const e of this.layers)t.push(...e.nonTrainableWeights);if(!this.trainable){const e=[];for(const t of this.layers)e.push(...t.trainableWeights);return e.concat(t)}return t}get weights(){return this.trainableWeights.concat(this.nonTrainableWeights)}
/**
     * Loads all layer weights from a JSON object.
     *
     * Porting Note: HDF5 weight files cannot be directly loaded in JavaScript /
     *   TypeScript. The utility script at `scripts/pykeras.py` offers means
     *   to convert them into JSON strings compatible with this method.
     * Porting Note: TensorFlow.js Layers supports only loading by name currently.
     *
     * @param weights A JSON mapping weight names to weight values as nested
     *   arrays of numbers, or a `NamedTensorMap`, i.e., a JSON mapping weight
     *   names to `tf.Tensor` objects.
     * @param strict Require that the provided weights exactly match those
     *   required by the container.  Default: `true`.  Passing `false` means that
     *   extra weights and missing weights will be silently ignored.
     */loadWeights(t,e=true){const s={};let n=0;const i=isKerasSavedModelFormat(t);i&&this.parseWeights(t);for(const t of this.layers)for(const[e,a]of t.weights.entries()){const t=i?`${a.name.split("/").slice(0,-1).join("/")+"/"}${e}`:a.originalName;if(s[t]!=null)throw new at(`Duplicate weight name: ${t}`);s[t]=a;n++}const a=[];for(const n in t){let i=n;if(s[n]==null){const t=n.split("/");const e=t.slice(0,-2).concat([t[t.length-1]]);i=e.join("/")}if(s[i]!=null)a.push([s[i],t[n]]);else if(e)throw new at(`Provided weight data has no target variable: ${n}`);delete s[i]}if(e){const t=[];for(const e in s)t.push(e);if(t.length>0)throw new at(`${t.length} of ${n} weights are not set: ${t}`)}batchSetValue(a)}parseWeights(t){for(const e in Object.keys(t)){const s=e.split("/");const n=["vars","layer_checkpoint_dependencies"];const i=s.map((t=>t.startsWith("_")?t.slice(1):t)).filter((t=>!n.includes(t))).join("/");if(i!==e){t[i]=t[e];delete t[e]}}}
/**
     * Util shared between different serialization methods.
     * @returns LayersModel config with Keras version information added.
     */updatedConfig(){const t=this.getConfig();const e={};e.className=this.getClassName();e.config=t;e.kerasVersion=`tfjs-layers ${pe}`;e.backend="TensorFlow.js";return e}
/**
     * Returns a JSON string containing the network configuration.
     *
     * To load a network from a JSON save file, use
     * models.modelFromJSON(jsonString);
     * @param extraJsonArgs Unused in tfjs-layers, maintained for PyKeras
     * @param returnString Whether the return value should be stringified
     *    (default: `true`).
     * @returns a JSON string if `returnString` (default), or a JSON object if
     *   `!returnString`.
     */
toJSON(t,e=true){const s=At(this.updatedConfig());return e?JSON.stringify(s):s}
/**
     * Call the model on new inputs.
     *
     * In this case `call` just reapplies all ops in the graph to the new inputs
     * (e.g. build a new computational graph from the provided inputs).
     *
     * @param inputs A tensor or list of tensors.
     * @param mask A mask or list of masks. A mask can be either a tensor or null
     *   (no mask).
     *
     * @return A tensor if there is a single output, or a list of tensors if there
     *   are more than one outputs.
     */call(t,e){return s((()=>{t=dt(t);const s=new FeedDict;for(let e=0;e<this.inputs.length;++e)s.add(this.inputs[e],t[e]);return execute(this.outputs,s,e)}))}
/**
     * Computes an output mask tensor.
     *
     * @param inputs Tensor or list of tensors.
     * @param mask Tensor or list of tensors.
     *
     * @return null or a tensor (or list of tensors, one per output tensor of the
     * layer).
     */computeMask(t,e){return s((()=>{t=dt(t);let s;s=e==null?bt(null,t.length):dt(e);return this.runInternalGraph(t,s)[1]}))}
/**
     * Computes the output shape of the layer.
     *
     * Assumes that the layer will be built to match that input shape provided.
     *
     * @param inputShape A shape (tuple of integers) or a list of shape tuples
     *   (one per output tensor of the layer). Shape tuples can include null for
     *   free dimensions, instead of an integer.
     */computeOutputShape(t){const e=normalizeShapeList(t);if(e.length!==this.inputLayers.length)throw new at(`Invalid inputShape argument ${t}: model has ${this.inputLayers.length} tensor inputs.`);const s={};for(let t=0;t<e.length;t++){const n=this.inputLayers[t];const i=e[t];const a=n.name+"_0_0";s[a]=i}const n=Object.keys(this.nodesByDepth).map((t=>parseInt(t,10))).sort(yt);if(n.length>1)for(const t of n){const e=this.nodesByDepth[t];for(const t of e){const e=t.outboundLayer;if(this.inputLayers.map((t=>t.id)).indexOf(e.id)!==-1)continue;const n=[];for(let e=0;e<t.inboundLayers.length;e++){const i=t.inboundLayers[e];const a=t.nodeIndices[e];const r=t.tensorIndices[e];const o=`${i.name}_${a}_${r}`;const l=s[o];n.push(l)}const i=e.computeOutputShape(ct(n));const a=normalizeShapeList(i);const r=e.inboundNodes.indexOf(t);for(let t=0;t<a.length;t++){const n=`${e.name}_${r}_${t}`;s[n]=a[t]}}}const i=[];const a=[];for(let t=0;t<this.outputLayers.length;t++){const e=this.outputLayers[t];const s=this.outputLayersNodeIndices[t];const n=this.outputLayersTensorIndices[t];const i=`${e.name}_${s}_${n}`;a.push(i)}for(let t=0;t<a.length;t++){const e=a[t];mt(e in s);i.push(s[e])}return ct(i)}
/**
     * Computes output tensors for new inputs.
     *
     * Note:
     *   - Expects `inputs` to be a list (potentially with 1 element).
     *
     * @param inputs List of tensors
     * @param masks List of masks (tensors or null).
     * @return Three lists: outputTensors, outputMasks, outputShapes
     */runInternalGraph(t,e){e==null&&(e=bt(null,t.length));const s={};for(let n=0;n<this.inputs.length;++n){const i=this.inputs[n];const a=t[n];const r=e[n];s[i.id]=[a,r]}const n=Object.keys(this.nodesByDepth).map((t=>parseInt(t,10))).sort(yt);for(const t of n){const e=this.nodesByDepth[t];for(const t of e){const e=t.outboundLayer;const n=t.inputTensors;const i=t.outputTensors;const a=new Array;for(const t of n)t.id in s&&a.push(s[t.id]);if(a.length===n.length){let n={};let r;let o;let l;let u;t.callArgs!=null&&(n=t.callArgs);if(a.length===1){const[t,s]=a[0];n.mask==null&&(n.mask=s);l=dt(e.call(t,n));u=dt(e.computeMask(t,s));r=[t];o=[s]}else{r=a.map((t=>t[0]));o=a.map((t=>t[1]));n.mask==null&&(n.mask=o);l=dt(e.call(r,n));u=dt(e.computeMask(r,o))}if(e.activityRegularizer)throw new rt("LayersModel invocation with concrete Tensor value(s) in the presence of activity regularizer(s) is not supported yet.");for(let t=0;t<i.length;++t){const e=i[t];const n=l[t];const a=u[t];s[e.id]=[n,a]}}}}const i=[];const a=[];const r=[];for(const t of this.outputs){mt(t.id in s,`Could not compute output ${t.name} : ${t.id}`);const[e,n]=s[t.id];r.push(e.shape);i.push(e);a.push(n)}return[i,a,r]}
/**
     * Builds a map of internal node keys to node ordering.
     * Used in serializaion a node orderings may change as unused nodes are
     * dropped. Porting Note:  This helper method was pulled out of getConfig to
     * improve readability.
     * @param layers An array of Layers in the model.
     * @returns Map of Node Keys to index order within the layer.
     */buildNodeConversionMap(t){const e={};let s;for(const t of this.layers){s=t instanceof Container?1:0;for(let n=0;n<t.inboundNodes.length;n++){const i=Container.nodeKey(t,n);if(this.containerNodes.has(i)){e[i]=s;s+=1}}}return e}getLayer(t,e){if(e!=null)return this.findLayer(e);if(t==null)throw new at("Provide either a layer name or layer index");if(typeof t==="number")return this.findLayer(t);for(const e of this.layers)if(e.name===t)return e;throw new at(`No such layer: ${t}`)}findLayer(t){if(this.layers.length<=t)throw new at(`Was asked to retrieve layer at index ${t}, but model only has ${this.layers.length} layer(s).`);return this.layers[t]}calculateLosses(){return s((()=>{const t=[];for(const e of this.layers)for(let s=0;s<e.inboundNodes.length;++s){const n=Container.nodeKey(e,s);this.containerNodes.has(n)&&t.push(...e.calculateLosses())}return t}))}getConfig(){const t={name:this.name};const e=this.buildNodeConversionMap(this.layers);const s=[];for(const t of this.layers){const n=t.getClassName();const i=t.getConfig();const a=[];for(let s=0;s<t.inboundNodes.length;s++){const n=t.inboundNodes[s];const i=Container.nodeKey(t,s);let r={};if(this.containerNodes.has(i)){if(n.callArgs)try{JSON.stringify(n.callArgs);r=n.callArgs}catch(e){console.warn(`Layer ${t.name} was passed non-serializable keyword arguments: ${n.callArgs}. They will not be included in the serialized model (and thus will be missing at deserialization time).`);r={}}if(n.inboundLayers.length>0){const t=[];for(let s=0;s<n.inboundLayers.length;s++){const i=n.inboundLayers[s];const a=n.nodeIndices[s];const o=n.tensorIndices[s];const l=Container.nodeKey(i,a);let u=e[l];u==null&&(u=0);t.push([i.name,u,o,r])}a.push(t)}}}const r={};r.name=t.name;r.className=n;r.config=i;r.inboundNodes=a;s.push(r)}t.layers=s;const n=[];for(let t=0;t<this.inputLayers.length;t++){const s=this.inputLayers[t];const i=this.inputLayersNodeIndices[t];const a=Container.nodeKey(s,i);if(!this.containerNodes.has(a))continue;let r=e[a];r!==null&&r!==void 0||(r=0);const o=this.inputLayersTensorIndices[t];n.push([s.name,r,o])}t.inputLayers=n;const i=[];for(let t=0;t<this.outputLayers.length;t++){const s=this.outputLayers[t];const n=this.outputLayersNodeIndices[t];const a=Container.nodeKey(s,n);if(!this.containerNodes.has(a))continue;let r=e[a];r!==null&&r!==void 0||(r=0);const o=this.outputLayersTensorIndices[t];i.push([s.name,r,o])}t.outputLayers=i;return t}
/**
     * Instantiates a LayersModel from its config (output of `get_config()`).
     * @param cls the class to create
     * @param config LayersModel config dictionary.
     * @param customObjects An optional dictionary of custom objects.
     * @param fastWeightInit Optional flag to use fast weight initialization
     *   during deserialization. This is applicable to cases in which
     *   the initialization will be immediately overwritten by loaded weight
     *   values. Default: `false`.
     * @returns A LayersModel instance.
     * @throws ValueError: In case of improperly formatted config dict.
     */static fromConfig(t,e,s={},n=false){const i={};const a={};function addUnprocessedNode(t,e){t.name in a?a[t.name].push(e):a[t.name]=[e]}function processNode(t,e){const s=[];let n;for(const a of e){const r=a[0];const o=a[1];const l=a[2];n=a[3]==null?{}:a[3];if(!(r in i)){addUnprocessedNode(t,e);return}const u=i[r];if(u.inboundNodes.length<=o){addUnprocessedNode(t,e);return}const h=u.inboundNodes[o];s.push(h.outputTensors[l])}s.length>0&&t.apply(ct(s),n)}
/**
         * Deserialize a layer, then call it on appropriate inputs.
         * @param layerData: layer config dict.
         * @throws ValueError: In case of improperly formatted `layer_data`
         * dict.
         */function processLayer(t){const s=t.name;const a=vt(t,e.customObjects!=null?e.customObjects:{});a.setFastWeightInitDuringBuild(n);i[s]=a;const r=t.inboundNodes;r.forEach((t=>{if(!(t instanceof Array))throw new at(`Corrupted configuration, expected array for nodeData: ${t}`);addUnprocessedNode(a,t)}))}const r=e.name;const o=e.layers;for(const t of o)processLayer(t);while(!wt(a))for(const t of o){const e=i[t.name];if(e.name in a){const t=a[e.name];delete a[e.name];for(const s of t)processNode(e,s)}}const l=[];const u=[];const h=e.inputLayers;for(const t of h){const e=t[0];const s=t[1];const n=t[2];mt(e in i);const a=i[e];const r=a.inboundNodes[s].outputTensors;l.push(r[n])}const c=e.outputLayers;for(const t of c){const e=t[0];const s=t[1];const n=t[2];mt(e in i);const a=i[e];const r=a.inboundNodes[s].outputTensors;u.push(r[n])}return new t({inputs:l,outputs:u,name:r})}get stateful(){if(this._stateful)throw new at("Container instance unexpectedly has _stateful = true. The statefulness of a Container is determined by the Layers it contains. Its _stateful property must remain the default false.");for(const t of this.layers)if(t.stateful)return true;return false}resetStates(){s((()=>{this.layers.forEach((t=>{t.stateful&&t.resetStates()}))}))}}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function standardizeSampleOrClassWeights(t,e,s){const n=e.length;if(t==null||Array.isArray(t)&&t.length===0)return e.map((t=>null));if(n===1)return Array.isArray(t)&&t.length===1?t:typeof t==="object"&&e[0]in t?[t[e[0]]]:[t];if(Array.isArray(t)){if(t.length!==n)throw new Error(`Provided ${s} is an array of ${t.length} element(s), but the model has ${n} outputs. Make sure a set of weights is provided for each model output.`);return t}if(typeof t==="object"&&Object.keys(t).length>0&&typeof t[Object.keys(t)[0]]==="object"){const s=[];e.forEach((e=>{e in t?s.push(t[e]):s.push(null)}));return s}throw new Error(`The model has multiple (${n}) outputs, so ${s} must be either an array with ${n} elements or an object with ${e} keys. Provided ${s} not understood: ${JSON.stringify(t)}`)}
/**
 * Standardize class weighting objects.
 *
 * This function takes a single class-weighting object, an array of them,
 * or a map from output name to class-weighting object. It compares it to the
 * output name(s) of the model, base on which it outputs an array of
 * class-weighting objects of which the length matches the number of outputs.
 *
 * @param classWeight Input class-weighting object(s).
 * @param outputNames All output name(s) of the model.
 * @return An array of class-weighting objects. The length of the array matches
 *   the model's number of outputs.
 */function standardizeClassWeights(t,e){return standardizeSampleOrClassWeights(t,e,"classWeight")}
/**
 * Standardize by-sample and/or by-class weights for training.
 *
 * Note that this function operates on one model output at a time. For a model
 * with multiple outputs, you must call this function multiple times.
 *
 * @param y The target tensor that the by-sample and/or by-class weight is for.
 *     The values of y are assumed to encode the classes, either directly
 *     as an integer index, or as one-hot encoding.
 * @param sampleWeight By-sample weights.
 * @param classWeight By-class weights: an object mapping class indices
 *     (integers) to a weight (float) to apply to the model's loss for the
 *     samples from this class during training. This can be useful to tell the
 *     model to "pay more attention" to samples from an under-represented class.
 * @param sampleWeightMode The mode for the sample weights.
 * @return A Promise of weight tensor, of which the size of the first dimension
 *     matches that of `y`.
 */
async function standardizeWeights(t,e,n,i){if(e!=null||i!=null)throw new Error("Support sampleWeight is not implemented yet");if(n!=null){const e=s((()=>{if(t.shape.length===1)return x(t);if(t.shape.length===2){if(t.shape[1]>1){const e=1;return I(t,e)}if(t.shape[1]===1)return L(t,[t.shape[0]]);throw new Error(`Encountered unexpected last-dimension size (${t.shape[1]}) during handling of class weights. The size is expected to be >= 1.`)}throw new Error(`Unexpected rank of target (y) tensor (${t.rank}) during handling of class weights. The rank is expected to be 1 or 2.`)}));const i=Array.from(await e.data());w(e);const a=[];i.forEach((t=>{if(n[t]==null)throw new Error(`classWeight must contain all classes in the training data. The class ${t} exists in the data but not in classWeight`);a.push(n[t])}));return r(a,"float32")}return null}
/**
 * Apply per-sample weights on the loss values from a number of samples.
 *
 * @param losses Loss tensor of shape `[batchSize]`.
 * @param sampleWeights Per-sample weight tensor of shape `[batchSize]`.
 * @returns Tensor of the same shape as`losses`.
 */function computeWeightedLoss(t,e){return c(t,e)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const de=32;
/**
 * Standardize the output of a dataset iterator for use by
 * LayersModel.fitDataset().
 *
 * @param model: A `tf.LayersModel` object.
 * @param iteratorOut The output of a dataset iterator. It is required to be
 *   an object of the form `{xs: TensorOrArrayOrMap, ys:
 * TensorOrArrayOrMap}`, where `TensorOrArrayOrMap` is a single `tf.Tensor`,
 * a `tf.Tensor[]`, or a flat map from string names to `tf.Tensor`s.
 * @returns A flat array of `tf.Tensor` objects: the input `tf.Tensor`s
 *   followed by the target `tf.Tensor`s.  When `tf.Tensor`s are provided
 *   as a map, the order in the resulting array is taken from the `inputNames`
 *   and `outputNames` of the model.
 */function standardizeDataIteratorOutput(e,s){let n;let i;const a=s;n=a.xs;i=a.ys;t.util.assert(n!=null&&i!=null,(()=>`A Dataset iterator for fitDataset() is expected to generate objects of the form \`{xs: xVal, ys: yVal}\`, where the two values may be \`tf.Tensor\`, an array of Tensors, or a map of string to Tensor.  The provided Dataset instead generates ${s}`));const r=flattenTensorOrArrayOrMap("input",e.inputNames,n);const o=flattenTensorOrArrayOrMap("output",e.outputNames,i);const l=r[0].shape[0];t.util.assert(r.length===e.inputs.length,(()=>`LayersModel has ${e.inputs.length} inputs, but the dataset provides ${r.length} inputs.  (Expected input keys: ${JSON.stringify(e.inputNames)})`));t.util.assert(o.length===e.outputs.length,(()=>`LayersModel has ${e.outputs.length} outputs, but the dataset provides ${o.length} outputs.  (Expected output keys: ${JSON.stringify(e.outputNames)})`));for(let s=0;s<r.length;s++)t.util.assert(r[s].shape[0]===l,(()=>`Batch size mismatch: input ${e.inputNames[s]} has ${r[s].shape[0]}; expected  ${l} based on input ${e.inputNames[0]}.`));for(let s=0;s<o.length;s++)t.util.assert(o[s].shape[0]===l,(()=>`Batch size mismatch: output ${e.outputNames[s]} has ${o[s].shape[0]}; expected  ${l} based on input ${e.inputNames[0]}.`));return{xs:r,ys:o}}function flattenTensorOrArrayOrMap(e,s,n){if(n instanceof t.Tensor)return[n];if(Array.isArray(n)){t.util.assert(n.length===s.length,(()=>`Received an array of ${n.length} Tensors, but expected ${s.length} to match the ${e} keys ${s}.`));return n}{const t=[];for(const i of s){if(n[i]==null)throw new at(`The feature data generated by the dataset lacks the required ${e} key '${i}'.`);t.push(n[i])}return t}}function standardizeTensorValidationData(t){if(t.length===3)throw new rt("Validation with sample weights is not implemented yet.");return{xs:t[0],ys:t[1]}}async function fitDataset(e,s,n){const i=n.batchesPerEpoch!=null;t.util.assert(e.optimizer!=null,(()=>"You must compile a model before training/testing. Use LayersModel.compile(modelCompileConfig)."));t.util.assert(n!=null,(()=>"For fitDataset(), the 2nd argument (config) is required, but it is not provided in this call."));t.util.assert(n.epochs!=null&&n.epochs>0&&Number.isInteger(n.epochs),(()=>`For fitDataset(), config.epochs is expected to be a positive integer, but got ${n.epochs}`));t.util.assert(!i||n.batchesPerEpoch>0&&Number.isInteger(n.batchesPerEpoch),(()=>`For fitDataset(), config.batchesPerEpoch is expected to be a positive integer if specified, but got ${n.batchesPerEpoch}`));t.util.assert(n.validationSplit==null,(()=>"`validationSplit` is not supported by `fitDataset()`. Use validationData instead."));if(e.isTraining)throw new Error("Cannot start training because another fit() call is ongoing.");e.isTraining=true;try{const a=n.validationData!=null;let r;let o;if(a)if(isDatasetObject(n.validationData))t.util.assert(n.validationBatches==null||n.validationBatches>0&&Number.isInteger(n.validationBatches),(()=>`For fitDataset() with dataset-based validation, config.validationBatches is expected not to be provided, or to be a positive integer, but got ${n.validationBatches}`));else{const t=standardizeTensorValidationData(n.validationData);r=t.xs;o=t.ys}const l=e.makeTrainFunction();const u=e.getDedupedMetricsNames();let h;h=a?u.slice().concat(u.map((t=>"val_"+t))):u.slice();const c=standardizeCallbacks(n.callbacks,n.yieldEvery);const p=n.verbose==null?1:n.verbose;const{callbackList:d,history:g}=configureCallbacks(c,p,n.epochs,null,null,getStepsPerEpoch(s,n),null,a,h);d.setModel(e);e.history=g;await d.onTrainBegin();e.stopTraining_=false;let m=n.initialEpoch==null?0:n.initialEpoch;let f=await s.iterator();while(m<n.epochs){const h={};await d.onEpochBegin(m);let c=0;let p=0;i||(f=await s.iterator());while(!i||c<n.batchesPerEpoch){const s=await f.next();if(i&&s.done){console.warn(`You provided \`batchesPerEpoch\` as ${n.batchesPerEpoch}, but your dataset iterator ran out of data after ${c} batches; interrupting training. Make sure that your dataset can generate at least \`batchesPerEpoch * epochs\` batches (in this case, `+n.batchesPerEpoch*n.epochs+" batches). You may need to use the repeat() function when building your dataset.");break}if(s.value!=null){const{xs:i,ys:a}=standardizeDataIteratorOutput(e,s.value);const r={};r.batch=p;r.size=i[0].shape[0];await d.onBatchBegin(p,r);const o=[];if(n.classWeight!=null){const t=standardizeClassWeights(n.classWeight,e.outputNames);for(let e=0;e<t.length;++e)o.push(await standardizeWeights(a[e],null,t[e]))}const h=i.concat(a).concat(o);const g=l(h);t.dispose(h);for(let e=0;e<u.length;++e){const s=u[e];const n=g[e];r[s]=n;t.keep(n)}await d.onBatchEnd(p,r);disposeTensorsInLogs(r);p++;c++}if(i?c>=n.batchesPerEpoch:s.done){if(a){let t;t=isDatasetObject(n.validationData)?dt(await e.evaluateDataset(n.validationData,{batches:n.validationBatches})):dt(e.evaluate(r,o,{batchSize:n.validationBatchSize==null?de:n.validationBatchSize,verbose:0}));for(let s=0;s<e.metricsNames.length;++s)h[`val_${e.metricsNames[s]}`]=t[s]}break}if(e.stopTraining_)break}await d.onEpochEnd(m,h);m++;if(e.stopTraining_)break}await d.onTrainEnd();await e.history.syncData();return e.history}finally{e.isTraining=false}}function getStepsPerEpoch(t,e){let s=null;e.batchesPerEpoch!=null?s=e.batchesPerEpoch:Number.isFinite(t.size)&&(s=t.size);return s}function isDatasetObject(t){return typeof t.iterator==="function"}function isLazyIteratorObject(t){return typeof t.next==="function"}async function evaluateDataset(e,s,n){n=n||{};const i=n.batches!=null;const a=e.testFunction;let r=[];if(n.verbose>0)throw new rt("Verbose mode is not implemented yet.");t.util.assert(!i||n.batches>0&&Number.isInteger(n.batches),(()=>`Test loop expects \`batches\` to be a positive integer, but received ${JSON.stringify(n.batches)}`));const l=isLazyIteratorObject(s)?s:await s.iterator();let u=0;let h=0;while(!i||h<n.batches){const s=await l.next();r=t.tidy((()=>{if(s.value){const{xs:n,ys:i}=standardizeDataIteratorOutput(e,s.value);const l=n.concat(i);const c=t.tidy((()=>a(l)));t.dispose(l);if(h===0)for(let t=0;t<c.length;++t)r.push(o(0));const p=l[0].shape[0];for(let e=0;e<c.length;++e){const s=c[e];const n=r[e];r[e]=t.tidy((()=>t.add(r[e],t.mul(p,s))));h>0&&t.dispose(n)}t.dispose(c);u+=p;++h}return r}));if(s.done){i&&console.warn(`Your dataset iterator ran out of data during evaluateDataset(). Interrupting evalution. Make sure that your dataset can generate at least \`batches\` batches (in this case, ${n.batches} batches). You may need to use the repeat() function when building your dataset.`);break}}for(let e=0;e<r.length;++e){const s=r[e];r[e]=t.div(r[e],u);t.dispose(s)}return ct(r)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function checkBatchSize(e){t.util.assert(e>0&&Number.isInteger(e),(()=>`batchSize is required to be a positive integer, but got ${e}`))}
/**
 * Slice a Tensor or an Array of Tensors, by start and stop indices.
 *
 * Porting Note: The `_slice_arrays` function in PyKeras is covered by this
 *   function and `sliceArraysByIndices()` together.
 *
 * @param arrays: the input.
 * @param start: the starting index (inclusive).
 * @param stop: the stopping index (exclusive).
 * @returns The result of the slicing. If `arrays` is an `Array` of
 *   `tf.Tensor`s, the slicing will be applied to all elements of the `Array`
 *   in the same way.
 */function sliceArrays(t,e,s){return t==null?[null]:Array.isArray(t)?t.map((t=>sliceAlongFirstAxis(t,e,s-e))):sliceAlongFirstAxis(t,e,s-e)}
/**
 * Slice a Tensor or an Array of Tensors, by random-order indices.
 *
 * Porting Note: The `_slice_arrays` function in PyKeras is covered by this
 *   function and `sliceArrays()` together.
 *
 * @param arrays The input `tf.Tensor` or `Array` of `tf.Tensor`s to slice.
 *   If an `Array` of `tf.Tensor`s, all `tf.Tensor`s will be sliced in the
 *   same fashion.
 * @param indices The indices to use for slicing along the first (batch)
 *   dimension.
 * @returns Result(s) of the slicing.
 */function sliceArraysByIndices(e,s){return t.tidy((()=>e==null?null:Array.isArray(e)?e.map((t=>sliceArraysByIndices(t,s))):gather(e,s.dtype==="int32"?s:t.cast(s,"int32"))))}
/**
 * Returns a list of batch indices (tuples of indices).
 * @param size: Integer, total size of the data to slice into batches.
 * @param batchSize: Integer, batch size.
 * @returns An Array of [batchStart, batchEnd] tuples. batchStart is
 *   inclusive; batchEnd is exclusive. I.e., each batch consists of indices x
 *   that satisfy batchStart <= x < batchEnd.
 */function makeBatches(t,e){const s=[];let n=0;let i=null;while(n<t){i=n+e;i>=t&&(i=t);s.push([n,i]);n=i}return s}function ensureTensorsRank2OrHigher(t){const e=[];t instanceof D&&(t=[t]);for(let s=0;s<t.length;++s){const n=t[s];if(n.rank===1)e.push(expandDims(n,1));else{if(n.rank===0)throw new Error("Expected tensor to be at least 1D, but received a 0D tensor (scalar).");e.push(n)}}return e}
/**
 * Compare a set of tensors with a reference (old) set, discard the ones
 * in the new set that are not present in the reference set.
 *
 * This method is used for memory clenaup during calls such as
 * LayersModel.fit().
 *
 * @param tensors New set which may contain Tensors not present in
 *   `refTensors`.
 * @param refTensors Reference Tensor set.
 */function disposeNewTensors(t,e){if(t==null)return;const s=[];if(e instanceof D)s.push(e.id);else if(Array.isArray(e))e.forEach((t=>s.push(t.id)));else if(e!=null)for(const t in e){const n=e[t];s.push(n.id)}const n=[];if(t instanceof D)s.indexOf(t.id)===-1&&n.push(t);else if(Array.isArray(t))t.forEach((t=>{s.indexOf(t.id)===-1&&n.push(t)}));else if(t!=null)for(const e in t){const i=t[e];s.indexOf(i.id)===-1&&n.push(i)}n.forEach((t=>{t.isDisposed||t.dispose()}))}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function isDataTensor(t){return t instanceof D}function isDataArray(t){return Array.isArray(t)}function isDataDict(t){return!isDataTensor(t)&&!isDataArray(t)}
/**
 * Normalizes inputs and targets provided by users.
 * @param data User-provided input data (polymorphic).
 * @param names An Array of expected Tensor names.
 * @param shapes Optional Array of expected Tensor shapes.
 * @param checkBatchAxis Whether to check that the batch axis of the arrays
 *   match  the expected value found in `shapes`.
 * @param exceptionPrefix String prefix used for exception formatting.
 * @returns List of standardized input Tensors (one Tensor per model input).
 * @throws ValueError: in case of improperly formatted user data.
 */function standardizeInputData(t,e,s,n=true,i=""){if(e==null||e.length===0){if(t!=null){let e=false;if(isDataArray(t)&&t.length>0)e=true;else if(isDataDict(t)){for(const s in t)if(t.hasOwnProperty(s)){e=true;break}}else e=true;if(e)throw new at(`Error when checking model ${i} expected no data, but got ${t}`)}return[]}if(t==null)return e.map((t=>null));let a;if(isDataDict(t)){t;a=[];for(const s of e){if(t[s]==null)throw new at(`No data provided for "${s}". Need data for each key in: ${e}`);a.push(t[s])}}else if(isDataArray(t)){t;if(t.length!==e.length)throw new at(`Error when checking model ${i}: the Array of Tensors that you are passing to your model is not the size the model expected. Expected to see ${e.length} Tensor(s), but instead got the following list of Tensor(s): ${t}`);a=t}else{t;if(e.length>1)throw new at(`The model ${i} expects ${e.length} Tensor(s), but only received one Tensor. Found: Tensor with shape ${t.shape}`);a=[t]}a=ensureTensorsRank2OrHigher(a);if(s!=null)for(let t=0;t<e.length;++t){if(s[t]==null)continue;const r=a[t];if(r.shape.length!==s[t].length)throw new at(`Error when checking ${i}: expected ${e[t]} to have ${s[t].length} dimension(s). but got array with shape ${r.shape}`);for(let e=0;e<s[t].length;++e){if(e===0&&!n)continue;const a=r.shape[e];const o=s[t][e];if(o!=null&&o>=0&&a!==o)throw new at(`${i} expected a batch of elements where each example has shape [${s[t].slice(1,s[t].length)}] (i.e.,tensor shape [*,${s[t].slice(1,s[t].length)}]) but the ${i} received an input with ${r.shape[0]} examples, each with shape [${r.shape.slice(1,r.shape.length)}] (tensor shape [${r.shape}])`)}}return a}
/**
 * User input validation for Tensors.
 * @param inputs `Array` of `tf.Tensor`s for inputs.
 * @param targets `Array` of `tf.Tensor`s for targets.
 * @param weights Optional `Array` of `tf.Tensor`s for sample weights.
 * @throws ValueError: in case of incorrectly formatted data.
 */function checkArrayLengths(t,e,s){const n=ft(t.map((t=>t.shape[0])));n.sort();const i=ft(e.map((t=>t.shape[0])));i.sort();if(n.length>1)throw new at(`All input Tensors (x) should have the same number of samples. Got array shapes: ${JSON.stringify(t.map((t=>t.shape)))}`);if(i.length>1)throw new at(`All target Tensors (y) should have the same number of samples. Got array shapes: ${JSON.stringify(e.map((t=>t.shape)))}`);if(n.length>0&&i.length>0&&!m.arraysEqual(n,i))throw new at(`Input Tensors should have the same number of samples as target Tensors. Found ${n[0]} input sample(s) and ${i[0]} target sample(s).`)}
/**
 * Validation on the compatibility of targes and loss functions.
 *
 * This helps prevent users from using loss functions incorrectly.
 *
 * @param targets `Array` of `tf.Tensor`s of targets.
 * @param lossFns `Array` of loss functions.
 * @param outputShapes `Array` of shapes of model outputs.
 */function checkLossAndTargetCompatibility(t,e,s){const n=[meanSquaredError$1,binaryCrossentropy$2,categoricalCrossentropy$2];for(let i=0;i<t.length;++i){const a=t[i];const r=e[i];const o=s[i];if(r!=null){if(r===categoricalCrossentropy$2&&a.shape[a.shape.length-1]===1)throw new at(`You are passing a target array of shape ${a.shape} while using a loss 'categorical_crossentropy'. 'categorical_crossentropy'expects targets to be binary matrices (1s and 0s) of shape [samples, classes].`);if(n.indexOf(r)!==-1){const t=a.shape.slice(1);const e=o.slice(1);for(let s=0;s<t.length;++s){const n=t[s];const i=e[s];if(i!=null&&n!==i)throw new at(`A target Tensor with shape ${a.shape} was passed for an output of shape ${o}, while using a loss function that expects targets to have the same shape as the output.`)}}}}}
/**
 * Check inputs provided by the user.
 *
 * Porting Note: This corresponds to _standardize_input_data() in Python
 *   Keras. Because of the strong typing in TF.js, we do not need to convert
 *   the data. Specifically:
 *   1) in PyKeras, `data` can be `DataFrame` instances from pandas, for
 *      example. We don't need to worry about that here because there is no
 *      widely popular javascript/typesdcript equivalent of pandas (so far).
 *      If one becomes available in the future, we can add support.
 *   2) in PyKeras, inputs can be Python dict. But here we are stipulating
 * that the data is either a single `tf.Tensor` or an Array of `tf.Tensor`s. We
 * may add support for `Object` data inputs in the future when the need
 * arises.
 *
 * Instead, we perform basic checks for number of parameters and shapes.
 *
 * @param data: The input data.
 * @param names: Name for the inputs, from the model.
 * @param shapes: Expected shapes for the input data, from the model.
 * @param checkBatchAxis: Whether the size along the batch axis (i.e., the
 *   first dimension) will be checked for matching.
 * @param exceptionPrefix: Execption prefix message, used in generating error
 *   messages.
 * @throws ValueError: on incorrect number of inputs or mismatches in shapes.
 */function checkInputData(t,e,s,n=true,i=""){let a;if(Array.isArray(t)){if(t.length!==e.length)throw new at(`Error when checking model ${i}: the Array of Tensors that you are passing to your model is not the size the the model expected. Expected to see ${e.length} Tensor(s), but instead got ${t.length} Tensors(s).`);a=t}else{if(e.length>1)throw new at(`The model expects ${e.length} ${i} Tensors, but only received one Tensor. Found: array with shape ${JSON.stringify(t.shape)}.`);a=[t]}if(s!=null)for(let t=0;t<e.length;++t){if(s[t]==null)continue;const r=a[t];if(r.shape.length!==s[t].length)throw new at(`Error when checking ${i}: expected ${e[t]} to have ${s[t].length} dimension(s), but got array with shape ${JSON.stringify(r.shape)}`);for(let a=0;a<s[t].length;++a){if(a===0&&!n)continue;const o=r.shape[a];const l=s[t][a];if(l!=null&&l!==o)throw new at(`Error when checking ${i}: expected ${e[t]} to have shape ${JSON.stringify(s[t])} but got array with shape ${JSON.stringify(r.shape)}.`)}}}
/**
 * Maps metric functions to model outputs.
 * @param metrics An shortcut strings name, metric function, `Array` or dict
 *   (`Object`) of metric functions.
 * @param outputNames An `Array` of the names of model outputs.
 * @returns An `Array` (one entry per model output) of `Array` of metric
 *   functions. For instance, if the model has 2 outputs, and for the first
 *   output we want to compute `binaryAccuracy` and `binaryCrossentropy`,
 *   and just `binaryAccuracy` for the second output, the `Array` would look
 *   like:
 *     `[[binaryAccuracy, binaryCrossentropy],  [binaryAccuracy]]`
 * @throws TypeError: incompatible metrics format.
 */function collectMetrics(t,e){if(t==null||Array.isArray(t)&&t.length===0)return e.map((t=>[]));let s;if(typeof t==="string"||typeof t==="function")s=[t];else{if(!Array.isArray(t)&&typeof t!=="object")throw new TypeError(`Type of metrics argument not understood. Expected an string,function, Array, or Object, found: ${t}`);s=t}if(Array.isArray(s))return e.map((t=>s));{const t=[];for(const n of e){let e=s.hasOwnProperty(n)?s[n]:[];Array.isArray(e)||(e=[e]);t.push(e)}return t}}const ge="layers-model";class LayersModel extends Container{constructor(t){super(t);this.isTraining=false}
/**
     * Print a text summary of the model's layers.
     *
     * The summary includes
     * - Name and type of all layers that comprise the model.
     * - Output shape(s) of the layers
     * - Number of weight parameters of each layer
     * - If the model has non-sequential-like topology, the inputs each layer
     *   receives
     * - The total number of trainable and non-trainable parameters of the model.
     *
     * ```js
     * const input1 = tf.input({shape: [10]});
     * const input2 = tf.input({shape: [20]});
     * const dense1 = tf.layers.dense({units: 4}).apply(input1);
     * const dense2 = tf.layers.dense({units: 8}).apply(input2);
     * const concat = tf.layers.concatenate().apply([dense1, dense2]);
     * const output =
     *     tf.layers.dense({units: 3, activation: 'softmax'}).apply(concat);
     *
     * const model = tf.model({inputs: [input1, input2], outputs: output});
     * model.summary();
     * ```
     *
     * @param lineLength Custom line length, in number of characters.
     * @param positions Custom widths of each of the columns, as either
     *   fractions of `lineLength` (e.g., `[0.5, 0.75, 1]`) or absolute number
     *   of characters (e.g., `[30, 50, 65]`). Each number corresponds to
     *   right-most (i.e., ending) position of a column.
     * @param printFn Custom print function. Can be used to replace the default
     *   `console.log`. For example, you can use `x => {}` to mute the printed
     *   messages in the console.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */summary(t,e,s=console.log){if(!this.built)throw new at("This model has never been called, thus its weights have not been created yet. So no summary can be displayed. Build the model first (e.g., by calling it on some test data).");printSummary(this,t,e,s)}
/**
     * Configures and prepares the model for training and evaluation.  Compiling
     * outfits the model with an optimizer, loss, and/or metrics.  Calling `fit`
     * or `evaluate` on an un-compiled model will throw an error.
     *
     * @param args a `ModelCompileArgs` specifying the loss, optimizer, and
     * metrics to be used for fitting and evaluating this model.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */compile(t){t.loss==null&&(t.loss=[]);this.loss=t.loss;if(typeof t.optimizer==="string"){this.optimizer_=getOptimizer(t.optimizer);this.isOptimizerOwned=true}else{if(!(t.optimizer instanceof T))throw new at("User-defined optimizer must be an instance of tf.Optimizer.");this.optimizer_=t.optimizer;this.isOptimizerOwned=false}let e=[];if(Array.isArray(t.loss)||typeof t.loss==="string"||typeof t.loss==="function")if(Array.isArray(t.loss)){if(t.loss.length!==this.outputs.length)throw new at(`When passing an Array as loss, it should have one entry per model output. The model has ${this.outputs.length} output(s), but you passed loss=${t.loss}.`);const s=t.loss;e=s.map((t=>get$1(t)))}else{const s=get$1(t.loss);this.outputs.forEach((t=>{e.push(s)}))}else{t.loss=t.loss;for(const e in t.loss)if(this.outputNames.indexOf(e)===-1)throw new at(`Unknown entry in loss dictionary: "${e}". Only expected the following keys: ${this.outputNames}`);for(const s of this.outputNames){t.loss[s]==null&&console.warn(`Output "${s}" is missing from loss dictionary. We assume this was done on purpose, and we will not be expecting data to be passed to ${s} during training`);e.push(get$1(t.loss[s]))}}this.lossFunctions=e;this.feedOutputNames=[];this.feedOutputShapes=[];this.feedLossFns=[];for(let t=0;t<this.outputs.length;++t){const e=this.internalOutputShapes[t];const s=this.outputNames[t];this.feedOutputNames.push(s);this.feedOutputShapes.push(e);this.feedLossFns.push(this.lossFunctions[t])}const s=[];this.metrics=t.metrics;this.metricsNames=["loss"];this.metricsTensors=[];nameScope("loss",(()=>{for(let t=0;t<this.outputs.length;++t){if(s.indexOf(t)!==-1)continue;const e=this.lossFunctions[t];if(this.outputs.length>1){this.metricsTensors.push([e,t]);this.metricsNames.push(this.outputNames[t]+"_loss")}}}));const n=collectMetrics(t.metrics,this.outputNames);const appendMetric=(t,e,s)=>{this.outputNames.length>1&&(e=this.outputNames[t]+"_"+e);this.metricsNames.push(e);this.metricsTensors.push([s,t])};nameScope("metric",(()=>{for(let t=0;t<this.outputs.length;++t){if(s.indexOf(t)!==-1)continue;const e=n[t];const handleMetrics=e=>{const s="";let n;let i;let a;for(const r of e){if(typeof r==="string"&&["accuracy","acc","crossentropy","ce"].indexOf(r)!==-1){const e=this.internalOutputShapes[t];e[e.length-1]===1||this.lossFunctions[t]===binaryCrossentropy$2?["accuracy","acc"].indexOf(r)!==-1?i=binaryAccuracy$1:["crossentropy","ce"].indexOf(r)!==-1&&(i=binaryCrossentropy$1):this.lossFunctions[t]===sparseCategoricalCrossentropy$1?["accuracy","acc"].indexOf(r)!==-1?i=sparseCategoricalAccuracy$1:["crossentropy","ce"].indexOf(r)!==-1&&(i=ue):["accuracy","acc"].indexOf(r)!==-1?i=categoricalAccuracy$1:["crossentropy","ce"].indexOf(r)!==-1&&(i=oe);let o;["accuracy","acc"].indexOf(r)!==-1?o="acc":["crossentropy","ce"].indexOf(r)!==-1&&(o="ce");a=i;n=s+o}else{const t=get(r);a=t;n=s+getLossOrMetricName(r)}let e;nameScope(n,(()=>{e=a}));appendMetric(t,n,e)}};handleMetrics(e)}}));this.collectedTrainableWeights=this.trainableWeights}checkTrainableWeightsConsistency(){this.collectedTrainableWeights!=null&&this.trainableWeights.length!==this.collectedTrainableWeights.length&&console.warn("Discrepancy between trainableweights and collected trainable weights. Did you set `model.trainable` without calling `model.compile()` afterwards?")}
/**
     * Returns the loss value & metrics values for the model in test mode.
     *
     * Loss and metrics are specified during `compile()`, which needs to happen
     * before calls to `evaluate()`.
     *
     * Computation is done in batches.
     *
     * ```js
     * const model = tf.sequential({
     *   layers: [tf.layers.dense({units: 1, inputShape: [10]})]
     * });
     * model.compile({optimizer: 'sgd', loss: 'meanSquaredError'});
     * const result = model.evaluate(
     *     tf.ones([8, 10]), tf.ones([8, 1]), {batchSize: 4});
     * result.print();
     * ```
     *
     * @param x `tf.Tensor` of test data, or an `Array` of `tf.Tensor`s if the
     * model has multiple inputs.
     * @param y `tf.Tensor` of target data, or an `Array` of `tf.Tensor`s if the
     * model has multiple outputs.
     * @param args A `ModelEvaluateArgs`, containing optional fields.
     *
     * @return `Scalar` test loss (if the model has a single output and no
     *   metrics) or `Array` of `Scalar`s (if the model has multiple outputs
     *   and/or metrics). The attribute `model.metricsNames`
     *   will give you the display labels for the scalar outputs.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */evaluate(t,e,s={}){const n=s.batchSize==null?32:s.batchSize;checkBatchSize(n);const i=true;const a=this.standardizeUserDataXY(t,e,i,n);try{const t=a[0].concat(a[1]);this.makeTestFunction();const e=this.testFunction;const i=this.testLoop(e,t,n,s.verbose,s.steps);return ct(i)}finally{disposeNewTensors(a[0],t);disposeNewTensors(a[1],e)}}
/**
     * Evaluate model using a dataset object.
     *
     * Note: Unlike `evaluate()`, this method is asynchronous (`async`).
     *
     * @param dataset A dataset object. Its `iterator()` method is expected
     *   to generate a dataset iterator object, the `next()` method of which
     *   is expected to produce data batches for evaluation. The return value
     *   of the `next()` call ought to contain a boolean `done` field and a
     *   `value` field. The `value` field is expected to be an array of two
     *   `tf.Tensor`s or an array of two nested `tf.Tensor` structures. The former
     *   case is for models with exactly one input and one output (e.g.
     *   a sequential model). The latter case is for models with multiple
     *   inputs and/or multiple outputs. Of the two items in the array, the
     *   first is the input feature(s) and the second is the output target(s).
     * @param args A configuration object for the dataset-based evaluation.
     * @returns Loss and metric values as an Array of `Scalar` objects.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */
async evaluateDataset(t,e){this.makeTestFunction();return evaluateDataset(this,t,e)}
/**
     * Get number of samples provided for training, evaluation or prediction.
     *
     * @param ins Input `tf.Tensor`.
     * @param batchSize Integer batch size, optional.
     * @param steps Total number of steps (batches of samples) before
     * declaring loop finished. Optional.
     * @param stepsName The public API's parameter name for `steps`.
     * @returns Number of samples provided.
     */checkNumSamples(t,e,s,n="steps"){let i;if(s!=null){i=null;if(e!=null)throw new at(`If ${n} is set, batchSize must be null or undefined.Got batchSize = ${e}`)}else{if(t==null)throw new at(`Either the input data should have a defined shape, or ${n} shoud be specified.`);i=Array.isArray(t)?t[0].shape[0]:t.shape[0]}return i}
/**
     * Execute internal tensors of the model with input data feed.
     * @param inputs Input data feed. Must match the inputs of the model.
     * @param outputs Names of the output tensors to be fetched. Must match
     *   names of the SymbolicTensors that belong to the graph.
     * @returns Fetched values for `outputs`.
     */execute(t,e){if(Array.isArray(e)&&e.length===0)throw new at("`outputs` is an empty Array, which is not allowed.");const s=Array.isArray(e);const n=s?e:[e];const i=this.retrieveSymbolicTensors(n);const a=new FeedDict;t instanceof D&&(t=[t]);if(Array.isArray(t)){if(t.length!==this.inputs.length)throw new at(`The number of inputs provided (${t.length}) does not match the number of inputs of this model (${this.inputs.length}).`);for(let e=0;e<this.inputs.length;++e)a.add(this.inputs[e],t[e])}else for(const e of this.inputs){const s=t[e.name];if(s==null)throw new at(`No value is provided for the model's input ${e.name}`);a.add(e,s)}const r=execute(i,a);return s?r:r[0]}retrieveSymbolicTensors(t){const e=bt(null,t.length);let s=t.length;for(const n of this.layers){const i=Array.isArray(n.output)?n.output:[n.output];const a=i.map((t=>t.name));for(let n=0;n<t.length;++n){const r=a.indexOf(t[n]);if(r!==-1){e[n]=i[r];s--}if(s===0)break}if(s===0)break}if(s>0){const s=[];e.forEach(((e,n)=>{e==null&&s.push(t[n])}));throw new at(`Cannot find SymbolicTensors for output name(s): ${JSON.stringify(s)}`)}return e}
/**
     * Helper method to loop over some data in batches.
     *
     * Porting Note: Not using the functional approach in the Python equivalent
     *   due to the imperative backend.
     * Porting Note: Does not support step mode currently.
     *
     * @param ins: input data
     * @param batchSize: integer batch size.
     * @param verbose: verbosity model
     * @returns: Predictions as `tf.Tensor` (if a single output) or an `Array` of
     *   `tf.Tensor` (if multipe outputs).
     */predictLoop(e,s=32,n=false){return t.tidy((()=>{const i=this.checkNumSamples(e);if(n)throw new rt("Verbose predictLoop() is not implemented yet.");const a=makeBatches(i,s);const r=this.outputs.map((t=>[]));for(let s=0;s<a.length;++s){const n=t.tidy((()=>{const t=a[s][0];const n=a[s][1];const i=sliceArrays(e,t,n);const r=[];if(Array.isArray(i))for(let t=0;t<i.length;++t)r.push({key:this.inputs[t],value:i[t]});else r.push({key:this.inputs[0],value:i});const o=new FeedDict(r);return execute(this.outputs,o)}));n.forEach(((t,e)=>r[e].push(t)))}return ct(r.map((e=>t.concat(e,0))))}))}
/**
     * Generates output predictions for the input samples.
     *
     * Computation is done in batches.
     *
     * Note: the "step" mode of predict() is currently not supported.
     *   This is because the TensorFlow.js core backend is imperative only.
     *
     * ```js
     * const model = tf.sequential({
     *   layers: [tf.layers.dense({units: 1, inputShape: [10]})]
     * });
     * model.predict(tf.ones([8, 10]), {batchSize: 4}).print();
     * ```
     *
     * @param x The input data, as a Tensor, or an `Array` of `tf.Tensor`s if
     *   the model has multiple inputs.
     * @param args A `ModelPredictArgs` object containing optional fields.
     *
     * @return Prediction results as a `tf.Tensor`(s).
     *
     * @exception ValueError In case of mismatch between the provided input data
     *   and the model's expectations, or in case a stateful model receives a
     *   number of samples that is not a multiple of the batch size.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */predict(t,e={}){const s=ensureTensorsRank2OrHigher(t);checkInputData(s,this.inputNames,this.feedInputShapes,false);try{const t=e.batchSize==null?32:e.batchSize;checkBatchSize(t);return this.predictLoop(s,t)}finally{disposeNewTensors(s,t)}}
/**
     * Returns predictions for a single batch of samples.
     *
     * ```js
     * const model = tf.sequential({
     *   layers: [tf.layers.dense({units: 1, inputShape: [10]})]
     * });
     * model.predictOnBatch(tf.ones([8, 10])).print();
     * ```
     * @param x: Input samples, as a Tensor (for models with exactly one
     *   input) or an array of Tensors (for models with more than one input).
     * @return Tensor(s) of predictions
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */predictOnBatch(t){checkInputData(t,this.inputNames,this.feedInputShapes,true);const e=(Array.isArray(t)?t[0]:t).shape[0];return this.predictLoop(t,e)}standardizeUserDataXY(t,e,s=true,n){if(this.optimizer_==null)throw new ht("You must compile a model before training/testing. Use LayersModel.compile(modelCompileArgs).");const i=[];for(let t=0;t<this.feedOutputShapes.length;++t){const e=this.feedOutputShapes[t];const s=this.feedLossFns[t];s===sparseCategoricalCrossentropy$1?i.push(e.slice(0,e.length-1).concat([1])):i.push(e)}t=standardizeInputData(t,this.feedInputNames,this.feedInputShapes,false,"input");e=standardizeInputData(e,this.feedOutputNames,i,false,"target");checkArrayLengths(t,e,null);checkLossAndTargetCompatibility(e,this.feedLossFns,this.feedOutputShapes);if(this.stateful&&n!=null&&n>0&&t[0].shape[0]%n!==0)throw new at(`In a stateful network, you should only pass inputs with a number of samples that is divisible by the batch size ${n}. Found: ${t[0].shape[0]} sample(s).`);return[t,e]}async standardizeUserData(t,e,s,n,i=true,a){const[r,o]=this.standardizeUserDataXY(t,e,i,a);if(s!=null)throw new Error("sample weight is not supported yet.");let l=null;if(n!=null){const t=standardizeClassWeights(n,this.outputNames);l=[];for(let e=0;e<t.length;++e)l.push(await standardizeWeights(o[e],null,t[e]))}return[r,o,l]}
/**
     * Loop over some test data in batches.
     * @param f A Function returning a list of tensors.
     * @param ins Array of tensors to be fed to `f`.
     * @param batchSize Integer batch size or `null` / `undefined`.
     * @param verbose verbosity mode.
     * @param steps Total number of steps (batches of samples) before
     * declaring test finished. Ignored with the default value of `null` /
     * `undefined`.
     * @returns Array of Scalars.
     */testLoop(e,s,n,i=0,a){return t.tidy((()=>{const l=this.checkNumSamples(s,n,a,"steps");const u=[];if(i>0)throw new rt("Verbose mode is not implemented yet.");if(a!=null)throw new rt("steps mode in testLoop() is not implemented yet");{const i=makeBatches(l,n);const a=r(range(0,l));for(let n=0;n<i.length;++n){const r=i[n][0];const l=i[n][1];const h=sliceAlongFirstAxis(a,r,l-r);const c=sliceArraysByIndices(s,h);const p=e(c);if(n===0)for(let t=0;t<p.length;++t)u.push(o(0));for(let e=0;e<p.length;++e){const s=p[e];u[e]=t.add(u[e],t.mul(l-r,s))}}for(let e=0;e<u.length;++e)u[e]=t.div(u[e],l)}return u}))}getDedupedMetricsNames(){const t=this.metricsNames;const e=[];for(let s=0;s<t.length;++s){const n=t[s];let i=n;if(St(t,n)>1){const e=St(t.slice(0,s),n);i+=`_${e}`}e.push(i)}return e}makeTrainFunction(){return e=>{const s=[];const n=e.slice(0,this.inputs.length);const i=e.slice(this.inputs.length,this.inputs.length+this.outputs.length);const a=e.slice(this.inputs.length+this.outputs.length,this.inputs.length+this.outputs.length*2);const r=[];const totalLossFunction=()=>{const e=[];for(let t=0;t<this.inputs.length;++t)e.push({key:this.inputs[t],value:n[t]});const o=new FeedDict(e);const l=execute(this.outputs,o,{training:true});let u;for(let e=0;e<this.lossFunctions.length;++e){const n=this.lossFunctions[e];let r=n(i[e],l[e]);a[e]!=null&&(r=computeWeightedLoss(r,a[e]));const o=t.mean(r);s.push(o);u=e===0?r:t.add(u,r)}for(let e=0;e<this.metricsTensors.length;++e){let n;if(this.outputs.length>1&&e<this.outputs.length)n=s[e];else{const s=this.metricsTensors[e][0];const a=this.metricsTensors[e][1];n=t.mean(s(i[a],l[a]))}t.keep(n);r.push(n)}u=t.mean(u);this.calculateLosses().forEach((e=>{u=t.add(u,e)}));return u};const o=this.collectedTrainableWeights.map((t=>t.read()));const l=true;const u=this.optimizer_.minimize(totalLossFunction,l,o);return[u].concat(r)}}makeTestFunction(){this.testFunction=e=>t.tidy((()=>{const s=[];let n;const i=e.slice(0,this.inputs.length);const a=e.slice(this.inputs.length,this.inputs.length+this.outputs.length);const r=[];for(let t=0;t<this.inputs.length;++t)r.push({key:this.inputs[t],value:i[t]});const o=new FeedDict(r);const l=execute(this.outputs,o);for(let e=0;e<this.lossFunctions.length;++e){const i=this.lossFunctions[e];const r=t.mean(i(a[e],l[e]));n=e===0?r:t.add(n,r);s.push(n)}for(let e=0;e<this.metricsTensors.length;++e){const n=this.metricsTensors[e][0];const i=this.metricsTensors[e][1];const r=t.mean(n(a[i],l[i]));s.push(r)}return s}))}
/**
     * Trains the model for a fixed number of epochs (iterations on a
     * dataset).
     *
     * ```js
     * const model = tf.sequential({
     *     layers: [tf.layers.dense({units: 1, inputShape: [10]})]
     * });
     * model.compile({optimizer: 'sgd', loss: 'meanSquaredError'});
     * for (let i = 1; i < 5 ; ++i) {
     *   const h = await model.fit(tf.ones([8, 10]), tf.ones([8, 1]), {
     *       batchSize: 4,
     *       epochs: 3
     *   });
     *   console.log("Loss after Epoch " + i + " : " + h.history.loss[0]);
     * }
     * ```
     *
     * @param x `tf.Tensor` of training data, or an array of `tf.Tensor`s if the
     * model has multiple inputs. If all inputs in the model are named, you
     * can also pass a dictionary mapping input names to `tf.Tensor`s.
     * @param y `tf.Tensor` of target (label) data, or an array of `tf.Tensor`s if
     * the model has multiple outputs. If all outputs in the model are named,
     * you can also pass a dictionary mapping output names to `tf.Tensor`s.
     * @param args A `ModelFitArgs`, containing optional fields.
     *
     * @return A `History` instance. Its `history` attribute contains all
     *   information collected during training.
     *
     * @exception ValueError In case of mismatch between the provided input
     * data and what the model expects.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */async fit(e,s,n={}){if(this.isTraining)throw new Error("Cannot start training because another fit() call is ongoing.");this.isTraining=true;let i;let a;let r;let o;let l;let u;let h;let c;let p;try{const t=n.batchSize==null?32:n.batchSize;checkBatchSize(t);const d=false;const g=await this.standardizeUserData(e,s,n.sampleWeight,n.classWeight,d,t);i=g[0];a=g[1];p=g[2];let m=false;let f;if(n.validationData!=null&&n.validationData.length>0){m=true;if(n.validationData.length!==2)throw n.validationData.length===3?new rt("validationData including sample weights is not supported yet."):new at(`When passing validation data, it must contain 2 (valX, valY) or 3 (valX, valY, valSampleWeight) items; ${n.validationData} is invalid.`);l=n.validationData[0];u=n.validationData[1];const e=true;const s=await this.standardizeUserData(l,u,null,null,e,t);h=s[0];c=s[1];f=h.concat(c)}else if(n.validationSplit!=null&&n.validationSplit>0&&n.validationSplit<1){m=true;const t=Math.floor(i[0].shape[0]*(1-n.validationSplit));const e=i[0].shape[0];h=sliceArrays(i,t,e);r=i;i=sliceArrays(i,0,t);c=sliceArrays(a,t,e);o=a;a=sliceArrays(a,0,t);f=h.concat(c)}else n.validationSteps!=null&&(m=true);const y=i.concat(a).concat(p);this.checkTrainableWeightsConsistency();const b=this.makeTrainFunction();const w=this.getDedupedMetricsNames();let S;let C;if(m){this.makeTestFunction();S=this.testFunction;C=w.slice().concat(w.map((t=>"val_"+t)))}else{S=null;f=[];C=w.slice()}const z=standardizeCallbacks(n.callbacks,n.yieldEvery);const N=await this.fitLoop(b,y,w,t,n.epochs,n.verbose,z,S,f,n.shuffle,C,n.initialEpoch,null,null);return N}finally{this.isTraining=false;disposeNewTensors(i,e);disposeNewTensors(a,s);disposeNewTensors(r,e);disposeNewTensors(o,s);disposeNewTensors(h,l);disposeNewTensors(c,u);p!=null&&t.dispose(p)}}
/**
     * Abstract fit function for `f(ins)`.
     * @param f A Function returning a list of tensors. For training, this
     *   function is expected to perform the updates to the variables.
     * @param ins List of tensors to be fed to `f`.
     * @param outLabels List of strings, display names of the outputs of `f`.
     * @param batchSize Integer batch size or `== null` if unknown. Default : 32.
     * @param epochs Number of times to iterate over the data. Default : 1.
     * @param verbose Verbosity mode: 0, 1, or 2. Default: 1.
     * @param callbacks List of callbacks to be called during training.
     * @param valF Function to call for validation.
     * @param valIns List of tensors to be fed to `valF`.
     * @param shuffle Whether to shuffle the data at the beginning of every
     * epoch. Default : true.
     * @param callbackMetrics List of strings, the display names of the metrics
     *   passed to the callbacks. They should be the concatenation of the
     *   display names of the outputs of `f` and the list of display names
     *   of the outputs of `valF`.
     * @param initialEpoch Epoch at which to start training (useful for
     *   resuming a previous training run). Default : 0.
     * @param stepsPerEpoch Total number of steps (batches on samples) before
     *   declaring one epoch finished and starting the next epoch. Ignored with
     *   the default value of `undefined` or `null`.
     * @param validationSteps Number of steps to run validation for (only if
     *   doing validation from data tensors). Not applicable for tfjs-layers.
     * @returns A `History` object.
     */async fitLoop(e,s,n,i,a,o,l,u,h,c,p,d,g,f){i==null&&(i=32);a==null&&(a=1);c==null&&(c=true);d==null&&(d=0);let y=false;u!=null&&h!=null&&(y=true);if(f!=null){y=true;if(g==null)throw new at("Can only use `validationSteps` when doing step-wise training, i.e., `stepsPerEpoch` must be set.")}const b=this.checkNumSamples(s,i,g,"steps_per_epoch");let w;b!=null&&(w=range(0,b));o==null&&(o=1);const{callbackList:S,history:C}=configureCallbacks(l,o,a,d,b,g,i,y,p);S.setModel(this);this.history=C;await S.onTrainBegin();this.stopTraining_=false;for(let o=d;o<a;++o){await S.onEpochBegin(o);const a={};if(g!=null)throw new rt("stepsPerEpoch mode is not implemented yet.");{if(c==="batch")throw new rt("batch shuffling is not implemneted yet");c&&m.shuffle(w);const o=r(w);const l=makeBatches(b,i);for(let r=0;r<l.length;++r){const c={};await S.onBatchBegin(r,c);t.tidy((()=>{const p=l[r][0];const d=l[r][1];const g=sliceAlongFirstAxis(o,p,d-p);c.batch=r;c.size=d-p;const m=sliceArraysByIndices(s,g);const f=e(m);for(let e=0;e<n.length;++e){const s=n[e];const i=f[e];c[s]=i;t.keep(i)}if(r===l.length-1&&y){const e=this.testLoop(u,h,i);for(let s=0;s<n.length;++s){const i=n[s];const r=e[s];t.keep(r);a["val_"+i]=r}}}));await S.onBatchEnd(r,c);disposeTensorsInLogs(c);if(this.stopTraining_)break}o.dispose()}await S.onEpochEnd(o,a);if(this.stopTraining_)break}await S.onTrainEnd();await this.history.syncData();return this.history}
/**
     * Trains the model using a dataset object.
     *
     * @param dataset A dataset object. Its `iterator()` method is expected
     *   to generate a dataset iterator object, the `next()` method of which
     *   is expected to produce data batches for training. The return value
     *   of the `next()` call ought to contain a boolean `done` field and a
     *   `value` field. The `value` field is expected to be an array of two
     *   `tf.Tensor`s or an array of two nested `tf.Tensor` structures. The former
     *   case is for models with exactly one input and one output (e.g.
     *   a sequential model). The latter case is for models with multiple
     *   inputs and/or multiple outputs.
     *   Of the two items in the array, the first is the input feature(s) and
     *   the second is the output target(s).
     * @param args A `ModelFitDatasetArgs`, containing optional fields.
     *
     * @return A `History` instance. Its `history` attribute contains all
     *   information collected during training.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */
async fitDataset(t,e){return fitDataset(this,t,e)}
/**
     * Runs a single gradient update on a single batch of data.
     *
     * This method differs from `fit()` and `fitDataset()` in the following
     * regards:
     *   - It operates on exactly one batch of data.
     *   - It returns only the loss and metric values, instead of
     *     returning the batch-by-batch loss and metric values.
     *   - It doesn't support fine-grained options such as verbosity and
     *     callbacks.
     *
     * @param x Input data. It could be one of the following:
     *   - A `tf.Tensor`, or an Array of `tf.Tensor`s (in case the model has
     *     multiple inputs).
     *   - An Object mapping input names to corresponding `tf.Tensor` (if the
     *     model has named inputs).
     * @param y Target data. It could be either a `tf.Tensor` or multiple
     *   `tf.Tensor`s. It should be consistent with `x`.
     * @returns Training loss or losses (in case the model has
     *   multiple outputs), along with metrics (if any), as numbers.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */async trainOnBatch(e,s){const n=await this.standardizeUserData(e,s);const i=n[0];const a=n[1];const r=this.makeTrainFunction();const o=r(i.concat(a));const l=[];for(const t of o){const e=await t.data();l.push(e[0])}t.dispose(o);disposeNewTensors(n[0],e);disposeNewTensors(n[1],s);return ct(l)}
/**
     * Extract weight values of the model.
     *
     * @param config: An instance of `io.SaveConfig`, which specifies
     * model-saving options such as whether only trainable weights are to be
     * saved.
     * @returns A `NamedTensorMap` mapping original weight names (i.e.,
     *   non-uniqueified weight names) to their values.
     */getNamedWeights(t){const e=[];const s=t!=null&&t.trainableOnly;const n=s?this.trainableWeights:this.weights;const i=this.getWeights(s);for(let t=0;t<n.length;++t)s&&!n[t].trainable||e.push({name:n[t].originalName,tensor:i[t]});return e}set stopTraining(t){this.stopTraining_=t}get stopTraining(){return this.stopTraining_}get optimizer(){return this.optimizer_}set optimizer(t){if(this.optimizer_!==t){this.optimizer_=t;this.isOptimizerOwned=false}}dispose(){const e=super.dispose();if(e.refCountAfterDispose===0&&this.optimizer!=null&&this.isOptimizerOwned){const s=t.memory().numTensors;this.optimizer_.dispose();e.numDisposedVariables+=s-t.memory().numTensors}return e}getLossIdentifiers(){let t;if(typeof this.loss==="string")t=ut(this.loss);else if(Array.isArray(this.loss)){for(const t of this.loss)if(typeof t!=="string")throw new Error("Serialization of non-string loss is not supported.");t=this.loss.map((t=>ut(t)))}else{const e=Object.keys(this.loss);t={};const s=this.loss;for(const n of e){if(typeof s[n]!=="string")throw new Error("Serialization of non-string loss is not supported.");t[n]=ut(s[n])}}return t}getMetricIdentifiers(){if(typeof this.metrics==="string"||typeof this.metrics==="function")return[ut(getLossOrMetricName(this.metrics))];if(Array.isArray(this.metrics))return this.metrics.map((t=>ut(getLossOrMetricName(t))));{const t={};for(const e in this.metrics)t[e]=ut(getLossOrMetricName(this.metrics[e]));return t}}getTrainingConfig(){return{loss:this.getLossIdentifiers(),metrics:this.getMetricIdentifiers(),optimizer_config:{class_name:this.optimizer.getClassName(),config:this.optimizer.getConfig()}}}loadTrainingConfig(t){if(t.weighted_metrics!=null)throw new Error("Loading weight_metrics is not supported yet.");if(t.loss_weights!=null)throw new Error("Loading loss_weights is not supported yet.");if(t.sample_weight_mode!=null)throw new Error("Loading sample_weight_mode is not supported yet.");const e=xt(t.optimizer_config);const s=vt(e);let n;if(typeof t.loss==="string")n=Ct(t.loss);else if(Array.isArray(t.loss))n=t.loss.map((t=>Ct(t)));else if(t.loss!=null){n={};for(const e in t.loss)n[e]=Ct(t.loss[e])}let i;if(Array.isArray(t.metrics))i=t.metrics.map((t=>Ct(t)));else if(t.metrics!=null){i={};for(const e in t.metrics)i[e]=Ct(t.metrics[e])}this.compile({loss:n,metrics:i,optimizer:s})}
/**
     * Save the configuration and/or weights of the LayersModel.
     *
     * An `IOHandler` is an object that has a `save` method of the proper
     * signature defined. The `save` method manages the storing or
     * transmission of serialized data ("artifacts") that represent the
     * model's topology and weights onto or via a specific medium, such as
     * file downloads, local storage, IndexedDB in the web browser and HTTP
     * requests to a server. TensorFlow.js provides `IOHandler`
     * implementations for a number of frequently used saving mediums, such as
     * `tf.io.browserDownloads` and `tf.io.browserLocalStorage`. See `tf.io`
     * for more details.
     *
     * This method also allows you to refer to certain types of `IOHandler`s
     * as URL-like string shortcuts, such as 'localstorage://' and
     * 'indexeddb://'.
     *
     * Example 1: Save `model`'s topology and weights to browser [local
     * storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage);
     * then load it back.
     *
     * ```js
     * const model = tf.sequential(
     *     {layers: [tf.layers.dense({units: 1, inputShape: [3]})]});
     * console.log('Prediction from original model:');
     * model.predict(tf.ones([1, 3])).print();
     *
     * const saveResults = await model.save('localstorage://my-model-1');
     *
     * const loadedModel = await tf.loadLayersModel('localstorage://my-model-1');
     * console.log('Prediction from loaded model:');
     * loadedModel.predict(tf.ones([1, 3])).print();
     * ```
     *
     * Example 2. Saving `model`'s topology and weights to browser
     * [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API);
     * then load it back.
     *
     * ```js
     * const model = tf.sequential(
     *     {layers: [tf.layers.dense({units: 1, inputShape: [3]})]});
     * console.log('Prediction from original model:');
     * model.predict(tf.ones([1, 3])).print();
     *
     * const saveResults = await model.save('indexeddb://my-model-1');
     *
     * const loadedModel = await tf.loadLayersModel('indexeddb://my-model-1');
     * console.log('Prediction from loaded model:');
     * loadedModel.predict(tf.ones([1, 3])).print();
     * ```
     *
     * Example 3. Saving `model`'s topology and weights as two files
     * (`my-model-1.json` and `my-model-1.weights.bin`) downloaded from
     * browser.
     *
     * ```js
     * const model = tf.sequential(
     *     {layers: [tf.layers.dense({units: 1, inputShape: [3]})]});
     * const saveResults = await model.save('downloads://my-model-1');
     * ```
     *
     * Example 4. Send  `model`'s topology and weights to an HTTP server.
     * See the documentation of `tf.io.http` for more details
     * including specifying request parameters and implementation of the
     * server.
     *
     * ```js
     * const model = tf.sequential(
     *     {layers: [tf.layers.dense({units: 1, inputShape: [3]})]});
     * const saveResults = await model.save('http://my-server/model/upload');
     * ```
     *
     * @param handlerOrURL An instance of `IOHandler` or a URL-like,
     * scheme-based string shortcut for `IOHandler`.
     * @param config Options for saving the model.
     * @returns A `Promise` of `SaveResult`, which summarizes the result of
     * the saving, such as byte sizes of the saved artifacts for the model's
     *   topology and weight values.
     *
     * @doc {heading: 'Models', subheading: 'Classes', ignoreCI: true}
     */async save(t,e){if(typeof t==="string"){const e=E.getSaveHandlers(t);if(e.length===0)throw new at(`Cannot find any save handlers for URL '${t}'`);if(e.length>1)throw new at(`Found more than one (${e.length}) save handlers for URL '${t}'`);t=e[0]}if(t.save==null)throw new at("LayersModel.save() cannot proceed because the IOHandler provided does not have the `save` attribute defined.");const s=await E.encodeWeights(this.getNamedWeights(e));const n=false;const i=null;const a=this.toJSON(i,n);const r={modelTopology:a,format:ge,generatedBy:`TensorFlow.js tfjs-layers v${pe}`,convertedBy:null};const o=e!=null&&e.includeOptimizer;if(o&&this.optimizer!=null){r.trainingConfig=this.getTrainingConfig();const t="optimizer";const{data:e,specs:n}=await E.encodeWeights(await this.optimizer.getWeights(),t);s.specs.push(...n);s.data=E.concatenateArrayBuffers([s.data,e])}if(this.userDefinedMetadata!=null){const t=true;checkUserDefinedMetadata(this.userDefinedMetadata,this.name,t);r.userDefinedMetadata=this.userDefinedMetadata}r.weightData=s.data;r.weightSpecs=s.specs;return t.save(r)}
/**
     * Set user-defined metadata.
     *
     * The set metadata will be serialized together with the topology
     * and weights of the model during `save()` calls.
     *
     * @param setUserDefinedMetadata
     */setUserDefinedMetadata(t){checkUserDefinedMetadata(t,this.name);this.userDefinedMetadata=t}getUserDefinedMetadata(){return this.userDefinedMetadata}}LayersModel.className="Model";l.registerClass(LayersModel);class Functional extends LayersModel{}Functional.className="Functional";l.registerClass(Functional);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Parses a JSON model configuration file and returns a model instance.
 *
 * ```js
 * // This example shows how to serialize a model using `toJSON()` and
 * // deserialize it as another model using `tf.models.modelFromJSON()`.
 * // Note: this example serializes and deserializes only the topology
 * // of the model; the weights of the loaded model will be different
 * // from those of the the original model, due to random weight
 * // initialization.
 * // To load the topology and weights of a model, use `tf.loadLayersModel()`.
 * const model1 = tf.sequential();
 * model1.add(tf.layers.repeatVector({inputShape: [2], n: 4}));
 * // Serialize `model1` as a JSON object.
 * const model1JSON = model1.toJSON(null, false);
 * model1.summary();
 *
 * const model2 = await tf.models.modelFromJSON(model1JSON);
 * model2.summary();
 * ```
 *
 *  @param modelAndWeightsConfig JSON object or string encoding a model and
 *       weights configuration. It can also be only the topology JSON of the
 *       model, in which case the weights will not be loaded.
 *  @param custom_objects Optional dictionary mapping names
 *       (strings) to custom classes or functions to be
 *       considered during deserialization.
 * @returns A TensorFlow.js Layers `tf.LayersModel` instance (uncompiled).
 */async function modelFromJSON(t,e){"modelTopology"in t||(t={modelTopology:t});t;let s=t.modelTopology;s.model_config!=null&&(s=s.model_config);const n=xt(s);const i=vt(n,e);if(t.weightsManifest!=null){const e=await E.loadWeights(t.weightsManifest,t.pathPrefix,i.weights.map((t=>t.originalName)));const s={};for(const t of i.weights)s[t.originalName]=e[t.originalName];i.loadWeights(s);w(e)}return i}
/**
 * Load a model composed of Layer objects, including its topology and optionally
 * weights. See the Tutorial named "How to import a Keras Model" for usage
 * examples.
 *
 * This method is applicable to:
 *
 * 1. Models created with the `tf.layers.*`, `tf.sequential`, and
 * `tf.model` APIs of TensorFlow.js and later saved with the
 * `tf.LayersModel.save` method.
 * 2. Models converted from Keras or TensorFlow tf.keras using the
 * [tensorflowjs_converter](https://github.com/tensorflow/tfjs/tree/master/tfjs-converter).
 *
 * This mode is *not* applicable to TensorFlow `SavedModel`s or their converted
 * forms. For those models, use `tf.loadGraphModel`.
 *
 * Example 1. Load a model from an HTTP server.
 *
 * ```js
 * const model = await tf.loadLayersModel(
 *     'https://storage.googleapis.com/tfjs-models/tfjs/iris_v1/model.json');
 * model.summary();
 * ```
 *
 * Example 2: Save `model`'s topology and weights to browser [local
 * storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage);
 * then load it back.
 *
 * ```js
 * const model = tf.sequential(
 *     {layers: [tf.layers.dense({units: 1, inputShape: [3]})]});
 * console.log('Prediction from original model:');
 * model.predict(tf.ones([1, 3])).print();
 *
 * const saveResults = await model.save('localstorage://my-model-1');
 *
 * const loadedModel = await tf.loadLayersModel('localstorage://my-model-1');
 * console.log('Prediction from loaded model:');
 * loadedModel.predict(tf.ones([1, 3])).print();
 * ```
 *
 * Example 3. Saving `model`'s topology and weights to browser
 * [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API);
 * then load it back.
 *
 * ```js
 * const model = tf.sequential(
 *     {layers: [tf.layers.dense({units: 1, inputShape: [3]})]});
 * console.log('Prediction from original model:');
 * model.predict(tf.ones([1, 3])).print();
 *
 * const saveResults = await model.save('indexeddb://my-model-1');
 *
 * const loadedModel = await tf.loadLayersModel('indexeddb://my-model-1');
 * console.log('Prediction from loaded model:');
 * loadedModel.predict(tf.ones([1, 3])).print();
 * ```
 *
 * Example 4. Load a model from user-selected files from HTML
 * [file input
 * elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file).
 *
 * ```js
 * // Note: this code snippet will not work without the HTML elements in the
 * //   page
 * const jsonUpload = document.getElementById('json-upload');
 * const weightsUpload = document.getElementById('weights-upload');
 *
 * const model = await tf.loadLayersModel(
 *     tf.io.browserFiles([jsonUpload.files[0], weightsUpload.files[0]]));
 * ```
 *
 * @param pathOrIOHandler Can be either of the two formats
 *   1. A string path to the `ModelAndWeightsConfig` JSON describing
 *      the model in the canonical TensorFlow.js format. For file://
 *      (tfjs-node-only), http:// and https:// schemas, the path can be
 *      either absolute or relative. The content of the JSON file is assumed to
 *      be a JSON object with the following fields and values:
 *      - 'modelTopology': A JSON object that can be either of:
 *        1. a model architecture JSON consistent with the format of the return
 *            value of `keras.Model.to_json()`
 *        2. a full model JSON in the format of `keras.models.save_model()`.
 *      - 'weightsManifest': A TensorFlow.js weights manifest.
 *      See the Python converter function `save_model()` for more details.
 *      It is also assumed that model weights can be accessed from relative
 *      paths described by the `paths` fields in weights manifest.
 *   2. A `tf.io.IOHandler` object that loads model artifacts with its `load`
 *      method.
 * @param options Optional configuration arguments for the model loading,
 *   including:
 *   - `strict`: Require that the provided weights exactly match those required
 *     by the layers.  Default true.  Passing false means that both extra
 *     weights and missing weights will be silently ignored.
 *   - `onProgress`: A progress callback of the form:
 *     `(fraction: number) => void`. This callback can be used to monitor the
 *     model-loading process.
 * @returns A `Promise` of `tf.LayersModel`, with the topology and weights
 *     loaded.
 *
 * @doc {heading: 'Models', subheading: 'Loading'}
 */async function loadLayersModel(t,e){e==null&&(e={});if(typeof t==="string"){const s=E.getLoadHandlers(t,e);if(s.length===0)s.push(E.browserHTTPRequest(t,e));else if(s.length>1)throw new at(`Found more than one (${s.length}) load handlers for URL '${t}'`);t=s[0]}return loadLayersModelFromIOHandler(t,void 0,e)}
/**
 * Load a model and optionally its weights, using an IOHandler object.
 *
 * @param handler The instance of `IOHandler` to be used during the model
 *   loading.
 * @param customObjects Any optional custom objects to be used during model
 *   loading.
 * @param strict Whether the weight loading will be done in strict mode.
 *   Default: `true`.
 */async function loadLayersModelFromIOHandler(t,e,s){s==null&&(s={});if(t.load==null)throw new at("Cannot proceed with model loading because the IOHandler provided does not have the `load` method implemented.");const n=await t.load();let i=n.modelTopology;i.model_config!=null&&(i=i.model_config);const a=s.strict==null||s.strict;const r=n.weightData!=null&&n.weightSpecs!=null&&a;const o=vt(xt(i),e,r);const l=n.trainingConfig;l!=null&&o.loadTrainingConfig(l);n.userDefinedMetadata!=null&&o.setUserDefinedMetadata(n.userDefinedMetadata);if(n.weightData!=null){if(n.weightSpecs==null)throw new at("LayersModel artifacts contains weight data, but not weight specs. Therefore loading of weights cannot proceed.");const{modelWeights:t,optimizerWeights:e}=decodeModelAndOptimizerWeights(n.weightData,n.weightSpecs);o.loadWeights(t,a);o.optimizer!=null&&e.length>0&&await o.optimizer.setWeights(e);w(t);w(e.map((t=>t.tensor)))}return o}function decodeModelAndOptimizerWeights(t,e){const s=E.decodeWeights(t,e);const n={};const i=[];e.forEach((t=>{t.group==="optimizer"?i.push({name:t.name,tensor:s[t.name]}):n[t.name]=s[t.name]}));return{modelWeights:n,optimizerWeights:i}}class Sequential extends LayersModel{constructor(t){super({inputs:[],outputs:[]});t=t||{};this.trainable=true;this.built=false;this.name=t.name!=null?t.name:getUid("sequential_");if(t.layers!=null)for(const e of t.layers)this.add(e)}checkShape(t){const e=t.inboundNodes[0].outputTensors[0].shape;if(e.some((t=>t<0)))throw new at(`Negative dimension size caused by adding layer ${t.name} with input shape [${t.inboundNodes[0].inputTensors[0].shape}]`)}
/**
     * Adds a layer instance on top of the layer stack.
     *
     * ```js
     *  const model = tf.sequential();
     *  model.add(tf.layers.dense({units: 8, inputShape: [1]}));
     *  model.add(tf.layers.dense({units: 4, activation: 'relu6'}));
     *  model.add(tf.layers.dense({units: 1, activation: 'relu6'}));
     *  // Note that the untrained model is random at this point.
     *  model.predict(tf.randomNormal([10, 1])).print();
     * ```
     * @param layer Layer instance.
     *
     * @exception ValueError In case the `layer` argument does not know its
     * input shape.
     * @exception ValueError In case the `layer` argument has multiple output
     *   tensors, or is already connected somewhere else (forbidden in
     *   `Sequential` models).
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */add(t){const e=t instanceof Sequential||t instanceof LayersModel;let s;if(e){s=t;if(s.outputs.length!==1)throw new at("All layers in a Sequential model should have a single output tensor. For multi-output layers, use the functional API.");if(s.inputs.length!==1)throw new at("All layers in a Sequential model should have a single input tensor. For multi-input layers, use the functional API.")}if(this.outputs.length===0){if(t.inboundNodes.length===0){if(t.batchInputShape==null)throw new at("The first layer in a Sequential model must get an `inputShape` or `batchInputShape` argument.");const e=Input({batchShape:t.batchInputShape,dtype:t.dtype,name:t.name+"_input"});t.apply(e)}if(e){this.outputs=s.outputs;this.inputs=s.inputs}else{if(t.inboundNodes.length!==1)throw new at(`A layer added to a Sequential model must not already be connected somewhere else. LayersModel received layer ${t.name} which has ${t.inboundNodes.length} pre-existing inbound connections.`);if(t.inboundNodes[0].outputTensors.length!==1)throw new at("All layers in a Sequential model should have a single output tensor. For multi-output layers, use the functional API.");this.checkShape(t);this.outputs=[t.inboundNodes[0].outputTensors[0]];this.inputs=getSourceInputs(this.outputs[0])}this.inboundNodes=[];new Node({outboundLayer:this,inboundLayers:[],nodeIndices:[],tensorIndices:[],inputTensors:this.inputs,outputTensors:this.outputs,inputMasks:bt(null,this.inputs.length),outputMasks:[null],inputShapes:this.inputs.map((t=>t.shape)),outputShapes:this.outputs[0].shape})}else{const e=t.apply(this.outputs[0]);if(Array.isArray(e))throw new TypeError("All layers in a Sequential model should have a single output tensor. For multi-output layers, use the functional API.");this.checkShape(t);this.outputs=[e];this.inboundNodes[0].outputTensors=this.outputs;this.inboundNodes[0].outputShapes=[this.outputs[0].shape]}this.layers.push(t);this.built=false}pop(){if(this.layers.length===0)throw new TypeError("There are no layers in the model.");this.layers.pop();if(this.layers.length===0){this.outputs=[];this.inboundNodes=[];this.outboundNodes=[]}else{const t=this.layers.length-1;this.layers[t].outboundNodes=[];this.outputs=[this.layers[t].output];this.inboundNodes[0].outputTensors=this.outputs;this.inboundNodes[0].outputShapes=[this.outputs[0].shape]}}call(t,e){this.model==null&&this.build();return this.model.call(t,e)}build(t){getExactlyOneShape(t);if(this.inputs.length===0||this.outputs.length===0)throw new TypeError("Sequential model cannot be built: model is empty. Add some layers first.");this.model=new LayersModel({inputs:this.inputs,outputs:this.outputs[0],name:this.name+"_model"});this.model.trainable=this.trainable;this.supportsMasking=this.model.supportsMasking;this.inputLayers=this.model.inputLayers;this.inputLayersNodeIndices=this.model.inputLayersNodeIndices;this.inputLayersTensorIndices=this.model.inputLayersTensorIndices;this.outputLayers=this.model.outputLayers;this.outputLayersNodeIndices=this.model.outputLayersNodeIndices;this.outputLayersTensorIndices=this.model.outputLayersTensorIndices;this.nodesByDepth=this.model.nodesByDepth;this.containerNodes=this.model.containerNodes;this.outputNames=this.model.outputNames;this.inputNames=this.model.inputNames;this.built=true}countParams(){this.built||this.build();return super.countParams()}
/**
     * Print a text summary of the Sequential model's layers.
     *
     * The summary includes
     * - Name and type of all layers that comprise the model.
     * - Output shape(s) of the layers
     * - Number of weight parameters of each layer
     * - The total number of trainable and non-trainable parameters of the
     * model.
     *
     * ```js
     * const model = tf.sequential();
     * model.add(
     *     tf.layers.dense({units: 100, inputShape: [10], activation: 'relu'}));
     * model.add(tf.layers.dense({units: 1, activation: 'sigmoid'}));
     *
     * model.summary();
     * ```
     *
     * @param lineLength Custom line length, in number of characters.
     * @param positions Custom widths of each of the columns, as either
     *   fractions of `lineLength` (e.g., `[0.5, 0.75, 1]`) or absolute number
     *   of characters (e.g., `[30, 50, 65]`). Each number corresponds to
     *   right-most (i.e., ending) position of a column.
     * @param printFn Custom print function. Can be used to replace the default
     *   `console.log`. For example, you can use `x => {}` to mute the printed
     *   messages in the console.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */summary(t,e,s=console.log){this.built||this.build();super.summary(t,e,s)}
/**
     * Sets the weights of the model.
     *
     * @param weights Should be a list of Tensors with shapes and types matching
     *   the output of `model.getWeights()`.
     */setWeights(t){this.model==null&&this.build();this.model.setWeights(t)}
/**
     * Returns the loss value & metrics values for the model in test mode.
     *
     * Loss and metrics are specified during `compile()`, which needs to happen
     * before calls to `evaluate()`.
     *
     * Computation is done in batches.
     *
     * ```js
     * const model = tf.sequential({
     *   layers: [tf.layers.dense({units: 1, inputShape: [10]})]
     * });
     * model.compile({optimizer: 'sgd', loss: 'meanSquaredError'});
     * const result = model.evaluate(tf.ones([8, 10]), tf.ones([8, 1]), {
     *   batchSize: 4,
     * });
     * result.print();
     * ```
     *
     * @param x `tf.Tensor` of test data, or an `Array` of `tf.Tensor`s if the
     * model has multiple inputs.
     * @param y `tf.Tensor` of target data, or an `Array` of `tf.Tensor`s if the
     * model has multiple outputs.
     * @param args A `ModelEvaluateConfig`, containing optional fields.
     *
     * @return `Scalar` test loss (if the model has a single output and no
     *   metrics) or `Array` of `Scalar`s (if the model has multiple outputs
     *   and/or metrics). The attribute `model.metricsNames`
     *   will give you the display labels for the scalar outputs.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */evaluate(t,e,s={}){if(!this.built)throw new ht("The model needs to be compiled before being used.");return this.model.evaluate(t,e,s)}
/**
     * Evaluate model using a dataset object.
     *
     * Note: Unlike `evaluate()`, this method is asynchronous (`async`).
     *
     * @param dataset A dataset object. Its `iterator()` method is expected
     *   to generate a dataset iterator object, the `next()` method of which
     *   is expected to produce data batches for evaluation. The return value
     *   of the `next()` call ought to contain a boolean `done` field and a
     *   `value` field. The `value` field is expected to be an array of two
     *   `tf.Tensor`s or an array of two nested `tf.Tensor` structures. The former
     *   case is for models with exactly one input and one output (e.g.
     *   a sequential model). The latter case is for models with multiple
     *   inputs and/or multiple outputs. Of the two items in the array, the
     *   first is the input feature(s) and the second is the output target(s).
     * @param args A configuration object for the dataset-based evaluation.
     * @returns Loss and metric values as an Array of `Scalar` objects.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */
async evaluateDataset(t,e){if(!this.built)throw new ht("The model needs to be compiled before being used.");return this.model.evaluateDataset(t,e)}
/**
     * Generates output predictions for the input samples.
     *
     * Computation is done in batches.
     *
     * Note: the "step" mode of predict() is currently not supported.
     *   This is because the TensorFlow.js core backend is imperative only.
     *
     * ```js
     * const model = tf.sequential({
     *   layers: [tf.layers.dense({units: 1, inputShape: [10]})]
     * });
     * model.predict(tf.ones([2, 10])).print();
     * ```
     *
     * @param x The input data, as a Tensor, or an `Array` of `tf.Tensor`s if
     *   the model has multiple inputs.
     * @param conifg A `ModelPredictConfig` object containing optional fields.
     *
     * @return `tf.Tensor`(s) of predictions.
     *
     * @exception ValueError In case of mismatch between the provided input data
     *   and the model's expectations, or in case a stateful model receives a
     *   number of samples that is not a multiple of the batch size.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */predict(t,e={}){this.model==null&&this.build();return this.model.predict(t,e)}
/**
     * Returns predictions for a single batch of samples.
     *
     * @param x: Input samples, as a Tensor, or list of Tensors (if the model
     *   has multiple inputs).
     * @return Tensor(s) of predictions
     */predictOnBatch(t){this.model==null&&this.build();return this.model.predictOnBatch(t)}
/**
     * See `LayersModel.compile`.
     *
     * @param args
     */compile(t){this.build();this.model.compile(t);this.optimizer_=this.model.optimizer;this.isOptimizerOwned=this.model.isOptimizerOwned;this.loss=this.model.loss;this.metrics=this.model.metrics;this.metricsTensors=this.model.metricsTensors;this.metricsNames=this.model.metricsNames}get optimizer(){return this.model==null?void 0:this.model.optimizer}set optimizer(t){this.model.optimizer=t}
/**
     * Trains the model for a fixed number of epochs (iterations on a dataset).
     *
     * ```js
     * const model = tf.sequential({
     *   layers: [tf.layers.dense({units: 1, inputShape: [10]})]
     * });
     * model.compile({optimizer: 'sgd', loss: 'meanSquaredError'});
     * const history = await model.fit(tf.ones([8, 10]), tf.ones([8, 1]), {
     *   batchSize: 4,
     *   epochs: 3
     * });
     * console.log(history.history.loss[0]);
     * ```
     *
     * @param x `tf.Tensor` of training data, or an array of `tf.Tensor`s if the
     * model has multiple inputs. If all inputs in the model are named, you can
     * also pass a dictionary mapping input names to `tf.Tensor`s.
     * @param y `tf.Tensor` of target (label) data, or an array of `tf.Tensor`s if
     * the model has multiple outputs. If all outputs in the model are named, you
     *  can also pass a dictionary mapping output names to `tf.Tensor`s.
     * @param args  A `ModelFitConfig`, containing optional fields.
     *
     * @return A `History` instance. Its `history` attribute contains all
     *   information collected during training.
     *
     * @exception ValueError In case of mismatch between the provided input data
     *   and what the model expects.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */async fit(t,e,s={}){if(!this.built)throw new ht("The model needs to be compiled before being used.");return this.model.fit(t,e,s)}
/**
     * Trains the model using a dataset object.
     *
     * ```js
     * const xArray = [
     *   [1, 1, 1, 1, 1, 1, 1, 1, 1],
     *   [1, 1, 1, 1, 1, 1, 1, 1, 1],
     *   [1, 1, 1, 1, 1, 1, 1, 1, 1],
     *   [1, 1, 1, 1, 1, 1, 1, 1, 1],
     * ];
     * const yArray = [1, 1, 1, 1];
     * // Create a dataset from the JavaScript array.
     * const xDataset = tf.data.array(xArray);
     * const yDataset = tf.data.array(yArray);
     * // Zip combines the `x` and `y` Datasets into a single Dataset, the
     * // iterator of which will return an object containing of two tensors,
     * // corresponding to `x` and `y`.  The call to `batch(4)` will bundle
     * // four such samples into a single object, with the same keys now pointing
     * // to tensors that hold 4 examples, organized along the batch dimension.
     * // The call to `shuffle(4)` causes each iteration through the dataset to
     * // happen in a different order.  The size of the shuffle window is 4.
     * const xyDataset = tf.data.zip({xs: xDataset, ys: yDataset})
     *     .batch(4)
     *     .shuffle(4);
     * const model = tf.sequential({
     *   layers: [tf.layers.dense({units: 1, inputShape: [9]})]
     * });
     * model.compile({optimizer: 'sgd', loss: 'meanSquaredError'});
     * const history = await model.fitDataset(xyDataset, {
     *   epochs: 4,
     *   callbacks: {onEpochEnd: (epoch, logs) => console.log(logs.loss)}
     * });
     * ```
     *
     * @param dataset A dataset object. Its `iterator()` method is expected to
     *   generate a dataset iterator object, the `next()` method of which is
     *   expected to produce data batches for evaluation. The return value of the
     *   `next()` call ought to contain a boolean `done` field and a `value`
     *   field.
     *
     *   The `value` field is expected to be an object of with fields
     *   `xs` and `ys`, which point to the feature tensor and the target tensor,
     *   respectively. This case is for models with exactly one input and one
     *   output (e.g. a sequential model). For example:
     *   ```js
     *   {value: {xs: xsTensor, ys: ysTensor}, done: false}
     *   ```
     *
     *   If the model has multiple inputs, the `xs` field of `value` should
     *   be an object mapping input names to their respective feature tensors.
     *   For example:
     *   ```js
     *   {
     *     value: {
     *       xs: {
     *         input_1: xsTensor1,
     *         input_2: xsTensor2
     *       },
     *       ys: ysTensor
     *     },
     *     done: false
     *   }
     *   ```
     *   If the model has multiple outputs, the `ys` field of `value` should
     *   be an object mapping output names to their respective target tensors.
     *   For example:
     *   ```js
     *   {
     *     value: {
     *       xs: xsTensor,
     *       ys: {
     *         output_1: ysTensor1,
     *         output_2: ysTensor2
     *       },
     *     },
     *     done: false
     *   }
     *   ```
     * @param args A `ModelFitDatasetArgs`, containing optional fields.
     *
     * @return A `History` instance. Its `history` attribute contains all
     *   information collected during training.
     *
     * @doc {heading: 'Models', subheading: 'Classes', ignoreCI: true}
     */async fitDataset(t,e){if(!this.built)throw new ht("The model needs to be compiled before being used.");return this.model.fitDataset(t,e)}
/**
     * Runs a single gradient update on a single batch of data.
     *
     * This method differs from `fit()` and `fitDataset()` in the following
     * regards:
     *   - It operates on exactly one batch of data.
     *   - It returns only the loss and metric values, instead of
     *     returning the batch-by-batch loss and metric values.
     *   - It doesn't support fine-grained options such as verbosity and
     *     callbacks.
     *
     * @param x Input data. It could be one of the following:
     *   - A `tf.Tensor`, or an Array of `tf.Tensor`s (in case the model has
     *     multiple inputs).
     *   - An Object mapping input names to corresponding `tf.Tensor` (if the
     *     model has named inputs).
     * @param y Target data. It could be either a `tf.Tensor` or multiple
     *   `tf.Tensor`s. It should be consistent with `x`.
     * @returns Training loss or losses (in case the model has
     *   multiple outputs), along with metrics (if any), as numbers.
     *
     * @doc {heading: 'Models', subheading: 'Classes'}
     */async trainOnBatch(t,e){return this.model.trainOnBatch(t,e)}static fromConfig(t,e,s={},n=false){let i;let a={};if(e instanceof Array){if(!(e[0].className!=null)||e[0].className==="Merge")throw new at("Legacy serialization format not supported yet.");i=e}else{m.assert(e.layers!=null,(()=>"When the config data for a Sequential model is not an Array, it must be an Object that contains the 'layers' field."));i=e.layers;delete e.layers;a=e}const r=new t(a);if(!(r instanceof Sequential))throw new rt(`Sequential.fromConfig called on non-Sequential input: ${r}`);for(const t of i){const e=void 0;const s=vt(t,e,n);n&&s.setFastWeightInitDuringBuild(true);r.add(s)}return r}set stopTraining(t){if(this.model==null)throw new at("Cannot set the stopTraining property of a sequential model before it is compiled.");this.model.stopTraining=t}get stopTraining(){if(this.model==null)throw new at("Cannot get the stopTraining property of a sequential model before it is compiled.");return this.model.stopTraining}getConfig(){const t=[];for(const e of this.layers){const s={};s.className=e.getClassName();s.config=e.getConfig();t.push(s)}return{name:this.name,layers:t}}}Sequential.className="Sequential";l.registerClass(Sequential);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function model(t){return new LayersModel(t)}function sequential(t){return new Sequential(t)}function input(t){return Input(t)}function registerCallbackConstructor(t,e){CallbackConstructorRegistry.registerCallbackConstructor(t,e)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */let me=class Activation extends l.Serializable{getConfig(){return{}}};class Elu extends me{
/**
     * Calculate the activation function.
     *
     * @param x: Input.
     * @param alpha: Scaling factor the negative section.
     * @return Output of the ELU activation.
     */
apply(t,e=1){return elu$1(t,e)}}Elu.className="elu";l.registerClass(Elu);class Selu extends me{apply(e){return t.selu(e)}}Selu.className="selu";l.registerClass(Selu);class Relu extends me{apply(e){return t.relu(e)}}Relu.className="relu";l.registerClass(Relu);class Relu6 extends me{apply(e){return s((()=>t.minimum(6,t.relu(e))))}}Relu6.className="relu6";l.registerClass(Relu6);class Linear extends me{apply(t){return t}}Linear.className="linear";l.registerClass(Linear);class Sigmoid extends me{apply(e){return t.sigmoid(e)}}Sigmoid.className="sigmoid";l.registerClass(Sigmoid);class HardSigmoid extends me{apply(t){return hardSigmoid(t)}}HardSigmoid.className="hardSigmoid";l.registerClass(HardSigmoid);class Softplus extends me{apply(e){return t.softplus(e)}}Softplus.className="softplus";l.registerClass(Softplus);class Softsign extends me{apply(t){return softsign(t)}}Softsign.className="softsign";l.registerClass(Softsign);class Tanh extends me{apply(e){return t.tanh(e)}}Tanh.className="tanh";l.registerClass(Tanh);let fe=class Softmax extends me{
/**
     * Calculate the activation function.
     *
     * @param x Tensor.
     * @param axis Integer, axis along which the softmax normalization is applied.
     * Invalid if < 2, as softmax across 1 (the batch dimension) is assumed to be
     * an error.
     *
     * @returns a Tensor of the same shape as x
     *
     * @throws ValueError: In case `dim(x) < 2`.
     */
apply(e,s=-1){return t.softmax(e,s)}};fe.className="softmax";l.registerClass(fe);class LogSoftmax extends me{
/**
     * Calculate the activation function of log softmax:
     * log( exp(x_i) / sum(exp(x)) )
     *
     * @param x Tensor.
     * @param axis Integer, axis along which the softmax normalization is applied.
     * Invalid if < 2, as softmax across 1 (the batch dimension) is assumed to be
     * an error.
     *
     * @returns a Tensor of the same shape as x
     *
     * @throws ValueError: In case `dim(x) < 2`.
     */
apply(e,s=-1){return t.logSoftmax(e,s)}}LogSoftmax.className="logSoftmax";l.registerClass(LogSoftmax);class Gelu extends me{
/**
     * Calculate the activation function.
     *
     * @param x Tensor.
     * @returns a Tensor of the same shape as x
     */
apply(e){return s((()=>t.tidy((()=>{const s=Math.sqrt(2);const n=t.mul(.5,t.add(1,t.erf(t.div(e,s))));return t.mul(e,n)}))))}}Gelu.className="gelu";l.registerClass(Gelu);class GeluNew extends me{
/**
     * Calculate the activation function.
     *
     * @param x Tensor.
     * @returns a Tensor of the same shape as x
     */
apply(e){return s((()=>t.mul(.5,t.mul(e,t.add(1,t.tanh(t.mul(t.sqrt(t.div(2,Math.PI)),t.add(e,t.mul(.044715,t.pow(e,3))))))))))}}GeluNew.className="gelu_new";l.registerClass(GeluNew);class Mish extends me{
/**
     * Calculate the activation function.
     *
     * @param x Tensor.
     * @returns a Tensor of the same shape as x
     */
apply(e){return s((()=>t.mul(e,t.tanh(t.softplus(e)))))}}Mish.className="mish";l.registerClass(Mish);class Swish extends me{
/**
     * Calculate the activation function.
     *
     * @param x Tensor.
     * @param alpha Scaling factor for the sigmoid function.
     * @returns a Tensor of the same shape as x
     */
apply(e,n=1){return s((()=>t.mul(t.sigmoid(t.mul(e,n)),e)))}}Swish.className="swish";l.registerClass(Swish);function serializeActivation(t){return t.getClassName()}function deserializeActivation(t,e={}){return ot(t,l.SerializationMap.getMap().classNameMap,e,"activation")}function getActivation(t){if(t==null){const t={};t.className="linear";t.config={};return deserializeActivation(t)}if(typeof t==="string"){const e={};e.className=t;e.config={};return deserializeActivation(e)}return t instanceof me?t:deserializeActivation(t)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function assertObjectArgs(t){if(t!=null&&typeof t!=="object")throw new Error(`Argument to L1L2 regularizer's constructor is expected to be an object, but received: ${t}`)}class Regularizer extends l.Serializable{}class L1L2 extends Regularizer{constructor(t){super();assertObjectArgs(t);this.l1=t==null||t.l1==null?.01:t.l1;this.l2=t==null||t.l2==null?.01:t.l2;this.hasL1=this.l1!==0;this.hasL2=this.l2!==0}
/**
     * Porting note: Renamed from __call__.
     * @param x Variable of which to calculate the regularization score.
     */apply(e){return s((()=>{let s=u([1]);this.hasL1&&(s=z(s,$(t.mul(this.l1,R(e)))));this.hasL2&&(s=z(s,$(t.mul(this.l2,square(e)))));return t.reshape(s,[])}))}getConfig(){return{l1:this.l1,l2:this.l2}}static fromConfig(t,e){return new t({l1:e.l1,l2:e.l2})}}L1L2.className="L1L2";l.registerClass(L1L2);function l1$1(t){assertObjectArgs(t);return new L1L2({l1:t!=null?t.l1:null,l2:0})}function l2$1(t){assertObjectArgs(t);return new L1L2({l2:t!=null?t.l2:null,l1:0})}const ye={l1l2:"L1L2"};function serializeRegularizer(t){return lt(t)}function deserializeRegularizer(t,e={}){return ot(t,l.SerializationMap.getMap().classNameMap,e,"regularizer")}function getRegularizer(t){if(t==null)return null;if(typeof t==="string"){const e=t in ye?ye[t]:t;const s={className:e,config:{}};return deserializeRegularizer(s)}return t instanceof Regularizer?t:deserializeRegularizer(t)}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class ReLU extends Layer{constructor(t){super(t==null?{}:t);this.supportsMasking=true;t!=null&&(this.maxValue=t.maxValue)}call(t,e){t=getExactlyOneTensor(t);let s=M(t);this.maxValue!=null&&(s=O(s,0,this.maxValue));return s}computeOutputShape(t){return t}getConfig(){const t={maxValue:this.maxValue};const e=super.getConfig();Object.assign(t,e);return t}}ReLU.className="ReLU";l.registerClass(ReLU);class LeakyReLU extends Layer{constructor(t){super(t==null?{}:t);this.DEFAULT_ALPHA=.3;t==null&&(t={});this.alpha=t.alpha==null?this.DEFAULT_ALPHA:t.alpha}call(t,e){const s=getExactlyOneTensor(t);return F(s,this.alpha)}computeOutputShape(t){return t}getConfig(){const t={alpha:this.alpha};const e=super.getConfig();Object.assign(t,e);return t}}LeakyReLU.className="LeakyReLU";l.registerClass(LeakyReLU);class PReLU extends Layer{constructor(t){super(t==null?{}:t);this.DEFAULT_ALPHA_INITIALIZER="zeros";t==null&&(t={});this.supportsMasking=true;this.alphaInitializer=getInitializer(t.alphaInitializer||this.DEFAULT_ALPHA_INITIALIZER);this.alphaRegularizer=getRegularizer(t.alphaRegularizer);this.alphaConstraint=getConstraint(t.alphaConstraint);if(t.sharedAxes==null)this.sharedAxes=null;else if(Array.isArray(t.sharedAxes))this.sharedAxes=t.sharedAxes;else{if(typeof t.sharedAxes!=="number")throw new at(`Expected sharedAxes to be a number or an array of numbers, but got ${t.sharedAxes}`);this.sharedAxes=[t.sharedAxes]}}build(t){t=getExactlyOneShape(t);const e=t.slice(1);if(this.sharedAxes!=null)for(const t of this.sharedAxes)e[t-1]=1;this.alpha=this.addWeight("alpha",e,"float32",this.alphaInitializer,this.alphaRegularizer,true,this.alphaConstraint);const s={};if(this.sharedAxes!=null)for(let e=1;e<t.length;++e)s[e]=t[e];this.inputSpec=[new InputSpec({ndim:t.length,axes:s})];this.built=true}call(t,e){t=getExactlyOneTensor(t);return _(t,this.alpha.read())}getConfig(){const t={alphaInitializer:serializeInitializer(this.alphaInitializer),alphaRegularizer:serializeRegularizer(this.alphaRegularizer),alphaConstraint:serializeConstraint(this.alphaConstraint),sharedAxes:this.sharedAxes};const e=super.getConfig();Object.assign(t,e);return t}}PReLU.className="PReLU";l.registerClass(PReLU);class ELU extends Layer{constructor(t){super(t==null?{}:t);this.DEFAULT_ALPHA=1;t==null&&(t={});if(t.alpha!=null&&t.alpha!==this.DEFAULT_ALPHA)throw new rt(`Non-default alpha value (${t.alpha}) is not supported by the ELU layer yet.`);this.alpha=t.alpha==null?this.DEFAULT_ALPHA:t.alpha}call(t,e){const s=getExactlyOneTensor(t);return P(s)}computeOutputShape(t){return t}getConfig(){const t={alpha:this.alpha};const e=super.getConfig();Object.assign(t,e);return t}}ELU.className="ELU";l.registerClass(ELU);class ThresholdedReLU extends Layer{constructor(t){super(t==null?{}:t);this.DEFAULT_THETA=1;t==null&&(t={});this.theta=t.theta==null?this.DEFAULT_THETA:t.theta}call(t,e){const s=getExactlyOneTensor(t);return c(s,b(U(s,this.theta),"float32"))}computeOutputShape(t){return t}getConfig(){const t={theta:this.theta};const e=super.getConfig();Object.assign(t,e);return t}}ThresholdedReLU.className="ThresholdedReLU";l.registerClass(ThresholdedReLU);class Softmax extends Layer{constructor(t){super(t==null?{}:t);this.DEFAULT_AXIS=1;t==null&&(t={});this.softmax=(new fe).apply;this.axis=t.axis==null?this.DEFAULT_AXIS:t.axis}call(t,e){return s((()=>{let s=getExactlyOneTensor(t);const n=e.mask;if(n!=null){const t=c(B(h(s.shape),b(n,s.dtype)),o(-1e9));s=z(s,t)}return this.axis instanceof Array?this.axis.length>1?V(B(s,W(s,this.axis,true))):this.softmax(s,this.axis[0]):this.softmax(s,this.axis)}))}computeOutputShape(t){return t}getConfig(){const t={axis:this.axis};const e=super.getConfig();Object.assign(t,e);return t}}Softmax.className="Softmax";l.registerClass(Softmax);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Transforms a single number of array of numbers into an array of numbers.
 * @param value
 * @param n: The size of the tuple to be returned.
 * @param name: Name of the parameter, used for generating error messages.
 * @returns An array of numbers.
 */function normalizeArray(t,e,s){if(typeof t==="number")return bt(t,e);if(t.length!==e)throw new at(`The ${s} argument must be an integer or tuple of ${e} integers. Received: ${t.length} elements.`);for(let n=0;n<e;++n){const i=t[n];if(!isInteger(i))throw new at(`The ${s} argument must be an integer or tuple of ${e} integers. Received: ${JSON.stringify(t)} including a non-integer number ${i}`)}return t}
/**
 * Determines output length of a convolution given input length.
 * @param inputLength
 * @param filterSize
 * @param padding
 * @param stride
 * @param dilation: dilation rate.
 */function convOutputLength(t,e,s,n,i=1){if(t==null)return t;const a=e+(e-1)*(i-1);let r;r=s==="same"?t:t-a+1;return Math.floor((r+n-1)/n)}function deconvLength(t,e,s,n){if(t==null)return null;if(n==="valid")t=t*e+max([s-e,0]);else{if(n!=="same")throw new at(`Unsupport padding mode: ${n}.`);t*=e}return t}
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Transpose and cast the input before the conv2d.
 * @param x Input image tensor.
 * @param dataFormat
 */function preprocessConv2DInput(e,n){return s((()=>{checkDataFormat(n);return n==="channelsFirst"?t.transpose(e,[0,2,3,1]):e}))}
/**
 * Transpose and cast the input before the conv3d.
 * @param x Input image tensor.
 * @param dataFormat
 */function preprocessConv3DInput(e,n){return s((()=>{checkDataFormat(n);return n==="channelsFirst"?t.transpose(e,[0,2,3,4,1]):e}))}
/**
 * 1D-convolution with bias added.
 *
 * Porting Note: This function does not exist in the Python Keras backend.
 *   It is exactly the same as `conv2d`, except the added `bias`.
 *
 * @param x Input tensor, rank-3, of shape `[batchSize, width, inChannels]`.
 * @param kernel Kernel, rank-3, of shape `[filterWidth, inDepth, outDepth]`.
 * @param bias Bias, rank-3, of shape `[outDepth]`.
 * @param strides
 * @param padding Padding mode.
 * @param dataFormat Data format.
 * @param dilationRate
 * @returns The result of the 1D convolution.
 * @throws ValueError, if `x`, `kernel` or `bias` is not of the correct rank.
 */function conv1dWithBias(e,n,i,a=1,r="valid",o,l=1){return s((()=>{o==null&&(o=imageDataFormat());checkDataFormat(o);if(e.shape.length!==3)throw new at(`The input of a conv1dWithBias operation should be 3, but is ${e.shape.length} instead.`);if(n.shape.length!==3)throw new at(`The kernel for a conv1dWithBias operation should be 3, but is ${n.shape.length} instead`);if(i!=null&&i.shape.length!==1)throw new at(`The bias for a conv1dWithBias operation should be 1, but is ${i.shape.length} instead`);o==="channelsFirst"&&(e=t.transpose(e,[0,2,1]));if(r==="causal")throw new rt("The support for CAUSAL padding mode in conv1dWithBias is not implemented yet.");let s=t.conv1d(e,n,a,r==="same"?"same":"valid","NWC",l);i!=null&&(s=biasAdd(s,i));return s}))}
/**
 * 1D-convolution.
 *
 * @param x Input tensor, rank-3, of shape `[batchSize, width, inChannels]`.
 * @param kernel Kernel, rank-3, of shape `[filterWidth, inDepth, outDepth]`.s
 * @param strides
 * @param padding Padding mode.
 * @param dataFormat Data format.
 * @param dilationRate
 * @returns The result of the 1D convolution.
 * @throws ValueError, if `x`, `kernel` or `bias` is not of the correct rank.
 */function conv2dWithBiasActivation(e,n,i,a=[1,1],r="valid",o,l,u=null){return s((()=>{o==null&&(o=imageDataFormat());checkDataFormat(o);if(e.rank!==3&&e.rank!==4)throw new at(`conv2dWithBiasActivation expects input to be of rank 3 or 4, but received ${e.rank}.`);if(n.rank!==3&&n.rank!==4)throw new at(`conv2dWithBiasActivation expects kernel to be of rank 3 or 4, but received ${e.rank}.`);let s=preprocessConv2DInput(e,o);if(r==="causal")throw new rt("The support for CAUSAL padding mode in conv1dWithBias is not implemented yet.");s=t.fused.conv2d({x:s,filter:n,strides:a,pad:r==="same"?"same":"valid",dilations:l,dataFormat:"NHWC",bias:i,activation:u});o==="channelsFirst"&&(s=t.transpose(s,[0,3,1,2]));return s}))}
/**
 * 3D Convolution.
 * @param x
 * @param kernel kernel of the convolution.
 * @param strides strides array.
 * @param padding padding mode. Default to 'valid'.
 * @param dataFormat data format. Defaults to 'channelsLast'.
 * @param dilationRate dilation rate array.
 * @returns Result of the 3D convolution.
 */function conv3dWithBias(e,n,i,a=[1,1,1],r="valid",o,l){return s((()=>{o==null&&(o=imageDataFormat());checkDataFormat(o);if(e.rank!==4&&e.rank!==5)throw new at(`conv3dWithBias expects input to be of rank 4 or 5, but received ${e.rank}.`);if(n.rank!==4&&n.rank!==5)throw new at(`conv3dWithBias expects kernel to be of rank 4 or 5, but received ${e.rank}.`);let s=preprocessConv3DInput(e,o);if(r==="causal")throw new rt("The support for CAUSAL padding mode in conv3dWithBias is not implemented yet.");s=t.conv3d(s,n,a,r==="same"?"same":"valid","NDHWC",l);i!=null&&(s=biasAdd(s,i));o==="channelsFirst"&&(s=t.transpose(s,[0,4,1,2,3]));return s}))}class BaseConv extends Layer{constructor(t,e){super(e);this.bias=null;this.DEFAULT_KERNEL_INITIALIZER="glorotNormal";this.DEFAULT_BIAS_INITIALIZER="zeros";BaseConv.verifyArgs(e);this.rank=t;zt(this.rank,"rank");if(this.rank!==1&&this.rank!==2&&this.rank!==3)throw new rt(`Convolution layer for rank other than 1, 2, or 3 (${this.rank}) is not implemented yet.`);this.kernelSize=normalizeArray(e.kernelSize,t,"kernelSize");this.strides=normalizeArray(e.strides==null?1:e.strides,t,"strides");this.padding=e.padding==null?"valid":e.padding;checkPaddingMode(this.padding);this.dataFormat=e.dataFormat==null?"channelsLast":e.dataFormat;checkDataFormat(this.dataFormat);this.activation=getActivation(e.activation);this.useBias=e.useBias==null||e.useBias;this.biasInitializer=getInitializer(e.biasInitializer||this.DEFAULT_BIAS_INITIALIZER);this.biasConstraint=getConstraint(e.biasConstraint);this.biasRegularizer=getRegularizer(e.biasRegularizer);this.activityRegularizer=getRegularizer(e.activityRegularizer);this.dilationRate=normalizeArray(e.dilationRate==null?1:e.dilationRate,t,"dilationRate");if(this.rank===1&&Array.isArray(this.dilationRate)&&this.dilationRate.length!==1)throw new at(`dilationRate must be a number or an array of a single number for 1D convolution, but received ${JSON.stringify(this.dilationRate)}`);if(this.rank===2){if(typeof this.dilationRate==="number")this.dilationRate=[this.dilationRate,this.dilationRate];else if(this.dilationRate.length!==2)throw new at(`dilationRate must be a number or array of two numbers for 2D convolution, but received ${JSON.stringify(this.dilationRate)}`)}else if(this.rank===3)if(typeof this.dilationRate==="number")this.dilationRate=[this.dilationRate,this.dilationRate,this.dilationRate];else if(this.dilationRate.length!==3)throw new at(`dilationRate must be a number or array of three numbers for 3D convolution, but received ${JSON.stringify(this.dilationRate)}`)}static verifyArgs(t){mt("kernelSize"in t,"required key 'kernelSize' not in config");if(typeof t.kernelSize!=="number"&&!Nt(t.kernelSize,"number",1,3))throw new at(`BaseConv expects config.kernelSize to be number or number[] with length 1, 2, or 3, but received ${JSON.stringify(t.kernelSize)}.`)}getConfig(){const t={kernelSize:this.kernelSize,strides:this.strides,padding:this.padding,dataFormat:this.dataFormat,dilationRate:this.dilationRate,activation:serializeActivation(this.activation),useBias:this.useBias,biasInitializer:serializeInitializer(this.biasInitializer),biasRegularizer:serializeRegularizer(this.biasRegularizer),activityRegularizer:serializeRegularizer(this.activityRegularizer),biasConstraint:serializeConstraint(this.biasConstraint)};const e=super.getConfig();Object.assign(t,e);return t}}class Conv extends BaseConv{constructor(t,e){super(t,e);this.kernel=null;Conv.verifyArgs(e);this.filters=e.filters;zt(this.filters,"filters");this.kernelInitializer=getInitializer(e.kernelInitializer||this.DEFAULT_KERNEL_INITIALIZER);this.kernelConstraint=getConstraint(e.kernelConstraint);this.kernelRegularizer=getRegularizer(e.kernelRegularizer)}build(t){t=getExactlyOneShape(t);const e=this.dataFormat==="channelsFirst"?1:t.length-1;if(t[e]==null)throw new at(`The channel dimension of the input should be defined. Found ${t[e]}`);const s=t[e];const n=this.kernelSize.concat([s,this.filters]);this.kernel=this.addWeight("kernel",n,null,this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);this.useBias&&(this.bias=this.addWeight("bias",[this.filters],null,this.biasInitializer,this.biasRegularizer,true,this.biasConstraint));this.inputSpec=[{ndim:this.rank+2,axes:{[e]:s}}];this.built=true}call(t,e){return s((()=>{t=getExactlyOneTensor(t);let e;const s=this.bias==null?null:this.bias.read();const n=kt(this.activation.getClassName());if(n!=null&&this.rank===2)e=conv2dWithBiasActivation(t,this.kernel.read(),s,this.strides,this.padding,this.dataFormat,this.dilationRate,n);else{if(this.rank===1)e=conv1dWithBias(t,this.kernel.read(),s,this.strides[0],this.padding,this.dataFormat,this.dilationRate[0]);else if(this.rank===2)e=conv2dWithBiasActivation(t,this.kernel.read(),s,this.strides,this.padding,this.dataFormat,this.dilationRate);else{if(this.rank!==3)throw new rt("convolutions greater than 3D are not implemented yet.");e=conv3dWithBias(t,this.kernel.read(),s,this.strides,this.padding,this.dataFormat,this.dilationRate)}this.activation!=null&&(e=this.activation.apply(e))}return e}))}computeOutputShape(t){t=getExactlyOneShape(t);const e=[];const s=this.dataFormat==="channelsLast"?t.slice(1,t.length-1):t.slice(2);for(let t=0;t<s.length;++t){const n=convOutputLength(s[t],this.kernelSize[t],this.padding,this.strides[t],typeof this.dilationRate==="number"?this.dilationRate:this.dilationRate[t]);e.push(n)}let n=[t[0]];if(this.dataFormat==="channelsLast"){n=n.concat(e);n.push(this.filters)}else{n.push(this.filters);n=n.concat(e)}return n}getConfig(){const t={filters:this.filters,kernelInitializer:serializeInitializer(this.kernelInitializer),kernelRegularizer:serializeRegularizer(this.kernelRegularizer),kernelConstraint:serializeConstraint(this.kernelConstraint)};const e=super.getConfig();Object.assign(t,e);return t}static verifyArgs(t){if(!("filters"in t)||typeof t.filters!=="number"||t.filters<1)throw new at(`Convolution layer expected config.filters to be a 'number' > 0 but got ${JSON.stringify(t.filters)}`)}}class Conv2D extends Conv{constructor(t){super(2,t);Conv2D.verifyArgs(t)}getConfig(){const t=super.getConfig();delete t.rank;return t}static verifyArgs(t){if(typeof t.kernelSize!=="number"&&!Nt(t.kernelSize,"number",1,2))throw new at(`Conv2D expects config.kernelSize to be number or number[] with length 1 or 2, but received ${JSON.stringify(t.kernelSize)}.`)}}Conv2D.className="Conv2D";l.registerClass(Conv2D);class Conv3D extends Conv{constructor(t){super(3,t);Conv3D.verifyArgs(t)}getConfig(){const t=super.getConfig();delete t.rank;return t}static verifyArgs(t){if(typeof t.kernelSize!=="number"&&!(Array.isArray(t.kernelSize)&&(t.kernelSize.length===1||t.kernelSize.length===3)))throw new at(`Conv3D expects config.kernelSize to be number or [number, number, number], but received ${JSON.stringify(t.kernelSize)}.`)}}Conv3D.className="Conv3D";l.registerClass(Conv3D);class Conv2DTranspose extends Conv2D{constructor(t){super(t);this.inputSpec=[new InputSpec({ndim:4})];if(this.padding!=="same"&&this.padding!=="valid")throw new at(`Conv2DTranspose currently supports only padding modes 'same' and 'valid', but received padding mode ${this.padding}`)}build(t){t=getExactlyOneShape(t);if(t.length!==4)throw new at("Input should have rank 4; Received input shape: "+JSON.stringify(t));const e=this.dataFormat==="channelsFirst"?1:t.length-1;if(t[e]==null)throw new at("The channel dimension of the inputs should be defined. Found `None`.");const s=t[e];const n=this.kernelSize.concat([this.filters,s]);this.kernel=this.addWeight("kernel",n,"float32",this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);this.useBias&&(this.bias=this.addWeight("bias",[this.filters],"float32",this.biasInitializer,this.biasRegularizer,true,this.biasConstraint));this.inputSpec=[new InputSpec({ndim:4,axes:{[e]:s}})];this.built=true}call(e,s){return t.tidy((()=>{let s=getExactlyOneTensor(e);if(s.shape.length!==4)throw new at(`Conv2DTranspose.call() expects input tensor to be rank-4, but received a tensor of rank-${s.shape.length}`);const n=s.shape;const i=n[0];let a;let r;if(this.dataFormat==="channelsFirst"){a=2;r=3}else{a=1;r=2}const o=n[a];const l=n[r];const u=this.kernelSize[0];const h=this.kernelSize[1];const c=this.strides[0];const p=this.strides[1];const d=deconvLength(o,c,u,this.padding);const g=deconvLength(l,p,h,this.padding);const m=[i,d,g,this.filters];this.dataFormat!=="channelsLast"&&(s=t.transpose(s,[0,2,3,1]));let f=t.conv2dTranspose(s,this.kernel.read(),m,this.strides,this.padding);this.dataFormat!=="channelsLast"&&(f=t.transpose(f,[0,3,1,2]));this.bias!=null&&(f=biasAdd(f,this.bias.read(),this.dataFormat));this.activation!=null&&(f=this.activation.apply(f));return f}))}computeOutputShape(t){t=getExactlyOneShape(t);const e=t.slice();let s;let n;let i;if(this.dataFormat==="channelsFirst"){s=1;n=2;i=3}else{s=3;n=1;i=2}const a=this.kernelSize[0];const r=this.kernelSize[1];const o=this.strides[0];const l=this.strides[1];e[s]=this.filters;e[n]=deconvLength(e[n],o,a,this.padding);e[i]=deconvLength(e[i],l,r,this.padding);return e}getConfig(){const t=super.getConfig();delete t.dilationRate;return t}}Conv2DTranspose.className="Conv2DTranspose";l.registerClass(Conv2DTranspose);class Conv3DTranspose extends Conv3D{constructor(t){super(t);this.inputSpec=[new InputSpec({ndim:5})];if(this.padding!=="same"&&this.padding!=="valid")throw new at(`Conv3DTranspose currently supports only padding modes 'same' and 'valid', but received padding mode ${this.padding}`)}build(t){t=getExactlyOneShape(t);if(t.length!==5)throw new at("Input should have rank 5; Received input shape: "+JSON.stringify(t));const e=this.dataFormat==="channelsFirst"?1:t.length-1;if(t[e]==null)throw new at("The channel dimension of the inputs should be defined. Found `None`.");const s=t[e];const n=this.kernelSize.concat([this.filters,s]);this.kernel=this.addWeight("kernel",n,"float32",this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);this.useBias&&(this.bias=this.addWeight("bias",[this.filters],"float32",this.biasInitializer,this.biasRegularizer,true,this.biasConstraint));this.inputSpec=[new InputSpec({ndim:5,axes:{[e]:s}})];this.built=true}call(e,s){return t.tidy((()=>{let s=getExactlyOneTensor(e);if(s.shape.length!==5)throw new at(`Conv3DTranspose.call() expects input tensor to be rank-4, but received a tensor of rank-${s.shape.length}`);const n=s.shape;const i=n[0];let a;let r;let o;if(this.dataFormat==="channelsFirst"){o=2;a=3;r=4}else{o=1;a=2;r=3}const l=n[o];const u=n[a];const h=n[r];const c=this.kernelSize[0];const p=this.kernelSize[1];const d=this.kernelSize[2];const g=this.strides[0];const m=this.strides[1];const f=this.strides[2];const y=deconvLength(l,g,c,this.padding);const b=deconvLength(u,m,p,this.padding);const w=deconvLength(h,f,d,this.padding);const S=[i,y,b,w,this.filters];this.dataFormat!=="channelsLast"&&(s=t.transpose(s,[0,2,3,4,1]));let C=t.conv3dTranspose(s,this.kernel.read(),S,this.strides,this.padding);this.dataFormat!=="channelsLast"&&(C=t.transpose(C,[0,4,1,2,3]));this.bias!==null&&(C=biasAdd(C,this.bias.read(),this.dataFormat));this.activation!==null&&(C=this.activation.apply(C));return C}))}computeOutputShape(t){t=getExactlyOneShape(t);const e=t.slice();let s;let n;let i;let a;if(this.dataFormat==="channelsFirst"){s=1;n=2;i=3;a=4}else{s=4;n=1;i=2;a=3}const r=this.kernelSize[0];const o=this.kernelSize[1];const l=this.kernelSize[2];const u=this.strides[0];const h=this.strides[1];const c=this.strides[2];e[s]=this.filters;e[n]=deconvLength(e[n],u,r,this.padding);e[i]=deconvLength(e[i],h,o,this.padding);e[a]=deconvLength(e[a],c,l,this.padding);return e}getConfig(){const t=super.getConfig();delete t.dilationRate;return t}}Conv3DTranspose.className="Conv3DTranspose";l.registerClass(Conv3DTranspose);class SeparableConv extends Conv{constructor(t,e){super(t,e);this.DEFAULT_DEPTHWISE_INITIALIZER="glorotUniform";this.DEFAULT_POINTWISE_INITIALIZER="glorotUniform";this.depthwiseKernel=null;this.pointwiseKernel=null;if(e.filters==null)throw new at("The `filters` configuration field is required by SeparableConv, but is unspecified.");if(e.kernelInitializer!=null||e.kernelRegularizer!=null||e.kernelConstraint!=null)throw new at("Fields kernelInitializer, kernelRegularizer and kernelConstraint are invalid for SeparableConv2D. Use depthwiseInitializer, depthwiseRegularizer, depthwiseConstraint, pointwiseInitializer, pointwiseRegularizer and pointwiseConstraint instead.");if(e.padding!=null&&e.padding!=="same"&&e.padding!=="valid")throw new at(`SeparableConv${this.rank}D supports only padding modes: 'same' and 'valid', but received ${JSON.stringify(e.padding)}`);this.depthMultiplier=e.depthMultiplier==null?1:e.depthMultiplier;this.depthwiseInitializer=getInitializer(e.depthwiseInitializer||this.DEFAULT_DEPTHWISE_INITIALIZER);this.depthwiseRegularizer=getRegularizer(e.depthwiseRegularizer);this.depthwiseConstraint=getConstraint(e.depthwiseConstraint);this.pointwiseInitializer=getInitializer(e.depthwiseInitializer||this.DEFAULT_POINTWISE_INITIALIZER);this.pointwiseRegularizer=getRegularizer(e.pointwiseRegularizer);this.pointwiseConstraint=getConstraint(e.pointwiseConstraint)}build(t){t=getExactlyOneShape(t);if(t.length<this.rank+2)throw new at(`Inputs to SeparableConv${this.rank}D should have rank ${this.rank+2}, but received input shape: ${JSON.stringify(t)}`);const e=this.dataFormat==="channelsFirst"?1:t.length-1;if(t[e]==null||t[e]<0)throw new at(`The channel dimension of the inputs should be defined, but found ${JSON.stringify(t[e])}`);const s=t[e];const n=this.kernelSize.concat([s,this.depthMultiplier]);const i=[];for(let t=0;t<this.rank;++t)i.push(1);i.push(s*this.depthMultiplier,this.filters);const a=true;this.depthwiseKernel=this.addWeight("depthwise_kernel",n,"float32",this.depthwiseInitializer,this.depthwiseRegularizer,a,this.depthwiseConstraint);this.pointwiseKernel=this.addWeight("pointwise_kernel",i,"float32",this.pointwiseInitializer,this.pointwiseRegularizer,a,this.pointwiseConstraint);this.useBias?this.bias=this.addWeight("bias",[this.filters],"float32",this.biasInitializer,this.biasRegularizer,a,this.biasConstraint):this.bias=null;this.inputSpec=[new InputSpec({ndim:this.rank+2,axes:{[e]:s}})];this.built=true}call(e,n){return s((()=>{e=getExactlyOneTensor(e);let s;if(this.rank===1)throw new rt("1D separable convolution is not implemented yet.");if(this.rank===2){this.dataFormat==="channelsFirst"&&(e=t.transpose(e,[0,2,3,1]));s=t.separableConv2d(e,this.depthwiseKernel.read(),this.pointwiseKernel.read(),this.strides,this.padding,this.dilationRate,"NHWC")}this.useBias&&(s=biasAdd(s,this.bias.read(),this.dataFormat));this.activation!=null&&(s=this.activation.apply(s));this.dataFormat==="channelsFirst"&&(s=t.transpose(s,[0,3,1,2]));return s}))}getConfig(){const t=super.getConfig();delete t.rank;delete t.kernelInitializer;delete t.kernelRegularizer;delete t.kernelConstraint;t.depthwiseInitializer=serializeInitializer(this.depthwiseInitializer);t.pointwiseInitializer=serializeInitializer(this.pointwiseInitializer);t.depthwiseRegularizer=serializeRegularizer(this.depthwiseRegularizer);t.pointwiseRegularizer=serializeRegularizer(this.pointwiseRegularizer);t.depthwiseConstraint=serializeConstraint(this.depthwiseConstraint);t.pointwiseConstraint=serializeConstraint(this.pointwiseConstraint);return t}}SeparableConv.className="SeparableConv";class SeparableConv2D extends SeparableConv{constructor(t){super(2,t)}}SeparableConv2D.className="SeparableConv2D";l.registerClass(SeparableConv2D);class Conv1D extends Conv{constructor(t){super(1,t);Conv1D.verifyArgs(t);this.inputSpec=[{ndim:3}]}getConfig(){const t=super.getConfig();delete t.rank;delete t.dataFormat;return t}static verifyArgs(t){if(typeof t.kernelSize!=="number"&&!Nt(t.kernelSize,"number",1,1))throw new at(`Conv1D expects config.kernelSize to be number or number[] with length 1, but received ${JSON.stringify(t.kernelSize)}.`)}}Conv1D.className="Conv1D";l.registerClass(Conv1D);class Cropping2D extends Layer{constructor(t){super(t);typeof t.cropping==="number"?this.cropping=[[t.cropping,t.cropping],[t.cropping,t.cropping]]:typeof t.cropping[0]==="number"?this.cropping=[[t.cropping[0],t.cropping[0]],[t.cropping[1],t.cropping[1]]]:this.cropping=t.cropping;this.dataFormat=t.dataFormat===void 0?"channelsLast":t.dataFormat;this.inputSpec=[{ndim:4}]}computeOutputShape(t){return this.dataFormat==="channelsFirst"?[t[0],t[1],t[2]-this.cropping[0][0]-this.cropping[0][1],t[3]-this.cropping[1][0]-this.cropping[1][1]]:[t[0],t[1]-this.cropping[0][0]-this.cropping[0][1],t[2]-this.cropping[1][0]-this.cropping[1][1],t[3]]}call(t,e){return s((()=>{t=getExactlyOneTensor(t);if(this.dataFormat==="channelsLast"){const e=sliceAlongAxis(t,this.cropping[0][0],t.shape[1]-this.cropping[0][0]-this.cropping[0][1],2);return sliceAlongAxis(e,this.cropping[1][0],t.shape[2]-this.cropping[1][1]-this.cropping[1][0],3)}{const e=sliceAlongAxis(t,this.cropping[0][0],t.shape[2]-this.cropping[0][0]-this.cropping[0][1],3);return sliceAlongAxis(e,this.cropping[1][0],t.shape[3]-this.cropping[1][1]-this.cropping[1][0],4)}}))}getConfig(){const t={cropping:this.cropping,dataFormat:this.dataFormat};const e=super.getConfig();Object.assign(t,e);return t}}Cropping2D.className="Cropping2D";l.registerClass(Cropping2D);class UpSampling2D extends Layer{constructor(t){super(t);this.DEFAULT_SIZE=[2,2];this.inputSpec=[{ndim:4}];this.size=t.size==null?this.DEFAULT_SIZE:t.size;this.dataFormat=t.dataFormat==null?"channelsLast":t.dataFormat;checkDataFormat(this.dataFormat);this.interpolation=t.interpolation==null?"nearest":t.interpolation;checkInterpolationFormat(this.interpolation)}computeOutputShape(t){if(this.dataFormat==="channelsFirst"){const e=t[2]==null?null:this.size[0]*t[2];const s=t[3]==null?null:this.size[1]*t[3];return[t[0],t[1],e,s]}{const e=t[1]==null?null:this.size[0]*t[1];const s=t[2]==null?null:this.size[1]*t[2];return[t[0],e,s,t[3]]}}call(e,s){return t.tidy((()=>{let s=getExactlyOneTensor(e);const n=s.shape;if(this.dataFormat==="channelsFirst"){s=t.transpose(s,[0,2,3,1]);const e=this.size[0]*n[2];const i=this.size[1]*n[3];const a=this.interpolation==="nearest"?t.image.resizeNearestNeighbor(s,[e,i]):t.image.resizeBilinear(s,[e,i]);return t.transpose(a,[0,3,1,2])}{const e=this.size[0]*n[1];const i=this.size[1]*n[2];return this.interpolation==="nearest"?t.image.resizeNearestNeighbor(s,[e,i]):t.image.resizeBilinear(s,[e,i])}}))}getConfig(){const t={size:this.size,dataFormat:this.dataFormat,interpolation:this.interpolation};const e=super.getConfig();Object.assign(t,e);return t}}UpSampling2D.className="UpSampling2D";l.registerClass(UpSampling2D);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * 2D convolution with separable filters.
 * @param x Input tensor.
 * @param depthwiseKernel Convolution kernel for depthwise convolution.
 * @param strides Strides (Array of two integers).
 * @param padding Padding model.
 * @param dataFormat Data format.
 * @param dilationRate Array of two integers, dilation rates for the separable
 *   convolution.
 * @returns Output tensor.
 * @throws ValueError If depthwiseKernel is not a 4D array.
 */function depthwiseConv2d$1(e,n,i=[1,1],a="valid",r,o){return s((()=>{r==null&&(r=imageDataFormat());checkDataFormat(r);let s=preprocessConv2DInput(e,r);if(e.rank!==4)throw new at(`Input for depthwiseConv2d is required to be 4-D, but is instead ${e.rank}-D`);if(n.rank!==4)throw new at(`depthwiseKernel is required to be 4-D, but is instead ${n.rank}-D`);s=t.depthwiseConv2d(s,n,i,a==="same"?"same":"valid","NHWC",o);r==="channelsFirst"&&(s=t.transpose(s,[0,3,1,2]));return s}))}class DepthwiseConv2D extends BaseConv{constructor(t){super(2,t);this.depthwiseKernel=null;this.depthMultiplier=t.depthMultiplier==null?1:t.depthMultiplier;this.depthwiseInitializer=getInitializer(t.depthwiseInitializer||this.DEFAULT_KERNEL_INITIALIZER);this.depthwiseConstraint=getConstraint(t.depthwiseConstraint);this.depthwiseRegularizer=getRegularizer(t.depthwiseRegularizer)}build(t){t=getExactlyOneShape(t);if(t.length<4)throw new at(`Inputs to DepthwiseConv2D should have rank 4. Received input shape: ${JSON.stringify(t)}.`);const e=this.dataFormat==="channelsFirst"?1:3;if(t[e]==null||t[e]<0)throw new at(`The channel dimension of the inputs to DepthwiseConv2D should be defined, but is not (${t[e]}).`);const s=t[e];const n=[this.kernelSize[0],this.kernelSize[1],s,this.depthMultiplier];this.depthwiseKernel=this.addWeight("depthwise_kernel",n,null,this.depthwiseInitializer,this.depthwiseRegularizer,true,this.depthwiseConstraint);this.useBias?this.bias=this.addWeight("bias",[s*this.depthMultiplier],null,this.biasInitializer,this.biasRegularizer,true,this.biasConstraint):this.bias=null;this.built=true}call(t,e){return s((()=>{t=getExactlyOneTensor(t);let e=depthwiseConv2d$1(t,this.depthwiseKernel.read(),this.strides,this.padding,this.dataFormat,null);this.useBias&&(e=biasAdd(e,this.bias.read(),this.dataFormat));this.activation!=null&&(e=this.activation.apply(e));return e}))}computeOutputShape(t){t=getExactlyOneShape(t);const e=this.dataFormat==="channelsFirst"?t[2]:t[1];const s=this.dataFormat==="channelsFirst"?t[3]:t[2];const n=this.dataFormat==="channelsFirst"?t[1]*this.depthMultiplier:t[3]*this.depthMultiplier;const i=convOutputLength(e,this.kernelSize[0],this.padding,this.strides[0]);const a=convOutputLength(s,this.kernelSize[1],this.padding,this.strides[1]);return this.dataFormat==="channelsFirst"?[t[0],n,i,a]:[t[0],i,a,n]}getConfig(){const t=super.getConfig();t.depthMultiplier=this.depthMultiplier;t.depthwiseInitializer=serializeInitializer(this.depthwiseInitializer);t.depthwiseRegularizer=serializeRegularizer(this.depthwiseRegularizer);t.depthwiseConstraint=serializeConstraint(this.depthwiseRegularizer);return t}}DepthwiseConv2D.className="DepthwiseConv2D";l.registerClass(DepthwiseConv2D);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Standardize `apply()` args to a single list of tensor inputs.
 *
 * When running a model loaded from file, the input tensors `initialState` and
 * `constants` are passed to `RNN.apply()` as part of `inputs` instead of the
 * dedicated kwargs fields. `inputs` consists of
 * `[inputs, initialState0, initialState1, ..., constant0, constant1]` in this
 * case.
 * This method makes sure that arguments are
 * separated and that `initialState` and `constants` are `Array`s of tensors
 * (or None).
 *
 * @param inputs Tensor or `Array` of  tensors.
 * @param initialState Tensor or `Array` of tensors or `null`/`undefined`.
 * @param constants Tensor or `Array` of tensors or `null`/`undefined`.
 * @returns An object consisting of
 *   inputs: A tensor.
 *   initialState: `Array` of tensors or `null`.
 *   constants: `Array` of tensors or `null`.
 * @throws ValueError, if `inputs` is an `Array` but either `initialState` or
 *   `constants` is provided.
 */function standardizeArgs(t,e,s,n){if(Array.isArray(t)){if(e!=null||s!=null)throw new at("When inputs is an array, neither initialState or constants should be provided");if(n!=null){s=t.slice(t.length-n,t.length);t=t.slice(0,t.length-n)}t.length>1&&(e=t.slice(1,t.length));t=t[0]}function toListOrNull(t){return t==null||Array.isArray(t)?t:[t]}e=toListOrNull(e);s=toListOrNull(s);return{inputs:t,initialState:e,constants:s}}
/**
 * Iterates over the time dimension of a tensor.
 *
 * @param stepFunction RNN step function.
 *   Parameters:
 *     inputs: tensor with shape `[samples, ...]` (no time dimension),
 *       representing input for the batch of samples at a certain time step.
 *     states: an Array of tensors.
 *   Returns:
 *     outputs: tensor with shape `[samples, outputDim]` (no time dimension).
 *     newStates: list of tensors, same length and shapes as `states`. The first
 *       state in the list must be the output tensor at the previous timestep.
 * @param inputs Tensor of temporal data of shape `[samples, time, ...]` (at
 *   least 3D).
 * @param initialStates Tensor with shape `[samples, outputDim]` (no time
 *   dimension), containing the initial values of the states used in the step
 *   function.
 * @param goBackwards If `true`, do the iteration over the time dimension in
 *   reverse order and return the reversed sequence.
 * @param mask Binary tensor with shape `[sample, time, 1]`, with a zero for
 *   every element that is masked.
 * @param constants An Array of constant values passed at each step.
 * @param unroll Whether to unroll the RNN or to use a symbolic loop. *Not*
 *   applicable to this imperative deeplearn.js backend. Its value is ignored.
 * @param needPerStepOutputs Whether the per-step outputs are to be
 *   concatenated into a single tensor and returned (as the second return
 *   value). Default: `false`. This arg is included so that the relatively
 *   expensive concatenation of the stepwise outputs can be omitted unless
 *   the stepwise outputs need to be kept (e.g., for an LSTM layer of which
 *   `returnSequence` is `true`.)
 * @returns An Array: `[lastOutput, outputs, newStates]`.
 *   lastOutput: the lastest output of the RNN, of shape `[samples, ...]`.
 *   outputs: tensor with shape `[samples, time, ...]` where each entry
 *     `output[s, t]` is the output of the step function at time `t` for sample
 *     `s`. This return value is provided if and only if the
 *     `needPerStepOutputs` is set as `true`. If it is set as `false`, this
 *     return value will be `undefined`.
 *   newStates: Array of tensors, latest states returned by the step function,
 *      of shape `(samples, ...)`.
 * @throws ValueError If input dimension is less than 3.
 *
 * TODO(nielsene): This needs to be tidy-ed.
 */function rnn$1(e,s,n,i=false,a,r,o=false,l=false){return t.tidy((()=>{const u=s.shape.length;if(u<3)throw new at(`Input should be at least 3D, but is ${u}D.`);const h=[1,0].concat(range(2,u));s=t.transpose(s,h);if(r!=null)throw new rt("The rnn() functoin of the deeplearn.js backend does not support constants yet.");o&&console.warn("Backend rnn(): the unroll = true option is not applicable to the imperative deeplearn.js backend.");if(a!=null){a=t.cast(t.cast(a,"bool"),"float32");a.rank===u-1&&(a=t.expandDims(a,-1));a=t.transpose(a,h)}if(i){s=t.reverse(s,0);a!=null&&(a=t.reverse(a,0))}const c=[];let p;let d=n;const g=s.shape[0];const m=t.unstack(s);let f;a!=null&&(f=t.unstack(a));for(let s=0;s<g;++s){const n=m[s];const i=t.tidy((()=>e(n,d)));if(a==null){p=i[0];d=i[1]}else{const e=t.tidy((()=>{const e=f[s];const n=t.sub(t.onesLike(e),e);const a=t.add(t.mul(i[0],e),t.mul(d[0],n));const r=d.map(((s,a)=>t.add(t.mul(i[1][a],e),t.mul(s,n))));return{output:a,newStates:r}}));p=e.output;d=e.newStates}l&&c.push(p)}let y;if(l){const e=1;y=t.stack(c,e)}return[p,y,d]}))}class RNN extends Layer{constructor(t){super(t);let e;if(t.cell==null)throw new at("cell property is missing for the constructor of RNN.");e=Array.isArray(t.cell)?new StackedRNNCells({cells:t.cell}):t.cell;if(e.stateSize==null)throw new at("The RNN cell should have an attribute `stateSize` (tuple of integers, one integer per RNN state).");this.cell=e;this.returnSequences=t.returnSequences!=null&&t.returnSequences;this.returnState=t.returnState!=null&&t.returnState;this.goBackwards=t.goBackwards!=null&&t.goBackwards;this._stateful=t.stateful!=null&&t.stateful;this.unroll=t.unroll!=null&&t.unroll;this.supportsMasking=true;this.inputSpec=[new InputSpec({ndim:3})];this.stateSpec=null;this.states_=null;this.numConstants=null;this.keptStates=[]}getStates(){if(this.states_==null){const t=Array.isArray(this.cell.stateSize)?this.cell.stateSize.length:1;return range(0,t).map((t=>null))}return this.states_}setStates(t){this.states_=t}computeOutputShape(t){isArrayOfShapes(t)&&(t=t[0]);t;let e=this.cell.stateSize;Array.isArray(e)||(e=[e]);const s=e[0];let n;n=this.returnSequences?[t[0],t[1],s]:[t[0],s];if(this.returnState){const s=[];for(const n of e)s.push([t[0],n]);return[n].concat(s)}return n}computeMask(e,s){return t.tidy((()=>{Array.isArray(s)&&(s=s[0]);const t=this.returnSequences?s:null;if(this.returnState){const e=this.states.map((t=>null));return[t].concat(e)}return t}))}get states(){if(this.states_==null){const t=Array.isArray(this.cell.stateSize)?this.cell.stateSize.length:1;const e=[];for(let s=0;s<t;++s)e.push(null);return e}return this.states_}set states(t){this.states_=t}build(t){const e=null;if(this.numConstants!=null)throw new rt("Constants support is not implemented in RNN yet.");isArrayOfShapes(t)&&(t=t[0]);t;const s=this.stateful?t[0]:null;const n=t.slice(2);this.inputSpec[0]=new InputSpec({shape:[s,null,...n]});const i=[t[0]].concat(t.slice(2));if(e!=null)throw new rt("Constants support is not implemented in RNN yet.");this.cell.build(i);let a;a=Array.isArray(this.cell.stateSize)?this.cell.stateSize:[this.cell.stateSize];if(this.stateSpec!=null){if(!m.arraysEqual(this.stateSpec.map((t=>t.shape[t.shape.length-1])),a))throw new at(`An initialState was passed that is not compatible with cell.stateSize. Received stateSpec=${this.stateSpec}; However cell.stateSize is ${this.cell.stateSize}`)}else this.stateSpec=a.map((t=>new InputSpec({shape:[null,t]})));this.stateful&&this.resetStates()}
/**
     * Reset the state tensors of the RNN.
     *
     * If the `states` argument is `undefined` or `null`, will set the
     * state tensor(s) of the RNN to all-zero tensors of the appropriate
     * shape(s).
     *
     * If `states` is provided, will set the state tensors of the RNN to its
     * value.
     *
     * @param states Optional externally-provided initial states.
     * @param training Whether this call is done during training. For stateful
     *   RNNs, this affects whether the old states are kept or discarded. In
     *   particular, if `training` is `true`, the old states will be kept so
     *   that subsequent backpropgataion through time (BPTT) may work properly.
     *   Else, the old states will be discarded.
     */resetStates(e,n=false){s((()=>{if(!this.stateful)throw new pt("Cannot call resetStates() on an RNN Layer that is not stateful.");const s=this.inputSpec[0].shape[0];if(s==null)throw new at("If an RNN is stateful, it needs to know its batch size. Specify the batch size of your input tensors: \n- If using a Sequential model, specify the batch size by passing a `batchInputShape` option to your first layer.\n- If using the functional API, specify the batch size by passing a `batchShape` option to your Input layer.");if(this.states_==null)Array.isArray(this.cell.stateSize)?this.states_=this.cell.stateSize.map((e=>t.zeros([s,e]))):this.states_=[t.zeros([s,this.cell.stateSize])];else if(e==null){t.dispose(this.states_);if(this.keptStates!=null){t.dispose(this.keptStates);this.keptStates=[]}Array.isArray(this.cell.stateSize)?this.states_=this.cell.stateSize.map((e=>t.zeros([s,e]))):this.states_[0]=t.zeros([s,this.cell.stateSize])}else{Array.isArray(e)||(e=[e]);if(e.length!==this.states_.length)throw new at(`Layer ${this.name} expects ${this.states_.length} state(s), but it received ${e.length} state value(s). Input received: ${e}`);n===true?this.keptStates.push(this.states_.slice()):t.dispose(this.states_);for(let t=0;t<this.states_.length;++t){const n=e[t];const i=Array.isArray(this.cell.stateSize)?this.cell.stateSize[t]:this.cell.stateSize;const a=[s,i];if(!m.arraysEqual(n.shape,a))throw new at(`State ${t} is incompatible with layer ${this.name}: expected shape=${a}, received shape=${n.shape}`);this.states_[t]=n}}this.states_=this.states_.map((e=>t.keep(e.clone())))}))}apply(t,e){let s=e==null?null:e.initialState;let n=e==null?null:e.constants;e==null&&(e={});const i=standardizeArgs(t,s,n,this.numConstants);t=i.inputs;s=i.initialState;n=i.constants;let a=[];let r=[];if(s!=null){e.initialState=s;a=a.concat(s);this.stateSpec=[];for(const t of s)this.stateSpec.push(new InputSpec({shape:t.shape}));r=r.concat(this.stateSpec)}if(n!=null){e.constants=n;a=a.concat(n);this.numConstants=n.length}const o=a[0]instanceof SymbolicTensor;if(o){const s=[t].concat(a);const n=this.inputSpec.concat(r);const i=this.inputSpec;this.inputSpec=n;const o=super.apply(s,e);this.inputSpec=i;return o}return super.apply(t,e)}call(t,e){return s((()=>{const s=e==null?null:e.mask;const n=e==null?null:e.training;let i=e==null?null:e.initialState;t=getExactlyOneTensor(t);i==null&&(i=this.stateful?this.states_:this.getInitialState(t));const a=Array.isArray(this.cell.stateSize)?this.cell.stateSize.length:1;if(i.length!==a)throw new at(`RNN Layer has ${a} state(s) but was passed ${i.length} initial state(s).`);this.unroll&&console.warn("Ignoring unroll = true for RNN layer, due to imperative backend.");const r={training:n};const step=(t,e)=>{const s=this.cell.call([t].concat(e),r);return[s[0],s.slice(1)]};const o=rnn$1(step,t,i,this.goBackwards,s,null,this.unroll,this.returnSequences);const l=o[0];const u=o[1];const h=o[2];this.stateful&&this.resetStates(h,n);const c=this.returnSequences?u:l;return this.returnState?[c].concat(h):c}))}getInitialState(e){return s((()=>{let s=t.zeros(e.shape);s=t.sum(s,[1,2]);s=expandDims(s);return Array.isArray(this.cell.stateSize)?this.cell.stateSize.map((t=>t>1?tile(s,[1,t]):s)):this.cell.stateSize>1?[tile(s,[1,this.cell.stateSize])]:[s]}))}get trainableWeights(){return this.trainable?this.cell.trainableWeights:[]}get nonTrainableWeights(){return this.trainable?this.cell.nonTrainableWeights:this.cell.weights}setFastWeightInitDuringBuild(t){super.setFastWeightInitDuringBuild(t);this.cell!=null&&this.cell.setFastWeightInitDuringBuild(t)}getConfig(){const t=super.getConfig();const e={returnSequences:this.returnSequences,returnState:this.returnState,goBackwards:this.goBackwards,stateful:this.stateful,unroll:this.unroll};this.numConstants!=null&&(e.numConstants=this.numConstants);const s=this.cell.getConfig();this.getClassName()===RNN.className&&(e.cell={className:this.cell.getClassName(),config:s});return Object.assign(Object.assign(Object.assign({},s),t),e)}static fromConfig(t,e,s={}){const n=e.cell;const i=vt(n,s);return new t(Object.assign(e,{cell:i}))}}RNN.className="RNN";l.registerClass(RNN);class RNNCell extends Layer{}class SimpleRNNCell extends RNNCell{constructor(t){super(t);this.DEFAULT_ACTIVATION="tanh";this.DEFAULT_KERNEL_INITIALIZER="glorotNormal";this.DEFAULT_RECURRENT_INITIALIZER="orthogonal";this.DEFAULT_BIAS_INITIALIZER="zeros";this.units=t.units;zt(this.units,"units");this.activation=getActivation(t.activation==null?this.DEFAULT_ACTIVATION:t.activation);this.useBias=t.useBias==null||t.useBias;this.kernelInitializer=getInitializer(t.kernelInitializer||this.DEFAULT_KERNEL_INITIALIZER);this.recurrentInitializer=getInitializer(t.recurrentInitializer||this.DEFAULT_RECURRENT_INITIALIZER);this.biasInitializer=getInitializer(t.biasInitializer||this.DEFAULT_BIAS_INITIALIZER);this.kernelRegularizer=getRegularizer(t.kernelRegularizer);this.recurrentRegularizer=getRegularizer(t.recurrentRegularizer);this.biasRegularizer=getRegularizer(t.biasRegularizer);this.kernelConstraint=getConstraint(t.kernelConstraint);this.recurrentConstraint=getConstraint(t.recurrentConstraint);this.biasConstraint=getConstraint(t.biasConstraint);this.dropout=min([1,max([0,t.dropout==null?0:t.dropout])]);this.recurrentDropout=min([1,max([0,t.recurrentDropout==null?0:t.recurrentDropout])]);this.dropoutFunc=t.dropoutFunc;this.stateSize=this.units;this.dropoutMask=null;this.recurrentDropoutMask=null}build(t){t=getExactlyOneShape(t);this.kernel=this.addWeight("kernel",[t[t.length-1],this.units],null,this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);this.recurrentKernel=this.addWeight("recurrent_kernel",[this.units,this.units],null,this.recurrentInitializer,this.recurrentRegularizer,true,this.recurrentConstraint);this.useBias?this.bias=this.addWeight("bias",[this.units],null,this.biasInitializer,this.biasRegularizer,true,this.biasConstraint):this.bias=null;this.built=true}call(e,n){return s((()=>{e;if(e.length!==2)throw new at(`SimpleRNNCell expects 2 input Tensors, got ${e.length}.`);let s=e[1];e=e[0];const i=n.training!=null&&n.training;0<this.dropout&&this.dropout<1&&this.dropoutMask==null&&(this.dropoutMask=generateDropoutMask({ones:()=>t.onesLike(e),rate:this.dropout,training:i,dropoutFunc:this.dropoutFunc}));0<this.recurrentDropout&&this.recurrentDropout<1&&this.recurrentDropoutMask==null&&(this.recurrentDropoutMask=generateDropoutMask({ones:()=>t.onesLike(s),rate:this.recurrentDropout,training:i,dropoutFunc:this.dropoutFunc}));let a;const r=this.dropoutMask;const o=this.recurrentDropoutMask;a=dot$1(r!=null?t.mul(e,r):e,this.kernel.read());this.bias!=null&&(a=biasAdd(a,this.bias.read()));o!=null&&(s=t.mul(s,o));let l=t.add(a,dot$1(s,this.recurrentKernel.read()));this.activation!=null&&(l=this.activation.apply(l));return[l,l]}))}getConfig(){const t=super.getConfig();const e={units:this.units,activation:serializeActivation(this.activation),useBias:this.useBias,kernelInitializer:serializeInitializer(this.kernelInitializer),recurrentInitializer:serializeInitializer(this.recurrentInitializer),biasInitializer:serializeInitializer(this.biasInitializer),kernelRegularizer:serializeRegularizer(this.kernelRegularizer),recurrentRegularizer:serializeRegularizer(this.recurrentRegularizer),biasRegularizer:serializeRegularizer(this.biasRegularizer),activityRegularizer:serializeRegularizer(this.activityRegularizer),kernelConstraint:serializeConstraint(this.kernelConstraint),recurrentConstraint:serializeConstraint(this.recurrentConstraint),biasConstraint:serializeConstraint(this.biasConstraint),dropout:this.dropout,recurrentDropout:this.recurrentDropout};return Object.assign(Object.assign({},t),e)}}SimpleRNNCell.className="SimpleRNNCell";l.registerClass(SimpleRNNCell);class SimpleRNN extends RNN{constructor(t){t.cell=new SimpleRNNCell(t);super(t)}call(e,n){return s((()=>{if(this.cell.dropoutMask!=null){t.dispose(this.cell.dropoutMask);this.cell.dropoutMask=null}if(this.cell.recurrentDropoutMask!=null){t.dispose(this.cell.recurrentDropoutMask);this.cell.recurrentDropoutMask=null}const s=n==null?null:n.mask;const i=n==null?null:n.training;const a=n==null?null:n.initialState;return super.call(e,{mask:s,training:i,initialState:a})}))}static fromConfig(t,e){return new t(e)}}SimpleRNN.className="SimpleRNN";l.registerClass(SimpleRNN);class GRUCell extends RNNCell{constructor(t){super(t);this.DEFAULT_ACTIVATION="tanh";this.DEFAULT_RECURRENT_ACTIVATION="hardSigmoid";this.DEFAULT_KERNEL_INITIALIZER="glorotNormal";this.DEFAULT_RECURRENT_INITIALIZER="orthogonal";this.DEFAULT_BIAS_INITIALIZER="zeros";if(t.resetAfter)throw new at("GRUCell does not support reset_after parameter set to true.");this.units=t.units;zt(this.units,"units");this.activation=getActivation(t.activation===void 0?this.DEFAULT_ACTIVATION:t.activation);this.recurrentActivation=getActivation(t.recurrentActivation===void 0?this.DEFAULT_RECURRENT_ACTIVATION:t.recurrentActivation);this.useBias=t.useBias==null||t.useBias;this.kernelInitializer=getInitializer(t.kernelInitializer||this.DEFAULT_KERNEL_INITIALIZER);this.recurrentInitializer=getInitializer(t.recurrentInitializer||this.DEFAULT_RECURRENT_INITIALIZER);this.biasInitializer=getInitializer(t.biasInitializer||this.DEFAULT_BIAS_INITIALIZER);this.kernelRegularizer=getRegularizer(t.kernelRegularizer);this.recurrentRegularizer=getRegularizer(t.recurrentRegularizer);this.biasRegularizer=getRegularizer(t.biasRegularizer);this.kernelConstraint=getConstraint(t.kernelConstraint);this.recurrentConstraint=getConstraint(t.recurrentConstraint);this.biasConstraint=getConstraint(t.biasConstraint);this.dropout=min([1,max([0,t.dropout==null?0:t.dropout])]);this.recurrentDropout=min([1,max([0,t.recurrentDropout==null?0:t.recurrentDropout])]);this.dropoutFunc=t.dropoutFunc;this.implementation=t.implementation;this.stateSize=this.units;this.dropoutMask=null;this.recurrentDropoutMask=null}build(t){t=getExactlyOneShape(t);const e=t[t.length-1];this.kernel=this.addWeight("kernel",[e,this.units*3],null,this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);this.recurrentKernel=this.addWeight("recurrent_kernel",[this.units,this.units*3],null,this.recurrentInitializer,this.recurrentRegularizer,true,this.recurrentConstraint);this.useBias?this.bias=this.addWeight("bias",[this.units*3],null,this.biasInitializer,this.biasRegularizer,true,this.biasConstraint):this.bias=null;this.built=true}call(e,n){return s((()=>{e;if(e.length!==2)throw new at(`GRUCell expects 2 input Tensors (inputs, h, c), got ${e.length}.`);const s=n.training!=null&&n.training;let i=e[1];e=e[0];0<this.dropout&&this.dropout<1&&this.dropoutMask==null&&(this.dropoutMask=generateDropoutMask({ones:()=>t.onesLike(e),rate:this.dropout,training:s,count:3,dropoutFunc:this.dropoutFunc}));0<this.recurrentDropout&&this.recurrentDropout<1&&this.recurrentDropoutMask==null&&(this.recurrentDropoutMask=generateDropoutMask({ones:()=>t.onesLike(i),rate:this.recurrentDropout,training:s,count:3,dropoutFunc:this.dropoutFunc}));const a=this.dropoutMask;const r=this.recurrentDropoutMask;let o;let l;let u;0<this.dropout&&this.dropout<1&&(e=t.mul(e,a[0]));let h=dot$1(e,this.kernel.read());this.useBias&&(h=biasAdd(h,this.bias.read()));0<this.recurrentDropout&&this.recurrentDropout<1&&(i=t.mul(i,r[0]));const c=this.recurrentKernel.read();const[p,d]=t.split(c,[2*this.units,this.units],c.rank-1);const g=dot$1(i,p);const[m,f,y]=t.split(h,3,h.rank-1);const[b,w]=t.split(g,2,g.rank-1);o=this.recurrentActivation.apply(t.add(m,b));l=this.recurrentActivation.apply(t.add(f,w));const S=dot$1(t.mul(l,i),d);u=this.activation.apply(t.add(y,S));const C=t.add(t.mul(o,i),t.mul(t.add(1,t.neg(o)),u));return[C,C]}))}getConfig(){const t=super.getConfig();const e={units:this.units,activation:serializeActivation(this.activation),recurrentActivation:serializeActivation(this.recurrentActivation),useBias:this.useBias,kernelInitializer:serializeInitializer(this.kernelInitializer),recurrentInitializer:serializeInitializer(this.recurrentInitializer),biasInitializer:serializeInitializer(this.biasInitializer),kernelRegularizer:serializeRegularizer(this.kernelRegularizer),recurrentRegularizer:serializeRegularizer(this.recurrentRegularizer),biasRegularizer:serializeRegularizer(this.biasRegularizer),activityRegularizer:serializeRegularizer(this.activityRegularizer),kernelConstraint:serializeConstraint(this.kernelConstraint),recurrentConstraint:serializeConstraint(this.recurrentConstraint),biasConstraint:serializeConstraint(this.biasConstraint),dropout:this.dropout,recurrentDropout:this.recurrentDropout,implementation:this.implementation,resetAfter:false};return Object.assign(Object.assign({},t),e)}}GRUCell.className="GRUCell";l.registerClass(GRUCell);class GRU extends RNN{constructor(t){t.implementation===0&&console.warn("`implementation=0` has been deprecated, and now defaults to `implementation=1`. Please update your layer call.");t.cell=new GRUCell(t);super(t)}call(e,n){return s((()=>{if(this.cell.dropoutMask!=null){t.dispose(this.cell.dropoutMask);this.cell.dropoutMask=null}if(this.cell.recurrentDropoutMask!=null){t.dispose(this.cell.recurrentDropoutMask);this.cell.recurrentDropoutMask=null}const s=n==null?null:n.mask;const i=n==null?null:n.training;const a=n==null?null:n.initialState;return super.call(e,{mask:s,training:i,initialState:a})}))}static fromConfig(t,e){e.implmentation===0&&(e.implementation=1);return new t(e)}}GRU.className="GRU";l.registerClass(GRU);class LSTMCell extends RNNCell{constructor(t){super(t);this.DEFAULT_ACTIVATION="tanh";this.DEFAULT_RECURRENT_ACTIVATION="hardSigmoid";this.DEFAULT_KERNEL_INITIALIZER="glorotNormal";this.DEFAULT_RECURRENT_INITIALIZER="orthogonal";this.DEFAULT_BIAS_INITIALIZER="zeros";this.units=t.units;zt(this.units,"units");this.activation=getActivation(t.activation===void 0?this.DEFAULT_ACTIVATION:t.activation);this.recurrentActivation=getActivation(t.recurrentActivation===void 0?this.DEFAULT_RECURRENT_ACTIVATION:t.recurrentActivation);this.useBias=t.useBias==null||t.useBias;this.kernelInitializer=getInitializer(t.kernelInitializer||this.DEFAULT_KERNEL_INITIALIZER);this.recurrentInitializer=getInitializer(t.recurrentInitializer||this.DEFAULT_RECURRENT_INITIALIZER);this.biasInitializer=getInitializer(t.biasInitializer||this.DEFAULT_BIAS_INITIALIZER);this.unitForgetBias=t.unitForgetBias;this.kernelRegularizer=getRegularizer(t.kernelRegularizer);this.recurrentRegularizer=getRegularizer(t.recurrentRegularizer);this.biasRegularizer=getRegularizer(t.biasRegularizer);this.kernelConstraint=getConstraint(t.kernelConstraint);this.recurrentConstraint=getConstraint(t.recurrentConstraint);this.biasConstraint=getConstraint(t.biasConstraint);this.dropout=min([1,max([0,t.dropout==null?0:t.dropout])]);this.recurrentDropout=min([1,max([0,t.recurrentDropout==null?0:t.recurrentDropout])]);this.dropoutFunc=t.dropoutFunc;this.implementation=t.implementation;this.stateSize=[this.units,this.units];this.dropoutMask=null;this.recurrentDropoutMask=null}build(t){var e;t=getExactlyOneShape(t);const s=t[t.length-1];this.kernel=this.addWeight("kernel",[s,this.units*4],null,this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);this.recurrentKernel=this.addWeight("recurrent_kernel",[this.units,this.units*4],null,this.recurrentInitializer,this.recurrentRegularizer,true,this.recurrentConstraint);let n;if(this.useBias){if(this.unitForgetBias){const t=this.biasInitializer;const s=this.units;n=new(e=class CustomInit extends Initializer{apply(e,n){const i=t.apply([s]);const a=(new Ones).apply([s]);const r=t.apply([s*2]);return concatAlongFirstAxis(concatAlongFirstAxis(i,a),r)}},e.className="CustomInit",e)}else n=this.biasInitializer;this.bias=this.addWeight("bias",[this.units*4],null,n,this.biasRegularizer,true,this.biasConstraint)}else this.bias=null;this.built=true}call(e,n){return s((()=>{const s=n.training!=null&&n.training;e;if(e.length!==3)throw new at(`LSTMCell expects 3 input Tensors (inputs, h, c), got ${e.length}.`);let i=e[1];const a=e[2];e=e[0];0<this.dropout&&this.dropout<1&&this.dropoutMask==null&&(this.dropoutMask=generateDropoutMask({ones:()=>t.onesLike(e),rate:this.dropout,training:s,count:4,dropoutFunc:this.dropoutFunc}));0<this.recurrentDropout&&this.recurrentDropout<1&&this.recurrentDropoutMask==null&&(this.recurrentDropoutMask=generateDropoutMask({ones:()=>t.onesLike(i),rate:this.recurrentDropout,training:s,count:4,dropoutFunc:this.dropoutFunc}));const r=this.dropoutMask;const o=this.recurrentDropoutMask;let l;let u;let h;let c;0<this.dropout&&this.dropout<1&&(e=t.mul(e,r[0]));let p=dot$1(e,this.kernel.read());0<this.recurrentDropout&&this.recurrentDropout<1&&(i=t.mul(i,o[0]));p=t.add(p,dot$1(i,this.recurrentKernel.read()));this.useBias&&(p=biasAdd(p,this.bias.read()));const[d,g,m,f]=t.split(p,4,p.rank-1);l=this.recurrentActivation.apply(d);u=this.recurrentActivation.apply(g);h=t.add(t.mul(u,a),t.mul(l,this.activation.apply(m)));c=this.recurrentActivation.apply(f);const y=t.mul(c,this.activation.apply(h));return[y,y,h]}))}getConfig(){const t=super.getConfig();const e={units:this.units,activation:serializeActivation(this.activation),recurrentActivation:serializeActivation(this.recurrentActivation),useBias:this.useBias,kernelInitializer:serializeInitializer(this.kernelInitializer),recurrentInitializer:serializeInitializer(this.recurrentInitializer),biasInitializer:serializeInitializer(this.biasInitializer),unitForgetBias:this.unitForgetBias,kernelRegularizer:serializeRegularizer(this.kernelRegularizer),recurrentRegularizer:serializeRegularizer(this.recurrentRegularizer),biasRegularizer:serializeRegularizer(this.biasRegularizer),activityRegularizer:serializeRegularizer(this.activityRegularizer),kernelConstraint:serializeConstraint(this.kernelConstraint),recurrentConstraint:serializeConstraint(this.recurrentConstraint),biasConstraint:serializeConstraint(this.biasConstraint),dropout:this.dropout,recurrentDropout:this.recurrentDropout,implementation:this.implementation};return Object.assign(Object.assign({},t),e)}}LSTMCell.className="LSTMCell";l.registerClass(LSTMCell);class LSTM extends RNN{constructor(t){t.implementation===0&&console.warn("`implementation=0` has been deprecated, and now defaults to `implementation=1`. Please update your layer call.");t.cell=new LSTMCell(t);super(t)}call(e,n){return s((()=>{if(this.cell.dropoutMask!=null){t.dispose(this.cell.dropoutMask);this.cell.dropoutMask=null}if(this.cell.recurrentDropoutMask!=null){t.dispose(this.cell.recurrentDropoutMask);this.cell.recurrentDropoutMask=null}const s=n==null?null:n.mask;const i=n==null?null:n.training;const a=n==null?null:n.initialState;return super.call(e,{mask:s,training:i,initialState:a})}))}static fromConfig(t,e){e.implmentation===0&&(e.implementation=1);return new t(e)}}LSTM.className="LSTM";l.registerClass(LSTM);class StackedRNNCells extends RNNCell{constructor(t){super(t);this.cells=t.cells}get stateSize(){const t=[];for(const e of this.cells.slice().reverse())Array.isArray(e.stateSize)?t.push(...e.stateSize):t.push(e.stateSize);return t}call(t,e){return s((()=>{t;let s=t.slice(1);const n=[];for(const t of this.cells.slice().reverse())Array.isArray(t.stateSize)?n.push(s.splice(0,t.stateSize.length)):n.push(s.splice(0,1));n.reverse();const i=[];let a;for(let r=0;r<this.cells.length;++r){const o=this.cells[r];s=n[r];a=r===0?[t[0]].concat(s):[a[0]].concat(s);a=o.call(a,e);i.push(a.slice(1))}s=[];for(const t of i.slice().reverse())s.push(...t);return[a[0]].concat(s)}))}build(t){isArrayOfShapes(t)&&(t=t[0]);t;let e;this.cells.forEach(((s,n)=>{nameScope(`RNNCell_${n}`,(()=>{s.build(t);e=Array.isArray(s.stateSize)?s.stateSize[0]:s.stateSize;t=[t[0],e]}))}));this.built=true}getConfig(){const t=super.getConfig();const getCellConfig=t=>({className:t.getClassName(),config:t.getConfig()});const e=this.cells.map(getCellConfig);const s={cells:e};return Object.assign(Object.assign({},t),s)}static fromConfig(t,e,s={}){const n=[];for(const t of e.cells)n.push(vt(t,s));return new t({cells:n})}get trainableWeights(){if(!this.trainable)return[];const t=[];for(const e of this.cells)t.push(...e.trainableWeights);return t}get nonTrainableWeights(){const t=[];for(const e of this.cells)t.push(...e.nonTrainableWeights);if(!this.trainable){const e=[];for(const t of this.cells)e.push(...t.trainableWeights);return e.concat(t)}return t}
/**
     * Retrieve the weights of a the model.
     *
     * @returns A flat `Array` of `tf.Tensor`s.
     */getWeights(){const t=[];for(const e of this.cells)t.push(...e.weights);return batchGetValue(t)}
/**
     * Set the weights of the model.
     *
     * @param weights An `Array` of `tf.Tensor`s with shapes and types matching
     *     the output of `getWeights()`.
     */setWeights(t){const e=[];for(const s of this.cells){const n=s.weights.length;const i=t.splice(n);for(let t=0;t<s.weights.length;++t)e.push([s.weights[t],i[t]])}batchSetValue(e)}}StackedRNNCells.className="StackedRNNCells";l.registerClass(StackedRNNCells);function generateDropoutMask(e){const{ones:s,rate:n,training:i=false,count:a=1,dropoutFunc:r}=e;const droppedInputs=()=>r!=null?r(s(),n):dropout$1(s(),n);const createMask=()=>inTrainPhase(droppedInputs,s,i);if(!a||a<=1)return t.keep(createMask().clone());const o=Array(a).fill(void 0).map(createMask);return o.map((e=>t.keep(e.clone())))}
/**
 * @license
 * Copyright 2020 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */var be=(void 0,function(t,e){var s={};for(var n in t)Object.prototype.hasOwnProperty.call(t,n)&&e.indexOf(n)<0&&(s[n]=t[n]);if(t!=null&&typeof Object.getOwnPropertySymbols==="function"){var i=0;for(n=Object.getOwnPropertySymbols(t);i<n.length;i++)e.indexOf(n[i])<0&&Object.prototype.propertyIsEnumerable.call(t,n[i])&&(s[n[i]]=t[n[i]])}return s});class ConvRNN2D extends RNN{constructor(t){if(t.unroll)throw new rt("Unrolling is not possible with convolutional RNNs.");if(Array.isArray(t.cell))throw new rt("It is not possible at the moment to stack convolutional cells.");super(t);this.inputSpec=[new InputSpec({ndim:5})]}call(e,s){return t.tidy((()=>{if(this.cell.dropoutMask!=null){t.dispose(this.cell.dropoutMask);this.cell.dropoutMask=null}if(this.cell.recurrentDropoutMask!=null){t.dispose(this.cell.recurrentDropoutMask);this.cell.recurrentDropoutMask=null}if(s&&s.constants)throw new at("ConvRNN2D cell does not support constants");const n=s==null?null:s.mask;const i=s==null?null:s.training;const a=s==null?null:s.initialState;return super.call(e,{mask:n,training:i,initialState:a})}))}computeOutputShape(t){let e=this.computeSingleOutputShape(t);this.returnSequences||(e=[e[0],...e.slice(2)]);this.returnState&&(e=[e,...Array(2).fill([t[0],...e.slice(-3)])]);return e}getInitialState(e){return t.tidy((()=>{const{stateSize:s}=this.cell;const n=e.shape;const i=this.computeSingleOutputShape(n);const a=[i[0],...i.slice(2)];const r=t.zeros(a);return Array.isArray(s)?Array(s.length).fill(r):[r]}))}resetStates(e,s=false){t.tidy((()=>{if(!this.stateful)throw new pt("Cannot call resetStates() on an RNN Layer that is not stateful.");const n=this.inputSpec[0].shape;const i=this.computeSingleOutputShape(n);const a=[i[0],...i.slice(2)];const r=n[0];if(r==null)throw new at("If an RNN is stateful, it needs to know its batch size. Specify the batch size of your input tensors: \n- If using a Sequential model, specify the batch size by passing a `batchInputShape` option to your first layer.\n- If using the functional API, specify the batch size by passing a `batchShape` option to your Input layer.");if(this.getStates()==null)Array.isArray(this.cell.stateSize)?this.states_=this.cell.stateSize.map((()=>t.zeros(a))):this.states_=[t.zeros(a)];else if(e==null){t.dispose(this.states_);if(this.keptStates!=null){t.dispose(this.keptStates);this.keptStates=[]}Array.isArray(this.cell.stateSize)?this.states_=this.cell.stateSize.map((()=>t.zeros(a))):this.states_[0]=t.zeros(a)}else{Array.isArray(e)||(e=[e]);if(e.length!==this.states_.length)throw new at(`Layer ${this.name} expects ${this.states_.length} state(s), but it received ${e.length} state value(s). Input received: ${e}`);s?this.keptStates.push(this.states_.slice()):t.dispose(this.states_);for(let t=0;t<this.states_.length;++t){const s=e[t];const n=a;if(!m.arraysEqual(s.shape,n))throw new at(`State ${t} is incompatible with layer ${this.name}: expected shape=${n}, received shape=${s.shape}`);this.states_[t]=s}}this.states_=this.states_.map((e=>t.keep(e.clone())))}))}computeSingleOutputShape(t){const{dataFormat:e,filters:s,kernelSize:n,padding:i,strides:a,dilationRate:r}=this.cell;const o=e==="channelsFirst";const l=t[o?3:2];const u=t[o?4:3];const h=convOutputLength(l,n[0],i,a[0],r[0]);const c=convOutputLength(u,n[1],i,a[1],r[1]);const p=[...t.slice(0,2),...o?[s,h,c]:[h,c,s]];return p}}ConvRNN2D.className="ConvRNN2D";class ConvLSTM2DCell extends LSTMCell{constructor(t){const{filters:e,kernelSize:s,strides:n,padding:i,dataFormat:a,dilationRate:r}=t;super(Object.assign(Object.assign({},t),{units:e}));this.filters=e;zt(this.filters,"filters");this.kernelSize=normalizeArray(s,2,"kernelSize");this.kernelSize.forEach((t=>zt(t,"kernelSize")));this.strides=normalizeArray(n||1,2,"strides");this.strides.forEach((t=>zt(t,"strides")));this.padding=i||"valid";checkPaddingMode(this.padding);this.dataFormat=a||"channelsLast";checkDataFormat(this.dataFormat);this.dilationRate=normalizeArray(r||1,2,"dilationRate");this.dilationRate.forEach((t=>zt(t,"dilationRate")))}build(e){var s;e=getExactlyOneShape(e);const n=this.dataFormat==="channelsFirst"?1:e.length-1;if(e[n]==null)throw new at(`The channel dimension of the input should be defined. Found ${e[n]}`);const i=e[n];const a=4;const r=this.kernelSize.concat([i,this.filters*a]);this.kernel=this.addWeight("kernel",r,null,this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);const o=this.kernelSize.concat([this.filters,this.filters*a]);this.recurrentKernel=this.addWeight("recurrent_kernel",o,null,this.recurrentInitializer,this.recurrentRegularizer,true,this.recurrentConstraint);if(this.useBias){let e;if(this.unitForgetBias){const n=this.biasInitializer;const i=this.filters;e=new(s=class CustomInit extends Initializer{apply(e,s){const a=n.apply([i]);const r=t.ones([i]);const o=n.apply([i*2]);return concatenate$2([a,r,o])}},s.className="CustomInit",s)}else e=this.biasInitializer;this.bias=this.addWeight("bias",[this.filters*a],null,e,this.biasRegularizer,true,this.biasConstraint)}this.built=true}call(e,s){return t.tidy((()=>{if(e.length!==3)throw new at(`ConvLSTM2DCell expects 3 input Tensors (inputs, h, c), got ${e.length}.`);const n=s.training||false;const i=e[0];const a=e[1];const r=e[2];const o=4;0<this.dropout&&this.dropout<1&&this.dropoutMask==null&&(this.dropoutMask=generateDropoutMask({ones:()=>t.onesLike(i),rate:this.dropout,training:n,count:o,dropoutFunc:this.dropoutFunc}));const l=this.dropoutMask;const applyDropout=(e,s,n)=>s&&s[n]?t.mul(s[n],e):e;let u=applyDropout(i,l,0);let h=applyDropout(i,l,1);let c=applyDropout(i,l,2);let p=applyDropout(i,l,3);0<this.recurrentDropout&&this.recurrentDropout<1&&this.recurrentDropoutMask==null&&(this.recurrentDropoutMask=generateDropoutMask({ones:()=>t.onesLike(a),rate:this.recurrentDropout,training:n,count:o,dropoutFunc:this.dropoutFunc}));const d=this.recurrentDropoutMask;let g=applyDropout(a,d,0);let m=applyDropout(a,d,1);let f=applyDropout(a,d,2);let y=applyDropout(a,d,3);const b=3;const[w,S,C,z]=t.split(this.kernel.read(),o,b);const[N,k,v,A]=this.useBias?t.split(this.bias.read(),o):[null,null,null,null];u=this.inputConv(u,w,N,this.padding);h=this.inputConv(h,S,k,this.padding);c=this.inputConv(c,C,v,this.padding);p=this.inputConv(p,z,A,this.padding);const[x,I,L,D]=t.split(this.recurrentKernel.read(),o,b);g=this.recurrentConv(g,x);m=this.recurrentConv(m,I);f=this.recurrentConv(f,L);y=this.recurrentConv(y,D);const T=this.recurrentActivation.apply(t.add(u,g));const E=this.recurrentActivation.apply(t.add(h,m));const R=t.add(t.mul(E,r),t.mul(T,this.activation.apply(t.add(c,f))));const $=t.mul(this.recurrentActivation.apply(t.add(p,y)),this.activation.apply(R));return[$,$,R]}))}getConfig(){const t=super.getConfig(),{units:e}=t,s=be(t,["units"]);const n={filters:this.filters,kernelSize:this.kernelSize,padding:this.padding,dataFormat:this.dataFormat,dilationRate:this.dilationRate,strides:this.strides};return Object.assign(Object.assign({},s),n)}inputConv(e,s,n,i){const a=t.conv2d(e,s,this.strides,i||"valid",this.dataFormat==="channelsFirst"?"NCHW":"NHWC",this.dilationRate);return n?biasAdd(a,n,this.dataFormat):a}recurrentConv(e,s){const n=1;return t.conv2d(e,s,n,"same",this.dataFormat==="channelsFirst"?"NCHW":"NHWC")}}ConvLSTM2DCell.className="ConvLSTM2DCell";t.serialization.registerClass(ConvLSTM2DCell);class ConvLSTM2D extends ConvRNN2D{constructor(t){const e=new ConvLSTM2DCell(t);super(Object.assign(Object.assign({},t),{cell:e}))}static fromConfig(t,e){return new t(e)}}ConvLSTM2D.className="ConvLSTM2D";t.serialization.registerClass(ConvLSTM2D);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class Dropout extends Layer{constructor(t){super(t);this.rate=Math.max(Math.min(t.rate,1),0);this.noiseShape=t.noiseShape;this.seed=t.seed;this.supportsMasking=true}getNoiseShape(t){if(this.noiseShape==null)return this.noiseShape;const e=t.shape;const s=[];for(let t=0;t<this.noiseShape.length;++t)s.push(this.noiseShape[t]==null?e[t]:this.noiseShape[t]);return s}call(t,e){return s((()=>{this.invokeCallHook(t,e);const s=getExactlyOneTensor(t);if(0<this.rate&&this.rate<1){const t=e.training!=null&&e.training;const n=this.getNoiseShape(s);const i=inTrainPhase((()=>dropout$1(s,this.rate,n,this.seed)),(()=>s),t);return i}return t}))}getConfig(){const t={rate:this.rate,noiseShape:this.noiseShape,seed:this.seed};const e=super.getConfig();Object.assign(t,e);return t}dispose(){return super.dispose()}}Dropout.className="Dropout";l.registerClass(Dropout);class SpatialDropout1D extends Dropout{constructor(t){super(t);this.inputSpec=[{ndim:3}]}getNoiseShape(t){const e=t.shape;return[e[0],1,e[2]]}}SpatialDropout1D.className="SpatialDropout1D";l.registerClass(SpatialDropout1D);class Dense extends Layer{constructor(t){super(t);this.activation=null;this.useBias=true;this.kernel=null;this.bias=null;this.DEFAULT_KERNEL_INITIALIZER="glorotNormal";this.DEFAULT_BIAS_INITIALIZER="zeros";if(t.batchInputShape==null&&t.inputShape==null&&t.inputDim!=null){let e=null;t.batchSize!=null&&(e=t.batchSize);this.batchInputShape=[e,t.inputDim]}this.units=t.units;zt(this.units,"units");this.activation=getActivation(t.activation);t.useBias!=null&&(this.useBias=t.useBias);this.kernelInitializer=getInitializer(t.kernelInitializer||this.DEFAULT_KERNEL_INITIALIZER);this.biasInitializer=getInitializer(t.biasInitializer||this.DEFAULT_BIAS_INITIALIZER);this.kernelConstraint=getConstraint(t.kernelConstraint);this.biasConstraint=getConstraint(t.biasConstraint);this.kernelRegularizer=getRegularizer(t.kernelRegularizer);this.biasRegularizer=getRegularizer(t.biasRegularizer);this.activityRegularizer=getRegularizer(t.activityRegularizer);this.supportsMasking=true;this.inputSpec=[{minNDim:2}]}build(t){t=getExactlyOneShape(t);const e=t[t.length-1];if(this.kernel==null){this.kernel=this.addWeight("kernel",[e,this.units],null,this.kernelInitializer,this.kernelRegularizer,true,this.kernelConstraint);this.useBias&&(this.bias=this.addWeight("bias",[this.units],null,this.biasInitializer,this.biasRegularizer,true,this.biasConstraint))}this.inputSpec=[{minNDim:2,axes:{[-1]:e}}];this.built=true}computeOutputShape(t){t=getExactlyOneShape(t);const e=t.slice();e[e.length-1]=this.units;return e}call(t,e){return s((()=>{this.invokeCallHook(t,e);const s=getExactlyOneTensor(t);const n=kt(this.activation.getClassName());let i;if(n!=null)i=dot$1(s,this.kernel.read(),n,this.bias?this.bias.read():null);else{i=dot$1(s,this.kernel.read());this.bias!=null&&(i=biasAdd(i,this.bias.read()));this.activation!=null&&(i=this.activation.apply(i))}return i}))}getConfig(){const t={units:this.units,activation:serializeActivation(this.activation),useBias:this.useBias,kernelInitializer:serializeInitializer(this.kernelInitializer),biasInitializer:serializeInitializer(this.biasInitializer),kernelRegularizer:serializeRegularizer(this.kernelRegularizer),biasRegularizer:serializeRegularizer(this.biasRegularizer),activityRegularizer:serializeRegularizer(this.activityRegularizer),kernelConstraint:serializeConstraint(this.kernelConstraint),biasConstraint:serializeConstraint(this.biasConstraint)};const e=super.getConfig();Object.assign(t,e);return t}}Dense.className="Dense";l.registerClass(Dense);class Flatten extends Layer{constructor(t){t=t||{};super(t);this.inputSpec=[{minNDim:3}];this.dataFormat=t.dataFormat}computeOutputShape(t){t=getExactlyOneShape(t);for(const e of t.slice(1))if(e==null)throw new at(`The shape of the input to "Flatten" is not fully defined (got ${t.slice(1)}). Make sure to pass a complete "input_shape" or "batch_input_shape" argument to the first layer in your model.`);return[t[0],arrayProd(t,1)]}call(t,e){return s((()=>{this.invokeCallHook(t,e);let s=getExactlyOneTensor(t);if(this.dataFormat==="channelsFirst"&&s.rank>1){const t=[0];for(let e=2;e<s.rank;++e)t.push(e);t.push(1);s=j(s,t)}return batchFlatten(s)}))}getConfig(){const t={};this.dataFormat!=null&&(t.dataFormat=this.dataFormat);const e=super.getConfig();Object.assign(t,e);return t}}Flatten.className="Flatten";l.registerClass(Flatten);class Activation extends Layer{constructor(t){super(t);this.supportsMasking=true;this.activation=getActivation(t.activation)}call(t,e){return s((()=>{this.invokeCallHook(t,e);const s=getExactlyOneTensor(t);return this.activation.apply(s)}))}getConfig(){const t={activation:serializeActivation(this.activation)};const e=super.getConfig();Object.assign(t,e);return t}}Activation.className="Activation";l.registerClass(Activation);class RepeatVector extends Layer{constructor(t){super(t);this.n=t.n;this.inputSpec=[{ndim:2}]}computeOutputShape(t){return[t[0],this.n,t[1]]}call(t,e){return s((()=>{t=getExactlyOneTensor(t);return repeat(t,this.n)}))}getConfig(){const t={n:this.n};const e=super.getConfig();Object.assign(t,e);return t}}RepeatVector.className="RepeatVector";l.registerClass(RepeatVector);class Reshape extends Layer{constructor(t){super(t);this.targetShape=t.targetShape;for(let t=0;t<this.targetShape.length;++t)this.isUnknown(this.targetShape[t])&&(this.targetShape[t]=null)}isUnknown(t){return t<0||t==null}
/**
     * Finds and replaces a missing dimension in output shape.
     *
     * This is a near direct port of the internal Numpy function
     * `_fix_unknown_dimension` in `numpy/core/src/multiarray/shape.c`.
     *
     * @param inputShape: Original shape of array begin reshape.
     * @param outputShape: Target shape of the array, with at most a single
     * `null` or negative number, which indicates an underdetermined dimension
     * that should be derived from `inputShape` and the known dimensions of
     *   `outputShape`.
     * @returns: The output shape with `null` replaced with its computed value.
     * @throws: ValueError: If `inputShape` and `outputShape` do not match.
     */fixUnknownDimension(t,e){const s="Total size of new array must be unchanged.";const n=e.slice();let i=1;let a=null;for(let t=0;t<n.length;++t){const e=n[t];if(this.isUnknown(e)){if(a!==null)throw new at("Can only specifiy one unknown dimension.");a=t}else i*=e}const r=arrayProd(t);if(a!==null){if(i===0||r%i!==0)throw new at(s);n[a]=r/i}else if(r!==i)throw new at(s);return n}computeOutputShape(t){let e=false;for(let s=0;s<t.length;++s)if(this.isUnknown(t[s])){e=true;break}return e?t.slice(0,1).concat(this.targetShape):t.slice(0,1).concat(this.fixUnknownDimension(t.slice(1),this.targetShape))}call(t,e){return s((()=>{this.invokeCallHook(t,e);const s=getExactlyOneTensor(t);const n=s.shape;const i=n.slice(0,1).concat(this.fixUnknownDimension(n.slice(1),this.targetShape));return L(s,i)}))}getConfig(){const t={targetShape:this.targetShape};const e=super.getConfig();Object.assign(t,e);return t}}Reshape.className="Reshape";l.registerClass(Reshape);class Permute extends Layer{constructor(t){super(t);if(t.dims==null)throw new Error("Required configuration field `dims` is missing during Permute constructor call.");if(!Array.isArray(t.dims))throw new Error(`Permute constructor requires \`dims\` to be an Array, but received ${t.dims} instead.`);const e=range(1,t.dims.length+1);if(!m.arraysEqual(t.dims.slice().sort(),e))throw new Error("Invalid permutation `dims`: "+JSON.stringify(t.dims)+" `dims` must contain consecutive integers starting from 1.");this.dims=t.dims;this.dimsIncludingBatch=[0].concat(this.dims);this.inputSpec=[new InputSpec({ndim:this.dims.length+1})]}computeOutputShape(t){t=getExactlyOneShape(t);const e=t.slice();this.dims.forEach(((s,n)=>{e[n+1]=t[s]}));return e}call(t,e){return j(getExactlyOneTensor(t),this.dimsIncludingBatch)}getConfig(){const t={dims:this.dims};const e=super.getConfig();Object.assign(t,e);return t}}Permute.className="Permute";l.registerClass(Permute);class Masking extends Layer{constructor(t){super(t==null?{}:t);this.supportsMasking=true;this.maskValue=t!=null?t.maskValue==null?0:t.maskValue:0}computeOutputShape(t){return t}getConfig(){const t=super.getConfig();const e={maskValue:this.maskValue};Object.assign(e,t);return e}computeMask(t,e){const s=getExactlyOneTensor(t);const n=-1;return G(q(s,this.maskValue),n)}call(t,e){return s((()=>{this.invokeCallHook(t,e);const s=getExactlyOneTensor(t);const n=-1;const i=true;const a=G(q(s,this.maskValue),n,i);const r=c(s,b(a,s.dtype));return r}))}}Masking.className="Masking";l.registerClass(Masking);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class Embedding extends Layer{constructor(t){super(t);this.embeddings=null;this.DEFAULT_EMBEDDINGS_INITIALIZER="randomUniform";if(t.batchInputShape==null&&t.inputShape==null){let e=null;t.batchSize!=null&&(e=t.batchSize);t.inputLength==null?this.batchInputShape=[e,null]:this.batchInputShape=[e].concat(dt(t.inputLength))}this.inputDim=t.inputDim;zt(this.inputDim,"inputDim");this.outputDim=t.outputDim;zt(this.outputDim,"outputDim");this.embeddingsInitializer=getInitializer(t.embeddingsInitializer||this.DEFAULT_EMBEDDINGS_INITIALIZER);this.embeddingsRegularizer=getRegularizer(t.embeddingsRegularizer);this.activityRegularizer=getRegularizer(t.activityRegularizer);this.embeddingsConstraint=getConstraint(t.embeddingsConstraint);this.maskZero=t.maskZero;this.supportsMasking=t.maskZero;this.inputLength=t.inputLength}build(t){this.embeddings=this.addWeight("embeddings",[this.inputDim,this.outputDim],this.dtype,this.embeddingsInitializer,this.embeddingsRegularizer,true,this.embeddingsConstraint);this.built=true}warnOnIncompatibleInputShape(t){}computeMask(t,e){return s((()=>{if(this.maskZero){t=getExactlyOneTensor(t);return q(t,n(t))}return null}))}computeOutputShape(t){t=getExactlyOneShape(t);if(this.inputLength==null)return[...t,this.outputDim];const e=dt(this.inputLength);if(e.length!==t.length-1)throw new at(`"inputLength" is ${this.inputLength}, but received input shape has shape ${t}`);{let s=0;for(let n=0;n<e.length;++n){const i=e[n];const a=t[n+1];if(i!=null&&a!=null&&i!==a)throw new at(`"inputLength" is ${this.inputLength}, but received input shape has shape ${t}`);i==null&&(e[s]=a);s++}}return[t[0],...e,this.outputDim]}call(t,e){return s((()=>{this.invokeCallHook(t,e);let s=getExactlyOneTensor(t);s.dtype!=="int32"&&(s=cast(s,"int32"));const n=gather(this.embeddings.read(),L(s,[s.size]));return L(n,getExactlyOneShape(this.computeOutputShape(s.shape)))}))}getConfig(){const t={inputDim:this.inputDim,outputDim:this.outputDim,embeddingsInitializer:serializeInitializer(this.embeddingsInitializer),embeddingsRegularizer:serializeRegularizer(this.embeddingsRegularizer),activityRegularizer:serializeRegularizer(this.activityRegularizer),embeddingsConstraint:serializeConstraint(this.embeddingsConstraint),maskZero:this.maskZero,inputLength:this.inputLength};const e=super.getConfig();Object.assign(t,e);return t}}Embedding.className="Embedding";l.registerClass(Embedding);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class Merge extends Layer{constructor(t){super(t||{});this.supportsMasking=true}
/**
     * Logic for merging multiple tensors, to be overridden by subclasses.
     * @param inputs
     */mergeFunction(t){throw new rt}
/**
     * Computes the shape of the result of an elementwise operation.
     *
     * @param shape1: Shape of the first tensor.
     * @param shape2: Shape of the second tensor.
     * @returns Expected output shape when an elementwise operation is carried
     *   out on 2 tensors with shapes `shape1` and `shape2`.
     * @throws ValueError: If `shape1` and `shape2` are not compatible for
     *   element-wise operations.
     */computeElementwiseOpOutputShape(t,e){if(t==null||e==null)return null;if(t.length<e.length)return this.computeElementwiseOpOutputShape(e,t);if(e.length===0)return t;const s=t.slice(0,t.length-e.length);for(let n=0;n<e.length;++n){const i=t[t.length-e.length+n];const a=e[n];if(i==null||a==null||i<0||a<0)s.push(null);else if(i===1)s.push(a);else if(a===1)s.push(i);else{if(i!==a)throw new at("Operands could not be broadcast together with shapes "+JSON.stringify(t)+" "+JSON.stringify(e));s.push(i)}}return s}build(t){Array.isArray(t)&&!Array.isArray(t[0])&&(t=[getExactlyOneShape(t)]);t;if(t.length<2)throw new at(`A merge layer should be called on an Array of at least 2 inputs. Got ${t.length} input(s).`);let e=[];for(const s of t)s!=null&&s[0]!==null&&e.push(s[0]);e=ft(e);if(e.length>1)throw new at(`Can not merge tensors with different batch sizes. Got tensors with shapes: ${JSON.stringify(t)}.`);let s=t[0]==null?null:t[0].slice(1);for(let e=1;e<t.length;++e){const n=t[e]==null?null:t[e].slice(1);s=this.computeElementwiseOpOutputShape(s,n)}const n=t.map((t=>t.length));t.indexOf(null)===-1&&ft(n).length===1?this.reshapeRequired=false:this.reshapeRequired=true}call(e,n){return s((()=>{e;if(this.reshapeRequired){const s=[];const n=e.map((t=>t.rank));if(n.indexOf(null)===-1){const t=max(n);for(let n of e){const e=n.rank;for(let s=0;s<t-e;++s)n=expandDims(n,1);s.push(n)}return this.mergeFunction(s)}{let n=false;for(const i of e){const e=i.rank;if(e==null){const e=i.shape;const a=e[0];const r=e.slice(1).concat([a]);let o=t.reshape(i,[a].concat(arrayProd(e.slice(1))));o=t.transpose(o,[1,0]);o=t.reshape(o,r);s.push(o);n=true}else if(e>1){const a=range(1,e).concat([0]);s.push(t.transpose(i,a));n=true}else s.push(i)}let i=this.mergeFunction(s);const a=i.rank;if(n)if(a==null){const e=i.shape;const s=e.length;const n=e[s-1];const a=[n].concat(e.slice(0,e.length-1));i=t.reshape(t.transpose(t.reshape(i,[-1,n]),[1,0]),a)}else if(a>1){const e=[a-1].concat(range(0,a-1));i=t.transpose(i,e)}return i}}return this.mergeFunction(e)}))}computeOutputShape(t){t;let e;e=t[0]==null?null:t[0].slice(1);for(let s=1;s<t.length;++s){const n=t[s]==null?null:t[s].slice(1);e=this.computeElementwiseOpOutputShape(e,n)}let s=[];for(const e of t)e!=null&&e[0]!==null&&s.push(e[0]);s=ft(s);e=s.length===1?s.concat(e):[null].concat(e);return e}computeMask(e,s){return t.tidy((()=>{if(s==null)return null;if(!Array.isArray(s))throw new at("`mask` should be an Array");if(!Array.isArray(e))throw new at("`inputs` should be an Array");if(s.length!==e.length)throw new at(`The Array 'inputs' and 'mask' are expected to have the same length, but have different lengths (${e.length} vs ${s.length})`);if(s.every((t=>t==null)))return null;s=s.map((e=>e==null?e:t.expandDims(e,0)));let n=s[0];for(let e=1;e<s.length-1;++e)n=t.logicalAnd(n,s[e]);return n}))}}class Add extends Merge{constructor(t){super(t)}mergeFunction(e){return s((()=>{let s=e[0].clone();for(let n=1;n<e.length;++n)s=t.add(s,e[n]);return s}))}}Add.className="Add";l.registerClass(Add);class Multiply extends Merge{constructor(t){super(t)}mergeFunction(e){return s((()=>{let s=e[0].clone();for(let n=1;n<e.length;++n)s=t.mul(s,e[n]);return s}))}}Multiply.className="Multiply";l.registerClass(Multiply);class Average extends Merge{constructor(t){super(t)}mergeFunction(e){return s((()=>{let s=e[0].clone();for(let n=1;n<e.length;++n)s=t.add(s,e[n]);return t.mul(1/e.length,s)}))}}Average.className="Average";l.registerClass(Average);class Maximum extends Merge{constructor(t){super(t)}mergeFunction(e){return s((()=>{let s=e[0];for(let n=1;n<e.length;++n)s=t.maximum(s,e[n]);return s}))}}Maximum.className="Maximum";l.registerClass(Maximum);class Minimum extends Merge{constructor(t){super(t)}mergeFunction(e){return s((()=>{let s=e[0];for(let n=1;n<e.length;++n)s=t.minimum(s,e[n]);return s}))}}Minimum.className="Minimum";l.registerClass(Minimum);class Concatenate extends Merge{constructor(t){super(t);this.DEFAULT_AXIS=-1;t==null&&(t={});this.axis=t.axis==null?this.DEFAULT_AXIS:t.axis;this.supportsMasking=true;this.reshapeRequired=false}build(t){if(!(Array.isArray(t)&&Array.isArray(t[0]))||t.length===1)throw new at("A `Concatenate` layer should be called on a list of at least 2 inputs");t;let e=true;for(const s of t)if(s!=null){e=false;break}if(e)return;const s=[];for(let e=0;e<t.length;++e){const n=t[e].slice();n.splice(this.axis,1);let i=false;for(const t of s)if(m.arraysEqual(t,n)){i=true;break}i||s.push(n)}if(s.length>1)throw new at("A `Concatenate` layer requires inputs with matching shapes except for the concat axis. Got input shapes: "+JSON.stringify(t))}mergeFunction(t){return s((()=>concatenate$2(t,this.axis)))}computeOutputShape(t){if(!(Array.isArray(t)&&Array.isArray(t[0])))throw new at("A `Concatenate` layer should be called on a list of inputs.");const e=t;const s=e[0].slice();const n=this.axis<0?s.length+this.axis:this.axis;for(const t of e.slice(1)){if(s[n]==null||t[n]==null){s[n]=null;break}s[n]+=t[n]}return s}computeMask(e,s){if(s==null)return null;if(!Array.isArray(s))throw new at("`mask` should be an array for Concatenate");if(!Array.isArray(e))throw new at("`inputs` should be an array for Concatenate");if(s.length!==e.length)throw new at(`Mismatch in the length of mask (${s.length}) and the legnth of inputs (${e.length})`);return t.tidy((()=>{let n=true;s.forEach((t=>{t==null||(n=false)}));if(n)return null;const i=[];for(let n=0;n<e.length;++n)s[n]==null?i.push(t.cast(t.onesLike(e[n]),"bool")):s[n].rank<e[n].rank?i.push(t.expandDims(s[n],-1)):i.push(s[n]);const a=t.concat(i,this.axis);return t.all(a,-1,false)}))}getConfig(){const t={axis:this.axis};const e=super.getConfig();Object.assign(t,e);return t}}Concatenate.className="Concatenate";l.registerClass(Concatenate);
/**
 * Interpretable potentially negative axis index.
 *
 * For example, given axis = -1, and dim = 3, this function will return 2.
 *
 * @param axis The axis index, may be a positive, zero or negative integer.
 * @param dim Total number of dimensions, a positive integer.
 * @returns A non-negative axis index equivalent to the input `axis`.
 */
function interpretAxis(t,e){while(t<0)t+=e;return t}function batchDot(e,s,n){if(e.shape.length>3||s.shape.length>3)throw new rt("batchDot is not implemented for tensors of 4D or higher rank yet");t.util.assert(e.shape.length>=2,(()=>`batchDot requires the rank of x to be >= 2, but got ${e.shape.length}`));t.util.assert(e.shape.length>=2,(()=>`batchDot requires the rank of y to be >= 2, but got ${s.shape.length}`));typeof n==="number"&&(n=[n,n]);if(e.dtype==="complex64"||s.dtype==="complex64")throw new rt("batchDot is not implemented for complex64-type Tensors yet.");const i=e.shape.length;const a=s.shape.length;n==null&&(n=[i-1,a-2]);const r=n;return t.tidy((()=>{let n;if(i>a){n=i-a;const e=[];for(let t=0;t<n;++t)e.push(1);s=t.reshape(s,s.shape.concat(e))}else if(a>i){n=a-i;const s=[];for(let t=0;t<n;++t)s.push(1);e=t.reshape(e,e.shape.concat(s))}else n=0;let o;if(e.shape.length===2&&s.shape.length===2)o=r[0]===r[1]?t.sum(t.mul(e,s),r[0]):t.sum(t.mul(t.transpose(e,[1,0]),s),r[1]);else{const n=r[0]!==e.shape.length-1;const i=r[1]===s.shape.length-1;o=t.matMul(e,s,n,i)}if(n>0){let e;e=i>a?i+a-3:i-1;const s=[];for(let t=e;t<e+n;++t)s.push(t);o=t.squeeze(o,s)}o.shape.length===1&&(o=t.expandDims(o,1));return o}))}class Dot extends Merge{constructor(t){super(t);this.axes=t.axes;this.normalize=t.normalize!=null&&t.normalize;this.supportsMasking=true;this.reshapeRequired=false}build(e){t.util.assert(Array.isArray(e)&&e.length===2&&Array.isArray(e[0])&&Array.isArray(e[1]),(()=>"A `Dot` layer should be called on a list of exactly 2 inputs."));const s=e[0];const n=e[1];if(s.length>3||n.length>3)throw new rt("Dot layer does not support tensors of 4D or higher rank yet.");const i=this.interpretAxes(s,n);if(s[i[0]]!==n[i[1]])throw new at(`Dimension incompatibility: ${s[i[0]]} !== ${n[i[1]]}`)}mergeFunction(t){if(t.length!==2)throw new at(`A \`Dot\` layer must be called on exactly 2 inputs, but received ${t.length} input(s).`);let e=t[0];let s=t[1];let n;n=Array.isArray(this.axes)?this.axes.map(((e,s)=>interpretAxis(e,t[s].shape.length))):[interpretAxis(this.axes,e.shape.length),interpretAxis(this.axes,s.shape.length)];if(this.normalize){e=l2Normalize(e,n[0]);s=l2Normalize(s,n[1])}return batchDot(e,s,n)}interpretAxes(t,e){let s;s=Array.isArray(this.axes)?this.axes:[interpretAxis(this.axes,t.length),interpretAxis(this.axes,e.length)];return s}computeOutputShape(e){t.util.assert(Array.isArray(e)&&e.length===2&&Array.isArray(e[0])&&Array.isArray(e[1]),(()=>"A `Dot` layer should be called on a list of exactly 2 inputs."));const s=e[0].slice();const n=e[1].slice();if(s.length>3||n.length>3)throw new rt("Dot layer does not support tensors of 4D or higher rank yet.");const i=this.interpretAxes(s,n);s.splice(i[0],1);n.splice(i[1],1);n.splice(0,1);const a=s.concat(n);a.length===1&&a.push(1);return a}computeMask(t,e){return null}getConfig(){const t={axes:this.axes,normalize:this.normalize};const e=super.getConfig();Object.assign(t,e);return t}}Dot.className="Dot";l.registerClass(Dot);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class GaussianNoise extends Layer{constructor(t){super(t);this.supportsMasking=true;this.stddev=t.stddev}computeOutputShape(t){return t}getConfig(){const t=super.getConfig();const e={stddev:this.stddev};Object.assign(e,t);return e}call(t,e){return s((()=>{this.invokeCallHook(t,e);const s=getExactlyOneTensor(t);const noised=()=>z(randomNormal$1(s.shape,0,this.stddev),s);const n=inTrainPhase(noised,(()=>s),e.training||false);return n}))}}GaussianNoise.className="GaussianNoise";l.registerClass(GaussianNoise);class GaussianDropout extends Layer{constructor(t){super(t);this.supportsMasking=true;this.rate=t.rate}computeOutputShape(t){return t}getConfig(){const t=super.getConfig();const e={rate:this.rate};Object.assign(e,t);return e}call(t,e){return s((()=>{this.invokeCallHook(t,e);const s=getExactlyOneTensor(t);if(this.rate>0&&this.rate<1){const noised=()=>{const t=Math.sqrt(this.rate/(1-this.rate));return c(s,randomNormal$1(s.shape,1,t))};return inTrainPhase(noised,(()=>s),e.training||false)}return s}))}}GaussianDropout.className="GaussianDropout";l.registerClass(GaussianDropout);class AlphaDropout extends Layer{constructor(t){super(t);this.supportsMasking=true;this.rate=t.rate;this.noiseShape=t.noiseShape}_getNoiseShape(t){return this.noiseShape||getExactlyOneTensor(t).shape}computeOutputShape(t){return t}getConfig(){const t=super.getConfig();const e={rate:this.rate};Object.assign(e,t);return e}call(t,e){return s((()=>{if(this.rate<1&&this.rate>0){const s=this._getNoiseShape(t);const droppedInputs=()=>{const e=getExactlyOneTensor(t);const n=1.6732632423543772;const i=1.0507009873554805;const a=-n*i;let r=H(p(s),this.rate);r=cast(r,"float32");const o=((1-this.rate)*(1+this.rate*a**2))**-.5;const l=-o*a*this.rate;const u=z(c(e,r),c(z(r,-1),a));return z(c(u,o),l)};return inTrainPhase(droppedInputs,(()=>getExactlyOneTensor(t)),e.training||false)}return t}))}}AlphaDropout.className="AlphaDropout";l.registerClass(AlphaDropout);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Applies batch normalization on x given mean, var, beta and gamma.
 *
 * I.e. returns:
 *   `output = (x - mean) / (sqrt(var) + epsilon) * gamma + beta`
 *
 * @param x Input tensor.
 * @param mean Mean of batch.
 * @param variance Variance of batch.
 * @param beta Tensor with which to center the input.
 * @param gamma Tensor by which to scale the input.
 * @param epsilon Fuzz factor.
 * @returns The result of the batch normalization.
 */function batchNormalization$1(e,s,n,i,a,r=.001){let o;if(e.rank===2)o=t.batchNorm2d(e,s,n,i,a,r);else if(e.rank===3)o=t.batchNorm3d(e,s,n,i,a,r);else{if(e.rank!==4)throw new rt(`batchNormalization is not implemented for array of rank ${e.rank} yet`);o=t.batchNorm4d(e,s,n,i,a,r)}return o}
/**
 * Non-broadcasting batch normalization for use in training (not inference).
 *
 * The input is normalized to zero mean and unit variance along the
 * `reductionAxes`, followed by scaling with `gamma` and shifted by `beta`.
 * The result of that is returned as the first element
 * of the returned `Array`. The other two elements are the mean and variance,
 * respectively.
 *
 * @param x Input tensor to be normalized.
 * @param gamma Tensor by which to scale the input.
 * @param beta Tensor by which to center the input.
 * @param reductionAxes Axes over which to normalize.
 * @param epsilon Fuzz factor.
 * @returns An `Array` of three `Tensors`:
 *   [normalized tensor, mean of input, variance of input].
 */function regularNormalizeBatchInTraining(e,n,i,a,r=.001){return s((()=>{const s=t.moments(e,a);const o=s.mean;const l=s.variance;const u=batchNormalization$1(e,o,l,i,n,r);return[u,o,l]}))}
/**
 * Broadcasting batch normalization for use in training (not inference).
 *
 * The input is normalized to zero mean and unit variance along the
 * `reductionAxes`, followed by scaling with `gamma` and shifted by `beta`.
 * The result of that is returned as the first element
 * of the returned `Array`. The other two elements are the mean and variance,
 * respectively.
 *
 * @param x Input tensor to be normalized.
 * @param gamma Tensor by which to scale the input.
 * @param beta Tensor by which to center the input.
 * @param reductionAxes Axes over which to normalize.
 * @param epsilon Fuzz factor.
 * @returns An `Array` of three `Tensors`:
 *   [normalized tensor, mean of input, variance of input].
 */function broadcastNormalizeBatchInTraining(e,n,i,a,r=.001){return s((()=>{const s=t.moments(e,a);const o=s.mean;const l=s.variance;const u=[];for(const t of range(0,e.rank))a.indexOf(t)!==-1?u.push(1):u.push(e.shape[t]);const h=L(o,u);const c=L(l,u);const p=n==null?null:L(n,u);const d=i==null?null:L(i,u);const g=batchNormalization$1(e,h,c,d,p,r);return[g,o,l]}))}
/**
 * Batch normalization for use in training (not inference).
 *
 * @param x Input tensor to be normalized.
 * @param gamma Tensor by which to scale the input.
 * @param beta Tensor by which to center the input.
 * @param reductionAxes Axes over which to normalize.
 * @param epsilon Fuzz factor.
 * @returns An `Array` of three `Tensors`:
 *   [normalized tensor, mean of input, variance of input].
 */function normalizeBatchInTraining(t,e,s,n,i=.001){return m.arraysEqual(n.slice().sort(),range(0,t.rank-1))?regularNormalizeBatchInTraining(t,e,s,n,i):broadcastNormalizeBatchInTraining(t,e,s,n,i)}class BatchNormalization extends Layer{constructor(t){t==null&&(t={});super(t);this.supportsMasking=true;this.axis=t.axis==null?-1:t.axis;this.momentum=t.momentum==null?.99:t.momentum;this.epsilon=t.epsilon==null?.001:t.epsilon;this.center=t.center==null||t.center;this.scale=t.scale==null||t.scale;this.betaInitializer=getInitializer(t.betaInitializer||"zeros");this.gammaInitializer=getInitializer(t.gammaInitializer||"ones");this.movingMeanInitializer=getInitializer(t.movingMeanInitializer||"zeros");this.movingVarianceInitializer=getInitializer(t.movingVarianceInitializer||"ones");this.betaConstraint=getConstraint(t.betaConstraint);this.gammaConstraint=getConstraint(t.gammaConstraint);this.betaRegularizer=getRegularizer(t.betaRegularizer);this.gammaRegularizer=getRegularizer(t.gammaRegularizer)}build(t){t=getExactlyOneShape(t);const e=this.axis>=0?this.axis:this.axis+t.length;const s=t[e];if(s==null)throw new at(`Axis ${e} of input tensor should have a defined dimension but the layer received an input with shape ${JSON.stringify(t)}.`);this.inputSpec=[new InputSpec({ndim:t.length,axes:{[e]:s}})];const n=[s];this.scale&&(this.gamma=this.addWeight("gamma",n,null,this.gammaInitializer,this.gammaRegularizer,true,this.gammaConstraint));this.center&&(this.beta=this.addWeight("beta",n,null,this.betaInitializer,this.betaRegularizer,true,this.betaConstraint));this.movingMean=this.addWeight("moving_mean",n,null,this.movingMeanInitializer,null,false);this.movingVariance=this.addWeight("moving_variance",n,null,this.movingVarianceInitializer,null,false);this.built=true}call(e,n){return s((()=>{const s=n.training!=null&&n.training;const i=getExactlyOneTensor(e);const a=i.shape;const r=a.length;const o=range(0,r);const l=this.axis>=0?this.axis:this.axis+r;o.splice(l,1);const u=bt(1,r);u[l]=a[l];const h=o.slice();h.sort();const c=!m.arraysEqual(h,range(0,r).slice(0,r-1));const normalizeInference=()=>{if(c){const t=L(this.movingMean.read(),u);const e=L(this.movingVariance.read(),u);const s=this.center?L(this.beta.read(),u):null;const n=this.scale?L(this.gamma.read(),u):null;return batchNormalization$1(i,t,e,s,n,this.epsilon)}return batchNormalization$1(i,this.movingMean.read(),this.movingVariance.read(),this.beta==null?null:this.beta.read(),this.gamma==null?null:this.gamma.read(),this.epsilon)};if(!s)return normalizeInference();const[p,d,g]=normalizeBatchInTraining(i,this.gamma.read(),this.beta.read(),o,this.epsilon);const doMovingAverage=(e,s,n)=>{t.tidy((()=>{const i=1-n;const a=e.read();const r=t.mul(t.sub(a,s),i);e.write(t.sub(a,r))}))};const updateMovingMeanAndVariance=()=>{doMovingAverage(this.movingMean,d,this.momentum);doMovingAverage(this.movingVariance,g,this.momentum)};updateMovingMeanAndVariance();return p}))}getConfig(){const t={axis:this.axis,momentum:this.momentum,epsilon:this.epsilon,center:this.center,scale:this.scale,betaInitializer:serializeInitializer(this.betaInitializer),gammaInitializer:serializeInitializer(this.gammaInitializer),movingMeanInitializer:serializeInitializer(this.movingMeanInitializer),movingVarianceInitializer:serializeInitializer(this.movingVarianceInitializer),betaRegularizer:serializeRegularizer(this.betaRegularizer),gammaRegularizer:serializeRegularizer(this.gammaRegularizer),betaConstraint:serializeConstraint(this.betaConstraint),gammaConstraint:serializeConstraint(this.gammaConstraint)};const e=super.getConfig();Object.assign(t,e);return t}}BatchNormalization.className="BatchNormalization";l.registerClass(BatchNormalization);class LayerNormalization extends Layer{constructor(t){t==null&&(t={});super(t);this.axis=t.axis==null?-1:t.axis;if(typeof this.axis==="number"){if(!Number.isInteger(this.axis))throw new Error(`Expected axis to be an integer, but received ${this.axis}`)}else{if(!Array.isArray(this.axis))throw new Error(`Expected axis to be an integer or an array of integers, but received ${JSON.stringify(this.axis)}`);for(const t of this.axis)if(!Number.isInteger(t))throw new Error(`Expected axis to be an array of integers, but received ${JSON.stringify(this.axis)}`)}this.epsilon=t.epsilon==null?.001:t.epsilon;this.center=t.center==null||t.center;this.scale=t.scale==null||t.scale;this.betaInitializer=getInitializer(t.betaInitializer||"zeros");this.gammaInitializer=getInitializer(t.gammaInitializer||"ones");this.betaRegularizer=getRegularizer(t.betaRegularizer);this.gammaRegularizer=getRegularizer(t.gammaRegularizer);this.supportsMasking=true}build(t){t=getExactlyOneShape(t);const e=t.length;typeof this.axis==="number"&&(this.axis=[this.axis]);for(let t=0;t<this.axis.length;++t)this.axis[t]<0&&(this.axis[t]+=e);for(const t of this.axis)if(t<0||t>=e)throw new Error(`Invalid axis: ${t}`);if(this.axis.length!==ft(this.axis).length)throw new Error(`Found duplicate axes in: ${this.axis}`);const s=this.axis.map((e=>t[e]));const n=true;this.scale?this.gamma=this.addWeight("gamma",s,"float32",this.gammaInitializer,this.gammaRegularizer,n):this.gamma=null;this.center?this.beta=this.addWeight("beta",s,"float32",this.betaInitializer,this.betaRegularizer,n):this.beta=null;this.built=true}call(e,n){const i=getExactlyOneTensor(e);const a=i.shape;const r=a.length;return s((()=>{const e=true;let{mean:s,variance:n}=J(i,this.axis,e);const o=bt(1,r);for(const t of this.axis)o[t]=a[t];const broadcast=e=>e!=null&&e.shape.length!==r?t.reshape(e,o):e;let l=this.scale?broadcast(this.gamma.read()):null;let u=this.center?broadcast(this.beta.read()):null;const h=[];const c=[];for(let t=0;t<r;++t)if(this.axis.indexOf(t)!==-1){h.push(a[t]);c.push(1)}else{h.push(1);c.push(a[t])}s=t.tile(s,h);n=t.tile(n,h);l!=null&&(l=t.tile(l,c));u!=null&&(u=t.tile(u,c));return batchNormalization$1(i,s,n,u,l,this.epsilon)}))}getConfig(){const t={axis:this.axis,epsilon:this.epsilon,center:this.center,scale:this.scale,betaInitializer:serializeInitializer(this.betaInitializer),gammaInitializer:serializeInitializer(this.gammaInitializer),betaRegularizer:serializeRegularizer(this.betaRegularizer),gammaRegularizer:serializeRegularizer(this.gammaRegularizer)};const e=super.getConfig();Object.assign(t,e);return t}}LayerNormalization.className="LayerNormalization";l.registerClass(LayerNormalization);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * Pads the middle dimension of a 3D tensor.
 *
 * @param x Input `tf.Tensor` to be padded.
 * @param padding `Array` of 2 integers, how many zeros to add at the start and
 *   end of the middle dimension (i.e., dimension 1).
 * @return A padded 3D `tf.Tensor`.
 */
/**
 * Pads the 2nd and 3rd dimensions of a 4D tensor.
 *
 * @param x Input `tf.Tensor` to be padded.
 * @param padding `Array` of two `Array`s, each of which is an `Array` of two
 *   integers. The amount of padding at the beginning and end of the 2nd and 3rd
 *   dimensions, respectively.
 * @param dataFormat 'channelsLast' (default) or 'channelsFirst'.
 * @return Padded 4D `tf.Tensor`.
 */
function spatial2dPadding(e,n,i){return s((()=>{if(e.rank!==4)throw new at(`temporalPadding expects input tensor to be 4-D, but received a ${e.rank}-D tensor.`);n==null&&(n=[[1,1],[1,1]]);if(n.length!==2||n[0].length!==2||n[1].length!==2)throw new at("spatial2dPadding expects `padding` to be an Array of two Arrays, each of which is an Array of two integers.");i==null&&(i=imageDataFormat());if(i!=="channelsLast"&&i!=="channelsFirst")throw new at(`Unknown data format: ${i}. Supported data formats are 'channelsLast' and 'channelsFirst.`);let s;s=i==="channelsFirst"?[[0,0],[0,0],n[0],n[1]]:[[0,0],n[0],n[1],[0,0]];return t.pad(e,s)}))}class ZeroPadding2D extends Layer{constructor(t){t==null&&(t={});super(t);this.dataFormat=t.dataFormat==null?imageDataFormat():t.dataFormat;if(t.padding==null)this.padding=[[1,1],[1,1]];else if(typeof t.padding==="number")this.padding=[[t.padding,t.padding],[t.padding,t.padding]];else{t.padding=t.padding;if(t.padding.length!==2)throw new at(`ZeroPadding2D expects padding to be a length-2 array, but received a length-${t.padding.length} array.`);let e;let s;if(typeof t.padding[0]==="number"){e=[t.padding[0],t.padding[0]];s=[t.padding[1],t.padding[1]]}else{t.padding=t.padding;if(t.padding[0].length!==2)throw new at(`ZeroPadding2D expects height padding to be a length-2 array, but received a length-${t.padding[0].length} array.`);e=t.padding[0];if(t.padding[1].length!==2)throw new at(`ZeroPadding2D expects width padding to be a length-2 array, but received a length-${t.padding[1].length} array.`);s=t.padding[1]}this.padding=[e,s]}this.inputSpec=[new InputSpec({ndim:4})]}computeOutputShape(t){t=getExactlyOneShape(t);let e;let s;if(this.dataFormat==="channelsFirst"){e=t[2]!=null&&t[2]>=0?t[2]+this.padding[0][0]+this.padding[0][1]:null;s=t[3]!=null&&t[3]>=0?t[3]+this.padding[1][0]+this.padding[1][1]:null;return[t[0],t[1],e,s]}e=t[1]!=null&&t[1]>=0?t[1]+this.padding[0][0]+this.padding[0][1]:null;s=t[2]!=null&&t[2]>=0?t[2]+this.padding[1][0]+this.padding[1][1]:null;return[t[0],e,s,t[3]]}call(t,e){return s((()=>spatial2dPadding(getExactlyOneTensor(t),this.padding,this.dataFormat)))}getConfig(){const t={padding:this.padding,dataFormat:this.dataFormat};const e=super.getConfig();Object.assign(t,e);return t}}ZeroPadding2D.className="ZeroPadding2D";l.registerClass(ZeroPadding2D);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */
/**
 * 2D pooling.
 * @param x
 * @param poolSize
 * @param strides strides. Defaults to [1, 1].
 * @param padding padding. Defaults to 'valid'.
 * @param dataFormat data format. Defaults to 'channelsLast'.
 * @param poolMode Mode of pooling. Defaults to 'max'.
 * @returns Result of the 2D pooling.
 */function pool2d(e,n,i,a,r,o){return s((()=>{checkDataFormat(r);checkPoolMode(o);checkPaddingMode(a);i==null&&(i=[1,1]);a==null&&(a="valid");r==null&&(r=imageDataFormat());o==null&&(o="max");e=preprocessConv2DInput(e,r);let s;const l=a==="same"?"same":"valid";s=o==="max"?t.maxPool(e,n,i,l):t.avgPool(e,n,i,l);r==="channelsFirst"&&(s=t.transpose(s,[0,3,1,2]));return s}))}
/**
 * 3D pooling.
 * @param x
 * @param poolSize. Default to [1, 1, 1].
 * @param strides strides. Defaults to [1, 1, 1].
 * @param padding padding. Defaults to 'valid'.
 * @param dataFormat data format. Defaults to 'channelsLast'.
 * @param poolMode Mode of pooling. Defaults to 'max'.
 * @returns Result of the 3D pooling.
 */function pool3d(e,n,i,a,r,o){return s((()=>{checkDataFormat(r);checkPoolMode(o);checkPaddingMode(a);i==null&&(i=[1,1,1]);a==null&&(a="valid");r==null&&(r=imageDataFormat());o==null&&(o="max");e=preprocessConv3DInput(e,r);let s;const l=a==="same"?"same":"valid";s=o==="max"?t.maxPool3d(e,n,i,l):t.avgPool3d(e,n,i,l);r==="channelsFirst"&&(s=t.transpose(s,[0,4,1,2,3]));return s}))}class Pooling1D extends Layer{
/**
     *
     * @param args Parameters for the Pooling layer.
     *
     * config.poolSize defaults to 2.
     */
constructor(t){t.poolSize==null&&(t.poolSize=2);super(t);if(typeof t.poolSize==="number")this.poolSize=[t.poolSize];else{if(!Array.isArray(t.poolSize)||t.poolSize.length!==1||typeof t.poolSize[0]!=="number")throw new at(`poolSize for 1D convolutional layer must be a number or an Array of a single number, but received ${JSON.stringify(t.poolSize)}`);this.poolSize=t.poolSize}zt(this.poolSize,"poolSize");if(t.strides==null)this.strides=this.poolSize;else if(typeof t.strides==="number")this.strides=[t.strides];else{if(!Array.isArray(t.strides)||t.strides.length!==1||typeof t.strides[0]!=="number")throw new at(`strides for 1D convolutional layer must be a number or an Array of a single number, but received ${JSON.stringify(t.strides)}`);this.strides=t.strides}zt(this.strides,"strides");this.padding=t.padding==null?"valid":t.padding;checkPaddingMode(this.padding);this.inputSpec=[new InputSpec({ndim:3})]}computeOutputShape(t){t=getExactlyOneShape(t);const e=convOutputLength(t[1],this.poolSize[0],this.padding,this.strides[0]);return[t[0],e,t[2]]}call(e,n){return s((()=>{this.invokeCallHook(e,n);e=expandDims(getExactlyOneTensor(e),2);const s=this.poolingFunction(getExactlyOneTensor(e),[this.poolSize[0],1],[this.strides[0],1],this.padding,"channelsLast");return t.squeeze(s,[2])}))}getConfig(){const t={poolSize:this.poolSize,padding:this.padding,strides:this.strides};const e=super.getConfig();Object.assign(t,e);return t}}class MaxPooling1D extends Pooling1D{constructor(t){super(t)}poolingFunction(t,e,s,n,i){checkDataFormat(i);checkPaddingMode(n);return pool2d(t,e,s,n,i,"max")}}MaxPooling1D.className="MaxPooling1D";l.registerClass(MaxPooling1D);class AveragePooling1D extends Pooling1D{constructor(t){super(t)}poolingFunction(t,e,s,n,i){checkDataFormat(i);checkPaddingMode(n);return pool2d(t,e,s,n,i,"avg")}}AveragePooling1D.className="AveragePooling1D";l.registerClass(AveragePooling1D);class Pooling2D extends Layer{constructor(t){t.poolSize==null&&(t.poolSize=[2,2]);super(t);this.poolSize=Array.isArray(t.poolSize)?t.poolSize:[t.poolSize,t.poolSize];if(t.strides==null)this.strides=this.poolSize;else if(Array.isArray(t.strides)){if(t.strides.length!==2)throw new at(`If the strides property of a 2D pooling layer is an Array, it is expected to have a length of 2, but received length ${t.strides.length}.`);this.strides=t.strides}else this.strides=[t.strides,t.strides];zt(this.poolSize,"poolSize");zt(this.strides,"strides");this.padding=t.padding==null?"valid":t.padding;this.dataFormat=t.dataFormat==null?"channelsLast":t.dataFormat;checkDataFormat(this.dataFormat);checkPaddingMode(this.padding);this.inputSpec=[new InputSpec({ndim:4})]}computeOutputShape(t){t=getExactlyOneShape(t);let e=this.dataFormat==="channelsFirst"?t[2]:t[1];let s=this.dataFormat==="channelsFirst"?t[3]:t[2];e=convOutputLength(e,this.poolSize[0],this.padding,this.strides[0]);s=convOutputLength(s,this.poolSize[1],this.padding,this.strides[1]);return this.dataFormat==="channelsFirst"?[t[0],t[1],e,s]:[t[0],e,s,t[3]]}call(t,e){return s((()=>{this.invokeCallHook(t,e);return this.poolingFunction(getExactlyOneTensor(t),this.poolSize,this.strides,this.padding,this.dataFormat)}))}getConfig(){const t={poolSize:this.poolSize,padding:this.padding,strides:this.strides,dataFormat:this.dataFormat};const e=super.getConfig();Object.assign(t,e);return t}}class MaxPooling2D extends Pooling2D{constructor(t){super(t)}poolingFunction(t,e,s,n,i){checkDataFormat(i);checkPaddingMode(n);return pool2d(t,e,s,n,i,"max")}}MaxPooling2D.className="MaxPooling2D";l.registerClass(MaxPooling2D);class AveragePooling2D extends Pooling2D{constructor(t){super(t)}poolingFunction(t,e,s,n,i){checkDataFormat(i);checkPaddingMode(n);return pool2d(t,e,s,n,i,"avg")}}AveragePooling2D.className="AveragePooling2D";l.registerClass(AveragePooling2D);class Pooling3D extends Layer{constructor(t){t.poolSize==null&&(t.poolSize=[2,2,2]);super(t);this.poolSize=Array.isArray(t.poolSize)?t.poolSize:[t.poolSize,t.poolSize,t.poolSize];if(t.strides==null)this.strides=this.poolSize;else if(Array.isArray(t.strides)){if(t.strides.length!==3)throw new at(`If the strides property of a 3D pooling layer is an Array, it is expected to have a length of 3, but received length ${t.strides.length}.`);this.strides=t.strides}else this.strides=[t.strides,t.strides,t.strides];zt(this.poolSize,"poolSize");zt(this.strides,"strides");this.padding=t.padding==null?"valid":t.padding;this.dataFormat=t.dataFormat==null?"channelsLast":t.dataFormat;checkDataFormat(this.dataFormat);checkPaddingMode(this.padding);this.inputSpec=[new InputSpec({ndim:5})]}computeOutputShape(t){t=getExactlyOneShape(t);let e=this.dataFormat==="channelsFirst"?t[2]:t[1];let s=this.dataFormat==="channelsFirst"?t[3]:t[2];let n=this.dataFormat==="channelsFirst"?t[4]:t[3];e=convOutputLength(e,this.poolSize[0],this.padding,this.strides[0]);s=convOutputLength(s,this.poolSize[1],this.padding,this.strides[1]);n=convOutputLength(n,this.poolSize[2],this.padding,this.strides[2]);return this.dataFormat==="channelsFirst"?[t[0],t[1],e,s,n]:[t[0],e,s,n,t[4]]}call(t,e){return s((()=>{this.invokeCallHook(t,e);return this.poolingFunction(getExactlyOneTensor(t),this.poolSize,this.strides,this.padding,this.dataFormat)}))}getConfig(){const t={poolSize:this.poolSize,padding:this.padding,strides:this.strides,dataFormat:this.dataFormat};const e=super.getConfig();Object.assign(t,e);return t}}class MaxPooling3D extends Pooling3D{constructor(t){super(t)}poolingFunction(t,e,s,n,i){checkDataFormat(i);checkPaddingMode(n);return pool3d(t,e,s,n,i,"max")}}MaxPooling3D.className="MaxPooling3D";l.registerClass(MaxPooling3D);class AveragePooling3D extends Pooling3D{constructor(t){super(t)}poolingFunction(t,e,s,n,i){checkDataFormat(i);checkPaddingMode(n);return pool3d(t,e,s,n,i,"avg")}}AveragePooling3D.className="AveragePooling3D";l.registerClass(AveragePooling3D);class GlobalPooling1D extends Layer{constructor(t){super(t);this.inputSpec=[new InputSpec({ndim:3})]}computeOutputShape(t){return[t[0],t[2]]}call(t,e){throw new rt}}class GlobalAveragePooling1D extends GlobalPooling1D{constructor(t){super(t||{})}call(e,n){return s((()=>{const s=getExactlyOneTensor(e);return t.mean(s,1)}))}}GlobalAveragePooling1D.className="GlobalAveragePooling1D";l.registerClass(GlobalAveragePooling1D);class GlobalMaxPooling1D extends GlobalPooling1D{constructor(t){super(t||{})}call(e,n){return s((()=>{const s=getExactlyOneTensor(e);return t.max(s,1)}))}}GlobalMaxPooling1D.className="GlobalMaxPooling1D";l.registerClass(GlobalMaxPooling1D);class GlobalPooling2D extends Layer{constructor(t){super(t);this.dataFormat=t.dataFormat==null?"channelsLast":t.dataFormat;checkDataFormat(this.dataFormat);this.inputSpec=[new InputSpec({ndim:4})]}computeOutputShape(t){t;return this.dataFormat==="channelsLast"?[t[0],t[3]]:[t[0],t[1]]}call(t,e){throw new rt}getConfig(){const t={dataFormat:this.dataFormat};const e=super.getConfig();Object.assign(t,e);return t}}class GlobalAveragePooling2D extends GlobalPooling2D{call(e,n){return s((()=>{const s=getExactlyOneTensor(e);return this.dataFormat==="channelsLast"?t.mean(s,[1,2]):t.mean(s,[2,3])}))}}GlobalAveragePooling2D.className="GlobalAveragePooling2D";l.registerClass(GlobalAveragePooling2D);class GlobalMaxPooling2D extends GlobalPooling2D{call(e,n){return s((()=>{const s=getExactlyOneTensor(e);return this.dataFormat==="channelsLast"?t.max(s,[1,2]):t.max(s,[2,3])}))}}GlobalMaxPooling2D.className="GlobalMaxPooling2D";l.registerClass(GlobalMaxPooling2D);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class Wrapper extends Layer{constructor(t){super(t);this.layer=t.layer}build(t){this.built=true}get trainable(){return this.layer!=null&&this.layer.trainable}set trainable(t){this.layer!=null&&(this.layer.trainable=t)}get trainableWeights(){return this.layer.trainableWeights}get nonTrainableWeights(){return this.layer.nonTrainableWeights}get updates(){return this.layer._updates}get losses(){return this.layer.losses}getWeights(){return this.layer.getWeights()}setWeights(t){this.layer.setWeights(t)}getConfig(){const t={layer:{className:this.layer.getClassName(),config:this.layer.getConfig()}};const e=super.getConfig();Object.assign(t,e);return t}setFastWeightInitDuringBuild(t){super.setFastWeightInitDuringBuild(t);this.layer!=null&&this.layer.setFastWeightInitDuringBuild(t)}static fromConfig(t,e,s={}){const n=e.layer;const i=vt(n,s);delete e.layer;const a={layer:i};Object.assign(a,e);return new t(a)}}class TimeDistributed extends Wrapper{constructor(t){super(t);this.supportsMasking=true}build(t){t=getExactlyOneShape(t);if(t.length<3)throw new at(`TimeDistributed layer expects an input shape >= 3D, but received input shape ${JSON.stringify(t)}`);this.inputSpec=[{shape:t}];const e=[t[0]].concat(t.slice(2));if(!this.layer.built){this.layer.build(e);this.layer.built=true}super.build(t)}computeOutputShape(t){t=getExactlyOneShape(t);const e=[t[0]].concat(t.slice(2));const s=this.layer.computeOutputShape(e);const n=t[1];return[s[0],n].concat(s.slice(1))}call(t,e){return s((()=>{t=getExactlyOneTensor(t);const step=(t,s)=>{const n=getExactlyOneTensor(this.layer.call(t,e));return[n,[]]};const s=rnn$1(step,t,[],false,null,null,false,true);const n=s[1];return n}))}}TimeDistributed.className="TimeDistributed";l.registerClass(TimeDistributed);function checkBidirectionalMergeMode(t){it($t,"BidirectionalMergeMode",t)}const we="concat";class Bidirectional extends Wrapper{constructor(t){super(t);const e=t.layer.getConfig();const s={};s.className=t.layer.getClassName();s.config=e;this.forwardLayer=vt(s);e.goBackwards=e.goBackwards!==true;const n={};n.className=t.layer.getClassName();n.config=e;this.backwardLayer=vt(n);this.forwardLayer.name="forward_"+this.forwardLayer.name;this.backwardLayer.name="backward_"+this.backwardLayer.name;this.mergeMode=t.mergeMode===void 0?we:t.mergeMode;checkBidirectionalMergeMode(this.mergeMode);if(t.weights)throw new rt("weights support is not implemented for Bidirectional layer yet.");this._stateful=t.layer.stateful;this.returnSequences=t.layer.returnSequences;this.returnState=t.layer.returnState;this.supportsMasking=true;this._trainable=true;this.inputSpec=t.layer.inputSpec;this.numConstants=null}get trainable(){return this._trainable}set trainable(t){this._trainable=t;this.forwardLayer!=null&&(this.forwardLayer.trainable=t);this.backwardLayer!=null&&(this.backwardLayer.trainable=t)}getWeights(){return this.forwardLayer.getWeights().concat(this.backwardLayer.getWeights())}setWeights(t){const e=t.length;const s=Math.floor(e/2);this.forwardLayer.setWeights(t.slice(0,s));this.backwardLayer.setWeights(t.slice(s))}computeOutputShape(t){let e=this.forwardLayer.computeOutputShape(t);Array.isArray(e)&&Array.isArray(e[0])||(e=[e]);e;let s;let n;let i;if(this.returnState){i=e.slice(1);s=e[0]}else s=e[0];s;if(this.mergeMode==="concat"){s[s.length-1]*=2;n=[s]}else n=this.mergeMode==null?[s,s.slice()]:[s];return this.returnState?this.mergeMode==null?n.concat(i).concat(i.slice()):[s].concat(i).concat(i.slice()):ct(n)}apply(t,e){let s=e==null?null:e.initialState;let n=e==null?null:e.constants;e==null&&(e={});const i=standardizeArgs(t,s,n,this.numConstants);t=i.inputs;s=i.initialState;n=i.constants;if(Array.isArray(t)){s=t.slice(1);t=t[0]}if((s==null||s.length===0)&&n==null)return super.apply(t,e);const a=[];const r=[];if(s!=null){const t=s.length;if(t%2>0)throw new at("When passing `initialState` to a Bidrectional RNN, the state should be an Array containing the states of the underlying RNNs.");e.initialState=s;a.push(...s);const n=s.map((t=>new InputSpec({shape:t.shape})));this.forwardLayer.stateSpec=n.slice(0,t/2);this.backwardLayer.stateSpec=n.slice(t/2);r.push(...n)}if(n!=null)throw new rt("Support for constants in Bidirectional layers is not implemented yet.");const o=a[0]instanceof SymbolicTensor;for(const t of a)if(t instanceof SymbolicTensor!==o)throw new at("The initial state of a Bidirectional layer cannot be specified as a mix of symbolic and non-symbolic tensors");if(o){const s=[t].concat(a);const n=this.inputSpec.concat(r);const i=this.inputSpec;this.inputSpec=n;const o=super.apply(s,e);this.inputSpec=i;return o}return super.apply(t,e)}call(e,n){return s((()=>{const s=n.initialState;let i;let a;if(s==null){i=this.forwardLayer.call(e,n);a=this.backwardLayer.call(e,n)}else{const t=s.slice(0,s.length/2);const r=s.slice(s.length/2);i=this.forwardLayer.call(e,Object.assign(n,{initialState:t}));a=this.backwardLayer.call(e,Object.assign(n,{initialState:r}))}let r;if(this.returnState){Array.isArray(i)&&(r=i.slice(1).concat(a.slice(1)));i=i[0];a=a[0]}this.returnSequences&&(a=t.reverse(a,1));let o;this.mergeMode==="concat"?o=concatenate$2([i,a]):this.mergeMode==="sum"?o=t.add(i,a):this.mergeMode==="ave"?o=t.mul(.5,t.add(i,a)):this.mergeMode==="mul"?o=t.mul(i,a):this.mergeMode==null&&(o=[i,a]);return this.returnState?this.mergeMode==null?o.concat(r):[o].concat(r):o}))}resetStates(t){this.forwardLayer.resetStates();this.backwardLayer.resetStates()}build(t){nameScope(this.forwardLayer.name,(()=>{this.forwardLayer.build(t)}));nameScope(this.backwardLayer.name,(()=>{this.backwardLayer.build(t)}));this.built=true}computeMask(t,e){Array.isArray(e)&&(e=e[0]);let s;s=this.returnSequences?this.mergeMode==null?[e,e]:e:this.mergeMode==null?[null,null]:null;if(this.returnState){const t=this.forwardLayer.states;const e=t.map((t=>null));return Array.isArray(s)?s.concat(e).concat(e):[s].concat(e).concat(e)}return s}get trainableWeights(){return this.forwardLayer.trainableWeights.concat(this.backwardLayer.trainableWeights)}get nonTrainableWeights(){return this.forwardLayer.nonTrainableWeights.concat(this.backwardLayer.nonTrainableWeights)}setFastWeightInitDuringBuild(t){super.setFastWeightInitDuringBuild(t);this.forwardLayer!=null&&this.forwardLayer.setFastWeightInitDuringBuild(t);this.backwardLayer!=null&&this.backwardLayer.setFastWeightInitDuringBuild(t)}getConfig(){const t={mergeMode:this.mergeMode};const e=super.getConfig();Object.assign(t,e);return t}static fromConfig(t,e){const s=vt(e.layer);delete e.layer;if(e.numConstants!=null)throw new rt("Deserialization of a Bidirectional layer with numConstants present is not supported yet.");const n=e;n.layer=s;return new t(n)}}Bidirectional.className="Bidirectional";l.registerClass(Bidirectional);
/**
 * @license
 * Copyright 2022 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class Rescaling extends Layer{constructor(t){super(t);this.scale=t.scale;t.offset?this.offset=t.offset:this.offset=0}getConfig(){const t={scale:this.scale,offset:this.offset};const e=super.getConfig();Object.assign(t,e);return t}call(t,e){return s((()=>{t=getExactlyOneTensor(t);t.dtype!=="float32"&&(t=cast(t,"float32"));return z(c(t,this.scale),this.offset)}))}}Rescaling.className="Rescaling";l.registerClass(Rescaling);
/**
 * @license
 * Copyright 2022 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const{resizeBilinear:Se,cropAndResize:Ce}=Z;class CenterCrop extends Layer{constructor(t){super(t);this.height=t.height;this.width=t.width}centerCrop(t,e,n,i,a,r,o,l){return s((()=>{let s;let u=false;const h=e/r;const c=n/o;const p=(i+e)/r;const d=(a+n)/o;const g=[h,c,p,d];const m=[];if(t.rank===3){u=true;s=K([t])}else s=t;for(let t=0;t<s.shape[0];t++)m.push(g);const f=Y(m,[m.length,4]);const y=X(0,m.length,1,"int32");const b=[i,a];const w=Ce(s,f,y,b,"nearest");return cast(u?getExactlyOneTensor(Q(w)):w,l)}))}upsize(t,e,n,i){return s((()=>{const s=Se(t,[e,n]);return cast(s,i)}))}call(t,e){return s((()=>{const e=getExactlyOneTensor(t);const s=e.dtype;const n=e.shape;const i=n[n.length-3];const a=n[n.length-2];let r=0;i!==this.height&&(r=Math.floor((i-this.height)/2));let o=0;if(a!==this.width){o=Math.floor((a-this.width)/2);o===0&&(o=1)}return r>=0&&o>=0?this.centerCrop(e,r,o,this.height,this.width,i,a,s):this.upsize(t,this.height,this.width,s)}))}getConfig(){const t={height:this.height,width:this.width};const e=super.getConfig();Object.assign(t,e);return t}computeOutputShape(t){t=getExactlyOneShape(t);const e=t.length-3;const s=t.length-2;t[e]=this.height;t[s]=this.width;return t}}CenterCrop.className="CenterCrop";l.registerClass(CenterCrop);
/**
 * @license
 * Copyright 2022 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function encodeCategoricalInputs(t,e,s,n){let i=getExactlyOneTensor(t);i.dtype!=="int32"&&(i=cast(i,"int32"));if(e==="int")return i;const a=i.shape;i.rank===0&&(i=tt(i,-1));e==="oneHot"&&i.shape[i.shape.length-1]!==1&&(i=tt(i,-1));if(i.rank>2)throw new at(`When outputMode is not int, maximum output rank is 2 Received outputMode ${e} and input shape ${a} which would result in output rank ${i.rank}.`);const r=["multiHot","oneHot"].includes(e);const o=i;let l;l=et(o,typeof n!=="undefined"&&e==="count"?n:[],s,r);if(e!=="tfIdf")return l;if(n)return c(l,n);throw new at("When outputMode is 'tfIdf', weights must be provided.")}
/**
 * @license
 * Copyright 2022 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class CategoryEncoding extends Layer{constructor(t){super(t);this.numTokens=t.numTokens;t.outputMode?this.outputMode=t.outputMode:this.outputMode="multiHot"}getConfig(){const t={numTokens:this.numTokens,outputMode:this.outputMode};const e=super.getConfig();Object.assign(t,e);return t}computeOutputShape(t){t=getExactlyOneShape(t);if(t==null)return[this.numTokens];if(this.outputMode==="oneHot"&&t[t.length-1]!==1){t.push(this.numTokens);return t}t[t.length-1]=this.numTokens;return t}call(t,e){return s((()=>{t=getExactlyOneTensor(t);t.dtype!=="int32"&&(t=cast(t,"int32"));let s;if(typeof e.countWeights!=="undefined"){if(this.outputMode!=="count")throw new at(`countWeights is not used when outputMode !== count.\n              Received countWeights=${e.countWeights}`);s=getExactlyOneTensor(e.countWeights)}const n=st(t);const i=nt(t);const a=U(this.numTokens,n).bufferSync().get(0);const r=H(i,0).bufferSync().get(0);if(!(a&&r))throw new at(`Input values must be between 0 < values <= numTokens with numTokens=${this.numTokens}`);return encodeCategoricalInputs(t,this.outputMode,this.numTokens,s)}))}}CategoryEncoding.className="CategoryEncoding";l.registerClass(CategoryEncoding);
/**
 * @license
 * Copyright 2022 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const ze=["bilinear","nearest"];const Ne=new Set(ze);class Resizing extends Layer{constructor(t){super(t);this.height=t.height;this.width=t.width;if(t.interpolation){if(!Ne.has(t.interpolation))throw new at(`Invalid interpolation parameter: ${t.interpolation} is not implemented`);this.interpolation=t.interpolation}else this.interpolation="bilinear";this.cropToAspectRatio=Boolean(t.cropToAspectRatio)}computeOutputShape(t){t=getExactlyOneShape(t);const e=t[2];return[this.height,this.width,e]}getConfig(){const t={height:this.height,width:this.width,interpolation:this.interpolation,cropToAspectRatio:this.cropToAspectRatio};const e=super.getConfig();Object.assign(t,e);return t}call(t,e){return s((()=>{const e=[this.height,this.width];if(this.interpolation==="bilinear")return Z.resizeBilinear(t,e,!this.cropToAspectRatio);if(this.interpolation==="nearest")return Z.resizeNearestNeighbor(t,e,!this.cropToAspectRatio);throw new Error(`Interpolation is ${this.interpolation} but only ${[...Ne]} are supported`)}))}}Resizing.className="Resizing";l.registerClass(Resizing);
/**
 * @license
 * Copyright 2023 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class RandomSeed{constructor(t){this.seed=t}next(){if(this.seed!==void 0)return this.seed++}}RandomSeed.className="RandomSeed";
/**
 * @license
 * Copyright 2023 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class BaseRandomLayer extends Layer{constructor(t){super(t);this.randomGenerator=new RandomSeed(t.seed)}getConfig(){const t={seed:this.randomGenerator.seed};const e=super.getConfig();Object.assign(t,e);return t}}BaseRandomLayer.className="BaseRandomLayer";
/**
 * @license
 * Copyright 2023 CodeSmith LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */const ke=["bilinear","nearest"];const ve=new Set(ke);class RandomWidth extends BaseRandomLayer{constructor(t){super(t);const{factor:e,interpolation:s="bilinear"}=t;this.factor=e;if(Array.isArray(this.factor)&&this.factor.length===2){this.widthLower=this.factor[0];this.widthUpper=this.factor[1]}else{if(Array.isArray(this.factor)||!(this.factor>0))throw new at(`Invalid factor: ${this.factor}. Must be positive number or tuple of 2 numbers`);this.widthLower=-this.factor;this.widthUpper=this.factor}if(this.widthLower<-1||this.widthUpper<-1)throw new at(`factor must have values larger than -1. Got: ${this.factor}`);if(this.widthUpper<this.widthLower)throw new at(`factor cannot have upper bound less than lower bound.\n        Got upper bound: ${this.widthUpper}.\n        Got lower bound: ${this.widthLower}\n      `);if(s){if(!ve.has(s))throw new at(`Invalid interpolation parameter: ${s} is not implemented`);this.interpolation=s}}getConfig(){const t={factor:this.factor,interpolation:this.interpolation};const e=super.getConfig();Object.assign(t,e);return t}computeOutputShape(t){t=getExactlyOneShape(t);const e=t[2];return[this.imgHeight,-1,e]}call(t,e){return s((()=>{const e=getExactlyOneTensor(t);this.imgHeight=e.shape[e.shape.length-3];const s=e.shape[e.shape.length-2];this.widthFactor=p([1],1+this.widthLower,1+this.widthUpper,"float32",this.randomGenerator.next());let n=this.widthFactor.dataSync()[0]*s;n=Math.round(n);const i=[this.imgHeight,n];switch(this.interpolation){case"bilinear":return Z.resizeBilinear(t,i);case"nearest":return Z.resizeNearestNeighbor(t,i);default:throw new Error(`Interpolation is ${this.interpolation}\n          but only ${[...ve]} are supported`)}}))}}RandomWidth.className="RandomWidth";l.registerClass(RandomWidth);
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function inputLayer(t){return new InputLayer(t)}function elu(t){return new ELU(t)}function reLU(t){return new ReLU(t)}function leakyReLU(t){return new LeakyReLU(t)}function prelu(t){return new PReLU(t)}function softmax(t){return new Softmax(t)}function thresholdedReLU(t){return new ThresholdedReLU(t)}function conv1d(t){return new Conv1D(t)}function conv2d(t){return new Conv2D(t)}function conv2dTranspose(t){return new Conv2DTranspose(t)}function conv3d(t){return new Conv3D(t)}function conv3dTranspose(t){return new Conv3DTranspose(t)}function separableConv2d(t){return new SeparableConv2D(t)}function cropping2D(t){return new Cropping2D(t)}function upSampling2d(t){return new UpSampling2D(t)}function depthwiseConv2d(t){return new DepthwiseConv2D(t)}function activation(t){return new Activation(t)}function dense(t){return new Dense(t)}function dropout(t){return new Dropout(t)}function spatialDropout1d(t){return new SpatialDropout1D(t)}function flatten(t){return new Flatten(t)}function repeatVector(t){return new RepeatVector(t)}function reshape(t){return new Reshape(t)}function permute(t){return new Permute(t)}function embedding(t){return new Embedding(t)}function add(t){return new Add(t)}function average(t){return new Average(t)}function concatenate(t){return new Concatenate(t)}function maximum(t){return new Maximum(t)}function minimum(t){return new Minimum(t)}function multiply(t){return new Multiply(t)}function dot(t){return new Dot(t)}function batchNormalization(t){return new BatchNormalization(t)}function layerNormalization(t){return new LayerNormalization(t)}function zeroPadding2d(t){return new ZeroPadding2D(t)}function averagePooling1d(t){return new AveragePooling1D(t)}function avgPool1d(t){return averagePooling1d(t)}function avgPooling1d(t){return averagePooling1d(t)}function averagePooling2d(t){return new AveragePooling2D(t)}function avgPool2d(t){return averagePooling2d(t)}function avgPooling2d(t){return averagePooling2d(t)}function averagePooling3d(t){return new AveragePooling3D(t)}function avgPool3d(t){return averagePooling3d(t)}function avgPooling3d(t){return averagePooling3d(t)}function globalAveragePooling1d(t){return new GlobalAveragePooling1D(t)}function globalAveragePooling2d(t){return new GlobalAveragePooling2D(t)}function globalMaxPooling1d(t){return new GlobalMaxPooling1D(t)}function globalMaxPooling2d(t){return new GlobalMaxPooling2D(t)}function maxPooling1d(t){return new MaxPooling1D(t)}function maxPooling2d(t){return new MaxPooling2D(t)}function maxPooling3d(t){return new MaxPooling3D(t)}function gru(t){return new GRU(t)}function gruCell(t){return new GRUCell(t)}function lstm(t){return new LSTM(t)}function lstmCell(t){return new LSTMCell(t)}function simpleRNN(t){return new SimpleRNN(t)}function simpleRNNCell(t){return new SimpleRNNCell(t)}function convLstm2d(t){return new ConvLSTM2D(t)}function convLstm2dCell(t){return new ConvLSTM2DCell(t)}function rnn(t){return new RNN(t)}function stackedRNNCells(t){return new StackedRNNCells(t)}function bidirectional(t){return new Bidirectional(t)}function timeDistributed(t){return new TimeDistributed(t)}const Ae=globalMaxPooling1d;const xe=globalMaxPooling2d;const Ie=maxPooling1d;const Le=maxPooling2d;function gaussianNoise(t){return new GaussianNoise(t)}function gaussianDropout(t){return new GaussianDropout(t)}function alphaDropout(t){return new AlphaDropout(t)}function masking(t){return new Masking(t)}function rescaling(t){return new Rescaling(t)}function centerCrop(t){return new CenterCrop(t)}function resizing(t){return new Resizing(t)}function categoryEncoding(t){return new CategoryEncoding(t)}function randomWidth(t){return new RandomWidth(t)}var De=Object.freeze(Object.defineProperty({__proto__:null,Layer:Layer,RNN:RNN,RNNCell:RNNCell,activation:activation,add:add,alphaDropout:alphaDropout,average:average,averagePooling1d:averagePooling1d,averagePooling2d:averagePooling2d,averagePooling3d:averagePooling3d,avgPool1d:avgPool1d,avgPool2d:avgPool2d,avgPool3d:avgPool3d,avgPooling1d:avgPooling1d,avgPooling2d:avgPooling2d,avgPooling3d:avgPooling3d,batchNormalization:batchNormalization,bidirectional:bidirectional,categoryEncoding:categoryEncoding,centerCrop:centerCrop,concatenate:concatenate,conv1d:conv1d,conv2d:conv2d,conv2dTranspose:conv2dTranspose,conv3d:conv3d,conv3dTranspose:conv3dTranspose,convLstm2d:convLstm2d,convLstm2dCell:convLstm2dCell,cropping2D:cropping2D,dense:dense,depthwiseConv2d:depthwiseConv2d,dot:dot,dropout:dropout,elu:elu,embedding:embedding,flatten:flatten,gaussianDropout:gaussianDropout,gaussianNoise:gaussianNoise,globalAveragePooling1d:globalAveragePooling1d,globalAveragePooling2d:globalAveragePooling2d,globalMaxPool1d:Ae,globalMaxPool2d:xe,globalMaxPooling1d:globalMaxPooling1d,globalMaxPooling2d:globalMaxPooling2d,gru:gru,gruCell:gruCell,input:input,inputLayer:inputLayer,layerNormalization:layerNormalization,leakyReLU:leakyReLU,lstm:lstm,lstmCell:lstmCell,masking:masking,maxPool1d:Ie,maxPool2d:Le,maxPooling1d:maxPooling1d,maxPooling2d:maxPooling2d,maxPooling3d:maxPooling3d,maximum:maximum,minimum:minimum,multiply:multiply,permute:permute,prelu:prelu,randomWidth:randomWidth,reLU:reLU,repeatVector:repeatVector,rescaling:rescaling,reshape:reshape,resizing:resizing,rnn:rnn,separableConv2d:separableConv2d,simpleRNN:simpleRNN,simpleRNNCell:simpleRNNCell,softmax:softmax,spatialDropout1d:spatialDropout1d,stackedRNNCells:stackedRNNCells,thresholdedReLU:thresholdedReLU,timeDistributed:timeDistributed,upSampling2d:upSampling2d,zeroPadding2d:zeroPadding2d},Symbol.toStringTag,{value:"Module"}));
/**
 * Binary accuracy metric function.
 *
 * `yTrue` and `yPred` can have 0-1 values. Example:
 * ```js
 * const x = tf.tensor2d([[1, 1, 1, 1], [0, 0, 0, 0]], [2, 4]);
 * const y = tf.tensor2d([[1, 0, 1, 0], [0, 0, 0, 1]], [2, 4]);
 * const accuracy = tf.metrics.binaryAccuracy(x, y);
 * accuracy.print();
 * ```
 *
 * `yTrue` and `yPred` can also have floating-number values between 0 and 1, in
 * which case the values will be thresholded at 0.5 to yield 0-1 values (i.e.,
 * a value >= 0.5 and <= 1.0 is interpreted as 1).
 *
 * Example:
 * ```js
 * const x = tf.tensor1d([1, 1, 1, 1, 0, 0, 0, 0]);
 * const y = tf.tensor1d([0.2, 0.4, 0.6, 0.8, 0.2, 0.3, 0.4, 0.7]);
 * const accuracy = tf.metrics.binaryAccuracy(x, y);
 * accuracy.print();
 * ```
 *
 * @param yTrue Binary Tensor of truth.
 * @param yPred Binary Tensor of prediction.
 * @return Accuracy Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function binaryAccuracy(t,e){return binaryAccuracy$1(t,e)}
/**
 * Binary crossentropy metric function.
 *
 * Example:
 * ```js
 * const x = tf.tensor2d([[0], [1], [1], [1]]);
 * const y = tf.tensor2d([[0], [0], [0.5], [1]]);
 * const crossentropy = tf.metrics.binaryCrossentropy(x, y);
 * crossentropy.print();
 * ```
 *
 * @param yTrue Binary Tensor of truth.
 * @param yPred Binary Tensor of prediction, probabilities for the `1` case.
 * @return Accuracy Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function binaryCrossentropy(t,e){return binaryCrossentropy$1(t,e)}
/**
 * Sparse categorical accuracy metric function.
 *
 * Example:
 * ```js
 *
 * const yTrue = tf.tensor1d([1, 1, 2, 2, 0]);
 * const yPred = tf.tensor2d(
 *      [[0, 1, 0], [1, 0, 0], [0, 0.4, 0.6], [0, 0.6, 0.4], [0.7, 0.3, 0]]);
 * const crossentropy = tf.metrics.sparseCategoricalAccuracy(yTrue, yPred);
 * crossentropy.print();
 * ```
 *
 * @param yTrue True labels: indices.
 * @param yPred Predicted probabilities or logits.
 * @returns Accuracy tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function sparseCategoricalAccuracy(t,e){return sparseCategoricalAccuracy$1(t,e)}
/**
 * Categorical accuracy metric function.
 *
 * Example:
 * ```js
 * const x = tf.tensor2d([[0, 0, 0, 1], [0, 0, 0, 1]]);
 * const y = tf.tensor2d([[0.1, 0.8, 0.05, 0.05], [0.1, 0.05, 0.05, 0.8]]);
 * const accuracy = tf.metrics.categoricalAccuracy(x, y);
 * accuracy.print();
 * ```
 *
 * @param yTrue Binary Tensor of truth: one-hot encoding of categories.
 * @param yPred Binary Tensor of prediction: probabilities or logits for the
 *   same categories as in `yTrue`.
 * @return Accuracy Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function categoricalAccuracy(t,e){return categoricalAccuracy$1(t,e)}
/**
 * Categorical crossentropy between an output tensor and a target tensor.
 *
 * @param target A tensor of the same shape as `output`.
 * @param output A tensor resulting from a softmax (unless `fromLogits` is
 *  `true`, in which case `output` is expected to be the logits).
 * @param fromLogits Boolean, whether `output` is the result of a softmax, or is
 *   a tensor of logits.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function categoricalCrossentropy(t,e){return oe(t,e)}
/**
 * Computes the precision of the predictions with respect to the labels.
 *
 * Example:
 * ```js
 * const x = tf.tensor2d(
 *    [
 *      [0, 0, 0, 1],
 *      [0, 1, 0, 0],
 *      [0, 0, 0, 1],
 *      [1, 0, 0, 0],
 *      [0, 0, 1, 0]
 *    ]
 * );
 *
 * const y = tf.tensor2d(
 *    [
 *      [0, 0, 1, 0],
 *      [0, 1, 0, 0],
 *      [0, 0, 0, 1],
 *      [0, 1, 0, 0],
 *      [0, 1, 0, 0]
 *    ]
 * );
 *
 * const precision = tf.metrics.precision(x, y);
 * precision.print();
 * ```
 *
 * @param yTrue The ground truth values. Expected to contain only 0-1 values.
 * @param yPred The predicted values. Expected to contain only 0-1 values.
 * @return Precision Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function precision(t,e){return precision$1(t,e)}
/**
 * Computes the recall of the predictions with respect to the labels.
 *
 * Example:
 * ```js
 * const x = tf.tensor2d(
 *    [
 *      [0, 0, 0, 1],
 *      [0, 1, 0, 0],
 *      [0, 0, 0, 1],
 *      [1, 0, 0, 0],
 *      [0, 0, 1, 0]
 *    ]
 * );
 *
 * const y = tf.tensor2d(
 *    [
 *      [0, 0, 1, 0],
 *      [0, 1, 0, 0],
 *      [0, 0, 0, 1],
 *      [0, 1, 0, 0],
 *      [0, 1, 0, 0]
 *    ]
 * );
 *
 * const recall = tf.metrics.recall(x, y);
 * recall.print();
 * ```
 *
 * @param yTrue The ground truth values. Expected to contain only 0-1 values.
 * @param yPred The predicted values. Expected to contain only 0-1 values.
 * @return Recall Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function recall(t,e){return recall$1(t,e)}
/**
 * Loss or metric function: Cosine proximity.
 *
 * Mathematically, cosine proximity is defined as:
 *   `-sum(l2Normalize(yTrue) * l2Normalize(yPred))`,
 * wherein `l2Normalize()` normalizes the L2 norm of the input to 1 and `*`
 * represents element-wise multiplication.
 *
 * ```js
 * const yTrue = tf.tensor2d([[1, 0], [1, 0]]);
 * const yPred = tf.tensor2d([[1 / Math.sqrt(2), 1 / Math.sqrt(2)], [0, 1]]);
 * const proximity = tf.metrics.cosineProximity(yTrue, yPred);
 * proximity.print();
 * ```
 *
 * @param yTrue Truth Tensor.
 * @param yPred Prediction Tensor.
 * @return Cosine proximity Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function cosineProximity(t,e){return cosineProximity$1(t,e)}
/**
 * Loss or metric function: Mean absolute error.
 *
 * Mathematically, mean absolute error is defined as:
 *   `mean(abs(yPred - yTrue))`,
 * wherein the `mean` is applied over feature dimensions.
 *
 * ```js
 * const yTrue = tf.tensor2d([[0, 1], [0, 0], [2, 3]]);
 * const yPred = tf.tensor2d([[0, 1], [0, 1], [-2, -3]]);
 * const mse = tf.metrics.meanAbsoluteError(yTrue, yPred);
 * mse.print();
 * ```
 *
 * @param yTrue Truth Tensor.
 * @param yPred Prediction Tensor.
 * @return Mean absolute error Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function meanAbsoluteError(t,e){return meanAbsoluteError$1(t,e)}
/**
 * Loss or metric function: Mean absolute percentage error.
 *
 * ```js
 * const yTrue = tf.tensor2d([[0, 1], [10, 20]]);
 * const yPred = tf.tensor2d([[0, 1], [11, 24]]);
 * const mse = tf.metrics.meanAbsolutePercentageError(yTrue, yPred);
 * mse.print();
 * ```
 *
 * Aliases: `tf.metrics.MAPE`, `tf.metrics.mape`.
 *
 * @param yTrue Truth Tensor.
 * @param yPred Prediction Tensor.
 * @return Mean absolute percentage error Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function meanAbsolutePercentageError(t,e){return meanAbsolutePercentageError$1(t,e)}function MAPE(t,e){return meanAbsolutePercentageError$1(t,e)}function mape(t,e){return meanAbsolutePercentageError$1(t,e)}
/**
 * Loss or metric function: Mean squared error.
 *
 * ```js
 * const yTrue = tf.tensor2d([[0, 1], [3, 4]]);
 * const yPred = tf.tensor2d([[0, 1], [-3, -4]]);
 * const mse = tf.metrics.meanSquaredError(yTrue, yPred);
 * mse.print();
 * ```
 *
 * Aliases: `tf.metrics.MSE`, `tf.metrics.mse`.
 *
 * @param yTrue Truth Tensor.
 * @param yPred Prediction Tensor.
 * @return Mean squared error Tensor.
 *
 * @doc {heading: 'Metrics', namespace: 'metrics'}
 */function meanSquaredError(t,e){return meanSquaredError$1(t,e)}function MSE(t,e){return meanSquaredError$1(t,e)}function mse(t,e){return meanSquaredError$1(t,e)}var Te=Object.freeze(Object.defineProperty({__proto__:null,MAPE:MAPE,MSE:MSE,binaryAccuracy:binaryAccuracy,binaryCrossentropy:binaryCrossentropy,categoricalAccuracy:categoricalAccuracy,categoricalCrossentropy:categoricalCrossentropy,cosineProximity:cosineProximity,mape:mape,meanAbsoluteError:meanAbsoluteError,meanAbsolutePercentageError:meanAbsolutePercentageError,meanSquaredError:meanSquaredError,mse:mse,precision:precision,recall:recall,sparseCategoricalAccuracy:sparseCategoricalAccuracy},Symbol.toStringTag,{value:"Module"}));
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */var Ee=Object.freeze(Object.defineProperty({__proto__:null,modelFromJSON:modelFromJSON},Symbol.toStringTag,{value:"Module"}));
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */function l1l2(t){return new L1L2(t)}
/**
 * Regularizer for L1 regularization.
 *
 * Adds a term to the loss to penalize large weights:
 * loss += sum(l1 * abs(x))
 * @param args l1 config.
 *
 * @doc {heading: 'Regularizers', namespace: 'regularizers'}
 */function l1(t){return l1$1(t)}
/**
 * Regularizer for L2 regularization.
 *
 * Adds a term to the loss to penalize large weights:
 * loss += sum(l2 * x^2)
 * @param args l2 config.
 *
 * @doc {heading: 'Regularizers', namespace: 'regularizers'}
 */function l2(t){return l2$1(t)}var Re=Object.freeze(Object.defineProperty({__proto__:null,l1:l1,l1l2:l1l2,l2:l2},Symbol.toStringTag,{value:"Module"}));
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */class Callback extends BaseCallback{constructor(){super(...arguments);this.model=null}setModel(t){if(!(t instanceof LayersModel))throw new Error("model must be a LayersModel, not some other Container");this.model=t}}function less(t,e){return t<e}function greater(t,e){return t>e}class EarlyStopping extends Callback{constructor(t){super();t==null&&(t={});if(t.restoreBestWeights)throw new rt("restoreBestWeights = True is not implemented in EarlyStopping yet.");this.monitor=t.monitor||"val_loss";this.minDelta=Math.abs(t.minDelta||0);this.patience=t.patience||0;this.verbose=t.verbose||0;this.mode=t.mode||"auto";this.baseline=t.baseline;if(["auto","min","max"].indexOf(this.mode)===-1){console.warn(`EarlyStopping mode '${this.mode}' is invalid. Falling back to mode 'auto'.`);this.mode="auto"}this.mode==="min"?this.monitorFunc=less:this.mode==="max"||this.monitor.indexOf("acc")!==-1?this.monitorFunc=greater:this.monitorFunc=less;this.monitorFunc===less&&(this.minDelta*=-1)}async onTrainBegin(t){this.wait=0;this.stoppedEpoch=0;this.baseline!=null?this.best=this.baseline:this.best=this.monitorFunc===less?Infinity:-Infinity}async onEpochEnd(t,e){await resolveScalarsInLogs(e);const s=this.getMonitorValue(e);if(s!=null)if(this.monitorFunc(s-this.minDelta,this.best)){this.best=s;this.wait=0}else{this.wait++;if(this.wait>=this.patience){this.stoppedEpoch=t;this.model.stopTraining=true}}}async onTrainEnd(t){this.stoppedEpoch>0&&this.verbose&&console.log(`Epoch ${this.stoppedEpoch}: early stopping.`)}getMonitorValue(t){t==null&&(t={});const e=t[this.monitor];e==null&&console.warn(`Metric for EarlyStopping ${this.monitor} is not available. Available metrics are: ${Object.keys(t)}`);return e}}function earlyStopping(t){return new EarlyStopping(t)}const $e={earlyStopping:earlyStopping};
/**
 * @license
 * Copyright 2018 Google LLC
 *
 * Use of this source code is governed by an MIT-style
 * license that can be found in the LICENSE file or at
 * https://opensource.org/licenses/MIT.
 * =============================================================================
 */export{Callback,CallbackList,CustomCallback,EarlyStopping,History,InputSpec,LayerVariable,LayersModel,RNN,Sequential,SymbolicTensor,$e as callbacks,Kt as constraints,Yt as initializers,input,De as layers,loadLayersModel,Te as metrics,model,Ee as models,registerCallbackConstructor,Re as regularizers,sequential,pe as version_layers};

