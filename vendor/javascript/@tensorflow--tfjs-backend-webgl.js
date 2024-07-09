import*as e from"@tensorflow/tfjs-core";import{env as t,util as n,device_util as o,backend_util as a,kernel_impls as r,KernelBackend as s,engine as i,DataStorage as c,buffer as l,scalar as u,tidy as d,nextFrame as p,registerBackend as h,Identity as f,Complex as x,LeakyRelu as m,Prelu as g,upcastType as C,Multiply as b,Reshape as v,sumOutType as $,Sum as y,Transpose as I,broadcast_util as S,_FusedMatMul as T,Abs as k,Acos as w,Acosh as R,Add as F,AddN as N,All as E,Any as P,ArgMax as A,ArgMin as O,Asin as D,Asinh as _,Atan as L,Atan2 as B,Atanh as U,AvgPool as M,AvgPool3D as V,AvgPool3DGrad as W,AvgPoolGrad as G,BatchMatMul as z,FusedBatchNorm as X,slice_util as H,Slice as K,BatchToSpaceND as j,Bincount as q,BitwiseAnd as Y,BroadcastArgs as Q,NotEqual as Z,Real as J,Cast as ee,Ceil as te,ClipByValue as ne,ComplexAbs as oe,Imag as ae,Concat as re,Conv2D as se,Conv2DBackpropFilter as ie,Conv2DBackpropInput as ce,Conv3D as le,Conv3DBackpropFilterV2 as ue,Conv3DBackpropInputV2 as de,Cos as pe,Cosh as he,CropAndResize as fe,Cumprod as xe,Cumsum as me,DenseBincount as ge,DepthToSpace as Ce,DepthwiseConv2dNative as be,DepthwiseConv2dNativeBackpropFilter as ve,DepthwiseConv2dNativeBackpropInput as $e,Diag as ye,Dilation2D as Ie,Einsum as Se,Elu as Te,EluGrad as ke,Equal as we,Erf as Re,Exp as Fe,ExpandDims as Ne,Expm1 as Ee,FFT as Pe,Fill as Ae,FlipLeftRight as Oe,Floor as De,FloorDiv as _e,FromPixels as Le,FusedConv2D as Be,FusedDepthwiseConv2D as Ue,GatherNd as Me,GatherV2 as Ve,Greater as We,GreaterEqual as Ge,IFFT as ze,IsFinite as Xe,IsInf as He,IsNan as Ke,Less as je,LessEqual as qe,LinSpace as Ye,Log as Qe,Log1p as Ze,LogicalAnd as Je,LogicalNot as et,LogicalOr as tt,LRN as nt,LRNGrad as ot,Max as at,Maximum as rt,MaxPool as st,MaxPool3D as it,MaxPool3DGrad as ct,MaxPoolGrad as lt,MaxPoolWithArgmax as ut,Mean as dt,Min as pt,Minimum as ht,MirrorPad as ft,Mod as xt,RealDiv as mt,Sub as gt,Softmax as Ct,Multinomial as bt,Neg as vt,NonMaxSuppressionV3 as $t,NonMaxSuppressionV4 as yt,NonMaxSuppressionV5 as It,OneHot as St,ZerosLike as Tt,OnesLike as kt,Pack as wt,PadV2 as Rt,Pow as Ft,Prod as Nt,RaggedGather as Et,RaggedRange as Pt,RaggedTensorToTensor as At,Range as Ot,Reciprocal as Dt,Relu as _t,Relu6 as Lt,ResizeBilinear as Bt,ResizeBilinearGrad as Ut,ResizeNearestNeighbor as Mt,ResizeNearestNeighborGrad as Vt,Reverse as Wt,RotateWithOffset as Gt,Round as zt,Rsqrt as Xt,ScatterNd as Ht,SearchSorted as Kt,Select as jt,Selu as qt,Sigmoid as Yt,Sign as Qt,Sin as Zt,Sinh as Jt,Softplus as en,SpaceToBatchND as tn,SparseFillEmptyRows as nn,SparseReshape as on,SparseSegmentMean as an,SparseSegmentSum as rn,SparseToDense as sn,SplitV as cn,Sqrt as ln,Square as un,SquaredDifference as dn,StaticRegexReplace as pn,Step as hn,StridedSlice as fn,StringNGrams as xn,StringSplit as mn,StringToHashBucketFast as gn,Tan as Cn,Tanh as bn,TensorScatterUpdate as vn,Tile as $n,TopK as yn,Transform as In,Unique as Sn,Unpack as Tn,UnsortedSegmentSum as kn,registerKernel as wn}from"@tensorflow/tfjs-core";import*as Rn from"@tensorflow/tfjs-backend-cpu/dist/shared";
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */const Fn={};const Nn={alpha:false,antialias:false,premultipliedAlpha:false,preserveDrawingBuffer:false,depth:false,stencil:false,failIfMajorPerformanceCaveat:true};function setWebGLContext(e,t){Fn[e]=t}function getWebGLContext(e,t){if(!(e in Fn)||t!=null){const n=getWebGLRenderingContext(e,t);if(n===null){console.log("Could not get context for WebGL version",e);return null}Fn[e]=n}const n=Fn[e];if(n==null||n.isContextLost()){delete Fn[e];return getWebGLContext(e)}n.disable(n.DEPTH_TEST);n.disable(n.STENCIL_TEST);n.disable(n.BLEND);n.disable(n.DITHER);n.disable(n.POLYGON_OFFSET_FILL);n.disable(n.SAMPLE_COVERAGE);n.enable(n.SCISSOR_TEST);n.enable(n.CULL_FACE);n.cullFace(n.BACK);return Fn[e]}function createCanvas(e){if(t().getBool("IS_SAFARI")||typeof OffscreenCanvas==="undefined"||e!==2){if(typeof document!=="undefined")return document.createElement("canvas");throw new Error("Cannot create a canvas in this context")}return new OffscreenCanvas(300,150)}function getWebGLRenderingContext(e,n){if(e!==1&&e!==2)throw new Error("Cannot get WebGL rendering context, WebGL is disabled.");const o=n==null?createCanvas(e):n;o.addEventListener("webglcontextlost",(t=>{t.preventDefault();delete Fn[e]}),false);t().getBool("SOFTWARE_WEBGL_ENABLED")&&(Nn.failIfMajorPerformanceCaveat=false);return e===1?o.getContext("webgl",Nn)||o.getContext("experimental-webgl",Nn):o.getContext("webgl2",Nn)}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */var En;(function(e){e[e.DENSE=0]="DENSE";e[e.SHARED_BATCH=1]="SHARED_BATCH"})(En||(En={}));var Pn;(function(e){e[e.RENDER=0]="RENDER";e[e.UPLOAD=1]="UPLOAD";e[e.PIXELS=2]="PIXELS";e[e.DOWNLOAD=3]="DOWNLOAD"})(Pn||(Pn={}));var An;(function(e){e[e.UNPACKED_FLOAT16=0]="UNPACKED_FLOAT16";e[e.UNPACKED_FLOAT32=1]="UNPACKED_FLOAT32";e[e.PACKED_4X1_UNSIGNED_BYTE=2]="PACKED_4X1_UNSIGNED_BYTE";e[e.PACKED_2X2_FLOAT32=3]="PACKED_2X2_FLOAT32";e[e.PACKED_2X2_FLOAT16=4]="PACKED_2X2_FLOAT16"})(An||(An={}));function getUnpackedMatrixTextureShapeWidthHeight(e,t){return[t,e]}function getUnpackedArraySizeFromMatrixSize(e,t){return e*t}function getDenseTexShape(e){const t=n.sizeFromShape(e);const o=Math.ceil(t/4);return n.sizeToSquarishShape(o)}function getPackedMatrixTextureShapeWidthHeight(e,t){return[Math.max(1,Math.ceil(t/2)),Math.max(1,Math.ceil(e/2))]}function getPackedRGBAArraySizeFromMatrixShape(e,t){const[n,o]=getPackedMatrixTextureShapeWidthHeight(e,t);return n*o*4}function getTextureConfig(e,n){const o=e;let a;let r;let s;let i;let c;let l;let u;let d;let p;let h;if(t().getNumber("WEBGL_VERSION")===2){a=o.R32F;r=o.R16F;s=o.RGBA16F;i=o.RGBA32F;c=o.RED;u=4;d=1;p=o.HALF_FLOAT;h=o.FLOAT;l=o.RGBA8}else{a=e.RGBA;r=e.RGBA;s=e.RGBA;i=o.RGBA;c=e.RGBA;u=4;d=4;p=n!=null?n.HALF_FLOAT_OES:null;h=e.FLOAT;l=e.RGBA}return{internalFormatFloat:a,internalFormatHalfFloat:r,internalFormatPackedHalfFloat:s,internalFormatPackedFloat:i,textureFormatFloat:c,downloadTextureFormat:l,downloadUnpackNumChannels:u,defaultNumChannels:d,textureTypeHalfFloat:p,textureTypeFloat:h}}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */function callAndCheck(e,n){const o=n();t().getBool("DEBUG")&&checkWebGLError(e);return o}function checkWebGLError(e){const t=e.getError();if(t!==e.NO_ERROR)throw new Error("WebGL Error: "+getWebGLErrorMessage(e,t))}const On=5.96e-8;const Dn=65504;function canBeRepresented(e){return!!(t().getBool("WEBGL_RENDER_FLOAT32_ENABLED")||e===0||On<Math.abs(e)&&Math.abs(e)<Dn)}function getWebGLErrorMessage(e,t){switch(t){case e.NO_ERROR:return"NO_ERROR";case e.INVALID_ENUM:return"INVALID_ENUM";case e.INVALID_VALUE:return"INVALID_VALUE";case e.INVALID_OPERATION:return"INVALID_OPERATION";case e.INVALID_FRAMEBUFFER_OPERATION:return"INVALID_FRAMEBUFFER_OPERATION";case e.OUT_OF_MEMORY:return"OUT_OF_MEMORY";case e.CONTEXT_LOST_WEBGL:return"CONTEXT_LOST_WEBGL";default:return`Unknown error code ${t}`}}function getExtensionOrThrow(e,t){return throwIfNull(e,(()=>e.getExtension(t)),'Extension "'+t+'" not supported on this browser.')}function createVertexShader$1(e,t){const n=throwIfNull(e,(()=>e.createShader(e.VERTEX_SHADER)),"Unable to create vertex WebGLShader.");callAndCheck(e,(()=>e.shaderSource(n,t)));callAndCheck(e,(()=>e.compileShader(n)));if(e.getShaderParameter(n,e.COMPILE_STATUS)===false){console.log(e.getShaderInfoLog(n));throw new Error("Failed to compile vertex shader.")}return n}function createFragmentShader(e,n){const o=throwIfNull(e,(()=>e.createShader(e.FRAGMENT_SHADER)),"Unable to create fragment WebGLShader.");callAndCheck(e,(()=>e.shaderSource(o,n)));callAndCheck(e,(()=>e.compileShader(o)));if(t().get("ENGINE_COMPILE_ONLY"))return o;if(e.getShaderParameter(o,e.COMPILE_STATUS)===false){logShaderSourceAndInfoLog(n,e.getShaderInfoLog(o));throw new Error("Failed to compile fragment shader.")}return o}const _n=/ERROR: [0-9]+:([0-9]+):/g;function logShaderSourceAndInfoLog(e,t){const o=_n.exec(t);if(o==null){console.log(`Couldn't parse line number in error: ${t}`);console.log(e);return}const a=+o[1];const r=e.split("\n");const s=r.length.toString().length+2;const i=r.map(((e,t)=>n.rightPad((t+1).toString(),s)+e));let c=0;for(let e=0;e<i.length;e++)c=Math.max(i[e].length,c);const l=i.slice(0,a-1);const u=i.slice(a-1,a);const d=i.slice(a);console.log(l.join("\n"));console.log(t.split("\n")[0]);console.log(`%c ${n.rightPad(u[0],c)}`,"border:1px solid red; background-color:#e3d2d2; color:#a61717");console.log(d.join("\n"))}function createProgram(e){return throwIfNull(e,(()=>e.createProgram()),"Unable to create WebGLProgram.")}function linkProgram(e,n){callAndCheck(e,(()=>e.linkProgram(n)));if(!t().get("ENGINE_COMPILE_ONLY")&&e.getProgramParameter(n,e.LINK_STATUS)===false){console.log(e.getProgramInfoLog(n));throw new Error("Failed to link vertex and fragment shaders.")}}function validateProgram(e,t){callAndCheck(e,(()=>e.validateProgram(t)));if(e.getProgramParameter(t,e.VALIDATE_STATUS)===false){console.log(e.getProgramInfoLog(t));throw new Error("Shader program validation failed.")}}function createStaticVertexBuffer(e,t){const n=throwIfNull(e,(()=>e.createBuffer()),"Unable to create WebGLBuffer");callAndCheck(e,(()=>e.bindBuffer(e.ARRAY_BUFFER,n)));callAndCheck(e,(()=>e.bufferData(e.ARRAY_BUFFER,t,e.STATIC_DRAW)));return n}function createStaticIndexBuffer(e,t){const n=throwIfNull(e,(()=>e.createBuffer()),"Unable to create WebGLBuffer");callAndCheck(e,(()=>e.bindBuffer(e.ELEMENT_ARRAY_BUFFER,n)));callAndCheck(e,(()=>e.bufferData(e.ELEMENT_ARRAY_BUFFER,t,e.STATIC_DRAW)));return n}function getNumChannels(){return t().getNumber("WEBGL_VERSION")===2?1:4}function createTexture(e){return throwIfNull(e,(()=>e.createTexture()),"Unable to create WebGLTexture.")}function validateTextureSize(e,n){const o=t().getNumber("WEBGL_MAX_TEXTURE_SIZE");if(e<=0||n<=0){const t=`[${e}x${n}]`;throw new Error("Requested texture size "+t+" is invalid.")}if(e>o||n>o){const t=`[${e}x${n}]`;const a=`[${o}x${o}]`;throw new Error("Requested texture size "+t+" greater than WebGL maximum on this browser / GPU "+a+".")}}function createFramebuffer(e){return throwIfNull(e,(()=>e.createFramebuffer()),"Unable to create WebGLFramebuffer.")}function bindVertexBufferToProgramAttribute(e,t,n,o,a,r,s){const i=e.getAttribLocation(t,n);if(i===-1)return false;callAndCheck(e,(()=>e.bindBuffer(e.ARRAY_BUFFER,o)));callAndCheck(e,(()=>e.vertexAttribPointer(i,a,e.FLOAT,false,r,s)));callAndCheck(e,(()=>e.enableVertexAttribArray(i)));return true}function bindTextureUnit(e,t,n){validateTextureUnit(e,n);callAndCheck(e,(()=>e.activeTexture(e.TEXTURE0+n)));callAndCheck(e,(()=>e.bindTexture(e.TEXTURE_2D,t)))}function unbindTextureUnit(e,t){validateTextureUnit(e,t);callAndCheck(e,(()=>e.activeTexture(e.TEXTURE0+t)));callAndCheck(e,(()=>e.bindTexture(e.TEXTURE_2D,null)))}function getProgramUniformLocationOrThrow(e,t,n){return throwIfNull(e,(()=>e.getUniformLocation(t,n)),'uniform "'+n+'" not present in program.')}function getProgramUniformLocation(e,t,n){return e.getUniformLocation(t,n)}function bindTextureToProgramUniformSampler(e,t,n,o){callAndCheck(e,(()=>bindTextureUnit(e,t,o)));callAndCheck(e,(()=>e.uniform1i(n,o)))}function bindCanvasToFramebuffer(e){callAndCheck(e,(()=>e.bindFramebuffer(e.FRAMEBUFFER,null)));callAndCheck(e,(()=>e.viewport(0,0,e.canvas.width,e.canvas.height)));callAndCheck(e,(()=>e.scissor(0,0,e.canvas.width,e.canvas.height)))}function bindColorTextureToFramebuffer(e,t,n){callAndCheck(e,(()=>e.bindFramebuffer(e.FRAMEBUFFER,n)));callAndCheck(e,(()=>e.framebufferTexture2D(e.FRAMEBUFFER,e.COLOR_ATTACHMENT0,e.TEXTURE_2D,t,0)))}function unbindColorTextureFromFramebuffer(e,t){callAndCheck(e,(()=>e.bindFramebuffer(e.FRAMEBUFFER,t)));callAndCheck(e,(()=>e.framebufferTexture2D(e.FRAMEBUFFER,e.COLOR_ATTACHMENT0,e.TEXTURE_2D,null,0)))}function validateFramebuffer(e){const t=e.checkFramebufferStatus(e.FRAMEBUFFER);if(t!==e.FRAMEBUFFER_COMPLETE)throw new Error("Error binding framebuffer: "+getFramebufferErrorMessage(e,t))}function getFramebufferErrorMessage(e,t){switch(t){case e.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:return"FRAMEBUFFER_INCOMPLETE_ATTACHMENT";case e.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:return"FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT";case e.FRAMEBUFFER_INCOMPLETE_DIMENSIONS:return"FRAMEBUFFER_INCOMPLETE_DIMENSIONS";case e.FRAMEBUFFER_UNSUPPORTED:return"FRAMEBUFFER_UNSUPPORTED";default:return`unknown error ${t}`}}function throwIfNull(e,t,n){const o=callAndCheck(e,(()=>t()));if(o==null)throw new Error(n);return o}function validateTextureUnit(e,t){const n=e.MAX_COMBINED_TEXTURE_IMAGE_UNITS-1;const o=t+e.TEXTURE0;if(o<e.TEXTURE0||o>n){const e=`[gl.TEXTURE0, gl.TEXTURE${n}]`;throw new Error(`textureUnit must be in ${e}.`)}}function getBatchDim(e,t=2){return n.sizeFromShape(e.slice(0,e.length-t))}function getRowsCols(e){if(e.length===0)throw Error("Cannot get rows and columns of an empty shape array.");return[e.length>1?e[e.length-2]:1,e[e.length-1]]}function getShapeAs3D(e){let t=[1,1,1];const n=e.length===0||e.length===1&&e[0]===1;n||(t=[getBatchDim(e),...getRowsCols(e)]);return t}function getTextureShapeFromLogicalShape(e,o=false){let a=t().getNumber("WEBGL_MAX_TEXTURE_SIZE");let r=t().getNumber("WEBGL_MAX_SIZE_FOR_NARROW_TEXTURE");r===Infinity&&t().getBool("WEBGL_AUTO_SQUARIFY_NARROW_TEXTURE_SHAPE")&&(r=a/2);if(o){a*=2;r*=2;e=e.map(((t,o)=>o>=e.length-2?n.nearestLargerEven(e[o]):e[o]));e.length===1&&(e=[2,e[0]])}if(e.length!==2){const t=n.squeezeShape(e);e=t.newShape}let s=n.sizeFromShape(e);let i=null;e.length<=1&&s<=a?i=[1,s]:e.length===2&&e[0]<=a&&e[1]<=a?i=e:e.length===3&&e[0]*e[1]<=a&&e[2]<=a?i=[e[0]*e[1],e[2]]:e.length===3&&e[0]<=a&&e[1]*e[2]<=a?i=[e[0],e[1]*e[2]]:e.length===4&&e[0]*e[1]*e[2]<=a&&e[3]<=a?i=[e[0]*e[1]*e[2],e[3]]:e.length===4&&e[0]<=a&&e[1]*e[2]*e[3]<=a&&(i=[e[0],e[1]*e[2]*e[3]]);const c=i!=null&&Math.max(...i)>r&&Math.min(...i)<=(o?2:1)&&Math.min(...i)>0;if(i==null||c)if(o){const t=getBatchDim(e);let o=2,a=2;e.length&&([o,a]=getRowsCols(e));s=t*(o/2)*(a/2);i=n.sizeToSquarishShape(s).map((e=>e*2))}else i=n.sizeToSquarishShape(s);return i}function isEven(e){return e%2===0}function isReshapeFree(e,t){e=e.slice(-2);t=t.slice(-2);if(n.arraysEqual(e,t))return true;if(!e.length||!t.length)return true;if(e[0]===0||e[1]===0||t[0]===0||t[1]===0)return true;if(e.length!==t.length){const n=e[e.length-1];const o=t[t.length-1];if(n===o)return true;if(isEven(n)&&isEven(o)&&(e[0]===1||t[0]===1))return true}return e[1]===t[1]&&isEven(e[0])&&isEven(t[0])}let Ln;let Bn;function getWebGLMaxTextureSize(e){if(Ln==null){const t=getWebGLContext(e);Ln=t.getParameter(t.MAX_TEXTURE_SIZE)}return Ln}function resetMaxTextureSize(){Ln=null}function resetMaxTexturesInShader(){Bn=null}function getMaxTexturesInShader(e){if(Bn==null){const t=getWebGLContext(e);Bn=t.getParameter(t.MAX_TEXTURE_IMAGE_UNITS)}return Math.min(16,Bn)}function getWebGLDisjointQueryTimerVersion(e){if(e===0)return 0;let t;const n=getWebGLContext(e);t=hasExtension(n,"EXT_disjoint_timer_query_webgl2")&&e===2?2:hasExtension(n,"EXT_disjoint_timer_query")?1:0;return t}function hasExtension(e,t){const n=e.getExtension(t);return n!=null}function isWebGLVersionEnabled(e){try{const t=getWebGLContext(e);if(t!=null)return true}catch(e){console.log("Error when getting WebGL context: ",e);return false}return false}function isCapableOfRenderingToFloatTexture(e){if(e===0)return false;const t=getWebGLContext(e);if(e===1){if(!hasExtension(t,"OES_texture_float"))return false}else if(!hasExtension(t,"EXT_color_buffer_float"))return false;const n=createFloatTextureAndBindToFramebuffer(t);return n}function isDownloadFloatTextureEnabled(e){if(e===0)return false;const t=getWebGLContext(e);if(e!==1){if(hasExtension(t,"EXT_color_buffer_float"))return createFloatTextureAndBindToFramebuffer(t);const e="EXT_color_buffer_half_float";if(hasExtension(t,e)){const n=t.getExtension(e);return createHalfFloatTextureAndBindToFramebuffer(t,n)}return false}if(!hasExtension(t,"OES_texture_float"))return false;if(!hasExtension(t,"WEBGL_color_buffer_float"))return false;const n=createFloatTextureAndBindToFramebuffer(t);return n}function createFloatTextureAndBindToFramebuffer(e){const t=getTextureConfig(e);const n=e.createTexture();e.bindTexture(e.TEXTURE_2D,n);const o=1;const a=1;e.texImage2D(e.TEXTURE_2D,0,t.internalFormatFloat,o,a,0,t.textureFormatFloat,t.textureTypeFloat,null);const r=e.createFramebuffer();e.bindFramebuffer(e.FRAMEBUFFER,r);e.framebufferTexture2D(e.FRAMEBUFFER,e.COLOR_ATTACHMENT0,e.TEXTURE_2D,n,0);const s=e.checkFramebufferStatus(e.FRAMEBUFFER)===e.FRAMEBUFFER_COMPLETE;e.bindTexture(e.TEXTURE_2D,null);e.bindFramebuffer(e.FRAMEBUFFER,null);e.deleteTexture(n);e.deleteFramebuffer(r);return s}function createHalfFloatTextureAndBindToFramebuffer(e,t){const n=getTextureConfig(e,t);const o=e.createTexture();e.bindTexture(e.TEXTURE_2D,o);const a=1;const r=1;e.texImage2D(e.TEXTURE_2D,0,n.internalFormatHalfFloat,a,r,0,n.textureFormatFloat,n.textureTypeHalfFloat,null);const s=e.createFramebuffer();e.bindFramebuffer(e.FRAMEBUFFER,s);e.framebufferTexture2D(e.FRAMEBUFFER,e.COLOR_ATTACHMENT0,e.TEXTURE_2D,o,0);const i=e.checkFramebufferStatus(e.FRAMEBUFFER)===e.FRAMEBUFFER_COMPLETE;e.bindTexture(e.TEXTURE_2D,null);e.bindFramebuffer(e.FRAMEBUFFER,null);e.deleteTexture(o);e.deleteFramebuffer(s);return i}function isWebGLFenceEnabled(e){if(e!==2)return false;const t=getWebGLContext(e);const n=t.fenceSync!=null;return n}function assertNotComplex(e,t){Array.isArray(e)||(e=[e]);e.forEach((e=>{e!=null&&n.assert(e.dtype!=="complex64",(()=>`${t} does not support complex64 tensors in the WebGL backend.`))}))}var Un=Object.freeze(Object.defineProperty({__proto__:null,assertNotComplex:assertNotComplex,bindCanvasToFramebuffer:bindCanvasToFramebuffer,bindColorTextureToFramebuffer:bindColorTextureToFramebuffer,bindTextureToProgramUniformSampler:bindTextureToProgramUniformSampler,bindTextureUnit:bindTextureUnit,bindVertexBufferToProgramAttribute:bindVertexBufferToProgramAttribute,callAndCheck:callAndCheck,canBeRepresented:canBeRepresented,createFragmentShader:createFragmentShader,createFramebuffer:createFramebuffer,createProgram:createProgram,createStaticIndexBuffer:createStaticIndexBuffer,createStaticVertexBuffer:createStaticVertexBuffer,createTexture:createTexture,createVertexShader:createVertexShader$1,getBatchDim:getBatchDim,getExtensionOrThrow:getExtensionOrThrow,getFramebufferErrorMessage:getFramebufferErrorMessage,getMaxTexturesInShader:getMaxTexturesInShader,getNumChannels:getNumChannels,getProgramUniformLocation:getProgramUniformLocation,getProgramUniformLocationOrThrow:getProgramUniformLocationOrThrow,getRowsCols:getRowsCols,getShapeAs3D:getShapeAs3D,getTextureShapeFromLogicalShape:getTextureShapeFromLogicalShape,getWebGLDisjointQueryTimerVersion:getWebGLDisjointQueryTimerVersion,getWebGLErrorMessage:getWebGLErrorMessage,getWebGLMaxTextureSize:getWebGLMaxTextureSize,hasExtension:hasExtension,isCapableOfRenderingToFloatTexture:isCapableOfRenderingToFloatTexture,isDownloadFloatTextureEnabled:isDownloadFloatTextureEnabled,isReshapeFree:isReshapeFree,isWebGLFenceEnabled:isWebGLFenceEnabled,isWebGLVersionEnabled:isWebGLVersionEnabled,linkProgram:linkProgram,logShaderSourceAndInfoLog:logShaderSourceAndInfoLog,resetMaxTextureSize:resetMaxTextureSize,resetMaxTexturesInShader:resetMaxTexturesInShader,unbindColorTextureFromFramebuffer:unbindColorTextureFromFramebuffer,unbindTextureUnit:unbindTextureUnit,validateFramebuffer:validateFramebuffer,validateProgram:validateProgram,validateTextureSize:validateTextureSize},Symbol.toStringTag,{value:"Module"}));
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */const Mn=t();Mn.registerFlag("HAS_WEBGL",(()=>Mn.getNumber("WEBGL_VERSION")>0));Mn.registerFlag("WEBGL_VERSION",(()=>isWebGLVersionEnabled(2)?2:isWebGLVersionEnabled(1)?1:0));Mn.registerFlag("WEBGL_CHECK_NUMERICAL_PROBLEMS",(()=>false));Mn.registerFlag("WEBGL_BUFFER_SUPPORTED",(()=>Mn.get("WEBGL_VERSION")===2));Mn.registerFlag("WEBGL_CPU_FORWARD",(()=>true));Mn.registerFlag("WEBGL_FORCE_F16_TEXTURES",(()=>false));Mn.registerFlag("WEBGL_PACK",(()=>Mn.getBool("HAS_WEBGL")));Mn.registerFlag("WEBGL_PACK_NORMALIZATION",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_CLIP",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_DEPTHWISECONV",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_BINARY_OPERATIONS",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_UNARY_OPERATIONS",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_ARRAY_OPERATIONS",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_IMAGE_OPERATIONS",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_REDUCE",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_LAZILY_UNPACK",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_CONV_IM2COL",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_PACK_CONV2DTRANSPOSE",(()=>Mn.getBool("WEBGL_PACK")));Mn.registerFlag("WEBGL_MAX_TEXTURE_SIZE",(()=>getWebGLMaxTextureSize(Mn.getNumber("WEBGL_VERSION"))));Mn.registerFlag("WEBGL_MAX_TEXTURES_IN_SHADER",(()=>getMaxTexturesInShader(Mn.getNumber("WEBGL_VERSION"))));Mn.registerFlag("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION",(()=>{const e=Mn.getNumber("WEBGL_VERSION");return e===0?0:getWebGLDisjointQueryTimerVersion(e)}));Mn.registerFlag("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_RELIABLE",(()=>Mn.getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION")>0&&!o.isMobile()));Mn.registerFlag("WEBGL_RENDER_FLOAT32_CAPABLE",(()=>isCapableOfRenderingToFloatTexture(Mn.getNumber("WEBGL_VERSION"))));Mn.registerFlag("WEBGL_RENDER_FLOAT32_ENABLED",(()=>!Mn.getBool("WEBGL_FORCE_F16_TEXTURES")&&Mn.getBool("WEBGL_RENDER_FLOAT32_CAPABLE")));Mn.registerFlag("WEBGL_DOWNLOAD_FLOAT_ENABLED",(()=>isDownloadFloatTextureEnabled(Mn.getNumber("WEBGL_VERSION"))));Mn.registerFlag("WEBGL_FENCE_API_ENABLED",(()=>isWebGLFenceEnabled(Mn.getNumber("WEBGL_VERSION"))));Mn.registerFlag("WEBGL_SIZE_UPLOAD_UNIFORM",(()=>{const e=Mn.getBool("WEBGL_RENDER_FLOAT32_ENABLED");return e?4:0}));Mn.registerFlag("WEBGL_DELETE_TEXTURE_THRESHOLD",(()=>-1),(e=>{if(!(typeof e==="number"))throw new Error(`WEBGL_DELETE_TEXTURE_THRESHOLD must be a number but got ${e}.`);if(e<0&&e!==-1)throw new Error(`WEBGL_DELETE_TEXTURE_THRESHOLD must be -1 (indicating never delete) or at least 0, but got ${e}.`)}));Mn.registerFlag("WEBGL_FLUSH_THRESHOLD",(()=>o.isMobile()?1:-1),(e=>{if(!(typeof e==="number"))throw new Error(`WEBGL_FLUSH_THRESHOLD must be a number but got ${e}.`);if(e<0&&e!==-1)throw new Error(`WEBGL_FLUSH_THRESHOLD must be -1 (indicating never manual flush) or at least 0, but got ${e}.`)}));Mn.registerFlag("CPU_HANDOFF_SIZE_THRESHOLD",(()=>128));Mn.registerFlag("WEBGL_USE_SHAPES_UNIFORMS",(()=>false));Mn.registerFlag("TOPK_LAST_DIM_CPU_HANDOFF_SIZE_THRESHOLD",(()=>1e5));Mn.registerFlag("TOPK_K_CPU_HANDOFF_THRESHOLD",(()=>128));Mn.registerFlag("WEBGL_EXP_CONV",(()=>false));Mn.registerFlag("SOFTWARE_WEBGL_ENABLED",(()=>Mn.getBool("IS_TEST")));Mn.registerFlag("WEBGL_MAX_SIZE_FOR_NARROW_TEXTURE",(()=>Infinity));Mn.registerFlag("WEBGL_AUTO_SQUARIFY_NARROW_TEXTURE_SHAPE",(()=>false));Mn.registerFlag("WEBGL2_ISNAN_CUSTOM",(()=>false));Mn.registerFlag("ENGINE_COMPILE_ONLY",(()=>false));
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */function getGlslDifferences(){let e;let n;let o;let a;let r;let s;let i;let c;let l;let u;if(t().getNumber("WEBGL_VERSION")===2){e="#version 300 es";n="in";o="out";a="in";r="texture";s="outputColor";i="out vec4 outputColor;";c=t().getBool("WEBGL2_ISNAN_CUSTOM")?"\n      bool isnan_custom(float val) {\n        uint floatToUint = floatBitsToUint(val);\n        return (floatToUint & 0x7fffffffu) > 0x7f800000u;\n      }\n\n      bvec4 isnan_custom(vec4 val) {\n        return bvec4(isnan_custom(val.x),\n          isnan_custom(val.y), isnan_custom(val.z), isnan_custom(val.w));\n      }\n\n      #define isnan(value) isnan_custom(value)\n    ":"";l="";u="\n      #define round(value) newRound(value)\n      int newRound(float value) {\n        return int(floor(value + 0.5));\n      }\n\n      ivec4 newRound(vec4 value) {\n        return ivec4(floor(value + vec4(0.5)));\n      }\n    "}else{e="";n="attribute";o="varying";a="varying";r="texture2D";s="gl_FragColor";i="";c="\n      #define isnan(value) isnan_custom(value)\n      bool isnan_custom(float val) {\n        return (val > 0. || val < 1. || val == 0.) ? false : true;\n      }\n      bvec4 isnan_custom(vec4 val) {\n        return bvec4(isnan(val.x), isnan(val.y), isnan(val.z), isnan(val.w));\n      }\n    ";l="\n      uniform float INFINITY;\n\n      bool isinf(float val) {\n        return abs(val) == INFINITY;\n      }\n      bvec4 isinf(vec4 val) {\n        return equal(abs(val), vec4(INFINITY));\n      }\n    ";u="\n      int round(float value) {\n        return int(floor(value + 0.5));\n      }\n\n      ivec4 round(vec4 value) {\n        return ivec4(floor(value + vec4(0.5)));\n      }\n    "}return{version:e,attribute:n,varyingVs:o,varyingFs:a,texture2D:r,output:s,defineOutput:i,defineSpecialNaN:c,defineSpecialInf:l,defineRound:u}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */function getLogicalCoordinatesFromFlatIndex(e,t,o="index"){const a=n.computeStrides(t);return a.map(((t,n)=>{const r=`int ${e[n]} = ${o} / ${t}`;const s=n===a.length-1?`int ${e[n+1]} = ${o} - ${e[n]} * ${t}`:`index -= ${e[n]} * ${t}`;return`${r}; ${s};`})).join("")}function getOutputLogicalCoordinatesFromFlatIndexByUniform(e,t,o="index"){const a=n.computeStrides(t);return a.map(((t,n)=>{const r=`int ${e[n]} = ${o} / outShapeStrides[${n}]`;const s=n===a.length-1?`int ${e[n+1]} = ${o} - ${e[n]} * outShapeStrides[${n}]`:`index -= ${e[n]} * outShapeStrides[${n}]`;return`${r}; ${s};`})).join("")}function symbolicallyComputeStrides(e,t){const n=e.length;const o=e.map((e=>`${t}[${e}]`));const a=new Array(n-1);a[n-2]=o[n-1];for(let e=n-3;e>=0;--e)a[e]=`(${a[e+1]} * ${o[e+1]})`;return a}function getLogicalCoordinatesFromFlatIndexByUniform(e,t,n="index"){const o=e.map(((e,t)=>t));const a=symbolicallyComputeStrides(o,t);return a.map(((t,o)=>{const r=`int ${e[o]} = ${n} / ${a[o]}`;const s=o===a.length-1?`int ${e[o+1]} = ${n} - ${e[o]} * ${a[o]}`:`index -= ${e[o]} * ${a[o]}`;return`${r}; ${s};`})).join("")}function getFlatIndexFrom3D(e){const t=n.computeStrides(e).map((e=>e.toString()));return`\n  int getFlatIndex(ivec3 coords) {\n    return coords.x * ${t[0]} + coords.y * ${t[1]} + coords.z;\n  }\n`}function getFlatIndexFrom3DOutput(){return"\n  int getFlatIndex(ivec3 coords) {\n    return coords.x * outShapeStrides[0] + coords.y * outShapeStrides[1] + coords.z;\n  }\n"}const Vn="\n  const float FLOAT_MAX = 1.70141184e38;\n  const float FLOAT_MIN = 1.17549435e-38;\n\n  lowp vec4 encode_float(highp float v) {\n    if (isnan(v)) {\n      return vec4(255, 255, 255, 255);\n    }\n\n    highp float av = abs(v);\n\n    if(av < FLOAT_MIN) {\n      return vec4(0.0, 0.0, 0.0, 0.0);\n    } else if(v > FLOAT_MAX) {\n      return vec4(0.0, 0.0, 128.0, 127.0) / 255.0;\n    } else if(v < -FLOAT_MAX) {\n      return vec4(0.0, 0.0,  128.0, 255.0) / 255.0;\n    }\n\n    highp vec4 c = vec4(0,0,0,0);\n\n    highp float e = floor(log2(av));\n    highp float m = exp2(fract(log2(av))) - 1.0;\n\n    c[2] = floor(128.0 * m);\n    m -= c[2] / 128.0;\n    c[1] = floor(32768.0 * m);\n    m -= c[1] / 32768.0;\n    c[0] = floor(8388608.0 * m);\n\n    highp float ebias = e + 127.0;\n    c[3] = floor(ebias / 2.0);\n    ebias -= c[3] * 2.0;\n    c[2] += floor(ebias) * 128.0;\n\n    c[3] += 128.0 * step(0.0, -v);\n\n    return c / 255.0;\n  }\n";
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */const{getBroadcastDims:Wn}=a;function makeShader(e,t,o){const a=[];e.forEach((e=>{const t=n.sizeFromShape(e.shapeInfo.logicalShape);if(e.shapeInfo.isUniform)a.push(`uniform float ${e.name}${t>1?`[${t}]`:""};`);else{a.push(`uniform sampler2D ${e.name};`);a.push(`uniform int offset${e.name};`)}if(o.enableShapeUniforms){const{uniformShape:t}=getUniformInfoFromShape(o.packedInputs,e.shapeInfo.logicalShape,e.shapeInfo.texShape);switch(t.length){case 1:a.push(`uniform int ${e.name}Shape;`);break;case 2:a.push(`uniform ivec2 ${e.name}Shape;`);break;case 3:a.push(`uniform ivec3 ${e.name}Shape;`);break;case 4:a.push(`uniform ivec4 ${e.name}Shape;`);break;default:break}a.push(`uniform ivec2 ${e.name}TexShape;`)}}));if(o.enableShapeUniforms){switch(t.logicalShape.length){case 1:a.push("uniform int outShape;");break;case 2:a.push("uniform ivec2 outShape;");a.push("uniform int outShapeStrides;");break;case 3:a.push("uniform ivec3 outShape;");a.push("uniform ivec2 outShapeStrides;");break;case 4:a.push("uniform ivec4 outShape;");a.push("uniform ivec3 outShapeStrides;");break;default:break}a.push("uniform ivec2 outTexShape;")}o.customUniforms&&o.customUniforms.forEach((e=>{a.push(`uniform ${e.type} ${e.name}${e.arrayIndex?`[${e.arrayIndex}]`:""};`)}));const r=a.join("\n");const s=e.map((e=>getInputSamplingSnippet(e,t,o.packedInputs,o.enableShapeUniforms))).join("\n");const i=t.texShape;const c=getGlslDifferences();const l=getFloatTextureSampleSnippet(c);let u;let d;let p=getShaderPrefix(c);if(t.isPacked){u=getPackedOutputSamplingSnippet(t.logicalShape,i,o.enableShapeUniforms);d=getFloatTextureSetRGBASnippet(c)}else{u=getOutputSamplingSnippet(t.logicalShape,i,o.enableShapeUniforms);d=getFloatTextureSetRSnippet(c)}o.packedInputs&&(p+=Hn);const h=[p,l,d,r,u,s,o.userCode].join("\n");return h}function getSamplerFromInInfo(e,t=false){const n=e.shapeInfo.logicalShape;switch(n.length){case 0:return getSamplerScalar(e,t);case 1:return getSampler1D(e,t);case 2:return getSampler2D(e,t);case 3:return getSampler3D(e,t);case 4:return getSampler4D(e,t);case 5:return getSampler5D(e);case 6:return getSampler6D(e);default:throw new Error(`${n.length}-D input sampling is not yet supported`)}}function getPackedSamplerFromInInfo(e,t){const n=e.shapeInfo.logicalShape;switch(n.length){case 0:return getPackedSamplerScalar(e);case 1:return getPackedSampler1D(e,t);case 2:return getPackedSampler2D(e,t);case 3:return getPackedSampler3D(e,t);default:return getPackedSamplerND(e,t)}}function getInputSamplingSnippet(e,t,n=false,o){let a="";a+=n?getPackedSamplerFromInInfo(e,o):getSamplerFromInInfo(e,o);const r=e.shapeInfo.logicalShape;const s=t.logicalShape;r.length<=s.length&&(a+=n?getPackedSamplerAtOutputCoords(e,t):getSamplerAtOutputCoords(e,t));return a}function getPackedOutputSamplingSnippet(e,t,n){switch(e.length){case 0:return getOutputScalarCoords();case 1:return getOutputPacked1DCoords(e,t,n);case 2:return getOutputPacked2DCoords(e,t,n);case 3:return getOutputPacked3DCoords(e,t,n);default:return getOutputPackedNDCoords(e,t,n)}}function getOutputSamplingSnippet(e,t,n){switch(e.length){case 0:return getOutputScalarCoords();case 1:return getOutput1DCoords(e,t,n);case 2:return getOutput2DCoords(e,t,n);case 3:return getOutput3DCoords(e,t,n);case 4:return getOutput4DCoords(e,t,n);case 5:return getOutput5DCoords(e,t);case 6:return getOutput6DCoords(e,t);default:throw new Error(`${e.length}-D output sampling is not yet supported`)}}function getFloatTextureSampleSnippet(e){return`\n    float sampleTexture(sampler2D textureSampler, vec2 uv) {\n      return ${e.texture2D}(textureSampler, uv).r;\n    }\n  `}function getFloatTextureSetRSnippet(e){return`\n    void setOutput(float val) {\n      ${e.output} = vec4(val, 0, 0, 0);\n    }\n  `}function getFloatTextureSetRGBASnippet(e){return`\n    void setOutput(vec4 val) {\n      ${e.output} = val;\n    }\n  `}function getShaderPrefix(e){const t=`${e.version}\n    precision highp float;\n    precision highp int;\n    precision highp sampler2D;\n    ${e.varyingFs} vec2 resultUV;\n    ${e.defineOutput}\n    const vec2 halfCR = vec2(0.5, 0.5);\n\n    struct ivec5\n    {\n      int x;\n      int y;\n      int z;\n      int w;\n      int u;\n    };\n\n    struct ivec6\n    {\n      int x;\n      int y;\n      int z;\n      int w;\n      int u;\n      int v;\n    };\n\n    uniform float NAN;\n    ${e.defineSpecialNaN}\n    ${e.defineSpecialInf}\n    ${e.defineRound}\n\n    int imod(int x, int y) {\n      return x - y * (x / y);\n    }\n\n    int idiv(int a, int b, float sign) {\n      int res = a / b;\n      int mod = imod(a, b);\n      if (sign < 0. && mod != 0) {\n        res -= 1;\n      }\n      return res;\n    }\n\n    //Based on the work of Dave Hoskins\n    //https://www.shadertoy.com/view/4djSRW\n    #define HASHSCALE1 443.8975\n    float random(float seed){\n      vec2 p = resultUV * seed;\n      vec3 p3  = fract(vec3(p.xyx) * HASHSCALE1);\n      p3 += dot(p3, p3.yzx + 19.19);\n      return fract((p3.x + p3.y) * p3.z);\n    }\n\n    ${Gn}\n    ${zn}\n    ${Xn}\n  `;return t}const Gn="\nvec2 uvFromFlat(int texNumR, int texNumC, int index) {\n  int texR = index / texNumC;\n  int texC = index - texR * texNumC;\n  return (vec2(texC, texR) + halfCR) / vec2(texNumC, texNumR);\n}\nvec2 packedUVfrom1D(int texNumR, int texNumC, int index) {\n  int texelIndex = index / 2;\n  int texR = texelIndex / texNumC;\n  int texC = texelIndex - texR * texNumC;\n  return (vec2(texC, texR) + halfCR) / vec2(texNumC, texNumR);\n}\n";const zn="\nvec2 packedUVfrom2D(int texelsInLogicalRow, int texNumR,\n  int texNumC, int row, int col) {\n  int texelIndex = (row / 2) * texelsInLogicalRow + (col / 2);\n  int texR = texelIndex / texNumC;\n  int texC = texelIndex - texR * texNumC;\n  return (vec2(texC, texR) + halfCR) / vec2(texNumC, texNumR);\n}\n";const Xn="\nvec2 packedUVfrom3D(int texNumR, int texNumC,\n    int texelsInBatch, int texelsInLogicalRow, int b,\n    int row, int col) {\n  int index = b * texelsInBatch + (row / 2) * texelsInLogicalRow + (col / 2);\n  int texR = index / texNumC;\n  int texC = index - texR * texNumC;\n  return (vec2(texC, texR) + halfCR) / vec2(texNumC, texNumR);\n}\n";const Hn="\n  float getChannel(vec4 frag, vec2 innerDims) {\n    vec2 modCoord = mod(innerDims, 2.);\n    return modCoord.x == 0. ?\n      (modCoord.y == 0. ? frag.r : frag.g) :\n      (modCoord.y == 0. ? frag.b : frag.a);\n  }\n  float getChannel(vec4 frag, int dim) {\n    float modCoord = mod(float(dim), 2.);\n    return modCoord == 0. ? frag.r : frag.g;\n  }\n";function getOutputScalarCoords(){return"\n    int getOutputCoords() {\n      return 0;\n    }\n  "}function getOutputPacked1DCoords(e,t,n){const o=[Math.ceil(t[0]/2),Math.ceil(t[1]/2)];return o[0]===1?n?"\n      int getOutputCoords() {\n        return 2 * int(resultUV.x * ceil(float(outTexShape[1]) / 2.0));\n      }\n    ":`\n      int getOutputCoords() {\n        return 2 * int(resultUV.x * ${o[1]}.0);\n      }\n    `:o[1]===1?n?"\n      int getOutputCoords() {\n        return 2 * int(resultUV.y * ceil(float(outTexShape[0]) / 2.0));\n      }\n    ":`\n      int getOutputCoords() {\n        return 2 * int(resultUV.y * ${o[0]}.0);\n      }\n    `:n?"\n    int getOutputCoords() {\n      ivec2 packedTexShape = ivec2(ceil(float(outTexShape[0]) / 2.0), ceil(float(outTexShape[1]) / 2.0));\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(packedTexShape[0], packedTexShape[1]));\n      return 2 * (resTexRC.x * packedTexShape[1] + resTexRC.y);\n    }\n  ":`\n    int getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(${o[0]}, ${o[1]}));\n      return 2 * (resTexRC.x * ${o[1]} + resTexRC.y);\n    }\n  `}function getOutput1DCoords(e,t,n){return t[0]===1?n?"\n      int getOutputCoords() {\n        return int(resultUV.x * float(outTexShape[1]));\n      }\n    ":`\n      int getOutputCoords() {\n        return int(resultUV.x * ${t[1]}.0);\n      }\n    `:t[1]===1?n?"\n      int getOutputCoords() {\n        return int(resultUV.y * float(outTexShape[0]));\n      }\n    ":`\n      int getOutputCoords() {\n        return int(resultUV.y * ${t[0]}.0);\n      }\n    `:n?"\n    int getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(outTexShape[0], outTexShape[1]));\n      return resTexRC.x * outTexShape[1] + resTexRC.y;\n    }\n  ":`\n    int getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(${t[0]}, ${t[1]}));\n      return resTexRC.x * ${t[1]} + resTexRC.y;\n    }\n  `}function getOutputPacked3DCoords(e,t,n){if(n)return"\n    ivec3 getOutputCoords() {\n      ivec2 packedTexShape = ivec2(ceil(float(outTexShape[0]) / 2.0), ceil(float(outTexShape[1]) / 2.0));\n      int texelsInLogicalRow = int(ceil(float(outShape[2]) / 2.0));\n      int texelsInBatch = texelsInLogicalRow * int(ceil(float(outShape[1]) / 2.0));\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(packedTexShape[0], packedTexShape[1]));\n      int index = resTexRC.x * packedTexShape[1] + resTexRC.y;\n\n      int b = index / texelsInBatch;\n      index -= b * texelsInBatch;\n\n      int r = 2 * (index / texelsInLogicalRow);\n      int c = imod(index, texelsInLogicalRow) * 2;\n\n      return ivec3(b, r, c);\n    }\n  ";const o=[Math.ceil(t[0]/2),Math.ceil(t[1]/2)];const a=Math.ceil(e[2]/2);const r=a*Math.ceil(e[1]/2);return`\n    ivec3 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(${o[0]}, ${o[1]}));\n      int index = resTexRC.x * ${o[1]} + resTexRC.y;\n\n      int b = index / ${r};\n      index -= b * ${r};\n\n      int r = 2 * (index / ${a});\n      int c = imod(index, ${a}) * 2;\n\n      return ivec3(b, r, c);\n    }\n  `}function getOutput3DCoords(e,t,n){if(n){const t=getOutputLogicalCoordinatesFromFlatIndexByUniform(["r","c","d"],e);return`\n  ivec3 getOutputCoords() {\n    ivec2 resTexRC = ivec2(resultUV.yx *\n                           vec2(outTexShape[0], outTexShape[1]));\n    int index = resTexRC.x * outTexShape[1] + resTexRC.y;\n    ${t}\n    return ivec3(r, c, d);\n  }\n`}const o=getLogicalCoordinatesFromFlatIndex(["r","c","d"],e);return`\n    ivec3 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(${t[0]}, ${t[1]}));\n      int index = resTexRC.x * ${t[1]} + resTexRC.y;\n      ${o}\n      return ivec3(r, c, d);\n    }\n  `}function getOutputPackedNDCoords(e,t,n){if(n)return"\n    ivec4 getOutputCoords() {\n      ivec2 packedTexShape = ivec2(ceil(float(outTexShape[0]) / 2.0), ceil(float(outTexShape[1]) / 2.0));\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(packedTexShape[0], packedTexShape[1]));\n      int index = resTexRC.x * packedTexShape[1] + resTexRC.y;\n\n      int texelsInLogicalRow = int(ceil(float(outShape[3]) / 2.0));\n      int texelsInBatch = texelsInLogicalRow * int(ceil(float(outShape[2]) / 2.0));\n      int texelsInBatchN = texelsInBatch * outShape[1];\n\n      int b2 = index / texelsInBatchN;\n      index -= b2 * texelsInBatchN;\n\n      int b = index / texelsInBatch;\n      index -= b * texelsInBatch;\n\n      int r = 2 * (index / texelsInLogicalRow);\n      int c = imod(index, texelsInLogicalRow) * 2;\n\n      return ivec4(b2, b, r, c);\n    }\n  ";const o=[Math.ceil(t[0]/2),Math.ceil(t[1]/2)];const a=Math.ceil(e[e.length-1]/2);const r=a*Math.ceil(e[e.length-2]/2);let s=r;let i="";let c="b, r, c";for(let t=2;t<e.length-1;t++){s*=e[e.length-t-1];i=`\n      int b${t} = index / ${s};\n      index -= b${t} * ${s};\n    `+i;c=`b${t}, `+c}return`\n    ivec${e.length} getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(${o[0]}, ${o[1]}));\n      int index = resTexRC.x * ${o[1]} + resTexRC.y;\n\n      ${i}\n\n      int b = index / ${r};\n      index -= b * ${r};\n\n      int r = 2 * (index / ${a});\n      int c = imod(index, ${a}) * 2;\n\n      return ivec${e.length}(${c});\n    }\n  `}function getOutput4DCoords(e,t,n){if(n){const t=getOutputLogicalCoordinatesFromFlatIndexByUniform(["r","c","d","d2"],e);return`\n    ivec4 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n        vec2(outTexShape[0], outTexShape[1]));\n      int index = resTexRC.x * outTexShape[1] + resTexRC.y;\n      ${t}\n      return ivec4(r, c, d, d2);\n    }\n  `}const o=getLogicalCoordinatesFromFlatIndex(["r","c","d","d2"],e);return`\n    ivec4 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n        vec2(${t[0]}, ${t[1]}));\n      int index = resTexRC.x * ${t[1]} + resTexRC.y;\n      ${o}\n      return ivec4(r, c, d, d2);\n    }\n  `}function getOutput5DCoords(e,t){const n=getLogicalCoordinatesFromFlatIndex(["r","c","d","d2","d3"],e);return`\n    ivec5 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx * vec2(${t[0]},\n                             ${t[1]}));\n\n      int index = resTexRC.x * ${t[1]} + resTexRC.y;\n\n      ${n}\n\n      ivec5 outShape = ivec5(r, c, d, d2, d3);\n      return outShape;\n    }\n  `}function getOutput6DCoords(e,t){const n=getLogicalCoordinatesFromFlatIndex(["r","c","d","d2","d3","d4"],e);return`\n    ivec6 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n        vec2(${t[0]}, ${t[1]}));\n      int index = resTexRC.x * ${t[1]} + resTexRC.y;\n\n      ${n}\n\n      ivec6 result = ivec6(r, c, d, d2, d3, d4);\n      return result;\n    }\n  `}function getOutputPacked2DCoords(e,t,o){const a=[Math.ceil(t[0]/2),Math.ceil(t[1]/2)];if(n.arraysEqual(e,t))return o?"\n      ivec2 getOutputCoords() {\n        ivec2 packedTexShape = ivec2(ceil(float(outTexShape[0]) / 2.0), ceil(float(outTexShape[1]) / 2.0));\n        return 2 * ivec2(resultUV.yx * vec2(packedTexShape[0], packedTexShape[1]));\n      }\n    ":`\n      ivec2 getOutputCoords() {\n        return 2 * ivec2(resultUV.yx * vec2(${a[0]}, ${a[1]}));\n      }\n    `;const r=Math.ceil(e[1]/2);return o?"\n    ivec2 getOutputCoords() {\n      ivec2 packedTexShape = ivec2(ceil(float(outTexShape[0]) / 2.0), ceil(float(outTexShape[1]) / 2.0));\n      int texelsInLogicalRow = int(ceil(float(outShape[1]) / 2.0));\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(packedTexShape[0], packedTexShape[1]));\n\n      int index = resTexRC.x * packedTexShape[1] + resTexRC.y;\n      int r = 2 * (index / texelsInLogicalRow);\n      int c = imod(index, texelsInLogicalRow) * 2;\n\n      return ivec2(r, c);\n    }\n  ":`\n    ivec2 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(${a[0]}, ${a[1]}));\n\n      int index = resTexRC.x * ${a[1]} + resTexRC.y;\n      int r = 2 * (index / ${r});\n      int c = imod(index, ${r}) * 2;\n\n      return ivec2(r, c);\n    }\n  `}function getOutput2DCoords(e,t,o){return n.arraysEqual(e,t)?o?"\n      ivec2 getOutputCoords() {\n        return ivec2(resultUV.yx * vec2(outTexShape[0], outTexShape[1]));\n      }\n    ":`\n      ivec2 getOutputCoords() {\n        return ivec2(resultUV.yx * vec2(${t[0]}, ${t[1]}));\n      }\n    `:e[1]===1?o?"\n      ivec2 getOutputCoords() {\n        ivec2 resTexRC = ivec2(resultUV.yx *\n                               vec2(outTexShape[0], outTexShape[1]));\n        int index = resTexRC.x * outTexShape[1] + resTexRC.y;\n        return ivec2(index, 0);\n      }\n    ":`\n      ivec2 getOutputCoords() {\n        ivec2 resTexRC = ivec2(resultUV.yx *\n                               vec2(${t[0]}, ${t[1]}));\n        int index = resTexRC.x * ${t[1]} + resTexRC.y;\n        return ivec2(index, 0);\n      }\n    `:e[0]===1?o?"\n      ivec2 getOutputCoords() {\n        ivec2 resTexRC = ivec2(resultUV.yx *\n                               vec2(outTexShape[0], outTexShape[1]));\n        int index = resTexRC.x * outTexShape[1] + resTexRC.y;\n        return ivec2(0, index);\n      }\n    ":`\n      ivec2 getOutputCoords() {\n        ivec2 resTexRC = ivec2(resultUV.yx *\n                               vec2(${t[0]}, ${t[1]}));\n        int index = resTexRC.x * ${t[1]} + resTexRC.y;\n        return ivec2(0, index);\n      }\n    `:o?"\n    ivec2 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(outTexShape[0], outTexShape[1]));\n      int index = resTexRC.x * outTexShape[1] + resTexRC.y;\n      int r = index / outShape[1];\n      int c = index - r * outShape[1];\n      return ivec2(r, c);\n    }\n  ":`\n    ivec2 getOutputCoords() {\n      ivec2 resTexRC = ivec2(resultUV.yx *\n                             vec2(${t[0]}, ${t[1]}));\n      int index = resTexRC.x * ${t[1]} + resTexRC.y;\n      int r = index / ${e[1]};\n      int c = index - r * ${e[1]};\n      return ivec2(r, c);\n    }\n  `}function getFlatOffsetUniformName(e){return`offset${e}`}function getPackedSamplerScalar(e){const t=e.name;const n="get"+t.charAt(0).toUpperCase()+t.slice(1);const o=getGlslDifferences();return`\n    vec4 ${n}() {\n      return ${o.texture2D}(${t}, halfCR);\n    }\n  `}function getSamplerScalar(e,t){const n=e.name;const o="get"+n.charAt(0).toUpperCase()+n.slice(1);if(e.shapeInfo.isUniform)return`float ${o}() {return ${n};}`;const[a,r]=e.shapeInfo.texShape;if(a===1&&r===1)return`\n      float ${o}() {\n        return sampleTexture(${n}, halfCR);\n      }\n    `;const s=getFlatOffsetUniformName(n);if(t)return`\n    float ${o}() {\n      vec2 uv = uvFromFlat(${n}TexShape[0], ${n}TexShape[1], ${s});\n      return sampleTexture(${n}, uv);\n    }\n  `;const[i,c]=e.shapeInfo.texShape;return`\n    float ${o}() {\n      vec2 uv = uvFromFlat(${i}, ${c}, ${s});\n      return sampleTexture(${n}, uv);\n    }\n  `}function getPackedSampler1D(e,t){const n=e.name;const o="get"+n.charAt(0).toUpperCase()+n.slice(1);const a=e.shapeInfo.texShape;const r=getGlslDifferences();if(t)return`\n    vec4 ${o}(int index) {\n      ivec2 packedTexShape = ivec2(ceil(float(${n}TexShape[0]) / 2.0), ceil(float(${n}TexShape[1]) / 2.0));\n      vec2 uv = packedUVfrom1D(\n        packedTexShape[0], packedTexShape[1], index);\n      return ${r.texture2D}(${n}, uv);\n    }\n  `;const s=[Math.ceil(a[0]/2),Math.ceil(a[1]/2)];return`\n    vec4 ${o}(int index) {\n      vec2 uv = packedUVfrom1D(\n        ${s[0]}, ${s[1]}, index);\n      return ${r.texture2D}(${n}, uv);\n    }\n  `}function getSampler1D(e,t){const n=e.name;const o="get"+n.charAt(0).toUpperCase()+n.slice(1);if(e.shapeInfo.isUniform)return`\n      float ${o}(int index) {\n        ${getUniformSampler(e)}\n      }\n    `;const a=e.shapeInfo.texShape;const r=a[0];const s=a[1];if(s===1&&r===1)return`\n      float ${o}(int index) {\n        return sampleTexture(${n}, halfCR);\n      }\n    `;const i=getFlatOffsetUniformName(n);return s===1?t?`\n      float ${o}(int index) {\n        vec2 uv = vec2(0.5, (float(index + ${i}) + 0.5) / float(${n}TexShape[0]));\n        return sampleTexture(${n}, uv);\n      }\n    `:`\n      float ${o}(int index) {\n        vec2 uv = vec2(0.5, (float(index + ${i}) + 0.5) / ${r}.0);\n        return sampleTexture(${n}, uv);\n      }\n    `:r===1?t?`\n      float ${o}(int index) {\n        vec2 uv = vec2((float(index + ${i}) + 0.5) / float(${n}TexShape[1]), 0.5);\n        return sampleTexture(${n}, uv);\n      }\n    `:`\n      float ${o}(int index) {\n        vec2 uv = vec2((float(index + ${i}) + 0.5) / ${s}.0, 0.5);\n        return sampleTexture(${n}, uv);\n      }\n    `:t?`\n    float ${o}(int index) {\n      vec2 uv = uvFromFlat(${n}TexShape[0], ${n}TexShape[1], index + ${i});\n      return sampleTexture(${n}, uv);\n    }\n  `:`\n    float ${o}(int index) {\n      vec2 uv = uvFromFlat(${r}, ${s}, index + ${i});\n      return sampleTexture(${n}, uv);\n    }\n  `}function getPackedSampler2D(e,t){const o=e.shapeInfo.logicalShape;const a=e.name;const r="get"+a.charAt(0).toUpperCase()+a.slice(1);const s=e.shapeInfo.texShape;const i=s[0];const c=s[1];const l=getGlslDifferences();if(s!=null&&n.arraysEqual(o,s))return t?`\n      vec4 ${r}(int row, int col) {\n        vec2 uv = (vec2(col, row) + halfCR) / vec2(${a}TexShape[1], ${a}TexShape[0]);\n\n        return ${l.texture2D}(${a}, uv);\n      }\n    `:`\n      vec4 ${r}(int row, int col) {\n        vec2 uv = (vec2(col, row) + halfCR) / vec2(${c}.0, ${i}.0);\n\n        return ${l.texture2D}(${a}, uv);\n      }\n    `;if(t)return`\n    vec4 ${r}(int row, int col) {\n      ivec2 packedTexShape = ivec2(ceil(float(${a}TexShape[0]) / 2.0), ceil(float(${a}TexShape[1]) / 2.0));\n      int valuesPerRow = int(ceil(float(${a}Shape[1]) / 2.0));\n      vec2 uv = packedUVfrom2D(valuesPerRow, packedTexShape[0], packedTexShape[1], row, col);\n      return ${l.texture2D}(${a}, uv);\n    }\n  `;const u=[Math.ceil(s[0]/2),Math.ceil(s[1]/2)];const d=Math.ceil(o[1]/2);return`\n    vec4 ${r}(int row, int col) {\n      vec2 uv = packedUVfrom2D(${d}, ${u[0]}, ${u[1]}, row, col);\n      return ${l.texture2D}(${a}, uv);\n    }\n  `}function getSampler2D(e,t){const o=e.shapeInfo.logicalShape;const a=e.name;const r="get"+a.charAt(0).toUpperCase()+a.slice(1);const s=e.shapeInfo.texShape;if(s!=null&&n.arraysEqual(o,s)){if(t)return`\n      float ${r}(int row, int col) {\n        vec2 uv = (vec2(col, row) + halfCR) / vec2(${a}TexShape[1], ${a}TexShape[0]);\n        return sampleTexture(${a}, uv);\n      }\n    `;const e=s[0];const n=s[1];return`\n    float ${r}(int row, int col) {\n      vec2 uv = (vec2(col, row) + halfCR) / vec2(${n}.0, ${e}.0);\n      return sampleTexture(${a}, uv);\n    }\n  `}const{newShape:i,keptDims:c}=n.squeezeShape(o);const l=i;if(l.length<o.length){const n=squeezeInputInfo(e,l);const o=["row","col"];return`\n      ${getSamplerFromInInfo(n,t)}\n      float ${r}(int row, int col) {\n        return ${r}(${getSqueezedParams(o,c)});\n      }\n    `}if(e.shapeInfo.isUniform)return`\n      float ${r}(int row, int col) {\n        int index = round(dot(vec2(row, col), vec2(${o[1]}, 1)));\n        ${getUniformSampler(e)}\n      }\n    `;const u=s[0];const d=s[1];const p=getFlatOffsetUniformName(a);return d===1?t?`\n      float ${r}(int row, int col) {\n        float index = dot(vec3(row, col, ${p}), vec3(${a}Shape[1], 1, 1));\n        vec2 uv = vec2(0.5, (index + 0.5) / float(${a}TexShape[0]));\n        return sampleTexture(${a}, uv);\n      }\n    `:`\n    float ${r}(int row, int col) {\n      float index = dot(vec3(row, col, ${p}), vec3(${o[1]}, 1, 1));\n      vec2 uv = vec2(0.5, (index + 0.5) / ${u}.0);\n      return sampleTexture(${a}, uv);\n    }\n  `:u===1?t?`\n      float ${r}(int row, int col) {\n        float index = dot(vec3(row, col, ${p}), vec3(${a}Shape[1], 1, 1));\n        vec2 uv = vec2((index + 0.5) / float(${a}TexShape[1]), 0.5);\n        return sampleTexture(${a}, uv);\n      }\n    `:`\n    float ${r}(int row, int col) {\n      float index = dot(vec3(row, col, ${p}), vec3(${o[1]}, 1, 1));\n      vec2 uv = vec2((index + 0.5) / ${d}.0, 0.5);\n      return sampleTexture(${a}, uv);\n    }\n  `:t?`\n      float ${r}(int row, int col) {\n        // Explicitly use integer operations as dot() only works on floats.\n        int index = row * ${a}Shape[1] + col + ${p};\n        vec2 uv = uvFromFlat(${a}TexShape[0], ${a}TexShape[1], index);\n        return sampleTexture(${a}, uv);\n      }\n    `:`\n  float ${r}(int row, int col) {\n    // Explicitly use integer operations as dot() only works on floats.\n    int index = row * ${o[1]} + col + ${p};\n    vec2 uv = uvFromFlat(${u}, ${d}, index);\n    return sampleTexture(${a}, uv);\n  }\n`}function getPackedSampler3D(e,t){const n=e.shapeInfo.logicalShape;const o=e.name;const a="get"+o.charAt(0).toUpperCase()+o.slice(1);const r=e.shapeInfo.texShape;const s=[Math.ceil(r[0]/2),Math.ceil(r[1]/2)];if(n[0]===1){const o=n.slice(1);const r=[1,2];const s=squeezeInputInfo(e,o);const i=["b","row","col"];return`\n        ${getPackedSamplerFromInInfo(s,t)}\n        vec4 ${a}(int b, int row, int col) {\n          return ${a}(${getSqueezedParams(i,r)});\n        }\n      `}const i=getGlslDifferences();if(t)return`\n    vec4 ${a}(int b, int row, int col) {\n      ivec2 packedTexShape = ivec2(ceil(float(${o}TexShape[0]) / 2.0), ceil(float(${o}TexShape[1]) / 2.0));\n      int valuesPerRow = int(ceil(float(${o}Shape[2]) / 2.0));\n      int texelsInBatch = valuesPerRow * int(ceil(float(${o}Shape[1]) / 2.0));\n      vec2 uv = packedUVfrom3D(\n        packedTexShape[0], packedTexShape[1], texelsInBatch, valuesPerRow, b, row, col);\n      return ${i.texture2D}(${o}, uv);\n    }\n  `;const c=s[0];const l=s[1];const u=Math.ceil(n[2]/2);const d=u*Math.ceil(n[1]/2);return`\n    vec4 ${a}(int b, int row, int col) {\n      vec2 uv = packedUVfrom3D(\n        ${c}, ${l}, ${d}, ${u}, b, row, col);\n      return ${i.texture2D}(${o}, uv);\n    }\n  `}function getSampler3D(e,t){const o=e.shapeInfo.logicalShape;const a=e.name;const r="get"+a.charAt(0).toUpperCase()+a.slice(1);const s=o[1]*o[2];const i=o[2];const{newShape:c,keptDims:l}=n.squeezeShape(o);const u=c;if(u.length<o.length){const n=squeezeInputInfo(e,u);const o=["row","col","depth"];return`\n        ${getSamplerFromInInfo(n,t)}\n        float ${r}(int row, int col, int depth) {\n          return ${r}(${getSqueezedParams(o,l)});\n        }\n      `}if(e.shapeInfo.isUniform)return`\n      float ${r}(int row, int col, int depth) {\n        int index = round(dot(vec3(row, col, depth),\n                          vec3(${s}, ${i}, 1)));\n        ${getUniformSampler(e)}\n      }\n    `;const d=e.shapeInfo.texShape;const p=d[0];const h=d[1];const f=e.shapeInfo.flatOffset;if(h===s&&f==null)return t?`\n      float ${r}(int row, int col, int depth) {\n        int stride1 = ${a}Shape[2];\n        float texR = float(row);\n        float texC = dot(vec2(col, depth), vec2(stride1, 1));\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                   vec2(${a}TexShape[1], ${a}TexShape[0]);\n        return sampleTexture(${a}, uv);\n      }\n    `:`\n        float ${r}(int row, int col, int depth) {\n          float texR = float(row);\n          float texC = dot(vec2(col, depth), vec2(${i}, 1));\n          vec2 uv = (vec2(texC, texR) + halfCR) /\n                     vec2(${h}.0, ${p}.0);\n          return sampleTexture(${a}, uv);\n        }\n      `;if(h===i&&f==null)return t?`\n      float ${r}(int row, int col, int depth) {\n        float texR = dot(vec2(row, col), vec2(${a}Shape[1], 1));\n        float texC = float(depth);\n        vec2 uv = (vec2(texC, texR) + halfCR) / vec2(${a}TexShape[1], ${a}TexShape[0]);\n        return sampleTexture(${a}, uv);\n      }\n    `:`\n    float ${r}(int row, int col, int depth) {\n      float texR = dot(vec2(row, col), vec2(${o[1]}, 1));\n      float texC = float(depth);\n      vec2 uv = (vec2(texC, texR) + halfCR) / vec2(${h}.0, ${p}.0);\n      return sampleTexture(${a}, uv);\n    }\n  `;const x=getFlatOffsetUniformName(a);return t?`\n    float ${r}(int row, int col, int depth) {\n      // Explicitly use integer operations as dot() only works on floats.\n      int stride0 = ${a}Shape[1] * ${a}Shape[2];\n      int stride1 = ${a}Shape[2];\n      int index = row * stride0 + col * stride1 + depth + ${x};\n      vec2 uv = uvFromFlat(${a}TexShape[0], ${a}TexShape[1], index);\n      return sampleTexture(${a}, uv);\n    }\n    `:`\n      float ${r}(int row, int col, int depth) {\n        // Explicitly use integer operations as dot() only works on floats.\n        int index = row * ${s} + col * ${i} + depth + ${x};\n        vec2 uv = uvFromFlat(${p}, ${h}, index);\n        return sampleTexture(${a}, uv);\n      }\n  `}function getPackedSamplerND(e,t){const n=e.name;const o="get"+n.charAt(0).toUpperCase()+n.slice(1);const a=getGlslDifferences();if(t)return`\n    vec4 ${o}(int b2, int b, int row, int col) {\n      int valuesPerRow = int(ceil(float(${n}Shape[3]) / 2.0));\n      int texelsInBatch = valuesPerRow * int(ceil(float(${n}Shape[2]) / 2.0));\n      int index = b * texelsInBatch + (row / 2) * valuesPerRow + (col / 2);\n      texelsInBatch *= ${n}Shape[1];\n      index = b2 * texelsInBatch + index;\n      ivec2 packedTexShape = ivec2(ceil(float(${n}TexShape[0]) / 2.0), ceil(float(${n}TexShape[1]) / 2.0));\n      int texR = index / packedTexShape[1];\n      int texC = index - texR * packedTexShape[1];\n      vec2 uv = (vec2(texC, texR) + halfCR) / vec2(packedTexShape[1], packedTexShape[0]); return ${a.texture2D}(${n}, uv);\n    }\n  `;const r=e.shapeInfo.logicalShape;const s=r.length;const i=e.shapeInfo.texShape;const c=[Math.ceil(i[0]/2),Math.ceil(i[1]/2)];const l=c[0];const u=c[1];const d=Math.ceil(r[s-1]/2);let p=d*Math.ceil(r[s-2]/2);let h="int b, int row, int col";let f=`b * ${p} + (row / 2) * ${d} + (col / 2)`;for(let e=2;e<s-1;e++){h=`int b${e}, `+h;p*=r[s-e-1];f=`b${e} * ${p} + `+f}return`\n    vec4 ${o}(${h}) {\n      int index = ${f};\n      int texR = index / ${u};\n      int texC = index - texR * ${u};\n      vec2 uv = (vec2(texC, texR) + halfCR) / vec2(${u}, ${l});\n      return ${a.texture2D}(${n}, uv);\n    }\n  `}function getSampler4D(e,t){const o=e.shapeInfo.logicalShape;const a=e.name;const r="get"+a.charAt(0).toUpperCase()+a.slice(1);const s=o[3];const i=o[2]*s;const c=o[1]*i;const{newShape:l,keptDims:u}=n.squeezeShape(o);if(l.length<o.length){const n=squeezeInputInfo(e,l);const o=["row","col","depth","depth2"];return`\n      ${getSamplerFromInInfo(n,t)}\n      float ${r}(int row, int col, int depth, int depth2) {\n        return ${r}(${getSqueezedParams(o,u)});\n      }\n    `}if(e.shapeInfo.isUniform)return`\n      float ${r}(int row, int col, int depth, int depth2) {\n        int index = round(dot(vec4(row, col, depth, depth2),\n                          vec4(${c}, ${i}, ${s}, 1)));\n        ${getUniformSampler(e)}\n      }\n    `;const d=e.shapeInfo.flatOffset;const p=e.shapeInfo.texShape;const h=p[0];const f=p[1];const x=`int stride2 = ${a}Shape[3];`;const m=`int stride1 = ${a}Shape[2] * stride2;`;const g=`int stride0 = ${a}Shape[1] * stride1;`;if(f===c&&d==null)return t?`\n      float ${r}(int row, int col, int depth, int depth2) {\n        ${x}\n        ${m}\n        float texR = float(row);\n        float texC =\n            dot(vec3(col, depth, depth2),\n                vec3(stride1, stride2, 1));\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                   vec2(${a}TexShape[1], ${a}TexShape[0]);\n        return sampleTexture(${a}, uv);\n      }\n    `:`\n      float ${r}(int row, int col, int depth, int depth2) {\n        float texR = float(row);\n        float texC =\n            dot(vec3(col, depth, depth2),\n                vec3(${i}, ${s}, 1));\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                   vec2(${f}.0, ${h}.0);\n        return sampleTexture(${a}, uv);\n      }\n    `;if(f===s&&d==null)return t?`\n      float ${r}(int row, int col, int depth, int depth2) {\n        float texR = dot(vec3(row, col, depth),\n                         vec3(${a}Shape[1] * ${a}Shape[2], ${a}Shape[2], 1));\n        float texC = float(depth2);\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                  vec2(${a}TexShape[1], ${a}TexShape[0]);\n        return sampleTexture(${a}, uv);\n      }\n    `:`\n      float ${r}(int row, int col, int depth, int depth2) {\n        float texR = dot(vec3(row, col, depth),\n                         vec3(${o[1]*o[2]}, ${o[2]}, 1));\n        float texC = float(depth2);\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                  vec2(${f}.0, ${h}.0);\n        return sampleTexture(${a}, uv);\n      }\n    `;const C=getFlatOffsetUniformName(a);return t?`\n    float ${r}(int row, int col, int depth, int depth2) {\n      // Explicitly use integer operations as dot() only works on floats.\n      ${x}\n      ${m}\n      ${g}\n      int index = row * stride0 + col * stride1 +\n          depth * stride2 + depth2;\n      vec2 uv = uvFromFlat(${a}TexShape[0], ${a}TexShape[1], index + ${C});\n      return sampleTexture(${a}, uv);\n    }\n  `:`\n    float ${r}(int row, int col, int depth, int depth2) {\n      // Explicitly use integer operations as dot() only works on floats.\n      int index = row * ${c} + col * ${i} +\n          depth * ${s} + depth2;\n      vec2 uv = uvFromFlat(${h}, ${f}, index + ${C});\n      return sampleTexture(${a}, uv);\n    }\n  `}function getSampler5D(e){const t=e.shapeInfo.logicalShape;const o=e.name;const a="get"+o.charAt(0).toUpperCase()+o.slice(1);const r=t[4];const s=t[3]*r;const i=t[2]*s;const c=t[1]*i;const{newShape:l,keptDims:u}=n.squeezeShape(t);if(l.length<t.length){const t=squeezeInputInfo(e,l);const n=["row","col","depth","depth2","depth3"];return`\n      ${getSamplerFromInInfo(t)}\n      float ${a}(int row, int col, int depth, int depth2, int depth3) {\n        return ${a}(${getSqueezedParams(n,u)});\n      }\n    `}if(e.shapeInfo.isUniform)return`\n      float ${a}(int row, int col, int depth, int depth2, int depth3) {\n        float index = dot(\n          vec4(row, col, depth, depth2),\n          vec4(${c}, ${i}, ${s}, ${r})) +\n          depth3;\n        ${getUniformSampler(e)}\n      }\n    `;const d=e.shapeInfo.flatOffset;const p=e.shapeInfo.texShape;const h=p[0];const f=p[1];if(f===c&&d==null)return`\n      float ${a}(int row, int col, int depth, int depth2, int depth3) {\n        int texR = row;\n        float texC = dot(vec4(col, depth, depth2, depth3),\n                         vec4(${i}, ${s}, ${r}, 1));\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                   vec2(${f}.0, ${h}.0);\n        return sampleTexture(${o}, uv);\n      }\n    `;if(f===r&&d==null)return`\n      float ${a}(int row, int col, int depth, int depth2, int depth3) {\n        float texR = dot(\n          vec4(row, col, depth, depth2),\n          vec4(${t[1]*t[2]*t[3]},\n               ${t[2]*t[3]}, ${t[3]}, 1));\n        int texC = depth3;\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                  vec2(${f}.0, ${h}.0);\n        return sampleTexture(${o}, uv);\n      }\n    `;const x=getFlatOffsetUniformName(o);return`\n    float ${a}(int row, int col, int depth, int depth2, int depth3) {\n      // Explicitly use integer operations as dot() only works on floats.\n      int index = row * ${c} + col * ${i} + depth * ${s} +\n          depth2 * ${r} + depth3 + ${x};\n      vec2 uv = uvFromFlat(${h}, ${f}, index);\n      return sampleTexture(${o}, uv);\n    }\n  `}function getSampler6D(e){const t=e.shapeInfo.logicalShape;const o=e.name;const a="get"+o.charAt(0).toUpperCase()+o.slice(1);const{newShape:r,keptDims:s}=n.squeezeShape(t);if(r.length<t.length){const t=squeezeInputInfo(e,r);const n=["row","col","depth","depth2","depth3","depth4"];return`\n      ${getSamplerFromInInfo(t)}\n      float ${a}(int row, int col, int depth,\n                    int depth2, int depth3, int depth4) {\n        return ${a}(${getSqueezedParams(n,s)});\n      }\n    `}const i=t[5];const c=t[4]*i;const l=t[3]*c;const u=t[2]*l;const d=t[1]*u;if(e.shapeInfo.isUniform)return`\n      float ${a}(int row, int col, int depth,\n                  int depth2, int depth3, int depth4) {\n        int index = round(dot(\n          vec4(row, col, depth, depth2),\n          vec4(${d}, ${u}, ${l}, ${c})) +\n          dot(\n            vec2(depth3, depth4),\n            vec2(${i}, 1)));\n        ${getUniformSampler(e)}\n      }\n    `;const p=e.shapeInfo.flatOffset;const h=e.shapeInfo.texShape;const f=h[0];const x=h[1];if(x===d&&p==null)return`\n      float ${a}(int row, int col, int depth,\n                    int depth2, int depth3, int depth4) {\n        int texR = row;\n        float texC = dot(vec4(col, depth, depth2, depth3),\n          vec4(${u}, ${l}, ${c}, ${i})) +\n               float(depth4);\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                   vec2(${x}.0, ${f}.0);\n        return sampleTexture(${o}, uv);\n      }\n    `;if(x===i&&p==null)return`\n      float ${a}(int row, int col, int depth,\n                    int depth2, int depth3, int depth4) {\n        float texR = dot(vec4(row, col, depth, depth2),\n          vec4(${t[1]*t[2]*t[3]*t[4]},\n               ${t[2]*t[3]*t[4]},\n               ${t[3]*t[4]},\n               ${t[4]})) + float(depth3);\n        int texC = depth4;\n        vec2 uv = (vec2(texC, texR) + halfCR) /\n                  vec2(${x}.0, ${f}.0);\n        return sampleTexture(${o}, uv);\n      }\n    `;const m=getFlatOffsetUniformName(o);return`\n    float ${a}(int row, int col, int depth,\n                  int depth2, int depth3, int depth4) {\n      // Explicitly use integer operations as dot() only works on floats.\n      int index = row * ${d} + col * ${u} + depth * ${l} +\n          depth2 * ${c} + depth3 * ${i} + depth4 + ${m};\n      vec2 uv = uvFromFlat(${f}, ${x}, index);\n      return sampleTexture(${o}, uv);\n    }\n  `}function getUniformSampler(e){const t=e.name;const o=n.sizeFromShape(e.shapeInfo.logicalShape);return o<2?`return ${t};`:`\n    for (int i = 0; i < ${o}; i++) {\n      if (i == index) {\n        return ${t}[i];\n      }\n    }\n  `}function getPackedSamplerAtOutputCoords(e,t){const o=e.name;const a=o.charAt(0).toUpperCase()+o.slice(1);const r="get"+a+"AtOutCoords";const s=e.shapeInfo.logicalShape.length;const i=t.logicalShape.length;const c=Wn(e.shapeInfo.logicalShape,t.logicalShape);const l=getCoordsDataType(i);const u=i-s;let d;const p=["x","y","z","w","u","v"];d=s===0?"":i<2&&c.length>=1?"coords = 0;":c.map((e=>`coords.${p[e+u]} = 0;`)).join("\n");let h="";h=i<2&&s>0?"coords":e.shapeInfo.logicalShape.map(((e,t)=>`coords.${p[t+u]}`)).join(", ");let f="return outputValue;";const x=n.sizeFromShape(e.shapeInfo.logicalShape);const m=x===1;const g=n.sizeFromShape(t.logicalShape);const C=g===1;if(s!==1||m||C){if(m&&!C)f=i===1?"\n        return vec4(outputValue.x, outputValue.x, 0., 0.);\n      ":"\n        return vec4(outputValue.x);\n      ";else if(c.length){const e=s-2;const t=s-1;c.indexOf(e)>-1&&c.indexOf(t)>-1?f="return vec4(outputValue.x);":c.indexOf(e)>-1?f="return vec4(outputValue.x, outputValue.y, outputValue.x, outputValue.y);":c.indexOf(t)>-1&&(f="return vec4(outputValue.xx, outputValue.zz);")}}else f="\n      return vec4(outputValue.xy, outputValue.xy);\n    ";return`\n    vec4 ${r}() {\n      ${l} coords = getOutputCoords();\n      ${d}\n      vec4 outputValue = get${a}(${h});\n      ${f}\n    }\n  `}function getSamplerAtOutputCoords(e,t){const o=e.name;const a=o.charAt(0).toUpperCase()+o.slice(1);const r="get"+a+"AtOutCoords";const s=t.texShape;const i=e.shapeInfo.texShape;const c=e.shapeInfo.logicalShape.length;const l=t.logicalShape.length;if(!e.shapeInfo.isUniform&&c===l&&e.shapeInfo.flatOffset==null&&n.arraysEqual(i,s))return`\n      float ${r}() {\n        return sampleTexture(${o}, resultUV);\n      }\n    `;const u=getCoordsDataType(l);const d=Wn(e.shapeInfo.logicalShape,t.logicalShape);const p=l-c;let h;const f=["x","y","z","w","u","v"];h=c===0?"":l<2&&d.length>=1?"coords = 0;":d.map((e=>`coords.${f[e+p]} = 0;`)).join("\n");let x="";x=l<2&&c>0?"coords":e.shapeInfo.logicalShape.map(((e,t)=>`coords.${f[t+p]}`)).join(", ");return`\n    float ${r}() {\n      ${u} coords = getOutputCoords();\n      ${h}\n      return get${a}(${x});\n    }\n  `}function getCoordsDataType(e){if(e<=1)return"int";if(e===2)return"ivec2";if(e===3)return"ivec3";if(e===4)return"ivec4";if(e===5)return"ivec5";if(e===6)return"ivec6";throw Error(`GPU for rank ${e} is not yet supported`)}function getUniformInfoFromShape(e,t,o){const{newShape:a,keptDims:r}=n.squeezeShape(t);const s=t.length;const i=e&&s===3&&t[0]===1;const c=i?t.slice(1):a;const l=!e&&s>1&&!n.arraysEqual(t,o)&&a.length<s||i;const u=l?c:t;return{useSqueezeShape:l,uniformShape:u,keptDims:r}}function squeezeInputInfo(e,t){const n=JSON.parse(JSON.stringify(e));n.shapeInfo.logicalShape=t;return n}function getSqueezedParams(e,t){return t.map((t=>e[t])).join(", ")}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */function compileProgram(e,n,o,a){const r=o.map(((e,t)=>{const o={logicalShape:e.shape,texShape:e.isUniform?null:e.texData.texShape,isUniform:e.isUniform,isPacked:!e.isUniform&&e.texData.isPacked,flatOffset:null};e.texData!=null&&e.texData.slice!=null&&e.texData.slice.flatOffset>0&&(o.flatOffset=e.texData.slice.flatOffset);return{name:n.variableNames[t],shapeInfo:o}}));const s=r.map((e=>e.shapeInfo));const i={logicalShape:a.shape,texShape:a.texData.texShape,isUniform:false,isPacked:a.texData.isPacked,flatOffset:null};const c=makeShader(r,i,n);const l=createFragmentShader(e.gl,c);const u=e.createProgram(l);if(t().get("ENGINE_COMPILE_ONLY"))return{program:n,fragmentShader:l,source:c,webGLProgram:u,inShapeInfos:s,outShapeInfo:i,variablesLocations:null,customUniformLocations:null,infLoc:null,nanLoc:null,outShapeLocation:null,outShapeStridesLocation:null,outTexShapeLocation:null};e.buildVao(u);return Object.assign({program:n,fragmentShader:l,source:c,webGLProgram:u,inShapeInfos:s,outShapeInfo:i},getUniformLocations(e,n,u))}function getUniformLocations(e,n,o){const a=[];const r=[];let s;let i;let c;let l=null;let u=null;u=e.getUniformLocation(o,"NAN",false);t().getNumber("WEBGL_VERSION")===1&&(l=e.getUniformLocation(o,"INFINITY",false));const d=false;for(const t of n.variableNames){const r={name:t,uniform:e.getUniformLocation(o,t,d),offset:e.getUniformLocation(o,`offset${t}`,d)};if(n.enableShapeUniforms){r.shape=e.getUniformLocation(o,`${t}Shape`,d);r.texShape=e.getUniformLocation(o,`${t}TexShape`,d)}a.push(r)}if(n.enableShapeUniforms){s=e.getUniformLocation(o,"outShape",d);c=e.getUniformLocation(o,"outShapeStrides",d);i=e.getUniformLocation(o,"outTexShape",d)}if(n.customUniforms)for(const t of n.customUniforms)r.push(e.getUniformLocation(o,t.name,d));return{variablesLocations:a,customUniformLocations:r,infLoc:l,nanLoc:u,outShapeLocation:s,outShapeStridesLocation:c,outTexShapeLocation:i}}function validateBinaryAndProgram(e,t){if(e.length!==t.length)throw Error(`Binary was compiled with ${e.length} inputs, but was executed with ${t.length} inputs`);e.forEach(((e,o)=>{const a=e.logicalShape;const r=t[o];const s=r.shape;if(!n.arraysEqual(a,s))throw Error(`Binary was compiled with different shapes than the current args. Shapes ${a} and ${s} must match`);if(e.isUniform&&r.isUniform)return;const i=e.texShape;const c=r.isUniform?null:r.texData.texShape;if(!n.arraysEqual(i,c))throw Error(`Binary was compiled with different texture shapes than the current args. Shape ${i} and ${c} must match`)}))}function runProgram(e,o,a,r,s){if(!o.program.enableShapeUniforms){validateBinaryAndProgram(o.inShapeInfos,a);validateBinaryAndProgram([o.outShapeInfo],[r])}const i=r.texData.texture;const c=r.texData.texShape;r.texData.isPacked?e.setOutputPackedMatrixTexture(i.texture,c[0],c[1]):e.setOutputMatrixTexture(i.texture,c[0],c[1]);e.setProgram(o.webGLProgram);e.bindVertexArray(o.webGLProgram.vao);t().getNumber("WEBGL_VERSION")===1&&o.infLoc!==null&&e.gl.uniform1f(o.infLoc,Infinity);o.nanLoc!==null&&e.gl.uniform1f(o.nanLoc,NaN);for(let t=0;t<a.length;++t){const r=a[t];const{uniform:s,offset:i,shape:c,texShape:l}=o.variablesLocations[t];if(c){const{uniformShape:t}=getUniformInfoFromShape(o.program.packedInputs,r.shape,r.texData.texShape);switch(t.length){case 1:e.gl.uniform1iv(c,new Int32Array(t));break;case 2:e.gl.uniform2iv(c,new Int32Array(t));break;case 3:e.gl.uniform3iv(c,new Int32Array(t));break;case 4:e.gl.uniform4iv(c,new Int32Array(t));break;default:break}}l&&e.gl.uniform2i(l,r.texData.texShape[0],r.texData.texShape[1]);if(s!=null)if(r.isUniform)if(n.sizeFromShape(r.shape)<2)e.gl.uniform1f(s,r.uniformValues[0]);else{let t=r.uniformValues;t instanceof Float32Array||(t=new Float32Array(t));e.gl.uniform1fv(s,t)}else{r.texData.slice!=null&&i!=null&&e.gl.uniform1i(i,r.texData.slice.flatOffset);e.setInputMatrixTexture(r.texData.texture.texture,s,t)}}const l=o.outShapeLocation;if(l)switch(r.shape.length){case 1:e.gl.uniform1iv(l,new Int32Array(r.shape));break;case 2:e.gl.uniform2iv(l,new Int32Array(r.shape));break;case 3:e.gl.uniform3iv(l,new Int32Array(r.shape));break;case 4:e.gl.uniform4iv(l,new Int32Array(r.shape));break;default:break}if(o.outShapeStridesLocation){const t=n.computeStrides(r.shape);switch(r.shape.length){case 2:e.gl.uniform1iv(o.outShapeStridesLocation,new Int32Array(t));break;case 3:e.gl.uniform2iv(o.outShapeStridesLocation,new Int32Array(t));break;case 4:e.gl.uniform3iv(o.outShapeStridesLocation,new Int32Array(t));break;default:break}}o.outTexShapeLocation&&e.gl.uniform2i(o.outTexShapeLocation,r.texData.texShape[0],r.texData.texShape[1]);if(o.program.customUniforms&&s)for(let t=0;t<o.program.customUniforms.length;++t){const n=o.program.customUniforms[t];const a=o.customUniformLocations[t];const r=s[t];if(n.type==="float")e.gl.uniform1fv(a,r);else if(n.type==="vec2")e.gl.uniform2fv(a,r);else if(n.type==="vec3")e.gl.uniform3fv(a,r);else if(n.type==="vec4")e.gl.uniform4fv(a,r);else if(n.type==="int")e.gl.uniform1iv(a,r);else if(n.type==="ivec2")e.gl.uniform2iv(a,r);else if(n.type==="ivec3")e.gl.uniform3iv(a,r);else{if(n.type!=="ivec4")throw Error(`uniform type ${n.type} is not supported yet.`);e.gl.uniform4iv(a,r)}}e.executeProgram()}function makeShaderKey(e,o,r){let s="";o.concat(r).forEach((t=>{const o=t.texData!=null&&t.texData.slice!=null&&t.texData.slice.flatOffset>0;if(e.enableShapeUniforms&&!t.isUniform){const i=t.texData.texShape;const{useSqueezeShape:c,uniformShape:l,keptDims:u}=getUniformInfoFromShape(e.packedInputs,t.shape,i);let d="",p="",h="";if(l.length===1&&e.packedInputs){const e=[Math.ceil(i[0]/2),Math.ceil(i[1]/2)];d=`${e[0]>1}_${e[1]>1}`}else if(l.length!==2||e.packedInputs){if(l.length>2&&!e.packedInputs){const e=n.computeStrides(l);h=`${e[0]===i[1]}_${e[e.length-1]===i[1]}`}}else p=`${l[0]>1}_${l[1]>1}`;const f=t.shape.length;const x=l.length===2&&n.arraysEqual(t.shape,i);const m=n.sizeFromShape(t.shape)===1;const g=a.getBroadcastDims(t.shape,r.shape);const C=!e.packedInputs&&f===r.shape.length&&n.arraysEqual(i,r.texData.texShape);const b=e.packedInputs||l.length>2?"":`${i[0]>1}_${i[1]>1}`;s+=`${f}_${C}_${c?u:""}_${l.length}_${m}_${g}_${x}_${d}_${p}_${h}_${b}_${o}`}else{const e=t.isUniform?"uniform":t.texData.texShape;s+=`${t.shape}_${e}_${o}`}}));const i=e.userCode;let c=e.constructor.name;c+="_"+s+"_"+i+`${t().getNumber("WEBGL_VERSION")}`;return c}function useShapeUniforms(e){return t().getBool("WEBGL_USE_SHAPES_UNIFORMS")&&e<=4}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class DecodeMatrixProgram{constructor(e){this.variableNames=["A"];this.packedInputs=false;this.packedOutput=true;this.outPackingScheme=En.DENSE;this.customUniforms=[{name:"texShape",type:"ivec2"}];const t=getGlslDifferences();this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);this.userCode=`\n      ivec3 outCoordsFromFlatIndex(int index) {\n        ${this.enableShapeUniforms?getOutputLogicalCoordinatesFromFlatIndexByUniform(["r","c","d"],e):getLogicalCoordinatesFromFlatIndex(["r","c","d"],e)}\n        return ivec3(r, c, d);\n      }\n\n      void main() {\n        ivec2 resTexRC = ivec2(resultUV.yx * vec2(texShape[0], texShape[1]));\n        int index = 4 * (resTexRC.x * texShape[1] + resTexRC.y);\n\n        vec4 result = vec4(0.);\n\n        for (int i=0; i<4; i++) {\n          int flatIndex = index + i;\n          ivec3 rc = outCoordsFromFlatIndex(flatIndex);\n          result[i] = getA(rc.x, rc.y, rc.z);\n        }\n\n        ${t.output} = result;\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class DecodeMatrixPackedProgram{constructor(e){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;this.outPackingScheme=En.DENSE;this.customUniforms=[{name:"texShape",type:"ivec2"}];const t=getGlslDifferences();this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);this.userCode=`\n      ivec3 outCoordsFromFlatIndex(int index) {\n        ${this.enableShapeUniforms?getOutputLogicalCoordinatesFromFlatIndexByUniform(["r","c","d"],e):getLogicalCoordinatesFromFlatIndex(["r","c","d"],e)}\n        return ivec3(r, c, d);\n      }\n\n      void main() {\n        ivec2 resTexRC = ivec2(resultUV.yx * vec2(texShape[0], texShape[1]));\n        int index = 4 * (resTexRC.x * texShape[1] + resTexRC.y);\n\n        vec4 result = vec4(0.);\n\n        for (int i=0; i<4; i++) {\n          int flatIndex = index + i;\n          ivec3 rc = outCoordsFromFlatIndex(flatIndex);\n          result[i] = getChannel(getA(rc.x, rc.y, rc.z), vec2(rc.y, rc.z));\n        }\n\n        ${t.output} = result;\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class EncodeFloatProgram{constructor(e){this.variableNames=["A"];this.outTexUsage=Pn.DOWNLOAD;const t=getGlslDifferences();this.outputShape=e;this.userCode=`\n      ${Vn}\n\n      void main() {\n        float x = getAAtOutCoords();\n        ${t.output} = encode_float(x);\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class EncodeFloatPackedProgram{constructor(e){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=false;this.outTexUsage=Pn.DOWNLOAD;const t=getGlslDifferences();this.outputShape=e;this.userCode=`\n      ${Vn}\n\n      void main() {\n        ivec3 coords = getOutputCoords();\n        float x = getChannel(getAAtOutCoords(), vec2(coords.y, coords.z));\n        ${t.output} = encode_float(x);\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */const Kn={R:0,G:1,B:2,A:3};class EncodeMatrixProgram{constructor(e,t=false,n="RGBA"){this.variableNames=["A"];this.customUniforms=[{name:"texShape",type:"ivec2"}];const o=getGlslDifferences();this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);let a="result";t&&(a="floor(result * 255. + 0.5)");let r="";for(let e=0;e<n.length;e++){const t=n[e];r+=`\n          if(offset == ${e}) {\n            result = values[${Kn[t]}];\n          }`}this.userCode=`\n      ${this.enableShapeUniforms?getFlatIndexFrom3DOutput():getFlatIndexFrom3D(e)}\n\n      void main() {\n        ivec3 coords = getOutputCoords();\n        int flatIndex = getFlatIndex(coords);\n        float result = 0.;\n        int offset = imod(flatIndex, ${n.length});\n\n        flatIndex = idiv(flatIndex, ${n.length}, 1.);\n\n        int r = flatIndex / texShape[1];\n        if (r < texShape[0]) {\n          int c = imod(flatIndex, texShape[1]);\n          vec2 uv = (vec2(c, r) + halfCR) / vec2(texShape[1], texShape[0]);\n          vec4 values = ${o.texture2D}(A, uv);\n          ${r}\n        }\n        ${o.output} = vec4(${a}, 0., 0., 0.);\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class EncodeMatrixPackedProgram{constructor(e,t=false){this.variableNames=["A"];this.packedInputs=false;this.packedOutput=true;this.customUniforms=[{name:"texShape",type:"ivec2"}];const n=getGlslDifferences();this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);let o="";let a="result";t&&(a="floor(result * 255. + 0.5)");for(let t=0;t<=1;t++)for(let a=0;a<=1;a++){const r=t*2+a;o+=`\n          localCoords = coords;\n          if(localCoords[2] + ${a} < ${this.enableShapeUniforms?"outShape[2]":`${e[2]}`}) {\n          localCoords[2] += ${a};\n          if (localCoords[1] + ${t} < ${this.enableShapeUniforms?"outShape[1]":`${e[1]}`}) {\n            localCoords[1] += ${t};\n\n            flatIndex = getFlatIndex(localCoords);\n            offset = imod(flatIndex, 4);\n\n            flatIndex = idiv(flatIndex, 4, 1.);\n\n            int r = flatIndex / texShape[1];\n            int c = imod(flatIndex, texShape[1]);\n            vec2 uv = (vec2(c, r) + halfCR) / vec2(texShape[1], texShape[0]);\n            values = ${n.texture2D}(A, uv);\n\n            if (offset == 0) {\n              result[${r}] = values[0];\n            } else if (offset == 1) {\n              result[${r}] = values[1];\n            } else if (offset == 2) {\n              result[${r}] = values[2];\n            } else {\n              result[${r}] = values[3];\n            }\n          }\n        }\n        `}this.userCode=`\n        ${this.enableShapeUniforms?getFlatIndexFrom3DOutput():getFlatIndexFrom3D(e)}\n\n        void main() {\n          ivec3 coords = getOutputCoords();\n\n          vec4 result = vec4(0.);\n          int flatIndex, r, c, offset;\n          ivec3 localCoords;\n          vec2 uv;\n          vec4 values;\n\n          ${o}\n\n          ${n.output} = ${a};\n        }\n    `}}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */function createVertexShader(e){const t=getGlslDifferences();const n=`${t.version}\n    precision highp float;\n    ${t.attribute} vec3 clipSpacePos;\n    ${t.attribute} vec2 uv;\n    ${t.varyingVs} vec2 resultUV;\n\n    void main() {\n      gl_Position = vec4(clipSpacePos, 1);\n      resultUV = uv;\n    }`;return createVertexShader$1(e,n)}function createVertexBuffer(e){const t=new Float32Array([-1,1,0,0,1,-1,-1,0,0,0,1,1,0,1,1,1,-1,0,1,0]);return createStaticVertexBuffer(e,t)}function createIndexBuffer(e){const t=new Uint16Array([0,1,2,2,1,3]);return createStaticIndexBuffer(e,t)}function createAndConfigureTexture(e,n,o,a,r,s){validateTextureSize(n,o);const i=createTexture(e);const c=e.TEXTURE_2D;callAndCheck(e,(()=>e.bindTexture(c,i)));callAndCheck(e,(()=>e.texParameteri(c,e.TEXTURE_WRAP_S,e.CLAMP_TO_EDGE)));callAndCheck(e,(()=>e.texParameteri(c,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE)));callAndCheck(e,(()=>e.texParameteri(c,e.TEXTURE_MIN_FILTER,e.NEAREST)));callAndCheck(e,(()=>e.texParameteri(c,e.TEXTURE_MAG_FILTER,e.NEAREST)));t().getNumber("WEBGL_VERSION")===1?callAndCheck(e,(()=>e.texImage2D(c,0,a,n,o,0,r,s,null))):callAndCheck(e,(()=>e.texStorage2D(c,1,a,n,o)));callAndCheck(e,(()=>e.bindTexture(e.TEXTURE_2D,null)));return{texture:i,texShape:[o,n]}}function getInternalFormatForFloat32MatrixTexture(e){return e.internalFormatFloat}function createFloat32MatrixTexture(e,t,n,o){const[a,r]=getUnpackedMatrixTextureShapeWidthHeight(t,n);return createAndConfigureTexture(e,a,r,getInternalFormatForFloat32MatrixTexture(o),o.textureFormatFloat,e.FLOAT)}function getInternalFormatForFloat16MatrixTexture(e){return e.internalFormatHalfFloat}function createFloat16MatrixTexture(e,t,n,o){const[a,r]=getUnpackedMatrixTextureShapeWidthHeight(t,n);return createAndConfigureTexture(e,a,r,getInternalFormatForFloat16MatrixTexture(o),o.textureFormatFloat,o.textureTypeHalfFloat)}function getInternalFormatForUnsignedBytesMatrixTexture(e){return e.downloadTextureFormat}function createUnsignedBytesMatrixTexture(e,t,n,o){const[a,r]=getUnpackedMatrixTextureShapeWidthHeight(t,n);return createAndConfigureTexture(e,a,r,getInternalFormatForUnsignedBytesMatrixTexture(o),e.RGBA,e.UNSIGNED_BYTE)}function getInternalFormatForPackedMatrixTexture(e){return e.internalFormatPackedFloat}function createPackedMatrixTexture(e,t,n,o){const[a,r]=getPackedMatrixTextureShapeWidthHeight(t,n);return createAndConfigureTexture(e,a,r,getInternalFormatForPackedMatrixTexture(o),e.RGBA,e.FLOAT)}function getInternalFormatForFloat16PackedMatrixTexture(e){return e.internalFormatPackedHalfFloat}function createFloat16PackedMatrixTexture(e,t,n,o){const[a,r]=getPackedMatrixTextureShapeWidthHeight(t,n);return createAndConfigureTexture(e,a,r,getInternalFormatForFloat16PackedMatrixTexture(o),e.RGBA,o.textureTypeHalfFloat)}function bindVertexProgramAttributeStreams(e,t,n){const o=0;const a=12;const r=20;callAndCheck(e,(()=>e.bindBuffer(e.ARRAY_BUFFER,n)));const s=bindVertexBufferToProgramAttribute(e,t,"clipSpacePos",n,3,r,o);return s&&bindVertexBufferToProgramAttribute(e,t,"uv",n,2,r,a)}function uploadDenseMatrixToTexture(e,n,o,a,r,s){callAndCheck(e,(()=>e.bindTexture(e.TEXTURE_2D,n)));let i,c,l;if(r instanceof Uint8Array){i=new Uint8Array(o*a*4);c=e.UNSIGNED_BYTE;l=e.RGBA}else{i=new Float32Array(o*a*4);c=e.FLOAT;l=s.internalFormatPackedFloat}i.set(r);t().getNumber("WEBGL_VERSION")===2?callAndCheck(e,(()=>e.texSubImage2D(e.TEXTURE_2D,0,0,0,o,a,e.RGBA,c,i))):callAndCheck(e,(()=>e.texImage2D(e.TEXTURE_2D,0,l,o,a,0,e.RGBA,c,i)));callAndCheck(e,(()=>e.bindTexture(e.TEXTURE_2D,null)))}function uploadPixelDataToTexture(e,n,o){callAndCheck(e,(()=>e.bindTexture(e.TEXTURE_2D,n)));o.data instanceof Uint8Array?t().getNumber("WEBGL_VERSION")===2?callAndCheck(e,(()=>e.texSubImage2D(e.TEXTURE_2D,0,0,0,o.width,o.height,e.RGBA,e.UNSIGNED_BYTE,o.data))):callAndCheck(e,(()=>e.texImage2D(e.TEXTURE_2D,0,e.RGBA,o.width,o.height,0,e.RGBA,e.UNSIGNED_BYTE,o.data))):t().getNumber("WEBGL_VERSION")===2?callAndCheck(e,(()=>e.texSubImage2D(e.TEXTURE_2D,0,0,0,e.RGBA,e.UNSIGNED_BYTE,o))):callAndCheck(e,(()=>e.texImage2D(e.TEXTURE_2D,0,e.RGBA,e.RGBA,e.UNSIGNED_BYTE,o)));callAndCheck(e,(()=>e.bindTexture(e.TEXTURE_2D,null)))}function createBufferFromOutputTexture(e,t,n,o){const a=e.createBuffer();callAndCheck(e,(()=>e.bindBuffer(e.PIXEL_PACK_BUFFER,a)));const r=4;const s=4;const i=r*s*t*n;callAndCheck(e,(()=>e.bufferData(e.PIXEL_PACK_BUFFER,i,e.STREAM_READ)));callAndCheck(e,(()=>e.readPixels(0,0,n,t,e.RGBA,e.FLOAT,0)));callAndCheck(e,(()=>e.bindBuffer(e.PIXEL_PACK_BUFFER,null)));return a}function downloadFloat32MatrixFromBuffer(e,t,n){const o=e;const a=new Float32Array(n);o.bindBuffer(o.PIXEL_PACK_BUFFER,t);o.getBufferSubData(o.PIXEL_PACK_BUFFER,0,a);o.bindBuffer(o.PIXEL_PACK_BUFFER,null);return a}function downloadByteEncodedFloatMatrixFromOutputTexture(e,t,n,o){const[a,r]=getUnpackedMatrixTextureShapeWidthHeight(t,n);const s=4;const i=new Uint8Array(getUnpackedArraySizeFromMatrixSize(t*n,s));callAndCheck(e,(()=>e.readPixels(0,0,a,r,o.downloadTextureFormat,e.UNSIGNED_BYTE,i)));return new Float32Array(i.buffer)}function downloadPackedMatrixFromBuffer(e,t,n,o,a,r,s,i){const c=e;const l=new Float32Array(getPackedRGBAArraySizeFromMatrixShape(r,s));c.bindBuffer(c.PIXEL_PACK_BUFFER,t);c.getBufferSubData(c.PIXEL_PACK_BUFFER,0,l);c.bindBuffer(c.PIXEL_PACK_BUFFER,null);return l}function downloadMatrixFromPackedOutputTexture(e,t,n){const o=new Float32Array(t*n*4);callAndCheck(e,(()=>e.readPixels(0,0,n,t,e.RGBA,e.FLOAT,o)));return o}var jn=Object.freeze(Object.defineProperty({__proto__:null,bindVertexProgramAttributeStreams:bindVertexProgramAttributeStreams,createBufferFromOutputTexture:createBufferFromOutputTexture,createFloat16MatrixTexture:createFloat16MatrixTexture,createFloat16PackedMatrixTexture:createFloat16PackedMatrixTexture,createFloat32MatrixTexture:createFloat32MatrixTexture,createIndexBuffer:createIndexBuffer,createPackedMatrixTexture:createPackedMatrixTexture,createUnsignedBytesMatrixTexture:createUnsignedBytesMatrixTexture,createVertexBuffer:createVertexBuffer,createVertexShader:createVertexShader,downloadByteEncodedFloatMatrixFromOutputTexture:downloadByteEncodedFloatMatrixFromOutputTexture,downloadFloat32MatrixFromBuffer:downloadFloat32MatrixFromBuffer,downloadMatrixFromPackedOutputTexture:downloadMatrixFromPackedOutputTexture,downloadPackedMatrixFromBuffer:downloadPackedMatrixFromBuffer,getInternalFormatForFloat16MatrixTexture:getInternalFormatForFloat16MatrixTexture,getInternalFormatForFloat16PackedMatrixTexture:getInternalFormatForFloat16PackedMatrixTexture,getInternalFormatForFloat32MatrixTexture:getInternalFormatForFloat32MatrixTexture,getInternalFormatForPackedMatrixTexture:getInternalFormatForPackedMatrixTexture,getInternalFormatForUnsignedBytesMatrixTexture:getInternalFormatForUnsignedBytesMatrixTexture,uploadDenseMatrixToTexture:uploadDenseMatrixToTexture,uploadPixelDataToTexture:uploadPixelDataToTexture},Symbol.toStringTag,{value:"Module"}));
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class GPGPUContext{constructor(e){this.outputTexture=null;this.program=null;this.disposed=false;this.itemsToPoll=[];const n=t().getNumber("WEBGL_VERSION");if(e!=null){this.gl=e;setWebGLContext(n,e)}else this.gl=getWebGLContext(n);e=this.gl;if(t().getNumber("WEBGL_VERSION")===2){const t=e;this.createVertexArray=()=>callAndCheck(t,(()=>t.createVertexArray()));this.bindVertexArray=e=>callAndCheck(t,(()=>t.bindVertexArray(e)));this.deleteVertexArray=e=>callAndCheck(t,(()=>t.deleteVertexArray(e)));this.getVertexArray=()=>callAndCheck(t,(()=>t.getParameter(t.VERTEX_ARRAY_BINDING)))}else if(e!=null){const t=e.getExtension("OES_vertex_array_object");if(t==null)throw new Error("All WebGL1 implementations are expected to offer OES_vertex_array_object.");this.createVertexArray=()=>callAndCheck(e,(()=>t.createVertexArrayOES()));this.bindVertexArray=n=>callAndCheck(e,(()=>t.bindVertexArrayOES(n)));this.deleteVertexArray=n=>callAndCheck(e,(()=>t.deleteVertexArrayOES(n)));this.getVertexArray=()=>callAndCheck(e,(()=>e.getParameter(t.VERTEX_ARRAY_BINDING_OES)))}let o="WEBGL_color_buffer_float";const a="EXT_color_buffer_half_float";this.parallelCompilationExtension=this.gl.getExtension("KHR_parallel_shader_compile");if(t().getNumber("WEBGL_VERSION")===1){const e="OES_texture_float";const n="OES_texture_half_float";this.textureFloatExtension=getExtensionOrThrow(this.gl,e);if(hasExtension(this.gl,n))this.textureHalfFloatExtension=getExtensionOrThrow(this.gl,n);else if(t().get("WEBGL_FORCE_F16_TEXTURES"))throw new Error("GL context does not support half float textures, yet the environment flag WEBGL_FORCE_F16_TEXTURES is set to true.");this.colorBufferFloatExtension=this.gl.getExtension(o);if(hasExtension(this.gl,a))this.colorBufferHalfFloatExtension=getExtensionOrThrow(this.gl,a);else if(t().get("WEBGL_FORCE_F16_TEXTURES"))throw new Error("GL context does not support color renderable half floats, yet the environment flag WEBGL_FORCE_F16_TEXTURES is set to true.")}else{o="EXT_color_buffer_float";if(hasExtension(this.gl,o))this.colorBufferFloatExtension=this.gl.getExtension(o);else{if(!hasExtension(this.gl,a))throw new Error("GL context does not support color renderable floats");this.colorBufferHalfFloatExtension=this.gl.getExtension(a)}}this.vertexBuffer=createVertexBuffer(this.gl);this.indexBuffer=createIndexBuffer(this.gl);this.framebuffer=createFramebuffer(this.gl);this.textureConfig=getTextureConfig(this.gl,this.textureHalfFloatExtension)}get debug(){return t().getBool("DEBUG")}dispose(){if(this.disposed)return;this.program!=null&&console.warn("Disposing a GPGPUContext that still has a bound WebGLProgram. This is probably a resource leak, delete the program with GPGPUContext.deleteProgram before disposing.");this.outputTexture!=null&&console.warn("Disposing a GPGPUContext that still has a bound output matrix texture.  This is probably a resource leak, delete the output matrix texture with GPGPUContext.deleteMatrixTexture before disposing.");const e=this.gl;callAndCheck(e,(()=>e.finish()));callAndCheck(e,(()=>e.bindFramebuffer(e.FRAMEBUFFER,null)));callAndCheck(e,(()=>e.deleteFramebuffer(this.framebuffer)));callAndCheck(e,(()=>e.bindBuffer(e.ARRAY_BUFFER,null)));callAndCheck(e,(()=>e.bindBuffer(e.ELEMENT_ARRAY_BUFFER,null)));callAndCheck(e,(()=>e.deleteBuffer(this.indexBuffer)));this.disposed=true}createFloat32MatrixTexture(e,t){this.throwIfDisposed();return createFloat32MatrixTexture(this.gl,e,t,this.textureConfig)}createFloat16MatrixTexture(e,t){this.throwIfDisposed();return createFloat16MatrixTexture(this.gl,e,t,this.textureConfig)}createUnsignedBytesMatrixTexture(e,t){this.throwIfDisposed();return createUnsignedBytesMatrixTexture(this.gl,e,t,this.textureConfig)}uploadPixelDataToTexture(e,t){this.throwIfDisposed();uploadPixelDataToTexture(this.gl,e,t)}uploadDenseMatrixToTexture(e,t,n,o){this.throwIfDisposed();uploadDenseMatrixToTexture(this.gl,e,t,n,o,this.textureConfig)}createFloat16PackedMatrixTexture(e,t){this.throwIfDisposed();return createFloat16PackedMatrixTexture(this.gl,e,t,this.textureConfig)}createPackedMatrixTexture(e,t){this.throwIfDisposed();return createPackedMatrixTexture(this.gl,e,t,this.textureConfig)}deleteMatrixTexture(e){this.throwIfDisposed();if(this.outputTexture===e){unbindColorTextureFromFramebuffer(this.gl,this.framebuffer);this.outputTexture=null}callAndCheck(this.gl,(()=>this.gl.deleteTexture(e)))}downloadByteEncodedFloatMatrixFromOutputTexture(e,t,n){return this.downloadMatrixDriver(e,(()=>downloadByteEncodedFloatMatrixFromOutputTexture(this.gl,t,n,this.textureConfig)))}downloadPackedMatrixFromBuffer(e,t,n,o,a,r){return downloadPackedMatrixFromBuffer(this.gl,e,t,n,o,a,r,this.textureConfig)}downloadFloat32MatrixFromBuffer(e,t){return downloadFloat32MatrixFromBuffer(this.gl,e,t)}createBufferFromTexture(e,t,n){this.bindTextureToFrameBuffer(e);const o=createBufferFromOutputTexture(this.gl,t,n,this.textureConfig);this.unbindTextureToFrameBuffer();return o}createAndWaitForFence(){const e=this.createFence(this.gl);return this.pollFence(e)}createFence(e){let n;let o;if(t().getBool("WEBGL_FENCE_API_ENABLED")){const t=e;const a=t.fenceSync(t.SYNC_GPU_COMMANDS_COMPLETE,0);e.flush();o=()=>{const e=t.clientWaitSync(a,0,0);return e===t.ALREADY_SIGNALED||e===t.CONDITION_SATISFIED};n=a}else if(t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION")>0){n=this.beginQuery();this.endQuery();o=()=>this.isQueryAvailable(n,t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION"))}else o=()=>true;return{query:n,isFencePassed:o}}downloadMatrixFromPackedTexture(e,t,n){return this.downloadMatrixDriver(e,(()=>downloadMatrixFromPackedOutputTexture(this.gl,t,n)))}createProgram(e){this.throwIfDisposed();const t=this.gl;this.vertexShader==null&&(this.vertexShader=createVertexShader(t));const n=createProgram(t);callAndCheck(t,(()=>t.attachShader(n,this.vertexShader)));callAndCheck(t,(()=>t.attachShader(n,e)));linkProgram(t,n);const o=Object.assign(n,{vao:this.createVertexArray()});this.debug&&validateProgram(t,o);return o}buildVao(e){this.setProgram(e);this.bindVertexArray(e.vao);const t=this.gl;callAndCheck(t,(()=>t.bindBuffer(t.ELEMENT_ARRAY_BUFFER,this.indexBuffer)));bindVertexProgramAttributeStreams(t,e,this.vertexBuffer)}deleteProgram(e){this.throwIfDisposed();e===this.program&&(this.program=null);if(e!=null){callAndCheck(this.gl,(()=>this.gl.deleteProgram(e)));this.deleteVertexArray(e.vao)}}setProgram(e){this.throwIfDisposed();this.program=e;this.program!=null&&this.debug&&validateProgram(this.gl,this.program);callAndCheck(this.gl,(()=>this.gl.useProgram(e)))}getUniformLocation(e,t,n=true){this.throwIfDisposed();return n?getProgramUniformLocationOrThrow(this.gl,e,t):getProgramUniformLocation(this.gl,e,t)}getAttributeLocation(e,t){this.throwIfDisposed();return callAndCheck(this.gl,(()=>this.gl.getAttribLocation(e,t)))}getUniformLocationNoThrow(e,t){this.throwIfDisposed();return this.gl.getUniformLocation(e,t)}setInputMatrixTexture(e,t,n){this.throwIfDisposed();this.throwIfNoProgram();bindTextureToProgramUniformSampler(this.gl,e,t,n)}setOutputMatrixTexture(e,t,n){this.setOutputMatrixTextureDriver(e,n,t)}setOutputPackedMatrixTexture(e,t,n){this.throwIfDisposed();const[o,a]=getPackedMatrixTextureShapeWidthHeight(t,n);this.setOutputMatrixTextureDriver(e,o,a)}setOutputMatrixWriteRegion(e,t,n,o){this.setOutputMatrixWriteRegionDriver(n,e,o,t)}setOutputPackedMatrixWriteRegion(e,t,n,o){throw new Error("setOutputPackedMatrixWriteRegion not implemented.")}debugValidate(){this.program!=null&&validateProgram(this.gl,this.program);validateFramebuffer(this.gl)}executeProgram(){this.throwIfDisposed();this.throwIfNoProgram();const e=this.gl;if(this.debug){const e=this.getVertexArray();console.assert(e===this.program.vao,"VAO changed between setProgram and executeProgram!");this.debugValidate()}callAndCheck(e,(()=>e.drawElements(e.TRIANGLES,6,e.UNSIGNED_SHORT,0)))}blockUntilAllProgramsCompleted(){this.throwIfDisposed();callAndCheck(this.gl,(()=>this.gl.finish()))}getQueryTimerExtension(){this.disjointQueryTimerExtension==null&&(this.disjointQueryTimerExtension=getExtensionOrThrow(this.gl,t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION")===2?"EXT_disjoint_timer_query_webgl2":"EXT_disjoint_timer_query"));return this.disjointQueryTimerExtension}getQueryTimerExtensionWebGL2(){return this.getQueryTimerExtension()}getQueryTimerExtensionWebGL1(){return this.getQueryTimerExtension()}beginQuery(){if(t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION")===2){const e=this.gl;const t=this.getQueryTimerExtensionWebGL2();const n=e.createQuery();e.beginQuery(t.TIME_ELAPSED_EXT,n);return n}const e=this.getQueryTimerExtensionWebGL1();const n=e.createQueryEXT();e.beginQueryEXT(e.TIME_ELAPSED_EXT,n);return n}endQuery(){if(t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION")===2){const e=this.gl;const t=this.getQueryTimerExtensionWebGL2();e.endQuery(t.TIME_ELAPSED_EXT);return}const e=this.getQueryTimerExtensionWebGL1();e.endQueryEXT(e.TIME_ELAPSED_EXT)}async waitForQueryAndGetTime(e){await n.repeatedTry((()=>this.disposed||this.isQueryAvailable(e,t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION"))));return this.getQueryTime(e,t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_VERSION"))}getQueryTime(e,t){if(t===0)return null;if(t===2){const t=this.gl;const n=t.getQueryParameter(e,t.QUERY_RESULT);return n/1e6}{const t=this.getQueryTimerExtensionWebGL1();const n=t.getQueryObjectEXT(e,t.QUERY_RESULT_EXT);return n/1e6}}isQueryAvailable(e,t){if(t===0)return true;if(t===2){const t=this.gl;const n=this.getQueryTimerExtensionWebGL2();const o=t.getQueryParameter(e,t.QUERY_RESULT_AVAILABLE);this.disjoint==null&&(this.disjoint=this.gl.getParameter(n.GPU_DISJOINT_EXT));return o&&!this.disjoint}{const t=this.getQueryTimerExtensionWebGL1();const n=t.getQueryObjectEXT(e,t.QUERY_RESULT_AVAILABLE_EXT);this.disjoint==null&&(this.disjoint=this.gl.getParameter(t.GPU_DISJOINT_EXT));return n&&!this.disjoint}}pollFence(e){return new Promise((t=>{this.addItemToPoll((()=>e.isFencePassed()),(()=>t()))}))}pollItems(){const e=linearSearchLastTrue(this.itemsToPoll.map((e=>e.isDoneFn)));for(let t=0;t<=e;++t){const{resolveFn:e}=this.itemsToPoll[t];e()}this.itemsToPoll=this.itemsToPoll.slice(e+1)}addItemToPoll(e,o){this.itemsToPoll.push({isDoneFn:e,resolveFn:o});if(this.itemsToPoll.length>1)return;let a;"setTimeoutCustom"in t().platform&&(a=t().platform.setTimeoutCustom.bind(t().platform));n.repeatedTry((()=>{this.pollItems();return this.itemsToPoll.length===0}),(()=>0),null,a)}bindTextureToFrameBuffer(e){this.throwIfDisposed();bindColorTextureToFramebuffer(this.gl,e,this.framebuffer);this.debug&&validateFramebuffer(this.gl)}unbindTextureToFrameBuffer(){if(this.outputTexture!=null){bindColorTextureToFramebuffer(this.gl,this.outputTexture,this.framebuffer);this.debug&&validateFramebuffer(this.gl)}else unbindColorTextureFromFramebuffer(this.gl,this.framebuffer)}downloadMatrixDriver(e,t){this.bindTextureToFrameBuffer(e);const n=t();this.unbindTextureToFrameBuffer();return n}setOutputMatrixTextureDriver(e,t,n){this.throwIfDisposed();const o=this.gl;bindColorTextureToFramebuffer(o,e,this.framebuffer);this.debug&&validateFramebuffer(o);this.outputTexture=e;callAndCheck(o,(()=>o.viewport(0,0,t,n)));callAndCheck(o,(()=>o.scissor(0,0,t,n)))}setOutputMatrixWriteRegionDriver(e,t,n,o){this.throwIfDisposed();callAndCheck(this.gl,(()=>this.gl.scissor(e,t,n,o)))}throwIfDisposed(){if(this.disposed)throw new Error("Attempted to use disposed GPGPUContext.")}throwIfNoProgram(){if(this.program==null)throw new Error("No GPU program is currently set.")}}function linearSearchLastTrue(e){let t=0;for(;t<e.length;++t){const n=e[t]();if(!n)break}return t-1}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const{addImpl:qn,bincountImpl:Yn,bincountReduceImpl:Qn,bitwiseAndImpl:Zn,castImpl:Jn,ceilImpl:eo,concatImpl:to,equalImpl:no,expImpl:oo,expm1Impl:ao,floorImpl:ro,gatherNdImpl:so,gatherV2Impl:io,greaterImpl:co,greaterEqualImpl:lo,lessImpl:uo,lessEqualImpl:po,linSpaceImpl:ho,logImpl:fo,maxImpl:xo,maximumImpl:mo,minimumImpl:go,multiplyImpl:Co,negImpl:bo,notEqualImpl:vo,prodImpl:$o,raggedGatherImpl:yo,raggedRangeImpl:Io,raggedTensorToTensorImpl:So,rangeImpl:To,rsqrtImpl:ko,scatterImpl:wo,sigmoidImpl:Ro,simpleAbsImpl:Fo,sliceImpl:No,sparseFillEmptyRowsImpl:Eo,sparseReshapeImpl:Po,sparseSegmentReductionImpl:Ao,sqrtImpl:Oo,staticRegexReplaceImpl:Do,stridedSliceImpl:_o,stringNGramsImpl:Lo,stringSplitImpl:Bo,stringToHashBucketFastImpl:Uo,subImpl:Mo,tileImpl:Vo,topKImpl:Wo,transposeImpl:Go,uniqueImpl:zo}=Rn;
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */function getVecChannels(e,t){return["x","y","z","w","u","v"].slice(0,t).map((t=>`${e}.${t}`))}function getChannels(e,t){return t===1?[e]:getVecChannels(e,t)}function getSourceCoords$2(e,t){if(e===1)return"rc";let n="";for(let o=0;o<e;o++){n+=t[o];o<e-1&&(n+=",")}return n}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class PackProgram{constructor(e){this.variableNames=["A"];this.packedInputs=false;this.packedOutput=true;this.outputShape=e;this.rank=e.length;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);if(this.rank===0)this.userCode="\n        void main() {\n          setOutput(vec4(getA(), 0., 0., 0.));\n        }\n      ";else{const e=getChannels("rc",this.rank);const t=getCoordsDataType(this.rank);const n=this.getOutOfBoundsCondition(e);const o=this.getSetup(e);const a=this.getOutput(e);this.userCode=`\n        void main() {\n          ${t} rc = getOutputCoords();\n\n          if(${n}) {\n            setOutput(vec4(0));\n          } else {\n            ${o}\n\n            setOutput(vec4(${a}));\n          }\n        }\n      `}}getSourceCoordsArr(e){const t=[];for(let n=0;n<=1;n++)for(let o=0;o<=1;o++){let a=`${n===0?"r":"rp1"}, ${o===0?"c":"cp1"}`;for(let t=2;t<this.rank;t++)a=`${e[e.length-1-t]},`+a;t.push(a)}return t}getOutOfBoundsCondition(e){if(this.rank===1)return`rc > ${this.enableShapeUniforms?"outShape":this.outputShape[0]}`;let t="";for(let n=this.rank-2;n<this.rank;n++){t+=`${e[n]} >= ${this.enableShapeUniforms?`outShape[${n}]`:this.outputShape[n]}`;n<this.rank-1&&(t+="||")}return t}getSetup(e){if(this.rank===1)return"";const t=e.slice(-2);const n=this.enableShapeUniforms?`outShape[${this.rank} - 1]`:this.outputShape[this.rank-1];const o=this.enableShapeUniforms?`outShape[${this.rank} - 2]`:this.outputShape[this.rank-2];return`\n      int r = ${t[0]};\n      int c = ${t[1]};\n      int rp1 = r + 1;\n      int cp1 = c + 1;\n\n      bool cEdge = cp1 >= ${n};\n      bool rEdge = rp1 >= ${o};\n    `}getOutput(e){const t=this.getSourceCoordsArr(e);if(this.rank===1){const e=this.enableShapeUniforms?"outShape":this.outputShape[0];return`getA(rc), (rc + 1 >= ${e} ? 0. : getA(rc + 1)), 0, 0`}return`getA(${t[0]}),\n            cEdge ? 0. : getA(${t[1]}),\n            rEdge ? 0. : getA(${t[2]}),\n            rEdge || cEdge ? 0. : getA(${t[3]})`}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class ReshapePackedProgram{constructor(e,t){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;this.customUniforms=[{name:"inputShape",type:"ivec3"}];this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);let n="";for(let e=0;e<4;e++){let t="thisRC = rc;";e%2===1&&(t+="thisRC.z += 1;");e>1&&(t+="thisRC.y += 1;");n+=`\n        ${t}\n        ${e>0?"if(thisRC.y < rows && thisRC.z < cols){":""}\n          int flatIndex = getFlatIndex(thisRC);\n\n          ivec3 inputRC = inputCoordsFromReshapedOutCoords(flatIndex);\n          vec2 inputRCInnerDims = vec2(float(inputRC.y),float(inputRC.z));\n\n          result[${e}] =\n            getChannel(getA(inputRC.x, inputRC.y, inputRC.z), inputRCInnerDims);\n        ${e>0?"}":""}\n      `}this.userCode=`\n      ${getReshapedInputCoords(t,this.enableShapeUniforms)}\n      ${this.enableShapeUniforms?getFlatIndexFrom3DOutput():getFlatIndexFrom3D(e)}\n\n      void main() {\n        ivec3 rc = getOutputCoords();\n\n        vec4 result = vec4(0.);\n\n        ivec3 thisRC;\n        int rows = ${this.enableShapeUniforms?"outShape[1]":e[1]};\n        int cols = ${this.enableShapeUniforms?"outShape[2]":e[2]};\n\n        ${n}\n\n        setOutput(result);\n      }\n    `}}function getReshapedInputCoords(e,t){const n=t?getLogicalCoordinatesFromFlatIndexByUniform(["r","c","d"],"inputShape"):getLogicalCoordinatesFromFlatIndex(["r","c","d"],e);return`\n    ivec3 inputCoordsFromReshapedOutCoords(int index) {\n      ${n}\n      return ivec3(r, c, d);\n    }\n  `}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class TextureManager{constructor(e){this.gpgpu=e;this.numUsedTextures=0;this.numFreeTextures=0;this._numBytesAllocated=0;this._numBytesFree=0;this.freeTextures={};this.usedTextures={};this.logEnabled=false}acquireTexture(e,t,n){const o=getPhysicalFromLogicalTextureType(t,n);const a=getKeyFromTextureShape(e,o,n);a in this.freeTextures||(this.freeTextures[a]=[]);a in this.usedTextures||(this.usedTextures[a]=[]);const r=computeBytes(e,o,this.gpgpu.gl,this.gpgpu.textureConfig,n);if(this.freeTextures[a].length>0){this.numFreeTextures--;this.numUsedTextures++;this._numBytesFree-=r;this.log();const e=this.freeTextures[a].pop();this.usedTextures[a].push(e);return e}let s;o===An.PACKED_2X2_FLOAT32?s=this.gpgpu.createPackedMatrixTexture(e[0],e[1]):o===An.PACKED_2X2_FLOAT16?s=this.gpgpu.createFloat16PackedMatrixTexture(e[0],e[1]):o===An.UNPACKED_FLOAT32?s=this.gpgpu.createFloat32MatrixTexture(e[0],e[1]):o===An.UNPACKED_FLOAT16?s=this.gpgpu.createFloat16MatrixTexture(e[0],e[1]):o===An.PACKED_4X1_UNSIGNED_BYTE&&(s=this.gpgpu.createUnsignedBytesMatrixTexture(e[0],e[1]));this.usedTextures[a].push(s);this.numUsedTextures++;this._numBytesAllocated+=r;this.log();return s}releaseTexture(e,n,o,a){if(this.freeTextures==null)return;const r=getPhysicalFromLogicalTextureType(o,a);const s=getKeyFromTextureShape(n,r,a);s in this.freeTextures||(this.freeTextures[s]=[]);const i=computeBytes(n,r,this.gpgpu.gl,this.gpgpu.textureConfig,a);const c=t().getNumber("WEBGL_DELETE_TEXTURE_THRESHOLD");if(c!==-1&&this._numBytesAllocated>c){this.gpgpu.deleteMatrixTexture(e.texture);this._numBytesAllocated-=i}else{this.freeTextures[s].push(e);this.numFreeTextures++;this._numBytesFree+=i}this.numUsedTextures--;const l=this.usedTextures[s];const u=l&&l.indexOf(e);if(u==null||u<0)throw new Error("Cannot release a texture that was never provided by this texture manager");l[u]=l[l.length-1];l.pop();this.log()}log(){if(!this.logEnabled)return;const e=this.numFreeTextures+this.numUsedTextures;console.log("Free/Used",`${this.numFreeTextures} / ${this.numUsedTextures}`,`(${e})`);const t=this._numBytesFree/this._numBytesAllocated;console.log(`Bytes allocated: ${this._numBytesAllocated}`);console.log(`Bytes unused: ${this._numBytesFree} (${Math.round(100*t)}%)`)}get numBytesAllocated(){return this._numBytesAllocated}get numBytesFree(){return this._numBytesFree}getNumUsedTextures(){return this.numUsedTextures}getNumFreeTextures(){return this.numFreeTextures}dispose(){if(this.freeTextures!=null){for(const e in this.freeTextures)this.freeTextures[e].forEach((e=>{this.gpgpu.deleteMatrixTexture(e.texture)}));for(const e in this.usedTextures)this.usedTextures[e].forEach((e=>{this.gpgpu.deleteMatrixTexture(e.texture)}));this.freeTextures=null;this.usedTextures=null;this.numUsedTextures=0;this.numFreeTextures=0;this._numBytesAllocated=0;this._numBytesFree=0}}}function numBytesForInternalFormat(e,t){const n=e;if(t===n.R32F)return 4;if(t===n.R16F)return 2;if(t===n.RGBA32F)return 16;if(t===e.RGBA)return 16;if(t===n.RGBA16F)return 8;if(t===n.RGBA8)return 4;throw new Error(`Unknown internal format ${t}`)}function computeBytes(e,t,n,o,a){const r=internalFormatForPhysicalTexType(t,o);let s;if(a){const[t,n]=getPackedMatrixTextureShapeWidthHeight(e[0],e[1]);s=t*n}else{const[t,n]=getUnpackedMatrixTextureShapeWidthHeight(e[0],e[1]);s=t*n}const i=numBytesForInternalFormat(n,r);return s*i}function internalFormatForPhysicalTexType(e,t){switch(e){case An.PACKED_2X2_FLOAT32:return getInternalFormatForPackedMatrixTexture(t);case An.PACKED_2X2_FLOAT16:return getInternalFormatForFloat16PackedMatrixTexture(t);case An.UNPACKED_FLOAT32:return getInternalFormatForFloat32MatrixTexture(t);case An.UNPACKED_FLOAT16:return getInternalFormatForFloat16MatrixTexture(t);case An.PACKED_4X1_UNSIGNED_BYTE:return getInternalFormatForUnsignedBytesMatrixTexture(t);default:throw new Error(`Unknown physical texture type ${e}`)}}function getPhysicalTextureForRendering(e){return t().getBool("WEBGL_RENDER_FLOAT32_ENABLED")?e?An.PACKED_2X2_FLOAT32:An.UNPACKED_FLOAT32:e?An.PACKED_2X2_FLOAT16:An.UNPACKED_FLOAT16}function getPhysicalFromLogicalTextureType(e,t){if(e===Pn.UPLOAD)return An.PACKED_2X2_FLOAT32;if(e===Pn.RENDER||e==null)return getPhysicalTextureForRendering(t);if(e===Pn.DOWNLOAD||e===Pn.PIXELS)return An.PACKED_4X1_UNSIGNED_BYTE;throw new Error(`Unknown logical texture type ${e}`)}function getKeyFromTextureShape(e,t,n){return`${e[0]}_${e[1]}_${t}_${n}`}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class UnaryOpProgram{constructor(e,t){this.variableNames=["A"];this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);this.userCode=`\n      float unaryOperation(float x) {\n        ${t}\n      }\n\n      void main() {\n        float x = getAAtOutCoords();\n        float y = unaryOperation(x);\n\n        setOutput(y);\n      }\n    `}}const Xo="if (isnan(x)) return x;";const Ho="return x;";const Ko="return abs(x);";const jo="return (x >= 0.0) ? x : (exp(x) - 1.0);";const qo=Xo+"\n  return (x < 0.0) ? 0.0 : x;\n";const Yo=Xo+"\n  return (x < 0.0) ? 0.0 : min(6.0, x);\n";const Qo="return x;";const Zo="return 1.0 / (1.0 + exp(-1.0 * x));";
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */const Jo="return x;";const ea="\n  vec4 result;\n\n  result.r = (x.r >= 0.0) ? x.r : (exp(x.r) - 1.0);\n  result.g = (x.g >= 0.0) ? x.g : (exp(x.g) - 1.0);\n  result.b = (x.b >= 0.0) ? x.b : (exp(x.b) - 1.0);\n  result.a = (x.a >= 0.0) ? x.a : (exp(x.a) - 1.0);\n\n  return result;\n";const ta="\n  vec4 result = x * vec4(greaterThanEqual(x, vec4(0.0)));\n  bvec4 isNaN = isnan(x);\n\n  result.r = isNaN.r ? x.r : result.r;\n  result.g = isNaN.g ? x.g : result.g;\n  result.b = isNaN.b ? x.b : result.b;\n  result.a = isNaN.a ? x.a : result.a;\n\n  return result;\n";const na="\n  vec4 result = min(x, vec4(6.)) * vec4(greaterThanEqual(x, vec4(0.0)));\n  bvec4 isNaN = isnan(x);\n\n  result.r = isNaN.r ? x.r : result.r;\n  result.g = isNaN.g ? x.g : result.g;\n  result.b = isNaN.b ? x.b : result.b;\n  result.a = isNaN.a ? x.a : result.a;\n\n  return result;\n";const oa="return 1.0 / (1.0 + exp(-1.0 * x));";class UnaryOpPackedProgram{constructor(e,t){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);this.userCode=`\n      vec4 unaryOperation(vec4 x) {\n        ${t}\n      }\n\n      void main() {\n        vec4 x = getAAtOutCoords();\n        vec4 y = unaryOperation(x);\n\n        setOutput(y);\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class UnpackProgram{constructor(e){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=false;this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);const t=e.length;const n=getChannels("rc",t);const o=getCoordsDataType(t);const a=getSourceCoords$2(t,n);const r=n.slice(-2);const s=t<=1?"rc":`vec2(${r.join(",")})`;this.userCode=`\n      void main() {\n        ${o} rc = getOutputCoords();\n        vec4 packedInput = getA(${a});\n\n        setOutput(getChannel(packedInput, ${s}));\n      }\n    `}}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */const aa=r.whereImpl;const ra=1e-7;const sa=1e-4;const ia={};function getBinaryCache(e){if(e in ia)return ia[e];ia[e]={};return ia[e]}const ca=t().getNumber("CPU_HANDOFF_SIZE_THRESHOLD");const la=600;function numMBBeforeWarning(){return t().global.screen==null?1024:t().global.screen.height*t().global.screen.width*window.devicePixelRatio*la/1024/1024}class MathBackendWebGL extends s{nextDataId(){return MathBackendWebGL.nextDataId++}constructor(e){super();this.pendingRead=new WeakMap;this.pendingDisposal=new WeakSet;this.dataRefCount=new WeakMap;this.numBytesInGPU=0;this.uploadWaitMs=0;this.downloadWaitMs=0;this.lastGlFlushTime=0;this.warnedAboutMemory=false;this.pendingDeletes=0;this.disposed=false;if(!t().getBool("HAS_WEBGL"))throw new Error("WebGL is not supported on this device");let n;if(e!=null){if(e instanceof GPGPUContext)n=e;else{const o=getWebGLContext(t().getNumber("WEBGL_VERSION"),e);n=new GPGPUContext(o)}this.binaryCache={};this.gpgpuCreatedLocally=false}else{const e=getWebGLContext(t().getNumber("WEBGL_VERSION"));n=new GPGPUContext(e);this.binaryCache=getBinaryCache(t().getNumber("WEBGL_VERSION"));this.gpgpuCreatedLocally=true}this.gpgpu=n;this.canvas=this.gpgpu.gl.canvas;this.textureManager=new TextureManager(this.gpgpu);this.numMBBeforeWarning=numMBBeforeWarning();this.texData=new c(this,i())}numDataIds(){return this.texData.numDataIds()-this.pendingDeletes}writeTexture(e,t,n,o,a,r){const s=this.makeTensorInfo(t,n);const i=this.texData.get(s.dataId);i.isPacked=false;i.texture={texture:e,texShape:[o,a]};i.texShape=[o,a];const c=getShapeAs3D(t);const l=new EncodeMatrixProgram(c,false,r);const u=this.runWebGLProgram(l,[s],n,[[o,a]]);u.shape=t;i.texture=null;this.disposeIntermediateTensorInfo(s);return u.dataId}write(e,n,o){(t().getBool("WEBGL_CHECK_NUMERICAL_PROBLEMS")||t().getBool("DEBUG"))&&this.checkNumericalProblems(e);if(o==="complex64"&&e!=null)throw new Error("Cannot write to a complex64 dtype. Please use tf.complex(real, imag).");const a={id:this.nextDataId()};this.texData.set(a,{shape:n,dtype:o,values:e,usage:Pn.UPLOAD,refCount:1});return a}refCount(e){if(this.texData.has(e)){const t=this.texData.get(e);return t.refCount}return 0}incRef(e){const t=this.texData.get(e);t.refCount++}decRef(e){if(this.texData.has(e)){const t=this.texData.get(e);t.refCount--}}move(e,n,o,a,r){t().getBool("DEBUG")&&this.checkNumericalProblems(n);if(a==="complex64")throw new Error("Cannot write to a complex64 dtype. Please use tf.complex(real, imag).");this.texData.set(e,{shape:o,dtype:a,values:n,usage:Pn.UPLOAD,refCount:r})}disposeIntermediateTensorInfo(e){this.disposeData(e.dataId)}readSync(e){const t=this.texData.get(e);const{values:o,dtype:r,complexTensorInfos:s,slice:i,shape:c,isPacked:l}=t;if(i!=null){let t;t=l?new UnaryOpPackedProgram(c,Qo):new UnaryOpProgram(c,Qo);const n=this.runWebGLProgram(t,[{dataId:e,shape:c,dtype:r}],r);const o=this.readSync(n.dataId);this.disposeIntermediateTensorInfo(n);return o}if(o!=null)return this.convertAndCacheOnCPU(e);if(r==="string")return o;const u=this.activeTimers!=null;let d;u&&(d=n.now());let p;if(r==="complex64"){const e=this.readSync(s.real.dataId);const t=this.readSync(s.imag.dataId);p=a.mergeRealAndImagArrays(e,t)}else p=this.getValuesFromTexture(e);u&&(this.downloadWaitMs+=n.now()-d);return this.convertAndCacheOnCPU(e,p)}async read(e){if(this.pendingRead.has(e)){const t=this.pendingRead.get(e);return new Promise((e=>t.push(e)))}const o=this.texData.get(e);const{values:r,shape:s,slice:c,dtype:l,complexTensorInfos:u,isPacked:d}=o;if(c!=null){let t;t=d?new UnaryOpPackedProgram(s,Qo):new UnaryOpProgram(s,Qo);const n=this.runWebGLProgram(t,[{dataId:e,shape:s,dtype:l}],l);const o=this.read(n.dataId);this.disposeIntermediateTensorInfo(n);return o}if(r!=null)return this.convertAndCacheOnCPU(e);if(t().getBool("DEBUG")&&!t().getBool("WEBGL_DOWNLOAD_FLOAT_ENABLED")&&t().getNumber("WEBGL_VERSION")===2)throw new Error("tensor.data() with WEBGL_DOWNLOAD_FLOAT_ENABLED=false and WEBGL_VERSION=2 not yet supported.");let p=null;let h;if(l!=="complex64"&&t().get("WEBGL_BUFFER_SUPPORTED")){h=this.decode(e);const t=this.texData.get(h.dataId);p=this.gpgpu.createBufferFromTexture(t.texture.texture,...getDenseTexShape(s))}this.pendingRead.set(e,[]);l!=="complex64"&&await this.gpgpu.createAndWaitForFence();let f;if(l==="complex64"){const e=await Promise.all([this.read(u.real.dataId),this.read(u.imag.dataId)]);const t=e[0];const n=e[1];f=a.mergeRealAndImagArrays(t,n)}else if(p==null)f=this.getValuesFromTexture(e);else{const e=n.sizeFromShape(s);f=this.gpgpu.downloadFloat32MatrixFromBuffer(p,e)}h!=null&&this.disposeIntermediateTensorInfo(h);if(p!=null){const e=this.gpgpu.gl;callAndCheck(e,(()=>e.deleteBuffer(p)))}const x=this.convertAndCacheOnCPU(e,f);const m=this.pendingRead.get(e);this.pendingRead.delete(e);m.forEach((e=>e(x)));if(this.pendingDisposal.has(e)){this.pendingDisposal.delete(e);this.disposeData(e)&&i().removeDataId(e,this);this.pendingDeletes--}return x}
/**
     * Read tensor to a new texture that is densely packed for ease of use.
     * @param dataId The source tensor.
     * @param options
     *     customTexShape: Optional. If set, will use the user defined texture
     *     shape to create the texture.
     */readToGPU(e,t={}){const n=this.texData.get(e);const{values:o,shape:a,slice:r,dtype:s,isPacked:c,texture:l}=n;if(s==="complex64")throw new Error("Does not support reading texture for complex64 dtype.");if(r!=null){let n;n=c?new UnaryOpPackedProgram(a,Qo):new UnaryOpProgram(a,Qo);const o=this.runWebGLProgram(n,[{dataId:e,shape:a,dtype:s}],s);const r=this.readToGPU(o,t);this.disposeIntermediateTensorInfo(o);return r}if(l==null)throw o!=null?new Error("Data is not on GPU but on CPU."):new Error("There is no data on GPU or CPU.");const u=this.decode(e,t.customTexShape);const d=i().makeTensorFromTensorInfo(u);const p=this.texData.get(u.dataId);return Object.assign({tensorRef:d},p.texture)}bufferSync(e){const t=this.readSync(e.dataId);if(e.dtype==="string")try{const o=t.map((e=>n.decodeString(e)));return l(e.shape,e.dtype,o)}catch(e){throw new Error("Failed to decode encoded string bytes into utf-8")}return l(e.shape,e.dtype,t)}checkNumericalProblems(e){if(e!=null)for(let n=0;n<e.length;n++){const o=e[n];if(!canBeRepresented(o)){if(t().getBool("WEBGL_RENDER_FLOAT32_CAPABLE"))throw Error(`The value ${o} cannot be represented with your current settings. Consider enabling float32 rendering: 'tf.env().set('WEBGL_RENDER_FLOAT32_ENABLED', true);'`);throw Error(`The value ${o} cannot be represented on this device.`)}}}getValuesFromTexture(e){const{shape:o,dtype:a,isPacked:r}=this.texData.get(e);const s=n.sizeFromShape(o);if(t().getBool("WEBGL_DOWNLOAD_FLOAT_ENABLED")){const t=this.decode(e);const n=this.texData.get(t.dataId);const a=this.gpgpu.downloadMatrixFromPackedTexture(n.texture.texture,...getDenseTexShape(o)).subarray(0,s);this.disposeIntermediateTensorInfo(t);return a}const i=t().getBool("WEBGL_PACK")&&r===true;const c=i?getShapeAs3D(o):o;const l=i?new EncodeFloatPackedProgram(c):new EncodeFloatProgram(c);const u=this.runWebGLProgram(l,[{shape:c,dtype:a,dataId:e}],"float32");const d=this.texData.get(u.dataId);const p=this.gpgpu.downloadByteEncodedFloatMatrixFromOutputTexture(d.texture.texture,d.texShape[0],d.texShape[1]).subarray(0,s);this.disposeIntermediateTensorInfo(u);return p}timerAvailable(){return t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_RELIABLE")>0}time(e){const o=this.activeTimers;const a=[];let r=false;if(this.programTimersStack==null){this.programTimersStack=a;r=true}else this.activeTimers.push(a);this.activeTimers=a;e();const s=n.flatten(this.activeTimers.map((e=>e.query))).filter((e=>e!=null));const i=n.flatten(this.activeTimers.map((e=>e.name))).filter((e=>e!=null));this.activeTimers=o;r&&(this.programTimersStack=null);const c={uploadWaitMs:this.uploadWaitMs,downloadWaitMs:this.downloadWaitMs,kernelMs:null,wallMs:null};return(async()=>{if(t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_RELIABLE")>0){const e=await Promise.all(s);c.kernelMs=n.sum(e);c.getExtraProfileInfo=()=>e.map(((e,t)=>({name:i[t],ms:e}))).map((e=>`${e.name}: ${e.ms}`)).join(", ")}else c.kernelMs={error:"WebGL query timers are not supported in this environment."};this.uploadWaitMs=0;this.downloadWaitMs=0;return c})()}memory(){return{unreliable:false,numBytesInGPU:this.numBytesInGPU,numBytesInGPUAllocated:this.textureManager.numBytesAllocated,numBytesInGPUFree:this.textureManager.numBytesFree}}startTimer(){return t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_RELIABLE")>0?this.gpgpu.beginQuery():{startMs:n.now(),endMs:null}}endTimer(e){if(t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_RELIABLE")>0){this.gpgpu.endQuery();return e}e.endMs=n.now();return e}async getQueryTime(e){if(t().getNumber("WEBGL_DISJOINT_QUERY_TIMER_EXTENSION_RELIABLE")>0)return this.gpgpu.waitForQueryAndGetTime(e);const n=e;return n.endMs-n.startMs}
/**
     * Decrease the RefCount on the dataId and dispose the memory if the dataId
     * has 0 refCount. If there are pending read on the data, the disposal would
     * added to the pending delete queue. Return true if the dataId is removed
     * from backend or the backend does not contain the dataId, false if the
     * dataId is not removed. Memory may or may not be released even when dataId
     * is removed, which also depends on dataRefCount, see `releaseGPU`.
     * @param dataId
     * @oaram force Optional, remove the data regardless of refCount
     */disposeData(e,t=false){if(this.pendingDisposal.has(e))return false;if(!this.texData.has(e))return true;t?this.texData.get(e).refCount=0:this.texData.get(e).refCount--;if(!t&&this.texData.get(e).refCount>0)return false;if(this.pendingRead.has(e)){this.pendingDisposal.add(e);this.pendingDeletes++;return false}this.releaseGPUData(e);const{complexTensorInfos:n}=this.texData.get(e);if(n!=null){this.disposeData(n.real.dataId,t);this.disposeData(n.imag.dataId,t)}this.texData.delete(e);return true}releaseGPUData(e){const{texture:t,dtype:n,texShape:o,usage:a,isPacked:r,slice:s}=this.texData.get(e);const i=s&&s.origDataId||e;const c=this.dataRefCount.get(i);if(c>1)this.dataRefCount.set(i,c-1);else{this.dataRefCount.delete(i);if(t!=null){this.numBytesInGPU-=this.computeBytes(o,n);this.textureManager.releaseTexture(t,o,a,r)}}const l=this.texData.get(e);l.texture=null;l.texShape=null;l.isPacked=false;l.slice=null}getTexture(e){this.uploadToGPU(e);return this.texData.get(e).texture.texture}getDataInfo(e){return this.texData.get(e)}shouldExecuteOnCPU(e,o=ca){return t().getBool("WEBGL_CPU_FORWARD")&&e.every((e=>this.texData.get(e.dataId).texture==null&&n.sizeFromShape(e.shape)<o))}getGPGPUContext(){return this.gpgpu}where(e){a.warn("tf.where() in webgl locks the UI thread. Call tf.whereAsync() instead");const t=e.dataSync();return aa(e.shape,t)}packedUnaryOp(e,t,n){const o=new UnaryOpPackedProgram(e.shape,t);const a=this.compileAndRun(o,[e],n);return i().makeTensorFromTensorInfo(a)}abs(e){if(this.shouldExecuteOnCPU([e])&&e.dtype!=="complex64"){const t=Fo(this.texData.get(e.dataId).values);return this.makeOutput(e.shape,e.dtype,t)}if(t().getBool("WEBGL_PACK_UNARY_OPERATIONS"))return this.packedUnaryOp(e,Ko,e.dtype);const n=new UnaryOpProgram(e.shape,Ko);const o=this.compileAndRun(n,[e]);return i().makeTensorFromTensorInfo(o)}makeTensorInfo(e,t,o){let a;if(t==="string"&&o!=null&&o.length>0&&n.isString(o[0])){const r=o.map((e=>n.encodeString(e)));a=this.write(r,e,t)}else a=this.write(o,e,t);this.texData.get(a).usage=null;return{dataId:a,shape:e,dtype:t}}makeOutput(e,t,n){return i().makeTensorFromTensorInfo(this.makeTensorInfo(e,t,n),this)}unpackTensor(e){const t=new UnpackProgram(e.shape);return this.runWebGLProgram(t,[e],e.dtype)}packTensor(e){const t=new PackProgram(e.shape);const n=true;return this.runWebGLProgram(t,[e],e.dtype,null,n)}packedReshape(e,t){const n=[getBatchDim(e.shape),...getRowsCols(e.shape)];const o={dtype:e.dtype,shape:n,dataId:e.dataId};const a=[getBatchDim(t),...getRowsCols(t)];const r=new ReshapePackedProgram(a,n);const s=true;const i=[n];const c=this.runWebGLProgram(r,[o],e.dtype,i,s);return{dataId:c.dataId,shape:t,dtype:c.dtype}}decode(e,t){const o=this.texData.get(e);const{isPacked:a,shape:r,dtype:s}=o;if(t!=null){const e=n.sizeFromShape(r);const o=t[0]*t[1]*4;n.assert(e<=o,(()=>"customTexShape is too small. Row * Column * 4 should be equal or larger than the size of the tensor data."))}const i=getShapeAs3D(r);let c;c=a?new DecodeMatrixPackedProgram(i):new DecodeMatrixProgram(i);const l=true;const u=[t!=null?t:getDenseTexShape(i)];const d=this.runWebGLProgram(c,[{shape:i,dtype:s,dataId:e}],s,u,l,t);return{dtype:s,shape:r,dataId:d.dataId}}runWebGLProgram(e,o,a,r,s=false,i){const c=this.makeTensorInfo(e.outputShape,a);const l=this.texData.get(c.dataId);e.packedOutput&&(l.isPacked=true);if(e.outPackingScheme===En.DENSE){const t=i!=null?i:getDenseTexShape(e.outputShape);l.texShape=t.map((e=>e*2))}e.outTexUsage!=null&&(l.usage=e.outTexUsage);if(n.sizeFromShape(c.shape)===0){l.values=n.getTypedArrayFromDType(c.dtype,0);return c}const u=[];const d=o.map((o=>{if(o.dtype==="complex64")throw new Error("GPGPUProgram does not support complex64 input. For complex64 dtypes, please separate the program into real and imaginary parts.");let a=this.texData.get(o.dataId);if(a.texture==null){if(!e.packedInputs&&n.sizeFromShape(o.shape)<=t().getNumber("WEBGL_SIZE_UPLOAD_UNIFORM"))return{shape:o.shape,texData:null,isUniform:true,uniformValues:a.values};if(e.packedInputs){a.isPacked=true;a.shape=o.shape}}this.uploadToGPU(o.dataId);if(!!a.isPacked!==!!e.packedInputs){o=a.isPacked?this.unpackTensor(o):this.packTensor(o);u.push(o);a=this.texData.get(o.dataId)}else if(a.isPacked&&!isReshapeFree(a.shape,o.shape)){const e=o;const t=o.shape;o.shape=a.shape;o=this.packedReshape(o,t);u.push(o);a=this.texData.get(o.dataId);e.shape=t}return{shape:o.shape,texData:a,isUniform:false}}));this.uploadToGPU(c.dataId);const p={shape:c.shape,texData:l,isUniform:false};const h=makeShaderKey(e,d,p);const f=this.getAndSaveBinary(h,(()=>compileProgram(this.gpgpu,e,d,p)));const x=this.activeTimers!=null;let m;x&&(m=this.startTimer());t().get("ENGINE_COMPILE_ONLY")||runProgram(this.gpgpu,f,d,p,r);u.forEach((e=>this.disposeIntermediateTensorInfo(e)));if(x){m=this.endTimer(m);this.activeTimers.push({name:e.constructor.name,query:this.getQueryTime(m)})}const g=t().getNumber("WEBGL_FLUSH_THRESHOLD");if(g>0){const e=n.now();if(e-this.lastGlFlushTime>g){this.gpgpu.gl.flush();this.lastGlFlushTime=e}}if(!t().getBool("WEBGL_LAZILY_UNPACK")&&l.isPacked&&s===false){const e=this.unpackTensor(c);this.disposeIntermediateTensorInfo(c);return e}return c}compileAndRun(e,t,n,o,a=false){n=n||t[0].dtype;const r=this.runWebGLProgram(e,t,n,o,a);return r}getAndSaveBinary(e,t){e in this.binaryCache||(this.binaryCache[e]=t());return this.binaryCache[e]}getTextureManager(){return this.textureManager}dispose(){if(!this.disposed){if(!t().getBool("IS_TEST")){const e=Object.keys(this.binaryCache);e.forEach((e=>{this.gpgpu.deleteProgram(this.binaryCache[e].webGLProgram);delete this.binaryCache[e]}))}this.textureManager.dispose();this.canvas!=null&&typeof HTMLCanvasElement!=="undefined"&&this.canvas instanceof HTMLCanvasElement?this.canvas.remove():this.canvas=null;if(this.gpgpuCreatedLocally){this.gpgpu.program=null;this.gpgpu.dispose()}this.disposed=true}}floatPrecision(){this.floatPrecisionValue==null&&(this.floatPrecisionValue=d((()=>{if(!t().get("WEBGL_RENDER_FLOAT32_ENABLED")){const e=t().getBool("DEBUG");t().set("DEBUG",false);const n=this.abs(u(1e-8)).dataSync()[0];t().set("DEBUG",e);if(n>0)return 32}return 16})));return this.floatPrecisionValue}epsilon(){return this.floatPrecision()===32?ra:sa}uploadToGPU(e){const o=this.texData.get(e);const{shape:a,dtype:r,values:s,texture:i,usage:c,isPacked:l}=o;if(i!=null)return;const u=this.activeTimers!=null;let d;u&&(d=n.now());let p=o.texShape;if(p==null){p=getTextureShapeFromLogicalShape(a,l);o.texShape=p}if(s!=null){const e=getShapeAs3D(a);let i;let c=p[1],h=p[0];const f=s instanceof Uint8Array||s instanceof Uint8ClampedArray;!l&&f||([c,h]=getPackedMatrixTextureShapeWidthHeight(p[0],p[1]));i=l?new EncodeMatrixPackedProgram(e,f):new EncodeMatrixProgram(e,f);const x=f?[h,c]:p;const m=this.makeTensorInfo(x,r);const g=this.texData.get(m.dataId);g.usage=f?Pn.PIXELS:Pn.UPLOAD;g.texShape=x;this.gpgpu.uploadDenseMatrixToTexture(this.getTexture(m.dataId),c,h,s);const C=[[h,c]];const b=true;const v=this.runWebGLProgram(i,[m],r,C,b);const $=this.texData.get(v.dataId);o.texShape=$.texShape;o.isPacked=$.isPacked;o.usage=$.usage;if(t().get("ENGINE_COMPILE_ONLY"))this.disposeData(v.dataId);else{o.texture=$.texture;o.values=null;this.texData.delete(v.dataId)}this.disposeIntermediateTensorInfo(m);u&&(this.uploadWaitMs+=n.now()-d)}else{const e=this.acquireTexture(p,c,r,l);o.texture=e}}convertAndCacheOnCPU(e,t){const n=this.texData.get(e);const{dtype:o}=n;t!=null&&(n.values=float32ToTypedArray(t,o));return n.values}acquireTexture(e,t,n,o){this.numBytesInGPU+=this.computeBytes(e,n);if(!this.warnedAboutMemory&&this.numBytesInGPU>this.numMBBeforeWarning*1024*1024){const e=(this.numBytesInGPU/1024/1024).toFixed(2);this.warnedAboutMemory=true;console.warn(`High memory usage in GPU: ${e} MB, most likely due to a memory leak`)}return this.textureManager.acquireTexture(e,t,o)}computeBytes(e,t){return e[0]*e[1]*n.bytesPerElement(t)}checkCompileCompletion(){for(const[,e]of Object.entries(this.binaryCache))this.checkCompletion_(e)}async checkCompileCompletionAsync(){const e=[];if(this.gpgpu.parallelCompilationExtension){for(const[,t]of Object.entries(this.binaryCache))e.push(this.checkCompletionAsync_(t));return Promise.all(e)}for(const[,t]of Object.entries(this.binaryCache)){const n=new Promise((e=>{try{this.checkCompletion_(t);e(true)}catch(e){throw e}}));e.push(n)}return Promise.all(e)}async checkCompletionAsync_(e){if(this.gpgpu.gl.getProgramParameter(e.webGLProgram,this.gpgpu.parallelCompilationExtension.COMPLETION_STATUS_KHR))return this.checkCompletion_(e);await p();return this.checkCompletionAsync_(e)}checkCompletion_(e){if(this.gpgpu.gl.getProgramParameter(e.webGLProgram,this.gpgpu.gl.LINK_STATUS)===false){console.log(this.gpgpu.gl.getProgramInfoLog(e.webGLProgram));if(this.gpgpu.gl.getShaderParameter(e.fragmentShader,this.gpgpu.gl.COMPILE_STATUS)===false){logShaderSourceAndInfoLog(e.source,this.gpgpu.gl.getShaderInfoLog(e.fragmentShader));throw new Error("Failed to compile fragment shader.")}throw new Error("Failed to link vertex and fragment shaders.")}return true}getUniformLocations(){for(const e of Object.values(this.binaryCache)){this.gpgpu.buildVao(e.webGLProgram);const{variablesLocations:t,customUniformLocations:n,infLoc:o,nanLoc:a,outShapeLocation:r,outShapeStridesLocation:s,outTexShapeLocation:i}=getUniformLocations(this.gpgpu,e.program,e.webGLProgram);e.variablesLocations=t;e.customUniformLocations=n;e.infLoc=o;e.nanLoc=a;e.outShapeLocation=r;e.outShapeStridesLocation=s;e.outTexShapeLocation=i}}createTensorFromGPUData(e,t,n){e.channels=e.channels||"RGBA";const{texture:o,height:a,width:r,channels:s}=e;const c=i().backend;if(!c.gpgpu.gl.isTexture(o))throw new Error("The texture is invalid. Also, please make sure the texture and the TFJS WebGL backend are using the same canvas. If you want to use your own custom canvas, you have to create and use the custom TFJS WebGL backend created from the canvas through 'new tf.MathBackendWebGL(customCanvas)'.");const l=c.writeTexture(o,t,n,a,r,s);return i().makeTensorFromDataId(l,t,n,c)}}MathBackendWebGL.nextDataId=0;function float32ToTypedArray(e,t){if(t==="float32"||t==="complex64")return e;if(t==="int32"||t==="bool"){const n=t==="int32"?new Int32Array(e.length):new Uint8Array(e.length);for(let t=0;t<n.length;++t)n[t]=Math.round(e[t]);return n}throw new Error(`Unknown dtype ${t}`)}
/** @license See the LICENSE file. */const ua="4.20.0";
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */function forceHalfFloat(){t().set("WEBGL_FORCE_F16_TEXTURES",true)}
/**
 * @license
 * Copyright 2020 Google Inc. All Rights Reserved.
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
 */o.isBrowser()&&h("webgl",(()=>new MathBackendWebGL),2);const da={forceHalfFloat:forceHalfFloat};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */const pa="\n  if (isnan(a)) return a;\n  if (isnan(b)) return b;\n";class BinaryOpProgram{constructor(e,t,n){this.variableNames=["A","B"];this.outputShape=a.assertAndGetBroadcastShape(t,n);this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);this.userCode=`\n      float binaryOperation(float a, float b) {\n        ${e}\n      }\n\n      void main() {\n        float a = getAAtOutCoords();\n        float b = getBAtOutCoords();\n        setOutput(binaryOperation(a, b));\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */const ha="\n  result.r = isNaN.r ? NAN : result.r;\n  result.g = isNaN.g ? NAN : result.g;\n  result.b = isNaN.b ? NAN : result.b;\n  result.a = isNaN.a ? NAN : result.a;\n";class BinaryOpPackedProgram{constructor(e,t,o,r=false){this.variableNames=["A","B"];this.supportsBroadcasting=true;this.packedInputs=true;this.packedOutput=true;this.outputShape=a.assertAndGetBroadcastShape(t,o);const s=this.outputShape.length;this.enableShapeUniforms=useShapeUniforms(s);let i="";if(r)if(s===0||n.sizeFromShape(this.outputShape)===1)i="\n          result.y = 0.;\n          result.z = 0.;\n          result.w = 0.;\n        ";else{const e=getCoordsDataType(s);i=`\n          ${e} coords = getOutputCoords();\n        `;if(s===1)this.enableShapeUniforms?i+="\n            result.y = (coords + 1) >= outShape ? 0. : result.y;\n            result.z = 0.;\n            result.w = 0.;\n          ":i+=`\n            result.y = (coords + 1) >= ${this.outputShape[0]} ? 0. : result.y;\n            result.z = 0.;\n            result.w = 0.;\n          `;else{const e=getChannels("coords",s);this.enableShapeUniforms?i+=`\n            bool nextRowOutOfBounds =\n              (${e[s-2]} + 1) >= outShape[${s} - 2];\n            bool nextColOutOfBounds =\n              (${e[s-1]} + 1) >= outShape[${s} - 1];\n            result.y = nextColOutOfBounds ? 0. : result.y;\n            result.z = nextRowOutOfBounds ? 0. : result.z;\n            result.w = nextColOutOfBounds || nextRowOutOfBounds ? 0. : result.w;\n          `:i+=`\n            bool nextRowOutOfBounds =\n              (${e[s-2]} + 1) >= ${this.outputShape[s-2]};\n            bool nextColOutOfBounds =\n              (${e[s-1]} + 1) >= ${this.outputShape[s-1]};\n            result.y = nextColOutOfBounds ? 0. : result.y;\n            result.z = nextRowOutOfBounds ? 0. : result.z;\n            result.w = nextColOutOfBounds || nextRowOutOfBounds ? 0. : result.w;\n          `}}this.userCode=`\n      vec4 binaryOperation(vec4 a, vec4 b) {\n        ${e}\n      }\n\n      void main() {\n        vec4 a = getAAtOutCoords();\n        vec4 b = getBAtOutCoords();\n\n        vec4 result = binaryOperation(a, b);\n        ${i}\n\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function identity(e){const{inputs:t,backend:n}=e;const{x:o}=t;n.incRef(o.dataId);return{dataId:o.dataId,shape:o.shape,dtype:o.dtype}}const fa={kernelName:f,backendName:"webgl",kernelFunc:identity};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function complex(e){const{inputs:t,backend:n}=e;const{real:o,imag:a}=t;const r=n.makeTensorInfo(o.shape,"complex64");const s=n.texData.get(r.dataId);const i=identity({inputs:{x:o},backend:n});const c=identity({inputs:{x:a},backend:n});s.complexTensorInfos={real:i,imag:c};return r}const xa={kernelName:x,backendName:"webgl",kernelFunc:complex};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ma="return (a < 0.) ? b * a : a;";const ga="\n  vec4 aLessThanZero = vec4(lessThan(a, vec4(0.)));\n  return (aLessThanZero * (b * a)) + ((vec4(1.0) - aLessThanZero) * a);\n";function leakyRelu(e){const{inputs:o,backend:a,attrs:r}=e;const{x:s}=o;const{alpha:i}=r;const c=a.makeTensorInfo([],"float32",n.createScalarValue(i,"float32"));const l=t().getBool("WEBGL_PACK_BINARY_OPERATIONS")?new BinaryOpPackedProgram(ga,s.shape,c.shape):new BinaryOpProgram(ma,s.shape,c.shape);const u=a.runWebGLProgram(l,[s,c],"float32");a.disposeIntermediateTensorInfo(c);return u}const Ca={kernelName:m,backendName:"webgl",kernelFunc:leakyRelu};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ba="return (a < 0.) ? b * a : a;";const va="\n  vec4 aLessThanZero = vec4(lessThan(a, vec4(0.)));\n  return (aLessThanZero * (b * a)) + ((vec4(1.0) - aLessThanZero) * a);\n";function prelu(e){const{inputs:n,backend:o}=e;const{x:a,alpha:r}=n;const s=t().getBool("WEBGL_PACK_BINARY_OPERATIONS")?new BinaryOpPackedProgram(va,a.shape,r.shape):new BinaryOpProgram(ba,a.shape,r.shape);return o.runWebGLProgram(s,[a,r],"float32")}const $a={kernelName:g,backendName:"webgl",kernelFunc:prelu};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ya="if (isnan(x)) return x;";
/**
 * Template that creates a `KernelFunc` for unary ops.
 * @param opSnippet Op snippet to create `UnaryOpProgram`.
 * @param packedOpSnippet Op snippet to create `UnaryOpPackedProgram`.
 * @param dtype Optional. If set, the result has this dtype. Otherwise, the
 *     result has the same dtype as the first input. This is mainly used in
 *     comparison kernels, such as Equal, Less, Greater, etc.
 */function unaryKernelFunc({opSnippet:e,packedOpSnippet:n,cpuKernelImpl:o,dtype:a}){return({inputs:r,backend:s})=>{const{x:i}=r;const c=s;const l=a||i.dtype;if(c.shouldExecuteOnCPU([i])&&o!=null){const e=c.texData.get(i.dataId);const t=o(e.values,l);return c.makeTensorInfo(i.shape,l,t)}const u=t().getBool("WEBGL_PACK_UNARY_OPERATIONS")&&n!=null;let d;d=u?new UnaryOpPackedProgram(i.shape,n):new UnaryOpProgram(i.shape,e);return c.runWebGLProgram(d,[i],l)}}
/**
 * Template that creates a `KernelFunc` for binary ops.
 * @param opSnippet Op snippet to create `BinaryOpProgram`.
 * @param packedOpSnippet Op snippet to create `BinaryOpPackedProgram`.
 * @param checkOutOfBoundsForPackedProgram Whether to set checkOutOfBounds=true
 *     when creating BinaryOpPackedProgram.
 * @param dtype Optional. If set, the result has this dtype. Otherwise, the
 *     result has the same dtype as the first input. This is mainly used in
 *     comparison kernels, such as Equal, Less, Greater, etc.
 */function binaryKernelFunc({opSnippet:e,packedOpSnippet:n,checkOutOfBounds:o=false,supportsComplex:r=false,cpuKernelImpl:s,dtype:i}){return({inputs:c,backend:l})=>{const{a:u,b:d}=c;const p=l;if(r&&u.dtype==="complex64"){const t=p.texData.get(u.dataId);const n=p.texData.get(d.dataId);const[o,a]=[[t.complexTensorInfos.real,n.complexTensorInfos.real],[t.complexTensorInfos.imag,n.complexTensorInfos.imag]].map((t=>{const[n,o]=t;const a={dataId:n.dataId,dtype:n.dtype,shape:u.shape};const r={dataId:o.dataId,dtype:o.dtype,shape:d.shape};const s=new BinaryOpProgram(e,u.shape,d.shape);return p.runWebGLProgram(s,[a,r],C(n.dtype,o.dtype))}));const r=complex({inputs:{real:o,imag:a},backend:p});p.disposeIntermediateTensorInfo(o);p.disposeIntermediateTensorInfo(a);return r}const h=i||C(u.dtype,d.dtype);if((u.dtype==="string"||d.dtype==="string"||p.shouldExecuteOnCPU([u,d]))&&s!=null){const e=p.texData.get(u.dataId).values;const t=p.texData.get(d.dataId).values;const n=u.dtype==="string"?a.fromUint8ToStringArray(e):e;const o=u.dtype==="string"?a.fromUint8ToStringArray(t):t;const[r,i]=s(u.shape,d.shape,n,o,h);const c=p.makeTensorInfo(i,h);const l=p.texData.get(c.dataId);l.values=r;return c}const f=t().getBool("WEBGL_PACK_BINARY_OPERATIONS")&&n!=null;let x;x=f?new BinaryOpPackedProgram(n,u.shape,d.shape,o):new BinaryOpProgram(e,u.shape,d.shape);return p.runWebGLProgram(x,[u,d],h)}}function mapActivationToShaderProgram(e,t=false){if(e==="linear")return t?Jo:Ho;if(e==="relu")return t?ta:qo;if(e==="elu")return t?ea:jo;if(e==="relu6")return t?na:Yo;if(e==="prelu")return t?va:ba;if(e==="leakyrelu")return t?ga:ma;if(e==="sigmoid")return t?oa:Zo;throw new Error(`Activation ${e} has not been implemented for the WebGL backend.`)}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class MatMulPackedProgram{constructor(e,t,n,o=false,a=false,r=false,s=null,i=false,c=false){this.variableNames=["matrixA","matrixB"];this.packedInputs=true;this.packedOutput=true;this.outputShape=n;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);const l=o?e[1]:e[2];const u=Math.ceil(l/2);const d=o?"i * 2, rc.y":"rc.y, i * 2";const p=a?"rc.z, i * 2":"i * 2, rc.z";const h=o?["a.xxyy","a.zzww"]:["a.xxzz","a.yyww"];const f=a?["b.xzxz","b.ywyw"]:["b.xyxy","b.zwzw"];let x="",m="";if(s){x=i?`vec4 activation(vec4 a) {\n          vec4 b = getPreluActivationWeightsAtOutCoords();\n          ${s}\n        }`:c?`vec4 activation(vec4 a) {\n          vec4 b = getLeakyreluAlphaAtOutCoords();\n          ${s}\n        }`:`vec4 activation(vec4 x) {\n          ${s}\n        }`;m="result = activation(result);"}const g=r?"result += getBiasAtOutCoords();":"";r&&this.variableNames.push("bias");i&&this.variableNames.push("preluActivationWeights");c&&this.variableNames.push("leakyreluAlpha");let C="rc.x";let b="rc.x";e[0]<t[0]?C=`imod(rc.x, ${e[0]})`:t[0]<e[0]&&(b=`imod(rc.x, ${t[0]})`);this.userCode=`\n      ${x}\n      // Don't use uniform for sharedDimensionPacked for performance.\n      const float sharedDimension = ${u}.0;\n\n      vec4 dot2x2ARowBCol(ivec3 rc) {\n        vec4 result = vec4(0);\n        int batchA = ${C};\n        int batchB = ${b};\n        for (int i = 0; i < ${u}; i++) {\n          vec4 a = getMatrixA(batchA, ${d});\n          vec4 b = getMatrixB(batchB, ${p});\n\n          // These swizzled products need to be separately added.\n          // See: https://github.com/tensorflow/tfjs/issues/1735\n          result += (${h[0]} * ${f[0]});\n          result += (${h[1]} * ${f[1]});\n        }\n        return result;\n      }\n\n      void main() {\n        ivec3 rc = getOutputCoords();\n        vec4 result = dot2x2ARowBCol(rc);\n\n        ${g}\n\n        ${m}\n\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */const Ia={REAL:"return areal * breal - aimag * bimag;",IMAG:"return areal * bimag + aimag * breal;"};class BinaryOpComplexProgram{constructor(e,t,n){this.variableNames=["AReal","AImag","BReal","BImag"];this.outputShape=a.assertAndGetBroadcastShape(t,n);this.userCode=`\n      float binaryOpComplex(\n          float areal, float aimag, float breal, float bimag) {\n        ${e}\n      }\n\n      void main() {\n        float areal = getARealAtOutCoords();\n        float aimag = getAImagAtOutCoords();\n        float breal = getBRealAtOutCoords();\n        float bimag = getBImagAtOutCoords();\n        setOutput(binaryOpComplex(areal, aimag, breal, bimag));\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Sa="return a * b;";function multiply(e){const{inputs:n,backend:o}=e;const{a:r,b:s}=n;const i=a.upcastType(r.dtype,s.dtype);if(r.dtype==="complex64"){const e=o.texData.get(r.dataId);const t=o.texData.get(s.dataId);const n=new BinaryOpComplexProgram(Ia.REAL,r.shape,s.shape);const a=new BinaryOpComplexProgram(Ia.IMAG,r.shape,s.shape);const i=[{dataId:e.complexTensorInfos.real.dataId,dtype:e.complexTensorInfos.real.dtype,shape:r.shape},{dataId:e.complexTensorInfos.imag.dataId,dtype:e.complexTensorInfos.imag.dtype,shape:r.shape},{dataId:t.complexTensorInfos.real.dataId,dtype:t.complexTensorInfos.real.dtype,shape:s.shape},{dataId:t.complexTensorInfos.imag.dataId,dtype:t.complexTensorInfos.imag.dtype,shape:s.shape}];const c=o.runWebGLProgram(n,i,"float32");const l=o.runWebGLProgram(a,i,"float32");const u=complex({inputs:{real:c,imag:l},backend:o});o.disposeIntermediateTensorInfo(c);o.disposeIntermediateTensorInfo(l);return u}if(o.shouldExecuteOnCPU([r,s])){const e=o.texData.get(r.dataId);const t=o.texData.get(s.dataId);const[n,a]=Co(r.shape,s.shape,e.values,t.values,i);const c=o.makeTensorInfo(a,i);const l=o.texData.get(c.dataId);l.values=n;return c}let c;c=t().getBool("WEBGL_PACK_BINARY_OPERATIONS")?new BinaryOpPackedProgram(Sa,r.shape,s.shape):new BinaryOpProgram(Sa,r.shape,s.shape);return o.runWebGLProgram(c,[r,s],i)}const Ta={kernelName:b,backendName:"webgl",kernelFunc:multiply};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function packedReshape(e,t,n){const o=[getBatchDim(e.shape),...getRowsCols(e.shape)];const a={dtype:e.dtype,shape:o,dataId:e.dataId};const r=[getBatchDim(t),...getRowsCols(t)];const s=new ReshapePackedProgram(r,o);const i=true;const c=[o];const l=n.runWebGLProgram(s,[a],e.dtype,c,i);return{dataId:l.dataId,shape:t,dtype:l.dtype}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function reshape(e){const{inputs:t,backend:o,attrs:a}=e;const{x:r}=t;const{shape:s}=a;const i=o;const c=n.sizeFromShape(r.shape);const l=n.inferFromImplicitShape(s,c);const u=n.sizeFromShape(l);n.assert(c===u,(()=>`The new shape (${l}) has ${u} elements and the old shape (${r.shape}) has ${c} elements. The new shape and old shape must have the same number of elements.`));const d=i.texData.get(r.dataId);if(d.isPacked&&!isReshapeFree(r.shape,l)&&!(d.texture!==null&&isReshapeFree(d.shape,l)))return packedReshape(r,l,i);i.incRef(r.dataId);return{dataId:r.dataId,shape:l,dtype:r.dtype}}const ka={kernelName:v,backendName:"webgl",kernelFunc:reshape};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */class MeanProgram{constructor(e,t){this.variableNames=["x"];const{windowSize:o,batchSize:a,inSize:r,outSize:s}=e;this.outputShape=[a,s];const i=Math.floor(o/4)*4;const c=o%4;let l="sumValue += dot(values, ones);";if(t!=null){const e=1/t;l=`sumValue += dot(values * ${n.isInt(e)?e.toPrecision(2):e}, ones);`}let u="";r%o>0&&(u=`\n        if (inIdx < 0 || inIdx >= ${r}) {\n          return 0.0;\n        }\n      `);this.userCode=`\n      const vec4 ones = vec4(1.0, 1.0, 1.0, 1.0);\n\n      float getValue(int batch, int inIdx) {\n        ${u}\n        return getX(batch, inIdx);\n      }\n\n      void main() {\n        ivec2 coords = getOutputCoords();\n        int batch = coords[0];\n        int outIdx = coords[1];\n        int inOffset = outIdx * ${o};\n\n        float sumValue = 0.0;\n\n        for (int i = 0; i < ${i}; i += 4) {\n          int inIdx = inOffset + i;\n          vec4 values = vec4(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            getValue(batch, inIdx + 2),\n            getValue(batch, inIdx + 3)\n          );\n\n          ${l}\n        }\n\n        int inIdx = inOffset + ${i};\n        if (${c===1}) {\n          vec4 values = vec4(getValue(batch, inIdx), 0.0, 0.0, 0.0);\n\n          ${l}\n        } else if (${c===2}) {\n          vec4 values = vec4(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1), 0.0, 0.0);\n\n          ${l}\n        } else if (${c===3}) {\n          vec4 values = vec4(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            getValue(batch, inIdx + 2), 0.0);\n\n          ${l}\n        }\n        setOutput(sumValue);\n      }\n    `}}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class ReduceProgram{constructor(e,t){this.variableNames=["x"];const{windowSize:n,batchSize:o,inSize:a,outSize:r}=e;this.outputShape=[o,r];let s="0.0";let i="";if(t==="prod")s="1.0";else if(t==="min"){s="1.0 / 1e-20";i="min"}else if(t==="max"){s="-1.0 / 1e-20";i="max"}let c=`${t}(${t}(${t}(minMaxValue[0], minMaxValue[1]), minMaxValue[2]), minMaxValue[3])`;t==="sum"?c="sumValue":t==="prod"?c="prodValue":t==="all"?c="allValue":t==="any"&&(c="anyValue");const l=Math.floor(n/4)*4;const u=n%4;let d=`\n      if (${t==="sum"}) {\n        sumValue += dot(values, ones);\n      } else if (${t==="prod"}) {\n        vec2 tmp = vec2(values[0], values[1]) * vec2(values[2], values[3]);\n        prodValue *= tmp[0] * tmp[1];\n      } else {\n        minMaxValue = ${i}(values, minMaxValue);\n        if (${t==="min"} || ${t==="max"}) {\n          minMaxValue = ${i}(values, minMaxValue);\n          bvec4 isNaN = isnan(values);\n          if (isNaN.r || isNaN.g || isNaN.b || isNaN.a) {\n            minMaxValue = vec4(NAN);\n          }\n        }\n      }\n    `;let p="vec4";if(t==="all"){s="1.0";d="\n        bool reducedAllValue = all(values);\n        float floatedReducedAllValue = float(reducedAllValue);\n        allValue = float(allValue >= 1.0 && floatedReducedAllValue >= 1.0);\n      ";p="bvec4"}else if(t==="any"){s="0.0";d="\n        bool reducedAnyValue = any(values);\n        float floatedReducedAnyValue = float(reducedAnyValue);\n        anyValue = float(anyValue >= 1.0 || floatedReducedAnyValue >= 1.0);\n      ";p="bvec4"}let h="";a%n>0&&(h=`\n        if (inIdx < 0 || inIdx >= ${a}) {\n          return initializationValue;\n        }\n      `);this.userCode=`\n      const float initializationValue = ${s};\n      const vec4 ones = vec4(1.0, 1.0, 1.0, 1.0);\n\n      float getValue(int batch, int inIdx) {\n        ${h}\n        return getX(batch, inIdx);\n      }\n\n      void main() {\n        ivec2 coords = getOutputCoords();\n        int batch = coords[0];\n        int outIdx = coords[1];\n        int inOffset = outIdx * ${n};\n\n        vec4 minMaxValue = vec4(${s});\n        float prodValue = 1.0;\n        float sumValue = 0.0;\n        float allValue = 1.0;\n        float anyValue = 0.0;\n\n        for (int i = 0; i < ${l}; i += 4) {\n          int inIdx = inOffset + i;\n          ${p} values = ${p}(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            getValue(batch, inIdx + 2),\n            getValue(batch, inIdx + 3)\n          );\n\n          ${d}\n        }\n\n        int inIdx = inOffset + ${l};\n        if (${u===1}) {\n          ${p} values = ${p}(\n            getValue(batch, inIdx),\n            initializationValue,\n            initializationValue,\n            initializationValue\n          );\n\n          ${d}\n        } else if (${u===2}) {\n          ${p} values = ${p}(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            initializationValue,\n            initializationValue\n          );\n\n          ${d}\n        } else if (${u===3}) {\n          ${p} values = ${p}(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            getValue(batch, inIdx + 2),\n            initializationValue\n          );\n\n          ${d}\n        }\n        setOutput(${c});\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function getReductionStages(e){const t=[];while(t.length===0||t[t.length-1].outSize!==1){const n=t.length?t[t.length-1].outSize:e[1];const o=a.computeOptimalWindowSize(n);t.push({inSize:n,windowSize:o,outSize:Math.ceil(n/o)})}return t}function reduce(e,t,n,o){const a=getReductionStages(e.shape);let r=e;for(let s=0;s<a.length;s++){const{inSize:i,windowSize:c,outSize:l}=a[s];let u;let d;u=n==="mean"?s===0?new MeanProgram({windowSize:c,inSize:i,batchSize:e.shape[0],outSize:l},i):new MeanProgram({windowSize:c,inSize:i,batchSize:e.shape[0],outSize:l}):new ReduceProgram({windowSize:c,inSize:i,batchSize:e.shape[0],outSize:l},n);d=r;r=o.runWebGLProgram(u,[r],t);d.dataId!==e.dataId&&o.disposeIntermediateTensorInfo(d)}return r}
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class TransposeProgram{constructor(e,t){this.variableNames=["A"];const n=new Array(e.length);for(let o=0;o<n.length;o++)n[o]=e[t[o]];this.outputShape=n;this.rank=n.length;const o=getCoordsDataType(this.rank);const a=getSwitchedCoords(t);this.userCode=`\n    void main() {\n      ${o} resRC = getOutputCoords();\n      setOutput(getA(${a}));\n    }\n    `}}function getSwitchedCoords(e){const t=e.length;if(t>6)throw Error(`Transpose for rank ${t} is not yet supported`);const n=["resRC.x","resRC.y","resRC.z","resRC.w","resRC.u","resRC.v"];const o=new Array(t);for(let t=0;t<e.length;t++)o[e[t]]=n[t];return o.join()}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class TransposePackedProgram{constructor(e,t){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;const n=new Array(e.length);for(let o=0;o<n.length;o++)n[o]=e[t[o]];this.outputShape=n;this.rank=n.length;if(this.rank>6)throw Error(`Packed transpose for rank ${this.rank} is not yet supported.`);const o=getCoordsDataType(this.rank);const a=getVecChannels("rc",this.rank);const r=new Array(this.rank);for(let e=0;e<t.length;e++)r[t[e]]=a[e];const s=`vec2(${r.slice(-2).join()})`;const i=`++${a[this.rank-1]} < ${n[this.rank-1]}`;const c=`getChannel(getA(${r.join()}), ${s})`;this.userCode=`\n    void main() {\n      ${o} rc = getOutputCoords();\n      vec4 result = vec4(0.);\n      result[0] = ${c};\n      if(${i}) {\n        result[1] = ${c};\n      }\n      --${a[this.rank-1]};\n      if(++${a[this.rank-2]} < ${n[this.rank-2]}) {\n        result[2] = ${c};\n        if(${i}) {\n          result[3] = ${c};\n        }\n      }\n      setOutput(result);\n    }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function transposeImpl(e,n,o){const a=t().getBool("WEBGL_PACK_ARRAY_OPERATIONS")?new TransposePackedProgram(e.shape,n):new TransposeProgram(e.shape,n);return o.runWebGLProgram(a,[e],e.dtype)}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function sumImpl(e,t,o,r){const s=t;const i=e.shape.length;const c=n.parseAxisParam(s,e.shape);let l=c;const u=a.getAxesPermutation(l,i);const d=u!=null;let p=e;if(d){p=transposeImpl(e,u,r);l=a.getInnerMostAxes(l.length,i)}a.assertAxesAreInnerMostDims("sum",l,i);const[h,f]=a.computeOutAndReduceShapes(p.shape,l);let x=h;o&&(x=a.expandShapeToKeepDim(h,c));const m=n.sizeFromShape(f);const g=n.sizeFromShape(e.shape);const C=g/m;const b=reshape({inputs:{x:p},attrs:{shape:[C,m]},backend:r});const v=$(e.dtype);const y=reduce(b,v,"sum",r);const I=reshape({inputs:{x:y},attrs:{shape:x},backend:r});r.disposeIntermediateTensorInfo(b);r.disposeIntermediateTensorInfo(y);d&&r.disposeIntermediateTensorInfo(p);return I}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function sum(e){const{inputs:t,backend:n,attrs:o}=e;const{x:a}=t;const{axis:r,keepDims:s}=o;return sumImpl(a,r,s,n)}const wa={kernelName:y,backendName:"webgl",kernelFunc:sum};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function transpose(e){const{inputs:t,backend:n,attrs:o}=e;const{x:a}=t;const{perm:r}=o;const s=n;const i=a.shape.length;const c=new Array(i);for(let e=0;e<c.length;e++)c[e]=a.shape[r[e]];let l;if(s.shouldExecuteOnCPU([a])){const e=s.texData.get(a.dataId);const t=e.values;const n=Go(t,a.shape,a.dtype,r,c);l=s.makeTensorInfo(c,a.dtype);const o=s.texData.get(l.dataId);o.values=n}else l=transposeImpl(a,r,s);return l}const Ra={kernelName:I,backendName:"webgl",kernelFunc:transpose};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Fa=1e3;function batchMatMulImpl({a:e,b:t,transposeA:o,transposeB:a,backend:r,bias:s=null,preluActivationWeights:i=null,leakyreluAlpha:c=0,activation:l=null}){const u=e.shape.length;const d=t.shape.length;const p=o?e.shape[u-2]:e.shape[u-1];const h=a?t.shape[d-1]:t.shape[d-2];const f=o?e.shape[u-1]:e.shape[u-2];const x=a?t.shape[d-2]:t.shape[d-1];const m=e.shape.slice(0,-2);const g=t.shape.slice(0,-2);const b=n.sizeFromShape(m);const v=n.sizeFromShape(g);const $=S.assertAndGetBroadcastShape(e.shape.slice(0,-2),t.shape.slice(0,-2));const y=$.concat([f,x]);n.assert(p===h,(()=>`Error in matMul: inner shapes (${p}) and (${h}) of Tensors with shapes ${e.shape} and ${t.shape} and transposeA=${o} and transposeB=${a} must match.`));const I=o?[b,p,f]:[b,f,p];const T=a?[v,x,h]:[v,h,x];const k=reshape({inputs:{x:e},backend:r,attrs:{shape:I}});const w=reshape({inputs:{x:t},backend:r,attrs:{shape:T}});const R=[k,w];const F=Math.max(b,v);const N=o?k.shape[1]:k.shape[2];const E=s!=null;const P=i!=null;const A=l==="leakyrelu";const O=l!=null?mapActivationToShaderProgram(l,true):null;const D=E||P||A||O!=null;let _;if((f===1||x===1)&&N>Fa&&D===false){let e=k;let t=w;if(o){e=transpose({inputs:{x:k},backend:r,attrs:{perm:[0,2,1]}});R.push(e)}if(a){t=transpose({inputs:{x:w},backend:r,attrs:{perm:[0,2,1]}});R.push(t)}const n=x!==1;const s=x===1;let i=e;if(n){i=reshape({inputs:{x:e},backend:r,attrs:{shape:[F,N,1]}});R.push(i)}const c=x===1?2:1;let l=t;if(s){l=reshape({inputs:{x:t},backend:r,attrs:{shape:[F,1,N]}});R.push(l)}const u=multiply({inputs:{a:i,b:l},backend:r});_=sum({inputs:{x:u},backend:r,attrs:{axis:c,keepDims:true}});R.push(u)}else{const l=C(e.dtype,t.dtype);const u=new MatMulPackedProgram(I,T,[F,f,x],o,a,E,O,P,A);const d=[k,w];s!=null&&d.push(s);P&&d.push(i);if(A){const e=r.makeTensorInfo([],"float32",n.createScalarValue(c,"float32"));d.push(e);R.push(e)}_=r.runWebGLProgram(u,d,l)}const L=reshape({inputs:{x:_},backend:r,attrs:{shape:y}});R.push(_);for(const e of R)r.disposeIntermediateTensorInfo(e);return L}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the License);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */function _fusedMatMul(e){const{inputs:t,backend:n,attrs:o}=e;const{a:a,b:r,bias:s,preluActivationWeights:i}=t;const{transposeA:c,transposeB:l,activation:u,leakyreluAlpha:d}=o;return batchMatMulImpl({a:a,b:r,transposeA:c,transposeB:l,backend:n,bias:s,preluActivationWeights:i,leakyreluAlpha:d,activation:u})}const Na={kernelName:T,backendName:"webgl",kernelFunc:_fusedMatMul};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ea="return abs(x);";function abs(e){const{inputs:n,backend:o}=e;const{x:a}=n;if(o.shouldExecuteOnCPU([a])&&a.dtype!=="complex64"){const e=o.texData.get(a.dataId);const t=Fo(e.values);return o.makeTensorInfo(a.shape,a.dtype,t)}let r;r=t().getBool("WEBGL_PACK_UNARY_OPERATIONS")?new UnaryOpPackedProgram(a.shape,Ea):new UnaryOpProgram(a.shape,Ea);return o.runWebGLProgram(r,[a],a.dtype)}const Pa={kernelName:k,backendName:"webgl",kernelFunc:abs};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Aa=Xo+"\n  if (abs(x) > 1.) {\n    return NAN;\n  }\n  return acos(x);\n";const Oa=unaryKernelFunc({opSnippet:Aa});const Da={kernelName:w,backendName:"webgl",kernelFunc:Oa};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const _a=Xo+"\n  if (x < 1.0) return NAN;\nreturn log(x + sqrt(x * x - 1.0));";const La=unaryKernelFunc({opSnippet:_a});const Ba={kernelName:R,backendName:"webgl",kernelFunc:La};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ua="return a + b;";const Ma=binaryKernelFunc({opSnippet:Ua,packedOpSnippet:Ua,supportsComplex:true,cpuKernelImpl:qn});const Va={kernelName:F,backendName:"webgl",kernelFunc:Ma};
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class AddNProgram{constructor(e,t){this.outputShape=[];this.outputShape=e;this.variableNames=t.map(((e,t)=>`T${t}`));const n=[];this.variableNames.forEach((e=>{n.push(`float v${e} = get${e}AtOutCoords();`)}));const o=this.variableNames.map((e=>`v${e}`)).join(" + ");this.userCode=`\n      void main() {\n        ${n.join("\n        ")}\n\n        float result = ${o};\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class AddNPackedProgram{constructor(e,t){this.outputShape=[];this.packedInputs=true;this.packedOutput=true;this.outputShape=e;this.variableNames=t.map(((e,t)=>`T${t}`));const n=[];this.variableNames.forEach((e=>{n.push(`vec4 v${e} = get${e}AtOutCoords();`)}));const o=this.variableNames.map((e=>`v${e}`)).join(" + ");this.userCode=`\n      void main() {\n        ${n.join("\n        ")}\n\n        vec4 result = ${o};\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function addN(e){const{inputs:n,backend:o}=e;const a=n;if(a.length===1)return identity({inputs:{x:a[0]},backend:o});if(a.length>t().getNumber("WEBGL_MAX_TEXTURES_IN_SHADER")){const e=Math.floor(a.length/2);const t=addN({inputs:a.slice(0,e),backend:o});const n=addN({inputs:a.slice(e),backend:o});return addN({inputs:[t,n],backend:o})}const r=a.map((e=>e.dtype)).reduce(((e,t)=>C(e,t)));const s=a.map((e=>e.shape));const i=t().getBool("WEBGL_PACK");const c=i?new AddNPackedProgram(a[0].shape,s):new AddNProgram(a[0].shape,s);return o.runWebGLProgram(c,a,r)}const Wa={kernelName:N,backendName:"webgl",kernelFunc:addN};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function all(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{axis:i,keepDims:c}=r;const l=s.shape.length;const u=n.parseAxisParam(i,s.shape);let d=u;const p=a.getAxesPermutation(d,l);let h=s;if(p!=null){h=transpose({inputs:{x:s},backend:o,attrs:{perm:p}});d=a.getInnerMostAxes(d.length,l)}a.assertAxesAreInnerMostDims("all",d,l);const[f,x]=a.computeOutAndReduceShapes(h.shape,d);const m=n.sizeFromShape(x);const g=reshape({inputs:{x:h},backend:o,attrs:{shape:[-1,m]}});const C=reduce(g,g.dtype,"all",o);let b;if(c){const e=a.expandShapeToKeepDim(f,u);b=reshape({inputs:{x:C},backend:o,attrs:{shape:e}})}else b=reshape({inputs:{x:C},backend:o,attrs:{shape:f}});o.disposeIntermediateTensorInfo(g);o.disposeIntermediateTensorInfo(C);p!=null&&o.disposeIntermediateTensorInfo(h);return b}const Ga={kernelName:E,backendName:"webgl",kernelFunc:all};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function any(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{axis:i,keepDims:c}=r;const l=s.shape.length;const u=n.parseAxisParam(i,s.shape);let d=u;const p=a.getAxesPermutation(d,l);let h=s;if(p!=null){h=transpose({inputs:{x:s},backend:o,attrs:{perm:p}});d=a.getInnerMostAxes(d.length,l)}a.assertAxesAreInnerMostDims("any",d,l);const[f,x]=a.computeOutAndReduceShapes(h.shape,d);const m=n.sizeFromShape(x);const g=reshape({inputs:{x:h},backend:o,attrs:{shape:[-1,m]}});const C=reduce(g,g.dtype,"any",o);let b;if(c){const e=a.expandShapeToKeepDim(f,u);b=reshape({inputs:{x:C},backend:o,attrs:{shape:e}})}else b=reshape({inputs:{x:C},backend:o,attrs:{shape:f}});o.disposeIntermediateTensorInfo(g);o.disposeIntermediateTensorInfo(C);p!=null&&o.disposeIntermediateTensorInfo(h);return b}const za={kernelName:P,backendName:"webgl",kernelFunc:any};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class ArgMinMaxProgram{constructor(e,t,n){this.variableNames=["A"];const{windowSize:o,batchSize:a,outSize:r}=e;n||this.variableNames.push("bestIndicesA");this.outputShape=[a,r];const s=t==="max"?">":"<";const i=n?"inOffset + i;":"round(getBestIndicesA(batch, inOffset + i));";this.userCode=`\n      void main() {\n        ivec2 coords = getOutputCoords();\n        int batch = coords[0];\n        int outIdx = coords[1];\n        int inOffset = outIdx * ${o};\n\n        int bestIndex = inOffset;\n        float bestValue = getA(batch, bestIndex);\n\n        for (int i = 0; i < ${o}; i++) {\n          int inIdx = ${i};\n          float candidate = getA(batch, inIdx);\n          if (candidate ${s} bestValue) {\n            bestValue = candidate;\n            bestIndex = inIdx;\n          }\n        }\n        setOutput(float(bestIndex));\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class ArgMinMaxPackedProgram{constructor(e,t,o,a){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;n.assert(e.length>2,(()=>`Packed arg${o.charAt(0).toUpperCase()+o.slice(1)} supports only inputs with rank above 2.`));const r=e[e.length-1];const s=Math.ceil(r/t);this.outputShape=e.slice(0,-1);s>1&&this.outputShape.push(s);a||this.variableNames.push("bestIndicesA");const i=this.outputShape;const c=i.length;const l=getCoordsDataType(c);const u=getChannels("coords",c);let d;let p;if(s===1){p=c+1;const e=getCoordsDataType(p);d=`\n        ${e} sourceLocR = ${e}(${u.join()}, 0);\n        ++${u[c-1]};\n        ${e} sourceLocG = ${e}(${u.join()}, 0);\n        ++${u[c-2]};\n        ${e} sourceLocA = ${e}(${u.join()}, 0);\n        --${u[c-1]};\n        ${e} sourceLocB = ${e}(${u.join()}, 0);\n        --${u[c-2]};`}else{p=c;d=`\n        ${l} sourceLocR = coords;\n        ++${u[c-1]};\n        ${l} sourceLocG = coords;\n        ++${u[c-2]};\n        ${l} sourceLocA = coords;\n        --${u[c-1]};\n        ${l} sourceLocB = coords;\n        --${u[c-2]};`}const h=["x","y","z","w","u","v"].slice(0,p);const f="."+h[p-1];const x=h.map((e=>"int "+e));const m=getChannels("sourceLocR",p-1).concat("inIdx.r");const g=getChannels("sourceLocG",p-1).concat("inIdx.g");const C=getChannels("sourceLocB",p-1).concat("inIdx.b");const b=getChannels("sourceLocA",p-1).concat("inIdx.a");const v=o==="max"?"greaterThan":"lessThan";const $=a?"":`\n          inIdx = round(vec4(getBestIndicesAChannel(${m.join()}),\n                             getBestIndicesAChannel(${g.join()}),\n                             getBestIndicesAChannel(${C.join()}),\n                             getBestIndicesAChannel(${b.join()})));`;const y=`vec4(\n            getAChannel(${m.join()}),\n            hasNextCol ? getAChannel(${g.join()}) : 0.,\n            hasNextRow ? getAChannel(${C.join()}) : 0.,\n            hasNextRow && hasNextCol ? getAChannel(${b.join()}) : 0.)`;const I=a?"":`\n      float getBestIndicesAChannel(${x.join()}) {\n        return getChannel(getBestIndicesA(${h.join()}),\n                                          vec2(${h.slice(-2).join()}));\n      }`;this.userCode=`\n      float getAChannel(${x.join()}) {\n        return getChannel(getA(${h.join()}),\n                               vec2(${h.slice(-2).join()}));\n      }\n      ${I}\n      void main() {\n        ${l} coords = getOutputCoords();\n        bool hasNextCol = ${u[c-1]} < ${i[c-1]-1};\n        bool hasNextRow = ${u[c-2]} < ${i[c-2]-1};\n        ${d}\n        ivec4 srcIdx = ivec4(sourceLocR${f}, sourceLocG${f},\n          sourceLocB${f}, sourceLocA${f}) * ${t};\n        ivec4 inIdx = srcIdx;\n        vec4 bestIndex = vec4(inIdx);\n        vec4 bestValue = ${y};\n\n        for (int i = 0; i < ${t}; i++) {\n          inIdx = srcIdx;\n          ${$}\n          vec4 candidate = ${y};\n          bvec4 nan = isnan(candidate);\n          bvec4 replace = bvec4(\n            vec4(${v}(candidate, bestValue)) * (vec4(1.0) - vec4(nan)));\n\n          bestValue = vec4(replace.x  ? candidate.x : bestValue.x,\n                           replace.y  ? candidate.y : bestValue.y,\n                           replace.z  ? candidate.z : bestValue.z,\n                           replace.w  ? candidate.w : bestValue.w);\n          bestIndex = mix(bestIndex, vec4(inIdx), vec4(replace));\n          srcIdx++;\n        }\n        setOutput(bestIndex);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function argReduce(e,t,n,o=null){let r=t.shape[0];let s=t.shape[1];if(o!=null){r=o.shape[0];s=o.shape[1]}const i=a.computeOptimalWindowSize(s);const c={windowSize:i,inSize:s,batchSize:r,outSize:Math.ceil(s/i)};const l=new ArgMinMaxProgram(c,n,o==null);const u=[t];o!=null&&u.push(o);const d=e.runWebGLProgram(l,u,"int32");if(d.shape[1]===1)return d;const p=argReduce(e,t,n,d);e.disposeIntermediateTensorInfo(d);return p}function argReducePacked(e,t,n,o=null){const r=o!=null?o.shape:t.shape;const s=r[r.length-1];const i=a.computeOptimalWindowSize(s);const c=new ArgMinMaxPackedProgram(r,i,n,o==null);const l=o==null?[t]:[t,o];const u=e.runWebGLProgram(c,l,"int32");if(u.shape.length===t.shape.length){const o=argReducePacked(e,t,n,u);e.disposeIntermediateTensorInfo(u);return o}return u}function argMinMaxReduce(e,o,r,s){const i=[r];a.assertAxesAreInnerMostDims("arg"+s.charAt(0).toUpperCase()+s.slice(1),i,o.shape.length);if(!t().getBool("WEBGL_PACK_REDUCE")||o.shape.length<=2){const t=[];const r=e.texData.get(o.dataId);const c=r!==null&&r.isPacked;let l=o;if(c){l=e.unpackTensor(o);t.push(l)}const[u,d]=a.computeOutAndReduceShapes(l.shape,i);const p=n.sizeFromShape(d);const h=reshape({inputs:{x:l},backend:e,attrs:{shape:[-1,p]}});t.push(h);const f=argReduce(e,h,s);t.push(f);const x=reshape({inputs:{x:f},backend:e,attrs:{shape:u}});t.forEach((t=>e.disposeIntermediateTensorInfo(t)));return x}return argReducePacked(e,o,s)}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function argMax(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{axis:i}=r;let c=n.parseAxisParam(i,s.shape);const l=a.getAxesPermutation(c,s.shape.length);let u=s;const d=[];if(l!=null){u=transpose({inputs:{x:s},backend:o,attrs:{perm:l}});d.push(u);c=a.getInnerMostAxes(c.length,u.shape.length)}a.assertAxesAreInnerMostDims("argMax",[c[0]],u.shape.length);const p=argMinMaxReduce(o,u,c[0],"max");d.forEach((e=>o.disposeIntermediateTensorInfo(e)));return p}const Xa={kernelName:A,backendName:"webgl",kernelFunc:argMax};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function argMin(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{axis:i}=r;let c=n.parseAxisParam(i,s.shape);const l=a.getAxesPermutation(c,s.shape.length);let u=s;const d=[];if(l!=null){u=transpose({inputs:{x:s},backend:o,attrs:{perm:l}});d.push(u);c=a.getInnerMostAxes(c.length,u.shape.length)}a.assertAxesAreInnerMostDims("argMin",[c[0]],u.shape.length);const p=argMinMaxReduce(o,u,c[0],"min");d.forEach((e=>o.disposeIntermediateTensorInfo(e)));return p}const Ha={kernelName:O,backendName:"webgl",kernelFunc:argMin};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ka=Xo+"\n  if (abs(x) > 1.) {\n    return NAN;\n  }\n  return asin(x);\n";const ja=unaryKernelFunc({opSnippet:Ka});const qa={kernelName:D,backendName:"webgl",kernelFunc:ja};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ya=Xo+"return log(x + sqrt(x * x + 1.0));";const Qa=unaryKernelFunc({opSnippet:Ya});const Za={kernelName:_,backendName:"webgl",kernelFunc:Qa};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ja=Xo+"\n  return atan(x);\n";const er=unaryKernelFunc({opSnippet:Ja});const tr={kernelName:L,backendName:"webgl",kernelFunc:er};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const nr=pa+"\n  return atan(a, b);\n";const or="\n  vec4 result = atan(a, b);\n  bvec4 isNaNA = isnan(a);\n  bvec4 isNaNB = isnan(b);\n  bvec4 isNaN = bvec4(isNaNA.x || isNaNB.x, isNaNA.y || isNaNB.y, isNaNA.z || isNaNB.z, isNaNA.w || isNaNB.w);\n  "+ha+"\n  return result;\n";const ar=binaryKernelFunc({opSnippet:nr,packedOpSnippet:or});const rr={kernelName:B,backendName:"webgl",kernelFunc:ar};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const sr=Xo+"\n  if ((x < -1.0) || (x > 1.0)) return NAN;\nreturn (log(1.0 + x) - log(1.0 - x)) / 2.0;";const ir=unaryKernelFunc({opSnippet:sr});const cr={kernelName:U,backendName:"webgl",kernelFunc:ir};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class Pool2DProgram{constructor(e,t,n,o=false,a=false){this.variableNames=["x"];if(t==="avg"&&n)throw new Error("Cannot compute positions for average pool.");const r=e.filterWidth;const s=e.strideHeight;const i=e.strideWidth;const c=e.dilationHeight;const l=e.dilationWidth;const u=e.effectiveFilterHeight;const d=e.effectiveFilterWidth;const p=e.padInfo.top;const h=e.padInfo.left;this.outputShape=e.outShape;const f=t==="avg";const x=`((batch  * ${e.inHeight} + xR) * ${e.inWidth} + xC) * ${e.inChannels} + d`;const m=`(xR * ${e.inWidth} + xC) * ${e.inChannels} + d`;let g="0.0";f||(g="-1.0 / 1e-20");if(n){const t=">=";this.userCode=`\n        const ivec2 strides = ivec2(${s}, ${i});\n        const ivec2 pads = ivec2(${p}, ${h});\n\n        void main() {\n          ivec4 coords = getOutputCoords();\n          int batch = coords[0];\n          int d = coords[3];\n\n          ivec2 xRCCorner = coords.yz * strides - pads;\n          int xRCorner = xRCCorner.x;\n          int xCCorner = xRCCorner.y;\n\n          // max/min x(?, ?, d) to get y(yR, yC, d).\n          // ? = to be determined\n          float minMaxValue = 0.0;\n          float minMaxValueFound = 0.0;\n          int minMaxPosition = 0;\n          float avgValue = 0.0;\n\n          for (int wR = 0; wR < ${u};\n              wR += ${c}) {\n            int xR = xRCorner + wR;\n\n            if (xR < 0 || xR >= ${e.inHeight}) {\n              continue;\n            }\n\n            for (int wC = 0; wC < ${d};\n                wC += ${l}) {\n              int xC = xCCorner + wC;\n\n              if (xC < 0 || xC >= ${e.inWidth}) {\n                continue;\n              }\n\n              float value = getX(batch, xR, xC, d);\n\n              // If a min / max value has already been found, use it. If not,\n              // use the current value.\n              float currMinMaxValue = mix(\n                  value, minMaxValue, minMaxValueFound);\n              if (value ${t} currMinMaxValue) {\n                minMaxValue = value;\n                minMaxValueFound = 1.0;\n                minMaxPosition = ${o?a?x:m:`wR * ${d} + wC`};\n              }\n            }\n          }\n          setOutput(float(minMaxPosition));\n        }\n      `;return}const C="max";let b=`${t}(${t}(${t}(minMaxValue[0], minMaxValue[1]), minMaxValue[2]), minMaxValue[3])`;t==="avg"&&(b="avgValue / max(count, 1.0)");const v=Math.floor(r/4)*4;const $=r%4;const y=`\n      if (${f}) {\n        avgValue += dot(values, ones);\n      } else {\n        minMaxValue = ${C}(values, minMaxValue);\n      }\n    `;this.userCode=`\n      const ivec2 strides = ivec2(${s}, ${i});\n      const ivec2 pads = ivec2(${p}, ${h});\n      const float initializationValue = ${g};\n      const vec4 ones = vec4(1.0, 1.0, 1.0, 1.0);\n\n      float count = 0.0;\n\n      float getValue(int batch, int xR, int xC, int d) {\n        if (xC < 0 || xC >= ${e.inWidth}) {\n          return initializationValue;\n        }\n        count += 1.0;\n        return getX(batch, xR, xC, d);\n      }\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords[0];\n        int d = coords[3];\n\n        ivec2 xRCCorner = coords.yz * strides - pads;\n        int xRCorner = xRCCorner.x;\n        int xCCorner = xRCCorner.y;\n\n        // max/min x(?, ?, d) to get y(yR, yC, d).\n        // ? = to be determined\n        vec4 minMaxValue = vec4(${g});\n        float avgValue = 0.0;\n        count = 0.0;\n\n        for (int wR = 0; wR < ${u};\n            wR += ${c}) {\n          int xR = xRCorner + wR;\n\n          if (xR < 0 || xR >= ${e.inHeight}) {\n            continue;\n          }\n\n          for (int wC = 0; wC < ${v}; wC += 4) {\n            int xC = xCCorner + wC * ${l};\n\n            vec4 values = vec4(\n              getValue(batch, xR, xC, d),\n              getValue(batch, xR, xC + ${l}, d),\n              getValue(batch, xR, xC + 2 * ${l}, d),\n              getValue(batch, xR, xC + 3 * ${l}, d)\n            );\n\n            ${y}\n          }\n\n          int xC = xCCorner + ${v};\n          if (${$===1}) {\n            vec4 values = vec4(\n              getValue(batch, xR, xC, d),\n              initializationValue,\n              initializationValue,\n              initializationValue\n            );\n\n            ${y}\n          } else if (${$===2}) {\n            vec4 values = vec4(\n              getValue(batch, xR, xC, d),\n              getValue(batch, xR, xC + ${l}, d),\n              initializationValue,\n              initializationValue\n            );\n\n            ${y}\n          } else if (${$===3}) {\n            vec4 values = vec4(\n              getValue(batch, xR, xC, d),\n              getValue(batch, xR, xC + ${l}, d),\n              getValue(batch, xR, xC + 2 * ${l}, d),\n              initializationValue\n            );\n\n            ${y}\n          }\n        }\n        setOutput(${b});\n      }\n    `}}class Pool3DProgram{constructor(e,t,n,o=false,a=false){this.variableNames=["x"];if(t==="avg"&&n)throw new Error("Cannot compute positions for average pool.");const r=e.filterWidth;const s=e.strideDepth;const i=e.strideHeight;const c=e.strideWidth;const l=e.dilationDepth;const u=e.dilationHeight;const d=e.dilationWidth;const p=e.effectiveFilterDepth;const h=e.effectiveFilterHeight;const f=e.effectiveFilterWidth;const x=e.padInfo.front;const m=e.padInfo.top;const g=e.padInfo.left;this.outputShape=e.outShape;const C=t==="avg";let b="0.0";C||(b="-1.0 / 1e-20");if(n){const t=">=";this.userCode=`\n        const ivec3 strides =\n            ivec3(${s}, ${i}, ${c});\n        const ivec3 pads = ivec3(${x}, ${m}, ${g});\n\n        void main() {\n          ivec5 coords = getOutputCoords();\n          int batch = coords.x;\n          int ch = coords.u;\n\n          ivec3 xCorner = ivec3(coords.y, coords.z, coords.w) * strides - pads;\n          int xDCorner = xCorner.x;\n          int xRCorner = xCorner.y;\n          int xCCorner = xCorner.z;\n\n          // max/min x(?, ?, ?, ch) to get y(yD, yR, yC, ch).\n          // ? = to be determined\n          float minMaxValue = 0.0;\n          float minMaxValueFound = 0.0;\n          int minMaxPosition = 0;\n\n          for (int wD = 0; wD < ${p};\n              wD += ${l}) {\n            int xD = xDCorner + wD;\n\n            if (xD < 0 || xD >= ${e.inDepth}) {\n              continue;\n            }\n\n            for (int wR = 0; wR < ${h};\n                wR += ${u}) {\n              int xR = xRCorner + wR;\n\n              if (xR < 0 || xR >= ${e.inHeight}) {\n                continue;\n              }\n\n              for (int wC = 0; wC < ${f};\n                  wC += ${d}) {\n                int xC = xCCorner + wC;\n\n                if (xC < 0 || xC >= ${e.inWidth}) {\n                  continue;\n                }\n\n                float value = getX(batch, xD, xR, xC, ch);\n\n                // If a min / max value has already been found, use it. If not,\n                // use the current value.\n                float currMinMaxValue = mix(\n                    value, minMaxValue, minMaxValueFound);\n                if (value ${t} currMinMaxValue) {\n                  minMaxValue = value;\n                  minMaxValueFound = 1.0;\n                  minMaxPosition = ${o?a?`(((batch * ${e.inDepth} + xD) * ${e.inHeight} + xR) * ${e.inWidth} + xC) * ${e.inChannels} + ch`:`((xD * ${e.inHeight} + xR) * ${e.inWidth} + xC) * ${e.inChannels} + ch`:`wD * ${h} * ${f} +\n                      wR * ${f} + wC`};\n                }\n              }\n            }\n          }\n          setOutput(float(minMaxPosition));\n        }\n      `;return}const v="max";let $=`${t}(${t}(${t}(minMaxValue[0], minMaxValue[1]), minMaxValue[2]), minMaxValue[3])`;t==="avg"&&($="avgValue / max(count, 1.0)");const y=Math.floor(r/4)*4;const I=r%4;const S=`\n      if (${C}) {\n        avgValue += dot(values, ones);\n      } else {\n        minMaxValue = ${v}(values, minMaxValue);\n      }\n    `;this.userCode=`\n      const ivec3 strides =\n        ivec3(${s}, ${i}, ${c});\n      const ivec3 pads = ivec3(${x}, ${m}, ${g});\n      const float initializationValue = ${b};\n      const vec4 ones = vec4(1.0, 1.0, 1.0, 1.0);\n\n      float count = 0.0;\n\n      float getValue(int batch, int xD, int xR, int xC, int ch) {\n        if (xC < 0 || xC >= ${e.inWidth}) {\n          return initializationValue;\n        }\n        count += 1.0;\n        return getX(batch, xD, xR, xC, ch);\n      }\n\n      void main() {\n        ivec5 coords = getOutputCoords();\n        int batch = coords.x;\n        int ch = coords.u;\n\n        ivec3 xCorner = ivec3(coords.y, coords.z, coords.w) * strides - pads;\n        int xDCorner = xCorner.x;\n        int xRCorner = xCorner.y;\n        int xCCorner = xCorner.z;\n\n        // max/min x(?, ?, ?, d) to get y(yD, yR, yC, ch).\n        // ? = to be determined\n        vec4 minMaxValue = vec4(${b});\n        float avgValue = 0.0;\n        count = 0.0;\n\n        for (int wD = 0; wD < ${p};\n            wD += ${l}) {\n          int xD = xDCorner + wD;\n\n          if (xD < 0 || xD >= ${e.inDepth}) {\n            continue;\n          }\n\n          for (int wR = 0; wR < ${h};\n            wR += ${u}) {\n            int xR = xRCorner + wR;\n\n            if (xR < 0 || xR >= ${e.inHeight}) {\n              continue;\n            }\n\n            for (int wC = 0; wC < ${y}; wC += 4) {\n              int xC = xCCorner + wC * ${d};\n\n              vec4 values = vec4(\n                getValue(batch, xD, xR, xC, ch),\n                getValue(batch, xD, xR, xC + ${d}, ch),\n                getValue(batch, xD, xR, xC + 2 * ${d}, ch),\n                getValue(batch, xD, xR, xC + 3 * ${d}, ch)\n              );\n\n              ${S}\n            }\n\n            int xC = xCCorner + ${y};\n            if (${I===1}) {\n              vec4 values = vec4(\n                getValue(batch, xD, xR, xC, ch),\n                initializationValue,\n                initializationValue,\n                initializationValue\n              );\n\n              ${S}\n            } else if (${I===2}) {\n              vec4 values = vec4(\n                getValue(batch, xD, xR, xC, ch),\n                getValue(batch, xD, xR, xC + ${d}, ch),\n                initializationValue,\n                initializationValue\n              );\n\n              ${S}\n            } else if (${I===3}) {\n              vec4 values = vec4(\n                getValue(batch, xD, xR, xC, ch),\n                getValue(batch, xD, xR, xC + ${d}, ch),\n                getValue(batch, xD, xR, xC + 2 * ${d}, ch),\n                initializationValue\n              );\n\n              ${S}\n            }\n          }\n        }\n        setOutput(${$});\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function avgPool(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;assertNotComplex(s,"avgPool");const{filterSize:i,strides:c,pad:l,dimRoundingMode:u}=r;const d=1;n.assert(a.eitherStridesOrDilationsAreOne(c,d),(()=>`Error in avgPool: Either strides or dilations must be 1. Got strides ${c} and dilations '${d}'`));const p=a.computePool2DInfo(s.shape,i,c,d,l,u);if(p.filterWidth===1&&p.filterHeight===1&&n.arraysEqual(p.inShape,p.outShape))return identity({inputs:{x:s},backend:o});const h=new Pool2DProgram(p,"avg",false);return o.runWebGLProgram(h,[s],"float32")}const lr={kernelName:M,backendName:"webgl",kernelFunc:avgPool};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function avgPool3D(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r}=t;const{filterSize:s,strides:i,pad:c,dimRoundingMode:l,dataFormat:u}=o;const d=[1,1,1];const p=a.computePool3DInfo(r.shape,s,i,d,c,l,u);const h=new Pool3DProgram(p,"avg",false);return n.runWebGLProgram(h,[r],"float32")}const ur={kernelName:V,backendName:"webgl",kernelFunc:avgPool3D};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class AvgPool2DBackpropProgram{constructor(e){this.variableNames=["dy"];this.outputShape=e.inShape;const t=e.filterHeight;const n=e.filterWidth;const o=e.strideHeight;const a=e.strideWidth;const r=e.dilationHeight;const s=e.dilationWidth;const i=e.effectiveFilterHeight;const c=e.effectiveFilterWidth;const l=i-1-e.padInfo.top;const u=c-1-e.padInfo.left;const d=1/(t*n);this.userCode=`\n      const ivec2 pads = ivec2(${l}, ${u});\n      const float avgMultiplier = float(${d});\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n\n        ivec2 dyRCCorner = coords.yz - pads;\n        int dyRCorner = dyRCCorner.x;\n        int dyCCorner = dyRCCorner.y;\n\n        // Convolve dy(?, ?, d) with pos mask(:, :, d) to get dx(xR, xC, d).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n        for (int wR = 0; wR < ${i};\n            wR += ${r}) {\n          float dyR = float(dyRCorner + wR) / ${o}.0;\n\n          if (dyR < 0.0 || dyR >= ${e.outHeight}.0 || fract(dyR) > 0.0) {\n            continue;\n          }\n          int idyR = int(dyR);\n\n          for (int wC = 0; wC < ${c};\n            wC+= ${s}) {\n            float dyC = float(dyCCorner + wC) / ${a}.0;\n\n            if (dyC < 0.0 || dyC >= ${e.outWidth}.0 ||\n                fract(dyC) > 0.0) {\n              continue;\n            }\n            int idyC = int(dyC);\n\n            float dyValue = getDy(b, idyR, idyC, d);\n\n            dotProd += dyValue * avgMultiplier;\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}class AvgPool3DBackpropProgram{constructor(e){this.variableNames=["dy"];this.outputShape=e.inShape;const t=e.filterDepth;const n=e.filterHeight;const o=e.filterWidth;const a=e.strideDepth;const r=e.strideHeight;const s=e.strideWidth;const i=e.dilationDepth;const c=e.dilationHeight;const l=e.dilationWidth;const u=e.effectiveFilterDepth;const d=e.effectiveFilterHeight;const p=e.effectiveFilterWidth;const h=u-1-e.padInfo.front;const f=d-1-e.padInfo.top;const x=p-1-e.padInfo.left;const m=1/(t*n*o);this.userCode=`\n      const ivec3 pads = ivec3(${h}, ${f}, ${x});\n      const float avgMultiplier = float(${m});\n\n      void main() {\n        ivec5 coords = getOutputCoords();\n        int batch = coords.x;\n        int ch = coords.u;\n\n        ivec3 dyCorner = ivec3(coords.y, coords.z, coords.w) - pads;\n        int dyDCorner = dyCorner.x;\n        int dyRCorner = dyCorner.y;\n        int dyCCorner = dyCorner.z;\n\n        // Convolve dy(?, ?, ?, d) with pos mask(:, :, :, ch) to get\n        // dx(xD, xR, xC, ch).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n\n        for (int wD = 0; wD < ${u};\n            wD += ${i}) {\n          float dyD = float(dyDCorner + wD) / ${a}.0;\n\n          if (dyD < 0.0 || dyD >= ${e.outDepth}.0 || fract(dyD) > 0.0) {\n            continue;\n          }\n          int idyD = int(dyD);\n\n          for (int wR = 0; wR < ${d};\n              wR += ${c}) {\n            float dyR = float(dyRCorner + wR) / ${r}.0;\n\n            if (dyR < 0.0 || dyR >= ${e.outHeight}.0 ||\n                fract(dyR) > 0.0) {\n              continue;\n            }\n            int idyR = int(dyR);\n\n            for (int wC = 0; wC < ${p};\n                wC += ${l}) {\n              float dyC = float(dyCCorner + wC) / ${s}.0;\n\n              if (dyC < 0.0 || dyC >= ${e.outWidth}.0 ||\n                  fract(dyC) > 0.0) {\n                continue;\n              }\n              int idyC = int(dyC);\n\n              float dyValue = getDy(batch, idyD, idyR, idyC, ch);\n\n              dotProd += dyValue * avgMultiplier;\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function avgPool3DGrad(e){const{inputs:t,backend:n,attrs:o}=e;const{dy:r,input:s}=t;const i=s;const{filterSize:c,strides:l,pad:u,dimRoundingMode:d}=o;const p=[1,1,1];const h=a.computePool3DInfo(i.shape,c,l,p,u,d);const f=new AvgPool3DBackpropProgram(h);return n.runWebGLProgram(f,[r],i.dtype)}const dr={kernelName:W,backendName:"webgl",kernelFunc:avgPool3DGrad};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function avgPoolGrad(e){const{inputs:t,backend:n,attrs:o}=e;const{dy:r,input:s}=t;const i=s;assertNotComplex([r,s],"avgPoolGrad");const{filterSize:c,strides:l,pad:u}=o;const d=a.computePool2DInfo(i.shape,c,l,1,u);const p=new AvgPool2DBackpropProgram(d);return n.runWebGLProgram(p,[r],i.dtype)}const pr={kernelName:G,backendName:"webgl",kernelFunc:avgPoolGrad};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function batchMatMul(e){const{inputs:t,backend:n,attrs:o}=e;const{a:a,b:r}=t;const{transposeA:s,transposeB:i}=o;return batchMatMulImpl({a:a,b:r,transposeA:s,transposeB:i,backend:n})}const hr={kernelName:z,backendName:"webgl",kernelFunc:batchMatMul};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class BatchNormProgram{constructor(e,t,n,o,r,s){this.outputShape=[];this.variableNames=["x","mean","variance"];a.assertAndGetBroadcastShape(e,t);a.assertAndGetBroadcastShape(e,n);let i="0.0";if(o!=null){a.assertAndGetBroadcastShape(e,o);this.variableNames.push("offset");i="getOffsetAtOutCoords()"}let c="1.0";if(r!=null){a.assertAndGetBroadcastShape(e,r);this.variableNames.push("scale");c="getScaleAtOutCoords()"}this.outputShape=e;this.userCode=`\n      void main() {\n        float x = getXAtOutCoords();\n        float mean = getMeanAtOutCoords();\n        float variance = getVarianceAtOutCoords();\n        float offset = ${i};\n        float scale = ${c};\n        float inv = scale * inversesqrt(variance + float(${s}));\n        setOutput(dot(vec3(x, -mean, offset), vec3(inv, inv, 1)));\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class BatchNormPackedProgram{constructor(e,t,n,o,r,s){this.packedInputs=true;this.packedOutput=true;this.variableNames=["x","mean","variance"];a.assertAndGetBroadcastShape(e,t);a.assertAndGetBroadcastShape(e,n);let i="vec4(0.0)";if(o!=null){a.assertAndGetBroadcastShape(e,o);this.variableNames.push("offset");i="getOffsetAtOutCoords()"}let c="vec4(1.0)";if(r!=null){a.assertAndGetBroadcastShape(e,r);this.variableNames.push("scale");c="getScaleAtOutCoords()"}this.outputShape=e;this.userCode=`\n      void main() {\n        vec4 offset = ${i};\n        vec4 scale = ${c};\n\n        vec4 x = getXAtOutCoords();\n        vec4 mean = getMeanAtOutCoords();\n        vec4 variance = getVarianceAtOutCoords();\n\n        vec4 inv = scale * inversesqrt(variance + vec4(${s}));\n\n        setOutput((x - mean) * inv + offset);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const batchNorm=({inputs:e,backend:o,attrs:a})=>{const{x:r,mean:s,variance:i,offset:c,scale:l}=e;n.assert(s.shape.length===i.shape.length,(()=>"Batch normalization gradient requires mean and variance to have equal ranks."));n.assert(c==null||s.shape.length===c.shape.length,(()=>"Batch normalization gradient requires mean and offset to have equal ranks."));n.assert(l==null||s.shape.length===l.shape.length,(()=>"Batch normalization gradient requires mean and scale to have equal ranks."));let{varianceEpsilon:u}=a;u==null&&(u=.001);const d=[r,s,i];let p=null;if(c!=null){p=c.shape;d.push(c)}let h=null;if(l!=null){h=l.shape;d.push(l)}const f=t().getBool("WEBGL_PACK_NORMALIZATION")?new BatchNormPackedProgram(r.shape,s.shape,i.shape,p,h,u):new BatchNormProgram(r.shape,s.shape,i.shape,p,h,u);const x=o.runWebGLProgram(f,d,d[0].dtype);return x};const fr={kernelName:X,backendName:"webgl",kernelFunc:batchNorm};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class SliceProgram{constructor(e){this.variableNames=["source"];this.outputShape=e;this.rank=e.length;const t=getCoordsDataType(this.rank);this.customUniforms=[{name:"start",arrayIndex:this.rank,type:"int"}];const n=getCoords$1(this.rank);let o;const a=e.map(((e,t)=>`sourceLoc.${xr[t]} = start[${t}] + coords.${xr[t]};`));o=`\n        ${t} sourceLoc;\n        ${t} coords = getOutputCoords();\n        ${a.join("\n")}\n      `;this.userCode=`\n      void main() {\n        ${o}\n        setOutput(getSource(${n}));\n      }\n    `}}const xr=["x","y","z","w","u","v"];function getCoords$1(e){if(e===1)return"sourceLoc";if(e<=6)return xr.slice(0,e).map((e=>"sourceLoc."+e)).join(",");throw Error(`Slicing for rank ${e} is not yet supported`)}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class SlicePackedProgram{constructor(e){this.variableNames=["source"];this.packedInputs=true;this.packedOutput=true;this.outputShape=e;this.rank=e.length;this.customUniforms=[{name:"start",arrayIndex:this.rank,type:"int"}];const t=getCoordsDataType(this.rank);const n=getChannels("coords",this.rank);const o=getChannels("sourceLoc",this.rank);const a=this.rank===1?"sourceLoc":`vec2(${o.slice(-2).join()})`;const r=`getChannel(getSource(${o.join()}), ${a})`;const s=`\n      result.x = ${r};\n      if (++${n[this.rank-1]} < ${e[this.rank-1]}) {\n        ++${o[this.rank-1]};\n        result.y = ${r};\n        --${o[this.rank-1]};\n      }\n    `;const i=this.rank===1?"":`\n      --${n[this.rank-1]};\n      if (++${n[this.rank-2]} < ${e[this.rank-2]}) {\n        ++${o[this.rank-2]};\n        result.z = ${r};\n        if (++${n[this.rank-1]} < ${e[this.rank-1]}) {\n          ++${o[this.rank-1]};\n          result.w = ${r};\n        }\n      }\n    `;const c=this.rank<=4?`sourceLoc = coords +\n            ${t}(${e.map(((e,t)=>`start[${t}]`)).join()});`:e.map(((e,t)=>`${o[t]} = ${n[t]} + start[${t}];`)).join("\n");this.userCode=`\n      void main() {\n        ${t} coords = getOutputCoords();\n        ${t} sourceLoc;\n        ${c}\n        vec4 result = vec4(0.);\n        ${s}\n        ${i}\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function shallowSlice(e,t,o,a){const r=a.texData.get(e.dataId);const s=a.makeTensorInfo(o,e.dtype);const i=a.texData.get(s.dataId);Object.assign(i,r);i.refCount=1;i.shape=o;i.dtype=e.dtype;let c=H.computeFlatOffset(t,n.computeStrides(e.shape));r.slice&&(c+=r.slice.flatOffset);i.slice={flatOffset:c,origDataId:r.slice&&r.slice.origDataId||e.dataId};const l=a.dataRefCount.get(i.slice.origDataId)||1;a.dataRefCount.set(i.slice.origDataId,l+1);return s}function slice(e){const{inputs:o,backend:a,attrs:r}=e;const{x:s}=o;const{begin:i,size:c}=r;const[l,u]=H.parseSliceParams(s,i,c);H.assertParamsValid(s,l,u);if(n.sizeFromShape(u)===0)return a.makeTensorInfo(u,s.dtype,[]);if(a.shouldExecuteOnCPU([s])||s.dtype==="string"){const e=a.texData.get(s.dataId);const t=No(e.values,l,u,s.shape,s.dtype);return a.makeTensorInfo(u,s.dtype,t)}const{isPacked:d}=a.texData.get(s.dataId);const p=H.isSliceContinous(s.shape,l,u);if(d||!p){const e=t().getBool("WEBGL_PACK_ARRAY_OPERATIONS")?new SlicePackedProgram(u):new SliceProgram(u);const n=[l];return a.runWebGLProgram(e,[s],s.dtype,n)}a.uploadToGPU(s.dataId);return shallowSlice(s,l,u,a)}const mr={kernelName:K,backendName:"webgl",kernelFunc:slice};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const batchToSpaceND=e=>{const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{blockShape:i,crops:c}=r;n.assert(s.shape.length<=4,(()=>"batchToSpaceND for rank > 4 with a WebGL backend not implemented yet"));const l=i.reduce(((e,t)=>e*t));const u=a.getReshaped(s.shape,i,l);const d=a.getPermuted(u.length,i.length);const p=a.getReshapedPermuted(s.shape,i,l);const h=a.getSliceBeginCoords(c,i.length);const f=a.getSliceSize(p,c,i.length);const x=[];const m=reshape({inputs:{x:s},backend:o,attrs:{shape:u}});const g=transpose({inputs:{x:m},backend:o,attrs:{perm:d}});const C=reshape({inputs:{x:g},backend:o,attrs:{shape:p}});const b=slice({inputs:{x:C},backend:o,attrs:{begin:h,size:f}});x.push(m);x.push(g);x.push(C);x.forEach((e=>o.disposeIntermediateTensorInfo(e)));return b};const gr={kernelName:j,backendName:"webgl",kernelFunc:batchToSpaceND};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function bincount(e){const{inputs:t,backend:n,attrs:o}=e;const{x:a,weights:r}=t;const{size:s}=o;const i=n.readSync(a.dataId);const c=n.readSync(r.dataId);const l=Yn(i,c,r.dtype,r.shape,s);return n.makeTensorInfo([s],r.dtype,l)}const Cr={kernelName:q,backendName:"webgl",kernelFunc:bincount};
/**
 * @license
 * Copyright 2023 Google LLC.
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
 */const br="\n  int r = int(a.r) & int(b.r);\n  int g = int(a.g) & int(b.g);\n  int rb = int(a.b) & int(b.b);\n  int ra = int(a.a) & int(b.a);\n  return vec4(r, g, rb, ra);\n";const vr="\n  return float(int(a.r) & int(b.r));\n";function bitwiseAnd(e){const{inputs:n,backend:o}=e;const{a:a,b:r}=n;const s=t().getBool("WEBGL_PACK_BINARY_OPERATIONS");const i=t().getNumber("WEBGL_VERSION");if(o.shouldExecuteOnCPU([a,r])||i===1){const e=o.texData.get(a.dataId).values;const t=o.texData.get(r.dataId).values;const[n,s]=Zn(a.shape,r.shape,e,t,a.dtype);const i=o.makeTensorInfo(s,a.dtype);const c=o.texData.get(i.dataId);c.values=n;return i}let c;c=s?new BinaryOpPackedProgram(br,a.shape,r.shape,false):new BinaryOpProgram(vr,a.shape,r.shape);return o.runWebGLProgram(c,[a,r],a.dtype)}const $r={kernelName:Y,backendName:"webgl",kernelFunc:bitwiseAnd};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function broadcastArgs(e){const{inputs:t,backend:n}=e;const{s0:o,s1:r}=t;const s=n.readSync(o.dataId);const i=n.readSync(r.dataId);const c=a.assertAndGetBroadcastShape(Array.from(s),Array.from(i));return n.makeTensorInfo([c.length],"int32",Int32Array.from(c))}const yr={kernelName:Q,backendName:"webgl",kernelFunc:broadcastArgs};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ir="return float(a != b);";const Sr=binaryKernelFunc({opSnippet:Ir,cpuKernelImpl:vo,dtype:"bool"});const Tr={kernelName:Z,backendName:"webgl",kernelFunc:Sr};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function real(e){const{inputs:t,backend:n}=e;const{input:o}=t;const a=n.texData.get(o.dataId);return identity({inputs:{x:a.complexTensorInfos.real},backend:n})}const kr={kernelName:J,backendName:"webgl",kernelFunc:real};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const wr="return float(int(x));";function int(e,t){const n=new UnaryOpProgram(e.shape,wr);const o=t.runWebGLProgram(n,[e],"int32");return{dataId:o.dataId,shape:o.shape,dtype:o.dtype}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function cast(t){const{inputs:o,backend:a,attrs:r}=t;const{x:s}=o;const{dtype:i}=r;if(i==="complex64"){if(s.dtype==="complex64")return identity({inputs:{x:s},backend:a});const t=e.zeros(s.shape);const n=cast({inputs:{x:s},backend:a,attrs:{dtype:"float32"}});const o=complex({inputs:{real:n,imag:t},backend:a});t.dispose();a.disposeIntermediateTensorInfo(n);return o}if(s.dtype==="complex64"){const e=real({inputs:{input:s},backend:a});const t=cast({inputs:{x:e},backend:a,attrs:{dtype:i}});a.disposeIntermediateTensorInfo(e);return t}if(!n.hasEncodingLoss(s.dtype,i)){const e=identity({inputs:{x:s},backend:a});return{dataId:e.dataId,shape:e.shape,dtype:i}}if(a.shouldExecuteOnCPU([s])){const e=a.texData.get(s.dataId).values;const[t,n,o]=Jn(e,s.shape,s.dtype,i);return a.makeTensorInfo(t,n,o)}if(i==="int32")return int(s,a);if(i==="bool"){const e=a.makeTensorInfo([],"bool",n.getTypedArrayFromDType("bool",1));const t={a:s,b:e};const o=Sr({inputs:t,backend:a});a.disposeIntermediateTensorInfo(e);return o}throw new Error(`Error in Cast: failed to cast ${s.dtype} to ${i}`)}const Rr={kernelName:ee,backendName:"webgl",kernelFunc:cast};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Fr="return ceil(x);";const Nr=unaryKernelFunc({opSnippet:Fr,packedOpSnippet:Fr,cpuKernelImpl:eo});const Er={kernelName:te,backendName:"webgl",kernelFunc:Nr};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class ClipProgram{constructor(e){this.variableNames=["A"];this.customUniforms=[{name:"minVal",type:"float"},{name:"maxVal",type:"float"}];this.outputShape=e;this.userCode="\n\n      void main() {\n        float value = getAAtOutCoords();\n        if (isnan(value)) {\n          setOutput(value);\n          return;\n        }\n\n        setOutput(clamp(value, minVal, maxVal));\n      }\n    "}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class ClipPackedProgram{constructor(e){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;this.customUniforms=[{name:"minVal",type:"float"},{name:"maxVal",type:"float"}];this.outputShape=e;this.userCode="\n      void main() {\n        vec4 value = getAAtOutCoords();\n\n        if (any(isnan(value))) {\n          setOutput(value);\n          return;\n        }\n\n        setOutput(clamp(value, vec4(minVal), vec4(maxVal)));\n      }\n    "}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function clipByValue(e){const{inputs:n,backend:o,attrs:a}=e;const{x:r}=n;const{clipValueMin:s,clipValueMax:i}=a;let c;c=t().getBool("WEBGL_PACK_CLIP")?new ClipPackedProgram(r.shape):new ClipProgram(r.shape);const l=[[s],[i]];return o.runWebGLProgram(c,[r],r.dtype,l)}const Pr={kernelName:ne,backendName:"webgl",kernelFunc:clipByValue};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class ComplexAbsProgram{constructor(e){this.variableNames=["real","imag"];this.outputShape=e;this.userCode="\n      void main() {\n        float re = abs(getRealAtOutCoords());\n        float im = abs(getImagAtOutCoords());\n        float mx = max(re, im);\n\n        // sadly the length function in glsl is not underflow-safe\n        // (at least not on Intel GPUs). So the safe solution is\n        // to ensure underflow-safety in all cases.\n        setOutput(\n          mx == 0.0 ? 0.0 : mx * length(vec2(1, min(re, im)/mx))\n        );\n      }\n    "}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function makeComplexComponentTensorInfo(e,t){return{dataId:t.dataId,dtype:t.dtype,shape:e.shape}}function complexAbs(e){const{inputs:t,backend:n}=e;const{x:o}=t;const a=n.texData.get(o.dataId);const r=new ComplexAbsProgram(o.shape);const s=[makeComplexComponentTensorInfo(o,a.complexTensorInfos.real),makeComplexComponentTensorInfo(o,a.complexTensorInfos.imag)];return n.runWebGLProgram(r,s,s[0].dtype)}const Ar={kernelName:oe,backendName:"webgl",kernelFunc:complexAbs};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class ConcatProgram{constructor(e){this.outputShape=[];this.outputShape=a.computeOutShape(e,1);this.variableNames=e.map(((e,t)=>`T${t}`));const t=new Array(e.length-1);t[0]=e[0][1];for(let n=1;n<t.length;n++)t[n]=t[n-1]+e[n][1];const n=[`if (yC < ${t[0]}) setOutput(getT0(yR, yC));`];for(let e=1;e<t.length;e++){const o=t[e-1];n.push(`else if (yC < ${t[e]}) setOutput(getT${e}(yR, yC-${o}));`)}const o=t.length;const r=t[t.length-1];n.push(`else setOutput(getT${o}(yR, yC-${r}));`);this.userCode=`\n      void main() {\n        ivec2 coords = getOutputCoords();\n        int yR = coords.x;\n        int yC = coords.y;\n\n        ${n.join("\n        ")}\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class ConcatPackedProgram{constructor(e,t){this.packedInputs=true;this.packedOutput=true;this.outputShape=[];this.outputShape=a.computeOutShape(e,t);const n=this.outputShape;const o=n.length;const r=getCoordsDataType(o);const s=getChannels("coords",o);const i=["x","y","z","w","u","v"].slice(0,o);this.variableNames=e.map(((e,t)=>`T${t}`));const c=new Array(e.length-1);c[0]=e[0][t];for(let n=1;n<c.length;n++)c[n]=c[n-1]+e[n][t];const l=i[t];const u=i.slice(-2);const d=i.join();let p=`if (${l} < ${c[0]}) {\n        return getChannel(\n            getT0(${d}), vec2(${u.join()}));\n        }`;for(let e=1;e<c.length;e++){const t=c[e-1];p+=`\n        if (${l} < ${c[e]}  && ${l} >= ${c[e-1]}) {\n          return getChannel(\n            getT${e}(${shiftedChannels(i,l,t)}),\n            vec2(${shiftedChannels(u,l,t)}));\n        }`}const h=c.length;const f=c[c.length-1];p+=`\n        return getChannel(\n          getT${h}(${shiftedChannels(i,l,f)}),\n          vec2(${shiftedChannels(u,l,f)}));`;this.userCode=`\n      float getValue(${i.map((e=>"int "+e))}) {\n        ${p}\n      }\n\n      void main() {\n        ${r} coords = getOutputCoords();\n        vec4 result = vec4(getValue(${s}), 0., 0., 0.);\n\n        ${s[o-1]} = ${s[o-1]} + 1;\n        if (${s[o-1]} < ${n[o-1]}) {\n          result.g = getValue(${s});\n        }\n\n        ${s[o-2]} = ${s[o-2]} + 1;\n        if (${s[o-2]} < ${n[o-2]}) {\n          result.a = getValue(${s});\n        }\n\n        ${s[o-1]} = ${s[o-1]} - 1;\n        if (${s[o-2]} < ${n[o-2]} &&\n            ${s[o-1]} < ${n[o-1]}) {\n          result.b = getValue(${s});\n        }\n        setOutput(result);\n      }\n    `}}
/**
 * Return an expression for coordinates into a vector where a given channel
 * will be offset by [shift].
 *
 * @param channels the channels to consider
 * @param channel the channel we want shifted
 * @param shift  the amount to subtract from the channel.
 *
 * @returns a string of the form 'x, y-[shift], z' where any one channel can
 * have the shift applied.
 */function shiftedChannels(e,t,n){const o=e.indexOf(t);const a=e.map(((e,t)=>t===o?`${e} - ${n}`:e));return a.join()}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function imag(e){const{inputs:t,backend:n}=e;const{input:o}=t;const a=n.texData.get(o.dataId);return identity({inputs:{x:a.complexTensorInfos.imag},backend:n})}const Or={kernelName:ae,backendName:"webgl",kernelFunc:imag};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function concatImpl(e,o,r){const s=e[0].dtype;if(s==="complex64"){const t=e.map((e=>real({inputs:{input:e},backend:r})));const n=e.map((e=>imag({inputs:{input:e},backend:r})));const a=concatImpl(t,o,r);const s=concatImpl(n,o,r);const i=complex({inputs:{real:a,imag:s},backend:r});t.forEach((e=>r.disposeIntermediateTensorInfo(e)));n.forEach((e=>r.disposeIntermediateTensorInfo(e)));r.disposeIntermediateTensorInfo(a);r.disposeIntermediateTensorInfo(s);return i}let i=r.shouldExecuteOnCPU(e);s==="string"&&(i=true);if(i){const t=e.map((e=>{const t=n.sizeFromShape(e.shape.slice(o));const a=[-1,t];return reshape({inputs:{x:e},backend:r,attrs:{shape:a}})}));const i=t.map((e=>({vals:r.readSync(e.dataId),shape:e.shape})));const c=a.computeOutShape(t.map((e=>e.shape)),1);const l=t[0].shape[0]===1;const u=to(i,c,s,l);const d=a.computeOutShape(e.map((e=>e.shape)),o);const p=r.makeTensorInfo(d,s,u);t.forEach((e=>r.disposeIntermediateTensorInfo(e)));return p}const c=e.filter((e=>n.sizeFromShape(e.shape)>0));const l=t().getBool("WEBGL_PACK_ARRAY_OPERATIONS")&&c[0].shape.length>1;if(c.length===1){const t=l?new UnaryOpProgram(e[0].shape,Qo):new UnaryOpPackedProgram(e[0].shape,Qo);return r.runWebGLProgram(t,e,s)}const u=t().getNumber("WEBGL_MAX_TEXTURES_IN_SHADER");if(c.length>u){const e=[];for(let t=0;t<c.length;t+=u){const n=c.slice(t,t+u);e.push(concatImpl(n,o,r))}const t=concatImpl(e,o,r);for(const t of e)r.disposeIntermediateTensorInfo(t);return t}if(l){const e=new ConcatPackedProgram(c.map((e=>e.shape)),o);return r.runWebGLProgram(e,c,s)}const{tensors2D:d,outShape:p}=computeTensors2D(c,o,r);const h=new ConcatProgram(d.map((e=>e.shape)));const f=r.runWebGLProgram(h,d,s);d.forEach((e=>r.disposeIntermediateTensorInfo(e)));const x=reshape({inputs:{x:f},attrs:{shape:p},backend:r});r.disposeIntermediateTensorInfo(f);return x}function computeTensors2D(e,t,o){const r=a.computeOutShape(e.map((e=>e.shape)),t);const s=e.map((e=>reshape({inputs:{x:e},attrs:{shape:[-1,n.sizeFromShape(e.shape.slice(t))]},backend:o})));return{tensors2D:s,outShape:r}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function concat(e){const{inputs:t,backend:o,attrs:r}=e;const{axis:s}=r;const i=n.parseAxisParam(s,t[0].shape)[0];const c=t.map((e=>e.shape));a.assertParamsConsistent(c,i);const l=a.computeOutShape(t.map((e=>e.shape)),i);if(n.sizeFromShape(l)===0)return o.makeTensorInfo(l,t[0].dtype,[]);const u=t.filter((e=>n.sizeFromShape(e.shape)>0));return u.length===1?identity({inputs:{x:u[0]},backend:o}):concatImpl(u,i,o)}const Dr={kernelName:re,backendName:"webgl",kernelFunc:concat};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class Conv2DProgram{constructor(e,t=false,n=null,o=false,a=false){this.variableNames=["x","W"];this.outputShape=e.outShape;const r=e.padInfo.top;const s=e.padInfo.left;const i=e.strideHeight;const c=e.strideWidth;const l=e.dilationHeight;const u=e.dilationWidth;const d=e.filterHeight;const p=e.filterWidth;const h=Math.floor(e.inChannels/4)*4;const f=e.inChannels%4;const x=e.dataFormat==="channelsLast";const m=x?1:2;const g=x?2:3;const C=x?3:1;let b="",v="";if(n){b=o?`float activation(float a) {\n          float b = getPreluActivationWeightsAtOutCoords();\n          ${n}\n        }`:a?`float activation(float a) {\n          float b = getLeakyreluAlphaAtOutCoords();\n          ${n}\n        }`:`\n          float activation(float x) {\n            ${n}\n          }\n        `;v="result = activation(result);"}const $=t?"result += getBiasAtOutCoords();":"";t&&this.variableNames.push("bias");o&&this.variableNames.push("preluActivationWeights");a&&this.variableNames.push("leakyreluAlpha");this.userCode=`\n      ${b}\n\n      const ivec2 strides = ivec2(${i}, ${c});\n      const ivec2 pads = ivec2(${r}, ${s});\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords[0];\n        int d2 = coords[${C}];\n\n        ivec2 xRCCorner =\n            ivec2(coords[${m}], coords[${g}]) * strides - pads;\n        int xRCorner = xRCCorner.x;\n        int xCCorner = xRCCorner.y;\n\n        // Convolve x(?, ?, d1) with w(:, :, d1, d2) to get y(yR, yC, d2).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n        for (int wR = 0; wR < ${d}; wR++) {\n          int xR = xRCorner + wR * ${l};\n\n          if (xR < 0 || xR >= ${e.inHeight}) {\n            continue;\n          }\n\n          for (int wC = 0; wC < ${p}; wC++) {\n            int xC = xCCorner + wC * ${u};\n\n            if (xC < 0 || xC >= ${e.inWidth}) {\n              continue;\n            }\n\n            for (int d1 = 0; d1 < ${h}; d1 += 4) {\n              vec4 wValues = vec4(\n                getW(wR, wC, d1, d2),\n                getW(wR, wC, d1 + 1, d2),\n                getW(wR, wC, d1 + 2, d2),\n                getW(wR, wC, d1 + 3, d2)\n              );\n\n              if (${x}) {\n                vec4 xValues = vec4(\n                  getX(batch, xR, xC, d1),\n                  getX(batch, xR, xC, d1 + 1),\n                  getX(batch, xR, xC, d1 + 2),\n                  getX(batch, xR, xC, d1 + 3)\n                );\n                dotProd += dot(xValues, wValues);\n              } else {\n                vec4 xValues = vec4(\n                  getX(batch, d1, xR, xC),\n                  getX(batch, d1 + 1, xR, xC),\n                  getX(batch, d1 + 2, xR, xC),\n                  getX(batch, d1 + 3, xR, xC)\n                );\n                dotProd += dot(xValues, wValues);\n              }\n            }\n\n            if (${f===1}) {\n\n              if (${x}) {\n                dotProd +=\n                    getX(batch, xR, xC, ${h}) *\n                    getW(wR, wC, ${h}, d2);\n              } else {\n                dotProd +=\n                    getX(batch, ${h}, xR, xC) *\n                    getW(wR, wC, ${h}, d2);\n              }\n\n            } else if (${f===2}) {\n              vec2 wValues = vec2(\n                getW(wR, wC, ${h}, d2),\n                getW(wR, wC, ${h} + 1, d2)\n              );\n\n              if (${x}) {\n                vec2 xValues = vec2(\n                  getX(batch, xR, xC, ${h}),\n                  getX(batch, xR, xC, ${h} + 1)\n                );\n                dotProd += dot(xValues, wValues);\n              } else {\n                vec2 xValues = vec2(\n                  getX(batch, ${h}, xR, xC),\n                  getX(batch, ${h} + 1, xR, xC)\n                );\n                dotProd += dot(xValues, wValues);\n              }\n\n            } else if (${f===3}) {\n              vec3 wValues = vec3(\n                getW(wR, wC, ${h}, d2),\n                getW(wR, wC, ${h} + 1, d2),\n                getW(wR, wC, ${h} + 2, d2)\n              );\n\n              if (${x}) {\n                vec3 xValues = vec3(\n                  getX(batch, xR, xC, ${h}),\n                  getX(batch, xR, xC, ${h} + 1),\n                  getX(batch, xR, xC, ${h} + 2)\n                );\n                dotProd += dot(xValues, wValues);\n              } else {\n                vec3 xValues = vec3(\n                  getX(batch, ${h}, xR, xC),\n                  getX(batch, ${h} + 1, xR, xC),\n                  getX(batch, ${h} + 2, xR, xC)\n                );\n                dotProd += dot(xValues, wValues);\n              }\n\n            }\n          }\n        }\n\n        float result = dotProd;\n        ${$}\n        ${v}\n        setOutput(result);\n      }\n    `}}class Conv3DProgram{constructor(e){this.variableNames=["x","W"];this.outputShape=e.outShape;const t=e.padInfo.front;const n=e.padInfo.top;const o=e.padInfo.left;const a=e.strideDepth;const r=e.strideHeight;const s=e.strideWidth;const i=e.dilationDepth;const c=e.dilationHeight;const l=e.dilationWidth;const u=e.filterDepth;const d=e.filterHeight;const p=e.filterWidth;const h=Math.floor(e.inChannels/4)*4;const f=e.inChannels%4;this.userCode=`\n      const ivec3 strides = ivec3(${a}, ${r}, ${s});\n      const ivec3 pads = ivec3(${t}, ${n}, ${o});\n\n      void main() {\n        ivec5 coords = getOutputCoords();\n        int batch = coords.x;\n        int d2 = coords.u;\n\n        ivec3 xFRCCorner = ivec3(coords.y, coords.z, coords.w) * strides - pads;\n        int xFCorner = xFRCCorner.x;\n        int xRCorner = xFRCCorner.y;\n        int xCCorner = xFRCCorner.z;\n\n        // Convolve x(?, ?, ?, d1) with w(:, :, :, d1, d2) to get\n        // y(yF, yR, yC, d2). ? = to be determined. : = across all\n        // values in that axis.\n        float dotProd = 0.0;\n        for (int wF = 0; wF < ${u}; wF++) {\n          int xF = xFCorner + wF * ${i};\n\n          if (xF < 0 || xF >= ${e.inDepth}) {\n            continue;\n          }\n\n          for (int wR = 0; wR < ${d}; wR++) {\n            int xR = xRCorner + wR * ${c};\n\n            if (xR < 0 || xR >= ${e.inHeight}) {\n              continue;\n            }\n\n            for (int wC = 0; wC < ${p}; wC++) {\n              int xC = xCCorner + wC * ${l};\n\n              if (xC < 0 || xC >= ${e.inWidth}) {\n                continue;\n              }\n\n              for (int d1 = 0; d1 < ${h}; d1 += 4) {\n                vec4 xValues = vec4(\n                  getX(batch, xF, xR, xC, d1),\n                  getX(batch, xF, xR, xC, d1 + 1),\n                  getX(batch, xF, xR, xC, d1 + 2),\n                  getX(batch, xF, xR, xC, d1 + 3)\n                );\n                vec4 wValues = vec4(\n                  getW(wF, wR, wC, d1, d2),\n                  getW(wF, wR, wC, d1 + 1, d2),\n                  getW(wF, wR, wC, d1 + 2, d2),\n                  getW(wF, wR, wC, d1 + 3, d2)\n                );\n\n                dotProd += dot(xValues, wValues);\n              }\n\n              if (${f===1}) {\n                dotProd +=\n                  getX(batch, xF, xR, xC, ${h}) *\n                  getW(wF, wR, wC, ${h}, d2);\n              } else if (${f===2}) {\n                vec2 xValues = vec2(\n                  getX(batch, xF, xR, xC, ${h}),\n                  getX(batch, xF, xR, xC, ${h} + 1)\n                );\n                vec2 wValues = vec2(\n                  getW(wF, wR, wC, ${h}, d2),\n                  getW(wF, wR, wC, ${h} + 1, d2)\n                );\n                dotProd += dot(xValues, wValues);\n              } else if (${f===3}) {\n                vec3 xValues = vec3(\n                  getX(batch, xF, xR, xC, ${h}),\n                  getX(batch, xF, xR, xC, ${h} + 1),\n                  getX(batch, xF, xR, xC, ${h} + 2)\n                );\n                vec3 wValues = vec3(\n                  getW(wF, wR, wC, ${h}, d2),\n                  getW(wF, wR, wC, ${h} + 1, d2),\n                  getW(wF, wR, wC, ${h} + 2, d2)\n                );\n                dotProd += dot(xValues, wValues);\n              }\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}
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
 */class Conv2DPackedProgram{constructor(e,t=false,o=null,a=false,r=false){this.variableNames=["x","W"];this.packedInputs=true;this.packedOutput=true;this.customUniforms=[{name:"pads",type:"ivec2"},{name:"strides",type:"ivec2"},{name:"dilations",type:"ivec2"},{name:"inDims",type:"ivec2"}];this.outputShape=e.outShape;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);const s=e.padInfo.left;const i=e.strideWidth;const c=e.dilationWidth;const l=e.filterHeight;const u=e.filterWidth;const d=u;let p="\n       int xR; int xC; int xCOffset;\n       vec4 wTexel; vec4 previous; vec4 final;";for(let e=0;e<u;e++)p+=`\n           vec4 xTexelC${e*2};\n           int xTexelC${e*2}Ready;\n           vec4 xTexelC${e*2+1};\n           int xTexelC${e*2+1}Ready;\n           vec4 xC${e};`;p+=`\n     for (int r = 0; r < ${l}; r++) {\n      for (int d1 = 0; d1 < ${e.inChannels}; d1 += 2) {\n       `;for(let e=0;e<u;e++)p+=`\n           xTexelC${e*2} = vec4(0.0);\n           xTexelC${e*2}Ready = 0;\n           xTexelC${e*2+1} = vec4(0.0);\n           xTexelC${e*2+1}Ready = 0;\n           xC${e} = vec4(0.0);`;p+="\n         xR = xRCorner + r * dilations[0];\n         if (xR >=0 && xR < inDims[0]) {\n       ";for(let t=0;t<(d+1)/2;t++){const o=t*2;p+=`\n           xC = xCCorner + ${o*c};\n           `;if(i===1){if(o<u){if(s%2===1){p+=`\n                 xCOffset = xC + 1;\n                 if (xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${o}Ready == 0) {\n                   xTexelC${o} = getX(batch, xR, xCOffset, d1);\n\n                   // Need to manually clear unused channels in case\n                   // we're reading from recycled texture.\n                   if (xCOffset + 1 >= inDims[1]) {\n                     xTexelC${o}.zw = vec2(0.0);\n                   }\n                   xTexelC${o}Ready = 1;\n                 }\n               `;p+=c===1&&o>0?`\n                 xC${o} = vec4(xTexelC${o-2}.zw, xTexelC${o}.xy);\n                 `:`\n                   xCOffset = xC + 1 - 2;\n\n                   if (xCOffset >= 0 && xCOffset < inDims[1]) {\n                     previous = getX(batch, xR, xCOffset, d1);\n\n                     // Need to manually clear unused channels in case\n                     // we're reading from recycled texture.\n                     if (xCOffset + 1 >= inDims[1]) {\n                       previous.zw = vec2(0.0);\n                     }\n\n                     xC${o} = vec4(previous.zw, xTexelC${o}.xy);\n                   } else {\n                     xC${o} = vec4(0.0, 0.0, xTexelC${o}.xy);\n                   }\n                   `}else p+=`\n                 if (xC >= 0 && xC < inDims[1] && xTexelC${o}Ready == 0) {\n                   xTexelC${o} = getX(batch, xR, xC, d1);\n                   if (xC + 1 >= inDims[1]) {\n                     xTexelC${o}.zw = vec2(0.0);\n                   }\n                   xTexelC${o}Ready = 1;\n                 }\n\n                 xC${o} = xTexelC${o};\n                 `;if(o+1<u){const e=s%2===0?n.nearestLargerEven(c):c;if(c%2===0&&s%2===1||c%2!==0&&s%2!==1){p+=`\n                   xCOffset = xC + imod(pads[1], 2) + ${e};\n\n                   if (xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${o+1}Ready == 0) {\n                     xTexelC${o+1} = getX(batch, xR, xCOffset, d1);\n\n                     // Need to manually clear unused channels in case\n                     // we're reading from recycled texture.\n                     if (xCOffset + 1 >= inDims[1]) {\n                       xTexelC${o+1}.zw = vec2(0.0);\n                     }\n                     xTexelC${o+1}Ready = 1;\n                   }\n                   `;p+=c>1?`\n                     xCOffset -= 2;\n                     if (xCOffset >= 0 && xCOffset < inDims[1]) {\n                      previous = getX(batch, xR, xCOffset, d1);\n                      xC${o+1} = vec4(previous.zw, xTexelC${o+1}.xy);\n                     } else {\n                      xC${o+1} = vec4(0.0, 0.0, xTexelC${o+1}.xy);\n                     }\n                     `:`\n                     xC${o+1} = vec4(xTexelC${o}.zw, xTexelC${o+1}.xy);\n                     `}else p+=e===1?`\n                     xC${o+1} = xTexelC${o};\n                     `:`\n                     xCOffset = xC + ${e};\n\n                     if (xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${o+1}Ready == 0) {\n                       xTexelC${o+1} = getX(batch, xR, xCOffset, d1);\n                       if (xCOffset + 1 >= inDims[1]) {\n                         xTexelC${o+1}.zw = vec2(0.0);\n                       }\n                       xTexelC${o+1}Ready = 1;\n                     }\n\n                     xC${o+1} = xTexelC${o+1};\n                     `}}}else if(o<u)if(s%2===1){p+=`\n                 xCOffset = xC + 1 - strides[1];\n                 if(xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${o}Ready == 0) {\n                   xTexelC${o} = getX(batch, xR, xCOffset, d1);\n                   // Need to manually clear unused channels in case\n                   // we're reading from recycled texture.\n                   if (xCOffset + 1 >= inDims[1]) {\n                     xTexelC${o}.zw = vec2(0.0);\n                   }\n                   xTexelC${o}Ready = 1;\n                 }\n\n                 if(xC + 1 >= 0 && xC + 1 < inDims[1] && xTexelC${o+1}Ready == 0) {\n                   xTexelC${o+1} = getX(batch, xR, xC + 1, d1);\n                   // Need to manually clear unused channels in case\n                   // we're reading from recycled texture.\n                   if (xC + 2 >= inDims[1]) {\n                     xTexelC${o+1}.zw = vec2(0.0);\n                   }\n                   xTexelC${o+1}Ready = 1;\n                 }\n\n                 xC${o} = vec4(xTexelC${o}.zw, xTexelC${o+1}.zw);\n               `;o+1<u&&(p+=`\n                   final = vec4(0.0);\n                   xCOffset = xC + 1 + strides[1];\n                   if(xCOffset >= 0 && xCOffset < inDims[1]) {\n                     final = getX(batch, xR, xCOffset, d1);\n                   }\n                   xC${o+1} = vec4(xTexelC${o+1}.xy, final.xy);\n                 `)}else{p+=`\n                 if(xC >= 0 && xC < inDims[1] && xTexelC${o}Ready == 0) {\n                   xTexelC${o} = getX(batch, xR, xC, d1);\n                   if (xC + 1 >= inDims[1]) {\n                     xTexelC${o}.zw = vec2(0.0);\n                   }\n                   xTexelC${o}Ready = 1;\n                 }\n\n                 xCOffset = xC + strides[1];\n                 if(xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${o+1}Ready == 0) {\n                   xTexelC${o+1} = getX(batch, xR, xCOffset, d1);\n                   if (xCOffset + 1 >= inDims[1]) {\n                     xTexelC${o+1}.zw = vec2(0.);\n                   }\n                   xTexelC${o+1}Ready = 1;\n                 }\n\n                 xC${o} = vec4(\n                   xTexelC${o}.xy, xTexelC${o+1}.xy);\n               `;o+1<u&&(p+=`\n                   xC${o+1} = vec4(xTexelC${o}.zw, xTexelC${o+1}.zw);\n                 `)}if(o<u){p+=`\n             wTexel = getW(r, ${o}, d1, d2);\n             dotProd += xC${o}.xxzz * vec4(wTexel.xy, wTexel.xy);\n             if(d1 + 1 < ${e.inChannels}) {\n               dotProd += xC${o}.yyww * vec4(wTexel.zw, wTexel.zw);\n             }\n           `;o+1<u&&(p+=`\n               wTexel = getW(r, ${o+1}, d1, d2);\n               dotProd += xC${o+1}.xxzz * vec4(wTexel.xy, wTexel.xy);\n               if(d1 + 1 < ${e.inChannels}) {\n                 dotProd += xC${o+1}.yyww * vec4(wTexel.zw, wTexel.zw);\n               }\n             `)}}p+="\n     }\n   ";p+="\n     }\n   ";p+="\n     }\n   ";let h="",f="";if(o){h=a?`vec4 activation(vec4 a) {\n           vec4 b = getPreluActivationWeightsAtOutCoords();\n           ${o}\n         }`:r?`vec4 activation(vec4 a) {\n           vec4 b = getLeakyreluAlphaAtOutCoords();\n           ${o}\n         }`:`vec4 activation(vec4 x) {\n           ${o}\n         }`;f="result = activation(result);"}const x=t?"result += getBiasAtOutCoords();":"";t&&this.variableNames.push("bias");a&&this.variableNames.push("preluActivationWeights");r&&this.variableNames.push("leakyreluAlpha");this.userCode=`\n       ${h}\n\n       void main() {\n         ivec4 coords = getOutputCoords();\n         int batch = coords.x;\n         ivec2 xRCCorner = coords.yz * strides - pads;\n         int d2 = coords.w;\n         int xRCorner = xRCCorner.x;\n         int xCCorner = xRCCorner.y;\n\n         //intialize dotProd with a small epsilon seems to reduce GPU accuracy loss.\n         vec4 dotProd = vec4(0.000000000000001);\n\n         ${p}\n\n         vec4 result = dotProd - vec4(0.000000000000001);\n         ${x}\n         ${f}\n         setOutput(result);\n       }\n     `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class Im2ColPackedProgram{constructor(e,t){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;this.customUniforms=[{name:"inputShape",type:"ivec4"},{name:"pad",type:"ivec2"},{name:"stride",type:"ivec2"},{name:"dilation",type:"ivec2"},{name:"inChannels",type:"int"},{name:"itemsPerBlockRow",type:"int"},{name:"outWidth",type:"int"}];this.outputShape=e;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);const{dataFormat:n}=t;const o=getGlslDifferences();const a=n==="channelsLast";const r=a?1:2;const s=a?2:3;const i=this.enableShapeUniforms?"if(blockIndex < outShape[2] && pos < outShape[1]) {":`if(blockIndex < ${e[2]} && pos < ${e[1]}) {`;let c="";for(let e=0;e<=1;e++)for(let t=0;t<=1;t++)c+=`\n          blockIndex = rc.z + ${t};\n          pos = rc.y + ${e};\n\n          ${i}\n            offsetY = int(blockIndex / outWidth) * stride[0] - pad[0];\n            d0 = offsetY + dilation[0] * (pos / itemsPerBlockRow);\n\n            if(d0 < inputShape[${r}] && d0 >= 0) {\n              // Use custom imod instead mod. On Intel GPU, mod may generate\n              // unexpected value.\n              // https://github.com/tensorflow/tfjs/issues/5447\n              offsetX = imod(blockIndex, outWidth) * stride[1] - pad[1];\n              d1 = offsetX + dilation[1] * (imod(pos, itemsPerBlockRow) /\n                  inChannels);\n\n              if(d1 < inputShape[${s}] && d1 >= 0) {\n\n                ch = imod(pos, inChannels);\n\n                if (${a}) {\n                  innerDims = vec2(d1, ch);\n                  result[${e*2+t}] = getChannel(\n                    getA(rc.x, d0, int(innerDims.x),\n                    int(innerDims.y)), innerDims);\n                } else {\n                  innerDims = vec2(d0, d1);\n                  result[${e*2+t}] = getChannel(\n                    getA(rc.x, ch, int(innerDims.x),\n                    int(innerDims.y)), innerDims);\n                }\n              }\n            }\n          }\n        `;this.userCode=`\n      void main() {\n        ivec3 rc = getOutputCoords();\n\n        vec4 result = vec4(0);\n\n        int blockIndex, pos, offsetY, d0, offsetX, d1, ch;\n        vec2 innerDims;\n\n        ${c}\n\n        ${o.output} = result;\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function getShapeForBatchMatMul(e,t){const n=e.length;return n>=3?t?[...e.slice(0,-3),e[n-3]*e[n-2],e[n-1]]:[...e.slice(0,-3),e[n-3],e[n-2]*e[n-1]]:!t&&n===1&&e[0]>1?[e[0],1]:null}function conv2dByMatMul({x:e,filter:t,convInfo:o,backend:a,bias:r=null,preluActivationWeights:s=null,leakyreluAlpha:i=0,activation:c=null}){const l=e.shape;const u=a.texData.get(e.dataId);const d=o.inChannels;const p=l[0]*l[1]*l[2];const h=o.outChannels;const f=o.dataFormat==="channelsLast";const x=false;const m=false;let g;const C=[];if(s!=null){const e=getShapeForBatchMatMul(s.shape,f);if(e!=null){s=reshape({inputs:{x:s},backend:a,attrs:{shape:e}});C.push(s)}}if(r!=null){const e=getShapeForBatchMatMul(r.shape,f);if(e!=null){r=reshape({inputs:{x:r},backend:a,attrs:{shape:e}});C.push(r)}}const b=(p===1||h===1)&&d>Fa;const v=!b&&u.isPacked&&f&&u.texture!=null&&l[2]%2!==0&&n.arraysEqual(u.shape.slice(-3),l.slice(-3));if(v){const d=l[0]*l[1]*(l[2]+1);const p={dataId:e.dataId,shape:[1,d,o.inChannels],dtype:e.dtype};const h=u.shape;u.shape=u.shape.slice();u.shape[u.shape.length-2]++;n.assert(isReshapeFree(u.shape,p.shape),(()=>`packed reshape ${u.shape} to ${p.shape} isn't free`));const f=reshape({inputs:{x:t},backend:a,attrs:{shape:[1,o.inChannels,o.outChannels]}});C.push(f);const b=batchMatMulImpl({a:p,b:f,backend:a,transposeA:x,transposeB:m,bias:r,activation:c,preluActivationWeights:s,leakyreluAlpha:i});const v=a.texData.get(b.dataId);n.assert(v.isPacked,(()=>"batchMatMul result is expected to be packed"));u.shape=h;v.shape=o.outShape;g=identity({inputs:{x:b},backend:a});g.shape=o.outShape;C.push(b)}else{const n=o.outHeight*o.outWidth;const l=reshape({inputs:{x:e},backend:a,attrs:{shape:f?[o.batchSize,n,o.inChannels]:[o.batchSize,o.inChannels,n]}});const u=reshape({inputs:{x:t},backend:a,attrs:{shape:[1,o.inChannels,o.outChannels]}});const d=batchMatMulImpl({a:f?l:u,b:f?u:l,transposeA:!f,transposeB:m,backend:a,bias:r,activation:c,preluActivationWeights:s,leakyreluAlpha:i});g=reshape({inputs:{x:d},backend:a,attrs:{shape:o.outShape}});C.push(l);C.push(u);C.push(d)}for(const e of C)a.disposeIntermediateTensorInfo(e);return g}function conv2dWithIm2Row({x:e,filter:t,convInfo:o,backend:a,bias:r=null,preluActivationWeights:s=null,leakyreluAlpha:i=0,activation:c=null}){const{filterWidth:l,filterHeight:u,inChannels:d,outWidth:p,outHeight:h,dataFormat:f}=o;const x=f==="channelsLast";const m=l*u*d;const g=h*p;const C=[o.batchSize,m,g];const b=true;const v=false;const $=[];if(s!=null){const e=getShapeForBatchMatMul(s.shape,x);if(e!=null){s=reshape({inputs:{x:s},backend:a,attrs:{shape:e}});$.push(s)}}if(r!=null){const e=getShapeForBatchMatMul(r.shape,x);if(e!=null){r=reshape({inputs:{x:r},backend:a,attrs:{shape:e}});$.push(r)}}const y=reshape({inputs:{x:t},backend:a,attrs:{shape:[1,m,n.sizeFromShape(t.shape)/m]}});$.push(y);const I=new Im2ColPackedProgram(C,o);const S=[e.shape,[o.padInfo.top,o.padInfo.left],[o.strideHeight,o.strideWidth],[o.dilationHeight,o.dilationWidth],[o.inChannels],[o.filterWidth*o.inChannels],[o.outWidth]];const T=a.runWebGLProgram(I,[e],"float32",S);const k=reshape({inputs:{x:T},backend:a,attrs:{shape:C}});$.push(T);$.push(k);const w=r!=null;const R=s!=null;const F=c==="leakyrelu";const N=c?mapActivationToShaderProgram(c,true):null;const E=new MatMulPackedProgram(x?k.shape:y.shape,x?y.shape:k.shape,x?[o.batchSize,g,o.outChannels]:[o.batchSize,o.outChannels,g],b,v,w,N,R,F);const P=x?[k,y]:[y,k];r&&P.push(r);R&&P.push(s);if(F){const e=a.makeTensorInfo([],"float32",n.createScalarValue(i,"float32"));P.push(e);$.push(e)}const A=a.runWebGLProgram(E,P,"float32");const O=reshape({inputs:{x:A},backend:a,attrs:{shape:o.outShape}});$.push(A);for(const e of $)a.disposeIntermediateTensorInfo(e);return O}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function conv2d(e){const{inputs:n,backend:o,attrs:r}=e;const{x:s,filter:i}=n;const{strides:c,pad:l,dataFormat:u,dilations:d,dimRoundingMode:p}=r;const h=a.convertConv2DDataFormat(u);const f=a.computeConv2DInfo(s.shape,i.shape,c,d,l,p,false,h);let x;if(f.filterHeight!==1||f.filterWidth!==1||f.dilationHeight!==1||f.dilationWidth!==1||f.strideHeight!==1||f.strideWidth!==1||f.padInfo.type!=="SAME"&&f.padInfo.type!=="VALID")if(f.strideWidth<=2&&h==="channelsLast"&&t().getBool("WEBGL_EXP_CONV")){const e=new Conv2DPackedProgram(f);const t=[[f.padInfo.top,f.padInfo.left],[f.strideHeight,f.strideWidth],[f.dilationHeight,f.dilationWidth],[f.inHeight,f.inWidth]];x=o.runWebGLProgram(e,[s,i],"float32",t)}else if(t().getBool("WEBGL_CONV_IM2COL"))x=conv2dWithIm2Row({x:s,filter:i,convInfo:f,backend:o});else{const e=new Conv2DProgram(f);x=o.runWebGLProgram(e,[s,i],"float32")}else x=conv2dByMatMul({x:s,filter:i,convInfo:f,backend:o});const m=reshape({inputs:{x:x},backend:o,attrs:{shape:f.outShape}});o.disposeIntermediateTensorInfo(x);return m}const _r={kernelName:se,backendName:"webgl",kernelFunc:conv2d};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class Conv2DDerFilterProgram{constructor(e){this.variableNames=["x","dy"];this.outputShape=e.filterShape;const t=e.strideHeight;const n=e.strideWidth;const o=e.padInfo.top;const a=e.padInfo.left;const r=e.dataFormat==="channelsLast";this.userCode=`\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int wR = coords.x;\n        int wC = coords.y;\n        int d1 = coords.z;\n        int d2 = coords.w;\n\n        // Convolve x(?, ?, d1) with dy(:, :, d2) to get dw(wR, wC, d1, d2).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n\n        for (int b = 0; b < ${e.batchSize}; b++) {\n          for (int yR = 0; yR < ${e.outHeight}; yR++) {\n            int xR = wR + yR * ${t} - ${o};\n\n            if (xR < 0 || xR >= ${e.inHeight}) {\n              continue;\n            }\n\n            for (int yC = 0; yC < ${e.outWidth}; yC++) {\n              int xC = wC + yC * ${n} - ${a};\n\n              if (xC < 0 || xC >= ${e.inWidth}) {\n                continue;\n              }\n\n              ${r?"float dyValue = getDy(b, yR, yC, d2);\n              float xValue = getX(b, xR, xC, d1);\n              dotProd += (xValue * dyValue);":"float dyValue = getDy(b, d2, yR, yC);\n              float xValue = getX(b, d1, xR, xC);\n              dotProd += (xValue * dyValue);"}\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}class Conv2DDerInputProgram{constructor(e){this.variableNames=["dy","W"];this.outputShape=e.inShape;const t=e.filterHeight;const n=e.filterWidth;const o=e.strideHeight;const a=e.strideWidth;const r=e.dataFormat==="channelsLast";const s=t-1-e.padInfo.top;const i=n-1-e.padInfo.left;const c=r?1:2;const l=r?2:3;const u=r?3:1;this.userCode=`\n      const ivec2 pads = ivec2(${s}, ${i});\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords[0];\n        int d1 = coords[${u}];\n\n        ivec2 dyCorner = ivec2(coords[${c}], coords[${l}]) - pads;\n        int dyRCorner = dyCorner.x;\n        int dyCCorner = dyCorner.y;\n\n        // Convolve dy(?, ?, d2) with w(:, :, d1, d2) to compute dx(xR, xC, d1).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n        for (int wR = 0; wR < ${t}; wR++) {\n          float dyR = float(dyRCorner + wR) / ${o}.0;\n\n          if (dyR < 0.0 || dyR >= ${e.outHeight}.0 || fract(dyR) > 0.0) {\n            continue;\n          }\n          int idyR = int(dyR);\n\n          int wRPerm = ${t} - 1 - wR;\n\n          for (int wC = 0; wC < ${n}; wC++) {\n            float dyC = float(dyCCorner + wC) / ${a}.0;\n\n            if (dyC < 0.0 || dyC >= ${e.outWidth}.0 ||\n                fract(dyC) > 0.0) {\n              continue;\n            }\n            int idyC = int(dyC);\n\n            int wCPerm = ${n} - 1 - wC;\n\n            for (int d2 = 0; d2 < ${e.outChannels}; d2++) {\n\n              if (${r}) {\n                float xValue = getDy(batch, idyR, idyC, d2);\n                float wValue = getW(wRPerm, wCPerm, d1, d2);\n                dotProd += xValue * wValue;\n              } else {\n                float xValue = getDy(batch, d2, idyR, idyC);\n                float wValue = getW(wRPerm, wCPerm, d1, d2);\n                dotProd += xValue * wValue;\n              }\n\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}class Conv3DDerFilterProgram{constructor(e){this.variableNames=["x","dy"];this.outputShape=e.filterShape;const t=e.strideDepth;const n=e.strideHeight;const o=e.strideWidth;const a=e.padInfo.front;const r=e.padInfo.top;const s=e.padInfo.left;this.userCode=`\n      void main() {\n        ivec5 coords = getOutputCoords();\n        int wF = coords.x;\n        int wR = coords.y;\n        int wC = coords.z;\n        int d1 = coords.w;\n        int d2 = coords.u;\n\n        float dotProd = 0.0;\n\n        for (int b = 0; b < ${e.batchSize}; b++) {\n          for (int yF = 0; yF < ${e.outDepth}; yF++) {\n            int xF = wF + yF * ${t} - ${a};\n\n            if (xF < 0 || xF >= ${e.inDepth}) {\n              continue;\n            }\n\n            for (int yR = 0; yR < ${e.outHeight}; yR++) {\n              int xR = wR + yR * ${n} - ${r};\n\n              if (xR < 0 || xR >= ${e.inHeight}) {\n                continue;\n              }\n\n              for (int yC = 0; yC < ${e.outWidth}; yC++) {\n                int xC = wC + yC * ${o} - ${s};\n\n                if (xC < 0 || xC >= ${e.inWidth}) {\n                  continue;\n                }\n\n                float dyValue = getDy(b, yF, yR, yC, d2);\n                float xValue = getX(b, xF, xR, xC, d1);\n                dotProd += (xValue * dyValue);\n              }\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}class Conv3DDerInputProgram{constructor(e){this.variableNames=["dy","W"];this.outputShape=e.inShape;const t=e.filterDepth;const n=e.filterHeight;const o=e.filterWidth;const a=e.strideDepth;const r=e.strideHeight;const s=e.strideWidth;const i=t-1-e.padInfo.front;const c=n-1-e.padInfo.top;const l=o-1-e.padInfo.left;this.userCode=`\n      const ivec3 pads = ivec3(${i}, ${c}, ${l});\n\n      void main() {\n        ivec5 coords = getOutputCoords();\n        int batch = coords.x;\n        int d1 = coords.u;\n\n\n        ivec3 dyCorner = ivec3(coords.y, coords.z, coords.w) - pads;\n        int dyFCorner = dyCorner.x;\n        int dyRCorner = dyCorner.y;\n        int dyCCorner = dyCorner.z;\n\n        float dotProd = 0.0;\n        for (int wF = 0; wF < ${t}; wF++) {\n          float dyF = float(dyFCorner + wF) / ${a}.0;\n\n          if (dyF < 0.0 || dyF >= ${e.outDepth}.0 || fract(dyF) > 0.0) {\n            continue;\n          }\n          int idyF = int(dyF);\n\n          int wFPerm = ${t} - 1 - wF;\n\n          for (int wR = 0; wR < ${n}; wR++) {\n            float dyR = float(dyRCorner + wR) / ${r}.0;\n\n            if (dyR < 0.0 || dyR >= ${e.outHeight}.0 ||\n              fract(dyR) > 0.0) {\n              continue;\n            }\n            int idyR = int(dyR);\n\n            int wRPerm = ${n} - 1 - wR;\n\n            for (int wC = 0; wC < ${o}; wC++) {\n              float dyC = float(dyCCorner + wC) / ${s}.0;\n\n              if (dyC < 0.0 || dyC >= ${e.outWidth}.0 ||\n                  fract(dyC) > 0.0) {\n                continue;\n              }\n              int idyC = int(dyC);\n\n              int wCPerm = ${o} - 1 - wC;\n\n              for (int d2 = 0; d2 < ${e.outChannels}; d2++) {\n                float xValue = getDy(batch, idyF, idyR, idyC, d2);\n                float wValue = getW(wFPerm, wRPerm, wCPerm, d1, d2);\n                dotProd += xValue * wValue;\n              }\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function conv2DBackpropFilter(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r,dy:s}=t;const{strides:i,pad:c,dataFormat:l,dimRoundingMode:u,filterShape:d}=o;const p=a.convertConv2DDataFormat(l);const h=a.computeConv2DInfo(r.shape,d,i,1,c,u,false,p);const f=new Conv2DDerFilterProgram(h);return n.runWebGLProgram(f,[r,s],"float32")}const Lr={kernelName:ie,backendName:"webgl",kernelFunc:conv2DBackpropFilter};
/**
 * @license
 * Copyright 2023 Google LLC.
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
 */class Conv2DDerInputPackedProgram{constructor(e){this.variableNames=["dy","W"];this.packedInputs=true;this.packedOutput=true;this.customUniforms=[{name:"strides",type:"vec2"}];this.outputShape=e.inShape;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);const t=e.filterHeight;const n=e.filterWidth;const o=t-1-e.padInfo.top;const a=n-1-e.padInfo.left;this.userCode=`\n      const ivec2 pads = ivec2(${o}, ${a});\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords[0];\n        int d1 = coords[3];\n\n        ivec2 dyCorner = ivec2(coords[1], coords[2]) - pads;\n        int dyRCorner = dyCorner.x;\n        int dyCCorner = dyCorner.y;\n\n        vec4 result = vec4(0.);\n        for (int wR = 0; wR < ${t}; wR++) {\n          float dyR = float(dyRCorner + wR) / strides[0];\n          if (dyR < 0.0 || dyR >= ${e.outHeight}.0 || fract(dyR) > 0.0) {\n            continue;\n          }\n          int idyR = int(dyR);\n          int wRPerm = ${t} - 1 - wR;\n\n          for (int wC = 0; wC < ${n}; wC++) {\n            int wCPerm = ${n} - 1 - wC;\n\n            float dyC = float(dyCCorner + wC) / strides[1];\n            bool idyCVal = (dyC >= 0.0) && (dyC < ${e.outWidth}.0)\n              && (fract(dyC) == 0.0);\n            int idyC = int(dyC);\n\n            float dyC2 = float(dyCCorner + wC + 1) / strides[1];\n            bool idyCVal2 = (dyC2 >= 0.0) && (dyC2 < ${e.outWidth}.0)\n              && (fract(dyC2) == 0.0);\n            int idyC2 = int(dyC2);\n\n            if (idyCVal && idyCVal2) {\n              for (int d2 = 0; d2 < ${e.outChannels}; d2 += 2) {\n                vec4 wValue = getW(wRPerm, wCPerm, d1, d2);\n                vec4 dySample = getDy(batch, idyR, idyC, d2);\n                vec4 dySample2 = (idyC / 2 == idyC2 / 2) ?\n                  dySample : getDy(batch, idyR, idyC2, d2);\n\n                vec2 dyValue = mod(float(idyC), 2.) == 0. ?\n                  dySample.xy : dySample.zw;\n                result.xy += vec2(dot(dyValue, wValue.xy),\n                  dot(dyValue, wValue.zw));\n\n                dyValue = mod(float(idyC2), 2.) == 0. ?\n                  dySample2.xy : dySample2.zw;\n                result.zw += vec2(dot(dyValue, wValue.xy),\n                  dot(dyValue, wValue.zw));\n              }\n            } else if (idyCVal) {\n              for (int d2 = 0; d2 < ${e.outChannels}; d2 += 2) {\n                vec4 wValue = getW(wRPerm, wCPerm, d1, d2);\n                vec4 dySample = getDy(batch, idyR, idyC, d2);\n                vec2 dyValue = mod(float(idyC), 2.) == 0. ?\n                  dySample.xy : dySample.zw;\n                result.xy += vec2(dot(dyValue, wValue.xy),\n                  dot(dyValue, wValue.zw));\n              }\n            } else if (idyCVal2) {\n              for (int d2 = 0; d2 < ${e.outChannels}; d2 += 2) {\n                vec4 wValue = getW(wRPerm, wCPerm, d1, d2);\n                vec4 dySample = getDy(batch, idyR, idyC2, d2);\n                vec2 dyValue = mod(float(idyC2), 2.) == 0. ?\n                  dySample.xy : dySample.zw;\n                result.zw += vec2(dot(dyValue, wValue.xy),\n                  dot(dyValue, wValue.zw));\n              }\n            }\n          }\n        }\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function conv2DBackpropInput(e){const{inputs:n,backend:o,attrs:r}=e;const{dy:s,filter:i}=n;const{inputShape:c,strides:l,pad:u,dataFormat:d,dimRoundingMode:p}=r;const h=a.convertConv2DDataFormat(d);const f=a.computeConv2DInfo(c,i.shape,l,1,u,p,false,h);if(t().getBool("WEBGL_PACK_CONV2DTRANSPOSE")&&h==="channelsLast"){const e=[[f.strideHeight,f.strideWidth]];const t=new Conv2DDerInputPackedProgram(f);return o.runWebGLProgram(t,[s,i],"float32",e)}{const e=new Conv2DDerInputProgram(f);return o.runWebGLProgram(e,[s,i],"float32")}}const Br={kernelName:ce,backendName:"webgl",kernelFunc:conv2DBackpropInput};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function conv3D(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r,filter:s}=t;const{strides:i,pad:c,dilations:l}=o;const u=a.computeConv3DInfo(r.shape,s.shape,i,l,c);const d=new Conv3DProgram(u);return n.runWebGLProgram(d,[r,s],"float32")}const Ur={kernelName:le,backendName:"webgl",kernelFunc:conv3D};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function conv3DBackpropFilterV2(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r,dy:s}=t;const{strides:i,pad:c,filterShape:l}=o;const u=a.computeConv3DInfo(r.shape,l,i,1,c);const d=new Conv3DDerFilterProgram(u);return n.runWebGLProgram(d,[r,s],"float32")}const Mr={kernelName:ue,backendName:"webgl",kernelFunc:conv3DBackpropFilterV2};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function conv3DBackpropInput(e){const{inputs:t,backend:n,attrs:o}=e;const{dy:r,filter:s}=t;const{pad:i,strides:c,inputShape:l}=o;const u=a.computeConv3DInfo(l,s.shape,c,1,i);const d=new Conv3DDerInputProgram(u);return n.runWebGLProgram(d,[r,s],"float32")}const Vr={kernelName:de,backendName:"webgl",kernelFunc:conv3DBackpropInput};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Wr=ya+"\n  return cos(x);\n";const Gr=`\n  vec4 result = cos(x);\n  bvec4 isNaN = isnan(x);\n  ${ha}\n  return result;\n`;const zr=unaryKernelFunc({opSnippet:Wr,packedOpSnippet:Gr});const Xr={kernelName:pe,backendName:"webgl",kernelFunc:zr};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Hr="\n  float e2x = exp(-x);\n  return (e2x + 1.0 / e2x) / 2.0;\n";const Kr=unaryKernelFunc({opSnippet:Hr});const jr={kernelName:he,backendName:"webgl",kernelFunc:Kr};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class CropAndResizeProgram{constructor(e,t,n,o,a){this.variableNames=["Image","Boxes","BoxInd"];this.outputShape=[];const[r,s,i,c]=e;const[l]=t;const[u,d]=n;this.outputShape=[l,u,d,c];const p=o==="bilinear"?1:0;const[h,f]=[s-1+".0",i-1+".0"];const[x,m,g]=u>1?[""+(s-1)/(u-1),"(y2-y1) * height_ratio",`y1*${h} + float(y)*(height_scale)`]:["0.0","0.0",`0.5 * (y1+y2) * ${h}`];const[C,b,v]=d>1?[""+(i-1)/(d-1),"(x2-x1) * width_ratio",`x1*${f} + float(x)*(width_scale)`]:["0.0","0.0",`0.5 * (x1+x2) * ${f}`];this.userCode=`\n      const float height_ratio = float(${x});\n      const float width_ratio = float(${C});\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int y = coords[1];\n        int x = coords[2];\n        int d = coords[3];\n\n        // get box vals\n        float y1 = getBoxes(b,0);\n        float x1 = getBoxes(b,1);\n        float y2 = getBoxes(b,2);\n        float x2 = getBoxes(b,3);\n\n        // get image in batch index\n        int bInd = round(getBoxInd(b));\n        if(bInd < 0 || bInd >= ${r}) {\n          return;\n        }\n\n        float height_scale = ${m};\n        float width_scale = ${b};\n\n        float in_y = ${g};\n        if( in_y < 0.0 || in_y > ${h} ) {\n          setOutput(float(${a}));\n          return;\n        }\n        float in_x = ${v};\n        if( in_x < 0.0 || in_x > ${f} ) {\n          setOutput(float(${a}));\n          return;\n        }\n\n        vec2 sourceFracIndexCR = vec2(in_x,in_y);\n        if(${p} == 1) {\n          // Compute the four integer indices.\n          ivec2 sourceFloorCR = ivec2(sourceFracIndexCR);\n          ivec2 sourceCeilCR = ivec2(ceil(sourceFracIndexCR));\n\n          float topLeft = getImage(b, sourceFloorCR.y, sourceFloorCR.x, d);\n          float bottomLeft = getImage(b, sourceCeilCR.y, sourceFloorCR.x, d);\n          float topRight = getImage(b, sourceFloorCR.y, sourceCeilCR.x, d);\n          float bottomRight = getImage(b, sourceCeilCR.y, sourceCeilCR.x, d);\n\n          vec2 fracCR = sourceFracIndexCR - vec2(sourceFloorCR);\n\n          float top = topLeft + (topRight - topLeft) * fracCR.x;\n          float bottom = bottomLeft + (bottomRight - bottomLeft) * fracCR.x;\n          float newValue = top + (bottom - top) * fracCR.y;\n          setOutput(newValue);\n        } else {\n          // Compute the coordinators of nearest neighbor point.\n          ivec2 sourceNearestCR = ivec2(floor(\n            sourceFracIndexCR + vec2(0.5,0.5)));\n          float newValue = getImage(b, sourceNearestCR.y, sourceNearestCR.x, d);\n          setOutput(newValue);\n        }\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const cropAndResize=e=>{const{inputs:t,backend:n,attrs:o}=e;const{image:a,boxes:r,boxInd:s}=t;const{cropSize:i,method:c,extrapolationValue:l}=o;const u=new CropAndResizeProgram(a.shape,r.shape,i,c,l);return n.runWebGLProgram(u,[a,r,s],"float32")};const qr={kernelName:fe,backendName:"webgl",kernelFunc:cropAndResize};var Yr;(function(e){e.Prod="*";e.Sum="+"})(Yr||(Yr={}));class CumProgram{constructor(e,t,n,o){this.op=e;this.outputShape=t;this.variableNames=["x"];this.customUniforms=[{name:"index",type:"float"}];const a=this.outputShape.length;const r=this.op===Yr.Prod?"1.0":"0.0";const s=n?r:`getX(${getCoords(a,"coords",this.op)})`;const i=this.outputShape[this.outputShape.length-1];let c="";let l="";if(n){c=o?"end != "+(i-1):"end != 0";l=o?"end + 1":"end - 1"}else{c=o?`end + pow2 < ${i}`:"end >= pow2";l=o?"end + pow2":"end - pow2"}this.userCode=`\n      void main() {\n        ${getCoordsDataType(a)} coords = getOutputCoords();\n        int end = ${getFinalCoord(a,"coords",this.op)};\n        float val = ${s};\n        int pow2 = int(pow(2.0, index));\n        if (${c}) {\n          int idx = ${l};\n          ${getFinalCoord(a,"coords",this.op)} = idx;\n          val ${this.op}= getX(${getCoords(a,"coords",this.op)});\n        }\n        setOutput(val);\n      }\n    `}}function getCoords(e,t,n){if(e===1)return`${t}`;if(e===2)return`${t}.x, ${t}.y`;if(e===3)return`${t}.x, ${t}.y, ${t}.z`;if(e===4)return`${t}.x, ${t}.y, ${t}.z, ${t}.w`;throw new Error(`Cumulative ${n} for rank ${e} is not yet supported`)}function getFinalCoord(e,t,n){if(e===1)return`${t}`;if(e===2)return`${t}.y`;if(e===3)return`${t}.z`;if(e===4)return`${t}.w`;throw new Error(`Cumulative ${n} for rank ${e} is not yet supported`)}
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
 */function cumImpl(e,t,n,o,r,s){const i=t.shape.length;const c=a.getAxesPermutation([o],i);let l=t;c!=null&&(l=transpose({inputs:{x:t},backend:n,attrs:{perm:c}}));const u=a.getInnerMostAxes(1,i)[0];if(u!==i-1)throw new Error(`WebGL cumprod shader expects an inner-most axis=${t.shape.length-1} but got axis=${o}`);const d=l.shape[u];let p=identity({inputs:{x:l},backend:n});for(let t=0;t<=Math.ceil(Math.log2(d))-1;t++){const o=new CumProgram(e,l.shape,false,s);const a=[[t]];const r=p;p=n.runWebGLProgram(o,[p],p.dtype,a);n.disposeIntermediateTensorInfo(r)}if(r){const t=new CumProgram(e,l.shape,r,s);const o=p;p=n.runWebGLProgram(t,[p],p.dtype);n.disposeIntermediateTensorInfo(o)}if(c!=null){const e=a.getUndoAxesPermutation(c);const t=transpose({inputs:{x:p},backend:n,attrs:{perm:e}});n.disposeIntermediateTensorInfo(p);n.disposeIntermediateTensorInfo(l);return t}return p}
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
 */function cumprod(e){const{inputs:t,backend:n,attrs:o}=e;const{x:a}=t;const{axis:r,exclusive:s,reverse:i}=o;return cumImpl(Yr.Prod,a,n,r,s,i)}const Qr={kernelName:xe,backendName:"webgl",kernelFunc:cumprod};
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
 */function cumsum(e){const{inputs:t,backend:n,attrs:o}=e;const{x:a}=t;const{axis:r,exclusive:s,reverse:i}=o;return cumImpl(Yr.Sum,a,n,r,s,i)}const Zr={kernelName:me,backendName:"webgl",kernelFunc:cumsum};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function denseBincount(e){const{inputs:t,backend:n,attrs:o}=e;const{x:a,weights:r}=t;const{size:s,binaryOutput:i}=o;if(a.shape.length===1){const e=n.readSync(a.dataId);const t=n.readSync(r.dataId);const o=Yn(e,t,r.dtype,r.shape,s);return n.makeTensorInfo([s],r.dtype,o)}if(a.shape.length===2){const e=n.bufferSync(a);const t=n.bufferSync(r);const o=Qn(e,t,s,i);return n.makeTensorInfo(o.shape,r.dtype,o.values)}throw new Error(`Error in denseBincount: input must be at most rank 2, but got rank${a.shape.length}.`)}const Jr={kernelName:ge,backendName:"webgl",kernelFunc:denseBincount};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class DepthToSpaceProgram{constructor(e,t,n){this.variableNames=["x"];this.outputShape=[];this.outputShape=e;this.blockSize=t;this.dataFormat=n;this.userCode=`\n    void main() {\n      ivec4 coords = getOutputCoords();\n      int b = coords[0];\n      int h = ${this.getHeightCoordString()};\n      int w = ${this.getWidthCoordString()};\n      int d = ${this.getDepthCoordString()};\n\n      int in_h = h / ${t};\n      int offset_h = imod(h, ${t});\n      int in_w = w / ${t};\n      int offset_w = imod(w, ${t});\n      int offset_d = (offset_h * ${t} + offset_w) *\n        ${this.getOutputDepthSize()};\n      int in_d = d + offset_d;\n\n      float result = ${this.getInputSamplingString()};\n      setOutput(result);\n    }\n  `}getHeightCoordString(){return this.dataFormat==="NHWC"?"coords[1]":"coords[2]"}getWidthCoordString(){return this.dataFormat==="NHWC"?"coords[2]":"coords[3]"}getDepthCoordString(){return this.dataFormat==="NHWC"?"coords[3]":"coords[1]"}getOutputDepthSize(){return this.dataFormat==="NHWC"?this.outputShape[3]:this.outputShape[1]}getInputSamplingString(){return this.dataFormat==="NHWC"?"getX(b, in_h, in_w, in_d)":"getX(b, in_d, in_h, in_w)"}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function depthToSpace(e){const{inputs:t,backend:n,attrs:o}=e;const{x:a}=t;const{blockSize:r,dataFormat:s}=o;const i=a.shape[0];const c=s==="NHWC"?a.shape[1]:a.shape[2];const l=s==="NHWC"?a.shape[2]:a.shape[3];const u=s==="NHWC"?a.shape[3]:a.shape[1];const d=c*r;const p=l*r;const h=u/(r*r);const f=s==="NHWC"?[i,d,p,h]:[i,h,d,p];const x=new DepthToSpaceProgram(f,r,s);return n.runWebGLProgram(x,[a],a.dtype)}const es={kernelName:Ce,backendName:"webgl",kernelFunc:depthToSpace};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class DepthwiseConv2DProgram{constructor(e,t=false,n=null,o=false,a=false){this.variableNames=["x","W"];this.customUniforms=[{name:"pads",type:"ivec2"},{name:"strides",type:"ivec2"},{name:"dilations",type:"ivec2"},{name:"inDims",type:"ivec2"}];this.outputShape=e.outShape;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);const r=e.filterHeight;const s=e.filterWidth;const i=e.outChannels/e.inChannels;let c="",l="";if(n){c=o?`float activation(float a) {\n          float b = getPreluActivationWeightsAtOutCoords();\n          ${n}\n        }`:a?`float activation(float a) {\n          float b = getLeakyreluAlphaAtOutCoords();\n          ${n}\n        }`:`\n          float activation(float x) {\n            ${n}\n          }\n        `;l="result = activation(result);"}const u=t?"result += getBiasAtOutCoords();":"";t&&this.variableNames.push("bias");o&&this.variableNames.push("preluActivationWeights");a&&this.variableNames.push("leakyreluAlpha");this.userCode=`\n      ${c}\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords.x;\n        ivec2 xRCCorner = coords.yz * strides - pads;\n        int d2 = coords.w;\n        int d1 = d2 / ${i};\n        int q = d2 - d1 * ${i};\n\n        int xRCorner = xRCCorner.x;\n        int xCCorner = xRCCorner.y;\n\n        // Convolve x(?, ?, d1) with w(:, :, d1, q) to get y(yR, yC, d2).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n        // TO DO(dsmilkov): Flatten the two for loops and vec4 the operations.\n        for (int wR = 0; wR < ${r}; wR++) {\n          int xR = xRCorner + wR * dilations[0];\n\n          if (xR < 0 || xR >= inDims[0]) {\n            continue;\n          }\n\n          for (int wC = 0; wC < ${s}; wC++) {\n            int xC = xCCorner + wC * dilations[1];\n\n            if (xC < 0 || xC >= inDims[1]) {\n              continue;\n            }\n\n            float xVal = getX(batch, xR, xC, d1);\n            float wVal = getW(wR, wC, d1, q);\n            dotProd += xVal * wVal;\n          }\n        }\n\n        float result = dotProd;\n        ${u}\n        ${l}\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class DepthwiseConvPacked2DProgram{constructor(e,t=false,o=null,a=false,r=false){this.variableNames=["x","W"];this.packedInputs=true;this.packedOutput=true;this.customUniforms=[{name:"pads",type:"ivec2"},{name:"strides",type:"ivec2"},{name:"dilations",type:"ivec2"},{name:"inDims",type:"ivec2"}];this.outputShape=e.outShape;this.enableShapeUniforms=useShapeUniforms(this.outputShape.length);const s=e.outChannels/e.inChannels;const i=e.padInfo.left;const c=e.strideWidth;const l=e.dilationWidth;const u=e.filterHeight;const d=e.filterWidth;const p=d;let h="\n      int xR; int xC; int xCOffset;\n      vec4 wTexel; vec4 previous; vec4 final;";for(let e=0;e<d;e++)h+=`\n          vec4 xTexelC${e*2};\n          int xTexelC${e*2}Ready;\n          vec4 xTexelC${e*2+1};\n          int xTexelC${e*2+1}Ready;\n          vec4 xC${e};`;h+=`\n    for (int r = 0; r < ${u}; r++) {\n      `;for(let e=0;e<d;e++)h+=`\n          xTexelC${e*2} = vec4(0.0);\n          xTexelC${e*2}Ready = 0;\n          xTexelC${e*2+1} = vec4(0.0);\n          xTexelC${e*2+1}Ready = 0;\n          xC${e} = vec4(0.0);`;h+="\n        xR = xRCorner + r * dilations[0];\n        if (xR >=0 && xR < inDims[0]) {\n      ";for(let e=0;e<(p+1)/2;e++){const t=e*2;h+=`\n          xC = xCCorner + ${t*l};\n          `;if(c===1){if(t<d){if(i%2===1){h+=`\n                xCOffset = xC + 1;\n                if (xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${t}Ready == 0) {\n                  xTexelC${t} = getX(batch, xR, xCOffset, d1);\n\n                  // Need to manually clear unused channels in case\n                  // we're reading from recycled texture.\n                  if (xCOffset + 1 >= inDims[1]) {\n                    xTexelC${t}.zw = vec2(0.0);\n                  }\n                  xTexelC${t}Ready = 1;\n                }\n              `;h+=l===1&&t>0?`\n                xC${t} = vec4(xTexelC${t-2}.zw, xTexelC${t}.xy);\n                `:`\n                  xCOffset = xC + 1 - 2;\n\n                  if (xCOffset >= 0 && xCOffset < inDims[1]) {\n                    previous = getX(batch, xR, xCOffset, d1);\n\n                    // Need to manually clear unused channels in case\n                    // we're reading from recycled texture.\n                    if (xCOffset + 1 >= inDims[1]) {\n                      previous.zw = vec2(0.0);\n                    }\n\n                    xC${t} = vec4(previous.zw, xTexelC${t}.xy);\n                  } else {\n                    xC${t} = vec4(0.0, 0.0, xTexelC${t}.xy);\n                  }\n                  `}else h+=`\n                if (xC >= 0 && xC < inDims[1] && xTexelC${t}Ready == 0) {\n                  xTexelC${t} = getX(batch, xR, xC, d1);\n                  if (xC + 1 >= inDims[1]) {\n                    xTexelC${t}.zw = vec2(0.0);\n                  }\n                  xTexelC${t}Ready = 1;\n                }\n\n                xC${t} = xTexelC${t};\n                `;if(t+1<d){const e=i%2===0?n.nearestLargerEven(l):l;if(l%2===0&&i%2===1||l%2!==0&&i%2!==1){h+=`\n                  xCOffset = xC + imod(pads[1], 2) + ${e};\n\n                  if (xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${t+1}Ready == 0) {\n                    xTexelC${t+1} = getX(batch, xR, xCOffset, d1);\n\n                    // Need to manually clear unused channels in case\n                    // we're reading from recycled texture.\n                    if (xCOffset + 1 >= inDims[1]) {\n                      xTexelC${t+1}.zw = vec2(0.0);\n                    }\n                    xTexelC${t+1}Ready = 1;\n                  }\n                  `;h+=l>1?`\n                    xCOffset -= 2;\n                    if (xCOffset >= 0 && xCOffset < inDims[1]) {\n                     previous = getX(batch, xR, xCOffset, d1);\n                     xC${t+1} = vec4(previous.zw, xTexelC${t+1}.xy);\n                    } else {\n                     xC${t+1} = vec4(0.0, 0.0, xTexelC${t+1}.xy);\n                    }\n                    `:`\n                    xC${t+1} = vec4(xTexelC${t}.zw, xTexelC${t+1}.xy);\n                    `}else h+=e===1?`\n                    xC${t+1} = xTexelC${t};\n                    `:`\n                    xCOffset = xC + ${e};\n\n                    if (xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${t+1}Ready == 0) {\n                      xTexelC${t+1} = getX(batch, xR, xCOffset, d1);\n                      if (xCOffset + 1 >= inDims[1]) {\n                        xTexelC${t+1}.zw = vec2(0.0);\n                      }\n                      xTexelC${t+1}Ready = 1;\n                    }\n\n                    xC${t+1} = xTexelC${t+1};\n                    `}}}else if(t<d)if(i%2===1){h+=`\n                xCOffset = xC + 1 - strides[1];\n                if(xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${t}Ready == 0) {\n                  xTexelC${t} = getX(batch, xR, xCOffset, d1);\n                  // Need to manually clear unused channels in case\n                  // we're reading from recycled texture.\n                  if (xCOffset + 1 >= inDims[1]) {\n                    xTexelC${t}.zw = vec2(0.0);\n                  }\n                  xTexelC${t}Ready = 1;\n                }\n\n                if(xC + 1 >= 0 && xC + 1 < inDims[1] && xTexelC${t+1}Ready == 0) {\n                  xTexelC${t+1} = getX(batch, xR, xC + 1, d1);\n                  // Need to manually clear unused channels in case\n                  // we're reading from recycled texture.\n                  if (xC + 2 >= inDims[1]) {\n                    xTexelC${t+1}.zw = vec2(0.0);\n                  }\n                  xTexelC${t+1}Ready = 1;\n                }\n\n                xC${t} = vec4(xTexelC${t}.zw, xTexelC${t+1}.zw);\n              `;t+1<d&&(h+=`\n                  final = vec4(0.0);\n                  xCOffset = xC + 1 + strides[1];\n                  if(xCOffset >= 0 && xCOffset < inDims[1]) {\n                    final = getX(batch, xR, xCOffset, d1);\n                  }\n                  xC${t+1} = vec4(xTexelC${t+1}.xy, final.xy);\n                `)}else{h+=`\n                if(xC >= 0 && xC < inDims[1] && xTexelC${t}Ready == 0) {\n                  xTexelC${t} = getX(batch, xR, xC, d1);\n                  if (xC + 1 >= inDims[1]) {\n                    xTexelC${t}.zw = vec2(0.0);\n                  }\n                  xTexelC${t}Ready = 1;\n                }\n\n                xCOffset = xC + strides[1];\n                if(xCOffset >= 0 && xCOffset < inDims[1] && xTexelC${t+1}Ready == 0) {\n                  xTexelC${t+1} = getX(batch, xR, xCOffset, d1);\n                  if (xCOffset + 1 >= inDims[1]) {\n                    xTexelC${t+1}.zw = vec2(0.);\n                  }\n                  xTexelC${t+1}Ready = 1;\n                }\n\n                xC${t} = vec4(\n                  xTexelC${t}.xy, xTexelC${t+1}.xy);\n              `;t+1<d&&(h+=`\n                  xC${t+1} = vec4(xTexelC${t}.zw, xTexelC${t+1}.zw);\n                `)}if(t<d){h+=`\n            wTexel = getW(r, ${t}, d1, q);\n            dotProd += xC${t} * vec4(wTexel.xz, wTexel.xz);\n          `;t+1<d&&(h+=`\n              wTexel = getW(r, ${t+1}, d1, q);\n              dotProd += xC${t+1} * vec4(wTexel.xz, wTexel.xz);\n            `)}}h+="\n    }\n  ";h+="\n      }\n    ";let f="",x="";if(o){f=a?`vec4 activation(vec4 a) {\n          vec4 b = getPreluActivationWeightsAtOutCoords();\n          ${o}\n        }`:r?`vec4 activation(vec4 a) {\n          vec4 b = getLeakyreluAlphaAtOutCoords();\n          ${o}\n        }`:`vec4 activation(vec4 x) {\n          ${o}\n        }`;x="result = activation(result);"}const m=t?"result += getBiasAtOutCoords();":"";t&&this.variableNames.push("bias");a&&this.variableNames.push("preluActivationWeights");r&&this.variableNames.push("leakyreluAlpha");this.userCode=`\n      ${f}\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords.x;\n        ivec2 xRCCorner = coords.yz * strides - pads;\n        int d2 = coords.w;\n        int d1 = d2 / ${s};\n        int q = d2 - d1 * ${s};\n        int xRCorner = xRCCorner.x;\n        int xCCorner = xRCCorner.y;\n\n        //intialize dotProd with a small epsilon seems to reduce GPU accuracy loss.\n        vec4 dotProd = vec4(0.000000000000001);\n\n        ${h}\n\n        vec4 result = dotProd - vec4(0.000000000000001);\n        ${m}\n        ${x}\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function depthwiseConv2dNative(e){const{inputs:o,backend:r,attrs:s}=e;const{x:i,filter:c}=o;const{strides:l,pad:u,dilations:d,dimRoundingMode:p}=s;let h=d;h==null&&(h=[1,1]);n.assert(a.eitherStridesOrDilationsAreOne(l,h),(()=>`Error in depthwiseConv2d: Either strides or dilations must be 1. Got strides ${l} and dilations '${h}'`));const f=a.computeConv2DInfo(i.shape,c.shape,l,h,u,p,true);let x;x=t().getBool("WEBGL_PACK_DEPTHWISECONV")&&f.strideWidth<=2&&f.outChannels/f.inChannels===1?new DepthwiseConvPacked2DProgram(f):new DepthwiseConv2DProgram(f);const m=[[f.padInfo.top,f.padInfo.left],[f.strideHeight,f.strideWidth],[f.dilationHeight,f.dilationWidth],[f.inHeight,f.inWidth]];return r.runWebGLProgram(x,[i,c],"float32",m)}const ts={kernelName:be,backendName:"webgl",kernelFunc:depthwiseConv2dNative};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class DepthwiseConv2DDerFilterProgram{constructor(e){this.variableNames=["x","dy"];this.outputShape=e.filterShape;const t=e.strideHeight;const n=e.strideWidth;const o=e.padInfo.top;const a=e.padInfo.left;const r=e.outChannels/e.inChannels;this.userCode=`\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int wR = coords.x;\n        int wC = coords.y;\n        int d1 = coords.z;\n        int dm = coords.w;\n        int d2 = d1 * ${r} + dm;\n\n        float dotProd = 0.0;\n\n        // TO DO: Vec4 over the batch size\n        for (int b = 0; b < ${e.batchSize}; b++) {\n          for (int yR = 0; yR < ${e.outHeight}; yR++) {\n            int xR = wR + yR * ${t} - ${o};\n\n            if (xR < 0 || xR >= ${e.inHeight}) {\n              continue;\n            }\n\n            for (int yC = 0; yC < ${e.outWidth}; yC++) {\n              int xC = wC + yC * ${n} - ${a};\n\n              if (xC < 0 || xC >= ${e.inWidth}) {\n                continue;\n              }\n\n              float dyValue = getDy(b, yR, yC, d2);\n              float xValue = getX(b, xR, xC, d1);\n              dotProd += (xValue * dyValue);\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}class DepthwiseConv2DDerInputProgram{constructor(e){this.variableNames=["dy","W"];this.outputShape=e.inShape;const t=e.filterHeight;const n=e.filterWidth;const o=e.strideHeight;const a=e.strideWidth;const r=t-1-e.padInfo.top;const s=n-1-e.padInfo.left;const i=e.outChannels/e.inChannels;this.userCode=`\n      const ivec2 pads = ivec2(${r}, ${s});\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords[0];\n        int d1 = coords[3];\n        ivec2 dyCorner = coords.yz - pads;\n        int dyRCorner = dyCorner.x;\n        int dyCCorner = dyCorner.y;\n\n        float dotProd = 0.0;\n\n        for (int wR = 0; wR < ${t}; wR++) {\n          float dyR = float(dyRCorner + wR) / ${o}.0;\n\n          if (dyR < 0.0 || dyR >= ${e.outHeight}.0 || fract(dyR) > 0.0) {\n            continue;\n          }\n          int idyR = int(dyR);\n\n          int wRPerm = ${t} - 1 - wR;\n\n          for (int wC = 0; wC < ${n}; wC++) {\n            float dyC = float(dyCCorner + wC) / ${a}.0;\n\n            if (dyC < 0.0 || dyC >= ${e.outWidth}.0 ||\n                fract(dyC) > 0.0) {\n              continue;\n            }\n            int idyC = int(dyC);\n\n            int wCPerm = ${n} - 1 - wC;\n\n            // TO DO: Vec4 over the channelMul\n            for (int dm = 0; dm < ${i}; dm++) {\n              int d2 = d1 * ${i} + dm;\n              float xValue = getDy(batch, idyR, idyC, d2);\n              float wValue = getW(wRPerm, wCPerm, d1, dm);\n              dotProd += xValue * wValue;\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function depthwiseConv2dNativeBackpropFilter(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r,dy:s}=t;const{strides:i,dilations:c,pad:l,dimRoundingMode:u,filterShape:d}=o;const p=a.computeConv2DInfo(r.shape,d,i,c,l,u,true);const h=new DepthwiseConv2DDerFilterProgram(p);return n.runWebGLProgram(h,[r,s],"float32")}const ns={kernelName:ve,backendName:"webgl",kernelFunc:depthwiseConv2dNativeBackpropFilter};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function depthwiseConv2dNativeBackpropInput(e){const{inputs:t,backend:n,attrs:o}=e;const{dy:r,filter:s}=t;const{strides:i,dilations:c,pad:l,dimRoundingMode:u,inputShape:d}=o;const p=a.computeConv2DInfo(d,s.shape,i,c,l,u,true);const h=new DepthwiseConv2DDerInputProgram(p);return n.runWebGLProgram(h,[r,s],"float32")}const os={kernelName:$e,backendName:"webgl",kernelFunc:depthwiseConv2dNativeBackpropInput};
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class DiagProgram{constructor(e){this.variableNames=["X"];this.outputShape=[e,e];this.userCode="\n      void main() {\n          ivec2 coords = getOutputCoords();\n          float val = coords[0] == coords[1] ? getX(coords[0]) : 0.0;\n          setOutput(val);\n      }\n    "}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function diag(e){const{inputs:t,backend:o}=e;const{x:a}=t;const r=[...a.shape,...a.shape];const s=n.sizeFromShape(a.shape);const i=reshape({inputs:{x:a},backend:o,attrs:{shape:[s]}});const c=new DiagProgram(s);const l=o.runWebGLProgram(c,[i],i.dtype);const u=reshape({inputs:{x:l},backend:o,attrs:{shape:r}});o.disposeIntermediateTensorInfo(i);o.disposeIntermediateTensorInfo(l);return u}const as={kernelName:ye,backendName:"webgl",kernelFunc:diag};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class Dilation2DProgram{constructor(e){this.variableNames=["x","W"];this.outputShape=e.outShape;const{inHeight:t,inWidth:n,padInfo:o,strideHeight:a,strideWidth:r,filterHeight:s,filterWidth:i,dilationHeight:c,dilationWidth:l}=e;const{top:u,left:d}=o;this.userCode=`\n      const ivec2 strides = ivec2(${a}, ${r});\n      const ivec2 pads = ivec2(${u}, ${d});\n      const float neg_infinity = -3.4e38;\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int batch = coords.x;\n        int d1 = coords.w;\n        ivec2 outTopLeftCorner =\n            coords.yz * strides - pads;\n        int hBeg = outTopLeftCorner.x;\n        int wBeg = outTopLeftCorner.y;\n\n        float curVal = neg_infinity;\n        for (int h = 0; h < ${s}; h++) {\n          int hIn = hBeg + h * ${c};\n\n          if (hIn >= 0 && hIn < ${t}) {\n            for (int w = 0; w < ${i}; w++) {\n              int wIn = wBeg + w * ${l};\n\n              if (wIn >= 0 && wIn < ${n}) {\n                float xVal = getX(batch, hIn, wIn, d1);\n                float wVal = getW(h, w, d1);\n\n                float val = xVal + wVal;\n                if (val > curVal) {\n                  curVal = val;\n                }\n              }\n            }\n          }\n        }\n\n        float result = curVal;\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function dilation2D(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r,filter:s}=t;const{strides:i,pad:c,dilations:l}=o;const u=a.computeDilation2DInfo(r.shape,s.shape,i,c,"NHWC",l);let d;const p=new Dilation2DProgram(u);d=n.runWebGLProgram(p,[r,s],"float32");const h=reshape({inputs:{x:d},backend:n,attrs:{shape:u.outShape}});n.disposeIntermediateTensorInfo(d);return h}const rs={kernelName:Ie,backendName:"webgl",kernelFunc:dilation2D};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function einsum(e){const{inputs:t,backend:o,attrs:r}=e;const{equation:s}=r;const i=t;const{allDims:c,summedDims:l,idDims:u}=a.decodeEinsumEquation(s,i.length);a.checkEinsumDimSizes(c.length,u,i);const{path:d,steps:p}=a.getEinsumComputePath(l,u);const h=p.length;let f=null;let x=c.length;const m=[];for(let e=0;e<h;++e){for(const t of p[e]){const{permutationIndices:e,expandDims:r}=a.getEinsumPermutation(x,u[t]);let s;if(a.isIdentityPermutation(e))s=i[t];else{s=transpose({inputs:{x:i[t]},backend:o,attrs:{perm:e}});m.push(s)}const c=s.shape.slice();for(let e=0;e<r.length;++e)c.splice(r[e],0,1);if(!n.arraysEqual(s.shape,c)){s=reshape({inputs:{x:s},backend:o,attrs:{shape:c}});m.push(s)}if(f===null)f=s;else{f=multiply({inputs:{a:s,b:f},backend:o});m.push(f)}}if(e<h-1){if(d[e]>=0){f=sum({inputs:{x:f},backend:o,attrs:{axis:d[e]-(c.length-x),keepDims:false}});m.push(f)}x--}}for(const e of m)e!==f&&o.disposeIntermediateTensorInfo(e);return f}const ss={kernelName:Se,backendName:"webgl",kernelFunc:einsum};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const is="return (x >= 0.0) ? x : (exp(x) - 1.0);";const cs="\n  vec4 result;\n\n  result.r = (x.r >= 0.0) ? x.r : (exp(x.r) - 1.0);\n  result.g = (x.g >= 0.0) ? x.g : (exp(x.g) - 1.0);\n  result.b = (x.b >= 0.0) ? x.b : (exp(x.b) - 1.0);\n  result.a = (x.a >= 0.0) ? x.a : (exp(x.a) - 1.0);\n\n  return result;\n";const ls=unaryKernelFunc({opSnippet:is,packedOpSnippet:cs});const us={kernelName:Te,backendName:"webgl",kernelFunc:ls};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ds="return (b >= 0.0) ? a : a * (b + 1.0);";const ps="\n  vec4 bGTEZero = vec4(greaterThanEqual(b, vec4(0.)));\n  return (bGTEZero * a) + ((vec4(1.0) - bGTEZero) * (a * (b + vec4(1.0))));\n";const eluGrad=e=>{const{inputs:n,backend:o}=e;const{dy:a,y:r}=n;const s=t().getBool("WEBGL_PACK_BINARY_OPERATIONS")?new BinaryOpPackedProgram(ps,a.shape,r.shape):new BinaryOpProgram(ds,a.shape,r.shape);return o.runWebGLProgram(s,[a,r],a.dtype)};const hs={kernelName:ke,backendName:"webgl",kernelFunc:eluGrad};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const fs="\n  return vec4(equal(a, b));\n";const xs="return float(a == b);";const ms=binaryKernelFunc({opSnippet:xs,packedOpSnippet:fs,dtype:"bool",cpuKernelImpl:no});const gs={kernelName:we,backendName:"webgl",kernelFunc:ms};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Cs=`\n  // Error function is calculated approximately with elementary function.\n  // See "Handbook of Mathematical Functions with Formulas,\n  // Graphs, and Mathematical Tables", Abramowitz and Stegun.\n  float p = ${a.ERF_P};\n  float a1 = ${a.ERF_A1};\n  float a2 = ${a.ERF_A2};\n  float a3 = ${a.ERF_A3};\n  float a4 = ${a.ERF_A4};\n  float a5 = ${a.ERF_A5};\n\n  float sign = sign(x);\n  x = abs(x);\n  float t = 1.0 / (1.0 + p * x);\n  return sign * (1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1)*t*exp(-x*x));\n`;const bs=unaryKernelFunc({opSnippet:Cs});const vs={kernelName:Re,backendName:"webgl",kernelFunc:bs};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const $s=ya+"\n  return exp(x);\n";const ys="\n  vec4 result = exp(x);\n  bvec4 isNaN = isnan(x);\n  result.r = isNaN.r ? x.r : result.r;\n  result.g = isNaN.g ? x.g : result.g;\n  result.b = isNaN.b ? x.b : result.b;\n  result.a = isNaN.a ? x.a : result.a;\n\n  return result;\n";const Is=unaryKernelFunc({opSnippet:$s,packedOpSnippet:ys,cpuKernelImpl:oo,dtype:"float32"});const Ss={kernelName:Fe,backendName:"webgl",kernelFunc:Is};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the License);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */function expandDims(e){const{inputs:t,attrs:o,backend:a}=e;const{dim:r}=o;const{input:s}=t;const i=s.shape.length;const c=s.shape.slice();let l=r;if(r<0){n.assert(-(i+1)<=r,(()=>`Axis must be in the interval [${-(i+1)}, ${i}]`));l=i+r+1}c.splice(l,0,1);return reshape({inputs:{x:s},backend:a,attrs:{shape:c}})}const Ts={kernelName:Ne,backendName:"webgl",kernelFunc:expandDims};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ks="return exp(x) - 1.0;";const ws=unaryKernelFunc({opSnippet:ks,packedOpSnippet:ks,cpuKernelImpl:ao});const Rs={kernelName:Ee,backendName:"webgl",kernelFunc:ws};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class FFTProgram{constructor(e,t,n){this.variableNames=["real","imag"];const o=t[1];this.outputShape=t;const a=n?`2.0 * ${Math.PI}`:`-2.0 * ${Math.PI}`;const r=n?`${o}.0`:"1.0";let s;if(e==="real")s="return real * expR - imag * expI;";else{if(e!=="imag")throw new Error(`FFT component must be either "real" or "imag", got ${e}.`);s="return real * expI + imag * expR;"}this.userCode=`\n      const float exponentMultiplier = ${a};\n\n      float unaryOpComplex(float real, float expR, float imag, float expI) {\n        ${s}\n      }\n\n      float mulMatDFT(int batch, int index) {\n        float indexRatio = float(index) / float(${o});\n        float exponentMultiplierTimesIndexRatio =\n            exponentMultiplier * indexRatio;\n\n        float result = 0.0;\n\n        for (int i = 0; i < ${o}; i++) {\n          // x = (-2|2 * PI / N) * index * i;\n          float x = exponentMultiplierTimesIndexRatio * float(i);\n          float expR = cos(x);\n          float expI = sin(x);\n          float real = getReal(batch, i);\n          float imag = getImag(batch, i);\n\n          result +=\n              unaryOpComplex(real, expR, imag, expI) / ${r};\n        }\n\n        return result;\n      }\n\n      void main() {\n        ivec2 coords = getOutputCoords();\n        setOutput(mulMatDFT(coords[0], coords[1]));\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function fftImpl(e,t,o){const a=o.texData.get(e.dataId);const r=n.sizeFromShape(e.shape);const s=e.shape[e.shape.length-1];const i=r/s;const c=reshape({inputs:{x:e},backend:o,attrs:{shape:[i,s]}});const l=c.shape;const u=new FFTProgram("real",l,t);const d=new FFTProgram("imag",l,t);const p=[{dataId:a.complexTensorInfos.real.dataId,dtype:a.complexTensorInfos.real.dtype,shape:l},{dataId:a.complexTensorInfos.imag.dataId,dtype:a.complexTensorInfos.imag.dtype,shape:l}];const h=o.runWebGLProgram(u,p,"float32");const f=o.runWebGLProgram(d,p,"float32");const x=complex({inputs:{real:h,imag:f},backend:o});o.disposeIntermediateTensorInfo(h);o.disposeIntermediateTensorInfo(f);const m=reshape({inputs:{x:x},backend:o,attrs:{shape:e.shape}});o.disposeIntermediateTensorInfo(c);o.disposeIntermediateTensorInfo(x);return m}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function fft(e){const{inputs:t,backend:n}=e;const{input:o}=t;return fftImpl(o,false,n)}const Fs={kernelName:Pe,backendName:"webgl",kernelFunc:fft};
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class FillProgram{constructor(e,t){this.outputShape=[];this.customUniforms=[{name:"value",type:"float"}];this.variableNames=["x"];this.outputShape=e;this.userCode="\n      void main() {\n        // Input can be obtained from uniform value.\n        setOutput(value);\n      }\n    "}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function fill(e){const{backend:t,attrs:o}=e;const{shape:a,value:r}=o;let{dtype:s}=o;s=s||n.inferDtype(r);if(s==="string"){const e=n.getArrayFromDType(s,n.sizeFromShape(a));e.fill(r);return t.makeTensorInfo(a,s,e)}{const e=new FillProgram(a,r);const n=[[r]];return t.runWebGLProgram(e,[],s,n)}}const Ns={kernelName:Ae,backendName:"webgl",kernelFunc:fill};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */class FlipLeftRightProgram{constructor(e){this.variableNames=["Image"];this.outputShape=[];const t=e[2];this.outputShape=e;this.userCode=`\n        void main() {\n          ivec4 coords = getOutputCoords();\n          int x = coords[2];\n\n          int coordX = ${t} - x - 1;\n          float outputValue;\n          if(coordX >= 0 && coordX < ${t}) {\n            outputValue = getImage(coords[0], coords[1], coordX, coords[3]);\n          } else {\n            outputValue = getImage(coords[0], coords[1], coords[2], coords[3]);\n          }\n          setOutput(outputValue);\n        }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Es={kernelName:Oe,backendName:"webgl",kernelFunc:({inputs:e,backend:t})=>{const{image:n}=e;const o=t;const a=new FlipLeftRightProgram(n.shape);const r=o.runWebGLProgram(a,[n],n.dtype);return r}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ps="return floor(x);";const As=unaryKernelFunc({opSnippet:Ps,packedOpSnippet:Ps,cpuKernelImpl:ro});const Os={kernelName:De,backendName:"webgl",kernelFunc:As};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ds="\n  float s = sign(a) * sign(b);\n  int ia = round(a);\n  int ib = round(b);\n  if (ib != 0) {\n    // Windows (D3D) wants guaranteed non-zero int division at compile-time.\n    return float(idiv(ia, ib, s));\n  } else {\n    return NAN;\n  }\n";const _s="\n  ivec4 ia = round(a);\n  ivec4 ib = round(b);\n  bvec4 cond = notEqual(ib, ivec4(0));\n  ivec4 result = ivec4(0);\n  vec4 s = sign(a) * sign(b);\n\n  // Windows (D3D) wants guaranteed non-zero int division at compile-time.\n  if (cond[0]) {\n    result[0] = idiv(ia[0], ib[0], s[0]);\n  }\n  if (cond[1]) {\n    result[1] = idiv(ia[1], ib[1], s[1]);\n  }\n  if (cond[2]) {\n    result[2] = idiv(ia[2], ib[2], s[2]);\n  }\n  if (cond[3]) {\n    result[3] = idiv(ia[3], ib[3], s[3]);\n  }\n  return vec4(result);\n";const Ls=binaryKernelFunc({opSnippet:Ds,packedOpSnippet:_s,dtype:"int32"});const Bs={kernelName:_e,backendName:"webgl",kernelFunc:Ls};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class FromPixelsProgram{constructor(e){this.variableNames=["A"];const t=getGlslDifferences();const[n,o]=e;this.outputShape=e;this.userCode=`\n      void main() {\n        ivec3 coords = getOutputCoords();\n        int texR = coords[0];\n        int texC = coords[1];\n        int depth = coords[2];\n        vec2 uv = (vec2(texC, texR) + halfCR) / vec2(${o}.0, ${n}.0);\n\n        vec4 values = ${t.texture2D}(A, uv);\n        float value;\n        if (depth == 0) {\n          value = values.r;\n        } else if (depth == 1) {\n          value = values.g;\n        } else if (depth == 2) {\n          value = values.b;\n        } else if (depth == 3) {\n          value = values.a;\n        }\n\n        setOutput(floor(value * 255.0 + 0.5));\n      }\n    `}}
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class FromPixelsPackedProgram{constructor(e){this.variableNames=["A"];this.packedInputs=false;this.packedOutput=true;const t=getGlslDifferences();const[n,o]=e;this.outputShape=e;this.userCode=`\n      void main() {\n        ivec3 coords = getOutputCoords();\n        int texR = coords[0];\n        int texC = coords[1];\n        int depth = coords[2];\n\n        vec4 result = vec4(0.);\n\n        for(int row=0; row<=1; row++) {\n          for(int col=0; col<=1; col++) {\n            texC = coords[1] + row;\n            depth = coords[2] + col;\n\n            vec2 uv = (vec2(texC, texR) + halfCR) /\n                       vec2(${o}.0, ${n}.0);\n            vec4 values = ${t.texture2D}(A, uv);\n            float value;\n            if (depth == 0) {\n              value = values.r;\n            } else if (depth == 1) {\n              value = values.g;\n            } else if (depth == 2) {\n              value = values.b;\n            } else if (depth == 3) {\n              value = values.a;\n            }\n\n            result[row * 2 + col] = floor(value * 255.0 + 0.5);\n          }\n        }\n\n        ${t.output} = result;\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */const Us={kernelName:Le,backendName:"webgl",kernelFunc:fromPixels};let Ms;let Vs=t().getBool("CANVAS2D_WILL_READ_FREQUENTLY_FOR_GPU");function fromPixels(e){const{inputs:n,backend:o,attrs:a}=e;let{pixels:r}=n;const{numChannels:s}=a;const i=typeof HTMLVideoElement!=="undefined"&&r instanceof HTMLVideoElement;const c=typeof HTMLImageElement!=="undefined"&&r instanceof HTMLImageElement;const[l,u]=i?[r.videoWidth,r.videoHeight]:[r.width,r.height];const d=[u,l];const p=[u,l,s];if(c||i){const e=t().getBool("CANVAS2D_WILL_READ_FREQUENTLY_FOR_GPU");if(Ms==null||e!==Vs){Vs=e;Ms=document.createElement("canvas").getContext("2d",{willReadFrequently:Vs})}Ms.canvas.width=l;Ms.canvas.height=u;Ms.drawImage(r,0,0,l,u);r=Ms.canvas}const h=o.makeTensorInfo(d,"int32");o.texData.get(h.dataId).usage=Pn.PIXELS;o.gpgpu.uploadPixelDataToTexture(o.getTexture(h.dataId),r);const f=t().getBool("WEBGL_PACK")?new FromPixelsPackedProgram(p):new FromPixelsProgram(p);const x=o.runWebGLProgram(f,[h],"int32");o.disposeData(h.dataId);return x}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function fusedConv2d(e){const{inputs:o,backend:r,attrs:s}=e;const{x:i,filter:c,bias:l,preluActivationWeights:u}=o;const{strides:d,pad:p,dataFormat:h,dilations:f,dimRoundingMode:x,activation:m,leakyreluAlpha:g}=s;const C=a.convertConv2DDataFormat(h);const b=a.computeConv2DInfo(i.shape,c.shape,d,f,p,x,false,C);let v;const $=[];const y=l!=null;const I=u!=null;const S=m==="leakyrelu";const prepareInputs=()=>{const e=[i,c];const alignInputWithDataFormat=(e,t)=>{if(t==="NCHW"&&e.shape.length===1&&e.shape[0]!==1){const t=reshape({inputs:{x:e},backend:r,attrs:{shape:[e.shape[0],1,1]}});$.push(t);return t}return e};y&&e.push(alignInputWithDataFormat(l,h));I&&e.push(alignInputWithDataFormat(u,h));if(S){const t=r.makeTensorInfo([],"float32",n.createScalarValue(g,"float32"));e.push(t);$.push(t)}return e};if(b.filterHeight!==1||b.filterWidth!==1||b.dilationHeight!==1||b.dilationWidth!==1||b.strideHeight!==1||b.strideWidth!==1||b.padInfo.type!=="SAME"&&b.padInfo.type!=="VALID")if(b.strideWidth<=2&&C==="channelsLast"&&t().getBool("WEBGL_EXP_CONV")){const e=m?mapActivationToShaderProgram(m,true):null;const t=new Conv2DPackedProgram(b,y,e,I,S);const n=[[b.padInfo.top,b.padInfo.left],[b.strideHeight,b.strideWidth],[b.dilationHeight,b.dilationWidth],[b.inHeight,b.inWidth]];const o=prepareInputs();v=r.runWebGLProgram(t,o,"float32",n)}else if(t().getBool("WEBGL_CONV_IM2COL"))v=conv2dWithIm2Row({x:i,filter:c,convInfo:b,backend:r,bias:l,activation:m,preluActivationWeights:u,leakyreluAlpha:g});else{const e=m?mapActivationToShaderProgram(m,false):null;const t=new Conv2DProgram(b,y,e,I,S);const n=prepareInputs();v=r.runWebGLProgram(t,n,"float32")}else v=conv2dByMatMul({x:i,filter:c,convInfo:b,backend:r,bias:l,activation:m,preluActivationWeights:u,leakyreluAlpha:g});const T=reshape({inputs:{x:v},backend:r,attrs:{shape:b.outShape}});$.push(v);$.forEach((e=>r.disposeIntermediateTensorInfo(e)));return T}const Ws={kernelName:Be,backendName:"webgl",kernelFunc:fusedConv2d};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function fusedDepthwiseConv2D(e){const{inputs:o,backend:r,attrs:s}=e;const{x:i,filter:c,bias:l,preluActivationWeights:u}=o;const{strides:d,pad:p,dilations:h,dimRoundingMode:f,activation:x,leakyreluAlpha:m}=s;const g=[];let C=h;C==null&&(C=[1,1]);n.assert(a.eitherStridesOrDilationsAreOne(d,C),(()=>`Error in depthwiseConv2d: Either strides or dilations must be 1. Got strides ${d} and dilations '${C}'`));const b=a.computeConv2DInfo(i.shape,c.shape,d,C,p,f,true);const v=t().getBool("WEBGL_PACK_DEPTHWISECONV")&&b.strideWidth<=2&&b.outChannels/b.inChannels===1;const $=x?mapActivationToShaderProgram(x,v):null;const y=[i,c];const I=l!=null;const S=u!=null;const T=x==="leakyrelu";I&&y.push(l);S&&y.push(u);if(T){const e=r.makeTensorInfo([],"float32",n.createScalarValue(m,"float32"));y.push(e);g.push(e)}let k;k=v?new DepthwiseConvPacked2DProgram(b,I,$,S,T):new DepthwiseConv2DProgram(b,I,$,S,T);const w=[[b.padInfo.top,b.padInfo.left],[b.strideHeight,b.strideWidth],[b.dilationHeight,b.dilationWidth],[b.inHeight,b.inWidth]];const R=r.runWebGLProgram(k,y,"float32",w);g.forEach((e=>r.disposeIntermediateTensorInfo(e)));return R}const Gs={kernelName:Ue,backendName:"webgl",kernelFunc:fusedDepthwiseConv2D};class GatherNDProgram{constructor(e,t,n,o){this.sliceDim=e;this.strides=t;this.paramsShape=o;this.variableNames=["x","indices"];this.outputShape=n;const a=getCoordsDataType(n.length);let r="\n    int index;";for(let e=0;e<this.sliceDim;e++)r+=`\n          index = round(getIndices(coords[0], ${e}));\n          out_of_bounds = out_of_bounds || index < 0;\n          out_of_bounds = out_of_bounds || index >= ${this.paramsShape[e]};\n          flattenIndex += index * ${this.strides[e]};`;this.userCode=`\n         void main() {\n          ${a} coords = getOutputCoords();\n          int flattenIndex = 0;\n          bool out_of_bounds = false;\n\n          ${r}\n\n          setOutput(out_of_bounds ? 0.0 : getX(flattenIndex, coords[1]));\n        }\n      `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function gatherNd(e){const{inputs:t,backend:o}=e;const{params:r,indices:s}=t;const i=s.shape;const c=i[i.length-1];const l=n.sizeFromShape(r.shape);const[u,d,p,h]=a.prepareAndValidate(r,s);const f=reshape({inputs:{x:s},backend:o,attrs:{shape:[d,c]}});const x=reshape({inputs:{x:r},backend:o,attrs:{shape:[n.sizeFromShape(r.shape)/p,p]}});if(o.shouldExecuteOnCPU([r,s])||r.dtype==="string"){const e=o.readSync(s.dataId);const t=o.bufferSync(r);const n=so(e,t,r.dtype,d,c,p,h,r.shape,l);return o.makeTensorInfo(u,r.dtype,n.values)}const m=new GatherNDProgram(c,h,[d,p],r.shape);const g=o.runWebGLProgram(m,[x,f],x.dtype);const C=reshape({inputs:{x:g},backend:o,attrs:{shape:u}});o.disposeIntermediateTensorInfo(f);o.disposeIntermediateTensorInfo(x);o.disposeIntermediateTensorInfo(g);return C}const zs={kernelName:Me,backendName:"webgl",kernelFunc:gatherNd};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class GatherProgram{constructor(e,t){this.variableNames=["A","indices"];this.outputShape=t;this.rank=t.length;const n=getCoordsDataType(this.rank);const o=getSourceCoords$1(e,2);this.userCode=`\n      void main() {\n        ${n} resRC = getOutputCoords();\n        int index = int(getIndices(resRC.x, resRC.z));\n        float inBounds = (index >= 0) && (index < ${e[2]}) ? 1.0 : 0.0;\n        setOutput(inBounds * getA(${o}));\n      }\n    `}}function getSourceCoords$1(e,t){const n=["resRC.x","resRC.y","resRC.z","resRC.w"];const o=[];for(let t=0;t<e.length;t++)t===2?o.push("index"):o.push(`${n[t]}`);return o.join()}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function gatherV2(e){const{inputs:o,backend:r,attrs:s}=e;const{x:i,indices:c}=o;const{axis:l,batchDims:u}=s;const d=n.parseAxisParam(l,i.shape)[0];if(t().get("DEBUG")){const e=r.readSync(c.dataId);const t=i.shape[d];for(let o=0;o<e.length;++o){const a=e[o];n.assert(a<=t-1&&a>=0,(()=>`GatherV2: the index value ${a} is not in [0, ${t-1}]`))}}const p=a.segment_util.collectGatherOpShapeInfo(i,c,d,u);const h=n.sizeFromShape(c.shape);const f=[];const x=reshape({inputs:{x:i},backend:r,attrs:{shape:[p.batchSize,p.outerSize,p.dimSize,p.sliceSize]}});const m=reshape({inputs:{x:c},backend:r,attrs:{shape:[p.batchSize,h/p.batchSize]}});f.push(x);f.push(m);const g=[p.batchSize,p.outerSize,h/p.batchSize,p.sliceSize];if(r.shouldExecuteOnCPU([i,c])||i.dtype==="string"){const e=r.bufferSync(m);const t=r.bufferSync(x);const n=io(t,e,g);f.forEach((e=>r.disposeIntermediateTensorInfo(e)));return r.makeTensorInfo(p.outputShape,n.dtype,n.values)}const C=new GatherProgram(x.shape,g);const b=r.runWebGLProgram(C,[x,m],x.dtype);f.push(b);const v=reshape({inputs:{x:b},backend:r,attrs:{shape:p.outputShape}});f.forEach((e=>r.disposeIntermediateTensorInfo(e)));return v}const Xs={kernelName:Ve,backendName:"webgl",kernelFunc:gatherV2};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Hs="return float(a > b);";const Ks="\n  return vec4(greaterThan(a, b));\n";const js=binaryKernelFunc({opSnippet:Hs,packedOpSnippet:Ks,cpuKernelImpl:co,dtype:"bool"});const qs={kernelName:We,backendName:"webgl",kernelFunc:js};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ys="return float(a >= b);";const Qs="\n  return vec4(greaterThanEqual(a, b));\n";const Zs=binaryKernelFunc({opSnippet:Ys,packedOpSnippet:Qs,dtype:"bool",cpuKernelImpl:lo});const Js={kernelName:Ge,backendName:"webgl",kernelFunc:Zs};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function ifft(e){const{inputs:t,backend:n}=e;const{input:o}=t;return fftImpl(o,true,n)}const ei={kernelName:ze,backendName:"webgl",kernelFunc:ifft};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ti="return float(!isnan(x) && !isinf(x));";const ni=unaryKernelFunc({opSnippet:ti,dtype:"bool"});const oi={kernelName:Xe,backendName:"webgl",kernelFunc:ni};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ai="return float(isinf(x));";const ri=unaryKernelFunc({opSnippet:ai,dtype:"bool"});const si={kernelName:He,backendName:"webgl",kernelFunc:ri};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ii="return float(isnan(x));";const ci=unaryKernelFunc({opSnippet:ii,dtype:"bool"});const li={kernelName:Ke,backendName:"webgl",kernelFunc:ci};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ui="return float(a < b);";const di="\n  return vec4(lessThan(a, b));\n";const pi=binaryKernelFunc({opSnippet:ui,packedOpSnippet:di,cpuKernelImpl:uo,dtype:"bool"});const hi={kernelName:je,backendName:"webgl",kernelFunc:pi};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const fi="return float(a <= b);";const xi="\n  return vec4(lessThanEqual(a, b));\n";const mi=binaryKernelFunc({opSnippet:fi,packedOpSnippet:xi,cpuKernelImpl:po,dtype:"bool"});const gi={kernelName:qe,backendName:"webgl",kernelFunc:mi};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function linSpace(e){const{backend:t,attrs:n}=e;const{start:o,stop:a,num:r}=n;const s=ho(o,a,r);return t.makeTensorInfo([s.length],"float32",s)}const Ci={kernelName:Ye,backendName:"webgl",kernelFunc:linSpace};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const bi=ya+"\n  return x < 0.0 ? 0./0. : log(x);\n";const vi="\n  vec4 result = log(x);\n  bvec4 isNaN = isnan(x);\n  result.r = isNaN.r ? x.r : (x.r < 0.0 ? 0./0. : result.r);\n  result.g = isNaN.g ? x.g : (x.g < 0.0 ? 0./0. : result.g);\n  result.b = isNaN.b ? x.b : (x.b < 0.0 ? 0./0. : result.b);\n  result.a = isNaN.a ? x.a : (x.a < 0.0 ? 0./0. : result.a);\n  return result;\n";const $i=unaryKernelFunc({opSnippet:bi,packedOpSnippet:vi,cpuKernelImpl:fo});const yi={kernelName:Qe,backendName:"webgl",kernelFunc:$i};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ii=ya+"\n  return log(1.0 + x);\n";const Si=unaryKernelFunc({opSnippet:Ii});const Ti={kernelName:Ze,backendName:"webgl",kernelFunc:Si};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ki="return float(a >= 1.0 && b >= 1.0);";const wi="\n  return vec4(\n    vec4(greaterThanEqual(a, vec4(1.0))) *\n    vec4(greaterThanEqual(b, vec4(1.0))));\n";const Ri=binaryKernelFunc({opSnippet:ki,packedOpSnippet:wi,dtype:"bool"});const Fi={kernelName:Je,backendName:"webgl",kernelFunc:Ri};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ni="return float(!(x >= 1.0));";const Ei=unaryKernelFunc({opSnippet:Ni});const Pi={kernelName:et,backendName:"webgl",kernelFunc:Ei};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ai="return float(a >= 1.0 || b >= 1.0);";const Oi="\n  return min(\n    vec4(greaterThanEqual(a, vec4(1.0))) +\n    vec4(greaterThanEqual(b, vec4(1.0))),\n    vec4(1.0));\n";const Di=binaryKernelFunc({opSnippet:Ai,packedOpSnippet:Oi,dtype:"bool"});const _i={kernelName:tt,backendName:"webgl",kernelFunc:Di};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class LRNProgram{constructor(e,t,n,o,a){this.variableNames=["x"];this.outputShape=[];const r=t;const s=e[3]-1;this.outputShape=e;let i;const c=`float(${n}) + float(${o}) * sum`;i=a===.5?`inversesqrt(${c})`:a===1?`1.0/(${c})`:`exp(log(${c}) * float(-${a}));`;this.userCode=`\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int r = coords[1];\n        int c = coords[2];\n        int d = coords[3];\n        float x = getX(b, r, c, d);\n        float sum = 0.0;\n        for (int j = -${r}; j <= ${r}; j++) {\n          int idx = d + j;\n          if (idx >= 0 && idx <=  ${s}) {\n            float z = getX(b, r, c, idx);\n            sum += z * z;\n          }\n        }\n        float val = x * ${i};\n        setOutput(val);\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class LRNPackedProgram{constructor(e,t,n,o,a){this.variableNames=["x"];this.outputShape=[];this.packedInputs=true;this.packedOutput=true;const r=t;const s=e[3]-1;this.outputShape=e;let i;const c=`float(${n}) + float(${o}) * sum`;i=a===.5?`inversesqrt(${c})`:a===1?`1.0/(${c})`:`exp(log(${c}) * float(-${a}));`;this.userCode=`\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords.x;\n        int r = coords.y;\n        int c = coords.z;\n        int d = coords.w;\n\n        bool hasNextCol = d < ${this.outputShape[3]};\n        bool hasNextRow = c < ${this.outputShape[2]};\n\n        vec4 sum = vec4(0.);\n        vec4 xFragAtOutputCoords = getX(b, r, c, d);\n\n        vec4 xAtOutputCoords = vec4(\n          getChannel(xFragAtOutputCoords, vec2(c, d)),\n          hasNextCol ?\n            getChannel(xFragAtOutputCoords, vec2(c, d + 1)) : 0.0,\n          hasNextRow ?\n            getChannel(xFragAtOutputCoords , vec2(c + 1, d)) : 0.0,\n          (hasNextRow && hasNextCol) ?\n            getChannel(xFragAtOutputCoords, vec2(c + 1, d + 1)) : 0.0\n        );\n\n        int firstChannel = d - ${r};\n        vec2 cache = vec2(0.);\n        if(firstChannel >= 0){\n          vec4 firstChannelFrag = getX(b, r, c, firstChannel);\n          cache.x = getChannel(firstChannelFrag, vec2(c, firstChannel));\n            if(hasNextRow){\n              cache.y = getChannel(firstChannelFrag, vec2(c + 1, firstChannel));\n            }\n        }\n\n        ivec2 depth = ivec2(d, d + 1);\n        for (int j = - ${r}; j <= ${r}; j++) {\n          ivec2 idx = depth + j;\n          bvec2 aboveLowerBound = greaterThanEqual(idx, ivec2(0));\n          bvec2 belowUpperBound = lessThanEqual(idx, ivec2(${s}));\n\n          bool depthInRange = aboveLowerBound.x && belowUpperBound.x;\n          bool depthPlusOneInRange = aboveLowerBound.y && belowUpperBound.y;\n\n          if(depthInRange || depthPlusOneInRange){\n            vec4 z = vec4(0.);\n            vec4 xFragAtCurrentDepth;\n            z.xz = cache.xy;\n            if(depthPlusOneInRange && hasNextCol){\n              xFragAtCurrentDepth = idx.y != d ?\n                getX(b, r, c, idx.y) : xFragAtOutputCoords;\n              z.y = getChannel(xFragAtCurrentDepth, vec2(c, idx.y));\n              if(hasNextRow){\n                z.w = getChannel(xFragAtCurrentDepth, vec2(c + 1, idx.y));\n              }\n            }\n            cache.xy = z.yw;\n            sum += z * z;\n          }\n        }\n        vec4 result = xAtOutputCoords * ${i};\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const lrn=e=>{const{inputs:n,backend:o,attrs:a}=e;const{x:r}=n;const{depthRadius:s,bias:i,alpha:c,beta:l}=a;const u=t().getBool("WEBGL_PACK_NORMALIZATION")?new LRNPackedProgram(r.shape,s,i,c,l):new LRNProgram(r.shape,s,i,c,l);return o.runWebGLProgram(u,[r],r.dtype)};const Li={kernelName:nt,backendName:"webgl",kernelFunc:lrn};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class LRNGradProgram{constructor(e,t,n,o,a){this.variableNames=["inputImage","outputImage","dy"];this.outputShape=[];this.outputShape=e;this.depth=e[3];this.depthRadius=t;this.bias=n;this.alpha=o;this.beta=a;this.userCode=`\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int r = coords[1];\n        int c = coords[2];\n\n        float result = 0.0;\n        for (int d = 0; d < ${this.depth}; ++d) {\n          int depthBegin = int(max(0.0, float(d - ${t})));\n          int depthEnd = int(min(float(${this.depth}),\n              float(d + ${t} + 1)));\n\n          const int MIN_DEPTH_BEGIN = 0;\n          const int MAX_DEPTH_END = ${this.depth};\n\n          float norm = 0.0;\n          for (int k = MIN_DEPTH_BEGIN; k < MAX_DEPTH_END; ++k) {\n            if (k < depthBegin){\n              continue;\n            }\n            else if (k >= depthBegin && k < depthEnd) {\n              norm += getInputImage(b, r, c, k) * getInputImage(b, r, c, k);\n            }\n            else {\n              break;\n            }\n          }\n\n          norm = float(${o}) * norm + float(${n});\n\n          for(int k = MIN_DEPTH_BEGIN; k < MAX_DEPTH_END; ++k){\n            if (k < depthBegin){\n              continue;\n            }\n            else if (k >= depthBegin && k < depthEnd){\n              float dyi = -2.0 * float(${o})\n                * float(${a})\n                * getInputImage(b, r, c, k) * getOutputImage(b, r, c, d)\n                / norm;\n              if (k == d) {\n                dyi += pow(norm, -1.0 * ${a});\n              }\n              if (k == coords[3]) {\n                dyi *= getDy(b, r, c, d);\n                result += dyi;\n              }\n            }\n            else {\n              break;\n            }\n          }\n      }\n      setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const lrnGrad=e=>{const{inputs:t,backend:n,attrs:o}=e;const{x:a,y:r,dy:s}=t;const{depthRadius:i,bias:c,alpha:l,beta:u}=o;const d=new LRNGradProgram(a.shape,i,c,l,u);return n.runWebGLProgram(d,[a,r,s],a.dtype)};const Bi={kernelName:ot,backendName:"webgl",kernelFunc:lrnGrad};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function maxImpl(e,t,o,a){const r=n.sizeFromShape(t);const s=n.sizeFromShape(e.shape);const i=s/r;const c=reshape({inputs:{x:e},attrs:{shape:[i,r]},backend:a});const l=reduce(c,e.dtype,"max",a);const u=reshape({inputs:{x:l},attrs:{shape:o},backend:a});a.disposeIntermediateTensorInfo(c);a.disposeIntermediateTensorInfo(l);return u}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function max(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{reductionIndices:i,keepDims:c}=r;const l=s.shape.length;const u=n.parseAxisParam(i,s.shape);let d=u;const p=a.getAxesPermutation(d,l);const h=p!=null;const f=o.shouldExecuteOnCPU([s]);let x=s;if(h){if(f){const e=o.texData.get(x.dataId);const t=e.values;const n=new Array(l);for(let e=0;e<n.length;e++)n[e]=s.shape[p[e]];const a=Go(t,s.shape,s.dtype,p,n);x=o.makeTensorInfo(n,s.dtype);const r=o.texData.get(x.dataId);r.values=a}else x=transposeImpl(s,p,o);d=a.getInnerMostAxes(d.length,l)}a.assertAxesAreInnerMostDims("max",d,l);const[m,g]=a.computeOutAndReduceShapes(x.shape,d);let C=m;c&&(C=a.expandShapeToKeepDim(m,u));let b;if(f){const e=o.texData.get(x.dataId);const t=e.values;const a=xo(t,n.sizeFromShape(g),C,s.dtype);b=o.makeTensorInfo(C,s.dtype);const r=o.texData.get(b.dataId);r.values=a}else b=maxImpl(x,g,C,o);h&&o.disposeIntermediateTensorInfo(x);return b}const Ui={kernelName:at,backendName:"webgl",kernelFunc:max};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Mi=pa+"\n  return max(a, b);\n";const Vi="\n  vec4 result = vec4(max(a, b));\n  bvec4 isNaNA = isnan(a);\n  bvec4 isNaNB = isnan(b);\n  bvec4 isNaN = bvec4(isNaNA.x || isNaNB.x, isNaNA.y || isNaNB.y, isNaNA.z || isNaNB.z, isNaNA.w || isNaNB.w);\n  "+ha+"\n  return result;\n";const Wi=binaryKernelFunc({opSnippet:Mi,packedOpSnippet:Vi,cpuKernelImpl:mo});const Gi={kernelName:rt,backendName:"webgl",kernelFunc:Wi};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function maxPool(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;assertNotComplex(s,"maxPool");const{filterSize:i,strides:c,pad:l,dimRoundingMode:u}=r;const d=1;n.assert(a.eitherStridesOrDilationsAreOne(c,d),(()=>`Error in maxPool: Either strides or dilations must be 1. Got strides ${c} and dilations '${d}'`));const p=a.computePool2DInfo(s.shape,i,c,d,l,u);if(p.filterWidth===1&&p.filterHeight===1&&n.arraysEqual(p.inShape,p.outShape))return identity({inputs:{x:s},backend:o});const h=new Pool2DProgram(p,"max",false);return o.runWebGLProgram(h,[s],s.dtype)}const zi={kernelName:st,backendName:"webgl",kernelFunc:maxPool};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function maxPool3d(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r}=t;const{filterSize:s,strides:i,pad:c,dataFormat:l,dimRoundingMode:u}=o;const d=[1,1,1];const p=a.computePool3DInfo(r.shape,s,i,d,c,u,l);const h=new Pool3DProgram(p,"max",false);return n.runWebGLProgram(h,[r],r.dtype)}const Xi={kernelName:it,backendName:"webgl",kernelFunc:maxPool3d};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class MaxPool2DBackpropProgram{constructor(e){this.variableNames=["dy","maxPos"];this.outputShape=e.inShape;const t=e.strideHeight;const n=e.strideWidth;const o=e.dilationHeight;const a=e.effectiveFilterHeight;const r=e.effectiveFilterWidth;const s=a-1-e.padInfo.top;const i=r-1-e.padInfo.left;const c=a*r-1;this.userCode=`\n      const ivec2 pads = ivec2(${s}, ${i});\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n\n        ivec2 dyRCCorner = coords.yz - pads;\n        int dyRCorner = dyRCCorner.x;\n        int dyCCorner = dyRCCorner.y;\n\n        // Convolve dy(?, ?, d) with pos mask(:, :, d) to get dx(xR, xC, d).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n        for (int wR = 0; wR < ${a};\n          wR += ${o}) {\n          float dyR = float(dyRCorner + wR) / ${t}.0;\n\n          if (dyR < 0.0 || dyR >= ${e.outHeight}.0 || fract(dyR) > 0.0) {\n            continue;\n          }\n          int idyR = int(dyR);\n\n          for (int wC = 0; wC < ${r}; wC++) {\n            float dyC = float(dyCCorner + wC) / ${n}.0;\n\n            if (dyC < 0.0 || dyC >= ${e.outWidth}.0 ||\n                fract(dyC) > 0.0) {\n              continue;\n            }\n            int idyC = int(dyC);\n\n            float dyValue = getDy(b, idyR, idyC, d);\n            int maxPosValue = ${c} - int(getMaxPos(b, idyR, idyC, d));\n\n            // Get the current value, check it against the value from the\n            // position matrix.\n            int curPosValue = wR * ${r} + wC;\n            float mask = float(maxPosValue == curPosValue ? 1.0 : 0.0);\n\n            dotProd += dyValue * mask;\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}class MaxPool3DBackpropProgram{constructor(e){this.variableNames=["dy","maxPos"];this.outputShape=e.inShape;const t=e.strideDepth;const n=e.strideHeight;const o=e.strideWidth;const a=e.dilationDepth;const r=e.dilationHeight;const s=e.dilationWidth;const i=e.effectiveFilterDepth;const c=e.effectiveFilterHeight;const l=e.effectiveFilterWidth;const u=i-1-e.padInfo.front;const d=c-1-e.padInfo.top;const p=l-1-e.padInfo.left;const h=i*c*l-1;this.userCode=`\n      const ivec3 pads = ivec3(${u}, ${d}, ${p});\n\n      void main() {\n        ivec5 coords = getOutputCoords();\n        int batch = coords.x;\n        int ch = coords.u;\n\n        ivec3 dyCorner = ivec3(coords.y, coords.z, coords.w) - pads;\n        int dyDCorner = dyCorner.x;\n        int dyRCorner = dyCorner.y;\n        int dyCCorner = dyCorner.z;\n\n        // Convolve dy(?, ?, ?, ch) with pos mask(:, :, :, d) to get\n        // dx(xD, xR, xC, ch).\n        // ? = to be determined. : = across all values in that axis.\n        float dotProd = 0.0;\n\n        for (int wD = 0; wD < ${i};\n           wD += ${a}) {\n          float dyD = float(dyDCorner + wD) / ${t}.0;\n\n          if (dyD < 0.0 || dyD >= ${e.outDepth}.0 || fract(dyD) > 0.0) {\n            continue;\n          }\n          int idyD = int(dyD);\n\n          for (int wR = 0; wR < ${c};\n              wR += ${r}) {\n            float dyR = float(dyRCorner + wR) / ${n}.0;\n\n            if (dyR < 0.0 || dyR >= ${e.outHeight}.0 ||\n                fract(dyR) > 0.0) {\n              continue;\n            }\n            int idyR = int(dyR);\n\n            for (int wC = 0; wC < ${l};\n                wC += ${s}) {\n              float dyC = float(dyCCorner + wC) / ${o}.0;\n\n              if (dyC < 0.0 || dyC >= ${e.outWidth}.0 ||\n                  fract(dyC) > 0.0) {\n                continue;\n              }\n              int idyC = int(dyC);\n\n              float dyValue = getDy(batch, idyD, idyR, idyC, ch);\n              int maxPosValue = ${h} -\n                  int(getMaxPos(batch, idyD, idyR, idyC, ch));\n\n              // Get the current value, check it against the value from the\n              // position matrix.\n              int curPosValue =\n                  wD * ${c} * ${l} +\n                  wR * ${l} + wC;\n              float mask = float(maxPosValue == curPosValue ? 1.0 : 0.0);\n\n              dotProd += dyValue * mask;\n            }\n          }\n        }\n        setOutput(dotProd);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function maxPool3DGrad(e){const{inputs:t,backend:n,attrs:o}=e;const{dy:r,input:s}=t;const i=s;const{filterSize:c,strides:l,pad:u,dimRoundingMode:d}=o;const p=[1,1,1];const h=a.computePool3DInfo(i.shape,c,l,p,u,d);const f=new Pool3DProgram(h,"max",true);const x=n.runWebGLProgram(f,[i],i.dtype);const m=new MaxPool3DBackpropProgram(h);const g=n.runWebGLProgram(m,[r,x],i.dtype);n.disposeIntermediateTensorInfo(x);return g}const Hi={kernelName:ct,backendName:"webgl",kernelFunc:maxPool3DGrad};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function maxPoolGrad(e){const{inputs:t,backend:n,attrs:o}=e;const{dy:r,input:s,output:i}=t;const c=s;assertNotComplex([s,i],"maxPoolGrad");const{filterSize:l,strides:u,pad:d,dimRoundingMode:p}=o;const h=a.computePool2DInfo(c.shape,l,u,1,d,p);const f=true;const x=new Pool2DProgram(h,"max",f);const m=n.runWebGLProgram(x,[c],c.dtype);const g=new MaxPool2DBackpropProgram(h);const C=n.runWebGLProgram(g,[r,m],c.dtype);n.disposeIntermediateTensorInfo(m);return C}const Ki={kernelName:lt,backendName:"webgl",kernelFunc:maxPoolGrad};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function maxPoolWithArgmaxImpl(e,t,n,o){let a=new Pool2DProgram(n,"max",false);const r=o.runWebGLProgram(a,[e],"float32");a=new Pool2DProgram(n,"max",true,true,t);const s=o.runWebGLProgram(a,[e],"float32");return[r,s]}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ji={kernelName:ut,backendName:"webgl",kernelFunc:({inputs:e,attrs:t,backend:o})=>{const{x:r}=e;const{filterSize:s,strides:i,pad:c,includeBatchInIndex:l}=t;const u=o;n.assert(r.shape.length===4,(()=>`Error in maxPool: input must be rank 4 but got rank ${r.shape.length}.`));const d=[1,1];n.assert(a.eitherStridesOrDilationsAreOne(i,d),(()=>`Error in maxPool: Either strides or dilations must be 1. Got strides ${i} and dilations '${d}'`));const p=a.computePool2DInfo(r.shape,s,i,d,c);const[h,f]=maxPoolWithArgmaxImpl(r,l,p,u);return[h,f]}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function meanImpl(e,t,o,a){const r=n.sizeFromShape(t);const s=n.sizeFromShape(e.shape);const i=s/r;const c=reshape({inputs:{x:e},attrs:{shape:[i,r]},backend:a});const l=reduce(c,"float32","mean",a);const u=reshape({inputs:{x:l},attrs:{shape:o},backend:a});a.disposeIntermediateTensorInfo(c);a.disposeIntermediateTensorInfo(l);return u}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const qi={kernelName:dt,backendName:"webgl",kernelFunc:({inputs:e,attrs:t,backend:o})=>{const{x:r}=e;const{keepDims:s,axis:i}=t;const c=o;const l=r.shape.length;const u=n.parseAxisParam(i,r.shape);let d=u;const p=a.getAxesPermutation(d,l);const h=p!=null;const f=c.shouldExecuteOnCPU([r]);const x=[];let m=r;if(h){if(f){const e=c.texData.get(m.dataId);const t=e.values;const n=new Array(l);for(let e=0;e<n.length;e++)n[e]=r.shape[p[e]];const o=Go(t,r.shape,r.dtype,p,n);m=c.makeTensorInfo(n,r.dtype);const a=c.texData.get(m.dataId);a.values=o}else m=transposeImpl(r,p,c);x.push(m);d=a.getInnerMostAxes(d.length,l)}a.assertAxesAreInnerMostDims("sum",d,l);const[g,C]=a.computeOutAndReduceShapes(m.shape,d);let b=g;s&&(b=a.expandShapeToKeepDim(g,u));const v=meanImpl(m,C,b,c);for(const e of x)c.disposeIntermediateTensorInfo(e);return v}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function min(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{axis:i,keepDims:c}=r;const l=s.shape.length;const u=n.parseAxisParam(i,s.shape);let d=u;const p=a.getAxesPermutation(d,l);let h=s;if(p!=null){h=transpose({inputs:{x:s},backend:o,attrs:{perm:p}});d=a.getInnerMostAxes(d.length,s.shape.length)}a.assertAxesAreInnerMostDims("min",d,l);const[f,x]=a.computeOutAndReduceShapes(h.shape,d);const m=n.sizeFromShape(x);const g=reshape({inputs:{x:h},backend:o,attrs:{shape:[-1,m]}});const C=reduce(g,g.dtype,"min",o);let b;if(c){const e=a.expandShapeToKeepDim(f,u);b=reshape({inputs:{x:C},backend:o,attrs:{shape:e}})}else b=reshape({inputs:{x:C},backend:o,attrs:{shape:f}});o.disposeIntermediateTensorInfo(g);o.disposeIntermediateTensorInfo(C);p!=null&&o.disposeIntermediateTensorInfo(h);return b}const Yi={kernelName:pt,backendName:"webgl",kernelFunc:min};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Qi=pa+"\n  return min(a, b);\n";const Zi="\n  vec4 result = vec4(min(a, b));\n  bvec4 isNaNA = isnan(a);\n  bvec4 isNaNB = isnan(b);\n  bvec4 isNaN = bvec4(isNaNA.x || isNaNB.x, isNaNA.y || isNaNB.y, isNaNA.z || isNaNB.z, isNaNA.w || isNaNB.w);\n  "+ha+"\n  return result;\n";const Ji=binaryKernelFunc({opSnippet:Qi,packedOpSnippet:Zi,cpuKernelImpl:go});const ec={kernelName:ht,backendName:"webgl",kernelFunc:Ji};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */class MirrorPadProgram{constructor(e,t,n){this.variableNames=["x"];this.outputShape=t.map(((t,n)=>t[0]+e[n]+t[1]));const o=e.length;const a=getCoordsDataType(o);const r=t.map((e=>e[0])).join(",");const s=t.map(((t,n)=>t[0]+e[n])).join(",");const i=["coords[0]","coords[1]","coords[2]","coords[3]"].slice(0,o);const c=n==="reflect"?0:1;this.userCode=o!==1?`\n      ${a} start = ${a}(${r});\n      ${a} end = ${a}(${s});\n\n      void main() {\n        ${a} outC = getOutputCoords();\n        for (int i = 0; i < ${o}; i++) {\n          if (outC[i] < start[i]) {\n            outC[i] = start[i] * 2 - outC[i] - ${c};\n          } else if(outC[i] >= end[i]) {\n            outC[i] = (end[i] - 1) * 2 - outC[i] + ${c};\n          }\n        }\n        ${a} coords = outC - start;\n        setOutput(getX(${i}));\n      }\n    `:`\n        int start = ${r};\n        int end = ${s};\n\n        void main() {\n          int outC = getOutputCoords();\n          if (outC < start) {\n            outC = start * 2 - outC - ${c};\n          } else if(outC >= end) {\n            outC = (end - 1) * 2 - outC + ${c};\n          }\n          setOutput(getX(outC - start));\n        }\n      `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */class MirrorPadPackedProgram{constructor(e,t,n){this.variableNames=["x"];this.packedInputs=true;this.packedOutput=true;this.outputShape=t.map(((t,n)=>t[0]+e[n]+t[1]));const o=e.length;const a=getCoordsDataType(o);const r=t.map((e=>e[0])).join(",");const s=t.map(((t,n)=>t[0]+e[n])).join(",");const i=getChannels("rc",o);const c=getChannels("source",o);const l=`${i[o-1]} < ${this.outputShape[o-1]}`;const u=o===1?"source":`vec2(${c.slice(-2).join()})`;const d=n==="reflect"?0:1;let p="";if(o===1){const e=`\n        ${a} source = rc;\n        if (source < start) {\n          source = start * 2 - source - ${d};\n        } else if (source >= end) {\n          source = (end - 1) * 2 - source + ${d};\n        }\n        source -= start;\n      `;p=`\n        ${a} rc = outputLoc;\n        ${e}\n        result[0] = getChannel(getX(${c.join()}), ${u});\n        ${i[o-1]} += 1;\n        if(${l}) {\n          ${e}\n          result[1] = getChannel(getX(${c.join()}), ${u});\n        }\n      `}else{const e=`\n        ${a} source = rc;\n        ${a} lt = ${a}(lessThan(source, start));\n        ${a} gte = ${a}(greaterThanEqual(source, end));\n        ${a} orig = 1 - (lt + gte);\n        source = orig * source +\n                lt * (start * 2 - source - ${d}) +\n                gte * ((end - 1) * 2 - source + ${d});\n        source -= start;\n      `;p=`\n        ${a} rc = outputLoc;\n        ${e}\n        result[0] = getChannel(getX(${c.join()}), ${u});\n        ${i[o-1]} += 1;\n        if(${l}) {\n          ${e}\n          result[1] = getChannel(getX(${c.join()}), ${u});\n        }\n        rc = outputLoc;\n        ${i[o-2]} += 1;\n        if(${i[o-2]} < ${this.outputShape[o-2]}) {\n          ${e}\n          result[2] = getChannel(getX(${c.join()}), ${u});\n          ${i[o-1]} += 1;\n          if(${l}) {\n            ${e}\n            result[3] = getChannel(getX(${c.join()}), ${u});\n          }\n        }\n      `}this.userCode=`\n      const ${a} start = ${a}(${r});\n      const ${a} end = ${a}(${s});\n\n      void main() {\n        ${a} outputLoc = getOutputCoords();\n        vec4 result = vec4(0.);\n        ${p}\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const mirrorPadKernelFunc=({inputs:e,backend:n,attrs:o})=>{const{x:a}=e;const{paddings:r,mode:s}=o;const i=t().getBool("WEBGL_PACK_ARRAY_OPERATIONS")?new MirrorPadPackedProgram(a.shape,r,s):new MirrorPadProgram(a.shape,r,s);const c=n.runWebGLProgram(i,[a],a.dtype);return c};const tc={kernelName:ft,backendName:"webgl",kernelFunc:mirrorPadKernelFunc};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const nc="if (b == 0.0) return NAN;\n  return mod(a, b);";const oc="\n  vec4 result = mod(a, b);\n  bvec4 isNaN = equal(b, vec4(0.0));\n  "+ha+"\n  return result;\n";const ac=binaryKernelFunc({opSnippet:nc,packedOpSnippet:oc});const rc={kernelName:xt,backendName:"webgl",kernelFunc:ac};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class MultinomialProgram{constructor(e,t,n){this.variableNames=["probs"];this.customUniforms=[{name:"seed",type:"float"}];this.outputShape=[e,n];this.userCode=`\n      void main() {\n        ivec2 coords = getOutputCoords();\n        int batch = coords[0];\n\n        float r = random(seed);\n        float cdf = 0.0;\n\n        for (int i = 0; i < ${t-1}; i++) {\n          cdf += getProbs(batch, i);\n\n          if (r < cdf) {\n            setOutput(float(i));\n            return;\n          }\n        }\n\n        // If no other event happened, last event happened.\n        setOutput(float(${t-1}));\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const sc="\nif (a == b) {\n  return 1.0;\n};\nreturn a / b;";const ic="\n  // vec4 one = vec4(equal(a, b));\n  // return one + (vec4(1.0) - one) * a / b;\n  vec4 result = a / b;\n  if(a.x == b.x) {\n    result.x = 1.;\n  }\n  if(a.y == b.y) {\n    result.y = 1.;\n  }\n  if(a.z == b.z) {\n    result.z = 1.;\n  }\n  if(a.w == b.w) {\n    result.w = 1.;\n  }\n\n  return result;\n";const cc=binaryKernelFunc({opSnippet:sc,packedOpSnippet:ic,checkOutOfBounds:true});const lc={kernelName:mt,backendName:"webgl",kernelFunc:cc};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const uc="return a - b;";const dc=binaryKernelFunc({opSnippet:uc,packedOpSnippet:uc,supportsComplex:true,cpuKernelImpl:Mo});const pc={kernelName:gt,backendName:"webgl",kernelFunc:dc};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function softmax(e){const{inputs:t,backend:o,attrs:r}=e;const{logits:s}=t;const{dim:i}=r;const c=n.parseAxisParam([i],s.shape);const l=max({inputs:{x:s},backend:o,attrs:{reductionIndices:c,keepDims:false}});const u=a.expandShapeToKeepDim(l.shape,c);const d=reshape({inputs:{x:l},backend:o,attrs:{shape:u}});const p=dc({inputs:{a:s,b:d},backend:o});const h=Is({inputs:{x:p},backend:o});const f=sum({inputs:{x:h},backend:o,attrs:{axis:c,keepDims:false}});const x=reshape({inputs:{x:f},backend:o,attrs:{shape:u}});const m=cc({inputs:{a:h,b:x},backend:o});o.disposeIntermediateTensorInfo(l);o.disposeIntermediateTensorInfo(d);o.disposeIntermediateTensorInfo(p);o.disposeIntermediateTensorInfo(h);o.disposeIntermediateTensorInfo(f);o.disposeIntermediateTensorInfo(x);return m}const hc={kernelName:Ct,backendName:"webgl",kernelFunc:softmax};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function multinomial(e){const{inputs:t,backend:n,attrs:o}=e;const{logits:a}=t;const{numSamples:r,seed:s,normalized:i}=o;const c=i?a:softmax({inputs:{logits:a},backend:n,attrs:{dim:a.shape.length-1}});const l=c.shape[0];const u=c.shape[1];const d=new MultinomialProgram(l,u,r);const p=[[s]];const h=n.runWebGLProgram(d,[c],"int32",p);i||n.disposeIntermediateTensorInfo(c);return h}const fc={kernelName:bt,backendName:"webgl",kernelFunc:multinomial};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const xc=Xo+"\n  return -x;\n";const mc="\n  vec4 result = -x;\n  bvec4 isNaN = isnan(x);\n\n  result.r = isNaN.r ? x.r : result.r;\n  result.g = isNaN.g ? x.g : result.g;\n  result.b = isNaN.b ? x.b : result.b;\n  result.a = isNaN.a ? x.a : result.a;\n\n  return result;\n";function neg(e){const{inputs:n,backend:o}=e;const{x:a}=n;if(o.shouldExecuteOnCPU([a])){const e=o.texData.get(a.dataId);const[t,n]=bo(e.values,a.shape,a.dtype);return o.makeTensorInfo(n,a.dtype,t)}let r;r=t().getBool("WEBGL_PACK_UNARY_OPERATIONS")?new UnaryOpPackedProgram(a.shape,mc):new UnaryOpProgram(a.shape,xc);return o.runWebGLProgram(r,[a],a.dtype)}const gc={kernelName:vt,backendName:"webgl",kernelFunc:neg};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Cc=r.nonMaxSuppressionV3Impl;function nonMaxSuppressionV3(e){a.warn("tf.nonMaxSuppression() in webgl locks the UI thread. Call tf.nonMaxSuppressionAsync() instead");const{inputs:t,backend:n,attrs:o}=e;const{boxes:r,scores:s}=t;const{maxOutputSize:i,iouThreshold:c,scoreThreshold:l}=o;const u=n.readSync(r.dataId);const d=n.readSync(s.dataId);const{selectedIndices:p}=Cc(u,d,i,c,l);return n.makeTensorInfo([p.length],"int32",new Int32Array(p))}const bc={kernelName:$t,backendName:"webgl",kernelFunc:nonMaxSuppressionV3};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const vc=r.nonMaxSuppressionV4Impl;function nonMaxSuppressionV4(e){a.warn("tf.nonMaxSuppression() in webgl locks the UI thread. Call tf.nonMaxSuppressionAsync() instead");const{inputs:t,backend:n,attrs:o}=e;const{boxes:r,scores:s}=t;const{maxOutputSize:i,iouThreshold:c,scoreThreshold:l,padToMaxOutputSize:u}=o;const d=n.readSync(r.dataId);const p=n.readSync(s.dataId);const{selectedIndices:h,validOutputs:f}=vc(d,p,i,c,l,u);return[n.makeTensorInfo([h.length],"int32",new Int32Array(h)),n.makeTensorInfo([],"int32",new Int32Array([f]))]}const $c={kernelName:yt,backendName:"webgl",kernelFunc:nonMaxSuppressionV4};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const yc=r.nonMaxSuppressionV5Impl;function nonMaxSuppressionV5(e){a.warn("tf.nonMaxSuppression() in webgl locks the UI thread. Call tf.nonMaxSuppressionAsync() instead");const{inputs:t,backend:n,attrs:o}=e;const{boxes:r,scores:s}=t;const{maxOutputSize:i,iouThreshold:c,scoreThreshold:l,softNmsSigma:u}=o;const d=n.readSync(r.dataId);const p=n.readSync(s.dataId);const h=i;const f=c;const x=l;const m=u;const{selectedIndices:g,selectedScores:C}=yc(d,p,h,f,x,m);return[n.makeTensorInfo([g.length],"int32",new Int32Array(g)),n.makeTensorInfo([C.length],"float32",new Float32Array(C))]}const Ic={kernelName:It,backendName:"webgl",kernelFunc:nonMaxSuppressionV5};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class OneHotProgram{constructor(e,t,n,o){this.variableNames=["indices"];this.outputShape=[e,t];this.userCode=`\n      void main() {\n        ivec2 coords = getOutputCoords();\n        int index = round(getIndices(coords.x));\n        setOutput(mix(float(${o}), float(${n}),\n                      float(index == coords.y)));\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const oneHot=e=>{const{inputs:t,backend:o,attrs:a}=e;const{indices:r}=t;const{dtype:s,depth:i,onValue:c,offValue:l}=a;const u=n.sizeFromShape(r.shape);const d=new OneHotProgram(u,i,c,l);const p=reshape({inputs:{x:r},backend:o,attrs:{shape:[u]}});const h=o.runWebGLProgram(d,[p],s);o.disposeIntermediateTensorInfo(p);const f=[...r.shape,i];const x=reshape({inputs:{x:h},backend:o,attrs:{shape:f}});o.disposeIntermediateTensorInfo(h);return x};const Sc={kernelName:St,backendName:"webgl",kernelFunc:oneHot};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function zerosLike(e){const{inputs:t,backend:n}=e;const{x:o}=t;if(o.dtype==="complex64"){const e=real({inputs:{input:o},backend:n});const t=zerosLike({inputs:{x:e},backend:n});const a=imag({inputs:{input:o},backend:n});const r=zerosLike({inputs:{x:a},backend:n});const s=complex({inputs:{real:t,imag:r},backend:n});n.disposeIntermediateTensorInfo(e);n.disposeIntermediateTensorInfo(t);n.disposeIntermediateTensorInfo(a);n.disposeIntermediateTensorInfo(r);return s}return fill({attrs:{shape:o.shape,dtype:o.dtype,value:o.dtype==="string"?"":0},backend:n})}const Tc={kernelName:Tt,backendName:"webgl",kernelFunc:zerosLike};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function onesLike(e){const{inputs:t,backend:n}=e;const{x:o}=t;if(o.dtype==="string")throw new Error("onesLike is not supported under string dtype");if(o.dtype==="complex64"){const e=real({inputs:{input:o},backend:n});const t=onesLike({inputs:{x:e},backend:n});const a=imag({inputs:{input:o},backend:n});const r=zerosLike({inputs:{x:a},backend:n});const s=complex({inputs:{real:t,imag:r},backend:n});n.disposeIntermediateTensorInfo(e);n.disposeIntermediateTensorInfo(t);n.disposeIntermediateTensorInfo(a);n.disposeIntermediateTensorInfo(r);return s}return fill({attrs:{shape:o.shape,dtype:o.dtype,value:1},backend:n})}const kc={kernelName:kt,backendName:"webgl",kernelFunc:onesLike};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function pack(e){const{inputs:t,backend:o,attrs:a}=e;const{axis:r}=a;if(t.length===1)return expandDims({inputs:{input:t[0]},backend:o,attrs:{dim:r}});const s=t[0].shape;const i=t[0].dtype;t.forEach((e=>{n.assertShapesMatch(s,e.shape,"All tensors passed to stack must have matching shapes");n.assert(i===e.dtype,(()=>"All tensors passed to stack must have matching dtypes"))}));const c=[];const l=t.map((e=>{const t=expandDims({inputs:{input:e},backend:o,attrs:{dim:r}});c.push(t);return t}));const u=concat({inputs:l,backend:o,attrs:{axis:r}});c.forEach((e=>o.disposeIntermediateTensorInfo(e)));return u}const wc={kernelName:wt,backendName:"webgl",kernelFunc:pack};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class PadProgram{constructor(e,t,n){this.variableNames=["x"];this.customUniforms=[{name:"value",type:"float"}];this.outputShape=t.map(((t,n)=>t[0]+e[n]+t[1]));const o=e.length;const a=getCoordsDataType(o);const r=t.map((e=>e[0])).join(",");const s=t.map(((t,n)=>t[0]+e[n])).join(",");const i=["coords[0]","coords[1]","coords[2]","coords[3]"].slice(0,o);this.userCode=o!==1?`\n      ${a} start = ${a}(${r});\n      ${a} end = ${a}(${s});\n\n      void main() {\n        ${a} outC = getOutputCoords();\n        if (any(lessThan(outC, start)) || any(greaterThanEqual(outC, end))) {\n          setOutput(value);\n        } else {\n          ${a} coords = outC - start;\n          setOutput(getX(${i}));\n        }\n      }\n    `:`\n        int start = ${r};\n        int end = ${s};\n\n        void main() {\n          int outC = getOutputCoords();\n          if (outC < start || outC >= end) {\n            setOutput(value);\n          } else {\n            setOutput(getX(outC - start));\n          }\n        }\n      `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class PadPackedProgram{constructor(e,t,n){this.variableNames=["x"];this.packedInputs=true;this.packedOutput=true;this.customUniforms=[{name:"value",type:"float"}];this.outputShape=t.map(((t,n)=>t[0]+e[n]+t[1]));const o=e.length;const a=getCoordsDataType(o);const r=t.map((e=>e[0])).join(",");const s=t.map(((t,n)=>t[0]+e[n])).join(",");const i=getChannels("rc",o);const c=getChannels("source",o);const l=`${i[o-1]} < ${this.outputShape[o-1]}`;const u=o===1?"source":`vec2(${c.slice(-2).join()})`;const d=[`${a} rc = outputLoc;`,`${i[o-1]} += 1;\n       if(${l}) {\n      `,o===1?"":`}\n       rc = outputLoc;\n       ${i[o-2]} += 1;\n       if(${i[o-2]} < ${this.outputShape[o-2]}) {`,o===1?"":`  ${i[o-1]} += 1;\n         if(${l}) {`];const p=o===1?"rc < start || rc >= end":"any(lessThan(rc, start)) || any(greaterThanEqual(rc, end))";let h="";for(let e=0,t=o===1?2:4;e<t;e++)h+=`\n        ${d[e]}\n        if (${p}) {\n          result[${e}] = float(value);\n        } else {\n          ${a} source = rc - start;\n          result[${e}] = getChannel(getX(${c.join()}), ${u});\n        }\n      `;h+=o===1?"} ":"}}";this.userCode=`\n      const ${a} start = ${a}(${r});\n      const ${a} end = ${a}(${s});\n\n      void main() {\n        ${a} outputLoc = getOutputCoords();\n        vec4 result = vec4(0.);\n        ${h}\n        setOutput(result);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const padV2=e=>{const{inputs:o,backend:a,attrs:r}=e;const{x:s}=o;const{paddings:i,constantValue:c}=r;if(n.sizeFromShape(s.shape)===0){const e=i.map(((e,t)=>e[0]+s.shape[t]+e[1]));return fill({backend:a,attrs:{shape:e,value:c,dtype:s.dtype}})}const l=t().getBool("WEBGL_PACK_ARRAY_OPERATIONS")?new PadPackedProgram(s.shape,i,c):new PadProgram(s.shape,i,c);const u=[[c]];return a.runWebGLProgram(l,[s],s.dtype,u)};const Rc={kernelName:Rt,backendName:"webgl",kernelFunc:padV2};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Fc="\n  if(a < 0.0 && floor(b) < b){\n    return NAN;\n  }\n  if (b == 0.0) {\n    return 1.0;\n  }\n  return (round(mod(b, 2.0)) != 1) ?\n      pow(abs(a), b) : sign(a) * pow(abs(a), b);\n";const Nc="\n  // isModRound1 has 1 for components with round(mod(b, 2.0)) == 1, 0 otherwise.\n  vec4 isModRound1 = vec4(equal(round(mod(b, 2.0)), ivec4(1)));\n  vec4 multiplier = sign(a) * isModRound1 + (vec4(1.0) - isModRound1);\n  vec4 result = multiplier * pow(abs(a), b);\n\n  // Ensure that a^0 = 1, including 0^0 = 1 as this correspond to TF and JS\n  bvec4 isExpZero = equal(b, vec4(0.0));\n  result.r = isExpZero.r ? 1.0 : result.r;\n  result.g = isExpZero.g ? 1.0 : result.g;\n  result.b = isExpZero.b ? 1.0 : result.b;\n  result.a = isExpZero.a ? 1.0 : result.a;\n\n  bvec4 isNaN1 = lessThan(a, vec4(0.0));\n  bvec4 isNaN2 = lessThan(floor(b), b);\n  bvec4 isNaN = bvec4(isNaN1.x && isNaN2.x, isNaN1.y && isNaN2.y, isNaN1.z && isNaN2.z, isNaN1.w && isNaN2.w);\n  "+ha+"\n  return result;\n";const Ec=binaryKernelFunc({opSnippet:Fc,packedOpSnippet:Nc});const Pc={kernelName:Ft,backendName:"webgl",kernelFunc:Ec};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function prod(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{axis:i,keepDims:c}=r;const l=s.shape.length;const u=[];const d=n.parseAxisParam(i,s.shape);let p=d;const h=a.getAxesPermutation(p,l);let f=s;if(h!=null){f=transpose({inputs:{x:s},backend:o,attrs:{perm:h}});p=a.getInnerMostAxes(p.length,l);u.push(f)}a.assertAxesAreInnerMostDims("prod",p,l);let x;if(o.shouldExecuteOnCPU([f])){const e=o.texData.get(f.dataId).values;const{outVals:t,outShape:n,outDtype:a}=$o(f.shape,f.dtype,e,p);x=o.makeTensorInfo(n,a,t)}else{const[e,t]=a.computeOutAndReduceShapes(f.shape,p);const r=n.sizeFromShape(t);const i=reshape({inputs:{x:f},backend:o,attrs:{shape:[-1,r]}});const c=$(s.dtype);const l=reduce(i,c,"prod",o);x=reshape({inputs:{x:l},backend:o,attrs:{shape:e}});u.push(i);u.push(l)}if(c){u.push(x);const e=a.expandShapeToKeepDim(x.shape,d);x=reshape({inputs:{x:x},backend:o,attrs:{shape:e}})}u.forEach((e=>o.disposeIntermediateTensorInfo(e)));return x}const Ac={kernelName:Nt,backendName:"webgl",kernelFunc:prod};
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
 */function raggedGather(e){const{inputs:t,backend:n,attrs:o}=e;const{paramsNestedSplits:a,paramsDenseValues:r,indices:s}=t;const{outputRaggedRank:i}=o;const c=a.map((e=>n.readSync(e.dataId)));const l=a.map((e=>e.shape));const u=n.readSync(r.dataId);const d=n.readSync(s.dataId);const[p,h,f]=yo(c,l,u,r.shape,r.dtype,d,s.shape,i);const x=p.map((e=>n.makeTensorInfo([e.length],"int32",e)));const m=n.makeTensorInfo(f,r.dtype,h);return x.concat([m])}const Oc={kernelName:Et,backendName:"webgl",kernelFunc:raggedGather};
/**
 * @license
 * Copyright 2022 Google LLC.
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
 */function raggedRange(e){const{inputs:t,backend:n}=e;const{starts:o,limits:a,deltas:r}=t;const s=n.readSync(o.dataId);const i=n.readSync(a.dataId);const c=n.readSync(r.dataId);const[l,u]=Io(s,o.shape,o.dtype,i,a.shape,c,r.shape);const d=n.makeTensorInfo([l.length],"int32",l);const p=n.makeTensorInfo([u.length],o.dtype,u);return[d,p]}const Dc={kernelName:Pt,backendName:"webgl",kernelFunc:raggedRange};
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
 */function raggedTensorToTensor(e){const{inputs:t,backend:n,attrs:o}=e;const{shape:a,values:r,defaultValue:s,rowPartitionTensors:i}=t;const{rowPartitionTypes:c}=o;const l=n.readSync(a.dataId);const u=n.readSync(r.dataId);const d=n.readSync(s.dataId);const p=i.map((e=>n.readSync(e.dataId)));const h=i.map((e=>e.shape));const[f,x]=So(l,a.shape,u,r.shape,r.dtype,d,s.shape,p,h,c);return n.makeTensorInfo(f,r.dtype,x)}const _c={kernelName:At,backendName:"webgl",kernelFunc:raggedTensorToTensor};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const range=e=>{const{backend:t,attrs:n}=e;const{start:o,stop:a,step:r,dtype:s}=n;const i=To(o,a,r,s);return t.makeTensorInfo([i.length],s,i)};const Lc={kernelName:Ot,backendName:"webgl",kernelFunc:range};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Bc="return 1.0 / x;";const Uc=unaryKernelFunc({opSnippet:Bc});const Mc={kernelName:Dt,backendName:"webgl",kernelFunc:Uc};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Vc=Xo+"\n  return (x < 0.0) ? 0.0 : x;\n";const Wc="\n  vec4 result = x * vec4(greaterThanEqual(x, vec4(0.0)));\n  bvec4 isNaN = isnan(x);\n\n  result.r = isNaN.r ? x.r : result.r;\n  result.g = isNaN.g ? x.g : result.g;\n  result.b = isNaN.b ? x.b : result.b;\n  result.a = isNaN.a ? x.a : result.a;\n\n  return result;\n";const Gc=unaryKernelFunc({opSnippet:Vc,packedOpSnippet:Wc});const zc={kernelName:_t,backendName:"webgl",kernelFunc:Gc};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Xc=Xo+"\n  return (x < 0.0) ? 0.0 : min(6.0, x);\n";const Hc="\n  vec4 result = min(x, vec4(6.)) * vec4(greaterThanEqual(x, vec4(0.0)));\n  bvec4 isNaN = isnan(x);\n\n  result.r = isNaN.r ? x.r : result.r;\n  result.g = isNaN.g ? x.g : result.g;\n  result.b = isNaN.b ? x.b : result.b;\n  result.a = isNaN.a ? x.a : result.a;\n\n  return result;\n";const Kc=unaryKernelFunc({opSnippet:Xc,packedOpSnippet:Hc});const jc={kernelName:Lt,backendName:"webgl",kernelFunc:Kc};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class ResizeBilinearProgram{constructor(e,t,n,o,a){this.variableNames=["A"];this.outputShape=[];const[r,s,i,c]=e;this.outputShape=[r,t,n,c];const l=[o&&t>1?s-1:s,o&&n>1?i-1:i];const u=[o&&t>1?t-1:t,o&&n>1?n-1:n];let d;d=a?"(vec2(yRC) + vec2(0.5)) * effectiveInputOverOutputRatioRC - vec2(0.5)":"vec2(yRC) * effectiveInputOverOutputRatioRC";this.userCode=`\n      const vec2 effectiveInputOverOutputRatioRC = vec2(\n          ${l[0]/u[0]},\n          ${l[1]/u[1]});\n      const vec2 inputShapeRC = vec2(${s}.0, ${i}.0);\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n        ivec2 yRC = coords.yz;\n\n        // Fractional source index.\n        vec2 sourceFracIndexRC = ${d};\n\n        // Compute the four integer indices.\n        ivec2 sourceFloorRC = ivec2(max(sourceFracIndexRC, vec2(0.0)));\n        ivec2 sourceCeilRC = ivec2(\n          min(inputShapeRC - 1.0, ceil(sourceFracIndexRC)));\n\n        float topLeft = getA(b, sourceFloorRC.x, sourceFloorRC.y, d);\n        float bottomLeft = getA(b, sourceCeilRC.x, sourceFloorRC.y, d);\n        float topRight = getA(b, sourceFloorRC.x, sourceCeilRC.y, d);\n        float bottomRight = getA(b, sourceCeilRC.x, sourceCeilRC.y, d);\n\n        vec2 fracRC = sourceFracIndexRC - vec2(sourceFloorRC);\n\n        float top = topLeft + (topRight - topLeft) * fracRC.y;\n        float bottom = bottomLeft + (bottomRight - bottomLeft) * fracRC.y;\n        float newValue = top + (bottom - top) * fracRC.x;\n\n        setOutput(newValue);\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class ResizeBilinearPackedProgram{constructor(e,t,n,o,a){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;this.outputShape=[];const[r,s,i,c]=e;this.outputShape=[r,t,n,c];const l=[o&&t>1?s-1:s,o&&n>1?i-1:i];const u=[o&&t>1?t-1:t,o&&n>1?n-1:n];let d;d=a?"(vec3(yRC) + vec3(0.5)) * effectiveInputOverOutputRatioRC - vec3(0.5)":"vec3(yRC) * effectiveInputOverOutputRatioRC";this.userCode=`\n      const vec3 effectiveInputOverOutputRatioRC = vec3(\n          ${l[0]/u[0]},\n          ${l[1]/u[1]},\n          ${l[1]/u[1]});\n      const vec3 inputShapeRC = vec3(${s}.0, ${i}.0,\n                                     ${i}.0);\n\n      float getAValue(int b, int r, int c, int d) {\n        return getChannel(getA(b, r, c, d), vec2(c, d));\n      }\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n        // Calculate values for next column in yRC.z.\n        ivec3 yRC = coords.yzz + ivec3(0, 0, 1);\n\n        // Fractional source index.\n        vec3 sourceFracIndexRC = ${d};\n\n        // Compute the four integer indices.\n        ivec3 sourceFloorRC = ivec3(max(sourceFracIndexRC, vec3(0.0)));\n        ivec3 sourceCeilRC = ivec3(\n          min(inputShapeRC - 1.0, ceil(sourceFracIndexRC)));\n\n        // Should we calculate next column and row elements in 2x2 packed cell.\n        bool hasNextCol = d < ${c-1};\n        bool hasNextRow = coords.z < ${n-1};\n\n        // In parallel, construct four corners for all four components in\n        // packed 2x2 cell.\n        vec4 topLeft = vec4(\n          getAValue(b, sourceFloorRC.x, sourceFloorRC.y, d),\n          hasNextCol ? getAValue(b, sourceFloorRC.x, sourceFloorRC.y, d + 1)\n                     : 0.0,\n          hasNextRow ? getAValue(b, sourceFloorRC.x, sourceFloorRC.z, d)\n                     : 0.0,\n          (hasNextRow && hasNextCol) ?\n            getAValue(b, sourceFloorRC.x, sourceFloorRC.z, d + 1) : 0.0);\n\n        vec4 bottomLeft = vec4(\n          getAValue(b, sourceCeilRC.x, sourceFloorRC.y, d),\n          hasNextCol ? getAValue(b, sourceCeilRC.x, sourceFloorRC.y, d + 1)\n                     : 0.0,\n          hasNextRow ? getAValue(b, sourceCeilRC.x, sourceFloorRC.z, d)\n                     : 0.0,\n          (hasNextRow && hasNextCol) ?\n            getAValue(b, sourceCeilRC.x, sourceFloorRC.z, d + 1) : 0.0);\n\n        vec4 topRight = vec4(\n          getAValue(b, sourceFloorRC.x, sourceCeilRC.y, d),\n          hasNextCol ? getAValue(b, sourceFloorRC.x, sourceCeilRC.y, d + 1)\n                     : 0.0,\n          hasNextRow ? getAValue(b, sourceFloorRC.x, sourceCeilRC.z, d)\n                     : 0.0,\n          (hasNextRow && hasNextCol) ?\n            getAValue(b, sourceFloorRC.x, sourceCeilRC.z, d + 1) : 0.0);\n\n        vec4 bottomRight = vec4(\n          getAValue(b, sourceCeilRC.x, sourceCeilRC.y, d),\n          hasNextCol ? getAValue(b, sourceCeilRC.x, sourceCeilRC.y, d + 1)\n                     : 0.0,\n          hasNextRow ? getAValue(b, sourceCeilRC.x, sourceCeilRC.z, d)\n                     : 0.0,\n          (hasNextRow && hasNextCol) ?\n            getAValue(b, sourceCeilRC.x, sourceCeilRC.z, d + 1) : 0.0);\n\n        vec3 fracRC = sourceFracIndexRC - vec3(sourceFloorRC);\n\n        vec4 top = mix(topLeft, topRight, fracRC.yyzz);\n        vec4 bottom = mix(bottomLeft, bottomRight, fracRC.yyzz);\n        vec4 newValue = mix(top, bottom, fracRC.x);\n\n        setOutput(newValue);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function resizeBilinear(e){const{inputs:n,backend:o,attrs:a}=e;const{images:r}=n;const{alignCorners:s,halfPixelCenters:i,size:c}=a;const[l,u]=c;const d=t().getBool("WEBGL_PACK_IMAGE_OPERATIONS")?new ResizeBilinearPackedProgram(r.shape,l,u,s,i):new ResizeBilinearProgram(r.shape,l,u,s,i);return o.runWebGLProgram(d,[r],"float32")}const qc={kernelName:Bt,backendName:"webgl",kernelFunc:resizeBilinear};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class ResizeBilinearBackpropProgram{constructor(e,t,n){this.variableNames=["dy"];this.outputShape=[];this.outputShape=t;const[,o,a]=t;const[,r,s]=e;const i=[n&&r>1?o-1:o,n&&s>1?a-1:a];const c=[n&&r>1?r-1:r,n&&s>1?s-1:s];const l=i[0]/c[0];const u=i[1]/c[1];const d=1/l;const p=1/u;const h=Math.ceil(d)*2+2;const f=Math.ceil(p)*2+2;this.userCode=`\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n        int r = coords[1];\n        int c = coords[2];\n\n        float accumulator = 0.0;\n\n        const float heightScale = float(${l});\n        const float widthScale = float(${u});\n\n        const float invHeightScale = float(${d});\n        const float invWidthScale = float(${p});\n\n        const int winHeight = int(${h});\n        const int winWidth = int(${f});\n\n        // Compute bounds for where in dy we will look\n        float startRLerp = floor(float(r) * invHeightScale);\n        int startDyR = int(startRLerp - float(winHeight / 2));\n\n        float startCLerp = floor(float(c) * invWidthScale);\n        int startDyC = int(startCLerp - float(winWidth / 2));\n\n        // Loop over dy\n        for (int dyROffset = 0; dyROffset < winHeight; dyROffset++) {\n          int dyR = dyROffset + startDyR;\n\n          // Guard against the window exceeding the bounds of dy\n          if (dyR < 0 || dyR >= ${r}) {\n            continue;\n          }\n\n          for (int dyCOffset = 0; dyCOffset < winWidth; dyCOffset++) {\n            int dyC = dyCOffset + startDyC;\n\n            // Guard against the window exceeding the bounds of dy\n            if (dyC < 0 || dyC >= ${s}) {\n              continue;\n            }\n\n            float dxR = float(dyR) * heightScale;\n            int topDxRIndex = int(floor(dxR));\n            int bottomDxRIndex = int(min(ceil(dxR), ${o-1}.0));\n            float dxRLerp = dxR - float(topDxRIndex);\n            float inverseDxRLerp = 1.0 - dxRLerp;\n\n            float dxC = float(dyC) * widthScale;\n            int leftDxCIndex = int(floor(dxC));\n            int rightDxCIndex = int(min(ceil(dxC), ${a-1}.0));\n            float dxCLerp = dxC - float(leftDxCIndex);\n            float inverseDxCLerp = 1.0 - dxCLerp;\n\n            if (r == topDxRIndex && c == leftDxCIndex) {\n              // topLeft\n              accumulator +=\n                getDy(b, dyR, dyC, d) * inverseDxRLerp * inverseDxCLerp;\n            }\n\n            if (r == topDxRIndex && c == rightDxCIndex) {\n              // topRight\n              accumulator += getDy(b, dyR, dyC, d) * inverseDxRLerp * dxCLerp;\n            }\n\n            if (r == bottomDxRIndex && c == leftDxCIndex) {\n              // bottomLeft\n              accumulator += getDy(b, dyR, dyC, d) * dxRLerp * inverseDxCLerp;\n            }\n\n            if (r == bottomDxRIndex && c == rightDxCIndex) {\n              // bottomRight\n              accumulator += getDy(b, dyR, dyC, d) * dxRLerp * dxCLerp;\n            }\n          }\n        }\n        // End loop over dy\n\n        setOutput(accumulator);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function resizeBilinearGrad(e){const{inputs:t,backend:n,attrs:o}=e;const{images:a,dy:r}=t;const{alignCorners:s}=o;const i=new ResizeBilinearBackpropProgram(r.shape,a.shape,s);return n.runWebGLProgram(i,[r],r.dtype)}const Yc={kernelName:Ut,backendName:"webgl",kernelFunc:resizeBilinearGrad};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class ResizeNearestNeighborProgram{constructor(e,t,n,o,a){this.variableNames=["A"];this.outputShape=[];const[r,s,i,c]=e;this.outputShape=[r,t,n,c];const l=[o&&t>1?s-1:s,o&&n>1?i-1:i];const u=[o&&t>1?t-1:t,o&&n>1?n-1:n];const d=o?"0.5":"0.0";let p;p=a?"max((vec2(yRC) + vec2(0.5)) * effectiveInputOverOutputRatioRC, vec2(0.0))":"vec2(yRC) * effectiveInputOverOutputRatioRC";this.userCode=`\n      const vec2 effectiveInputOverOutputRatioRC = vec2(\n          ${l[0]/u[0]},\n          ${l[1]/u[1]});\n      const vec2 inputShapeRC = vec2(${s}.0, ${i}.0);\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n        ivec2 yRC = coords.yz;\n\n        // Fractional source index.\n        vec2 sourceFracIndexRC = ${p};\n\n        // Compute the coordinators of nearest neighbor point.\n        ivec2 sourceNearestRC = ivec2(\n          min(inputShapeRC - 1.0, floor(sourceFracIndexRC + ${d})));\n        float newValue = getA(b, sourceNearestRC.x, sourceNearestRC.y, d);\n\n        setOutput(newValue);\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class ResizeNearestNeighborPackedProgram{constructor(e,t,n,o,a){this.variableNames=["A"];this.packedInputs=true;this.packedOutput=true;this.outputShape=[];const[r,s,i,c]=e;this.outputShape=[r,t,n,c];const l=[o&&t>1?s-1:s,o&&n>1?i-1:i];const u=[o&&t>1?t-1:t,o&&n>1?n-1:n];const d=o?"0.5":"0.0";let p;p=a?"max((vec3(yRC) + vec3(0.5)) * effectiveInputOverOutputRatioRC, vec3(0.0))":"vec3(yRC) * effectiveInputOverOutputRatioRC";this.userCode=`\n      const vec3 effectiveInputOverOutputRatioRC = vec3(\n          ${l[0]/u[0]},\n          ${l[1]/u[1]},\n          ${l[1]/u[1]});\n      const vec3 inputShapeRC = vec3(${s}.0, ${i}.0,\n                                     ${i}.0);\n\n      float getAValue(int b, int r, int c, int d) {\n        return getChannel(getA(b, r, c, d), vec2(c, d));\n      }\n\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n        // Calculate values for next column in yRC.z.\n        ivec3 yRC = coords.yzz + ivec3(0, 0, 1);\n\n        // Fractional source index.\n        vec3 sourceFracIndexRC = ${p};\n\n        // Compute the coordinators of nearest neighbor point.\n        ivec3 sourceNearestRC = ivec3(\n          min(inputShapeRC - 1.0, floor(sourceFracIndexRC + ${d})));\n\n        // Should we calculate next column and row elements in 2x2 packed cell.\n        bool hasNextCol = d < ${c-1};\n        bool hasNextRow = coords.z < ${n-1};\n\n        vec4 newValue = vec4(\n          getAValue(b, sourceNearestRC.x, sourceNearestRC.y, d),\n          hasNextCol ? getAValue(b, sourceNearestRC.x, sourceNearestRC.y, d + 1)\n                     : 0.0,\n          hasNextRow ? getAValue(b, sourceNearestRC.x, sourceNearestRC.z, d)\n                     : 0.0,\n          (hasNextRow && hasNextCol) ?\n            getAValue(b, sourceNearestRC.x, sourceNearestRC.z, d + 1) : 0.0);\n\n        setOutput(newValue);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function resizeNearestNeighbor(e){const{inputs:n,backend:o,attrs:a}=e;const{images:r}=n;const{alignCorners:s,halfPixelCenters:i,size:c}=a;const[l,u]=c;const d=t().getBool("WEBGL_PACK_IMAGE_OPERATIONS")?new ResizeNearestNeighborPackedProgram(r.shape,l,u,s,i):new ResizeNearestNeighborProgram(r.shape,l,u,s,i);return o.runWebGLProgram(d,[r],r.dtype)}const Qc={kernelName:Mt,backendName:"webgl",kernelFunc:resizeNearestNeighbor};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class ResizeNearestNeigborBackpropProgram{constructor(e,t,n){this.variableNames=["dy"];this.outputShape=[];this.outputShape=t;const[,o,a]=t;const[,r,s]=e;const i=[n&&r>1?o-1:o,n&&s>1?a-1:a];const c=[n&&r>1?r-1:r,n&&s>1?s-1:s];const l=i[0]/c[0];const u=i[1]/c[1];const d=1/l;const p=1/u;const h=Math.ceil(d)*2+2;const f=Math.ceil(p)*2+2;this.userCode=`\n      void main() {\n        ivec4 coords = getOutputCoords();\n        int b = coords[0];\n        int d = coords[3];\n        int r = coords[1];\n        int c = coords[2];\n\n        float accumulator = 0.0;\n\n        const float heightScale = float(${l});\n        const float widthScale = float(${u});\n\n        const float invHeightScale = float(${d});\n        const float invWidthScale = float(${p});\n\n        const int winHeight = int(${h});\n        const int winWidth = int(${f});\n\n        // Compute bounds for where in dy we will look\n        float startRLerp = floor(float(r) * invHeightScale);\n        int startDyR = int(floor(startRLerp - float(winHeight / 2)));\n\n        float startCLerp = floor(float(c) * invWidthScale);\n        int startDyC = int(floor(startCLerp - float(winWidth / 2)));\n\n        // Loop over dy\n        for (int dyROffset = 0; dyROffset < winHeight; dyROffset++) {\n          int dyR = dyROffset + startDyR;\n\n          // Guard against the window exceeding the bounds of dy\n          if (dyR < 0 || dyR >= ${r}) {\n            continue;\n          }\n\n          for (int dyCOffset = 0; dyCOffset < winWidth; dyCOffset++) {\n            int dyC = dyCOffset + startDyC;\n\n            // Guard against the window exceeding the bounds of dy\n            if (dyC < 0 || dyC >= ${s}) {\n              continue;\n            }\n\n            float sourceFracRow =\n              float(${i[0]}) *\n                (float(dyR) / float(${c[0]}));\n\n            float sourceFracCol =\n                float(${i[1]}) *\n                  (float(dyC) / float(${c[1]}));\n\n            int sourceNearestRow = int(min(\n                float(int(${o}) - 1),\n                ${n} ? float(round(sourceFracRow)) :\n                                  float(floor(sourceFracRow))));\n\n            int sourceNearestCol = int(min(\n                float(int(${a}) - 1),\n                ${n} ? float(round(sourceFracCol)) :\n                                  float(floor(sourceFracCol))));\n\n            if (r == sourceNearestRow && c == sourceNearestCol) {\n              accumulator += getDy(b, dyR, dyC, d);\n            }\n          }\n        }\n        // End loop over dy\n\n        setOutput(accumulator);\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function resizeNearestNeighborGrad(e){const{inputs:t,backend:n,attrs:o}=e;const{images:a,dy:r}=t;const{alignCorners:s}=o;const i=new ResizeNearestNeigborBackpropProgram(r.shape,a.shape,s);return n.runWebGLProgram(i,[r],r.dtype)}const Zc={kernelName:Vt,backendName:"webgl",kernelFunc:resizeNearestNeighborGrad};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class ReverseProgram{constructor(e,t){this.variableNames=["x"];const n=e.length;if(n>4)throw new Error(`WebGL backend: Reverse of rank-${n} tensor is not yet supported`);this.outputShape=e;if(n===1){this.userCode=`\n        void main() {\n          int coord = getOutputCoords();\n          setOutput(getX(${e[0]} - coord - 1));\n        }\n      `;return}const getInCoord=n=>t.indexOf(n)!==-1&&e[n]!==1?`${e[n]} - coords[${n}] - 1`:`coords[${n}]`;const o=e.map(((e,t)=>getInCoord(t))).join(",");const a=getCoordsDataType(n);this.userCode=`\n      void main() {\n        ${a} coords = getOutputCoords();\n        setOutput(getX(${o}));\n      }\n    `}}
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */class ReversePackedProgram{constructor(e,t){this.variableNames=["x"];this.packedInputs=true;this.packedOutput=true;const n=e.length;if(n>4)throw new Error(`WebGL backend: Reverse of rank-${n} tensor is not yet supported`);this.outputShape=e;const o=getChannels("rc",n);const a=`${o[n-1]} + 1 < ${this.outputShape[n-1]}`;const r=`${o[n-2]} + 1 < ${this.outputShape[n-2]}`;const s=getCoordsDataType(n);this.userCode=n===1?`\n        void main(){\n          int rc = getOutputCoords();\n          vec4 result = vec4(0.);\n          result.r = getChannel(getX(${e[0]} - rc - 1),\n            ${e[0]} - rc - 1);\n          if(${a}){\n              result.g = getChannel(getX(${e[0]} - (rc  + 1) - 1),\n                ${e[0]} - (rc  + 1) - 1);\n          }\n          setOutput(result);\n        }\n      `:`\n        void main() {\n          ${s} rc = getOutputCoords();\n          vec4 result = vec4(0.);\n          result.r = ${getR(o.slice())};\n          if(${a}){\n            result.g = ${getG(o.slice())};\n          }\n          if(${r}) {\n            result.b = ${getB(o.slice())};\n            if(${a}) {\n              result.a = ${getA(o.slice())};\n            }\n          }\n          setOutput(result);\n        }\n    `;function getR(e){return getChannel(e)}function getG(e){e[n-1]="("+e[n-1]+" + 1)";return getChannel(e)}function getB(e){e[n-2]="("+e[n-2]+" + 1)";return getChannel(e)}function getA(e){e[n-1]="("+e[n-1]+" + 1)";e[n-2]="("+e[n-2]+" + 1)";return getChannel(e)}function getChannel(t){const n=e.map(((e,n)=>getInCoord(n,t)));const o=n.join(",");const a=n.slice(-2).join(",");return`getChannel(getX(${o}), vec2(${a}))`}function getInCoord(n,o){return t.indexOf(n)!==-1&&e[n]!==1?`${e[n]} - ${o[n]} - 1`:`${o[n]}`}}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function reverse(e){const{inputs:o,backend:a,attrs:r}=e;const{x:s}=o;const{dims:i}=r;const c=s.shape.length;const l=n.parseAxisParam(i,s.shape);if(c===0)return identity({inputs:{x:s},backend:a});const u=t().getBool("WEBGL_PACK_ARRAY_OPERATIONS")?new ReversePackedProgram(s.shape,l):new ReverseProgram(s.shape,l);return a.runWebGLProgram(u,[s],s.dtype)}const Jc={kernelName:Wt,backendName:"webgl",kernelFunc:reverse};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */class RotateProgram{constructor(e,t){this.variableNames=["Image"];this.outputShape=[];this.customUniforms=[{name:"params",type:"vec4"}];const n=e[1];const o=e[2];this.outputShape=e;let a="";a=typeof t==="number"?`float outputValue = ${t.toFixed(2)};`:`\n        vec3 fill = vec3(${t.join(",")});\n        float outputValue = fill[coords[3]];`;this.userCode=`\n        void main() {\n          ivec4 coords = getOutputCoords();\n          int x = coords[2];\n          int y = coords[1];\n          float coordXFloat = (float(x) - params[0]) * params[3] -\n            (float(y) - params[1]) * params[2];\n          float coordYFloat = (float(x) - params[0]) * params[2] +\n            (float(y) - params[1]) * params[3];\n          int coordX = int(round(coordXFloat + params[0]));\n          int coordY = int(round(coordYFloat + params[1]));\n          ${a}\n          if(coordX >= 0 && coordX < ${o} && coordY >= 0 && coordY < ${n}) {\n            outputValue = getImage(coords[0], coordY, coordX, coords[3]);\n          }\n          setOutput(outputValue);\n        }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const el={kernelName:Gt,backendName:"webgl",kernelFunc:({inputs:e,attrs:t,backend:n})=>{const{image:o}=e;const{radians:r,fillValue:s,center:i}=t;const c=n;const l=new RotateProgram(o.shape,s);const[u,d]=a.getImageCenter(i,o.shape[1],o.shape[2]);const p=[[u,d,Math.sin(r),Math.cos(r)]];const h=c.runWebGLProgram(l,[o],o.dtype,p);return h}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const tl="\n  // OpenGL ES does not support round function.\n  // The algorithm is based on banker's rounding.\n  float base = floor(x);\n  if ((x - base) < 0.5) {\n    return floor(x);\n  } else if ((x - base) > 0.5) {\n    return ceil(x);\n  } else {\n    if (mod(base, 2.0) == 0.0) {\n      return base;\n    } else {\n      return base + 1.0;\n    }\n  }\n";const nl=unaryKernelFunc({opSnippet:tl});const ol={kernelName:zt,backendName:"webgl",kernelFunc:nl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const al="return inversesqrt(x);";const rl=unaryKernelFunc({opSnippet:al,cpuKernelImpl:ko});const sl={kernelName:Xt,backendName:"webgl",kernelFunc:rl};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class ScatterProgram{constructor(e,t,n,o,a,r,s=true,i=false){this.variableNames=["updates","indices","defaultValue"];this.outputShape=r;const c=getCoordsDataType(a.length);const l=getCoordsDataType(r.length);let u="";n===1?u="i":n===2&&(u="i, j");const d=`getIndices(${u})`;let p="";o===1?p="i":o===2&&(p="i, coords[1]");const h=`getUpdates(${p})`;let f="";i&&(f="coords[0], coords[1]");const x=`getDefaultValue(${f})`;const m=t>1?"strides[j]":"strides";this.userCode=`\n        ${c} strides = ${c}(${a});\n\n        void main() {\n          ${l} coords = getOutputCoords();\n          float sum = 0.0;\n          bool found = false;\n          for (int i = 0; i < ${e}; i++) {\n            int flattenedIndex = 0;\n            for (int j = 0; j < ${t}; j++) {\n              int index = round(${d});\n              flattenedIndex += index * ${m};\n            }\n            if (flattenedIndex == coords[0]) {\n              sum += ${h};\n              found = true;\n            }\n          }\n          setOutput(mix(${x}, sum, float(found)));\n        }\n      `}}
/**
 * @license
 * Copyright 2023 Google LLC.
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
 */class ScatterPackedProgram{constructor(e,t,n,o,a,r,s=true,i=false){this.variableNames=["updates","indices","defaultValue"];this.packedInputs=true;this.packedOutput=true;this.outputShape=r;const c=getCoordsDataType(a.length);const l=getCoordsDataType(r.length);let u="";n===1?u="i":n===2&&(u="i, j");const d=`getIndices(${u})`;let p="";o===1?p="i":o===2&&(p="i, coords[1]");const h=`getUpdates(${p})`;let f="";i&&(f="coords[0], coords[1]");const x=`getDefaultValue(${f})`;const m=t>1?"strides[j]":"strides";const g=t>1?"strides[j + 1]":"strides";this.userCode=`\n        ${c} strides = ${c}(${a});\n\n        void main() {\n          ${l} coords = getOutputCoords();\n          vec4 sum = vec4(0.);\n          vec4 found = vec4(0.);\n          for (int i = 0; i < ${e}; i+=2) {\n            ivec2 flattenedIndex = ivec2(0);\n            for (int j = 0; j < ${t}; j+=2) {\n              ivec4 index = round(${d});\n              flattenedIndex += index.xz * ${m};\n              if (j + 1 < ${t}) {\n                flattenedIndex += index.yw * ${g};\n              }\n            }\n            if (flattenedIndex[0] == coords[0] || flattenedIndex[1] == coords[0] ||\n                flattenedIndex[0] == coords[0] + 1 || flattenedIndex[1] == coords[0] + 1) {\n              vec4 updVals = ${h};\n              if (flattenedIndex[0] == coords[0]) {\n                sum.xy += updVals.xy;\n                found.xy = vec2(1.);\n              } else if (flattenedIndex[0] == coords[0] + 1) {\n                sum.zw += updVals.xy;\n                found.zw = vec2(1.);\n              }\n              if (flattenedIndex[1] == coords[0]) {\n                sum.xy += updVals.zw;\n                found.xy = vec2(1.);\n              } else if (flattenedIndex[1] == coords[0] + 1) {\n                sum.zw += updVals.zw;\n                found.zw = vec2(1.);\n              }\n            }\n          }\n          setOutput(mix(${x}, sum, found));\n        }\n      `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function scatterNd(e){const{inputs:n,backend:o,attrs:r}=e;const{indices:s,updates:i}=n;const{shape:c}=r;const{sliceRank:l,numUpdates:u,sliceSize:d,strides:p,outputSize:h}=a.calculateShapes(i,s,c);const f=[h/d,d];if(h===0)return o.makeTensorInfo(c,s.dtype);const x=reshape({inputs:{x:s},backend:o,attrs:{shape:[u,l]}});const m=reshape({inputs:{x:i},backend:o,attrs:{shape:[u,d]}});const g=o.makeTensorInfo([],"float32",new Float32Array([0]));let C;C=t().getBool("WEBGL_PACK")?new ScatterPackedProgram(u,l,x.shape.length,m.shape.length,p,f):new ScatterProgram(u,l,x.shape.length,m.shape.length,p,f);const b=o.runWebGLProgram(C,[m,x,g],m.dtype);const v=reshape({inputs:{x:b},backend:o,attrs:{shape:c}});o.disposeIntermediateTensorInfo(x);o.disposeIntermediateTensorInfo(m);o.disposeIntermediateTensorInfo(b);o.disposeIntermediateTensorInfo(g);return v}const il={kernelName:Ht,backendName:"webgl",kernelFunc:scatterNd};
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
 */class SearchSortedProgram{constructor(e,n,o,a){this.variableNames=["sortedSequence","values"];this.customUniforms=[{name:"numInputs",type:"int"}];this.outputShape=[e,o];const r="while (left < right) {";const s=`for (int i = 0; i < ${Math.ceil(Math.log2(n+1))}; ++i) { if (left >= right) break;`;const i=t().getNumber("WEBGL_VERSION")===2?r:s;const c=a==="left"?"<":"<=";this.userCode=`\n       int findBound(int batch, float value) {\n         int left = 0;\n         int right = numInputs;\n         int mid;\n         ${i}\n           mid = (left + right) / 2;\n           if (getSortedSequence(batch, mid) ${c} value) {\n             left = mid + 1;\n           } else {\n             right = mid;\n           }\n         }\n         return right;\n       }\n\n       void main() {\n         ivec2 coords = getOutputCoords();\n         int batch = coords[0];\n         int valueIndex = coords[1];\n\n         float value = getValues(batch, valueIndex);\n\n         setOutput(float(findBound(batch, value)));\n       }\n     `}}
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
 */function searchSorted(e){const{inputs:t,backend:n,attrs:o}=e;const{sortedSequence:a,values:r}=t;const{side:s}=o;const i=new SearchSortedProgram(a.shape[0],a.shape[1],r.shape[1],s);const c=[[a.shape[1]]];return n.runWebGLProgram(i,[a,r],"int32",c)}const cl={kernelName:Kt,backendName:"webgl",kernelFunc:searchSorted};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class SelectProgram{constructor(e,t,n){this.variableNames=["c","a","b"];this.outputShape=t;let o;let a;if(n>4)throw Error(`Where for rank ${n} is not yet supported`);if(n===1){a="resRC";o="resRC"}else{const n=["resRC.x","resRC.y","resRC.z","resRC.w"];const r=[];const s=[];for(let o=0;o<t.length;o++){s.push(`${n[o]}`);o<e&&r.push(`${n[o]}`)}o=r.join();a=s.join()}const r=getCoordsDataType(n);this.userCode=`\n      void main() {\n        ${r} resRC = getOutputCoords();\n        float cVal = getC(${o});\n        if (cVal >= 1.0) {\n          setOutput(getA(${a}));\n        } else {\n          setOutput(getB(${a}));\n        }\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function select(e){const{inputs:t,backend:n}=e;const{condition:o,t:a,e:r}=t;const s=new SelectProgram(o.shape.length,a.shape,a.shape.length);return n.runWebGLProgram(s,[o,a,r],C(a.dtype,r.dtype))}const ll={kernelName:jt,backendName:"webgl",kernelFunc:select};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const ul=`\n  // Stable and Attracting Fixed Point (0, 1) for Normalized Weights.\n  // see: https://arxiv.org/abs/1706.02515\n  float scaleAlpha = ${a.SELU_SCALEALPHA};\n  float scale = ${a.SELU_SCALE};\n  return (x >= 0.0) ? scale * x : scaleAlpha * (exp(x) - 1.0);\n`;const dl=unaryKernelFunc({opSnippet:ul});const pl={kernelName:qt,backendName:"webgl",kernelFunc:dl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const hl=ya+"\n  return 1.0 / (1.0 + exp(-1.0 * x));\n";const fl="\n  vec4 result = 1.0 / (1.0 + exp(-1.0 * x));\n  bvec4 isNaN = isnan(x);\n\n  result.r = isNaN.r ? x.r : result.r;\n  result.g = isNaN.g ? x.g : result.g;\n  result.b = isNaN.b ? x.b : result.b;\n  result.a = isNaN.a ? x.a : result.a;\n\n  return result;\n";const xl=unaryKernelFunc({opSnippet:hl,packedOpSnippet:fl,cpuKernelImpl:Ro});const ml={kernelName:Yt,backendName:"webgl",kernelFunc:xl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const gl="\n  if (isnan(x)) { return 0.0; }\n  return sign(x);\n";const Cl=unaryKernelFunc({opSnippet:gl});const bl={kernelName:Qt,backendName:"webgl",kernelFunc:Cl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const vl=ya+"\n  return sin(x);\n";const $l=`\n  vec4 result = sin(x);\n  bvec4 isNaN = isnan(x);\n  ${ha}\n  return result;\n`;const yl=unaryKernelFunc({opSnippet:vl,packedOpSnippet:$l});const Il={kernelName:Zt,backendName:"webgl",kernelFunc:yl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Sl="\n  float e2x = exp(x);\n  return (e2x - 1.0 / e2x) / 2.0;\n";const Tl=unaryKernelFunc({opSnippet:Sl});const kl={kernelName:Jt,backendName:"webgl",kernelFunc:Tl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const wl="\n  float epsilon = 1.1920928955078125e-7;\n  float threshold = log(epsilon) + 2.0;\n\n  bool too_large = x > -threshold;\n  bool too_small = x < threshold;\n\n  float result;\n  float exp_x = exp(x);\n\n  if (too_large){\n    result = x;\n  }\n  else if (too_small){\n    result = exp_x;\n  }\n  else{\n    result = log(exp_x + 1.0);\n  }\n  return result;\n";const Rl=unaryKernelFunc({opSnippet:wl});const Fl={kernelName:en,backendName:"webgl",kernelFunc:Rl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const spaceToBatchND=e=>{const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{blockShape:i,paddings:c}=r;n.assert(s.shape.length<=4,(()=>"spaceToBatchND for rank > 4 with a WebGL backend not implemented yet"));const l=i.reduce(((e,t)=>e*t));const u=[[0,0]];u.push(...c);for(let e=1+i.length;e<s.shape.length;++e)u.push([0,0]);const d=[];const p=padV2({inputs:{x:s},backend:o,attrs:{paddings:u,constantValue:0}});const h=a.getReshaped(p.shape,i,l,false);const f=a.getPermuted(h.length,i.length,false);const x=a.getReshapedPermuted(p.shape,i,l,false);const m=reshape({inputs:{x:p},backend:o,attrs:{shape:h}});const g=transpose({inputs:{x:m},backend:o,attrs:{perm:f}});const C=reshape({inputs:{x:g},backend:o,attrs:{shape:x}});d.push(p);d.push(m);d.push(g);d.forEach((e=>o.disposeIntermediateTensorInfo(e)));return C};const Nl={kernelName:tn,backendName:"webgl",kernelFunc:spaceToBatchND};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function sparseFillEmptyRows(e){const{inputs:t,backend:n}=e;const{indices:o,values:a,denseShape:r,defaultValue:s}=t;if(r.shape.length!==1)throw new Error(`Dense shape must be a vector, saw:\n         ${r.shape}`);if(o.shape.length!==2)throw new Error(`Indices must be a matrix, saw:\n         ${o.shape}`);if(a.shape.length!==1)throw new Error(`Values must be a vector, saw:\n         ${a.shape}`);if(s.shape.length!==0)throw new Error(`Default value must be a scalar, saw:\n        ${s.shape}`);const i=n.readSync(o.dataId);const c=n.readSync(a.dataId);const l=n.readSync(r.dataId);const u=n.readSync(s.dataId)[0];const[d,p,h,f,x]=Eo(i,o.shape,o.dtype,c,a.dtype,l,u);return[n.makeTensorInfo(p,o.dtype,d),n.makeTensorInfo([p[0]],a.dtype,h),n.makeTensorInfo([f.length],"bool",new Uint8Array(f.map((e=>Number(e))))),n.makeTensorInfo([x.length],o.dtype,new Int32Array(x))]}const El={kernelName:nn,backendName:"webgl",kernelFunc:sparseFillEmptyRows};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function sparseReshape(e){const{inputs:t,backend:n}=e;const{inputIndices:o,inputShape:a,newShape:r}=t;if(o.shape.length!==2)throw new Error(`Input indices should be a matrix but received shape ${o.shape}`);if(a.shape.length!==1)throw new Error(`Input shape should be a vector but received shape ${a.shape}`);if(r.shape.length!==1)throw new Error(`Target shape should be a vector but received shape ${r.shape}`);const s=Array.from(n.readSync(a.dataId));const i=n.readSync(o.dataId);const c=Array.from(n.readSync(r.dataId));const[l,u,d]=Po(i,o.shape,o.dtype,s,c);return[n.makeTensorInfo(u,o.dtype,l),n.makeTensorInfo([d.length],r.dtype,new Int32Array(d))]}const Pl={kernelName:on,backendName:"webgl",kernelFunc:sparseReshape};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function sparseSegmentMean(e){const{inputs:t,backend:n}=e;const{data:o,indices:a,segmentIds:r}=t;if(o.shape.length<1)throw new Error("Data should be at least 1 dimensional but received scalar");if(a.shape.length!==1)throw new Error(`Indices should be a vector but received shape\n              ${a.shape}`);if(r.shape.length!==1)throw new Error(`Segment ids should be a vector but received shape\n              ${r.shape}`);const s=n.readSync(o.dataId);const i=n.readSync(a.dataId);const c=n.readSync(r.dataId);const[l,u]=Ao(s,o.shape,o.dtype,i,c,true);return n.makeTensorInfo(u,o.dtype,l)}const Al={kernelName:an,backendName:"webgl",kernelFunc:sparseSegmentMean};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function sparseSegmentSum(e){const{inputs:t,backend:n}=e;const{data:o,indices:a,segmentIds:r}=t;if(o.shape.length<1)throw new Error("Data should be at least 1 dimensional but received scalar");if(a.shape.length!==1)throw new Error(`Indices should be a vector but received shape\n             ${a.shape}`);if(r.shape.length!==1)throw new Error(`Segment ids should be a vector but received shape\n             ${r.shape}`);const s=n.readSync(o.dataId);const i=n.readSync(a.dataId);const c=n.readSync(r.dataId);const[l,u]=Ao(s,o.shape,o.dtype,i,c);return n.makeTensorInfo(u,o.dtype,l)}const Ol={kernelName:rn,backendName:"webgl",kernelFunc:sparseSegmentSum};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function sparseToDense(e){const{inputs:t,backend:o,attrs:r}=e;const{sparseIndices:s,sparseValues:i,defaultValue:c}=t;const{outputShape:l}=r;const{sliceRank:u,numUpdates:d,sliceSize:p,strides:h,outputSize:f}=a.calculateShapes(i,s,l);const x=false;if(i.dtype==="string"){const e=o.bufferSync(s);const t=o.bufferSync(i);const a=n.decodeString(o.readSync(c.dataId)[0]);const r=wo(e,t,l,f,p,d,u,h,a,x);return o.makeTensorInfo(l,r.dtype,r.values)}const m=new ScatterProgram(d,u,s.shape.length,i.shape.length,h,[f,1],x);const g=o.runWebGLProgram(m,[i,s,c],i.dtype);const C=reshape({inputs:{x:g},backend:o,attrs:{shape:l}});o.disposeIntermediateTensorInfo(g);return C}const Dl={kernelName:sn,backendName:"webgl",kernelFunc:sparseToDense};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function splitV(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s}=t;const{numOrSizeSplits:i,axis:c}=r;const l=n.parseAxisParam(c,s.shape)[0];const u=a.prepareSplitSize(s,i,l);const d=s.shape.length;const p=new Array(d).fill(0);const h=s.shape.slice();return u.map((e=>{const t=[...h];t[l]=e;const n=slice({inputs:{x:s},backend:o,attrs:{begin:p,size:t}});p[l]+=e;return n}))}const _l={kernelName:cn,backendName:"webgl",kernelFunc:splitV};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Ll="return sqrt(x);";const Bl=unaryKernelFunc({opSnippet:Ll,packedOpSnippet:Ll,cpuKernelImpl:Oo});const Ul={kernelName:ln,backendName:"webgl",kernelFunc:Bl};
/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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
 */const Ml="return x * x;";const Vl=unaryKernelFunc({opSnippet:Ml});const Wl={kernelName:un,backendName:"webgl",kernelFunc:Vl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Gl="return (a - b) * (a - b);";const zl=binaryKernelFunc({opSnippet:Gl,packedOpSnippet:Gl});const Xl={kernelName:dn,backendName:"webgl",kernelFunc:zl};
/**
 * @license
 * Copyright 2023 Google LLC.
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
 */function staticRegexReplace(e){const{inputs:t,backend:n,attrs:o}=e;const{x:r}=t;if(r.dtype!=="string")throw new Error("Input must be of datatype string");const s=n.readSync(r.dataId);const i=a.fromUint8ToStringArray(s);const c=Do(i,"string",o);return n.makeTensorInfo(r.shape,"string",c)}const Hl={kernelName:pn,backendName:"webgl",kernelFunc:staticRegexReplace};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function step({inputs:e,attrs:t,backend:n}){const{x:o}=e;const a=Xo+`\n    return x > 0.0 ? 1.0 : float(${t.alpha});\n  `;const r=new UnaryOpProgram(o.shape,a);return n.runWebGLProgram(r,[o],o.dtype)}const Kl={kernelName:hn,backendName:"webgl",kernelFunc:step};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class StridedSliceProgram{constructor(e,t,n){this.variableNames=["x"];this.outputShape=n;const o=n.length;const a=getCoordsDataType(n.length);const r=getCoordsDataType(n.length);let s="";if(o===1)s="coords * strides + begin";else{let e=0;s=n.map(((t,o)=>{e++;return n.length===1?`coords * strides[${o}] + begin[${o}]`:`coords[${e-1}] * strides[${o}] + begin[${o}]`})).join(",")}this.userCode=`\n      ${a} begin = ${a}(${e});\n      ${a} strides = ${a}(${t});\n\n      void main() {\n        ${r} coords = getOutputCoords();\n        setOutput(getX(${s}));\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function stridedSlice(e){const{inputs:t,backend:o,attrs:a}=e;const{x:r}=t;const{begin:s,end:i,strides:c,beginMask:u,endMask:d,ellipsisMask:p,newAxisMask:h,shrinkAxisMask:f}=a;const{finalShapeSparse:x,finalShape:m,isIdentity:g,sliceDim0:C,isSimpleSlice:b,begin:v,end:$,strides:y}=H.sliceInfo(r.shape,s,i,c,u,d,p,h,f);let I;if(g)I=reshape({inputs:{x:r},backend:o,attrs:{shape:m}});else if(C||b){n.assert(r.shape.length>=1,(()=>`Input must have rank at least 1, got: ${r.shape.length}`));const e=H.computeOutShape(v,$,y);const t=slice({inputs:{x:r},backend:o,attrs:{begin:v,size:e}});I=reshape({inputs:{x:t},backend:o,attrs:{shape:m}});o.disposeIntermediateTensorInfo(t)}else{const e=o.shouldExecuteOnCPU([r]);if(e){const e=o.readSync(r.dataId);const t=l(r.shape,r.dtype,e);const n=_o(x,t,y,v);I=o.makeTensorInfo(m,r.dtype,n.values)}else{const e=new StridedSliceProgram(v,y,x);I=o.runWebGLProgram(e,[r],r.dtype)}}const S=reshape({inputs:{x:I},backend:o,attrs:{shape:m}});o.disposeIntermediateTensorInfo(I);return S}const jl={kernelName:fn,backendName:"webgl",kernelFunc:stridedSlice};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function stringNGrams(e){const{inputs:t,backend:n,attrs:o}=e;const{separator:a,nGramWidths:r,leftPad:s,rightPad:i,padWidth:c,preserveShortSequences:l}=o;const{data:u,dataSplits:d}=t;const p=n.readSync(u.dataId);const h=n.readSync(d.dataId);const[f,x]=Lo(p,h,a,r,s,i,c,l);return[n.makeTensorInfo([f.length],"string",f),n.makeTensorInfo(d.shape,"int32",x)]}const ql={kernelName:xn,backendName:"webgl",kernelFunc:stringNGrams};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function stringSplit(e){const{inputs:t,backend:n,attrs:o}=e;const{skipEmpty:a}=o;const{input:r,delimiter:s}=t;if(r.dtype!=="string")throw new Error("Input must be of datatype string");if(r.shape.length!==1)throw new Error(`Input must be a vector, got shape: ${r.shape}`);if(s.shape.length!==0)throw new Error(`Delimiter must be a scalar, got shape: ${s.shape}`);const i=n.readSync(r.dataId);const c=n.readSync(s.dataId)[0];const[l,u,d]=Bo(i,c,a);const p=u.length;return[n.makeTensorInfo([p,2],"int32",l),n.makeTensorInfo([p],"string",u),n.makeTensorInfo([2],"int32",new Int32Array(d))]}const Yl={kernelName:mn,backendName:"webgl",kernelFunc:stringSplit};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function stringToHashBucketFast(e){const{inputs:t,backend:n,attrs:o}=e;const{numBuckets:a}=o;const{input:r}=t;if(r.dtype!=="string")throw new Error("Input must be of datatype string");if(a<=0)throw new Error("Number of buckets must be at least 1");const s=n.readSync(r.dataId);const i=Uo(s,a);return n.makeTensorInfo(r.shape,"int32",i)}const Ql={kernelName:gn,backendName:"webgl",kernelFunc:stringToHashBucketFast};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const Zl="return tan(x);";const Jl=unaryKernelFunc({opSnippet:Zl});const eu={kernelName:Cn,backendName:"webgl",kernelFunc:Jl};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const tu="\n  float e2x = exp(-2.0 * abs(x));\n  return sign(x) * (1.0 - e2x) / (1.0 + e2x);\n";const nu=unaryKernelFunc({opSnippet:tu});const ou={kernelName:bn,backendName:"webgl",kernelFunc:nu};
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
 */function tensorScatterUpdate(e){const{inputs:t,backend:n,attrs:o}=e;const{tensor:r,indices:s,updates:i}=t;const{}=o;const{sliceRank:c,numUpdates:l,sliceSize:u,strides:d,outputSize:p}=a.calculateShapes(i,s,r.shape);const h=[p/u,u];if(p===0)return n.makeTensorInfo(r.shape,s.dtype);const f=reshape({inputs:{x:s},backend:n,attrs:{shape:[l,c]}});const x=reshape({inputs:{x:i},backend:n,attrs:{shape:[l,u]}});const m=reshape({inputs:{x:r},backend:n,attrs:{shape:h}});const g=new ScatterProgram(l,c,f.shape.length,x.shape.length,d,h,false,true);const C=n.runWebGLProgram(g,[x,f,m],m.dtype);const b=reshape({inputs:{x:C},backend:n,attrs:{shape:r.shape}});n.disposeIntermediateTensorInfo(f);n.disposeIntermediateTensorInfo(x);n.disposeIntermediateTensorInfo(m);n.disposeIntermediateTensorInfo(C);return b}const au={kernelName:vn,backendName:"webgl",kernelFunc:tensorScatterUpdate};
/**
 * @license
 * Copyright 2017 Google LLC. All Rights Reserved.
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
 */class TileProgram{constructor(e,t){this.variableNames=["A"];const n=new Array(e.length);for(let o=0;o<n.length;o++)n[o]=e[o]*t[o];this.outputShape=n;this.rank=n.length;const o=getCoordsDataType(this.rank);const a=getSourceCoords(e);this.userCode=`\n      void main() {\n        ${o} resRC = getOutputCoords();\n        setOutput(getA(${a}));\n      }\n    `}}function getSourceCoords(e){const t=e.length;if(t>5)throw Error(`Tile for rank ${t} is not yet supported`);if(t===1)return`imod(resRC, ${e[0]})`;const n=["resRC.x","resRC.y","resRC.z","resRC.w","resRC.u"];const o=[];for(let t=0;t<e.length;t++)o.push(`imod(${n[t]}, ${e[t]})`);return o.join()}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function tile(e){const{inputs:t,backend:o,attrs:a}=e;const{x:r}=t;const{reps:s}=a;if(r.dtype==="string"||r.shape.length>5){const e=o.readSync(r.dataId);const t=r.dtype==="string"?e.map((e=>n.decodeString(e))):e;const a=l(r.shape,r.dtype,t);const i=Vo(a,s);return o.makeTensorInfo(i.shape,i.dtype,i.values)}const i=new TileProgram(r.shape,s);const c=o.runWebGLProgram(i,[r],r.dtype);return c}const ru={kernelName:$n,backendName:"webgl",kernelFunc:tile};class SwapProgram{
/**
     * @param shape desired output shape (can be larger than input shape, output
     *                                    will be padded with -Infinity)
     */
constructor(e){this.variableNames=["x","indices"];this.customUniforms=[{name:"n",type:"int"},{name:"firstPass",type:"int"},{name:"negativeInf",type:"float"},{name:"dir",type:"int"},{name:"inc",type:"int"}];this.outputShape=e;this.userCode="\n       void main() {\n         ivec2 coords = getOutputCoords();\n         int batch = coords[0];\n         int elemIdx = coords[1];\n\n         // We compare elements pair-wise within a group of size 2 * inc.\n         // The comparing rule for each group alternates between ascending\n         // and descending. Within each group, we compare each pair at\n         // positions i and i+inc. To decide whether an element at position i\n         // is x0 or x1, we mod it by 2 * inc, if the result is smaller than\n         // inc, it is in the first half of the group, we denote it as x0,\n         // otherwise we denote it as x1.\n         // For example, as shown in the Bitonic top K paper referenced above,\n         // Figure5(a) shows that element[1] is in the\n         // second half of the group when group size is 2, but it is in the\n         // first half of the group when group size is 4.\n\n         bool isFirstInPair = imod(elemIdx, 2 * inc) < inc;\n         int i = isFirstInPair ? elemIdx : elemIdx - inc;\n\n         int i0 = firstPass == 1 ? i : int(getIndices(batch, i));\n         int i1 = firstPass == 1 ? i + inc : int(getIndices(batch, i + inc));\n         float x0 = i0 < n ? getX(batch, i0) : negativeInf;\n         float x1 = i1 < n ? getX(batch, i1) : negativeInf;\n\n         // Denotes which direction indices are in (ascending or descending).\n         bool reverse = imod(elemIdx, 2 * dir) >= dir;\n         bool isGreater = x0 > x1 || (x0 == x1 && i1 > i0);\n         if (reverse == isGreater) { // Elements in opposite order of direction\n           int iTemp = i0;\n           i0 = i1;\n           i1 = iTemp;\n         }\n         if (isFirstInPair) {\n            setOutput(float(i0));\n         } else {\n            setOutput(float(i1));\n         }\n       }\n     "}}class MergeProgram{
/**
     * @param shape desired output shape (must be half of the input size)
     */
constructor(e){this.variableNames=["x","indices"];this.customUniforms=[{name:"n",type:"int"},{name:"firstPass",type:"int"},{name:"k",type:"int"}];this.outputShape=e;this.userCode="\n    void main() {\n         // Takes max of indices (0, k), (1, k + 1), (2, k + 2) ...\n         ivec2 coords = getOutputCoords();\n         int batch = coords[0];\n         int elemIdx = coords[1];\n\n         // The output size is half of the previous size.\n         // If the previous sequence is | | | | _ _ _ _  | | | |  _ _ _ _ (k=4),\n         // we only need to output the indices at positions |, the indices at\n         // positions _ can be thrown away, see Figure5(b) After Phase 2\n         // (Merge phase) in the Bitonic Top K paper referenced above.\n         // For example, the paper shows we only need to output the orange bars.\n         // The output sequence should look like this | | | | | | | |.\n         // Because the sequence is halved, to map the output index back\n         // to the previous sequence to find the corresponding value,\n         // we need to double the index. When we double the index,\n         // we basically interpolate a position, so 2i looks like\n         // | _ | _ | _ | _ | _ | _ | _. We move the | to the first k position\n         // of each 2k positions by - elemIdx % k. E.g. for output at\n         // index 4,5,6,7, we want to get the corresponding element at\n         // original index 8,9,10,11, for output at index 8,9,10,11,\n         // we want to get the corresponding element at original index\n         // 16,17,18,19, so on and so forth.\n\n         int i = elemIdx < k ? elemIdx : (elemIdx * 2 - imod(elemIdx, k));\n         int i0 = firstPass == 1 ? i : int(getIndices(batch, i));\n         int i1 = firstPass == 1 ? i + k : int(getIndices(batch, i + k));\n\n         float x0 = getX(batch, i0);\n         float x1 = i1 < n ? getX(batch, i1) : x0;\n\n         setOutput(x0 >= x1 ? float(i0) : float(i1));\n       }\n     "}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function disposeIntermediateTensorInfoOrNull(e,t){t!==null&&e.disposeIntermediateTensorInfo(t)}function roundUpToPow2(e){let t=1;while(t<e)t*=2;return t}function topK(e){const{inputs:o,backend:a,attrs:r}=e;const{x:s}=o;const{k:i,sorted:c}=r;const l=t().getNumber("TOPK_LAST_DIM_CPU_HANDOFF_SIZE_THRESHOLD");const u=t().getNumber("TOPK_K_CPU_HANDOFF_THRESHOLD");const d=s.shape;const p=d[d.length-1];if(a.shouldExecuteOnCPU([s])||p<l||i>u){const e=a.readSync(s.dataId);const[t,n]=Wo(e,d,s.dtype,i,c);return[a.makeTensorInfo(t.shape,t.dtype,t.values),a.makeTensorInfo(n.shape,n.dtype,n.values)]}if(i===0){d[d.length-1]=0;return[a.makeTensorInfo(d,s.dtype,[]),a.makeTensorInfo(d,"int32",[])]}if(p===1)return[s,fill({attrs:{shape:d,dtype:"int32",value:0},backend:a})];const h=a.texData.get(s.dataId);const f=h!==null&&h.isPacked;const x=f?a.unpackTensor(s):s;const m=n.sizeFromShape(d);const g=m/p;const C=reshape({inputs:{x:x},attrs:{shape:[g,p]},backend:a});f&&disposeIntermediateTensorInfoOrNull(a,x);const b=roundUpToPow2(i);const v=roundUpToPow2(p);let $=null;const getInputs=()=>$===null?[C,C]:[C,$];const runSwap=(e,t,n)=>{const o=getInputs();const r=new SwapProgram(n);const s=$===null?1:0;const i=[[p],[s],[Number.NEGATIVE_INFINITY],[e],[t]];const c=$;$=a.runWebGLProgram(r,o,"int32",i);disposeIntermediateTensorInfoOrNull(a,c)};for(let e=1;e<b;e*=2){const t=e*2;for(let n=e;n>=1;n/=2)runSwap(t,n,[g,v])}for(let e=v;e>b;e/=2){const t=getInputs();const n=new MergeProgram([g,e/2]);const o=$===null?1:0;const r=[[p],[o],[b]];const s=$;$=a.runWebGLProgram(n,t,"int32",r);disposeIntermediateTensorInfoOrNull(a,s);const i=b/2;const c=i*2;for(let e=i;e>=1;e/=2)runSwap(c,e,$.shape)}let y=$;$=slice({inputs:{x:$},backend:a,attrs:{begin:0,size:[g,i]}});disposeIntermediateTensorInfoOrNull(a,y);let I=gatherV2({inputs:{x:C,indices:$},backend:a,attrs:{axis:1,batchDims:1}});disposeIntermediateTensorInfoOrNull(a,C);const S=d.slice(0,-1);S.push(i);y=$;$=reshape({inputs:{x:$},attrs:{shape:S},backend:a});disposeIntermediateTensorInfoOrNull(a,y);const T=I;I=reshape({inputs:{x:I},attrs:{shape:S},backend:a});disposeIntermediateTensorInfoOrNull(a,T);return[I,$]}const su={kernelName:yn,backendName:"webgl",kernelFunc:topK};
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */class TransformProgram{constructor(e,t,n,o,a,r){this.variableNames=["Image","Transforms"];this.outputShape=r;const s=n==="nearest"?1:2;let i;switch(o){case"constant":i=1;break;case"reflect":i=2;break;case"wrap":i=3;break;case"nearest":i=4;break;default:i=1;break}this.userCode=`\n            float mapCoord(float outCoord, float len) {\n              float inCoord = outCoord;\n              if(${i} == 2) {\n                if (inCoord < 0.0) {\n                  if (len <= 1.0) {\n                    inCoord = 0.0;\n                  } else {\n                    float sz2 = 2.0 * len;\n                    if (inCoord < sz2) {\n                      inCoord = sz2 * float(int(float(-inCoord / sz2))) +\n                      inCoord;\n                    }\n                    inCoord = inCoord < -len ? inCoord + sz2 : -inCoord - 1.0;\n                  }\n                } else if (inCoord > len - 1.0) {\n                  if (len <= 1.0) {\n                    inCoord = 0.0;\n                  } else {\n                    float sz2 = 2.0 * len;\n                    inCoord -= sz2 * float(int(float(inCoord / sz2)));\n                    if (inCoord >= len) {\n                      inCoord = sz2 - inCoord - 1.0;\n                    }\n                  }\n                }\n                return clamp(inCoord, 0.0, len - 1.0);\n              } else if (${i} == 3) {\n                if (inCoord < 0.0) {\n                  if (len <= 1.0) {\n                    inCoord = 0.0;\n                  } else {\n                    float sz = len - 1.0;\n                    inCoord += len * (float(int(float(-inCoord / sz))) + 1.0);\n                  }\n                } else if (inCoord > len - 1.0) {\n                  if (len <= 1.0) {\n                    inCoord = 0.0;\n                  } else {\n                    float sz = len - 1.0;\n                    inCoord -= len * float(int(float(inCoord / sz)));\n                  }\n                }\n                return clamp(inCoord, 0.0, len - 1.0);\n              } else if (${i} == 4) {\n                return clamp(outCoord, 0.0, len - 1.0);\n              } else {\n                return outCoord;\n              }\n            }\n\n            float readWithFillValue(int batch, int coordY, int coordX,\n              int channel) {\n              float outputValue;\n              if (0 <= coordY && coordY < ${e} && 0 <= coordX && coordX < ${t}) {\n                  outputValue = getImage(batch, coordY, coordX, channel);\n              } else {\n                outputValue = float(${a});\n              }\n              return outputValue;\n            }\n\n            void main() {\n              ivec4 coords = getOutputCoords();\n              float outputValue;\n              int batch = coords[0];\n              int x = coords[2];\n              int y = coords[1];\n              int channel = coords[3];\n              float xf = float(x);\n              float yf = float(y);\n              float a1 = getTransforms(batch, 0);\n              float a2 = getTransforms(batch, 1);\n              float a3 = getTransforms(batch, 2);\n              float b1 = getTransforms(batch, 3);\n              float b2 = getTransforms(batch, 4);\n              float b3 = getTransforms(batch, 5);\n              float c1 = getTransforms(batch, 6);\n              float c2 = getTransforms(batch, 7);\n              float projection = c1 * xf + c2 * yf + 1.0;\n              if (projection == 0.0) {\n                outputValue = float(${a});\n              } else {\n                float inX = (a1 * xf + a2 * yf + a3) / projection;\n                float inY = (b1 * xf + b2 * yf + b3) / projection;\n                float mapX = mapCoord(inX, float(${t}));\n                float mapY = mapCoord(inY, float(${e}));\n\n                if (${s} == 1) {\n                  int coordY = int(round(mapY));\n                  int coordX = int(round(mapX));\n                  outputValue = readWithFillValue(batch, coordY, coordX,\n                    channel);\n                } else {\n                  float yFloor = floor(mapY);\n                  float xFloor = floor(mapX);\n                  float yCeil = yFloor + 1.0;\n                  float xCeil = xFloor + 1.0;\n                  float valueYFloor = (xCeil - mapX) *\n                  readWithFillValue(batch, int(yFloor), int(xFloor), channel) +\n                  (mapX - xFloor) *\n                  readWithFillValue(batch, int(yFloor), int(xCeil), channel);\n                  float valueYCeil = (xCeil - mapX) *\n                  readWithFillValue(batch, int(yCeil), int(xFloor), channel) +\n                  (mapX - xFloor) *\n                  readWithFillValue(batch, int(yCeil), int(xCeil), channel);\n                  outputValue = (yCeil - mapY) * valueYFloor +\n                  (mapY - yFloor) * valueYCeil;\n                }\n              }\n              setOutput(outputValue);\n            }\n        `}}
/**
 * @license
 * Copyright 2021 Google LLC. All Rights Reserved.
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
 */function transform(e){const{inputs:t,backend:n,attrs:o}=e;const{image:a,transforms:r}=t;const{interpolation:s,fillMode:i,fillValue:c,outputShape:l}=o;const[u,d,p,h]=a.shape;const[f,x]=l!=null?l:[d,p];const m=[u,f,x,h];const g=new TransformProgram(d,p,s,i,c,m);return n.runWebGLProgram(g,[a,r],"float32")}const iu={kernelName:In,backendName:"webgl",kernelFunc:transform};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the License);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */function unique(e){const{inputs:t,attrs:n,backend:o}=e;const{axis:a}=n;const{x:r}=t;assertNotComplex(r,"unique");console.warn("WARNING: ","UI might be locked temporarily as data is being downloaded");const s=o.readSync(r.dataId);const{outputValues:i,outputShape:c,indices:l}=zo(s,a,r.shape,r.dtype);return[o.makeTensorInfo(c,r.dtype,i),o.makeTensorInfo([l.length],"int32",l)]}const cu={kernelName:Sn,backendName:"webgl",kernelFunc:unique};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function unpack(e){const{inputs:t,backend:n,attrs:o}=e;const{value:a}=t;let{axis:r}=o;r<0&&(r+=a.shape.length);const s=a;const i=s.shape.length;const c=a.shape[r];const l=new Array(i-1);let u=0;for(let e=0;e<i;e++)e!==r&&(l[u++]=s.shape[e]);const d=[];const p=new Array(i).fill(0);const h=s.shape.slice();h[r]=1;const f=new Array(c);for(let e=0;e<f.length;e++){p[r]=e;const t=slice({inputs:{x:s},backend:n,attrs:{begin:p,size:h}});const o=reshape({inputs:{x:t},backend:n,attrs:{shape:l}});f[e]=o;d.push(t)}d.forEach((e=>n.disposeIntermediateTensorInfo(e)));return f}const lu={kernelName:Tn,backendName:"webgl",kernelFunc:unpack};
/**
 * @license
 * Copyright 2018 Google LLC. All Rights Reserved.
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
 */class SegmentOpProgram{constructor(e,t){this.variableNames=["x","segmentIds"];const n=e.windowSize;const o=e.batchSize;const a=e.inSize;const r=e.numSegments;const s=r*Math.ceil(a/n);this.outputShape=[o,s];const i="0.0";const c="sumValue";const l=Math.floor(n/4)*4;const u=n%4;const d="\n        sumValue += dot(values, segFilter);\n    ";let p="";a%n>0&&(p=`\n        if (inIdx < 0 || inIdx >= ${a}) {\n          return initializationValue;\n        }\n      `);let h="";a%n>0&&(h=`\n        if (inIdx < 0 || inIdx >= ${a}) {\n          return -1.0;\n        }\n      `);this.userCode=`\n      const float initializationValue = ${i};\n\n      float getValue(int batch, int inIdx) {\n        ${p}\n        return getX(batch, inIdx);\n      }\n\n      float getSegmentIdAtIndex(int inIdx) {\n        ${h}\n        return getSegmentIds(inIdx);\n      }\n\n      void main() {\n        ivec2 coords = getOutputCoords();\n        int batch = coords[0];\n        int outIdx = coords[1];\n        int inOffset = int(floor(float(outIdx) / float(\n          ${r})) * float(${n}));\n        int currentSeg = int(mod(float(outIdx), float(${r})));\n\n        float sumValue = 0.0;\n\n        for (int i = 0; i < ${l}; i += 4) {\n          int inIdx = inOffset + i;\n          vec4 values = vec4(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            getValue(batch, inIdx + 2),\n            getValue(batch, inIdx + 3)\n          );\n\n          vec4 segFilter = vec4(\n            int(getSegmentIdAtIndex(inIdx)) == currentSeg ? 1 : 0,\n            int(getSegmentIdAtIndex(inIdx + 1)) == currentSeg ? 1 : 0,\n            int(getSegmentIdAtIndex(inIdx + 2)) == currentSeg ? 1 : 0,\n            int(getSegmentIdAtIndex(inIdx + 3)) == currentSeg ? 1 : 0\n          );\n\n          ${d}\n        }\n\n        int inIdx = inOffset + ${l};\n        if (${u===1}) {\n          vec4 values = vec4(\n            getValue(batch, inIdx),\n            initializationValue,\n            initializationValue,\n            initializationValue\n          );\n\n          int inIdxSeg = int(getSegmentIdAtIndex(inIdx));\n\n          vec4 segFilter = vec4(\n            int(getSegmentIdAtIndex(inIdx)) == currentSeg ? 1 : 0,\n            0,\n            0,\n            0\n          );\n\n          ${d}\n        } else if (${u===2}) {\n          vec4 values = vec4(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            initializationValue,\n            initializationValue\n          );\n\n          vec4 segFilter = vec4(\n            int(getSegmentIdAtIndex(inIdx)) == currentSeg ? 1 : 0,\n            int(getSegmentIdAtIndex(inIdx + 1)) == currentSeg ? 1 : 0,\n              0,\n              0\n          );\n\n          ${d}\n        } else if (${u===3}) {\n          vec4 values = vec4(\n            getValue(batch, inIdx),\n            getValue(batch, inIdx + 1),\n            getValue(batch, inIdx + 2),\n            initializationValue\n          );\n\n          vec4 segFilter = vec4(\n            int(getSegmentIdAtIndex(inIdx)) == currentSeg ? 1 : 0,\n            int(getSegmentIdAtIndex(inIdx + 1)) == currentSeg ? 1 : 0,\n            int(getSegmentIdAtIndex(inIdx + 2)) == currentSeg ? 1 : 0,\n            0\n          );\n\n          ${d}\n        }\n        setOutput(${c});\n      }\n    `}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */function unsortedSegmentSum(e){const{inputs:t,backend:o,attrs:r}=e;const{x:s,segmentIds:i}=t;const{numSegments:c}=r;const l=s.shape.length;const u=[];let d=0;const p=a.getAxesPermutation([d],l);let h=s;if(p!=null){h=transpose({inputs:{x:s},backend:o,attrs:{perm:p}});u.push(h);d=a.getInnerMostAxes(1,l)[0]}const f=a.segment_util.computeOutShape(h.shape,d,c);const x=n.sizeFromShape([h.shape[d]]);const m=reshape({inputs:{x:h},backend:o,attrs:{shape:[-1,x]}});u.push(m);const g=$(s.dtype);const segOpCompute=(e,t,n,r,s)=>{const i=e.shape[0];const c=e.shape[1];const l=a.segment_util.segOpComputeOptimalWindowSize(c,s);const d={windowSize:l,inSize:c,batchSize:i,numSegments:s};const p=new SegmentOpProgram(d,t);const h=o.compileAndRun(p,[e,n],r);u.push(h);if(h.shape[1]===s)return h;const f=range({backend:o,attrs:{start:0,stop:s,step:1,dtype:"float32"}});const x=tile({inputs:{x:f},backend:o,attrs:{reps:[c/l]}});u.push(f);u.push(x);const m=segOpCompute(h,t,x,r,s);return m};const C=segOpCompute(m,"unsortedSegmentSum",i,g,c);const b=reshape({inputs:{x:C},backend:o,attrs:{shape:f}});let v=b;if(p!=null){u.push(b);const e=a.getUndoAxesPermutation(p);v=transpose({inputs:{x:v},backend:o,attrs:{perm:e}})}u.forEach((e=>o.disposeIntermediateTensorInfo(e)));return v}const uu={kernelName:kn,backendName:"webgl",kernelFunc:unsortedSegmentSum};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */const du=[Na,Pa,Da,Ba,Va,Wa,Ga,za,Xa,Ha,qa,Za,tr,rr,cr,lr,ur,dr,pr,hr,fr,gr,Cr,$r,yr,Rr,Er,Pr,xa,Ar,Dr,_r,Lr,Br,Ur,Mr,Vr,Xr,jr,qr,Qr,Zr,Jr,es,ts,ns,os,as,rs,ss,us,hs,gs,vs,Ss,Ts,Rs,Fs,Ns,Es,Os,Bs,Us,Ws,Gs,zs,Xs,qs,Js,fa,ei,Or,oi,si,li,Ca,hi,gi,Ci,yi,Ti,Fi,Pi,_i,Li,Bi,Ui,Gi,zi,Xi,Hi,Ki,ji,qi,Yi,ec,tc,rc,fc,Ta,gc,bc,$c,Ic,Tr,Sc,kc,wc,Rc,Pc,$a,Ac,Oc,Dc,_c,Lc,kr,lc,Mc,zc,jc,ka,qc,Yc,Qc,Zc,Jc,el,ol,sl,il,cl,ll,pl,ml,bl,Il,kl,mr,hc,Fl,Nl,El,Pl,Al,Ol,Dl,_l,Ul,Wl,Xl,Hl,Kl,jl,ql,Yl,Ql,pc,wa,eu,ou,au,ru,su,iu,Ra,cu,lu,uu,Tc];for(const e of du)wn(e);
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
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
 */export{GPGPUContext,MathBackendWebGL,forceHalfFloat,jn as gpgpu_util,setWebGLContext,ua as version_webgl,da as webgl,Un as webgl_util};

