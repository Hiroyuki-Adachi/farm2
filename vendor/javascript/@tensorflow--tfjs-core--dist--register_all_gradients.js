import{A as n,a,b as e,c as t,d as s,e as r,f as o,g as c,h as u,i as p,j as l,k as i,l as d,m as h,E as g,n as m,o as k,p as x,B as f,q as v,r as F,C as N,s as S,t as b,u as T,v as G,w as y,x as P,y as _,z as $,D as E,F as R,G as M,H as z,I as D,J as j,K as w,L as C,M as K,N as A,O as B,P as I,Q as V,R as L,S as W,T as Y,U as Z,V as q,W as H,X as J,Y as Q,Z as X,_ as O,$ as U,a0 as nn,a1 as an,a2 as en,a3 as tn,a4 as sn,a5 as rn,a6 as on,a7 as cn,a8 as un,a9 as pn,aa as ln,ab as dn,ac as hn,ad as gn,ae as mn,af as kn,ag as xn,ah as fn,ai as vn,aj as Fn,ak as Nn,al as Sn,am as bn,an as Tn,ao as Gn,ap as yn,aq as Pn,ar as _n,as as $n,at as En,au as Rn,av as Mn,aw as zn,ax as Dn,ay as jn,az as wn,aA as Cn,aB as Kn,aC as An,aD as Bn,aE as In,aF as Vn,aG as Ln,aH as Wn,aI as Yn,aJ as Zn,aK as qn,aL as Hn,aM as Jn,aN as Qn,aO as Xn,aP as On,aQ as Un,aR as na,aS as aa,aT as ea,aU as ta,aV as sa,aW as ra,aX as oa,aY as ca}from"../_/8ddWaOrg.js";import{J as ua,bW as pa,aT as la,bS as ia,bw as da,bY as ha,bR as ga,a4 as ma,aW as ka,cv as xa,cw as fa,bZ as va,bo as Fa,ci as Na,j as Sa,cx as ba,aG as Ta,bL as Ga,am as ya,at as Pa,aB as _a,cf as $a,bQ as Ea,cy as Ra,cz as Ma,cA as za,T as Da,cB as ja,bC as wa,bD as Ca,cC as Ka,_ as Aa,ck as Ba,cD as Ia,cE as Va,cF as La,ad as Wa,bv as Ya,c7 as Za,cb as qa,cG as Ha,bV as Ja,al as Qa,cH as Xa,aa as Oa,as as Ua,cI as ne,aZ as ae,bE as ee,ai as te,ch as se,cc as re,b6 as oe,aw as ce,Z as ue,bp as pe,aC as le,X as ie,Y as de,b0 as he,bA as ge,z as me,N as ke,aL as xe,ak as fe,ae as ve}from"../_/xYr_nMYD.js";import"../_/vX83Zs-I.js";import{o as Fe}from"../_/J5sCwXNI.js";import{assert as Ne,parseAxisParam as Se,sizeFromShape as be}from"./util_base.js";import{S as Te,a as Ge,p as ye}from"../_/KcZLPp9h.js";import"./backends/backend.js";import"./environment.js";import"../_/kxV-4fTk.js";import"./types.js";import"seedrandom";import"../_/g6dUepHB.js";import"long";import"../_/VDbnZg2_.js";import"../_/TExXu_CZ.js";
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Pe={kernelName:n,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(n,pa(ua(e,"float32"),-1))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const _e={kernelName:a,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>{const a=ia(ua(e,"float32"));const t=ga(ha(da(1),a));return ka(ma(n,t))}}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const $e={kernelName:e,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>{const a=ga(ha(ia(ua(e,"float32")),1));return ma(n,a)}}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ee={kernelName:t,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=xa(e.shape,t.shape);const derA=()=>{let a=n;const t=fa(e.shape,s);t.length>0&&(a=va(a,t));return Fa(a,e.shape)};const derB=()=>{let a=n;const e=fa(t.shape,s);e.length>0&&(a=va(a,e));return Fa(a,t.shape)};return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Re={kernelName:s,saveAllInputs:true,gradFunc:(n,a)=>{const e={};a.forEach(((a,t)=>{e[t]=()=>n.clone()}));return e}};
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
 */const Me={kernelName:r,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>Na(e)}}};
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
 */const ze={kernelName:o,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>Na(e)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const De={kernelName:c,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,ga(ha(da(1),ia(ua(e,"float32")))))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const je={kernelName:u,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>{const a=ga(Sa(da(1),ia(ua(e,"float32"))));return ma(n,a)}}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const we={kernelName:p,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=xa(e.shape,t.shape);const derA=()=>{const a=Sa(ia(e),ia(t));let r=la(n,ma(t,a));const o=fa(e.shape,s);o.length>0&&(r=va(r,o));return Fa(r,e.shape)};const derB=()=>{const a=Sa(ia(e),ia(t));let r=ka(la(n,ma(e,a)));const o=fa(t.shape,s);o.length>0&&(r=va(r,o));return Fa(r,t.shape)};return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ce={kernelName:l,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,Sa(ia(ua(e,"float32")),1))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ke={kernelName:i,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,ha(da(1),ia(ua(e,"float32"))))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
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
/**
 * Computes the backprop of a 3d avg pool.
 *
 * @param dy The dy error, of rank 5 of shape
 *     [batchSize, depth, height, width, channels].
 * assumed.
 * @param input The original input image, of rank 5 or rank4 of shape
 *     [batchSize, depth, height, width, channels].
 * @param filterSize The filter size:
 *     `[filterDepth, filterHeight, filterWidth]`.
 *     `filterSize` is a single number,
 *     then `filterDepth == filterHeight == filterWidth`.
 * @param strides The strides of the pooling:
 *     `[strideDepth, strideHeight, strideWidth]`. If
 *     `strides` is a single number, then `strideHeight == strideWidth`.
 * @param pad A string from: 'same', 'valid'. The type of padding algorithm
 *     used in the forward prop of the op.
 * @param dimRoundingMode A string from: 'ceil', 'round', 'floor'. If none is
 *     provided, it will default to truncate.
 */function avgPool3dGrad_(n,a,e,t,s,r){const o=d(n,"dy","avgPool3dGrad");const c=d(a,"input","avgPool3dGrad");let u=o;let p=c;let l=false;if(c.rank===4){l=true;u=Fa(o,[1,o.shape[0],o.shape[1],o.shape[2],o.shape[3]]);p=Fa(c,[1,c.shape[0],c.shape[1],c.shape[2],c.shape[3]])}Ne(u.rank===5,(()=>`Error in avgPool3dGrad: dy must be rank 5 but got rank ${u.rank}.`));Ne(p.rank===5,(()=>`Error in avgPool3dGrad: input must be rank 5 but got rank ${p.rank}.`));ba("avgPool3dGrad",s,r);const i={dy:u,input:p};const m={filterSize:e,strides:t,pad:s,dimRoundingMode:r};const k=g.runKernel(h,i,m);return l?Fa(k,[k.shape[1],k.shape[2],k.shape[3],k.shape[4]]):k}const Ae=Fe({avgPool3dGrad_:avgPool3dGrad_});
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Be={kernelName:m,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{filterSize:s,strides:r,pad:o,dimRoundingMode:c}=e;return{x:()=>Ae(n,t,s,r,o,c)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
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
/**
 * Computes the backprop of an 2D avg pool.
 *
 * @param dy The dy error, of rank 4 or rank 3 of shape
 *     [batchSize, height, width, channels]. If rank 3, batch of 1 is
 * assumed.
 * @param input The input image, of rank 4 or rank 3 of shape
 *     [batchSize, height, width, channels]. If rank 3, batch of 1 is
 * assumed.
 * @param filterSize The filter size: `[filterHeight, filterWidth]`. If
 *     `filterSize` is a single number, then `filterHeight == filterWidth`.
 * @param strides The strides of the pooling: `[strideHeight, strideWidth]`. If
 *     `strides` is a single number, then `strideHeight == strideWidth`.
 * @param pad The type of padding algorithm used in the forward prop of the op.
 *     'same', 'valid', for more info, see this guide:
 *     [https://www.tensorflow.org/api_docs/python/tf/nn/convolution](
 *         https://www.tensorflow.org/api_docs/python/tf/nn/convolution)
 */function avgPoolGrad_(n,a,e,t,s){const r=d(n,"dy","avgPoolGrad");const o=d(a,"input","avgPoolGrad");Ne(o.rank===r.rank,(()=>`Rank of input (${o.rank}) does not match rank of dy (${r.rank})`));let c=o;let u=r;let p=false;if(o.rank===3){p=true;c=Fa(o,[1,o.shape[0],o.shape[1],o.shape[2]]);u=Fa(r,[1,r.shape[0],r.shape[1],r.shape[2]])}Ne(u.rank===4,(()=>`Error in avgPoolGrad: dy must be rank 4 but got rank ${u.rank}.`));Ne(c.rank===4,(()=>`Error in avgPoolGrad: input must be rank 4 but got rank ${c.rank}.`));const l={dy:u,input:c};const i={filterSize:e,strides:t,pad:s};const h=g.runKernel(k,l,i);return p?Fa(h,[h.shape[1],h.shape[2],h.shape[3]]):h}const Ie=Fe({avgPoolGrad_:avgPoolGrad_});
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ve={kernelName:x,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{filterSize:s,strides:r,pad:o}=e;return{x:()=>Ie(n,t,s,r,o)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Le={kernelName:f,inputsToSave:["a","b"],gradFunc:(n,a,e)=>{const[t,s]=a;const{transposeA:r,transposeB:o}=e;return r||o?!r&&o?{a:()=>Ta(n,s,false,false),b:()=>Ta(n,t,true,false)}:r&&!o?{a:()=>Ta(s,n,false,true),b:()=>Ta(t,n,false,false)}:{a:()=>Ta(s,n,true,true),b:()=>Ta(n,t,true,true)}:{a:()=>Ta(n,s,false,true),b:()=>Ta(t,n,true,false)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const We={kernelName:v,gradFunc:(n,a,e)=>{const{blockShape:t,crops:s}=e;return{x:()=>Ga(n,t,s)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ye={kernelName:F,gradFunc:(n,a,e)=>{const t=e;const s=t.inputShape;const r=t.shape;const o=Array.from(r);for(let n=s.length-1;n>=0;n--)if(s[n]===r[n])o[n]=1;else if(s[n]!==1)throw new Error(`broadcastTo(): [${s}] cannot be broadcast to [${r}].`);const c=[];for(let n=0;n<o.length;n++)o[n]>1&&c.push(n);return{x:()=>va(n,c,true)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ze={kernelName:N,gradFunc:n=>({x:()=>n.clone()})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const qe={kernelName:S,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const He={kernelName:b,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{clipValueMin:s,clipValueMax:r}=e;return{x:()=>$a(_a(ya(t,s),Pa(t,r)),n,Na(n))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Je={kernelName:T,inputsToSave:["x"],gradFunc:Pe.gradFunc};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Qe={kernelName:G,saveAllInputs:true,gradFunc:(n,a,e)=>{const t=a.map((n=>n.shape));const{axis:s}=e;const r=Se(s,a[0].shape)[0];const o=t.map((n=>n[r]));const c=Ea(n,o,r);return c.map((n=>()=>n))}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Xe={kernelName:y,inputsToSave:["x","filter"],gradFunc:(n,a,e)=>{const[t,s]=a;const{dilations:r,strides:o,pad:c,dataFormat:u}=e;Ne(Ra(r),(()=>`Error in gradient of conv2D: dilation rates greater than 1 are not yet supported in gradients. Got dilations '${r}'`));return{x:()=>Ma(t.shape,n,s,o,c,u),filter:()=>za(t,n,s.shape,o,c,u)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Oe={kernelName:P,inputsToSave:["dy","filter"],gradFunc:(n,a,e)=>{const[t,s]=a;const{strides:r,pad:o,dataFormat:c,dimRoundingMode:u}=e;return{dy:()=>Da(n,s,r,o,c,1,u),filter:()=>za(n,t,s.shape,r,o,c,u)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
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
/**
 * Computes the derivative of the filter of a 3D convolution.
 *
 * @param x The input tensor, of rank 5 or rank 4 of shape
 *     [batch, depth, height, width, inChannels]. If rank 4, batch of 1 is
 *     assumed.
 * @param dy The dy image, of rank 5 or rank 4, of shape
 *     [batch, depth, height, width, outDepth]. If rank 4, batch of 1 is
 *     assumed.
 * @param filterShape The shape of the filter, length 5,
 *     [filterDepth, filterHeight, filterWidth, inDepth, outDepth].
 * @param strides The strides of the convolution: [strideDepth, strideHeight,
 * strideWidth].
 * @param pad A string from: 'same', 'valid'. The type of padding algorithm
 *     used in the forward prop of the op.
 */function conv3DBackpropFilter_(n,a,e,t,s){let r=n;n.rank===4&&(r=Fa(n,[1,n.shape[0],n.shape[1],n.shape[2],n.shape[3]]));let o=a;o.rank===4&&(o=Fa(a,[1,a.shape[0],a.shape[1],a.shape[2],a.shape[3]]));Ne(r.rank===5,(()=>`Error in conv3dDerFilter: input must be rank 5, but got shape ${r.shape}.`));Ne(o.rank===5,(()=>`Error in conv3dDerFilter: dy must be rank 5, but got shape ${o.shape}.`));Ne(e.length===5,(()=>`Error in conv3dDerFilter: filterShape must be length 5, but got ${e}.`));Ne(r.shape[4]===e[3],(()=>`Error in conv3dDerFilter: depth of input ${r.shape[4]}) must match input depth in filter (${e[3]}.`));Ne(o.shape[4]===e[4],(()=>`Error in conv3dDerFilter: depth of dy (${o.shape[4]}) must match output depth for filter (${e[4]}).`));const c={x:r,dy:o};const u={strides:t,pad:s,filterShape:e};return g.runKernel(_,c,u)}const Ue=Fe({conv3DBackpropFilter_:conv3DBackpropFilter_});
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const nt={kernelName:$,inputsToSave:["x","filter"],gradFunc:(n,a,e)=>{const{dilations:t,strides:s,pad:r}=e;Ne(Ra(t),(()=>`Error in gradient of conv3D: dilation rates greater than 1 are not yet supported in gradients. Got dilations '${t}'`));const[o,c]=a;return{x:()=>ja(o.shape,n,c,s,r),filter:()=>Ue(o,n,c.shape,s,r)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const at={kernelName:E,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(ka(wa(ua(e,"float32"))),n)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const et={kernelName:R,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(Ca(ua(e,"float32")),n)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const tt={kernelName:M,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{axis:s,exclusive:r,reverse:o}=e;return{x:()=>{const a=Ka([s],t.rank);let e=Aa(n,s,r,!o);a!=null&&(e=Ba(e,a));return e}}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const st={kernelName:z,inputsToSave:["x","filter"],gradFunc:(n,a,e)=>{const{dilations:t,strides:s,pad:r,dimRoundingMode:o}=e;const c=t==null?[1,1]:t;Ne(Ra(c),(()=>`Error in gradient of depthwiseConv2dNative: dilation rates greater than 1 are not yet supported. Got dilations '${c}'`));const[u,p]=a;Ne(u.rank===4,(()=>`Error in gradient of depthwiseConv2dNative: input must be rank 4, but got rank ${u.rank}.`));Ne(p.rank===4,(()=>`Error in gradient of depthwiseConv2dNative: filter must be rank 4, but got rank ${p.rank}.`));Ne(u.shape[3]===p.shape[2],(()=>`Error in gradient of depthwiseConv2d: number of input channels (${u.shape[3]}) must match the inChannels dimension in filter ${p.shape[2]}.`));Ne(Ia(s,c),(()=>`Error in gradient of depthwiseConv2d: Either strides or dilations must be  1. Got strides ${s} and dilations '${c}'.`));ba("depthwiseConv2d",r,o);return{x:()=>Va(u.shape,n,p,s,r,c,o),filter:()=>La(u,n,p.shape,s,r,c,o)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const rt={kernelName:D,inputsToSave:["x","filter"],gradFunc:(n,a,e)=>{const[t,s]=a;const r={x:t,filter:s,dy:n};const o={x:t,filter:s,dy:n};return{x:()=>g.runKernel(j,r,e),filter:()=>g.runKernel(w,o,e)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ot={kernelName:C,outputsToSave:[true],gradFunc:(n,a)=>{const[e]=a;const t={dy:n,y:e};return{x:()=>g.runKernel(K,t)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ct={kernelName:A,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;const t=la(Wa(ka(ia(e))),2/Math.sqrt(Math.PI));return{x:()=>la(n,t)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ut={kernelName:B,outputsToSave:[true],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(n,e)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const pt={kernelName:I,inputsToSave:["input"],gradFunc:(n,a)=>{const[e]=a;return{input:()=>Fa(n,e.shape)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const lt={kernelName:V,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(n,Wa(e))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const it={kernelName:L,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const dt={kernelName:W,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=xa(e.shape,t.shape);const derA=()=>{const a=ma(n,ua(t,"float32"));const r=fa(e.shape,s);return r.length>0?Fa(va(a,r),e.shape):a};const derB=()=>{let a=la(n,ua(e,"float32"));const r=fa(t.shape,s);r.length>0&&(a=Fa(va(a,r),t.shape));const o=ia(t);return ka(ma(a,ua(o,"float32")))};return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ht={kernelName:Y,inputsToSave:["x","mean","variance","scale"],gradFunc:(n,a,e)=>{const{varianceEpsilon:t}=e;const[s,r,o,c]=a;const u=c==null?da(1):c;const p=fa(r.shape,s.shape);const l=[];if(r.rank===1){for(let n=0;n<s.shape.length-1;++n)l.push(s.shape[n]);l.push(1)}const i=ha(s,r);const d=la(n,u);const h=Ya(Sa(o,da(t)));const g=la(la(la(h,h),h),da(-.5));const derX=()=>r.rank===1?Fa(la(la(n,Za(Fa(h,[1,1,1,r.shape[0]]),l)),u),s.shape):Fa(la(la(n,h),u),s.shape);const derMean=()=>{let n=la(la(h,da(-1)),d);r.rank===1&&(n=va(n,p));return Fa(n,r.shape)};const derVariance=()=>{let n=la(la(g,i),d);r.rank===1&&(n=va(n,p));return Fa(n,r.shape)};const derScale=()=>{const a=la(i,h);let e=la(n,a);r.rank===1&&(e=va(e,p));return Fa(e,r.shape)};const derOffset=()=>{let a=n;r.rank===1&&(a=va(a,p));return Fa(a,r.shape)};return{x:derX,mean:derMean,variance:derVariance,scale:derScale,offset:derOffset}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const gt={kernelName:Z,inputsToSave:["x","indices"],gradFunc:(n,a,e)=>{const[t,s]=a;const{axis:r,batchDims:o}=e;const c=Se(r,t.shape)[0];const derXBatch=(n,a,e)=>()=>{const t=n.shape;const s=a.size;const o=t.slice(0,c);const u=o.length;const p=t.slice(r,t.length).slice(1);const l=p.length;const i=arrayRange(0,u);const d=arrayRange(u+1,u+1+l);const h=arrayConcat([o,[s],p]);const g=Fa(e,h);const m=Fa(a,[s]);const k=arrayConcat([[u],i,d]);const x=Ba(g,k);let f=qa(x,m,n.shape[c]);const v=Ha(k);f=Ba(f,v);return f};if(o===1){const a=t.shape[0];const e=t.split(a,0);const derXBatched=()=>{const a=Ja(e.map(((a,e)=>derXBatch(a,s.slice(e,1),n.slice(e,1))())));return a.reshape(t.shape)};return{x:derXBatched,indices:()=>s}}return{x:derXBatch(t,s,n),indices:()=>s}}};function arrayRange(n,a){const e=[];for(let t=n;t<a;++t)e.push(t);return e}function arrayConcat(n){const a=[];for(let e=0;e<n.length;++e)for(let t=0;t<n[e].length;++t)a.push(n[e][t]);return a}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const mt={kernelName:q,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;return{a:()=>Na(e),b:()=>Na(t)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const kt={kernelName:H,gradFunc:n=>({x:()=>ua(n,"float32")})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const xt={kernelName:J,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ft={kernelName:Q,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const vt={kernelName:X,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ft={kernelName:O,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{alpha:s}=e;const r=Qa(t,0);return{x:()=>$a(r,n,la(n,s))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Nt={kernelName:U,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,Sa(e,1))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const St={kernelName:nn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,ua(e,"float32"))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const bt={kernelName:an,inputsToSave:[],outputsToSave:[true],gradFunc:(n,a,e)=>{const[t]=a;const{axis:s}=e;return{logits:()=>{const a=true;const e=Wa(t);return ha(n,la(va(n,s,a),e))}}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */function localResponseNormalizationBackprop_(n,a,e,t=5,s=1,r=1,o=.5){const c={x:n,y:a,dy:e};const u={depthRadius:t,bias:s,alpha:r,beta:o};return g.runKernel(en,c,u)}const Tt=Fe({localResponseNormalizationBackprop_:localResponseNormalizationBackprop_});
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Gt={kernelName:tn,inputsToSave:["x"],outputsToSave:[true],gradFunc:(n,a,e)=>{const[t,s]=a;const{depthRadius:r,bias:o,alpha:c,beta:u}=e;return{x:()=>Tt(t,s,n,r,o,c,u)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */function gradForMinAndMax(n,a,e,t){a.rank<e.rank&&(a=Fa(a,Xa(a.shape,t)));n.rank<e.rank&&(n=Fa(n,Xa(n.shape,t)));return{x:()=>{const t=la(n,ua(Oa(e,a),n.dtype));return t}}}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const yt={kernelName:sn,inputsToSave:["x"],outputsToSave:[true],gradFunc:(n,a,e)=>{const t=e;const{reductionIndices:s}=t;const r=a[0];const o=a[1];const c=Se(s,r.shape);const u=gradForMinAndMax(n,o,r,c);return{x:()=>u.x()}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Pt={kernelName:rn,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const derA=()=>la(n,ua(ya(e,t),"float32"));const derB=()=>la(n,ua(Ua(e,t),"float32"));return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
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
/**
 * Computes the backprop of a 3d max pool.
 *
 * @param dy The dy error, of rank 5 of shape
 *     [batchSize, depth, height, width, channels].
 * assumed.
 * @param input The original input image, of rank 5 or rank 4 of shape
 *     [batchSize, depth, height, width, channels].
 * @param output The original output image, of rank 5 of shape
 *     [batchSize, outDepth, outHeight, outWidth, channels].
 * @param filterSize The filter size:
 *     `[filterDepth, filterHeight, filterWidth]`.
 *     `filterSize` is a single number,
 *     then `filterDepth == filterHeight == filterWidth`.
 * @param strides The strides of the pooling:
 *     `[strideDepth, strideHeight, strideWidth]`. If
 *     `strides` is a single number, then `strideHeight == strideWidth`.
 * @param pad A string from: 'same', 'valid'. The type of padding algorithm
 *     used in the forward prop of the op.
 * @param dimRoundingMode A string from: 'ceil', 'round', 'floor'. If none is
 *     provided, it will default to truncate.
 */function maxPool3dGrad_(n,a,e,t,s,r,o){const c=d(n,"dy","maxPool3dGrad");const u=d(a,"input","maxPool3dGrad");const p=d(e,"output","maxPool3dGrad");let l=c;let i=u;let h=p;let m=false;if(u.rank===4){m=true;l=Fa(c,[1,c.shape[0],c.shape[1],c.shape[2],c.shape[3]]);i=Fa(u,[1,u.shape[0],u.shape[1],u.shape[2],u.shape[3]]);h=Fa(p,[1,p.shape[0],p.shape[1],p.shape[2],p.shape[3]])}Ne(l.rank===5,(()=>`Error in maxPool3dGrad: dy must be rank 5 but got rank ${l.rank}.`));Ne(i.rank===5,(()=>`Error in maxPool3dGrad: input must be rank 5 but got rank ${i.rank}.`));Ne(h.rank===5,(()=>`Error in maxPool3dGrad: output must be rank 5 but got rank ${h.rank}.`));ba("maxPool3dGrad",r,o);const k={dy:l,input:i,output:h};const x={filterSize:t,strides:s,pad:r,dimRoundingMode:o};const f=g.runKernel(on,k,x);return m?Fa(f,[f.shape[1],f.shape[2],f.shape[3],f.shape[4]]):f}const _t=Fe({maxPool3dGrad_:maxPool3dGrad_});
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const $t={kernelName:cn,inputsToSave:["x"],outputsToSave:[true],gradFunc:(n,a,e)=>{const[t,s]=a;const{filterSize:r,strides:o,pad:c,dimRoundingMode:u}=e;return{x:()=>_t(n,t,s,r,o,c,u)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
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
/**
 * Computes the backprop of a 2D max pool.
 *
 * @param dy The dy error, of rank 4 or rank 3 of shape
 *     [batchSize, height, width, channels]. If rank 3, batch of 1 is
 * assumed.
 * @param input The original input image, of rank 4, of shape
 *     [batchSize, height, width, channels].
 * @param output The original output image, of rank 4, of shape
 *     [batchSize, outHeight, outWidth, channels].
 * @param filterSize The filter size: `[filterHeight, filterWidth]`. If
 *     `filterSize` is a single number, then `filterHeight == filterWidth`.
 * @param strides The strides of the pooling: `[strideHeight, strideWidth]`. If
 *     `strides` is a single number, then `strideHeight == strideWidth`.
 * @param pad The type of padding algorithm used in the forward prop of the op.
 *     'same', 'valid', for more info, see this guide:
 *     [https://www.tensorflow.org/api_docs/python/tf/nn/convolution](
 *          https://www.tensorflow.org/api_docs/python/tf/nn/convolution)
 * @param dimRoundingMode A string from: 'ceil', 'round', 'floor'. If none is
 *     provided, it will default to truncate.
 */function maxPoolGrad_(n,a,e,t,s,r,o){const c=d(n,"dy","maxPoolGrad");const u=d(a,"input","maxPoolGrad");const p=d(e,"output","maxPoolGrad");Ne(u.rank===c.rank,(()=>`Rank of input (${u.rank}) does not match rank of dy (${c.rank})`));Ne(c.rank===4,(()=>`Error in maxPoolGrad: dy must be rank 4 but got rank ${c.rank}.`));Ne(u.rank===4,(()=>`Error in maxPoolGrad: input must be rank 4 but got rank ${u.rank}.`));ba("maxPoolGrad",r,o);const l={dy:c,input:u,output:p};const i={filterSize:t,strides:s,pad:r,dimRoundingMode:o};return g.runKernel(un,l,i)}const Et=Fe({maxPoolGrad_:maxPoolGrad_});
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Rt={kernelName:pn,inputsToSave:["x"],outputsToSave:[true],gradFunc:(n,a,e)=>{const[t,s]=a;const{filterSize:r,strides:o,pad:c}=e;return{x:()=>Et(n,t,s,r,o,c)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Mt={kernelName:ln,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{axis:s}=e;const r=Se(s,t.shape);const o=ne(t.shape,r);const c=o[1];const u=be(c);const derX=()=>{const a=t.shape.slice();r.forEach((n=>{a[n]=1}));const e=Fa(n,a);const s=ma(la(e,ae(t.shape,"float32")),u);return s};return{x:derX}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const zt={kernelName:dn,inputsToSave:["x"],outputsToSave:[true],gradFunc:(n,a,e)=>{const t=e;const{axis:s}=t;const[r,o]=a;const c=Se(s,r.shape);const u=gradForMinAndMax(n,o,r,c);return{x:()=>u.x()}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Dt={kernelName:hn,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const derA=()=>la(n,ua(Pa(e,t),"float32"));const derB=()=>la(n,ua(Qa(e,t),"float32"));return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const jt={kernelName:gn,inputsToSave:["x"],gradFunc:(n,a,e)=>{const t=a[0];const{paddings:s}=e;const r=s.map((n=>n[0]));return{x:()=>ee(n,r,t.shape)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const wt={kernelName:mn,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=xa(e.shape,t.shape);const derA=()=>{const a=fa(e.shape,s);return a.length>0?Fa(va(n,a),e.shape):n};const derB=()=>{const a=la(n,ka(te(ma(e,t))));const r=fa(t.shape,s);return r.length>0?Fa(va(a,r),t.shape):a};return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ct={kernelName:kn,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=xa(e.shape,t.shape);const derA=()=>{const a=la(n,ua(t,"float32"));const r=fa(e.shape,s);return r.length>0?Fa(va(a,r),e.shape):a};const derB=()=>{const a=la(n,ua(e,"float32"));const r=fa(t.shape,s);return r.length>0?Fa(va(a,r),t.shape):a};return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Kt={kernelName:xn,gradFunc:n=>({x:()=>ka(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const At={kernelName:fn,inputsToSave:["indices"],gradFunc:(n,a)=>{const e=a[0];return{indices:()=>se(e.shape,"float32")}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Bt={kernelName:vn,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const It={kernelName:Fn,saveAllInputs:true,gradFunc:(n,a,e)=>{const{axis:t}=e;const s=re(n,t);return s.map((n=>()=>n))}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Vt={kernelName:Nn,inputsToSave:["x"],gradFunc:(n,a,e)=>{const t=a[0];const{paddings:s}=e;const r=s.map((n=>n[0]));return{x:()=>ee(n,r,t.shape)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Lt={kernelName:Sn,inputsToSave:["a","b"],outputsToSave:[true],gradFunc:(n,a)=>{const[e,t,s]=a;const r=e;const o=t;const c=xa(r.shape,o.shape);const derBase=()=>{const a=ua(o,"float32");let e=la(n,la(a,oe(r,ha(a,da(1)))));const t=fa(r.shape,c);t.length>0&&(e=va(e,t));return Fa(e,r.shape)};const derExp=()=>{const a=Qa(r,0);const e=$a(a,ce(r),Na(r));let t=la(n,la(s,e));const u=fa(o.shape,c);u.length>0&&(t=va(t,u));return Fa(t,o.shape)};return{a:derBase,b:derExp}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Wt={kernelName:bn,inputsToSave:["x","alpha"],gradFunc:(n,a)=>{const[e,t]=a;const s=Qa(e,0);return{x:()=>$a(s,n,la(n,t)),alpha:()=>{let a=$a(s,Na(n),la(n,e));const r=fa(t.shape,n.shape);r.length>0&&(a=va(a,r));return Fa(a,t.shape)}}}};
/**
 * @license
 * Copyright 2022 Google Inc. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */function prodGradFn_(n,a,e){const t=n.shape.slice();t[e]=1;const s=Fa(a,t);const r=ue(n,e,true,false);const o=ue(n,e,true,true);const c=la(r,o);return la(s,c)}function prodsGradFn_(n,a,e){const t=n.shape.length;const s=t-e.length;const r=Ka(e,t);let o=n;r!=null&&(o=Ba(n,r));const c=o.shape.slice();const u=c.splice(t-e.length,e.length);const p=u.reduce(((n,a)=>n*a),1);c.push(p);const l=o.reshape(c);let i=prodGradFn_(l,a,s);i=i.reshape(o.shape);if(r!=null){const n=Ha(r);i=Ba(i,n)}return i}const Yt={kernelName:Tn,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{axis:s}=e;let r=[];r=s===void 0||s===null?t.shape.map(((n,a)=>a)):typeof s==="number"?[s]:s;return{x:()=>prodsGradFn_(t,n,r)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Zt={kernelName:Gn,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=xa(e.shape,t.shape);const derA=()=>{const a=ma(n,ua(t,"float32"));const r=fa(e.shape,s);return r.length>0?Fa(va(a,r),e.shape):a};const derB=()=>{let a=la(n,ua(e,"float32"));const r=fa(t.shape,s);r.length>0&&(a=Fa(va(a,r),t.shape));const o=ia(t);return ka(ma(a,ua(o,"float32")))};return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const qt={kernelName:yn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,ka(ia(e)))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ht={kernelName:Pn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;const t=la(Pa(e,6),pa(e));return{x:()=>la(n,ua(t,"float32"))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Jt={kernelName:_n,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(n,ua(pa(e),"float32"))}}};
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
 */const Qt={kernelName:$n,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>Fa(n,e.shape)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Xt={kernelName:En,inputsToSave:["images"],gradFunc:(n,a,e)=>{const[t]=a;const s={dy:n,images:t};const imagesDer=()=>g.runKernel(Rn,s,e);return{images:imagesDer}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ot={kernelName:Mn,inputsToSave:["images"],gradFunc:(n,a,e)=>{const[t]=a;const s={dy:n,images:t};const imagesDer=()=>g.runKernel(zn,s,e);return{images:imagesDer}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ut={kernelName:Dn,gradFunc:(n,a,e)=>{const{dims:t}=e;const s=Se(t,n.shape);return{x:()=>pe(n,s)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ns={kernelName:jn,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const as={kernelName:wn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ka(ma(n,la(oe(e,1.5),2)))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const es={kernelName:Cn,inputsToSave:["condition"],gradFunc:(n,a)=>{const[e]=a;return{condition:()=>ua(Na(e),"float32"),t:()=>la(n,ua(e,n.dtype)),e:()=>la(n,ua(le(e),n.dtype))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ts={kernelName:Kn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>{const a=Qa(e,da(0));const t=da(Te);const s=da(Ge);const r=la(n,s);const o=la(la(n,t),Wa(ua(e,"float32")));return $a(a,r,o)}}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ss={kernelName:An,outputsToSave:[true],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(n,la(e,ha(da(1),e)))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const rs={kernelName:Bn,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const os={kernelName:In,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(ie(ua(e,"float32")),n)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const cs={kernelName:Vn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(de(ua(e,"float32")),n)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const us={kernelName:Ln,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{begin:s,size:r}=e;const o=t.shape;const[c,u]=ye(t,s,r);const p=[];for(let a=0;a<n.rank;a++)p.push([c[a],o[a]-c[a]-u[a]]);return{x:()=>he(n,p)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ps={kernelName:Wn,outputsToSave:[true],gradFunc:(n,a,e)=>{const[t]=a;const{dim:s}=e;const r=true;const o=la(n,t);return{logits:()=>ha(o,la(va(o,[s],r),t))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ls={kernelName:Yn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(n,ge(e))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const is={kernelName:Zn,gradFunc:(n,a,e)=>{const{blockShape:t,paddings:s}=e;return{x:()=>me(n,t,s)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ds={kernelName:qn,gradFunc:(n,a,e)=>{const{axis:t}=e;return{x:()=>ke(n,t)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const hs={kernelName:Hn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,la(ga(ua(e,"float32")),2))}}};
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
 */const gs={kernelName:Jn,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(n,la(ua(e,"float32"),2))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ms={kernelName:Qn,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=da(2);const derA=()=>la(n,la(s,ha(e,t)));const derB=()=>la(n,la(s,ha(t,e)));return{a:derA,b:derB}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ks={kernelName:Xn,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const xs={kernelName:On,inputsToSave:["a","b"],gradFunc:(n,a)=>{const[e,t]=a;const s=xa(e.shape,t.shape);const derA=()=>{let a=n;const t=fa(e.shape,s);t.length>0&&(a=va(a,t));return Fa(a,e.shape)};const derB=()=>{let a=n;const e=fa(t.shape,s);e.length>0&&(a=va(a,e));return Fa(ka(a),t.shape)};return{a:derA,b:derB}}};
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
 */const fs={kernelName:Un,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const s=t.shape.slice();const{axis:r}=e;const o=Se(r,t.shape);o.forEach((n=>{s[n]=1}));const c=Fa(n,s);const u=la(c,ae(t.shape,"float32"));return{x:()=>u}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const vs={kernelName:na,inputsToSave:["x"],gradFunc:(n,a)=>{const[e]=a;return{x:()=>ma(n,ia(ie(e)))}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Fs={kernelName:aa,outputsToSave:[true],gradFunc:(n,a)=>{const[e]=a;return{x:()=>la(ha(da(1),ia(e)),n)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ns={kernelName:ea,inputsToSave:["x"],gradFunc:(n,a,e)=>{const[t]=a;const{reps:s}=e;const derX=()=>{let a=Na(t);if(t.rank===1)for(let e=0;e<s[0];++e)a=Sa(a,ee(n,[e*t.shape[0]],[t.shape[0]]));else if(t.rank===2)for(let e=0;e<s[0];++e)for(let r=0;r<s[1];++r)a=Sa(a,ee(n,[e*t.shape[0],r*t.shape[1]],[t.shape[0],t.shape[1]]));else if(t.rank===3)for(let e=0;e<s[0];++e)for(let r=0;r<s[1];++r)for(let o=0;o<s[2];++o)a=Sa(a,ee(n,[e*t.shape[0],r*t.shape[1],o*t.shape[2]],[t.shape[0],t.shape[1],t.shape[2]]));else{if(t.rank!==4)throw new Error(`Gradient for tile operation is not implemented for rank-${t.rank} tensors yet.`);for(let e=0;e<s[0];++e)for(let r=0;r<s[1];++r)for(let o=0;o<s[2];++o)for(let c=0;c<s[3];++c)a=Sa(a,ee(n,[e*t.shape[0],r*t.shape[1],o*t.shape[2],c*t.shape[3]],[t.shape[0],t.shape[1],t.shape[2],t.shape[3]]))}return a};return{x:derX}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ss={kernelName:ta,gradFunc:(n,a,e)=>{const t=e;const{perm:s}=t;const r=Ha(s);return{x:()=>Ba(n,r)}}};
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
 */const bs={kernelName:sa,gradFunc:(n,a,e)=>{const t=e;const{axis:s}=t;return{value:()=>Ja(n,s)}}};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Ts={kernelName:ra,inputsToSave:["segmentIds"],gradFunc:(n,a)=>{const[e]=a;const derX=()=>gatherDropNegatives(n,e);return{x:derX}}};function gatherDropNegatives(n,a){const e=xe(a,Na(a));const t=fe(n,e);let s=ya(a,da(0,"int32"));const r=t.rank-s.rank;for(let n=0;n<r;++n)s=ve(s,n+1);s=_a(s,ae(t.shape,"bool"));const o=Na(t);return $a(s,t,o)}
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const Gs={kernelName:oa,gradFunc:n=>({x:()=>Na(n)})};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */const ys=[Pe,_e,$e,Ee,Re,Me,ze,De,je,we,Ce,Ke,Be,Ve,Le,We,Ye,Ze,qe,He,Je,Qe,Oe,Xe,nt,at,et,tt,st,rt,Zt,ot,ct,ut,pt,lt,dt,it,ht,gt,mt,kt,xt,ft,vt,Ft,Nt,St,bt,Gt,yt,yt,Pt,$t,Rt,Mt,zt,Dt,jt,wt,Ct,Kt,At,Bt,It,Vt,Vt,Lt,Wt,Yt,qt,Ht,Jt,Qt,Xt,Ot,Ut,ns,as,es,ts,ss,rs,os,cs,us,ps,ls,is,is,ds,ds,hs,ms,gs,ks,xs,fs,vs,Fs,Ns,Ss,bs,Ts,Gs];for(const n of ys)ca(n);

