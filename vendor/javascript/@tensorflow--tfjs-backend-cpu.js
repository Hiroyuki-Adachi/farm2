export{MathBackendCPU,version_cpu}from"./base.js";import{Elu as t,util as e,LeakyRelu as n,Prelu as s,Relu as a,Relu6 as o,Reshape as c,broadcast_util as r,buffer as i,BatchMatMul as d,_FusedMatMul as p,Acos as l,Acosh as u,AddN as h,backend_util as f,All as m,Any as k,ArgMax as g,ArgMin as I,Asin as b,Asinh as N,Atan as v,Atan2 as y,Atanh as x,AvgPool as S,AvgPool3D as T,AvgPool3DGrad as F,AvgPoolGrad as M,FusedBatchNorm as A,BatchToSpaceND as w,Bincount as D,BroadcastArgs as z,ClipByValue as W,ComplexAbs as H,Imag as C,Concat as P,TensorBuffer as E,Conv2D as R,Conv2DBackpropFilter as V,Conv2DBackpropInput as B,Conv3D as $,Conv3DBackpropFilterV2 as G,Conv3DBackpropInputV2 as O,Cos as _,Cosh as L,CropAndResize as q,upcastType as U,Cumprod as Z,Cumsum as K,DenseBincount as Y,DepthToSpace as j,DepthwiseConv2dNative as J,DepthwiseConv2dNativeBackpropFilter as Q,DepthwiseConv2dNativeBackpropInput as X,Diag as tt,Dilation2D as et,Dilation2DBackpropFilter as nt,Dilation2DBackpropInput as st,Draw as at,Sum as ot,Einsum as ct,EluGrad as rt,Erf as it,ExpandDims as dt,RealDiv as pt,FFT as lt,Fill as ut,FlipLeftRight as ht,FusedConv2D as ft,FusedDepthwiseConv2D as mt,GatherNd as kt,GatherV2 as gt,IFFT as It,IsFinite as bt,IsInf as Nt,IsNan as vt,LinSpace as yt,Log1p as xt,LogicalAnd as St,LogicalNot as Tt,LogicalOr as Ft,LRN as Mt,LRNGrad as At,Max as wt,MaxPool as Dt,MaxPool3D as zt,MaxPool3DGrad as Wt,MaxPoolGrad as Ht,MaxPoolWithArgmax as Ct,Mean as Pt,Min as Et,MirrorPad as Rt,Mod as Vt,Softmax as Bt,Multinomial as $t,kernel_impls as Gt,NonMaxSuppressionV3 as Ot,NonMaxSuppressionV4 as _t,NonMaxSuppressionV5 as Lt,OneHot as qt,ZerosLike as Ut,OnesLike as Zt,Pack as Kt,PadV2 as Yt,Pow as jt,RaggedGather as Jt,RaggedRange as Qt,RaggedTensorToTensor as Xt,Range as te,Reciprocal as ee,ResizeBilinear as ne,ResizeBilinearGrad as se,ResizeNearestNeighbor as ae,ResizeNearestNeighborGrad as oe,Reverse as ce,RotateWithOffset as re,Round as ie,ScatterNd as de,SearchSorted as pe,Select as le,Selu as ue,Sign as he,Sin as fe,Sinh as me,Softplus as ke,SpaceToBatchND as ge,SparseFillEmptyRows as Ie,SparseReshape as be,SparseSegmentMean as Ne,SparseSegmentSum as ve,SparseToDense as ye,SplitV as xe,Square as Se,Step as Te,slice_util as Fe,StridedSlice as Me,StringNGrams as Ae,StringSplit as we,StringToHashBucketFast as De,Tan as ze,Tanh as We,TensorScatterUpdate as He,Tile as Ce,TopK as Pe,Transform as Ee,Unique as Re,Unpack as Ve,UnsortedSegmentSum as Be,registerKernel as $e}from"@tensorflow/tfjs-core";import{u as Ge,a as Oe,c as _e,i as Le,s as qe,b as Ue,t as Ze,d as Ke,e as Ye,f as je,r as Je,g as Qe,h as Xe,j as tn,k as en,z as nn,m as sn,l as an,n as on,o as cn,p as rn,q as dn,v as pn,w as ln,x as un,y as hn,A as fn,B as mn,C as kn,D as gn,E as In,F as bn,G as Nn,H as vn,I as yn,J as xn,K as Sn,L as Tn,M as Fn,N as Mn,O as An,P as wn,Q as Dn,R as zn,S as Wn,T as Hn,U as Cn,V as Pn,W as En,X as Rn,Y as Vn,Z as Bn,_ as $n,$ as Gn,a0 as On,a1 as _n,a2 as Ln,a3 as qn,a4 as Un,a5 as Zn,a6 as Kn,a7 as Yn,a8 as jn,a9 as Jn,aa as Qn,ab as Xn,ac as ts,ad as es,ae as ns,af as ss,ag as as,ah as os}from"../_/EJ8UOOSH.js";export{ai as shared}from"../_/EJ8UOOSH.js";import*as cs from"seedrandom";
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
 */const rs=Ge(t,(t=>t>=0?t:Math.exp(t)-1));const is={kernelName:t,backendName:"cpu",kernelFunc:rs};
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
 */function leakyRelu(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{alpha:c}=a;Oe([o],"leakyRelu");const r=e.sizeFromShape(o.shape);const i=s.data.get(o.dataId).values;const d=e.getTypedArrayFromDType("float32",r);for(let t=0;t<i.length;t++)d[t]=i[t]<0?c*i[t]:i[t];return s.makeTensorInfo(o.shape,"float32",d)}const ds={kernelName:n,backendName:"cpu",kernelFunc:leakyRelu};
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
 */const ps=_e(((t,e)=>t<0?e*t:t));function prelu(t){const{inputs:e,backend:n}=t;const{x:s,alpha:a}=e;Oe([s,a],"prelu");const o=n.data.get(s.dataId).values;const c=n.data.get(a.dataId).values;const[r,i]=ps(s.shape,a.shape,o,c,"float32");return n.makeTensorInfo(i,"float32",r)}const ls={kernelName:s,backendName:"cpu",kernelFunc:prelu};
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
 */const us=Ge(a,(t=>Math.max(0,t)));const hs={kernelName:a,backendName:"cpu",kernelFunc:us};
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
 */const fs=Ge(o,(t=>Math.min(Math.max(0,t),6)));const ms={kernelName:o,backendName:"cpu",kernelFunc:fs};
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
 */function applyActivation(t,e,n,s,a){if(n==="linear")return Le({inputs:{x:e},backend:t});if(n==="relu")return us({inputs:{x:e},backend:t});if(n==="elu")return rs({inputs:{x:e},backend:t});if(n==="relu6")return fs({inputs:{x:e},backend:t});if(n==="prelu")return prelu({inputs:{x:e,alpha:s},backend:t});if(n==="leakyrelu")return leakyRelu({inputs:{x:e},backend:t,attrs:{alpha:a}});if(n==="sigmoid")return qe({inputs:{x:e},backend:t});throw new Error(`Activation ${n} has not been implemented for the CPU backend.`)}
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
 */function reshape(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{shape:c}=a;const r=e.sizeFromShape(o.shape);const i=e.inferFromImplicitShape(c,r);const d=e.sizeFromShape(i);e.assert(r===d,(()=>`The new shape (${i}) has ${d} elements and the old shape (${o.shape}) has ${r} elements. The new shape and old shape must have the same number of elements.`));s.incRef(o.dataId);const p=s.data.get(o.dataId);if(p.complexTensorInfos!=null){const t=p.complexTensorInfos.real;const e=p.complexTensorInfos.imag;t.shape=i;e.shape=i}return{dataId:o.dataId,shape:i,dtype:o.dtype}}const ks={kernelName:c,backendName:"cpu",kernelFunc:reshape};
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
 */function batchMatMul(t){const{inputs:n,backend:s,attrs:a}=t;const{a:o,b:c}=n;const{transposeA:d,transposeB:p}=a;Oe([o,c],"matMul");const l=o.shape.length;const u=c.shape.length;const h=d?o.shape[l-2]:o.shape[l-1];const f=p?c.shape[u-1]:c.shape[u-2];const m=d?o.shape[l-1]:o.shape[l-2];const k=p?c.shape[u-2]:c.shape[u-1];const g=o.shape.slice(0,-2);const I=c.shape.slice(0,-2);const b=e.sizeFromShape(g);const N=e.sizeFromShape(I);const v=r.assertAndGetBroadcastShape(o.shape.slice(0,-2),c.shape.slice(0,-2));const y=v.concat([m,k]);e.assert(h===f,(()=>`Error in matMul: inner shapes (${h}) and (${f}) of Tensors with shapes ${o.shape} and ${c.shape} and transposeA=${d} and transposeB=${p} must match.`));const x=d?[b,h,m]:[b,m,h];const S=p?[N,k,f]:[N,f,k];const T=reshape({inputs:{x:o},backend:s,attrs:{shape:x}});const F=reshape({inputs:{x:c},backend:s,attrs:{shape:S}});const M=d?T.shape[1]:T.shape[2];const A=d?T.shape[2]:T.shape[1];const w=p?F.shape[1]:F.shape[2];const D=Math.max(b,N);const z=s.data.get(T.dataId).values;const W=s.data.get(F.dataId).values;const H=e.computeStrides(T.shape);const C=e.computeStrides(F.shape);const[P,E,R]=d?[H[0],1,H[1]]:[H[0],H[1],1];const[V,B,$]=p?[1,C[1],C[0]]:[C[1],1,C[0]];const G=A*w;const O=i([D,A,w],T.dtype);const _=O.values;const L=s.blockSize;for(let t=0;t<D;t++){const e=t%b;const n=t%N;for(let s=0;s<A;s+=L){const a=Math.min(s+L,A);for(let o=0;o<w;o+=L){const c=Math.min(o+L,w);for(let r=0;r<M;r+=L){const i=Math.min(r+L,M);for(let d=s;d<a;d++)for(let s=o;s<c;s++){let a=0;for(let t=r;t<i;t++){const o=z[e*P+d*E+t*R];const c=W[t*V+s*B+n*$];a+=o*c}_[t*G+(d*w+s)]+=a}}}}}s.disposeIntermediateTensorInfo(T);s.disposeIntermediateTensorInfo(F);return s.makeTensorInfo(y,O.dtype,O.values)}const gs={kernelName:d,backendName:"cpu",kernelFunc:batchMatMul};
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
 */function _fusedMatMul(t){const{inputs:e,backend:n,attrs:s}=t;const{a:a,b:o,bias:c,preluActivationWeights:r}=e;const{transposeA:i,transposeB:d,activation:p,leakyreluAlpha:l}=s;let u;let h;let f;const m=[];const k=batchMatMul({inputs:{a:a,b:o},attrs:{transposeA:i,transposeB:d},backend:n});u=k;if(c){h=Ue({inputs:{a:u,b:c},backend:n});m.push(u);u=h}if(p){f=applyActivation(n,u,p,r,l);m.push(u);u=f}for(const t of m)n.disposeIntermediateTensorInfo(t);return u}const Is={kernelName:p,backendName:"cpu",kernelFunc:_fusedMatMul};
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
 */const bs=Ge(l,(t=>Math.acos(t)));const Ns={kernelName:l,backendName:"cpu",kernelFunc:bs};
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
 */const vs=Ge(u,(t=>Math.acosh(t)));const ys={kernelName:u,backendName:"cpu",kernelFunc:vs};
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
 */function addN(t){const{inputs:e,backend:n}=t;const s=e;Oe(e,"addN");const a=s.map((t=>n.data.get(t.dataId).values));const o=i(s[0].shape,s[0].dtype);const c=o.values;for(let t=0;t<s.length;t++){const e=a[t];for(let t=0;t<c.length;t++)c[t]+=e[t]}return n.makeTensorInfo(o.shape,o.dtype,o.values)}const xs={kernelName:h,backendName:"cpu",kernelFunc:addN};
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
 */function all(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c,keepDims:r}=a;Oe(o,"all");const i=e.parseAxisParam(c,o.shape);let d=i;const p=f.getAxesPermutation(d,o.shape.length);let l=o;if(p!=null){l=Ze({inputs:{x:o},backend:s,attrs:{perm:p}});d=f.getInnerMostAxes(d.length,o.shape.length)}f.assertAxesAreInnerMostDims("all",d,l.shape.length);const[u,h]=f.computeOutAndReduceShapes(l.shape,d);const m=e.sizeFromShape(h);const k=e.makeZerosTypedArray(e.sizeFromShape(u),l.dtype);const g=s.data.get(l.dataId).values;for(let t=0;t<k.length;++t){const e=t*m;let n=g[e];for(let t=0;t<m;++t){const s=g[e+t];n=n&&s}k[t]=n}p!=null&&s.disposeIntermediateTensorInfo(l);const I=s.makeTensorInfo(u,l.dtype,k);if(r){const t=f.expandShapeToKeepDim(u,i);const e=reshape({inputs:{x:I},backend:s,attrs:{shape:t}});s.disposeIntermediateTensorInfo(I);return e}return I}const Ss={kernelName:m,backendName:"cpu",kernelFunc:all};
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
 */function any(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c,keepDims:r}=a;Oe(o,"any");const i=e.parseAxisParam(c,o.shape);let d=i;const p=f.getAxesPermutation(d,o.shape.length);let l=o;if(p!=null){l=Ze({inputs:{x:o},backend:s,attrs:{perm:p}});d=f.getInnerMostAxes(d.length,o.shape.length)}f.assertAxesAreInnerMostDims("any",d,l.shape.length);const[u,h]=f.computeOutAndReduceShapes(l.shape,d);const m=e.sizeFromShape(h);const k=e.makeZerosTypedArray(e.sizeFromShape(u),l.dtype);const g=s.data.get(l.dataId).values;for(let t=0;t<k.length;++t){const e=t*m;let n=g[e];for(let t=0;t<m;++t){const s=g[e+t];n=n||s}k[t]=n}p!=null&&s.disposeIntermediateTensorInfo(l);const I=s.makeTensorInfo(u,l.dtype,k);if(r){const t=f.expandShapeToKeepDim(u,i);const e=reshape({inputs:{x:I},backend:s,attrs:{shape:t}});s.disposeIntermediateTensorInfo(I);return e}return I}const Ts={kernelName:k,backendName:"cpu",kernelFunc:any};
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
 */function argMax(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c}=a;Oe(o,"argMax");let r=e.parseAxisParam(c,o.shape);const i=f.getAxesPermutation(r,o.shape.length);let d=o;const p=[];if(i!=null){d=Ze({inputs:{x:o},backend:s,attrs:{perm:i}});p.push(d);r=f.getInnerMostAxes(r.length,d.shape.length)}r=[r[0]];f.assertAxesAreInnerMostDims("argMax",r,d.shape.length);const[l,u]=f.computeOutAndReduceShapes(d.shape,r);const h=e.sizeFromShape(l);const m=e.makeZerosTypedArray(h,"int32");const k=e.sizeFromShape(u);const g=s.data.get(d.dataId).values;for(let t=0;t<m.length;++t){const e=t*k;let n=g[e];let s=0;for(let t=0;t<k;++t){const a=g[e+t];if(a>n){n=a;s=t}}m[t]=s}p.forEach((t=>s.disposeIntermediateTensorInfo(t)));return s.makeTensorInfo(l,"int32",m)}const Fs={kernelName:g,backendName:"cpu",kernelFunc:argMax};
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
 */function argMin(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c}=a;Oe(o,"argMin");let r=e.parseAxisParam(c,o.shape);const i=f.getAxesPermutation(r,o.shape.length);let d=o;const p=[];if(i!=null){d=Ze({inputs:{x:o},backend:s,attrs:{perm:i}});p.push(d);r=f.getInnerMostAxes(r.length,d.shape.length)}r=[r[0]];f.assertAxesAreInnerMostDims("argMin",r,d.shape.length);const[l,u]=f.computeOutAndReduceShapes(d.shape,r);const h=e.sizeFromShape(l);const m=e.makeZerosTypedArray(h,"int32");const k=e.sizeFromShape(u);const g=s.data.get(d.dataId).values;for(let t=0;t<m.length;++t){const e=t*k;let n=g[e];let s=0;for(let t=0;t<k;++t){const a=g[e+t];if(a<n){n=a;s=t}}m[t]=s}p.forEach((t=>s.disposeIntermediateTensorInfo(t)));return s.makeTensorInfo(l,"int32",m)}const Ms={kernelName:I,backendName:"cpu",kernelFunc:argMin};
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
 */const As=Ge(b,(t=>Math.asin(t)));const ws={kernelName:b,backendName:"cpu",kernelFunc:As};
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
 */const Ds=Ge(N,(t=>Math.asinh(t)));const zs={kernelName:N,backendName:"cpu",kernelFunc:Ds};
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
 */const Ws=Ge(v,(t=>Math.atan(t)));const Hs={kernelName:v,backendName:"cpu",kernelFunc:Ws};
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
 */const Cs=_e(((t,e)=>Math.atan2(t,e)));const Ps=Ke(y,Cs);const Es={kernelName:y,backendName:"cpu",kernelFunc:Ps};
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
 */const Rs=Ge(x,(t=>Math.atanh(t)));const Vs={kernelName:x,backendName:"cpu",kernelFunc:Rs};
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
 */function pool(t,e,n,s,a,o){const c=a.strideHeight;const r=a.strideWidth;const d=a.dilationHeight;const p=a.dilationWidth;const l=a.effectiveFilterHeight;const u=a.effectiveFilterWidth;const h=a.padInfo.top;const f=a.padInfo.left;const m=o==="max"?Number.NEGATIVE_INFINITY:Number.POSITIVE_INFINITY;const k=i(a.outShape,n);const g=k.values;const I=a.outShape[1]*a.outShape[2]*a.outShape[3];const b=a.outShape[2]*a.outShape[3];const N=a.outShape[3];for(let e=0;e<a.batchSize;++e){const n=e*I;const i=e*s[0];for(let e=0;e<a.inChannels;++e)for(let k=0;k<a.outHeight;++k){const I=k*c-h;const v=Math.max(0,I);const y=Math.min(a.inHeight,l+I);const x=n+k*b;for(let n=0;n<a.outWidth;++n){const c=n*r-f;const l=Math.max(0,c);const h=Math.min(a.inWidth,u+c);let k=m;let I=0;let b=0;for(let n=v;n<y;n+=d){const a=i+n*s[1];for(let n=l;n<h;n+=p){const c=a+n*s[2];const r=t[c+e];if(o==="max"&&r>k)k=r;else if(o==="avg"){I+=r;b++}}if(isNaN(k))break}const S=x+n*N+e;g[S]=o==="avg"?I/b:k}}}return k}function maxPoolPositions(t,e,n,s,a=false,o=false){const c=i(s.outShape,"int32");const r=s.strideHeight;const d=s.strideWidth;const p=s.dilationHeight;const l=s.dilationWidth;const u=s.effectiveFilterHeight;const h=s.effectiveFilterWidth;const f=s.padInfo.top;const m=s.padInfo.left;const k=i(e,n,t);for(let t=0;t<s.batchSize;++t)for(let e=0;e<s.inChannels;++e)for(let n=0;n<s.outHeight;++n){const i=n*r-f;let g=i;while(g<0)g+=p;const I=Math.min(s.inHeight,u+i);for(let r=0;r<s.outWidth;++r){const u=r*d-m;let f=u;while(f<0)f+=l;const b=Math.min(s.inWidth,h+u);let N=Number.NEGATIVE_INFINITY;let v=-1;for(let n=g;n<I;n+=p){const c=n-i;for(let r=f;r<b;r+=l){const i=r-u;const d=k.get(t,n,r,e);if(d>N){N=d;v=a?o?((t*s.inHeight+n)*s.inWidth+r)*s.inChannels+e:(n*s.inWidth+r)*s.inChannels+e:c*h+i}}}c.set(v,t,n,r,e)}}return c}function pool3d(t,e,n,s,a,o){const c=a.strideDepth;const r=a.strideHeight;const d=a.strideWidth;const p=a.dilationDepth;const l=a.dilationHeight;const u=a.dilationWidth;const h=a.effectiveFilterDepth;const f=a.effectiveFilterHeight;const m=a.effectiveFilterWidth;const k=a.padInfo.front;const g=a.padInfo.top;const I=a.padInfo.left;const b=o==="max"?Number.NEGATIVE_INFINITY:Number.POSITIVE_INFINITY;const N=i(a.outShape,n);const v=N.values;const y=a.outShape[1]*a.outShape[2]*a.outShape[3]*a.outShape[4];const x=a.outShape[2]*a.outShape[3]*a.outShape[4];const S=a.outShape[3]*a.outShape[4];const T=a.outShape[4];for(let e=0;e<a.batchSize;++e){const n=e*y;const i=e*s[0];for(let e=0;e<a.inChannels;++e)for(let N=0;N<a.outDepth;++N){const y=N*c-k;let F=y;while(F<0)F+=p;const M=Math.min(a.inDepth,h+y);const A=n+N*x;for(let n=0;n<a.outHeight;++n){const c=n*r-g;let h=c;while(h<0)h+=l;const k=Math.min(a.inHeight,f+c);const N=A+n*S;for(let n=0;n<a.outWidth;++n){const c=n*d-I;let r=c;while(r<0)r+=u;const f=Math.min(a.inWidth,m+c);const g=N+n*T;let y=b;let x=0;let S=0;for(let n=F;n<M;n+=p){const a=i+n*s[1];for(let n=h;n<k;n+=l){const c=a+n*s[2];for(let n=r;n<f;n+=u){const a=c+n*s[3];const r=t[a+e];if(o==="max"&&r>y)y=r;else if(o==="avg"){x+=r;S++}if(isNaN(y))break}if(isNaN(y))break}if(isNaN(y))break}const A=g+e;v[A]=o==="avg"?x/Math.max(S,1):y}}}}return N}function maxPool3dPositions(t,e){const n=i(e.outShape,"int32");const s=e.strideDepth;const a=e.strideHeight;const o=e.strideWidth;const c=e.dilationDepth;const r=e.dilationHeight;const d=e.dilationWidth;const p=e.effectiveFilterDepth;const l=e.effectiveFilterHeight;const u=e.effectiveFilterWidth;const h=e.padInfo.front;const f=e.padInfo.top;const m=e.padInfo.left;for(let i=0;i<e.batchSize;++i)for(let k=0;k<e.inChannels;++k)for(let g=0;g<e.outDepth;++g){const I=g*s-h;let b=I;while(b<0)b+=c;const N=Math.min(e.inDepth,p+I);for(let s=0;s<e.outHeight;++s){const p=s*a-f;let h=p;while(h<0)h+=r;const v=Math.min(e.inHeight,l+p);for(let a=0;a<e.outWidth;++a){const f=a*o-m;let y=f;while(y<0)y+=d;const x=Math.min(e.inWidth,u+f);let S=Number.NEGATIVE_INFINITY;let T=-1;for(let e=b;e<N;e+=c){const n=e-I;for(let s=h;s<v;s+=r){const a=s-p;for(let o=y;o<x;o+=d){const c=o-f;const r=t.get(i,e,s,o,k);if(r>=S){S=r;T=n*l*u+a*l+c}}}}n.set(T,i,g,s,a,k)}}}return n}
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
 */function avgPool(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;Oe(o,"avgPool");const{filterSize:c,strides:r,pad:i,dimRoundingMode:d}=a;const p=1;e.assert(f.eitherStridesOrDilationsAreOne(r,p),(()=>`Error in avgPool: Either strides or dilations must be 1. Got strides ${r} and dilations '${p}'`));const l=f.computePool2DInfo(o.shape,c,r,p,i,d);let u;if(l.filterWidth===1&&l.filterHeight===1&&e.arraysEqual(l.inShape,l.outShape))u=Le({inputs:{x:o},backend:s});else{const t=s.data.get(o.dataId).values;const n=e.computeStrides(o.shape);const a=pool(t,o.shape,o.dtype,n,l,"avg");u=s.makeTensorInfo(l.outShape,o.dtype,a.values)}return u}const Bs={kernelName:S,backendName:"cpu",kernelFunc:avgPool};
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
 */function avgPool3D(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{filterSize:c,strides:r,pad:i,dimRoundingMode:d,dataFormat:p}=a;Oe(o,"avgPool3d");const l=f.computePool3DInfo(o.shape,c,r,1,i,d,p);const u=s.data.get(o.dataId).values;const h=pool3d(u,o.shape,o.dtype,e.computeStrides(o.shape),l,"avg");return s.makeTensorInfo(h.shape,"float32",h.values)}const $s={kernelName:T,backendName:"cpu",kernelFunc:avgPool3D};
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
 */function avgPool3DGrad(t){const{inputs:e,backend:n,attrs:s}=t;const{dy:a,input:o}=e;const{filterSize:c,strides:r,pad:d,dimRoundingMode:p}=s;Oe([a,o],"avgPool3DGrad");const l=f.computePool3DInfo(o.shape,c,r,1,d,p);const u=l.strideDepth;const h=l.strideHeight;const m=l.strideWidth;const k=l.filterDepth;const g=l.filterHeight;const I=l.filterWidth;const b=l.dilationDepth;const N=l.dilationHeight;const v=l.dilationWidth;const y=l.effectiveFilterDepth;const x=l.effectiveFilterHeight;const S=l.effectiveFilterWidth;const T=y-1-l.padInfo.front;const F=S-1-l.padInfo.left;const M=x-1-l.padInfo.top;const A=i(o.shape,"float32");const w=1/(k*g*I);const D=n.bufferSync(a);for(let t=0;t<l.batchSize;++t)for(let e=0;e<l.inChannels;++e)for(let n=0;n<l.inDepth;++n)for(let s=0;s<l.inHeight;++s)for(let a=0;a<l.inWidth;++a){const o=n-T;const c=s-M;const r=a-F;let i=0;for(let n=0;n<y;n+=b){const s=(o+n)/u;if(!(s<0||s>=l.outDepth||Math.floor(s)!==s))for(let n=0;n<x;n+=N){const a=(c+n)/h;if(!(a<0||a>=l.outHeight||Math.floor(a)!==a))for(let n=0;n<S;n+=v){const o=(r+n)/m;if(o<0||o>=l.outWidth||Math.floor(o)!==o)continue;const c=D.get(t,s,a,o,e);i+=c}}}A.set(i*w,t,n,s,a,e)}return n.makeTensorInfo(A.shape,A.dtype,A.values)}const Gs={kernelName:F,backendName:"cpu",kernelFunc:avgPool3DGrad};
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
 */function avgPoolGrad(t){const{inputs:e,backend:n,attrs:s}=t;const{dy:a,input:o}=e;const c=o;Oe([a,o],"avgPoolGrad");const{filterSize:r,strides:d,pad:p}=s;const l=f.computePool2DInfo(c.shape,r,d,1,p);const u=l.strideHeight;const h=l.strideWidth;const m=l.filterHeight;const k=l.filterWidth;const g=l.dilationHeight;const I=l.dilationWidth;const b=l.effectiveFilterHeight;const N=l.effectiveFilterWidth;const v=N-1-l.padInfo.left;const y=b-1-l.padInfo.top;const x=i(c.shape,"float32");const S=1/(m*k);const T=n.data.get(a.dataId).values;const F=i(a.shape,"float32",T);for(let t=0;t<l.batchSize;++t)for(let e=0;e<l.inChannels;++e)for(let n=0;n<l.inHeight;++n)for(let s=0;s<l.inWidth;++s){const a=n-y;const o=s-v;let c=0;for(let n=0;n<b;n+=g){const s=(a+n)/u;if(!(s<0||s>=l.outHeight||Math.floor(s)!==s))for(let n=0;n<N;n+=I){const a=(o+n)/h;if(a<0||a>=l.outWidth||Math.floor(a)!==a)continue;const r=F.get(t,s,a,e);c+=r}}x.set(c*S,t,n,s,e)}return n.makeTensorInfo(x.shape,x.dtype,x.values)}const Os={kernelName:M,backendName:"cpu",kernelFunc:avgPoolGrad};
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
 */function batchNorm(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,scale:c,offset:r,mean:i,variance:d}=n;e.assert(i.shape.length===d.shape.length,(()=>"Batch normalization gradient requires mean and variance to have equal ranks."));e.assert(r==null||i.shape.length===r.shape.length,(()=>"Batch normalization gradient requires mean and offset to have equal ranks."));e.assert(c==null||i.shape.length===c.shape.length,(()=>"Batch normalization gradient requires mean and scale to have equal ranks."));Oe([o,i,d,c,r],"batchNorm");let{varianceEpsilon:p}=a;p==null&&(p=.001);const l=s.data.get(o.dataId).values;const u=s.data.get(i.dataId).values;const h=s.data.get(d.dataId).values;const f=c?s.data.get(c.dataId).values:new Float32Array([1]);const m=r?s.data.get(r.dataId).values:new Float32Array([0]);const k=new Float32Array(l.length);const g=m.length;const I=f.length;const b=h.length;const N=u.length;let v=0;let y=0;let x=0;let S=0;for(let t=0;t<l.length;++t){k[t]=m[v++]+(l[t]-u[y++])*f[x++]/Math.sqrt(h[S++]+p);v>=g&&(v=0);y>=N&&(y=0);x>=I&&(x=0);S>=b&&(S=0)}return s.makeTensorInfo(o.shape,o.dtype,k)}const _s={kernelName:A,backendName:"cpu",kernelFunc:batchNorm};
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
 */function batchToSpaceND(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a}=e;const{blockShape:o,crops:c}=s;Oe([a],"batchToSpaceND");const r=o.reduce(((t,e)=>t*e));const i=f.getReshaped(a.shape,o,r);const d=f.getPermuted(i.length,o.length);const p=f.getReshapedPermuted(a.shape,o,r);const l=f.getSliceBeginCoords(c,o.length);const u=f.getSliceSize(p,c,o.length);const h=reshape({inputs:{x:a},backend:n,attrs:{shape:i}});const m=Ze({inputs:{x:h},backend:n,attrs:{perm:d}});const k=reshape({inputs:{x:m},backend:n,attrs:{shape:p}});const g=Ye({inputs:{x:k},backend:n,attrs:{begin:l,size:u}});n.disposeIntermediateTensorInfo(h);n.disposeIntermediateTensorInfo(m);n.disposeIntermediateTensorInfo(k);return g}const Ls={kernelName:w,backendName:"cpu",kernelFunc:batchToSpaceND};
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
 */function bincount(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a,weights:o}=e;const{size:c}=s;const r=n.data.get(a.dataId).values;const i=n.data.get(o.dataId).values;const d=je(r,i,o.dtype,o.shape,c);return n.makeTensorInfo([c],o.dtype,d)}const qs={kernelName:D,backendName:"cpu",kernelFunc:bincount};
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
 */function broadcastArgs(t){const{inputs:e,backend:n}=t;const{s0:s,s1:a}=e;const o=n.data.get(s.dataId).values;const c=n.data.get(a.dataId).values;const r=f.assertAndGetBroadcastShape(Array.from(o),Array.from(c));return n.makeTensorInfo([r.length],"int32",Int32Array.from(r))}const Us={kernelName:z,backendName:"cpu",kernelFunc:broadcastArgs};
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
 */const Zs=Ge(W,((t,e)=>{const n=e;return t>n.clipValueMax?n.clipValueMax:t<n.clipValueMin?n.clipValueMin:t}));const Ks={kernelName:W,backendName:"cpu",kernelFunc:Zs};
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
 */const complexAbs=t=>{const{x:n}=t.inputs;const s=t.backend;const a=new Float32Array(e.sizeFromShape(n.shape));const o=s.data.get(n.dataId);const c=o.complexTensorInfos.real;const r=o.complexTensorInfos.imag;const i=s.data.get(c.dataId).values;const d=s.data.get(r.dataId).values;for(let t=0;t<i.length;t++){const e=i[t];const n=d[t];a[t]=Math.hypot(e,n)}return s.makeOutput(a,n.shape,"float32")};const Ys={kernelName:H,backendName:"cpu",kernelFunc:complexAbs};
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
 */function imag(t){const{inputs:e,backend:n}=t;const{input:s}=e;const a=n.data.get(s.dataId).complexTensorInfos.imag;const o=n.data.get(a.dataId).values;return n.makeTensorInfo(a.shape,a.dtype,o)}const js={kernelName:C,backendName:"cpu",kernelFunc:imag};
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
 */function concat(t){const{inputs:n,backend:s,attrs:a}=t;const{axis:o}=a;const c=e.parseAxisParam(o,n[0].shape)[0];const r=n.map((t=>t.shape));f.assertParamsConsistent(r,c);let i=f.computeOutShape(n.map((t=>t.shape)),c);if(e.sizeFromShape(i)===0)return s.makeTensorInfo(i,n[0].dtype,[]);const d=n.filter((t=>e.sizeFromShape(t.shape)>0));if(d.length===1)return Le({inputs:{x:d[0]},backend:s});if(d[0].dtype==="complex64"){const t=d.map((t=>Je({inputs:{input:t},backend:s})));const e=d.map((t=>imag({inputs:{input:t},backend:s})));const n=concat({inputs:t,backend:s,attrs:{axis:c}});const a=concat({inputs:e,backend:s,attrs:{axis:c}});const o=Qe({inputs:{real:n,imag:a},backend:s});t.forEach((t=>s.disposeIntermediateTensorInfo(t)));e.forEach((t=>s.disposeIntermediateTensorInfo(t)));s.disposeIntermediateTensorInfo(n);s.disposeIntermediateTensorInfo(a);return o}const p=d.map((t=>{const n=e.sizeFromShape(t.shape.slice(c));const a=[-1,n];return reshape({inputs:{x:t},backend:s,attrs:{shape:a}})}));const l=p.map((t=>({vals:s.data.get(t.dataId).values,shape:t.shape})));i=f.computeOutShape(p.map((t=>t.shape)),1);const u=p[0].shape[0]===1;const h=Xe(l,i,n[0].dtype,u);const m=f.computeOutShape(d.map((t=>t.shape)),c);const k=s.makeTensorInfo(m,n[0].dtype,h);p.forEach((t=>s.disposeIntermediateTensorInfo(t)));return k}const Js={kernelName:P,backendName:"cpu",kernelFunc:concat};
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
 */function conv2D(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,filter:c}=n;const{strides:r,pad:i,dataFormat:d,dilations:p,dimRoundingMode:l}=a;Oe([o,c],"conv2d");const u=f.convertConv2DDataFormat(d);const h=f.computeConv2DInfo(o.shape,c.shape,r,p,i,l,false,u);const m=h.filterHeight;const k=h.filterWidth;const g=h.dilationHeight;const I=h.dilationWidth;const b=h.padInfo.left;const N=h.padInfo.top;const v=h.dataFormat==="channelsLast";const y=new E(h.outShape,o.dtype);const x=e.computeStrides(o.shape);const S=e.computeStrides(c.shape);const T=x[0];const F=v?x[1]:x[2];const M=v?x[2]:1;const A=v?1:x[1];const w=y.strides[0];const D=v?y.strides[1]:y.strides[2];const z=v?y.strides[2]:1;const W=v?1:y.strides[1];const H=s.data.get(o.dataId).values;const C=s.data.get(c.dataId).values;const P=y.values;for(let t=0;t<h.batchSize;++t){const e=t*T;const n=t*w;for(let t=0;t<h.outHeight;++t){const s=n+t*D;const a=t*h.strideHeight-N;for(let t=0;t<m;++t){const n=a+t*g;if(n<0||n>=h.inHeight)continue;const o=t*S[0];const c=e+n*F;for(let t=0;t<h.outWidth;++t){const e=s+t*z;const n=t*h.strideWidth-b;for(let t=0;t<k;++t){const s=n+t*I;if(s<0||s>=h.inWidth)continue;const a=o+t*S[1];const r=c+s*M;let i=a;for(let t=0;t<h.inChannels;++t){const n=H[r+t*A];for(let t=0;t<h.outChannels;++t)P[e+t*W]+=n*C[i+t];i+=h.outChannels}}}}}}return s.makeTensorInfo(y.shape,y.dtype,P)}const Qs={kernelName:R,backendName:"cpu",kernelFunc:conv2D};
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
 */function conv2DBackpropFilter(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a,dy:o}=e;const{strides:c,pad:r,dataFormat:i,dimRoundingMode:d,filterShape:p}=s;Oe([a,o],"conv2dBackpropFilter");const l=f.convertConv2DDataFormat(i);const u=f.computeConv2DInfo(a.shape,p,c,1,r,d,false,l);const{strideHeight:h,strideWidth:m,filterHeight:k,filterWidth:g}=u;const I=u.dataFormat==="channelsLast";const b=new E(u.filterShape,"float32");const N=u.padInfo.left;const v=u.padInfo.top;const y=n.data.get(a.dataId).values;const x=n.data.get(o.dataId).values;const S=new E(a.shape,a.dtype,y);const T=new E(o.shape,o.dtype,x);for(let t=0;t<k;++t){const e=Math.max(0,Math.ceil((v-t)/h));const n=Math.min(u.outHeight,(u.inHeight+v-t)/h);for(let s=0;s<g;++s){const a=Math.max(0,Math.ceil((N-s)/m));const o=Math.min(u.outWidth,(u.inWidth+N-s)/m);for(let c=0;c<u.inChannels;++c)for(let r=0;r<u.outChannels;++r){let i=0;for(let d=0;d<u.batchSize;++d)for(let p=e;p<n;++p){const e=t+p*h-v;for(let t=a;t<o;++t){const n=s+t*m-N;i+=I?S.get(d,e,n,c)*T.get(d,p,t,r):S.get(d,c,e,n)*T.get(d,r,p,t)}}b.set(i,t,s,c,r)}}}return n.makeTensorInfo(b.shape,b.dtype,b.values)}const Xs={kernelName:V,backendName:"cpu",kernelFunc:conv2DBackpropFilter};
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
 */function conv2DBackpropInput(t){const{inputs:n,backend:s,attrs:a}=t;const{dy:o,filter:c}=n;const{inputShape:r,strides:i,pad:d,dataFormat:p,dimRoundingMode:l}=a;Oe([o,c],"conv2dBackpropInput");const u=e.computeStrides(c.shape);const h=e.computeStrides(o.shape);let m=f.convertConv2DDataFormat(p);const k=f.computeConv2DInfo(r,c.shape,i,1,d,l,false,m);const g=new E(k.inShape,"float32");const I=g.values;const b=s.data.get(o.dataId).values;const N=s.data.get(c.dataId).values;const[v,y,x]=u;const{batchSize:S,filterHeight:T,filterWidth:F,inChannels:M,inHeight:A,inWidth:w,outChannels:D,outHeight:z,outWidth:W,strideHeight:H,strideWidth:C}=k;m=k.dataFormat;const P=T-1-k.padInfo.top;const R=F-1-k.padInfo.left;const V=m==="channelsLast";const B=g.strides[0];const $=V?g.strides[1]:g.strides[2];const G=V?g.strides[2]:1;const O=V?1:g.strides[1];const _=h[0];const L=V?h[1]:h[2];const q=V?h[2]:1;const U=V?1:h[1];for(let t=0;t<S;++t)for(let e=0;e<M;++e)for(let n=0;n<A;++n){const s=n-P;const a=Math.max(0,Math.ceil(s/H));const o=Math.min(z,(T+s)/H);for(let c=0;c<w;++c){const r=c-R;const i=Math.max(0,Math.ceil(r/C));const d=Math.min(W,(F+r)/C);let p=0;for(let n=a;n<o;++n){const a=n*H-s;for(let s=i;s<d;++s){const o=s*C-r;const c=_*t+L*n+q*s;const i=v*(T-1-a)+y*(F-1-o)+x*e;for(let t=0;t<D;++t){const e=b[c+U*t];const n=N[i+t];p+=e*n}}}const l=B*t+$*n+G*c+O*e;I[l]=p}}return s.makeTensorInfo(g.shape,g.dtype,g.values)}const ta={kernelName:B,backendName:"cpu",kernelFunc:conv2DBackpropInput};
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
 */function conv3D(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,filter:c}=n;const{strides:r,pad:i,dilations:d}=a;Oe([o,c],"conv3d");const p=f.computeConv3DInfo(o.shape,c.shape,r,d,i);const{filterDepth:l,filterHeight:u,filterWidth:h,dilationDepth:m,dilationHeight:k,dilationWidth:g,padInfo:I}=p;const b=I.front;const N=I.left;const v=I.top;const y=new E(p.outShape,o.dtype);const x=s.data.get(o.dataId).values;const S=s.data.get(c.dataId).values;const T=y.values;const F=e.computeStrides(o.shape);const M=e.computeStrides(c.shape);for(let t=0;t<p.batchSize;++t){const e=t*F[0];const n=t*y.strides[0];for(let t=0;t<p.outDepth;++t){const s=n+t*y.strides[1];const a=t*p.strideDepth-b;for(let t=0;t<l;++t){const n=a+t*m;if(n<0||n>=p.inDepth)continue;const o=t*M[0];const c=e+n*F[1];for(let t=0;t<p.outHeight;++t){const e=s+t*y.strides[2];const n=t*p.strideHeight-v;for(let t=0;t<u;++t){const s=n+t*k;if(s<0||s>=p.inHeight)continue;const a=o+t*M[1];const r=c+s*F[2];for(let t=0;t<p.outWidth;++t){const n=e+t*p.outChannels;const s=t*p.strideWidth-N;for(let t=0;t<h;++t){const e=s+t*g;if(e<0||e>=p.inWidth)continue;const o=a+t*M[2];const c=r+e*p.inChannels;let i=o;for(let t=0;t<p.inChannels;++t){const e=x[c+t];for(let t=0;t<p.outChannels;++t)T[n+t]+=e*S[i+t];i+=p.outChannels}}}}}}}}return s.makeTensorInfo(y.shape,y.dtype,y.values)}const ea={kernelName:$,backendName:"cpu",kernelFunc:conv3D};
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
 */function conv3DBackpropFilterV2(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,dy:c}=n;const{strides:r,pad:i,filterShape:d}=a;Oe([o,c],"conv3dBackpropFilterV2");const p=e.computeStrides(o.shape);const l=e.computeStrides(c.shape);const u=f.computeConv3DInfo(o.shape,d,r,1,i);const h=u.strideDepth;const m=u.strideHeight;const k=u.strideWidth;const g=u.filterDepth;const I=u.filterHeight;const b=u.filterWidth;const N=new E(u.filterShape,"float32");const v=N.values;const[y,x,S,T]=N.strides;const F=s.data.get(c.dataId).values;const[M,A,w,D]=l;const z=s.data.get(o.dataId).values;const[W,H,C,P]=p;const R=u.padInfo.front;const V=u.padInfo.left;const B=u.padInfo.top;for(let t=0;t<g;++t){const e=Math.max(0,Math.ceil((R-t)/h));const n=Math.min(u.outDepth,(u.inDepth+R-t)/h);const s=t*y;for(let a=0;a<I;++a){const o=Math.max(0,Math.ceil((B-a)/m));const c=Math.min(u.outHeight,(u.inHeight+B-a)/m);const r=a*x+s;for(let s=0;s<b;++s){const i=Math.max(0,Math.ceil((V-s)/k));const d=Math.min(u.outWidth,(u.inWidth+V-s)/k);const p=s*S+r;for(let r=0;r<u.inChannels;++r){const l=r*T+p;for(let p=0;p<u.outChannels;++p){let f=0;for(let l=0;l<u.batchSize;++l){const u=l*W;const g=l*M;for(let l=e;l<n;++l){const e=t+l*h-R;const n=e*H+u;const I=l*A+g;for(let t=o;t<c;++t){const e=a+t*m-B;const o=e*C+n;const c=t*w+I;for(let t=i;t<d;++t){const e=s+t*k-V;const n=e*P+o;const a=t*D+c;f+=z[n+r]*F[a+p]}}}}v[l+p]=f}}}}}return s.makeTensorInfo(N.shape,N.dtype,N.values)}const na={kernelName:G,backendName:"cpu",kernelFunc:conv3DBackpropFilterV2};
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
 */function conv3DBackpropInputV2(t){const{inputs:n,backend:s,attrs:a}=t;const{dy:o,filter:c}=n;const{pad:r,strides:i,inputShape:d}=a;Oe([o],"conv3dBackpropInputV2");const p=e.computeStrides(o.shape);const l=e.computeStrides(c.shape);const u=f.computeConv3DInfo(d,c.shape,i,1,r);const h=new E(u.inShape,"float32");const m=h.values;const[k,g,I,b]=h.strides;const N=s.data.get(o.dataId).values;const[v,y,x,S]=p;const T=s.data.get(c.dataId).values;const[F,M,A,w]=l;const{batchSize:D,filterDepth:z,filterHeight:W,filterWidth:H,inChannels:C,inDepth:P,inHeight:R,inWidth:V,outChannels:B,outDepth:$,outHeight:G,outWidth:O,strideDepth:_,strideHeight:L,strideWidth:q}=u;const U=z-1-u.padInfo.front;const Z=W-1-u.padInfo.top;const K=H-1-u.padInfo.left;for(let t=0;t<D;++t)for(let e=0;e<C;++e)for(let n=0;n<P;++n){const s=n-U;const a=Math.max(0,Math.ceil(s/_));const o=Math.min($,(z+s)/_);for(let c=0;c<R;++c){const r=c-Z;const i=Math.max(0,Math.ceil(r/L));const d=Math.min(G,(W+r)/L);for(let p=0;p<V;++p){const l=p-K;const u=Math.max(0,Math.ceil(l/q));const h=Math.min(O,(H+l)/q);let f=0;for(let n=a;n<o;++n){const a=n*_-s;for(let s=i;s<d;++s){const o=s*L-r;for(let c=u;c<h;++c){const r=c*q-l;const i=v*t+y*n+x*s+S*c;const d=F*(z-1-a)+M*(W-1-o)+A*(H-1-r)+w*e;for(let t=0;t<B;++t){const e=N[i+t];const n=T[d+t];f+=e*n}}}}m[k*t+g*n+I*c+b*p+e]=f}}}return s.makeTensorInfo(h.shape,h.dtype,h.values)}const sa={kernelName:O,backendName:"cpu",kernelFunc:conv3DBackpropInputV2};
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
 */const aa=Ge(_,(t=>Math.cos(t)));const oa={kernelName:_,backendName:"cpu",kernelFunc:aa};
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
 */const ca=Ge(L,(t=>Math.cosh(t)));const ra={kernelName:L,backendName:"cpu",kernelFunc:ca};
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
 */function cropAndResize(t){const{inputs:n,backend:s,attrs:a}=t;const{image:o,boxes:c,boxInd:r}=n;const{cropSize:d,method:p,extrapolationValue:l}=a;const[u,h,f,m]=o.shape;const k=c.shape[0];const[g,I]=d;const b=i([k,g,I,m],"float32");const N=s.data.get(c.dataId).values;const v=s.data.get(r.dataId).values;const y=s.data.get(o.dataId).values;const x=e.computeStrides(o.shape);const S=e.computeStrides(b.shape);for(let t=0;t<k;t++){const e=t*4;const n=N[e];const s=N[e+1];const a=N[e+2];const o=N[e+3];const c=v[t];if(c>=u)continue;const r=g>1?(a-n)*(h-1)/(g-1):0;const i=I>1?(o-s)*(f-1)/(I-1):0;for(let e=0;e<g;e++){const d=g>1?n*(h-1)+e*r:.5*(n+a)*(h-1);if(d<0||d>h-1)for(let n=0;n<I;n++)for(let s=0;s<m;s++){const a=s+n*S[2]+e*S[1]+t*S[0];b.values[a]=l}else if(p==="bilinear"){const n=Math.floor(d);const a=Math.ceil(d);const r=d-n;for(let d=0;d<I;d++){const p=I>1?s*(f-1)+d*i:.5*(s+o)*(f-1);if(p<0||p>f-1){for(let n=0;n<m;n++){const s=n+d*S[2]+e*S[1]+t*S[0];b.values[s]=l}continue}const u=Math.floor(p);const h=Math.ceil(p);const k=p-u;for(let s=0;s<m;s++){let o=s+u*x[2]+n*x[1]+c*x[0];const i=y[o];o=s+h*x[2]+n*x[1]+c*x[0];const p=y[o];o=s+u*x[2]+a*x[1]+c*x[0];const l=y[o];o=s+h*x[2]+a*x[1]+c*x[0];const f=y[o];const m=i+(p-i)*k;const g=l+(f-l)*k;o=s+d*S[2]+e*S[1]+t*S[0];b.values[o]=m+(g-m)*r}}}else for(let n=0;n<I;++n){const a=I>1?s*(f-1)+n*i:.5*(s+o)*(f-1);if(a<0||a>f-1){for(let s=0;s<m;s++){const a=s+n*S[2]+e*S[1]+t*S[0];b.values[a]=l}continue}const r=Math.round(a);const p=Math.round(d);for(let s=0;s<m;s++){const a=s+r*x[2]+p*x[1]+c*x[0];const o=s+n*S[2]+e*S[1]+t*S[0];b.values[o]=y[a]}}}}return s.makeTensorInfo(b.shape,b.dtype,b.values)}const ia={kernelName:q,backendName:"cpu",kernelFunc:cropAndResize};
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
 */function cumprod(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c,exclusive:r,reverse:i}=a;Oe(o,"cumprod");const d=f.getAxesPermutation([c],o.shape.length);let p=o;d!=null&&(p=Ze({inputs:{x:o},backend:s,attrs:{perm:d}}));const l=f.getInnerMostAxes(1,o.shape.length)[0];if(l!==p.shape.length-1)throw new Error(`backend.cumprod in CPU expects an inner-most axis=${p.shape.length-1} but got axis=${l}`);const u=U(p.dtype,"int32");const h=e.makeOnesTypedArray(e.sizeFromShape(p.shape),u);const m=s.data.get(p.dataId).values;const k=p.shape[p.shape.length-1];const g=i?(t,e)=>t+k-e-1:(t,e)=>t+e;for(let t=0;t<m.length;t+=k)for(let e=0;e<k;e++){const n=g(t,e);if(e===0)h[n]=r?1:m[n];else{const s=g(t,e-1);h[n]=r?m[s]*h[s]:m[n]*h[s]}}const I=s.makeTensorInfo(p.shape,u,h);if(d!=null){const t=f.getUndoAxesPermutation(d);const e=Ze({inputs:{x:I},backend:s,attrs:{perm:t}});s.disposeIntermediateTensorInfo(I);s.disposeIntermediateTensorInfo(p);return e}return I}const da={kernelName:Z,backendName:"cpu",kernelFunc:cumprod};
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
 */function cumsum(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c,exclusive:r,reverse:i}=a;Oe(o,"cumsum");const d=f.getAxesPermutation([c],o.shape.length);let p=o;d!=null&&(p=Ze({inputs:{x:o},backend:s,attrs:{perm:d}}));const l=f.getInnerMostAxes(1,o.shape.length)[0];if(l!==p.shape.length-1)throw new Error(`backend.cumsum in CPU expects an inner-most axis=${p.shape.length-1} but got axis=${l}`);const u=U(p.dtype,"int32");const h=e.makeZerosTypedArray(e.sizeFromShape(p.shape),u);const m=s.data.get(p.dataId).values;const k=p.shape[p.shape.length-1];const g=i?(t,e)=>t+k-e-1:(t,e)=>t+e;for(let t=0;t<m.length;t+=k)for(let e=0;e<k;e++){const n=g(t,e);if(e===0)h[n]=r?0:m[n];else{const s=g(t,e-1);h[n]=r?m[s]+h[s]:m[n]+h[s]}}const I=s.makeTensorInfo(p.shape,u,h);if(d!=null){const t=f.getUndoAxesPermutation(d);const e=Ze({inputs:{x:I},backend:s,attrs:{perm:t}});s.disposeIntermediateTensorInfo(I);s.disposeIntermediateTensorInfo(p);return e}return I}const pa={kernelName:K,backendName:"cpu",kernelFunc:cumsum};
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
 */function denseBincount(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a,weights:o}=e;const{size:c,binaryOutput:r}=s;if(a.shape.length===1){const t=n.data.get(a.dataId).values;const e=n.data.get(o.dataId).values;const s=je(t,e,o.dtype,o.shape,c);return n.makeTensorInfo([c],o.dtype,s)}if(a.shape.length===2){const t=n.bufferSync(a);const e=n.bufferSync(o);const s=tn(t,e,c,r);return n.makeTensorInfo(s.shape,o.dtype,s.values)}throw new Error(`Error in denseBincount: input must be at most rank 2, but got rank${a.shape.length}.`)}const la={kernelName:Y,backendName:"cpu",kernelFunc:denseBincount};
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
 */function depthToSpace(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{blockSize:c,dataFormat:r}=a;e.assert(r==="NHWC",(()=>`Only NHWC dataFormat supported on CPU for depthToSpace. Got ${r}`));const i=o.shape[0];const d=o.shape[1];const p=o.shape[2];const l=o.shape[3];const u=d*c;const h=p*c;const f=l/(c*c);const m=s.data.get(o.dataId).values;const k=new Float32Array(i*u*h*f);let g=0;for(let t=0;t<i;++t)for(let e=0;e<u;++e){const n=Math.floor(e/c);const s=e%c;for(let e=0;e<h;++e){const a=Math.floor(e/c);const o=e%c;const r=(s*c+o)*f;for(let e=0;e<f;++e){const s=e+r;const o=s+l*(a+p*(n+d*t));k[g++]=m[o]}}}return s.makeTensorInfo([i,u,h,f],o.dtype,k)}const ua={kernelName:j,backendName:"cpu",kernelFunc:depthToSpace};
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
 */function depthwiseConv2dNative(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,filter:c}=n;const{strides:r,pad:i,dilations:d,dimRoundingMode:p}=a;Oe([o,c],"depthwiseConv2DNative");const l=e.computeStrides(o.shape);const u=e.computeStrides(c.shape);let h=d;h==null&&(h=[1,1]);e.assert(f.eitherStridesOrDilationsAreOne(r,h),(()=>`Error in depthwiseConv2d: Either strides or dilations must be 1. Got strides ${r} and dilations '${h}'`));const m=f.computeConv2DInfo(o.shape,c.shape,r,h,i,p,true);const{filterHeight:k,filterWidth:g,dilationHeight:I,dilationWidth:b,padInfo:N}=m;const v=N.left;const y=N.top;const x=m.outChannels/m.inChannels;const S=new E(m.outShape,o.dtype);const T=s.data.get(o.dataId).values;const F=s.data.get(c.dataId).values;const M=S.values;for(let t=0;t<m.batchSize;++t){const e=t*l[0];const n=t*S.strides[0];for(let t=0;t<m.outHeight;++t){const s=n+t*S.strides[1];const a=t*m.strideHeight-y;for(let t=0;t<k;++t){const n=a+t*I;if(n<0||n>=m.inHeight)continue;const o=t*u[0];const c=e+n*l[1];for(let t=0;t<m.outWidth;++t){const e=s+t*S.strides[2];const n=t*m.strideWidth-v;for(let t=0;t<g;++t){const s=n+t*b;if(s<0||s>=m.inWidth)continue;const a=o+t*u[1];const r=c+s*m.inChannels;let i=e;let d=a;for(let t=0;t<m.inChannels;++t){const e=T[r+t];for(let t=0;t<x;++t)M[i+t]+=e*F[d+t];i+=x;d+=x}}}}}}return s.makeTensorInfo(S.shape,S.dtype,S.values)}const ha={kernelName:J,backendName:"cpu",kernelFunc:depthwiseConv2dNative};
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
 */function depthwiseConv2dNativeBackpropFilter(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a,dy:o}=e;const{strides:c,dilations:r,pad:i,dimRoundingMode:d,filterShape:p}=s;Oe([a,o],"depthwiseConv2dNativeBackpropFilter");const l=f.computeConv2DInfo(a.shape,p,c,r,i,d,true);const{strideHeight:u,strideWidth:h,filterHeight:m,filterWidth:k}=l;const g=new E(l.filterShape,"float32");const I=l.padInfo.left;const b=l.padInfo.top;const N=l.outChannels/l.inChannels;const v=n.data.get(a.dataId).values;const y=new E(a.shape,a.dtype,v);const x=n.data.get(o.dataId).values;const S=new E(o.shape,o.dtype,x);for(let t=0;t<m;++t){const e=Math.max(0,Math.ceil((b-t)/u));const n=Math.min(l.outHeight,(l.inHeight+b-t)/u);for(let s=0;s<k;++s){const a=Math.max(0,Math.ceil((I-s)/h));const o=Math.min(l.outWidth,(l.inWidth+I-s)/h);for(let c=0;c<l.outChannels;++c){const r=Math.trunc(c/N);const i=c%N;let d=0;for(let i=0;i<l.batchSize;++i)for(let p=e;p<n;++p){const e=t+p*u-b;for(let t=a;t<o;++t){const n=s+t*h-I;d+=y.get(i,e,n,r)*S.get(i,p,t,c)}}g.set(d,t,s,r,i)}}}return n.makeTensorInfo(g.shape,g.dtype,g.values)}const fa={kernelName:Q,backendName:"cpu",kernelFunc:depthwiseConv2dNativeBackpropFilter};
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
 */function depthwiseConv2dNativeBackpropInput(t){const{inputs:n,backend:s,attrs:a}=t;const{dy:o,filter:c}=n;const{strides:r,dilations:i,pad:d,dimRoundingMode:p,inputShape:l}=a;Oe([o,c],"depthwiseConv2DNativeBackpropInput");const u=e.computeStrides(o.shape);const h=e.computeStrides(c.shape);const m=f.computeConv2DInfo(l,c.shape,r,i,d,p,true);const k=new E(m.inShape,"float32");const g=k.values;const[I,b,N]=k.strides;const v=s.data.get(o.dataId).values;const[y,x,S]=u;const T=s.data.get(c.dataId).values;const[F,M,A]=h;const{batchSize:w,filterHeight:D,filterWidth:z,inChannels:W,inHeight:H,inWidth:C,outChannels:P,outHeight:R,outWidth:V,strideHeight:B,strideWidth:$}=m;const G=D-1-m.padInfo.top;const O=z-1-m.padInfo.left;const _=P/W;for(let t=0;t<w;++t)for(let e=0;e<W;++e)for(let n=0;n<H;++n){const s=n-G;const a=Math.max(0,Math.ceil(s/B));const o=Math.min(R,(D+s)/B);for(let c=0;c<C;++c){const r=c-O;const i=Math.max(0,Math.ceil(r/$));const d=Math.min(V,(z+r)/$);let p=0;for(let n=a;n<o;++n){const a=n*B-s;for(let s=i;s<d;++s){const o=s*$-r;const c=y*t+x*n+S*s;const i=F*(D-1-a)+M*(z-1-o)+A*e;for(let t=0;t<_;++t){const n=e*_+t;const s=v[c+n];const a=T[i+t];p+=s*a}}}g[I*t+b*n+N*c+e]=p}}return s.makeTensorInfo(k.shape,k.dtype,k.values)}const ma={kernelName:X,backendName:"cpu",kernelFunc:depthwiseConv2dNativeBackpropInput};
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
 */function diag(t){const{inputs:n,backend:s}=t;const{x:a}=n;const o=e.sizeFromShape(a.shape);const c=s.data.get(a.dataId).values;const r=i([o,o],a.dtype);const d=r.values;for(let t=0;t<c.length;t++)d[t*o+t]=c[t];const p=[...a.shape,...a.shape];return s.makeTensorInfo(p,r.dtype,r.values)}const ka={kernelName:tt,backendName:"cpu",kernelFunc:diag};
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
 */const ga={kernelName:et,backendName:"cpu",kernelFunc:({inputs:t,backend:n,attrs:s})=>{const{x:a,filter:o}=t;const{strides:c,pad:r,dilations:i}=s;const d=n;const p=d.data.get(a.dataId).values;const l=a.shape.length;const u=d.data.get(o.dataId).values;const h=o.shape.length;const{batchSize:m,inHeight:k,inWidth:g,inChannels:I,outHeight:b,outWidth:N,padInfo:v,strideHeight:y,strideWidth:x,filterHeight:S,filterWidth:T,dilationHeight:F,dilationWidth:M,outShape:A}=f.computeDilation2DInfo(a.shape,o.shape,c,r,"NHWC",i);const w=e.sizeFromShape(A);const D=A.length;const z=e.getArrayFromDType(a.dtype,w);for(let t=0;t<m;++t)for(let n=0;n<b;++n){const s=n*y-v.top;for(let c=0;c<N;++c){const r=c*x-v.left;for(let i=0;i<I;++i){let d=Number.MIN_SAFE_INTEGER;for(let n=0;n<S;++n){const c=s+n*F;if(c>=0&&c<k)for(let s=0;s<T;++s){const f=r+s*M;if(f>=0&&f<g){const r=e.locToIndex([t,c,f,i],l,e.computeStrides(a.shape));const m=e.locToIndex([n,s,i],h,e.computeStrides(o.shape));const k=p[r]+u[m];k>d&&(d=k)}}}const f=e.locToIndex([t,n,c,i],D,e.computeStrides(A));z[f]=d}}}const W=d.write(e.toTypedArray(z,a.dtype),A,a.dtype);return{dataId:W,shape:A,dtype:a.dtype}}};
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
 */const Ia={kernelName:nt,backendName:"cpu",kernelFunc:({inputs:t,backend:n,attrs:s})=>{const{x:a,filter:o,dy:c}=t;const{strides:r,pad:i,dilations:d}=s;const p=n;const l=e.toNestedArray(a.shape,p.data.get(a.dataId).values);const u=e.toNestedArray(o.shape,p.data.get(o.dataId).values);const{batchSize:h,inHeight:m,inWidth:k,inChannels:g,outHeight:I,outWidth:b,padInfo:N,strideHeight:v,strideWidth:y,filterHeight:x,filterWidth:S,dilationHeight:T,dilationWidth:F,outShape:M}=f.computeDilation2DInfo(a.shape,o.shape,r,i,"NHWC",d);e.assert(c.rank===M.length,(()=>`Error in ${nt}, dy must have the same rank as output ${M.length}, but got ${c.rank}`));const A=e.toNestedArray(M,p.data.get(c.dataId).values);const w=e.makeZerosNestedTypedArray(o.shape,o.dtype);for(let t=0;t<h;++t)for(let e=0;e<I;++e){const n=e*v-N.top;for(let s=0;s<b;++s){const a=s*y-N.left;for(let o=0;o<g;++o){let c=Number.MIN_SAFE_INTEGER;let r=0;let i=0;for(let e=0;e<x;++e){const s=n+e*T;if(s>=0&&s<m)for(let n=0;n<S;++n){const d=a+n*F;if(d>=0&&d<k){const a=l[t][s][d][o]+u[e][n][o];if(a>c){c=a;r=e;i=n}}}}w[r][i][o]+=A[t][e][s][o]}}}const D=p.write(e.toTypedArray(w,a.dtype),o.shape,o.dtype);return{dataId:D,shape:o.shape,dtype:o.dtype}}};
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
 */const ba={kernelName:st,backendName:"cpu",kernelFunc:({inputs:t,backend:n,attrs:s})=>{const{x:a,filter:o,dy:c}=t;const{strides:r,pad:i,dilations:d}=s;const p=n;const l=e.toNestedArray(a.shape,p.data.get(a.dataId).values);const u=e.toNestedArray(o.shape,p.data.get(o.dataId).values);const{batchSize:h,inHeight:m,inWidth:k,inChannels:g,outHeight:I,outWidth:b,padInfo:N,strideHeight:v,strideWidth:y,filterHeight:x,filterWidth:S,dilationHeight:T,dilationWidth:F,outShape:M}=f.computeDilation2DInfo(a.shape,o.shape,r,i,"NHWC",d);e.assert(c.rank===M.length,(()=>`Error in ${st}, dy must have the same rank as output ${M.length}, but got ${c.rank}`));const A=e.toNestedArray(M,p.data.get(c.dataId).values);const w=e.makeZerosNestedTypedArray(a.shape,a.dtype);for(let t=0;t<h;++t)for(let e=0;e<I;++e){const n=e*v-N.top;for(let s=0;s<b;++s){const a=s*y-N.left;for(let o=0;o<g;++o){let c=Number.MIN_SAFE_INTEGER;let r=n<0?0:n;let i=a<0?0:a;for(let e=0;e<x;++e){const s=n+e*T;if(s>=0&&s<m)for(let n=0;n<S;++n){const d=a+n*F;if(d>=0&&d<k){const a=l[t][s][d][o]+u[e][n][o];if(a>c){c=a;r=s;i=d}}}}w[t][r][i][o]+=A[t][e][s][o]}}}const D=p.write(e.toTypedArray(w,a.dtype),a.shape,a.dtype);return{dataId:D,shape:a.shape,dtype:a.dtype}}};
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
 */function draw(t){const{inputs:e,backend:n,attrs:s}=t;const{image:a}=e;const{canvas:o,options:c}=s;const{contextOptions:r,imageOptions:i}=c||{};const d=(i===null||i===void 0?void 0:i.alpha)||1;const p=(r===null||r===void 0?void 0:r.contextType)||"2d";if(p!=="2d")throw new Error(`Context type ${r.contextType} is not supported by the CPU backend.`);const l=o.getContext(p,(r===null||r===void 0?void 0:r.contextAttributes)||{});if(l==null)throw new Error(`Could not get the context with ${p} type.`);const[u,h]=a.shape.slice(0,2);const f=a.shape.length===2?1:a.shape[2];const m=n.data.get(a.dataId).values;const k=a.dtype==="float32"?255:1;const g=new Uint8ClampedArray(h*u*4);for(let t=0;t<u*h;++t){const e=[0,0,0,255*d];for(let n=0;n<f;n++){const s=m[t*f+n];if(a.dtype==="float32"){if(s<0||s>1)throw new Error(`Tensor values for a float32 Tensor must be in the range [0 - 1] but encountered ${s}.`)}else if(a.dtype==="int32"&&(s<0||s>255))throw new Error(`Tensor values for a int32 Tensor must be in the range [0 - 255] but encountered ${s}.`);if(f===1){e[0]=s*k;e[1]=s*k;e[2]=s*k}else e[n]=s*k}const n=t*4;g[n+0]=Math.round(e[0]);g[n+1]=Math.round(e[1]);g[n+2]=Math.round(e[2]);g[n+3]=Math.round(e[3])}o.width=h;o.height=u;const I=new ImageData(g,h,u);l.putImageData(I,0,0);return a}const Na={kernelName:at,backendName:"cpu",kernelFunc:draw};
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
 */function sum(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c,keepDims:r}=a;Oe(o,"sum");let i;i=o.dtype==="bool"?en({inputs:{x:o},backend:s,attrs:{dtype:"int32"}}):Le({inputs:{x:o},backend:s});const d=i.shape.length;const p=e.parseAxisParam(c,i.shape);const l=f.getAxesPermutation(p,d);let u=p;let h=i;if(l!=null){h=Ze({inputs:{x:i},backend:s,attrs:{perm:l}});u=f.getInnerMostAxes(u.length,d)}f.assertAxesAreInnerMostDims("sum",u,h.shape.length);const[m,k]=f.computeOutAndReduceShapes(h.shape,u);const g=f.upcastType(h.dtype,"int32");let I=nn(s,m,g);const b=e.sizeFromShape(k);const N=s.data.get(I.dataId).values;const v=s.data.get(h.dataId).values;for(let t=0;t<N.length;++t){const e=t*b;let n=0;for(let t=0;t<b;++t)n+=v[e+t];N[t]=n}if(r){const t=f.expandShapeToKeepDim(I.shape,p);const e=I;I=reshape({inputs:{x:I},backend:s,attrs:{shape:t}});s.disposeIntermediateTensorInfo(e)}s.disposeIntermediateTensorInfo(i);l!=null&&s.disposeIntermediateTensorInfo(h);return I}const va={kernelName:ot,backendName:"cpu",kernelFunc:sum};
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
 */function einsum(t){const{inputs:n,backend:s,attrs:a}=t;const{equation:o}=a;const c=n;const{allDims:r,summedDims:i,idDims:d}=f.decodeEinsumEquation(o,c.length);f.checkEinsumDimSizes(r.length,d,c);const{path:p,steps:l}=f.getEinsumComputePath(i,d);const u=l.length;let h=null;let m=r.length;const k=[];for(let t=0;t<u;++t){for(const n of l[t]){const{permutationIndices:t,expandDims:a}=f.getEinsumPermutation(m,d[n]);let o;if(f.isIdentityPermutation(t))o=c[n];else{o=Ze({inputs:{x:c[n]},backend:s,attrs:{perm:t}});k.push(o)}const r=o.shape.slice();for(let t=0;t<a.length;++t)r.splice(a[t],0,1);if(!e.arraysEqual(o.shape,r)){o=reshape({inputs:{x:o},backend:s,attrs:{shape:r}});k.push(o)}if(h===null)h=o;else{h=sn({inputs:{a:o,b:h},backend:s});k.push(h)}}if(t<u-1){if(p[t]>=0){h=sum({inputs:{x:h},backend:s,attrs:{axis:p[t]-(r.length-m),keepDims:false}});k.push(h)}m--}}for(const t of k)t!==h&&s.disposeIntermediateTensorInfo(t);return h}const ya={kernelName:ct,backendName:"cpu",kernelFunc:einsum};
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
 */function eluGrad(t){const{inputs:n,backend:s}=t;const{dy:a,y:o}=n;Oe([a,o],"eluGrad");const c=new Float32Array(e.sizeFromShape(o.shape));const r=s.data.get(o.dataId).values;const i=s.data.get(a.dataId).values;for(let t=0;t<r.length;++t){const e=r[t];c[t]=e>=0?i[t]:i[t]*(e+1)}return s.makeTensorInfo(o.shape,"float32",c)}const xa={kernelName:rt,backendName:"cpu",kernelFunc:eluGrad};
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
 */const Sa=f.ERF_P;const Ta=f.ERF_A1;const Fa=f.ERF_A2;const Ma=f.ERF_A3;const Aa=f.ERF_A4;const wa=f.ERF_A5;const Da=Ge(it,(t=>{const e=Math.sign(t);const n=Math.abs(t);const s=1/(1+Sa*n);return e*(1-((((wa*s+Aa)*s+Ma)*s+Fa)*s+Ta)*s*Math.exp(-n*n))}));const za={kernelName:it,backendName:"cpu",kernelFunc:Da};
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
 */function expandDims(t){const{inputs:n,backend:s,attrs:a}=t;const{input:o}=n;const{dim:c}=a;const r=o.shape.length;const i=o.shape.slice();let d=c;if(c<0){e.assert(-(r+1)<=c,(()=>`Axis must be in the interval [${-(r+1)}, ${r}]`));d=r+c+1}i.splice(d,0,1);return reshape({inputs:{x:o},backend:s,attrs:{shape:i}})}const Wa={kernelName:dt,backendName:"cpu",kernelFunc:expandDims};
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
 */const Ha=_e(((t,e)=>t/e));const Ca=Ke(pt,Ha);const Pa={kernelName:pt,backendName:"cpu",kernelFunc:Ca};
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
 */function fftBatch(t,n,s){const a=t.shape;const o=a[0];const c=a[1];const r=s.data.get(t.dataId);const i=r.complexTensorInfos.real;const d=r.complexTensorInfos.imag;const p=[o,c];const l=e.sizeFromShape(p);const u=e.getTypedArrayFromDType("float32",l);const h=e.getTypedArrayFromDType("float32",l);for(let t=0;t<o;t++){const e=Ye({inputs:{x:i},backend:s,attrs:{begin:[t,0],size:[1,c]}});const a=Ye({inputs:{x:d},backend:s,attrs:{begin:[t,0],size:[1,c]}});const o=Qe({inputs:{real:e,imag:a},backend:s});const{real:r,imag:p}=fftImpl(o,n,s);const l=f.mergeRealAndImagArrays(r,p);for(let e=0;e<c;e++){const n=f.getComplexWithIndex(l,e);u[t*c+e]=n.real;h[t*c+e]=n.imag}s.disposeIntermediateTensorInfo(e);s.disposeIntermediateTensorInfo(a);s.disposeIntermediateTensorInfo(o)}const m=s.makeTensorInfo(p,"float32",u);const k=s.makeTensorInfo(p,"float32",h);const g=Qe({inputs:{real:m,imag:k},backend:s});s.disposeIntermediateTensorInfo(m);s.disposeIntermediateTensorInfo(k);return g}function fftImpl(t,n,s){const a=e.sizeFromShape(t.shape);const o=s.data.get(t.dataId);const c=s.data.get(o.complexTensorInfos.real.dataId).values;const r=s.data.get(o.complexTensorInfos.imag.dataId).values;if(isExponentOf2(a)){const o=fftRadix2(c,r,a,n,s);const i=[t.shape[0],t.shape[1]];if(n){const t=s.makeTensorInfo(i,"float32",o.real);const n=s.makeTensorInfo(i,"float32",o.imag);const c=s.makeTensorInfo([],"float32",e.createScalarValue(a,"float32"));const r=Le({inputs:{x:c},backend:s});const d=Pa.kernelFunc({inputs:{a:t,b:c},backend:s});const p=Pa.kernelFunc({inputs:{a:n,b:r},backend:s});const l=s.data.get(d.dataId).values;const u=s.data.get(p.dataId).values;s.disposeIntermediateTensorInfo(t);s.disposeIntermediateTensorInfo(n);s.disposeIntermediateTensorInfo(c);s.disposeIntermediateTensorInfo(r);s.disposeIntermediateTensorInfo(d);s.disposeIntermediateTensorInfo(p);return{real:l,imag:u}}return o}{const t=f.mergeRealAndImagArrays(c,r);const e=fourierTransformByMatmul(t,a,n);return f.splitRealAndImagArrays(e)}}function isExponentOf2(t){return(t&t-1)===0}function fftRadix2(t,e,n,s,a){if(n===1)return{real:t,imag:e};const o=f.mergeRealAndImagArrays(t,e);const c=n/2;const r=f.complexWithEvenIndex(o);const i=r.real;const d=r.imag;const p=[i.length];const l=a.makeTensorInfo(p,"float32",i);const u=a.makeTensorInfo(p,"float32",d);const h=Qe({inputs:{real:l,imag:u},backend:a});const m=f.complexWithOddIndex(o);const k=m.real;const g=m.imag;const I=[k.length];const b=a.makeTensorInfo(I,"float32",k);const N=a.makeTensorInfo(I,"float32",g);const v=Qe({inputs:{real:b,imag:N},backend:a});const y=fftRadix2(i,d,c,s,a);const x=y.real;const S=y.imag;const T=[x.length];const F=a.makeTensorInfo(T,"float32",x);const M=a.makeTensorInfo(T,"float32",S);const A=Qe({inputs:{real:F,imag:M},backend:a});const w=fftRadix2(k,g,c,s,a);const D=w.real;const z=w.imag;const W=[D.length];const H=a.makeTensorInfo(W,"float32",D);const C=a.makeTensorInfo(W,"float32",z);const P=Qe({inputs:{real:H,imag:C},backend:a});const E=f.exponents(n,s);const R=[E.real.length];const V=a.makeTensorInfo(R,"float32",E.real);const B=a.makeTensorInfo(R,"float32",E.imag);const $=Qe({inputs:{real:V,imag:B},backend:a});const G=sn({inputs:{a:$,b:P},backend:a});const O=Ue({inputs:{a:A,b:G},backend:a});const _=an({inputs:{a:A,b:G},backend:a});const L=Je({inputs:{input:O},backend:a});const q=Je({inputs:{input:_},backend:a});const U=imag({inputs:{input:O},backend:a});const Z=imag({inputs:{input:_},backend:a});const K=concat({inputs:[L,q],backend:a,attrs:{axis:0}});const Y=concat({inputs:[U,Z],backend:a,attrs:{axis:0}});const j=a.data.get(K.dataId).values;const J=a.data.get(Y.dataId).values;a.disposeIntermediateTensorInfo(l);a.disposeIntermediateTensorInfo(u);a.disposeIntermediateTensorInfo(h);a.disposeIntermediateTensorInfo(b);a.disposeIntermediateTensorInfo(N);a.disposeIntermediateTensorInfo(v);a.disposeIntermediateTensorInfo(F);a.disposeIntermediateTensorInfo(M);a.disposeIntermediateTensorInfo(A);a.disposeIntermediateTensorInfo(H);a.disposeIntermediateTensorInfo(C);a.disposeIntermediateTensorInfo(P);a.disposeIntermediateTensorInfo(V);a.disposeIntermediateTensorInfo(B);a.disposeIntermediateTensorInfo($);a.disposeIntermediateTensorInfo(G);a.disposeIntermediateTensorInfo(O);a.disposeIntermediateTensorInfo(_);a.disposeIntermediateTensorInfo(L);a.disposeIntermediateTensorInfo(U);a.disposeIntermediateTensorInfo(q);a.disposeIntermediateTensorInfo(Z);a.disposeIntermediateTensorInfo(K);a.disposeIntermediateTensorInfo(Y);return{real:j,imag:J}}function fourierTransformByMatmul(t,e,n){const s=new Float32Array(e*2);for(let a=0;a<e;a++){let o=0;let c=0;for(let s=0;s<e;s++){const r=f.exponent(a*s,e,n);const i=f.getComplexWithIndex(t,s);o+=i.real*r.real-i.imag*r.imag;c+=i.real*r.imag+i.imag*r.real}if(n){o/=e;c/=e}f.assignToTypedArray(s,o,c,a)}return s}
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
 */function fft(t){const{inputs:n,backend:s}=t;const{input:a}=n;const o=e.sizeFromShape(a.shape);const c=a.shape[a.shape.length-1];const r=o/c;const i=reshape({inputs:{x:a},backend:s,attrs:{shape:[r,c]}});const d=fftBatch(i,false,s);const p=reshape({inputs:{x:d},backend:s,attrs:{shape:a.shape}});s.disposeIntermediateTensorInfo(i);s.disposeIntermediateTensorInfo(d);return p}const Ea={kernelName:lt,backendName:"cpu",kernelFunc:fft};
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
 */function fill(t){const{backend:n,attrs:s}=t;const{shape:a,value:o,dtype:c}=s;const r=c||e.inferDtype(o);const i=e.getArrayFromDType(r,e.sizeFromShape(a));fillValues(i,o,r);return n.makeTensorInfo(a,r,i)}const Ra={kernelName:ut,backendName:"cpu",kernelFunc:fill};function fillValues(t,e,n){n==="string",t.fill(e)}
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
 */const Va={kernelName:ht,backendName:"cpu",kernelFunc:({inputs:t,attrs:n,backend:s})=>{const{image:a}=t;const o=s;const c=e.getTypedArrayFromDType(a.dtype,e.sizeFromShape(a.shape));const[r,i,d,p]=a.shape;const l=o.data.get(a.dataId).values;for(let t=0;t<r;t++){const e=t*d*i*p;for(let t=0;t<i;t++){const n=t*(d*p);for(let t=0;t<d;t++){const s=t*p;for(let a=0;a<p;a++){const o=Math.round(d-t-1);const r=e+n+s+a;let i=l[r];if(o>=0&&o<d){const t=o*p;const s=e+n+t+a;i=l[s]}c[r]=i}}}}const u=o.write(c,a.shape,a.dtype);return{dataId:u,shape:a.shape,dtype:a.dtype}}};
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
 */function fusedConv2D(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a,filter:o,bias:c,preluActivationWeights:r}=e;const{strides:i,pad:d,dataFormat:p,dilations:l,dimRoundingMode:u,activation:h,leakyreluAlpha:f}=s;let m=conv2D({inputs:{x:a,filter:o},backend:n,attrs:{strides:i,pad:d,dataFormat:p,dilations:l,dimRoundingMode:u}});if(c){const t=m;if(p==="NCHW"&&c.shape.length===1&&c.shape[0]!==1){const t=reshape({inputs:{x:c},backend:n,attrs:{shape:[c.shape[0],1,1]}});m=Ue({inputs:{a:m,b:t},backend:n});n.disposeIntermediateTensorInfo(t)}else m=Ue({inputs:{a:m,b:c},backend:n});n.disposeIntermediateTensorInfo(t)}if(h){const t=m;if(p==="NCHW"&&h==="prelu"&&r.shape.length===1&&r.shape[0]!==1){const t=reshape({inputs:{x:r},backend:n,attrs:{shape:[r.shape[0],1,1]}});m=applyActivation(n,m,h,t,f);n.disposeIntermediateTensorInfo(t)}else m=applyActivation(n,m,h,r,f);n.disposeIntermediateTensorInfo(t)}return m}const Ba={kernelName:ft,backendName:"cpu",kernelFunc:fusedConv2D};
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
 */function fusedDepthwiseConv2D(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a,filter:o,bias:c,preluActivationWeights:r}=e;const{strides:i,pad:d,dataFormat:p,dilations:l,dimRoundingMode:u,activation:h,leakyreluAlpha:f}=s;let m=depthwiseConv2dNative({inputs:{x:a,filter:o},backend:n,attrs:{strides:i,pad:d,dataFormat:p,dilations:l,dimRoundingMode:u}});if(c){const t=m;m=Ue({inputs:{a:m,b:c},backend:n});n.disposeIntermediateTensorInfo(t)}if(h){const t=m;m=applyActivation(n,m,h,r,f);n.disposeIntermediateTensorInfo(t)}return m}const $a={kernelName:mt,backendName:"cpu",kernelFunc:fusedDepthwiseConv2D};
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
 */function gatherNd(t){const{inputs:n,backend:s}=t;const{params:a,indices:o}=n;const c=e.sizeFromShape(a.shape);const r=o.shape;const i=r[r.length-1];const[d,p,l,u]=f.prepareAndValidate(a,o);if(p===0)return s.makeTensorInfo(d,a.dtype,[]);const h=s.data.get(o.dataId).values;const m=s.bufferSync(a);const k=on(h,m,a.dtype,p,i,l,u,a.shape,c);return s.makeTensorInfo(d,a.dtype,k.values)}const Ga={kernelName:kt,backendName:"cpu",kernelFunc:gatherNd};
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
 */function gatherV2(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,indices:c}=n;const{axis:r,batchDims:i}=a;Oe([o,c],"gatherV2");const d=e.parseAxisParam(r,o.shape)[0];const p=s.data.get(c.dataId).values;const l=o.shape[d];for(let t=0;t<p.length;++t){const n=p[t];e.assert(n<=l-1&&n>=0,(()=>`GatherV2: the index value ${n} is not in [0, ${l-1}]`))}let u=i;i==null&&(u=0);const h=e.sizeFromShape(c.shape);const m=f.segment_util.collectGatherOpShapeInfo(o,c,d,u);const k=reshape({inputs:{x:o},backend:s,attrs:{shape:[m.batchSize,m.outerSize,m.dimSize,m.sliceSize]}});const g=reshape({inputs:{x:c},backend:s,attrs:{shape:[m.batchSize,h/m.batchSize]}});const I=[m.batchSize,m.outerSize,h/m.batchSize,m.sliceSize];const b=s.bufferSync(g);const N=s.bufferSync(k);const v=cn(N,b,I);s.disposeIntermediateTensorInfo(k);s.disposeIntermediateTensorInfo(g);return s.makeTensorInfo(m.outputShape,v.dtype,v.values)}const Oa={kernelName:gt,backendName:"cpu",kernelFunc:gatherV2};
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
 */function ifft(t){const{inputs:n,backend:s}=t;const{input:a}=n;const o=e.sizeFromShape(a.shape);const c=a.shape[a.shape.length-1];const r=o/c;const i=reshape({inputs:{x:a},backend:s,attrs:{shape:[r,c]}});const d=fftBatch(i,true,s);const p=reshape({inputs:{x:d},backend:s,attrs:{shape:a.shape}});s.disposeIntermediateTensorInfo(i);s.disposeIntermediateTensorInfo(d);return p}const _a={kernelName:It,backendName:"cpu",kernelFunc:ifft};
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
 */const La=Ge(bt,(t=>Number.isFinite(t)?1:0),"bool");const qa={kernelName:bt,backendName:"cpu",kernelFunc:La};
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
 */const Ua=Ge(Nt,(t=>Math.abs(t)===Infinity?1:0),"bool");const Za={kernelName:Nt,backendName:"cpu",kernelFunc:Ua};
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
 */const Ka=Ge(vt,(t=>Number.isNaN(t)?1:0),"bool");const Ya={kernelName:vt,backendName:"cpu",kernelFunc:Ka};
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
 */function linSpace(t){const{backend:e,attrs:n}=t;const{start:s,stop:a,num:o}=n;const c=rn(s,a,o);return e.makeTensorInfo([c.length],"float32",c)}const ja={kernelName:yt,backendName:"cpu",kernelFunc:linSpace};
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
 */const Ja=Ge(xt,(t=>Math.log1p(t)));const Qa={kernelName:xt,backendName:"cpu",kernelFunc:Ja};
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
 */const Xa=_e(((t,e)=>t&&e));const to=Ke(St,Xa,null,"bool");const eo={kernelName:St,backendName:"cpu",kernelFunc:to};
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
 */const no=Ge(Tt,(t=>t?0:1),"bool");const so={kernelName:Tt,backendName:"cpu",kernelFunc:no};
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
 */const ao=_e(((t,e)=>t||e));const oo=Ke(Ft,ao,null,"bool");const co={kernelName:Ft,backendName:"cpu",kernelFunc:oo};
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
 */function lRN(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{depthRadius:c,bias:r,alpha:i,beta:d}=a;Oe(o,"LRN");const p=o.shape[3];const l=p-1;const u=s.data.get(o.dataId).values;const h=e.sizeFromShape(o.shape);const f=new Float32Array(h);function sumAcrossChannels(t){const e=t%p;let n=t-e+Math.max(0,e-c);const s=t-e+Math.min(e+c,l);let a=0;for(;n<=s;n++){const t=u[n];a+=t*t}return a}for(let t=0;t<h;t++){const e=sumAcrossChannels(t);const n=u[t]*Math.pow(r+i*e,-d);f[t]=n}return s.makeTensorInfo(o.shape,o.dtype,f)}const ro={kernelName:Mt,backendName:"cpu",kernelFunc:lRN};
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
 */function lRNGrad(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,y:c,dy:r}=n;const{depthRadius:i,bias:d,alpha:p,beta:l}=a;Oe(r,"LRNGrad");const u=e.sizeFromShape(r.shape);const h=r.shape[3];const f=s.data.get(r.dataId).values;const m=s.data.get(o.dataId).values;const k=s.data.get(c.dataId).values;const g=new Float32Array(u);const I=u;for(let t=0;t<I;t++){const e=t%h;const n=t-e+Math.max(0,e-i);const s=t-e+Math.min(h,e+i+1);let a=0;for(let t=n;t<s;t++)a+=Math.pow(m[t],2);a=p*a+d;for(let e=n;e<s;e++){let n=-2*p*l*m[e]*k[t]/a;t===e&&(n+=Math.pow(a,-l));n*=f[t];g[e]+=n}}return s.makeTensorInfo(r.shape,o.dtype,g)}const io={kernelName:At,backendName:"cpu",kernelFunc:lRNGrad};
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
 */function max(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{reductionIndices:c,keepDims:r}=a;const i=s;let d=o.shape;const p=d.length;const l=e.parseAxisParam(c,d);let u=l;const h=f.getAxesPermutation(u,p);let m=i.data.get(o.dataId).values;if(h!=null){const t=new Array(p);for(let e=0;e<t.length;e++)t[e]=d[h[e]];m=dn(m,d,o.dtype,h,t);u=f.getInnerMostAxes(u.length,p);d=t}Oe(o,"max");f.assertAxesAreInnerMostDims("max",u,p);const[k,g]=f.computeOutAndReduceShapes(d,u);const I=e.sizeFromShape(g);const b=pn(m,I,k,o.dtype);const N=i.write(b,k,o.dtype);let v=k;if(r){const t=f.expandShapeToKeepDim(k,l);v=t}return{dataId:N,shape:v,dtype:o.dtype}}const po={kernelName:wt,backendName:"cpu",kernelFunc:max};
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
 */function maxPool(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;Oe(o,"maxPool");const{filterSize:c,strides:r,pad:i,dimRoundingMode:d}=a;const p=1;e.assert(f.eitherStridesOrDilationsAreOne(r,p),(()=>`Error in maxPool: Either strides or dilations must be 1. Got strides ${r} and dilations '${p}'`));const l=f.computePool2DInfo(o.shape,c,r,p,i,d);let u;if(l.filterWidth===1&&l.filterHeight===1&&e.arraysEqual(l.inShape,l.outShape))u=Le({inputs:{x:o},backend:s});else{const t=s.data.get(o.dataId).values;const n=e.computeStrides(o.shape);const a=pool(t,o.shape,o.dtype,n,l,"max");u=s.makeTensorInfo(l.outShape,o.dtype,a.values)}return u}const lo={kernelName:Dt,backendName:"cpu",kernelFunc:maxPool};
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
 */function maxPool3D(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{filterSize:c,strides:r,pad:i,dimRoundingMode:d,dataFormat:p}=a;Oe(o,"maxPool3d");const l=f.computePool3DInfo(o.shape,c,r,1,i,d,p);const u=s.data.get(o.dataId).values;const h=pool3d(u,o.shape,o.dtype,e.computeStrides(o.shape),l,"max");return s.makeTensorInfo(h.shape,"float32",h.values)}const uo={kernelName:zt,backendName:"cpu",kernelFunc:maxPool3D};
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
 */function maxPool3DGrad(t){const{inputs:e,backend:n,attrs:s}=t;const{dy:a,input:o}=e;const{filterSize:c,strides:r,pad:d,dimRoundingMode:p}=s;Oe([a,o],"maxPool3DGrad");const l=f.computePool3DInfo(o.shape,c,r,1,d,p);const u=n.bufferSync(o);const h=maxPool3dPositions(u,l);const m=l.strideDepth;const k=l.strideHeight;const g=l.strideWidth;const I=l.dilationDepth;const b=l.dilationHeight;const N=l.dilationWidth;const v=l.effectiveFilterDepth;const y=l.effectiveFilterHeight;const x=l.effectiveFilterWidth;const S=v-1-l.padInfo.front;const T=x-1-l.padInfo.left;const F=y-1-l.padInfo.top;const M=i(o.shape,"float32");const A=n.bufferSync(a);for(let t=0;t<l.batchSize;++t)for(let e=0;e<l.inChannels;++e)for(let n=0;n<l.inDepth;++n)for(let s=0;s<l.inHeight;++s)for(let a=0;a<l.inWidth;++a){const o=n-S;const c=s-F;const r=a-T;let i=0;for(let n=0;n<v;n+=I){const s=(o+n)/m;if(!(s<0||s>=l.outDepth||Math.floor(s)!==s))for(let a=0;a<y;a+=b){const o=(c+a)/k;if(!(o<0||o>=l.outHeight||Math.floor(o)!==o))for(let c=0;c<x;c+=N){const d=(r+c)/g;if(d<0||d>=l.outWidth||Math.floor(d)!==d)continue;const p=v*y*x-1-h.get(t,s,o,d,e);const u=n*y*x+a*x+c;const f=p===u?1:0;if(f===0)continue;const m=A.get(t,s,o,d,e);i+=m*f}}}M.set(i,t,n,s,a,e)}return n.makeTensorInfo(M.shape,M.dtype,M.values)}const ho={kernelName:Wt,backendName:"cpu",kernelFunc:maxPool3DGrad};
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
 */function maxPoolGrad(t){const{inputs:e,backend:n,attrs:s}=t;const{dy:a,input:o,output:c}=e;const r=o;Oe([o,c],"maxPoolGrad");const{filterSize:d,strides:p,pad:l,dimRoundingMode:u}=s;const h=f.computePool2DInfo(r.shape,d,p,1,l,u);const m=n.data.get(r.dataId).values;const k=i(h.outShape,r.dtype,maxPoolPositions(m,r.shape,r.dtype,h).values);const g=h.strideHeight;const I=h.strideWidth;const b=h.dilationHeight;const N=h.dilationWidth;const v=h.effectiveFilterHeight;const y=h.effectiveFilterWidth;const x=y-1-h.padInfo.left;const S=v-1-h.padInfo.top;const T=i(r.shape,"float32");const F=n.data.get(a.dataId).values;const M=i(a.shape,"float32",F);for(let t=0;t<h.batchSize;++t)for(let e=0;e<h.inChannels;++e)for(let n=0;n<h.inHeight;++n)for(let s=0;s<h.inWidth;++s){const a=n-S;const o=s-x;let c=0;for(let n=0;n<v;n+=b){const s=(a+n)/g;if(!(s<0||s>=h.outHeight||Math.floor(s)!==s))for(let a=0;a<y;a+=N){const r=(o+a)/I;if(r<0||r>=h.outWidth||Math.floor(r)!==r)continue;const i=v*y-1-k.get(t,s,r,e);const d=n*y+a;const p=i===d?1:0;if(p===0)continue;const l=M.get(t,s,r,e);c+=l*p}}T.set(c,t,n,s,e)}return n.makeTensorInfo(T.shape,T.dtype,T.values)}const fo={kernelName:Ht,backendName:"cpu",kernelFunc:maxPoolGrad};
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
 */function maxPoolWithArgmaxImpl(t,n,s,a,o){const c=e.computeStrides(n);const r=pool(t,n,s,c,o,"max");const i=maxPoolPositions(t,n,s,o,true,a);return[r.values,i.values]}
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
 */const mo={kernelName:Ct,backendName:"cpu",kernelFunc:({inputs:t,attrs:e,backend:n})=>{const{x:s}=t;const{filterSize:a,strides:o,pad:c,includeBatchInIndex:r}=e;const i=n;Oe(s,"MaxPoolWithArgmax");const d=i.data.get(s.dataId).values;const p=f.computePool2DInfo(s.shape,a,o,[1,1],c);const[l,u]=maxPoolWithArgmaxImpl(d,s.shape,s.dtype,r,p);const h=i.write(l,p.outShape,s.dtype);const m=i.write(u,p.outShape,s.dtype);return[{dataId:h,shape:p.outShape,dtype:s.dtype},{dataId:m,shape:p.outShape,dtype:"int32"}]}};
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
 */function mean(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c,keepDims:r}=a;const i=e.parseAxisParam(c,o.shape);const d=f.computeOutAndReduceShapes(o.shape,i);const p=d[1];const l=e.sizeFromShape(p);const u=[];const h=s.makeTensorInfo([],"float32",new Float32Array([l]));u.push(h);const m=en({inputs:{x:o},backend:s,attrs:{dtype:"float32"}});u.push(m);const k=Ca({inputs:{a:m,b:h},backend:s});u.push(k);const g=sum({inputs:{x:k},backend:s,attrs:{axis:c,keepDims:r}});u.forEach((t=>s.disposeIntermediateTensorInfo(t)));return g}const ko={kernelName:Pt,backendName:"cpu",kernelFunc:mean};
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
 */function min(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{axis:c,keepDims:r}=a;Oe(o,"min");const i=e.parseAxisParam(c,o.shape);let d=i;const p=f.getAxesPermutation(d,o.shape.length);let l=o;if(p!=null){l=Ze({inputs:{x:o},backend:s,attrs:{perm:p}});d=f.getInnerMostAxes(d.length,o.shape.length)}f.assertAxesAreInnerMostDims("min",d,l.shape.length);const[u,h]=f.computeOutAndReduceShapes(l.shape,d);const m=e.sizeFromShape(h);const k=e.makeZerosTypedArray(e.sizeFromShape(u),l.dtype);const g=s.data.get(l.dataId).values;for(let t=0;t<k.length;++t){const e=t*m;let n=g[e];for(let t=0;t<m;++t){const s=g[e+t];(Number.isNaN(s)||s<n)&&(n=s)}k[t]=n}p!=null&&s.disposeIntermediateTensorInfo(l);const I=s.makeTensorInfo(u,l.dtype,k);if(r){const t=f.expandShapeToKeepDim(u,i);const e=reshape({inputs:{x:I},backend:s,attrs:{shape:t}});s.disposeIntermediateTensorInfo(I);return e}return I}const go={kernelName:Et,backendName:"cpu",kernelFunc:min};
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
 */function mirrorPad(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{paddings:c,mode:r}=a;Oe(o,"mirrorPad");const i=c.map(((t,e)=>t[0]+o.shape[e]+t[1]));const d=c.map((t=>t[0]));const p=c.map(((t,e)=>t[0]+o.shape[e]));const l=r==="reflect"?0:1;const u=s.data.get(o.dataId).values;const h=o.shape.length;const f=e.computeStrides(o.shape);const m=e.sizeFromShape(i);const k=i.length;const g=e.computeStrides(i);const I=e.getTypedArrayFromDType(o.dtype,m);for(let t=0;t<m;t++){let n=e.indexToLoc(t,k,g);for(let t=0;t<k;t++)n[t]<d[t]?n[t]=d[t]*2-n[t]-l:n[t]>=p[t]&&(n[t]=2*(p[t]-1)-n[t]+l);n=n.map(((t,e)=>t-d[e]));const s=e.locToIndex(n,h,f);I[t]=u[s]}const b=s.write(I,i,o.dtype);return{dataId:b,shape:i,dtype:o.dtype}}const Io={kernelName:Rt,backendName:"cpu",kernelFunc:mirrorPad};
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
 */const bo=_e(((t,e)=>{const n=t%e;return t<0&&e<0||t>=0&&e>=0?n:(n+e)%e}));const No=Ke(Vt,bo);const vo={kernelName:Vt,backendName:"cpu",kernelFunc:No};
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
 */function softmax(t){const{inputs:n,backend:s,attrs:a}=t;const{logits:o}=n;const{dim:c}=a;const r=o.shape.length;let i=c;i===-1&&(i=r-1);if(i!==r-1)throw Error(`Softmax along a non-last dimension is not yet supported. Logits was rank ${r} and dim was ${i}`);const d=e.parseAxisParam([i],o.shape);const p=max({inputs:{x:o},backend:s,attrs:{reductionIndices:d,keepDims:false}});const l=f.expandShapeToKeepDim(p.shape,d);const u=reshape({inputs:{x:p},backend:s,attrs:{shape:l}});const h=an({inputs:{a:o,b:u},backend:s});const m=ln({inputs:{x:h},backend:s});const k=sum({inputs:{x:m},backend:s,attrs:{axis:d,keepDims:false}});const g=reshape({inputs:{x:k},backend:s,attrs:{shape:l}});const I=Ca({inputs:{a:m,b:g},backend:s});s.disposeIntermediateTensorInfo(p);s.disposeIntermediateTensorInfo(u);s.disposeIntermediateTensorInfo(h);s.disposeIntermediateTensorInfo(m);s.disposeIntermediateTensorInfo(k);s.disposeIntermediateTensorInfo(g);return I}const yo={kernelName:Bt,backendName:"cpu",kernelFunc:softmax};
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
 */function multinomial(t){const{inputs:n,backend:s,attrs:a}=t;const{logits:o}=n;const{numSamples:c,seed:r,normalized:i}=a;Oe(o,"multinomial");const d=i?o:softmax({inputs:{logits:o},backend:s,attrs:{dim:-1}});const p=d.shape[0];const l=d.shape[1];const u=s.data.get(d.dataId).values;const h=[p,c];const f=e.makeZerosTypedArray(e.sizeFromShape(h),"int32");for(let t=0;t<p;++t){const e=t*l;const n=new Float32Array(l-1);n[0]=u[e];for(let t=1;t<n.length;++t)n[t]=n[t-1]+u[e+t];const s=cs.alea(r.toString());const a=t*c;for(let t=0;t<c;++t){const e=s();f[a+t]=n.length;for(let s=0;s<n.length;s++)if(e<n[s]){f[a+t]=s;break}}}i||s.disposeIntermediateTensorInfo(d);return s.makeTensorInfo(h,"int32",f)}const xo={kernelName:$t,backendName:"cpu",kernelFunc:multinomial};
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
 */const So=Gt.nonMaxSuppressionV3Impl;function nonMaxSuppressionV3(t){const{inputs:e,backend:n,attrs:s}=t;const{boxes:a,scores:o}=e;const{maxOutputSize:c,iouThreshold:r,scoreThreshold:i}=s;Oe(a,"NonMaxSuppression");const d=n.data.get(a.dataId).values;const p=n.data.get(o.dataId).values;const{selectedIndices:l}=So(d,p,c,r,i);return n.makeTensorInfo([l.length],"int32",new Int32Array(l))}const To={kernelName:Ot,backendName:"cpu",kernelFunc:nonMaxSuppressionV3};
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
 */const Fo=Gt.nonMaxSuppressionV4Impl;function nonMaxSuppressionV4(t){const{inputs:e,backend:n,attrs:s}=t;const{boxes:a,scores:o}=e;const{maxOutputSize:c,iouThreshold:r,scoreThreshold:i,padToMaxOutputSize:d}=s;Oe(a,"NonMaxSuppressionPadded");const p=n.data.get(a.dataId).values;const l=n.data.get(o.dataId).values;const{selectedIndices:u,validOutputs:h}=Fo(p,l,c,r,i,d);return[n.makeTensorInfo([u.length],"int32",new Int32Array(u)),n.makeTensorInfo([],"int32",new Int32Array([h]))]}const Mo={kernelName:_t,backendName:"cpu",kernelFunc:nonMaxSuppressionV4};
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
 */const Ao=Gt.nonMaxSuppressionV5Impl;function nonMaxSuppressionV5(t){const{inputs:e,backend:n,attrs:s}=t;const{boxes:a,scores:o}=e;const{maxOutputSize:c,iouThreshold:r,scoreThreshold:i,softNmsSigma:d}=s;Oe(a,"NonMaxSuppressionWithScore");const p=n.data.get(a.dataId).values;const l=n.data.get(o.dataId).values;const u=c;const h=r;const f=i;const m=d;const{selectedIndices:k,selectedScores:g}=Ao(p,l,u,h,f,m);return[n.makeTensorInfo([k.length],"int32",new Int32Array(k)),n.makeTensorInfo([g.length],"float32",new Float32Array(g))]}const wo={kernelName:Lt,backendName:"cpu",kernelFunc:nonMaxSuppressionV5};
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
 */function oneHot(t){const{inputs:n,backend:s,attrs:a}=t;const{indices:o}=n;const{dtype:c,depth:r,onValue:i,offValue:d}=a;Oe(o,"oneHot");const p=e.sizeFromShape(o.shape);const l=new Float32Array(p*r);l.fill(d);const u=s.data.get(o.dataId).values;for(let t=0;t<p;++t)u[t]>=0&&u[t]<r&&(l[t*r+u[t]]=i);return s.makeTensorInfo([...o.shape,r],c,l)}const Do={kernelName:qt,backendName:"cpu",kernelFunc:oneHot};
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
 */function zerosLike(t){const{inputs:e,backend:n}=t;const{x:s}=e;if(s.dtype==="string")throw new Error("zerosLike is not supported for string tensors");if(s.dtype==="complex64"){const t=Je({inputs:{input:s},backend:n});const e=zerosLike({inputs:{x:t},backend:n});const a=imag({inputs:{input:s},backend:n});const o=zerosLike({inputs:{x:a},backend:n});const c=Qe({inputs:{real:e,imag:o},backend:n});n.disposeIntermediateTensorInfo(t);n.disposeIntermediateTensorInfo(e);n.disposeIntermediateTensorInfo(a);n.disposeIntermediateTensorInfo(o);return c}return fill({backend:n,attrs:{shape:s.shape,value:0,dtype:s.dtype}})}const zo={kernelName:Ut,backendName:"cpu",kernelFunc:zerosLike};
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
 */function onesLike(t){const{inputs:e,backend:n}=t;const{x:s}=e;if(s.dtype==="string")throw new Error("onesLike is not supported for string tensors");if(s.dtype==="complex64"){const t=Je({inputs:{input:s},backend:n});const e=onesLike({inputs:{x:t},backend:n});const a=imag({inputs:{input:s},backend:n});const o=zerosLike({inputs:{x:a},backend:n});const c=Qe({inputs:{real:e,imag:o},backend:n});n.disposeIntermediateTensorInfo(t);n.disposeIntermediateTensorInfo(e);n.disposeIntermediateTensorInfo(a);n.disposeIntermediateTensorInfo(o);return c}return fill({backend:n,attrs:{shape:s.shape,value:1,dtype:s.dtype}})}const Wo={kernelName:Zt,backendName:"cpu",kernelFunc:onesLike};
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
 */function pack(t){const{inputs:n,backend:s,attrs:a}=t;const{axis:o}=a;if(n.length===1)return expandDims({inputs:{input:n[0]},backend:s,attrs:{dim:o}});const c=n[0].shape;const r=n[0].dtype;n.forEach((t=>{e.assertShapesMatch(c,t.shape,"All tensors passed to stack must have matching shapes");e.assert(r===t.dtype,(()=>"All tensors passed to stack must have matching dtypes"))}));const i=[];const d=n.map((t=>{const e=expandDims({inputs:{input:t},backend:s,attrs:{dim:o}});i.push(e);return e}));const p=concat({inputs:d,backend:s,attrs:{axis:o}});i.forEach((t=>s.disposeIntermediateTensorInfo(t)));return p}const Ho={kernelName:Kt,backendName:"cpu",kernelFunc:pack};
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
 */function padV2(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{paddings:c,constantValue:r}=a;Oe(o,"pad");const i=c.map(((t,e)=>t[0]+o.shape[e]+t[1]));const d=c.map((t=>t[0]));const p=s.data.get(o.dataId).values;const l=e.sizeFromShape(o.shape);const u=o.shape.length;const h=e.computeStrides(o.shape);const f=e.sizeFromShape(i);const m=i.length;const k=e.computeStrides(i);const g=e.getTypedArrayFromDType(o.dtype,f);r!==0&&g.fill(r);for(let t=0;t<l;t++){const n=e.indexToLoc(t,u,h);const s=n.map(((t,e)=>t+d[e]));const a=e.locToIndex(s,m,k);g[a]=p[t]}const I=s.write(g,i,o.dtype);return{dataId:I,shape:i,dtype:o.dtype}}const Co={kernelName:Yt,backendName:"cpu",kernelFunc:padV2};
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
 */const Po=_e(((t,e)=>Math.pow(t,e)));const Eo=Ke(jt,Po);const Ro={kernelName:jt,backendName:"cpu",kernelFunc:Eo};
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
 */function raggedGather(t){const{inputs:e,backend:n,attrs:s}=t;const{paramsNestedSplits:a,paramsDenseValues:o,indices:c}=e;const{outputRaggedRank:r}=s;const i=a.map((t=>n.data.get(t.dataId).values));const d=a.map((t=>t.shape));const p=n.data.get(o.dataId).values;const l=n.data.get(c.dataId).values;const[u,h,f]=un(i,d,p,o.shape,o.dtype,l,c.shape,r);const m=u.map((t=>n.makeTensorInfo([t.length],"int32",t)));const k=n.makeTensorInfo(f,o.dtype,h);return m.concat([k])}const Vo={kernelName:Jt,backendName:"cpu",kernelFunc:raggedGather};
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
 */function raggedRange(t){const{inputs:e,backend:n}=t;const{starts:s,limits:a,deltas:o}=e;const c=n.data.get(s.dataId).values;const r=n.data.get(a.dataId).values;const i=n.data.get(o.dataId).values;const[d,p]=hn(c,s.shape,s.dtype,r,a.shape,i,o.shape);const l=n.makeTensorInfo([d.length],"int32",d);const u=n.makeTensorInfo([p.length],s.dtype,p);return[l,u]}const Bo={kernelName:Qt,backendName:"cpu",kernelFunc:raggedRange};
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
 */function raggedTensorToTensor(t){const{inputs:e,backend:n,attrs:s}=t;const{shape:a,values:o,defaultValue:c,rowPartitionTensors:r}=e;const{rowPartitionTypes:i}=s;const d=n.data.get(a.dataId).values;const p=n.data.get(o.dataId).values;const l=n.data.get(c.dataId).values;const u=r.map((t=>n.data.get(t.dataId).values));const h=r.map((t=>t.shape));const[f,m]=fn(d,a.shape,p,o.shape,o.dtype,l,c.shape,u,h,i);return n.makeTensorInfo(f,o.dtype,m)}const $o={kernelName:Xt,backendName:"cpu",kernelFunc:raggedTensorToTensor};
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
 */function range(t){const{backend:e,attrs:n}=t;const{start:s,stop:a,dtype:o,step:c}=n;const r=mn(s,a,c,o);return e.makeTensorInfo([r.length],o,r)}const Go={kernelName:te,backendName:"cpu",kernelFunc:range};
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
 */const Oo=Ge(ee,(t=>1/t));const _o={kernelName:ee,backendName:"cpu",kernelFunc:Oo};
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
 */function resizeBilinear(t){const{inputs:n,backend:s,attrs:a}=t;const{images:o}=n;const{alignCorners:c,halfPixelCenters:r,size:i}=a;Oe(o,"resizeBilinear");const d=e.computeStrides(o.shape);const[p,l]=i;const[u,h,f,m]=o.shape;const k=s.data.get(o.dataId).values;const g=new Float32Array(e.sizeFromShape([u,p,l,m]));const I=[c&&p>1?h-1:h,c&&l>1?f-1:f];const b=[c&&p>1?p-1:p,c&&l>1?l-1:l];let N=0;const v=I[0]/b[0];const y=I[1]/b[1];for(let t=0;t<u;t++)for(let e=0;e<p;e++){let n;n=r?v*(e+.5)-.5:v*e;const s=Math.max(0,Math.floor(n));const a=n-s;const o=Math.min(h-1,Math.ceil(n));const c=t*d[0]+s*d[1];const i=t*d[0]+o*d[1];for(let t=0;t<l;t++){let e;e=r?y*(t+.5)-.5:y*t;const n=Math.max(0,Math.floor(e));const s=e-n;const o=Math.min(f-1,Math.ceil(e));const p=c+n*d[2];const l=i+n*d[2];const u=c+o*d[2];const h=i+o*d[2];for(let t=0;t<m;t++){const e=k[p+t];const n=k[l+t];const o=k[u+t];const c=k[h+t];const r=e+(o-e)*s;const i=n+(c-n)*s;const d=r+(i-r)*a;g[N++]=d}}}return s.makeTensorInfo([u,p,l,m],"float32",g)}const Lo={kernelName:ne,backendName:"cpu",kernelFunc:resizeBilinear};
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
 */function resizeBilinearGrad(t){const{inputs:n,backend:s,attrs:a}=t;const{images:o,dy:c}=n;const{alignCorners:r}=a;Oe([c,o],"resizeBilinearGrad");const i=e.computeStrides(o.shape);const[d,p,l,u]=o.shape;const[,h,f]=c.shape;const m=new Float32Array(d*p*l*u);const k=[r&&h>1?p-1:p,r&&f>1?l-1:l];const g=[r&&h>1?h-1:h,r&&f>1?f-1:f];const I=k[0]/g[0];const b=k[1]/g[1];const N=s.data.get(c.dataId).values;let v=0;for(let t=0;t<d;t++){const e=t*i[0];for(let t=0;t<h;t++){const n=t*I;const s=Math.floor(n);const a=Math.min(Math.ceil(n),p-1);const o=e+s*i[1];const c=e+a*i[1];const r=n-s;const d=1-r;for(let t=0;t<f;t++){const e=t*b;const n=Math.floor(e);const s=Math.min(Math.ceil(e),l-1);const a=e-n;const p=1-a;const h=o+n*i[2];const f=o+s*i[2];const k=c+n*i[2];const g=c+s*i[2];const I=d*p;const y=d*a;const x=r*p;const S=r*a;for(let t=0;t<u;t++){const e=N[v++];m[h+t]+=e*I;m[f+t]+=e*y;m[k+t]+=e*x;m[g+t]+=e*S}}}}return s.makeTensorInfo([d,l,p,u],"float32",m)}const qo={kernelName:se,backendName:"cpu",kernelFunc:resizeBilinearGrad};
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
 */function resizeNearestNeighbor(t){const{inputs:n,backend:s,attrs:a}=t;const{images:o}=n;const{alignCorners:c,halfPixelCenters:r,size:i}=a;Oe(o,"resizeNearestNeighbor");const d=e.computeStrides(o.shape);const[p,l]=i;const[u,h,f,m]=o.shape;const k=s.data.get(o.dataId).values;const g=new Float32Array(u*p*l*m);const I=[c&&p>1?h-1:h,c&&l>1?f-1:f];const b=[c&&p>1?p-1:p,c&&l>1?l-1:l];const N=I[0]/b[0];const v=I[1]/b[1];let y=0;for(let t=0;t<u;t++){const e=t*d[0];for(let t=0;t<p;t++){const n=r?N*(t+.5):N*t;let s=Math.min(h-1,c?Math.round(n):Math.floor(n));r&&(s=Math.max(0,s));const a=e+s*d[1];for(let t=0;t<l;t++){const e=r?v*(t+.5):v*t;let n=Math.min(f-1,c?Math.round(e):Math.floor(e));r&&(n=Math.max(0,n));const s=a+n*d[2];for(let t=0;t<m;t++){const e=k[s+t];g[y++]=e}}}}return s.makeTensorInfo([u,p,l,m],o.dtype,g)}const Uo={kernelName:ae,backendName:"cpu",kernelFunc:resizeNearestNeighbor};
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
 */function resizeNearestNeighborGrad(t){const{inputs:n,backend:s,attrs:a}=t;const{images:o,dy:c}=n;const{alignCorners:r}=a;Oe([c,o],"resizeNearestNeighborGrad");const i=e.computeStrides(o.shape);const d=e.computeStrides(c.shape);const[p,l,u,h]=o.shape;const[,f,m]=c.shape;const k=new Float32Array(p*l*u*h);const g=s.data.get(c.dataId).values;const I=[r&&f>1?l-1:l,r&&m>1?u-1:u];const b=[r&&f>1?f-1:f,r&&m>1?m-1:m];const N=I[0]/b[0];const v=I[1]/b[1];const y=1/N;const x=1/v;const S=Math.ceil(y)*2+2;const T=Math.ceil(x)*2+2;for(let t=0;t<p;t++){const e=t*i[0];for(let t=0;t<l;t++){const n=e+t*i[1];const s=Math.floor(t*y);const a=Math.floor(s-S/2);for(let s=0;s<u;s++){const o=n+s*i[2];const c=Math.floor(s*x);const p=Math.floor(c-T/2);for(let n=0;n<h;n++){let c=0;for(let o=0;o<S;o++){const i=o+a;if(i<0||i>=f)continue;const h=e+i*d[1];const k=i*N;const I=Math.min(l-1,r?Math.round(k):Math.floor(k));if(t===I)for(let t=0;t<T;t++){const e=t+p;if(e<0||e>=m)continue;const a=h+e*d[2];const o=e*v;const i=Math.min(u-1,r?Math.round(o):Math.floor(o));s===i&&(c+=g[a+n])}}k[o+n]=c}}}}return s.makeTensorInfo(o.shape,o.dtype,k)}const Zo={kernelName:oe,backendName:"cpu",kernelFunc:resizeNearestNeighborGrad};
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
 */function reverse(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{dims:c}=a;Oe(o,"reverse");const r=o.shape.length;const i=e.parseAxisParam(c,o.shape);if(r===0)return Le({inputs:{x:o},backend:s});const d=new E(o.shape,o.dtype);const p=s.bufferSync(o);for(let t=0;t<d.size;t++){const e=d.indexToLoc(t);const n=e.slice();i.forEach((t=>n[t]=o.shape[t]-1-n[t]));d.set(p.get(...n),...e)}return s.makeTensorInfo(d.shape,d.dtype,d.values)}const Ko={kernelName:ce,backendName:"cpu",kernelFunc:reverse};
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
 */const Yo={kernelName:re,backendName:"cpu",kernelFunc:({inputs:t,attrs:n,backend:s})=>{const{image:a}=t;const{radians:o,fillValue:c,center:r}=n;const i=s;const d=e.getTypedArrayFromDType(a.dtype,e.sizeFromShape(a.shape));const[p,l,u,h]=a.shape;const[m,k]=f.getImageCenter(r,l,u);const g=255;const I=Math.sin(o);const b=Math.cos(o);const N=i.data.get(a.dataId).values;for(let t=0;t<p;t++){const e=t*u*l*h;for(let t=0;t<l;t++){const n=t*(u*h);for(let s=0;s<u;s++){const a=s*h;for(let o=0;o<h;o++){const r=[p,t,s,o];const i=r[2];const f=r[1];let v=(i-m)*b-(f-k)*I;let y=(i-m)*I+(f-k)*b;v=Math.round(v+m);y=Math.round(y+k);let x=c;typeof c!=="number"&&(x=o===3?g:c[o]);if(v>=0&&v<u&&y>=0&&y<l){const t=y*(u*h);const n=v*h;const s=e+t+n+o;x=N[s]}const S=e+n+a+o;d[S]=x}}}}const v=i.write(d,a.shape,a.dtype);return{dataId:v,shape:a.shape,dtype:a.dtype}}};
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
 */const jo=Ge(ie,(t=>{const e=Math.floor(t);return t-e<.5?Math.floor(t):t-e>.5?Math.ceil(t):e%2===0?e:e+1}));const Jo={kernelName:ie,backendName:"cpu",kernelFunc:jo};
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
 */function scatterNd(t){const{inputs:e,backend:n,attrs:s}=t;const{indices:a,updates:o}=e;const{shape:c}=s;const{sliceRank:r,numUpdates:i,sliceSize:d,strides:p,outputSize:l}=f.calculateShapes(o,a,c);const u=true;const h=n.bufferSync(a);const m=n.bufferSync(o);const k=kn(h,m,c,l,d,i,r,p,0,u);return n.makeTensorInfo(c,k.dtype,k.values)}const Qo={kernelName:de,backendName:"cpu",kernelFunc:scatterNd};
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
 */function lowerBound(t,e){let n=0;let s=t.length;let a=0;while(n<s){a=Math.floor((n+s)/2);t[a]<e?n=a+1:s=a}return s}function upperBound(t,e){let n=0;let s=t.length;let a=0;while(n<s){a=Math.floor((n+s)/2);t[a]<=e?n=a+1:s=a}return s}function searchSortedImpl(t,n,s,a,o,c){const r=e.getArrayFromDType("int32",s*o);for(let e=0;e<s;++e){const s=t.slice(e*a,(e+1)*a);const i=e*o;for(let t=0;t<o;++t)r[i+t]=c==="left"?lowerBound(s,n[t+i]):upperBound(s,n[t+i])}return r}
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
 */function searchSorted(t){const{inputs:e,backend:n,attrs:s}=t;const{sortedSequence:a,values:o}=e;const{side:c}=s;const r=n.data.get(a.dataId).values;const i=n.data.get(o.dataId).values;const d=searchSortedImpl(r,i,a.shape[0],a.shape[1],o.shape[1],c);return n.makeTensorInfo(o.shape,"int32",d)}const Xo={kernelName:pe,backendName:"cpu",kernelFunc:searchSorted};
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
 */function select(t){const{inputs:n,backend:s}=t;const{condition:a,t:o,e:c}=n;Oe([a,o,c],"select");const r=a.shape.length;const i=s.data.get(a.dataId).values;const d=s.data.get(o.dataId).values;const p=s.data.get(c.dataId).values;const l=U(o.dtype,c.dtype);const u=e.makeZerosTypedArray(e.sizeFromShape(o.shape),l);let h=0;const f=r===0||r>1||o.shape.length===1?1:e.sizeFromShape(o.shape.slice(1));for(let t=0;t<i.length;t++)for(let e=0;e<f;e++)i[t]===1?u[h++]=d[t]:u[h++]=p[t];return s.makeTensorInfo(o.shape,l,u)}const tc={kernelName:le,backendName:"cpu",kernelFunc:select};
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
 */const ec=f.SELU_SCALEALPHA;const nc=f.SELU_SCALE;const sc=Ge(ue,(t=>t>=0?nc*t:ec*(Math.exp(t)-1)));const ac={kernelName:ue,backendName:"cpu",kernelFunc:sc};
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
 */const oc=Ge(he,(t=>t<0?-1:t>0?1:0));const cc={kernelName:he,backendName:"cpu",kernelFunc:oc};
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
 */const rc=Ge(fe,(t=>Math.sin(t)));const ic={kernelName:fe,backendName:"cpu",kernelFunc:rc};
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
 */const dc=Ge(me,(t=>Math.sinh(t)));const pc={kernelName:me,backendName:"cpu",kernelFunc:dc};
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
 */const lc=1.1920928955078125e-7;const uc=Math.log(lc)+2;const hc=Ge(ke,(t=>{const e=t>-uc;const n=t<uc;const s=Math.exp(t);let a;a=n?s:e?t:Math.log(1+s);return a}));const fc={kernelName:ke,backendName:"cpu",kernelFunc:hc};
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
 */function spaceToBatchND(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{blockShape:c,paddings:r}=a;Oe([o],"spaceToBatchND");const i=e.sizeFromShape(c);const d=[[0,0]];d.push(...r);for(let t=1+c.length;t<o.shape.length;++t)d.push([0,0]);const p=Co.kernelFunc({inputs:{x:o},backend:s,attrs:{paddings:d,constantValue:0}});const l=f.getReshaped(p.shape,c,i,false);const u=f.getPermuted(l.length,c.length,false);const h=f.getReshapedPermuted(p.shape,c,i,false);const m={x:p};const k={shape:l};const g=reshape({inputs:m,backend:s,attrs:k});const I={x:g};const b={perm:u};const N=Ze({inputs:I,backend:s,attrs:b});const v={x:N};const y={shape:h};const x=reshape({inputs:v,backend:s,attrs:y});s.disposeIntermediateTensorInfo(p);s.disposeIntermediateTensorInfo(g);s.disposeIntermediateTensorInfo(N);return x}const mc={kernelName:ge,backendName:"cpu",kernelFunc:spaceToBatchND};
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
 */function sparseFillEmptyRows(t){const{inputs:e,backend:n}=t;const{indices:s,values:a,denseShape:o,defaultValue:c}=e;if(o.shape.length!==1)throw new Error(`Dense shape must be a vector, saw:\n        ${o.shape}`);if(s.shape.length!==2)throw new Error(`Indices must be a matrix, saw:\n        ${s.shape}`);if(a.shape.length!==1)throw new Error(`Values must be a vector, saw:\n        ${a.shape}`);if(c.shape.length!==0)throw new Error(`Default value must be a scalar, saw:\n        ${c.shape}`);const r=n.data.get(s.dataId).values;const i=n.data.get(a.dataId).values;const d=n.data.get(o.dataId).values;const p=n.data.get(c.dataId).values[0];const[l,u,h,f,m]=gn(r,s.shape,s.dtype,i,a.dtype,d,p);return[n.makeTensorInfo(u,s.dtype,l),n.makeTensorInfo([u[0]],a.dtype,h),n.makeTensorInfo([f.length],"bool",new Uint8Array(f.map((t=>Number(t))))),n.makeTensorInfo([m.length],s.dtype,new Int32Array(m))]}const kc={kernelName:Ie,backendName:"cpu",kernelFunc:sparseFillEmptyRows};
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
 */function sparseReshape(t){const{inputs:e,backend:n}=t;const{inputIndices:s,inputShape:a,newShape:o}=e;if(s.shape.length!==2)throw new Error(`Input indices should be a matrix but received shape\n        ${s.shape}`);if(a.shape.length!==1)throw new Error(`Input shape should be a vector but received shape\n        ${a.shape}`);if(o.shape.length!==1)throw new Error(`Target shape should be a vector but received shape ${o.shape}`);const c=Array.from(n.data.get(a.dataId).values);const r=n.data.get(s.dataId).values;const i=Array.from(n.data.get(o.dataId).values);const[d,p,l]=In(r,s.shape,s.dtype,c,i);return[n.makeTensorInfo(p,s.dtype,d),n.makeTensorInfo([l.length],o.dtype,new Int32Array(l))]}const gc={kernelName:be,backendName:"cpu",kernelFunc:sparseReshape};
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
 */function sparseSegmentMean(t){const{inputs:e,backend:n}=t;const{data:s,indices:a,segmentIds:o}=e;if(s.shape.length<1)throw new Error("Data should be at least 1 dimensional but received scalar");if(a.shape.length!==1)throw new Error(`Indices should be a vector but received shape\n          ${a.shape}`);if(o.shape.length!==1)throw new Error(`Segment ids should be a vector but received shape\n          ${o.shape}`);if(a.shape[0]!==o.shape[0])throw new Error("segmentIds and indices should have same size.");const c=n.data.get(s.dataId).values;const r=n.data.get(a.dataId).values;const i=n.data.get(o.dataId).values;const[d,p]=bn(c,s.shape,s.dtype,r,i,true);return n.makeTensorInfo(p,s.dtype,d)}const Ic={kernelName:Ne,backendName:"cpu",kernelFunc:sparseSegmentMean};
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
 */function sparseSegmentSum(t){const{inputs:e,backend:n}=t;const{data:s,indices:a,segmentIds:o}=e;if(s.shape.length<1)throw new Error("Data should be at least 1 dimensional but received scalar");if(a.shape.length!==1)throw new Error(`Indices should be a vector but received shape\n         ${a.shape}`);if(o.shape.length!==1)throw new Error(`Segment ids should be a vector but received shape\n         ${o.shape}`);if(a.shape[0]!==o.shape[0])throw new Error("segmentIds and indices should have same size.");const c=n.data.get(s.dataId).values;const r=n.data.get(a.dataId).values;const i=n.data.get(o.dataId).values;const[d,p]=bn(c,s.shape,s.dtype,r,i);return n.makeTensorInfo(p,s.dtype,d)}const bc={kernelName:ve,backendName:"cpu",kernelFunc:sparseSegmentSum};
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
 */function sparseToDense(t){const{inputs:n,backend:s,attrs:a}=t;const{sparseIndices:o,sparseValues:c,defaultValue:r}=n;const{outputShape:i}=a;const{sliceRank:d,numUpdates:p,sliceSize:l,strides:u,outputSize:h}=f.calculateShapes(c,o,i);const m=false;const k=s.bufferSync(o);let g;switch(c.dtype){case"bool":{const t=s.bufferSync(c);const e=Boolean(s.data.get(r.dataId).values[0]);g=kn(k,t,i,h,l,p,d,u,e,m);break}case"float32":{const t=s.bufferSync(c);const e=s.data.get(r.dataId).values[0];g=kn(k,t,i,h,l,p,d,u,e,m);break}case"int32":{const t=s.bufferSync(c);const e=s.data.get(r.dataId).values[0];g=kn(k,t,i,h,l,p,d,u,e,m);break}case"string":{const t=s.bufferSync(c);const n=e.decodeString(s.data.get(r.dataId).values[0]);g=kn(k,t,i,h,l,p,d,u,n,m);break}default:throw new Error(`Unsupported type ${c.dtype}`)}return s.makeTensorInfo(i,g.dtype,g.values)}const Nc={kernelName:ye,backendName:"cpu",kernelFunc:sparseToDense};
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
 */function splitV(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{numOrSizeSplits:c,axis:r}=a;const i=e.parseAxisParam(r,o.shape)[0];const d=f.prepareSplitSize(o,c,i);const p=new Array(o.shape.length).fill(0);const l=o.shape.slice();return d.map((t=>{const e=[...l];e[i]=t;const n=Ye({inputs:{x:o},backend:s,attrs:{begin:p,size:e}});p[i]+=t;return n}))}const vc={kernelName:xe,backendName:"cpu",kernelFunc:splitV};
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
 */const yc={kernelName:Se,backendName:"cpu",kernelFunc:({inputs:t,backend:e})=>{const{x:n}=t;const s=e;Oe(n,"square");const a=s.data.get(n.dataId).values;const o=new Float32Array(a.length);for(let t=0;t<a.length;++t){const e=a[t];o[t]=e*e}const c=s.write(o,n.shape,n.dtype);return{dataId:c,shape:n.shape,dtype:n.dtype}}};
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
 */const xc=Ge(Te,((t,e)=>{const n=e;return isNaN(t)?NaN:t>0?1:n.alpha}));const Sc={kernelName:Te,backendName:"cpu",kernelFunc:xc};
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
 */function stridedSlice(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o}=n;const{begin:c,end:r,strides:i,beginMask:d,endMask:p,ellipsisMask:l,newAxisMask:u,shrinkAxisMask:h}=a;Oe(o,"stridedSlice");const{finalShapeSparse:f,finalShape:m,isIdentity:k,sliceDim0:g,isSimpleSlice:I,begin:b,end:N,strides:v}=Fe.sliceInfo(o.shape,c,r,i,d,p,l,u,h);let y;if(k)y=reshape({inputs:{x:o},backend:s,attrs:{shape:m}});else if(g||I){e.assert(o.shape.length>=1,(()=>`Input must have rank at least 1, got: ${o.shape.length}`));const t=Fe.computeOutShape(b,N,v);const n=Ye({inputs:{x:o},backend:s,attrs:{begin:b,size:t}});y=reshape({inputs:{x:n},backend:s,attrs:{shape:m}});s.disposeIntermediateTensorInfo(n)}else{const t=s.bufferSync(o);const e=Nn(f,t,v,b);y=s.makeTensorInfo(m,e.dtype,e.values)}return y}const Tc={kernelName:Me,backendName:"cpu",kernelFunc:stridedSlice};
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
 */function stringNGrams(t){const{inputs:e,backend:n,attrs:s}=t;const{separator:a,nGramWidths:o,leftPad:c,rightPad:r,padWidth:i,preserveShortSequences:d}=s;const{data:p,dataSplits:l}=e;const u=n.data.get(p.dataId).values;const h=n.data.get(l.dataId).values;const[f,m]=vn(u,h,a,o,c,r,i,d);return[n.makeTensorInfo([f.length],"string",f),n.makeTensorInfo(l.shape,"int32",m)]}const Fc={kernelName:Ae,backendName:"cpu",kernelFunc:stringNGrams};
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
 */function stringSplit(t){const{inputs:e,backend:n,attrs:s}=t;const{skipEmpty:a}=s;const{input:o,delimiter:c}=e;if(o.dtype!=="string")throw new Error("Input must be of datatype string");if(o.shape.length!==1)throw new Error(`Input must be a vector, got shape: ${o.shape}`);if(c.shape.length!==0)throw new Error(`Delimiter must be a scalar, got shape: ${c.shape}`);const r=n.data.get(o.dataId).values;const i=n.data.get(c.dataId).values[0];const[d,p,l]=yn(r,i,a);const u=p.length;return[n.makeTensorInfo([u,2],"int32",d),n.makeTensorInfo([u],"string",p),n.makeTensorInfo([2],"int32",new Int32Array(l))]}const Mc={kernelName:we,backendName:"cpu",kernelFunc:stringSplit};
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
 */function stringToHashBucketFast(t){const{inputs:e,backend:n,attrs:s}=t;const{numBuckets:a}=s;const{input:o}=e;if(o.dtype!=="string")throw new Error("Input must be of datatype string");if(a<=0)throw new Error("Number of buckets must be at least 1");const c=n.data.get(o.dataId).values;const r=xn(c,a);return n.makeTensorInfo(o.shape,"int32",r)}const Ac={kernelName:De,backendName:"cpu",kernelFunc:stringToHashBucketFast};
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
 */const wc=Ge(ze,(t=>Math.tan(t)));const Dc={kernelName:ze,backendName:"cpu",kernelFunc:wc};
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
 */const zc=Ge(We,(t=>Math.tanh(t)));const Wc={kernelName:We,backendName:"cpu",kernelFunc:zc};
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
 */function tensorScatterUpdate(t){const{inputs:e,backend:n}=t;const{tensor:s,indices:a,updates:o}=e;const{sliceRank:c,numUpdates:r,sliceSize:i,strides:d,outputSize:p}=f.calculateShapes(o,a,s.shape);const l=false;const u=n.bufferSync(a);const h=n.bufferSync(o);const m=n.bufferSync(s);const k=kn(u,h,s.shape,p,i,r,c,d,m,l);return n.makeTensorInfo(s.shape,k.dtype,k.values)}const Hc={kernelName:He,backendName:"cpu",kernelFunc:tensorScatterUpdate};
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
 */function tile(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a}=e;const{reps:o}=s;Oe(a,"tile");const c=Sn(n.bufferSync(a),o);return n.makeTensorInfo(c.shape,c.dtype,c.values)}const Cc={kernelName:Ce,backendName:"cpu",kernelFunc:tile};
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
 */function topK(t){const{inputs:e,backend:n,attrs:s}=t;const{x:a}=e;const{k:o,sorted:c}=s;Oe(a,"topk");const r=n.data.get(a.dataId).values;const[i,d]=Tn(r,a.shape,a.dtype,o,c);return[n.makeTensorInfo(i.shape,i.dtype,i.values),n.makeTensorInfo(d.shape,d.dtype,d.values)]}const Pc={kernelName:Pe,backendName:"cpu",kernelFunc:topK};
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
 */function transform(t){const{inputs:n,attrs:s,backend:a}=t;const{image:o,transforms:c}=n;const{interpolation:r,fillMode:i,fillValue:d,outputShape:p}=s;const[l,u,h,f]=o.shape;const[m,k]=p!=null?p:[u,h];const g=[l,m,k,f];const I=e.computeStrides(o.shape);const b=I[0];const N=I[1];const v=I[2];const y=e.computeStrides(g);const x=y[0];const S=y[1];const T=y[2];const F=e.getTypedArrayFromDType(o.dtype,e.sizeFromShape(g));F.fill(d);const M=a.data.get(o.dataId).values;const A=a.data.get(c.dataId).values;for(let t=0;t<l;++t){const e=c.shape[0]===1?A:A.subarray(t*8,t*8+8);for(let n=0;n<m;++n)for(let s=0;s<k;++s)for(let a=0;a<f;++a){let o;const c=e[6]*s+e[7]*n+1;if(c===0)continue;const p=(e[0]*s+e[1]*n+e[2])/c;const l=(e[3]*s+e[4]*n+e[5])/c;const f=mapCoord(p,h,i);const m=mapCoord(l,u,i);switch(r){case"nearest":o=nearestInterpolation(M,u,h,b,N,v,t,m,f,a,d);break;case"bilinear":o=bilinearInterpolation(M,u,h,b,N,v,t,m,f,a,d);break;default:throw new Error(`Error in Transform: Expect 'nearest' or 'bilinear', but got ${r}`)}const k=t*x+n*S+s*T+a;F[k]=o}return a.makeTensorInfo(g,o.dtype,F)}const w=a.write(F,g,o.dtype);return{dataId:w,shape:o.shape,dtype:o.dtype}}const Ec={kernelName:Ee,backendName:"cpu",kernelFunc:transform};function mapCoord(t,e,n){switch(n){case"reflect":return mapCoordReflect(t,e);case"wrap":return mapCoordWrap(t,e);case"nearest":return mapCoordNearest(t,e);case"constant":default:return mapCoordConstant(t,e)}}function mapCoordReflect(t,n){let s=t;if(s<0)if(n<=1)s=0;else{const t=2*n;s<t&&(s=t*Math.trunc(-s/t)+s);s=s<-n?s+t:-s-1}else if(s>n-1)if(n<=1)s=0;else{const t=2*n;s-=t*Math.trunc(s/t);s>=n&&(s=t-s-1)}return e.clamp(0,s,n-1)}function mapCoordWrap(t,n){let s=t;if(s<0)if(n<=1)s=0;else{const t=n-1;s+=n*(Math.trunc(-s/t)+1)}else if(s>n-1)if(n<=1)s=0;else{const t=n-1;s-=n*Math.trunc(s/t)}return e.clamp(0,s,n-1)}function mapCoordConstant(t,e){return t}function mapCoordNearest(t,n){return e.clamp(0,t,n-1)}function readWithFillValue(t,e,n,s,a,o,c,r,i,d,p){const l=c*s+r*a+i*o+d;return 0<=r&&r<e&&0<=i&&i<n?t[l]:p}function nearestInterpolation(t,e,n,s,a,o,c,r,i,d,p){const l=Math.round(r);const u=Math.round(i);return readWithFillValue(t,e,n,s,a,o,c,l,u,d,p)}function bilinearInterpolation(t,e,n,s,a,o,c,r,i,d,p){const l=Math.floor(r);const u=Math.floor(i);const h=l+1;const f=u+1;const m=(f-i)*readWithFillValue(t,e,n,s,a,o,c,l,u,d,p)+(i-u)*readWithFillValue(t,e,n,s,a,o,c,l,f,d,p);const k=(f-i)*readWithFillValue(t,e,n,s,a,o,c,h,u,d,p)+(i-u)*readWithFillValue(t,e,n,s,a,o,c,h,f,d,p);return(h-r)*m+(r-l)*k}
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
 */function unique(t){const{inputs:e,attrs:n,backend:s}=t;const{axis:a}=n;const{x:o}=e;Oe(o,"unique");const c=s.data.get(o.dataId).values;const{outputValues:r,outputShape:i,indices:d}=Fn(c,a,o.shape,o.dtype);return[s.makeTensorInfo(i,o.dtype,r),s.makeTensorInfo([d.length],"int32",d)]}const Rc={kernelName:Re,backendName:"cpu",kernelFunc:unique};
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
 */function unpack(t){const{inputs:e,backend:n,attrs:s}=t;const{value:a}=e;let{axis:o}=s;o<0&&(o+=a.shape.length);const c=a.shape.length;const r=a.shape[o];const i=new Array(c-1);let d=0;for(let t=0;t<c;t++)t!==o&&(i[d++]=a.shape[t]);const p=new Array(c).fill(0);const l=a.shape.slice();l[o]=1;const u=new Array(r);for(let t=0;t<u.length;t++){p[o]=t;const e=Ye({inputs:{x:a},backend:n,attrs:{begin:p,size:l}});u[t]=reshape({inputs:{x:e},backend:n,attrs:{shape:i}});n.disposeIntermediateTensorInfo(e)}return u}const Vc={kernelName:Ve,backendName:"cpu",kernelFunc:unpack};
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
 */function unsortedSegmentSum(t){const{inputs:n,backend:s,attrs:a}=t;const{x:o,segmentIds:c}=n;const{numSegments:r}=a;Oe(o,"unsortedSegmentSum");const i=o.shape.length;const d=c.shape.length;const p=[];const l=[];const u=i-d;let h=c;for(let t=0;t<u;++t){const e=expandDims({inputs:{input:h},backend:s,attrs:{dim:t+1}});h=e;l.push(e)}for(let t=0;t<r;++t){const n=e.createScalarValue(t,"int32");const a=s.makeTensorInfo([],"int32",n);const c=Mn({inputs:{a:a,b:h},backend:s});const r=en({inputs:{x:c},backend:s,attrs:{dtype:"float32"}});const i=sn({inputs:{a:r,b:o},backend:s});const d=sum({inputs:{x:i},backend:s,attrs:{axis:0,keepDims:false}});p.push(d);l.push(a);l.push(c);l.push(r);l.push(i);l.push(d)}const f=pack({inputs:p,backend:s,attrs:{axis:0}});l.forEach((t=>s.disposeIntermediateTensorInfo(t)));return f}const Bc={kernelName:Be,backendName:"cpu",kernelFunc:unsortedSegmentSum};
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
 */const $c=[Is,An,Ns,ys,wn,xs,Ss,Ts,Fs,Ms,ws,zs,Hs,Es,Vs,Bs,$s,Gs,Os,gs,_s,Ls,qs,Dn,Us,zn,Wn,Ks,Hn,Ys,Js,Qs,Xs,ta,ea,na,sa,oa,ra,ia,da,pa,la,ua,ha,fa,ma,ka,ga,Ia,ba,Na,ya,is,xa,Cn,za,Pn,Wa,En,Ea,Ra,Va,Rn,Vn,Ba,$a,Ga,Oa,Bn,$n,Gn,_a,js,qa,Za,Ya,ds,On,_n,ja,Ln,Qa,eo,so,co,ro,io,po,qn,lo,uo,ho,fo,mo,ko,go,Un,Io,vo,xo,Zn,Kn,To,Mo,wo,Yn,Do,Wo,Ho,Co,Ro,ls,jn,Vo,Bo,$o,Go,Jn,Pa,_o,hs,ms,ks,Lo,qo,Uo,Zo,Ko,Yo,Jo,Qn,Qo,Xo,tc,ac,Xn,cc,ic,pc,ts,yo,fc,mc,kc,gc,Ic,bc,Nc,vc,es,yc,ns,ss,Sc,Tc,Fc,Mc,Ac,as,va,Dc,Wc,Hc,Cc,Pc,Ec,os,Rc,Vc,Bc,zo];for(const t of $c)$e(t);
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
 */

