import*as e from"@tensorflow/tfjs";import*as t from"util";import*as r from"os";import*as o from"google-protobuf";import n from"process";import*as a from"@tensorflow/tfjs-core";import*as i from"path";import*as s from"progress";import l from"./io/file_system.js";import*as p from"@mapbox/node-pre-gyp";import*as u from"fs";import"buffer";var f=e;try{"default"in e&&(f=e.default)}catch(e){}var d={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(d,"__esModule",{value:true});d._fusedMatMulConfig=void 0;var c=f;d._fusedMatMulConfig={kernelName:c._FusedMatMul,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b,n=t.bias,a=t.preluActivationWeights;var i=e.backend;var s=e.attrs,l=s.transposeA,p=s.transposeB,u=s.activation,f=s.leakyreluAlpha;return(0,c.tidy)((function(){var e=(0,c.matMul)(r,o,l,p);n!=null&&(e=(0,c.add)(e,n));e=i.applyActivation(e,u,a,f);return e}))}};var g=e;try{"default"in e&&(g=e.default)}catch(e){}var v=r;try{"default"in r&&(v=r.default)}catch(e){}var y={};
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
 */Object.defineProperty(y,"__esModule",{value:true});y.encodeInt32ArrayAsInt64=y.Int64Scalar=void 0;var h=g;var w=v;var m=2147483648;var T=function(){function Int64Scalar(e){this.value=e;this.dtype="int64";this.rank=1;if(Int64Scalar.endiannessOkay_==null){if((0,w.endianness)()!=="LE")throw new Error("Int64Scalar does not support endianness of this machine: "+"".concat((0,w.endianness)()));Int64Scalar.endiannessOkay_=true}h.util.assert(e>-m&&e<m-1,(function(){return"Got a value outside of the bound of values supported for int64 "+"dtype ([-".concat(m,", ").concat(m-1,"]): ").concat(e)}));h.util.assert(Number.isInteger(e),(function(){return"Expected value to be an integer, but got ".concat(e)}));var t=e>=0?0:-1;var r=e%m;this.valueArray_=new Int32Array([r,t])}Object.defineProperty(Int64Scalar.prototype,"shape",{get:function(){return[]},enumerable:false,configurable:true});Object.defineProperty(Int64Scalar.prototype,"valueArray",{get:function(){return this.valueArray_},enumerable:false,configurable:true});return Int64Scalar}();y.Int64Scalar=T;function encodeInt32ArrayAsInt64(e){if((0,w.endianness)()!=="LE")throw new Error("Int64Scalar does not support endianness of this machine: "+"".concat((0,w.endianness)()));var t=new Int32Array(e.length*2);for(var r=0;r<e.length;r++)t[r*2]=e[r];return t}y.encodeInt32ArrayAsInt64=encodeInt32ArrayAsInt64;var b=o;try{"default"in o&&(b=o.default)}catch(e){}var D=typeof globalThis!=="undefined"?globalThis:typeof self!=="undefined"?self:global;var F={};var M=b;var S=M;var k=Function("return this")();S.exportSymbol("proto.tensorflow.Any",null,k);S.exportSymbol("proto.tensorflow.AssetFileDef",null,k);S.exportSymbol("proto.tensorflow.AttrValue",null,k);S.exportSymbol("proto.tensorflow.AttrValue.ListValue",null,k);S.exportSymbol("proto.tensorflow.AttrValue.ValueCase",null,k);S.exportSymbol("proto.tensorflow.CollectionDef",null,k);S.exportSymbol("proto.tensorflow.CollectionDef.AnyList",null,k);S.exportSymbol("proto.tensorflow.CollectionDef.BytesList",null,k);S.exportSymbol("proto.tensorflow.CollectionDef.FloatList",null,k);S.exportSymbol("proto.tensorflow.CollectionDef.Int64List",null,k);S.exportSymbol("proto.tensorflow.CollectionDef.KindCase",null,k);S.exportSymbol("proto.tensorflow.CollectionDef.NodeList",null,k);S.exportSymbol("proto.tensorflow.DataClass",null,k);S.exportSymbol("proto.tensorflow.DataType",null,k);S.exportSymbol("proto.tensorflow.FunctionDef",null,k);S.exportSymbol("proto.tensorflow.FunctionDefLibrary",null,k);S.exportSymbol("proto.tensorflow.GradientDef",null,k);S.exportSymbol("proto.tensorflow.GraphDef",null,k);S.exportSymbol("proto.tensorflow.HistogramPluginData",null,k);S.exportSymbol("proto.tensorflow.HistogramProto",null,k);S.exportSymbol("proto.tensorflow.MetaGraphDef",null,k);S.exportSymbol("proto.tensorflow.MetaGraphDef.MetaInfoDef",null,k);S.exportSymbol("proto.tensorflow.NameAttrList",null,k);S.exportSymbol("proto.tensorflow.NodeDef",null,k);S.exportSymbol("proto.tensorflow.OpDef",null,k);S.exportSymbol("proto.tensorflow.OpDef.ArgDef",null,k);S.exportSymbol("proto.tensorflow.OpDef.AttrDef",null,k);S.exportSymbol("proto.tensorflow.OpDef.OpDeprecation",null,k);S.exportSymbol("proto.tensorflow.OpList",null,k);S.exportSymbol("proto.tensorflow.SavedModel",null,k);S.exportSymbol("proto.tensorflow.SaverDef",null,k);S.exportSymbol("proto.tensorflow.SaverDef.CheckpointFormatVersion",null,k);S.exportSymbol("proto.tensorflow.SignatureDef",null,k);S.exportSymbol("proto.tensorflow.Summary",null,k);S.exportSymbol("proto.tensorflow.Summary.Audio",null,k);S.exportSymbol("proto.tensorflow.Summary.Image",null,k);S.exportSymbol("proto.tensorflow.Summary.Value",null,k);S.exportSymbol("proto.tensorflow.Summary.Value.ValueCase",null,k);S.exportSymbol("proto.tensorflow.SummaryDescription",null,k);S.exportSymbol("proto.tensorflow.SummaryMetadata",null,k);S.exportSymbol("proto.tensorflow.SummaryMetadata.PluginData",null,k);S.exportSymbol("proto.tensorflow.Tensor",null,k);S.exportSymbol("proto.tensorflow.TensorInfo",null,k);S.exportSymbol("proto.tensorflow.TensorInfo.CooSparse",null,k);S.exportSymbol("proto.tensorflow.TensorInfo.EncodingCase",null,k);S.exportSymbol("proto.tensorflow.TensorShape",null,k);S.exportSymbol("proto.tensorflow.TensorShape.Dim",null,k);S.exportSymbol("proto.tensorflow.VersionDef",null,k);
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */proto.tensorflow.Any=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.Any,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.Any.displayName="proto.tensorflow.Any")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.TensorShape=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.TensorShape.repeatedFields_,null)};S.inherits(proto.tensorflow.TensorShape,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.TensorShape.displayName="proto.tensorflow.TensorShape")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.TensorShape.Dim=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.TensorShape.Dim,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.TensorShape.Dim.displayName="proto.tensorflow.TensorShape.Dim")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.Tensor=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.Tensor.repeatedFields_,null)};S.inherits(proto.tensorflow.Tensor,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.Tensor.displayName="proto.tensorflow.Tensor")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.AttrValue=function(e){M.Message.initialize(this||D,e,0,-1,null,proto.tensorflow.AttrValue.oneofGroups_)};S.inherits(proto.tensorflow.AttrValue,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.AttrValue.displayName="proto.tensorflow.AttrValue")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.AttrValue.ListValue=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.AttrValue.ListValue.repeatedFields_,null)};S.inherits(proto.tensorflow.AttrValue.ListValue,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.AttrValue.ListValue.displayName="proto.tensorflow.AttrValue.ListValue")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.NameAttrList=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.NameAttrList,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.NameAttrList.displayName="proto.tensorflow.NameAttrList")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.NodeDef=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.NodeDef.repeatedFields_,null)};S.inherits(proto.tensorflow.NodeDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.NodeDef.displayName="proto.tensorflow.NodeDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.VersionDef=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.VersionDef.repeatedFields_,null)};S.inherits(proto.tensorflow.VersionDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.VersionDef.displayName="proto.tensorflow.VersionDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.GraphDef=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.GraphDef.repeatedFields_,null)};S.inherits(proto.tensorflow.GraphDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.GraphDef.displayName="proto.tensorflow.GraphDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.CollectionDef=function(e){M.Message.initialize(this||D,e,0,-1,null,proto.tensorflow.CollectionDef.oneofGroups_)};S.inherits(proto.tensorflow.CollectionDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.CollectionDef.displayName="proto.tensorflow.CollectionDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.CollectionDef.NodeList=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.CollectionDef.NodeList.repeatedFields_,null)};S.inherits(proto.tensorflow.CollectionDef.NodeList,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.CollectionDef.NodeList.displayName="proto.tensorflow.CollectionDef.NodeList")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.CollectionDef.BytesList=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.CollectionDef.BytesList.repeatedFields_,null)};S.inherits(proto.tensorflow.CollectionDef.BytesList,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.CollectionDef.BytesList.displayName="proto.tensorflow.CollectionDef.BytesList")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.CollectionDef.Int64List=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.CollectionDef.Int64List.repeatedFields_,null)};S.inherits(proto.tensorflow.CollectionDef.Int64List,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.CollectionDef.Int64List.displayName="proto.tensorflow.CollectionDef.Int64List")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.CollectionDef.FloatList=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.CollectionDef.FloatList.repeatedFields_,null)};S.inherits(proto.tensorflow.CollectionDef.FloatList,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.CollectionDef.FloatList.displayName="proto.tensorflow.CollectionDef.FloatList")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.CollectionDef.AnyList=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.CollectionDef.AnyList.repeatedFields_,null)};S.inherits(proto.tensorflow.CollectionDef.AnyList,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.CollectionDef.AnyList.displayName="proto.tensorflow.CollectionDef.AnyList")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.SaverDef=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.SaverDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.SaverDef.displayName="proto.tensorflow.SaverDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.TensorInfo=function(e){M.Message.initialize(this||D,e,0,-1,null,proto.tensorflow.TensorInfo.oneofGroups_)};S.inherits(proto.tensorflow.TensorInfo,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.TensorInfo.displayName="proto.tensorflow.TensorInfo")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.TensorInfo.CooSparse=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.TensorInfo.CooSparse,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.TensorInfo.CooSparse.displayName="proto.tensorflow.TensorInfo.CooSparse")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.SignatureDef=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.SignatureDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.SignatureDef.displayName="proto.tensorflow.SignatureDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.AssetFileDef=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.AssetFileDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.AssetFileDef.displayName="proto.tensorflow.AssetFileDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.OpDef=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.OpDef.repeatedFields_,null)};S.inherits(proto.tensorflow.OpDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.OpDef.displayName="proto.tensorflow.OpDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.OpDef.ArgDef=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.OpDef.ArgDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.OpDef.ArgDef.displayName="proto.tensorflow.OpDef.ArgDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.OpDef.AttrDef=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.OpDef.AttrDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.OpDef.AttrDef.displayName="proto.tensorflow.OpDef.AttrDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.OpDef.OpDeprecation=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.OpDef.OpDeprecation,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.OpDef.OpDeprecation.displayName="proto.tensorflow.OpDef.OpDeprecation")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.OpList=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.OpList.repeatedFields_,null)};S.inherits(proto.tensorflow.OpList,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.OpList.displayName="proto.tensorflow.OpList")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.MetaGraphDef=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.MetaGraphDef.repeatedFields_,null)};S.inherits(proto.tensorflow.MetaGraphDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.MetaGraphDef.displayName="proto.tensorflow.MetaGraphDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.MetaGraphDef.MetaInfoDef=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.MetaGraphDef.MetaInfoDef.repeatedFields_,null)};S.inherits(proto.tensorflow.MetaGraphDef.MetaInfoDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.MetaGraphDef.MetaInfoDef.displayName="proto.tensorflow.MetaGraphDef.MetaInfoDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.SavedModel=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.SavedModel.repeatedFields_,null)};S.inherits(proto.tensorflow.SavedModel,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.SavedModel.displayName="proto.tensorflow.SavedModel")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.FunctionDefLibrary=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.FunctionDefLibrary.repeatedFields_,null)};S.inherits(proto.tensorflow.FunctionDefLibrary,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.FunctionDefLibrary.displayName="proto.tensorflow.FunctionDefLibrary")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.FunctionDef=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.FunctionDef.repeatedFields_,null)};S.inherits(proto.tensorflow.FunctionDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.FunctionDef.displayName="proto.tensorflow.FunctionDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.GradientDef=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.GradientDef,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.GradientDef.displayName="proto.tensorflow.GradientDef")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.SummaryDescription=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.SummaryDescription,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.SummaryDescription.displayName="proto.tensorflow.SummaryDescription")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.HistogramProto=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.HistogramProto.repeatedFields_,null)};S.inherits(proto.tensorflow.HistogramProto,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.HistogramProto.displayName="proto.tensorflow.HistogramProto")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.SummaryMetadata=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.SummaryMetadata,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.SummaryMetadata.displayName="proto.tensorflow.SummaryMetadata")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.SummaryMetadata.PluginData=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.SummaryMetadata.PluginData,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.SummaryMetadata.PluginData.displayName="proto.tensorflow.SummaryMetadata.PluginData")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.Summary=function(e){M.Message.initialize(this||D,e,0,-1,proto.tensorflow.Summary.repeatedFields_,null)};S.inherits(proto.tensorflow.Summary,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.Summary.displayName="proto.tensorflow.Summary")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.Summary.Image=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.Summary.Image,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.Summary.Image.displayName="proto.tensorflow.Summary.Image")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.Summary.Audio=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.Summary.Audio,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.Summary.Audio.displayName="proto.tensorflow.Summary.Audio")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.Summary.Value=function(e){M.Message.initialize(this||D,e,0,-1,null,proto.tensorflow.Summary.Value.oneofGroups_)};S.inherits(proto.tensorflow.Summary.Value,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.Summary.Value.displayName="proto.tensorflow.Summary.Value")
/**
 * Generated by JsPbCodeGenerator.
 * @param {Array=} opt_data Optional initial data array, typically from a
 * server response, or constructed directly in Javascript. The array is used
 * in place and becomes part of the constructed object. It is not cloned.
 * If no data is provided, the constructed object will be empty, but still
 * valid.
 * @extends {jspb.Message}
 * @constructor
 */;proto.tensorflow.HistogramPluginData=function(e){M.Message.initialize(this||D,e,0,-1,null,null)};S.inherits(proto.tensorflow.HistogramPluginData,M.Message);S.DEBUG&&!COMPILED&&(proto.tensorflow.HistogramPluginData.displayName="proto.tensorflow.HistogramPluginData");if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.Any.prototype.toObject=function(e){return proto.tensorflow.Any.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.Any} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.Any.toObject=function(e,t){var r={typeUrl:M.Message.getFieldWithDefault(t,1,""),value:t.getValue_asB64()};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.Any}
 */proto.tensorflow.Any.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.Any;return proto.tensorflow.Any.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.Any} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.Any}
 */proto.tensorflow.Any.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setTypeUrl(o);break;case 2:o=/** @type {!Uint8Array} */t.readBytes();e.setValue(o);break;default:t.skipField();break}}return e};proto.tensorflow.Any.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.Any.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.Any} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.Any.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getTypeUrl();r.length>0&&t.writeString(1,r);r=e.getValue_asU8();r.length>0&&t.writeBytes(2,r)};proto.tensorflow.Any.prototype.getTypeUrl=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.Any} returns this
 */proto.tensorflow.Any.prototype.setTypeUrl=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.Any.prototype.getValue=function(){/** @type {!(string|Uint8Array)} */
return M.Message.getFieldWithDefault(this||D,2,"")};proto.tensorflow.Any.prototype.getValue_asB64=function(){/** @type {string} */
return M.Message.bytesAsB64(this.getValue())};proto.tensorflow.Any.prototype.getValue_asU8=function(){/** @type {!Uint8Array} */
return M.Message.bytesAsU8(this.getValue())};
/**
 * @param {!(string|Uint8Array)} value
 * @return {!proto.tensorflow.Any} returns this
 */proto.tensorflow.Any.prototype.setValue=function(e){return M.Message.setProto3BytesField(this||D,2,e)};proto.tensorflow.TensorShape.repeatedFields_=[2];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.TensorShape.prototype.toObject=function(e){return proto.tensorflow.TensorShape.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.TensorShape} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.TensorShape.toObject=function(e,t){var r={dimList:M.Message.toObjectList(t.getDimList(),proto.tensorflow.TensorShape.Dim.toObject,e),unknownRank:M.Message.getBooleanFieldWithDefault(t,3,false)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.TensorShape}
 */proto.tensorflow.TensorShape.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.TensorShape;return proto.tensorflow.TensorShape.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.TensorShape} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.TensorShape}
 */proto.tensorflow.TensorShape.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 2:var o=new proto.tensorflow.TensorShape.Dim;t.readMessage(o,proto.tensorflow.TensorShape.Dim.deserializeBinaryFromReader);e.addDim(o);break;case 3:o=/** @type {boolean} */t.readBool();e.setUnknownRank(o);break;default:t.skipField();break}}return e};proto.tensorflow.TensorShape.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.TensorShape.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.TensorShape} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.TensorShape.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getDimList();r.length>0&&t.writeRepeatedMessage(2,r,proto.tensorflow.TensorShape.Dim.serializeBinaryToWriter);r=e.getUnknownRank();r&&t.writeBool(3,r)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.TensorShape.Dim.prototype.toObject=function(e){return proto.tensorflow.TensorShape.Dim.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.TensorShape.Dim} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.TensorShape.Dim.toObject=function(e,t){var r={size:M.Message.getFieldWithDefault(t,1,0),name:M.Message.getFieldWithDefault(t,2,"")};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.TensorShape.Dim}
 */proto.tensorflow.TensorShape.Dim.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.TensorShape.Dim;return proto.tensorflow.TensorShape.Dim.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.TensorShape.Dim} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.TensorShape.Dim}
 */proto.tensorflow.TensorShape.Dim.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readInt64();e.setSize(o);break;case 2:o=/** @type {string} */t.readString();e.setName(o);break;default:t.skipField();break}}return e};proto.tensorflow.TensorShape.Dim.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.TensorShape.Dim.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.TensorShape.Dim} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.TensorShape.Dim.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getSize();r!==0&&t.writeInt64(1,r);r=e.getName();r.length>0&&t.writeString(2,r)};proto.tensorflow.TensorShape.Dim.prototype.getSize=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.TensorShape.Dim} returns this
 */proto.tensorflow.TensorShape.Dim.prototype.setSize=function(e){return M.Message.setProto3IntField(this||D,1,e)};proto.tensorflow.TensorShape.Dim.prototype.getName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.TensorShape.Dim} returns this
 */proto.tensorflow.TensorShape.Dim.prototype.setName=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.TensorShape.prototype.getDimList=function(){/** @type{!Array<!proto.tensorflow.TensorShape.Dim>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.TensorShape.Dim,2)};
/**
 * @param {!Array<!proto.tensorflow.TensorShape.Dim>} value
 * @return {!proto.tensorflow.TensorShape} returns this
*/proto.tensorflow.TensorShape.prototype.setDimList=function(e){return M.Message.setRepeatedWrapperField(this||D,2,e)};
/**
 * @param {!proto.tensorflow.TensorShape.Dim=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.TensorShape.Dim}
 */proto.tensorflow.TensorShape.prototype.addDim=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,2,e,proto.tensorflow.TensorShape.Dim,t)};proto.tensorflow.TensorShape.prototype.clearDimList=function(){return this.setDimList([])};proto.tensorflow.TensorShape.prototype.getUnknownRank=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,3,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.TensorShape} returns this
 */proto.tensorflow.TensorShape.prototype.setUnknownRank=function(e){return M.Message.setProto3BooleanField(this||D,3,e)};proto.tensorflow.Tensor.repeatedFields_=[5,6,7,8,9,10,11,16,17];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.Tensor.prototype.toObject=function(e){return proto.tensorflow.Tensor.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.Tensor} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.Tensor.toObject=function(e,t){var r,o={dtype:M.Message.getFieldWithDefault(t,1,0),tensorShape:(r=t.getTensorShape())&&proto.tensorflow.TensorShape.toObject(e,r),versionNumber:M.Message.getFieldWithDefault(t,3,0),tensorContent:t.getTensorContent_asB64(),floatValList:(r=M.Message.getRepeatedFloatingPointField(t,5))==null?void 0:r,doubleValList:(r=M.Message.getRepeatedFloatingPointField(t,6))==null?void 0:r,intValList:(r=M.Message.getRepeatedField(t,7))==null?void 0:r,stringValList:t.getStringValList_asB64(),scomplexValList:(r=M.Message.getRepeatedFloatingPointField(t,9))==null?void 0:r,int64ValList:(r=M.Message.getRepeatedField(t,10))==null?void 0:r,boolValList:(r=M.Message.getRepeatedBooleanField(t,11))==null?void 0:r,uint32ValList:(r=M.Message.getRepeatedField(t,16))==null?void 0:r,uint64ValList:(r=M.Message.getRepeatedField(t,17))==null?void 0:r};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.Tensor}
 */proto.tensorflow.Tensor.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.Tensor;return proto.tensorflow.Tensor.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.Tensor} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.Tensor}
 */proto.tensorflow.Tensor.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {!proto.tensorflow.DataType} */t.readEnum();e.setDtype(o);break;case 2:o=new proto.tensorflow.TensorShape;t.readMessage(o,proto.tensorflow.TensorShape.deserializeBinaryFromReader);e.setTensorShape(o);break;case 3:o=/** @type {number} */t.readInt32();e.setVersionNumber(o);break;case 4:o=/** @type {!Uint8Array} */t.readBytes();e.setTensorContent(o);break;case 5:var n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedFloat():[t.readFloat()];for(var a=0;a<n.length;a++)e.addFloatVal(n[a]);break;case 6:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedDouble():[t.readDouble()];for(a=0;a<n.length;a++)e.addDoubleVal(n[a]);break;case 7:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedInt32():[t.readInt32()];for(a=0;a<n.length;a++)e.addIntVal(n[a]);break;case 8:o=/** @type {!Uint8Array} */t.readBytes();e.addStringVal(o);break;case 9:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedFloat():[t.readFloat()];for(a=0;a<n.length;a++)e.addScomplexVal(n[a]);break;case 10:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedInt64():[t.readInt64()];for(a=0;a<n.length;a++)e.addInt64Val(n[a]);break;case 11:n=/** @type {!Array<boolean>} */t.isDelimited()?t.readPackedBool():[t.readBool()];for(a=0;a<n.length;a++)e.addBoolVal(n[a]);break;case 16:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedUint32():[t.readUint32()];for(a=0;a<n.length;a++)e.addUint32Val(n[a]);break;case 17:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedUint64():[t.readUint64()];for(a=0;a<n.length;a++)e.addUint64Val(n[a]);break;default:t.skipField();break}}return e};proto.tensorflow.Tensor.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.Tensor.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.Tensor} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.Tensor.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getDtype();r!==0&&t.writeEnum(1,r);r=e.getTensorShape();r!=null&&t.writeMessage(2,r,proto.tensorflow.TensorShape.serializeBinaryToWriter);r=e.getVersionNumber();r!==0&&t.writeInt32(3,r);r=e.getTensorContent_asU8();r.length>0&&t.writeBytes(4,r);r=e.getFloatValList();r.length>0&&t.writePackedFloat(5,r);r=e.getDoubleValList();r.length>0&&t.writePackedDouble(6,r);r=e.getIntValList();r.length>0&&t.writePackedInt32(7,r);r=e.getStringValList_asU8();r.length>0&&t.writeRepeatedBytes(8,r);r=e.getScomplexValList();r.length>0&&t.writePackedFloat(9,r);r=e.getInt64ValList();r.length>0&&t.writePackedInt64(10,r);r=e.getBoolValList();r.length>0&&t.writePackedBool(11,r);r=e.getUint32ValList();r.length>0&&t.writePackedUint32(16,r);r=e.getUint64ValList();r.length>0&&t.writePackedUint64(17,r)};proto.tensorflow.Tensor.prototype.getDtype=function(){/** @type {!proto.tensorflow.DataType} */
return M.Message.getFieldWithDefault(this||D,1,0)};
/**
 * @param {!proto.tensorflow.DataType} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setDtype=function(e){return M.Message.setProto3EnumField(this||D,1,e)};proto.tensorflow.Tensor.prototype.getTensorShape=function(){/** @type{?proto.tensorflow.TensorShape} */
return M.Message.getWrapperField(this||D,proto.tensorflow.TensorShape,2)};
/**
 * @param {?proto.tensorflow.TensorShape|undefined} value
 * @return {!proto.tensorflow.Tensor} returns this
*/proto.tensorflow.Tensor.prototype.setTensorShape=function(e){return M.Message.setWrapperField(this||D,2,e)};proto.tensorflow.Tensor.prototype.clearTensorShape=function(){return this.setTensorShape(void 0)};proto.tensorflow.Tensor.prototype.hasTensorShape=function(){return M.Message.getField(this||D,2)!=null};proto.tensorflow.Tensor.prototype.getVersionNumber=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,3,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setVersionNumber=function(e){return M.Message.setProto3IntField(this||D,3,e)};proto.tensorflow.Tensor.prototype.getTensorContent=function(){/** @type {!(string|Uint8Array)} */
return M.Message.getFieldWithDefault(this||D,4,"")};proto.tensorflow.Tensor.prototype.getTensorContent_asB64=function(){/** @type {string} */
return M.Message.bytesAsB64(this.getTensorContent())};proto.tensorflow.Tensor.prototype.getTensorContent_asU8=function(){/** @type {!Uint8Array} */
return M.Message.bytesAsU8(this.getTensorContent())};
/**
 * @param {!(string|Uint8Array)} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setTensorContent=function(e){return M.Message.setProto3BytesField(this||D,4,e)};proto.tensorflow.Tensor.prototype.getFloatValList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedFloatingPointField(this||D,5)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setFloatValList=function(e){return M.Message.setField(this||D,5,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addFloatVal=function(e,t){return M.Message.addToRepeatedField(this||D,5,e,t)};proto.tensorflow.Tensor.prototype.clearFloatValList=function(){return this.setFloatValList([])};proto.tensorflow.Tensor.prototype.getDoubleValList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedFloatingPointField(this||D,6)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setDoubleValList=function(e){return M.Message.setField(this||D,6,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addDoubleVal=function(e,t){return M.Message.addToRepeatedField(this||D,6,e,t)};proto.tensorflow.Tensor.prototype.clearDoubleValList=function(){return this.setDoubleValList([])};proto.tensorflow.Tensor.prototype.getIntValList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedField(this||D,7)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setIntValList=function(e){return M.Message.setField(this||D,7,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addIntVal=function(e,t){return M.Message.addToRepeatedField(this||D,7,e,t)};proto.tensorflow.Tensor.prototype.clearIntValList=function(){return this.setIntValList([])};proto.tensorflow.Tensor.prototype.getStringValList=function(){/** @type {!(Array<!Uint8Array>|Array<string>)} */
return M.Message.getRepeatedField(this||D,8)};proto.tensorflow.Tensor.prototype.getStringValList_asB64=function(){/** @type {!Array<string>} */
return M.Message.bytesListAsB64(this.getStringValList())};proto.tensorflow.Tensor.prototype.getStringValList_asU8=function(){/** @type {!Array<!Uint8Array>} */
return M.Message.bytesListAsU8(this.getStringValList())};
/**
 * @param {!(Array<!Uint8Array>|Array<string>)} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setStringValList=function(e){return M.Message.setField(this||D,8,e||[])};
/**
 * @param {!(string|Uint8Array)} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addStringVal=function(e,t){return M.Message.addToRepeatedField(this||D,8,e,t)};proto.tensorflow.Tensor.prototype.clearStringValList=function(){return this.setStringValList([])};proto.tensorflow.Tensor.prototype.getScomplexValList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedFloatingPointField(this||D,9)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setScomplexValList=function(e){return M.Message.setField(this||D,9,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addScomplexVal=function(e,t){return M.Message.addToRepeatedField(this||D,9,e,t)};proto.tensorflow.Tensor.prototype.clearScomplexValList=function(){return this.setScomplexValList([])};proto.tensorflow.Tensor.prototype.getInt64ValList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedField(this||D,10)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setInt64ValList=function(e){return M.Message.setField(this||D,10,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addInt64Val=function(e,t){return M.Message.addToRepeatedField(this||D,10,e,t)};proto.tensorflow.Tensor.prototype.clearInt64ValList=function(){return this.setInt64ValList([])};proto.tensorflow.Tensor.prototype.getBoolValList=function(){/** @type {!Array<boolean>} */
return M.Message.getRepeatedBooleanField(this||D,11)};
/**
 * @param {!Array<boolean>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setBoolValList=function(e){return M.Message.setField(this||D,11,e||[])};
/**
 * @param {boolean} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addBoolVal=function(e,t){return M.Message.addToRepeatedField(this||D,11,e,t)};proto.tensorflow.Tensor.prototype.clearBoolValList=function(){return this.setBoolValList([])};proto.tensorflow.Tensor.prototype.getUint32ValList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedField(this||D,16)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setUint32ValList=function(e){return M.Message.setField(this||D,16,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addUint32Val=function(e,t){return M.Message.addToRepeatedField(this||D,16,e,t)};proto.tensorflow.Tensor.prototype.clearUint32ValList=function(){return this.setUint32ValList([])};proto.tensorflow.Tensor.prototype.getUint64ValList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedField(this||D,17)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.setUint64ValList=function(e){return M.Message.setField(this||D,17,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor} returns this
 */proto.tensorflow.Tensor.prototype.addUint64Val=function(e,t){return M.Message.addToRepeatedField(this||D,17,e,t)};proto.tensorflow.Tensor.prototype.clearUint64ValList=function(){return this.setUint64ValList([])};proto.tensorflow.AttrValue.oneofGroups_=[[1,2,3,4,5,6,7,8,9,10]];proto.tensorflow.AttrValue.ValueCase={VALUE_NOT_SET:0,LIST:1,S:2,I:3,F:4,B:5,TYPE:6,SHAPE:7,TENSOR:8,PLACEHOLDER:9,FUNC:10};proto.tensorflow.AttrValue.prototype.getValueCase=function(){/** @type {proto.tensorflow.AttrValue.ValueCase} */
return M.Message.computeOneofCase(this||D,proto.tensorflow.AttrValue.oneofGroups_[0])};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.AttrValue.prototype.toObject=function(e){return proto.tensorflow.AttrValue.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.AttrValue} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.AttrValue.toObject=function(e,t){var r,o={list:(r=t.getList())&&proto.tensorflow.AttrValue.ListValue.toObject(e,r),s:t.getS_asB64(),i:M.Message.getFieldWithDefault(t,3,0),f:M.Message.getFloatingPointFieldWithDefault(t,4,0),b:M.Message.getBooleanFieldWithDefault(t,5,false),type:M.Message.getFieldWithDefault(t,6,0),shape:(r=t.getShape())&&proto.tensorflow.TensorShape.toObject(e,r),tensor:(r=t.getTensor())&&proto.tensorflow.Tensor.toObject(e,r),placeholder:M.Message.getFieldWithDefault(t,9,""),func:(r=t.getFunc())&&proto.tensorflow.NameAttrList.toObject(e,r)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.AttrValue}
 */proto.tensorflow.AttrValue.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.AttrValue;return proto.tensorflow.AttrValue.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.AttrValue} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.AttrValue}
 */proto.tensorflow.AttrValue.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.AttrValue.ListValue;t.readMessage(o,proto.tensorflow.AttrValue.ListValue.deserializeBinaryFromReader);e.setList(o);break;case 2:o=/** @type {!Uint8Array} */t.readBytes();e.setS(o);break;case 3:o=/** @type {number} */t.readInt64();e.setI(o);break;case 4:o=/** @type {number} */t.readFloat();e.setF(o);break;case 5:o=/** @type {boolean} */t.readBool();e.setB(o);break;case 6:o=/** @type {!proto.tensorflow.DataType} */t.readEnum();e.setType(o);break;case 7:o=new proto.tensorflow.TensorShape;t.readMessage(o,proto.tensorflow.TensorShape.deserializeBinaryFromReader);e.setShape(o);break;case 8:o=new proto.tensorflow.Tensor;t.readMessage(o,proto.tensorflow.Tensor.deserializeBinaryFromReader);e.setTensor(o);break;case 9:o=/** @type {string} */t.readString();e.setPlaceholder(o);break;case 10:o=new proto.tensorflow.NameAttrList;t.readMessage(o,proto.tensorflow.NameAttrList.deserializeBinaryFromReader);e.setFunc(o);break;default:t.skipField();break}}return e};proto.tensorflow.AttrValue.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.AttrValue.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.AttrValue} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.AttrValue.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getList();r!=null&&t.writeMessage(1,r,proto.tensorflow.AttrValue.ListValue.serializeBinaryToWriter);r=/** @type {!(string|Uint8Array)} */M.Message.getField(e,2);r!=null&&t.writeBytes(2,r);r=/** @type {number} */M.Message.getField(e,3);r!=null&&t.writeInt64(3,r);r=/** @type {number} */M.Message.getField(e,4);r!=null&&t.writeFloat(4,r);r=/** @type {boolean} */M.Message.getField(e,5);r!=null&&t.writeBool(5,r);r=/** @type {!proto.tensorflow.DataType} */M.Message.getField(e,6);r!=null&&t.writeEnum(6,r);r=e.getShape();r!=null&&t.writeMessage(7,r,proto.tensorflow.TensorShape.serializeBinaryToWriter);r=e.getTensor();r!=null&&t.writeMessage(8,r,proto.tensorflow.Tensor.serializeBinaryToWriter);r=/** @type {string} */M.Message.getField(e,9);r!=null&&t.writeString(9,r);r=e.getFunc();r!=null&&t.writeMessage(10,r,proto.tensorflow.NameAttrList.serializeBinaryToWriter)};proto.tensorflow.AttrValue.ListValue.repeatedFields_=[2,3,4,5,6,7,8,9];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.AttrValue.ListValue.prototype.toObject=function(e){return proto.tensorflow.AttrValue.ListValue.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.AttrValue.ListValue} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.AttrValue.ListValue.toObject=function(e,t){var r,o={sList:t.getSList_asB64(),iList:(r=M.Message.getRepeatedField(t,3))==null?void 0:r,fList:(r=M.Message.getRepeatedFloatingPointField(t,4))==null?void 0:r,bList:(r=M.Message.getRepeatedBooleanField(t,5))==null?void 0:r,typeList:(r=M.Message.getRepeatedField(t,6))==null?void 0:r,shapeList:M.Message.toObjectList(t.getShapeList(),proto.tensorflow.TensorShape.toObject,e),tensorList:M.Message.toObjectList(t.getTensorList(),proto.tensorflow.Tensor.toObject,e),funcList:M.Message.toObjectList(t.getFuncList(),proto.tensorflow.NameAttrList.toObject,e)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.AttrValue.ListValue}
 */proto.tensorflow.AttrValue.ListValue.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.AttrValue.ListValue;return proto.tensorflow.AttrValue.ListValue.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.AttrValue.ListValue} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.AttrValue.ListValue}
 */proto.tensorflow.AttrValue.ListValue.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 2:var o=/** @type {!Uint8Array} */t.readBytes();e.addS(o);break;case 3:var n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedInt64():[t.readInt64()];for(var a=0;a<n.length;a++)e.addI(n[a]);break;case 4:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedFloat():[t.readFloat()];for(a=0;a<n.length;a++)e.addF(n[a]);break;case 5:n=/** @type {!Array<boolean>} */t.isDelimited()?t.readPackedBool():[t.readBool()];for(a=0;a<n.length;a++)e.addB(n[a]);break;case 6:n=/** @type {!Array<!proto.tensorflow.DataType>} */t.isDelimited()?t.readPackedEnum():[t.readEnum()];for(a=0;a<n.length;a++)e.addType(n[a]);break;case 7:o=new proto.tensorflow.TensorShape;t.readMessage(o,proto.tensorflow.TensorShape.deserializeBinaryFromReader);e.addShape(o);break;case 8:o=new proto.tensorflow.Tensor;t.readMessage(o,proto.tensorflow.Tensor.deserializeBinaryFromReader);e.addTensor(o);break;case 9:o=new proto.tensorflow.NameAttrList;t.readMessage(o,proto.tensorflow.NameAttrList.deserializeBinaryFromReader);e.addFunc(o);break;default:t.skipField();break}}return e};proto.tensorflow.AttrValue.ListValue.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.AttrValue.ListValue.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.AttrValue.ListValue} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.AttrValue.ListValue.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getSList_asU8();r.length>0&&t.writeRepeatedBytes(2,r);r=e.getIList();r.length>0&&t.writePackedInt64(3,r);r=e.getFList();r.length>0&&t.writePackedFloat(4,r);r=e.getBList();r.length>0&&t.writePackedBool(5,r);r=e.getTypeList();r.length>0&&t.writePackedEnum(6,r);r=e.getShapeList();r.length>0&&t.writeRepeatedMessage(7,r,proto.tensorflow.TensorShape.serializeBinaryToWriter);r=e.getTensorList();r.length>0&&t.writeRepeatedMessage(8,r,proto.tensorflow.Tensor.serializeBinaryToWriter);r=e.getFuncList();r.length>0&&t.writeRepeatedMessage(9,r,proto.tensorflow.NameAttrList.serializeBinaryToWriter)};proto.tensorflow.AttrValue.ListValue.prototype.getSList=function(){/** @type {!(Array<!Uint8Array>|Array<string>)} */
return M.Message.getRepeatedField(this||D,2)};proto.tensorflow.AttrValue.ListValue.prototype.getSList_asB64=function(){/** @type {!Array<string>} */
return M.Message.bytesListAsB64(this.getSList())};proto.tensorflow.AttrValue.ListValue.prototype.getSList_asU8=function(){/** @type {!Array<!Uint8Array>} */
return M.Message.bytesListAsU8(this.getSList())};
/**
 * @param {!(Array<!Uint8Array>|Array<string>)} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.setSList=function(e){return M.Message.setField(this||D,2,e||[])};
/**
 * @param {!(string|Uint8Array)} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.addS=function(e,t){return M.Message.addToRepeatedField(this||D,2,e,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearSList=function(){return this.setSList([])};proto.tensorflow.AttrValue.ListValue.prototype.getIList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedField(this||D,3)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.setIList=function(e){return M.Message.setField(this||D,3,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.addI=function(e,t){return M.Message.addToRepeatedField(this||D,3,e,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearIList=function(){return this.setIList([])};proto.tensorflow.AttrValue.ListValue.prototype.getFList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedFloatingPointField(this||D,4)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.setFList=function(e){return M.Message.setField(this||D,4,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.addF=function(e,t){return M.Message.addToRepeatedField(this||D,4,e,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearFList=function(){return this.setFList([])};proto.tensorflow.AttrValue.ListValue.prototype.getBList=function(){/** @type {!Array<boolean>} */
return M.Message.getRepeatedBooleanField(this||D,5)};
/**
 * @param {!Array<boolean>} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.setBList=function(e){return M.Message.setField(this||D,5,e||[])};
/**
 * @param {boolean} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.addB=function(e,t){return M.Message.addToRepeatedField(this||D,5,e,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearBList=function(){return this.setBList([])};proto.tensorflow.AttrValue.ListValue.prototype.getTypeList=function(){/** @type {!Array<!proto.tensorflow.DataType>} */
return M.Message.getRepeatedField(this||D,6)};
/**
 * @param {!Array<!proto.tensorflow.DataType>} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.setTypeList=function(e){return M.Message.setField(this||D,6,e||[])};
/**
 * @param {!proto.tensorflow.DataType} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
 */proto.tensorflow.AttrValue.ListValue.prototype.addType=function(e,t){return M.Message.addToRepeatedField(this||D,6,e,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearTypeList=function(){return this.setTypeList([])};proto.tensorflow.AttrValue.ListValue.prototype.getShapeList=function(){/** @type{!Array<!proto.tensorflow.TensorShape>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.TensorShape,7)};
/**
 * @param {!Array<!proto.tensorflow.TensorShape>} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
*/proto.tensorflow.AttrValue.ListValue.prototype.setShapeList=function(e){return M.Message.setRepeatedWrapperField(this||D,7,e)};
/**
 * @param {!proto.tensorflow.TensorShape=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.TensorShape}
 */proto.tensorflow.AttrValue.ListValue.prototype.addShape=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,7,e,proto.tensorflow.TensorShape,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearShapeList=function(){return this.setShapeList([])};proto.tensorflow.AttrValue.ListValue.prototype.getTensorList=function(){/** @type{!Array<!proto.tensorflow.Tensor>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.Tensor,8)};
/**
 * @param {!Array<!proto.tensorflow.Tensor>} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
*/proto.tensorflow.AttrValue.ListValue.prototype.setTensorList=function(e){return M.Message.setRepeatedWrapperField(this||D,8,e)};
/**
 * @param {!proto.tensorflow.Tensor=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Tensor}
 */proto.tensorflow.AttrValue.ListValue.prototype.addTensor=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,8,e,proto.tensorflow.Tensor,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearTensorList=function(){return this.setTensorList([])};proto.tensorflow.AttrValue.ListValue.prototype.getFuncList=function(){/** @type{!Array<!proto.tensorflow.NameAttrList>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.NameAttrList,9)};
/**
 * @param {!Array<!proto.tensorflow.NameAttrList>} value
 * @return {!proto.tensorflow.AttrValue.ListValue} returns this
*/proto.tensorflow.AttrValue.ListValue.prototype.setFuncList=function(e){return M.Message.setRepeatedWrapperField(this||D,9,e)};
/**
 * @param {!proto.tensorflow.NameAttrList=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.NameAttrList}
 */proto.tensorflow.AttrValue.ListValue.prototype.addFunc=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,9,e,proto.tensorflow.NameAttrList,t)};proto.tensorflow.AttrValue.ListValue.prototype.clearFuncList=function(){return this.setFuncList([])};proto.tensorflow.AttrValue.prototype.getList=function(){/** @type{?proto.tensorflow.AttrValue.ListValue} */
return M.Message.getWrapperField(this||D,proto.tensorflow.AttrValue.ListValue,1)};
/**
 * @param {?proto.tensorflow.AttrValue.ListValue|undefined} value
 * @return {!proto.tensorflow.AttrValue} returns this
*/proto.tensorflow.AttrValue.prototype.setList=function(e){return M.Message.setOneofWrapperField(this||D,1,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearList=function(){return this.setList(void 0)};proto.tensorflow.AttrValue.prototype.hasList=function(){return M.Message.getField(this||D,1)!=null};proto.tensorflow.AttrValue.prototype.getS=function(){/** @type {!(string|Uint8Array)} */
return M.Message.getFieldWithDefault(this||D,2,"")};proto.tensorflow.AttrValue.prototype.getS_asB64=function(){/** @type {string} */
return M.Message.bytesAsB64(this.getS())};proto.tensorflow.AttrValue.prototype.getS_asU8=function(){/** @type {!Uint8Array} */
return M.Message.bytesAsU8(this.getS())};
/**
 * @param {!(string|Uint8Array)} value
 * @return {!proto.tensorflow.AttrValue} returns this
 */proto.tensorflow.AttrValue.prototype.setS=function(e){return M.Message.setOneofField(this||D,2,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearS=function(){return M.Message.setOneofField(this||D,2,proto.tensorflow.AttrValue.oneofGroups_[0],void 0)};proto.tensorflow.AttrValue.prototype.hasS=function(){return M.Message.getField(this||D,2)!=null};proto.tensorflow.AttrValue.prototype.getI=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,3,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.AttrValue} returns this
 */proto.tensorflow.AttrValue.prototype.setI=function(e){return M.Message.setOneofField(this||D,3,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearI=function(){return M.Message.setOneofField(this||D,3,proto.tensorflow.AttrValue.oneofGroups_[0],void 0)};proto.tensorflow.AttrValue.prototype.hasI=function(){return M.Message.getField(this||D,3)!=null};proto.tensorflow.AttrValue.prototype.getF=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,4,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.AttrValue} returns this
 */proto.tensorflow.AttrValue.prototype.setF=function(e){return M.Message.setOneofField(this||D,4,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearF=function(){return M.Message.setOneofField(this||D,4,proto.tensorflow.AttrValue.oneofGroups_[0],void 0)};proto.tensorflow.AttrValue.prototype.hasF=function(){return M.Message.getField(this||D,4)!=null};proto.tensorflow.AttrValue.prototype.getB=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,5,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.AttrValue} returns this
 */proto.tensorflow.AttrValue.prototype.setB=function(e){return M.Message.setOneofField(this||D,5,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearB=function(){return M.Message.setOneofField(this||D,5,proto.tensorflow.AttrValue.oneofGroups_[0],void 0)};proto.tensorflow.AttrValue.prototype.hasB=function(){return M.Message.getField(this||D,5)!=null};proto.tensorflow.AttrValue.prototype.getType=function(){/** @type {!proto.tensorflow.DataType} */
return M.Message.getFieldWithDefault(this||D,6,0)};
/**
 * @param {!proto.tensorflow.DataType} value
 * @return {!proto.tensorflow.AttrValue} returns this
 */proto.tensorflow.AttrValue.prototype.setType=function(e){return M.Message.setOneofField(this||D,6,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearType=function(){return M.Message.setOneofField(this||D,6,proto.tensorflow.AttrValue.oneofGroups_[0],void 0)};proto.tensorflow.AttrValue.prototype.hasType=function(){return M.Message.getField(this||D,6)!=null};proto.tensorflow.AttrValue.prototype.getShape=function(){/** @type{?proto.tensorflow.TensorShape} */
return M.Message.getWrapperField(this||D,proto.tensorflow.TensorShape,7)};
/**
 * @param {?proto.tensorflow.TensorShape|undefined} value
 * @return {!proto.tensorflow.AttrValue} returns this
*/proto.tensorflow.AttrValue.prototype.setShape=function(e){return M.Message.setOneofWrapperField(this||D,7,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearShape=function(){return this.setShape(void 0)};proto.tensorflow.AttrValue.prototype.hasShape=function(){return M.Message.getField(this||D,7)!=null};proto.tensorflow.AttrValue.prototype.getTensor=function(){/** @type{?proto.tensorflow.Tensor} */
return M.Message.getWrapperField(this||D,proto.tensorflow.Tensor,8)};
/**
 * @param {?proto.tensorflow.Tensor|undefined} value
 * @return {!proto.tensorflow.AttrValue} returns this
*/proto.tensorflow.AttrValue.prototype.setTensor=function(e){return M.Message.setOneofWrapperField(this||D,8,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearTensor=function(){return this.setTensor(void 0)};proto.tensorflow.AttrValue.prototype.hasTensor=function(){return M.Message.getField(this||D,8)!=null};proto.tensorflow.AttrValue.prototype.getPlaceholder=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,9,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.AttrValue} returns this
 */proto.tensorflow.AttrValue.prototype.setPlaceholder=function(e){return M.Message.setOneofField(this||D,9,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearPlaceholder=function(){return M.Message.setOneofField(this||D,9,proto.tensorflow.AttrValue.oneofGroups_[0],void 0)};proto.tensorflow.AttrValue.prototype.hasPlaceholder=function(){return M.Message.getField(this||D,9)!=null};proto.tensorflow.AttrValue.prototype.getFunc=function(){/** @type{?proto.tensorflow.NameAttrList} */
return M.Message.getWrapperField(this||D,proto.tensorflow.NameAttrList,10)};
/**
 * @param {?proto.tensorflow.NameAttrList|undefined} value
 * @return {!proto.tensorflow.AttrValue} returns this
*/proto.tensorflow.AttrValue.prototype.setFunc=function(e){return M.Message.setOneofWrapperField(this||D,10,proto.tensorflow.AttrValue.oneofGroups_[0],e)};proto.tensorflow.AttrValue.prototype.clearFunc=function(){return this.setFunc(void 0)};proto.tensorflow.AttrValue.prototype.hasFunc=function(){return M.Message.getField(this||D,10)!=null};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.NameAttrList.prototype.toObject=function(e){return proto.tensorflow.NameAttrList.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.NameAttrList} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.NameAttrList.toObject=function(e,t){var r,o={name:M.Message.getFieldWithDefault(t,1,""),attrMap:(r=t.getAttrMap())?r.toObject(e,proto.tensorflow.AttrValue.toObject):[]};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.NameAttrList}
 */proto.tensorflow.NameAttrList.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.NameAttrList;return proto.tensorflow.NameAttrList.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.NameAttrList} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.NameAttrList}
 */proto.tensorflow.NameAttrList.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setName(o);break;case 2:o=e.getAttrMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readMessage,proto.tensorflow.AttrValue.deserializeBinaryFromReader,"",new proto.tensorflow.AttrValue)}));break;default:t.skipField();break}}return e};proto.tensorflow.NameAttrList.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.NameAttrList.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.NameAttrList} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.NameAttrList.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getName();r.length>0&&t.writeString(1,r);r=e.getAttrMap(true);r&&r.getLength()>0&&r.serializeBinary(2,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeMessage,proto.tensorflow.AttrValue.serializeBinaryToWriter)};proto.tensorflow.NameAttrList.prototype.getName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.NameAttrList} returns this
 */proto.tensorflow.NameAttrList.prototype.setName=function(e){return M.Message.setProto3StringField(this||D,1,e)};
/**
 * map<string, AttrValue> attr = 2;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,!proto.tensorflow.AttrValue>}
 */proto.tensorflow.NameAttrList.prototype.getAttrMap=function(e){/** @type {!jspb.Map<string,!proto.tensorflow.AttrValue>} */
return M.Message.getMapField(this||D,2,e,proto.tensorflow.AttrValue)};proto.tensorflow.NameAttrList.prototype.clearAttrMap=function(){this.getAttrMap().clear();return this||D};proto.tensorflow.NodeDef.repeatedFields_=[3];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.NodeDef.prototype.toObject=function(e){return proto.tensorflow.NodeDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.NodeDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.NodeDef.toObject=function(e,t){var r,o={name:M.Message.getFieldWithDefault(t,1,""),op:M.Message.getFieldWithDefault(t,2,""),inputList:(r=M.Message.getRepeatedField(t,3))==null?void 0:r,device:M.Message.getFieldWithDefault(t,4,""),attrMap:(r=t.getAttrMap())?r.toObject(e,proto.tensorflow.AttrValue.toObject):[]};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.NodeDef}
 */proto.tensorflow.NodeDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.NodeDef;return proto.tensorflow.NodeDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.NodeDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.NodeDef}
 */proto.tensorflow.NodeDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setName(o);break;case 2:o=/** @type {string} */t.readString();e.setOp(o);break;case 3:o=/** @type {string} */t.readString();e.addInput(o);break;case 4:o=/** @type {string} */t.readString();e.setDevice(o);break;case 5:o=e.getAttrMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readMessage,proto.tensorflow.AttrValue.deserializeBinaryFromReader,"",new proto.tensorflow.AttrValue)}));break;default:t.skipField();break}}return e};proto.tensorflow.NodeDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.NodeDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.NodeDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.NodeDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getName();r.length>0&&t.writeString(1,r);r=e.getOp();r.length>0&&t.writeString(2,r);r=e.getInputList();r.length>0&&t.writeRepeatedString(3,r);r=e.getDevice();r.length>0&&t.writeString(4,r);r=e.getAttrMap(true);r&&r.getLength()>0&&r.serializeBinary(5,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeMessage,proto.tensorflow.AttrValue.serializeBinaryToWriter)};proto.tensorflow.NodeDef.prototype.getName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.NodeDef} returns this
 */proto.tensorflow.NodeDef.prototype.setName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.NodeDef.prototype.getOp=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.NodeDef} returns this
 */proto.tensorflow.NodeDef.prototype.setOp=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.NodeDef.prototype.getInputList=function(){/** @type {!Array<string>} */
return M.Message.getRepeatedField(this||D,3)};
/**
 * @param {!Array<string>} value
 * @return {!proto.tensorflow.NodeDef} returns this
 */proto.tensorflow.NodeDef.prototype.setInputList=function(e){return M.Message.setField(this||D,3,e||[])};
/**
 * @param {string} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.NodeDef} returns this
 */proto.tensorflow.NodeDef.prototype.addInput=function(e,t){return M.Message.addToRepeatedField(this||D,3,e,t)};proto.tensorflow.NodeDef.prototype.clearInputList=function(){return this.setInputList([])};proto.tensorflow.NodeDef.prototype.getDevice=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,4,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.NodeDef} returns this
 */proto.tensorflow.NodeDef.prototype.setDevice=function(e){return M.Message.setProto3StringField(this||D,4,e)};
/**
 * map<string, AttrValue> attr = 5;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,!proto.tensorflow.AttrValue>}
 */proto.tensorflow.NodeDef.prototype.getAttrMap=function(e){/** @type {!jspb.Map<string,!proto.tensorflow.AttrValue>} */
return M.Message.getMapField(this||D,5,e,proto.tensorflow.AttrValue)};proto.tensorflow.NodeDef.prototype.clearAttrMap=function(){this.getAttrMap().clear();return this||D};proto.tensorflow.VersionDef.repeatedFields_=[3];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.VersionDef.prototype.toObject=function(e){return proto.tensorflow.VersionDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.VersionDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.VersionDef.toObject=function(e,t){var r,o={producer:M.Message.getFieldWithDefault(t,1,0),minConsumer:M.Message.getFieldWithDefault(t,2,0),badConsumersList:(r=M.Message.getRepeatedField(t,3))==null?void 0:r};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.VersionDef}
 */proto.tensorflow.VersionDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.VersionDef;return proto.tensorflow.VersionDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.VersionDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.VersionDef}
 */proto.tensorflow.VersionDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readInt32();e.setProducer(o);break;case 2:o=/** @type {number} */t.readInt32();e.setMinConsumer(o);break;case 3:var n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedInt32():[t.readInt32()];for(var a=0;a<n.length;a++)e.addBadConsumers(n[a]);break;default:t.skipField();break}}return e};proto.tensorflow.VersionDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.VersionDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.VersionDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.VersionDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getProducer();r!==0&&t.writeInt32(1,r);r=e.getMinConsumer();r!==0&&t.writeInt32(2,r);r=e.getBadConsumersList();r.length>0&&t.writePackedInt32(3,r)};proto.tensorflow.VersionDef.prototype.getProducer=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.VersionDef} returns this
 */proto.tensorflow.VersionDef.prototype.setProducer=function(e){return M.Message.setProto3IntField(this||D,1,e)};proto.tensorflow.VersionDef.prototype.getMinConsumer=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,2,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.VersionDef} returns this
 */proto.tensorflow.VersionDef.prototype.setMinConsumer=function(e){return M.Message.setProto3IntField(this||D,2,e)};proto.tensorflow.VersionDef.prototype.getBadConsumersList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedField(this||D,3)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.VersionDef} returns this
 */proto.tensorflow.VersionDef.prototype.setBadConsumersList=function(e){return M.Message.setField(this||D,3,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.VersionDef} returns this
 */proto.tensorflow.VersionDef.prototype.addBadConsumers=function(e,t){return M.Message.addToRepeatedField(this||D,3,e,t)};proto.tensorflow.VersionDef.prototype.clearBadConsumersList=function(){return this.setBadConsumersList([])};proto.tensorflow.GraphDef.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.GraphDef.prototype.toObject=function(e){return proto.tensorflow.GraphDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.GraphDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.GraphDef.toObject=function(e,t){var r,o={nodeList:M.Message.toObjectList(t.getNodeList(),proto.tensorflow.NodeDef.toObject,e),versions:(r=t.getVersions())&&proto.tensorflow.VersionDef.toObject(e,r),library:(r=t.getLibrary())&&proto.tensorflow.FunctionDefLibrary.toObject(e,r)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.GraphDef}
 */proto.tensorflow.GraphDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.GraphDef;return proto.tensorflow.GraphDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.GraphDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.GraphDef}
 */proto.tensorflow.GraphDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.NodeDef;t.readMessage(o,proto.tensorflow.NodeDef.deserializeBinaryFromReader);e.addNode(o);break;case 4:o=new proto.tensorflow.VersionDef;t.readMessage(o,proto.tensorflow.VersionDef.deserializeBinaryFromReader);e.setVersions(o);break;case 2:o=new proto.tensorflow.FunctionDefLibrary;t.readMessage(o,proto.tensorflow.FunctionDefLibrary.deserializeBinaryFromReader);e.setLibrary(o);break;default:t.skipField();break}}return e};proto.tensorflow.GraphDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.GraphDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.GraphDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.GraphDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getNodeList();r.length>0&&t.writeRepeatedMessage(1,r,proto.tensorflow.NodeDef.serializeBinaryToWriter);r=e.getVersions();r!=null&&t.writeMessage(4,r,proto.tensorflow.VersionDef.serializeBinaryToWriter);r=e.getLibrary();r!=null&&t.writeMessage(2,r,proto.tensorflow.FunctionDefLibrary.serializeBinaryToWriter)};proto.tensorflow.GraphDef.prototype.getNodeList=function(){/** @type{!Array<!proto.tensorflow.NodeDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.NodeDef,1)};
/**
 * @param {!Array<!proto.tensorflow.NodeDef>} value
 * @return {!proto.tensorflow.GraphDef} returns this
*/proto.tensorflow.GraphDef.prototype.setNodeList=function(e){return M.Message.setRepeatedWrapperField(this||D,1,e)};
/**
 * @param {!proto.tensorflow.NodeDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.NodeDef}
 */proto.tensorflow.GraphDef.prototype.addNode=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,1,e,proto.tensorflow.NodeDef,t)};proto.tensorflow.GraphDef.prototype.clearNodeList=function(){return this.setNodeList([])};proto.tensorflow.GraphDef.prototype.getVersions=function(){/** @type{?proto.tensorflow.VersionDef} */
return M.Message.getWrapperField(this||D,proto.tensorflow.VersionDef,4)};
/**
 * @param {?proto.tensorflow.VersionDef|undefined} value
 * @return {!proto.tensorflow.GraphDef} returns this
*/proto.tensorflow.GraphDef.prototype.setVersions=function(e){return M.Message.setWrapperField(this||D,4,e)};proto.tensorflow.GraphDef.prototype.clearVersions=function(){return this.setVersions(void 0)};proto.tensorflow.GraphDef.prototype.hasVersions=function(){return M.Message.getField(this||D,4)!=null};proto.tensorflow.GraphDef.prototype.getLibrary=function(){/** @type{?proto.tensorflow.FunctionDefLibrary} */
return M.Message.getWrapperField(this||D,proto.tensorflow.FunctionDefLibrary,2)};
/**
 * @param {?proto.tensorflow.FunctionDefLibrary|undefined} value
 * @return {!proto.tensorflow.GraphDef} returns this
*/proto.tensorflow.GraphDef.prototype.setLibrary=function(e){return M.Message.setWrapperField(this||D,2,e)};proto.tensorflow.GraphDef.prototype.clearLibrary=function(){return this.setLibrary(void 0)};proto.tensorflow.GraphDef.prototype.hasLibrary=function(){return M.Message.getField(this||D,2)!=null};proto.tensorflow.CollectionDef.oneofGroups_=[[1,2,3,4,5]];proto.tensorflow.CollectionDef.KindCase={KIND_NOT_SET:0,NODE_LIST:1,BYTES_LIST:2,INT64_LIST:3,FLOAT_LIST:4,ANY_LIST:5};proto.tensorflow.CollectionDef.prototype.getKindCase=function(){/** @type {proto.tensorflow.CollectionDef.KindCase} */
return M.Message.computeOneofCase(this||D,proto.tensorflow.CollectionDef.oneofGroups_[0])};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.CollectionDef.prototype.toObject=function(e){return proto.tensorflow.CollectionDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.CollectionDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.CollectionDef.toObject=function(e,t){var r,o={nodeList:(r=t.getNodeList())&&proto.tensorflow.CollectionDef.NodeList.toObject(e,r),bytesList:(r=t.getBytesList())&&proto.tensorflow.CollectionDef.BytesList.toObject(e,r),int64List:(r=t.getInt64List())&&proto.tensorflow.CollectionDef.Int64List.toObject(e,r),floatList:(r=t.getFloatList())&&proto.tensorflow.CollectionDef.FloatList.toObject(e,r),anyList:(r=t.getAnyList())&&proto.tensorflow.CollectionDef.AnyList.toObject(e,r)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.CollectionDef}
 */proto.tensorflow.CollectionDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.CollectionDef;return proto.tensorflow.CollectionDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.CollectionDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.CollectionDef}
 */proto.tensorflow.CollectionDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.CollectionDef.NodeList;t.readMessage(o,proto.tensorflow.CollectionDef.NodeList.deserializeBinaryFromReader);e.setNodeList(o);break;case 2:o=new proto.tensorflow.CollectionDef.BytesList;t.readMessage(o,proto.tensorflow.CollectionDef.BytesList.deserializeBinaryFromReader);e.setBytesList(o);break;case 3:o=new proto.tensorflow.CollectionDef.Int64List;t.readMessage(o,proto.tensorflow.CollectionDef.Int64List.deserializeBinaryFromReader);e.setInt64List(o);break;case 4:o=new proto.tensorflow.CollectionDef.FloatList;t.readMessage(o,proto.tensorflow.CollectionDef.FloatList.deserializeBinaryFromReader);e.setFloatList(o);break;case 5:o=new proto.tensorflow.CollectionDef.AnyList;t.readMessage(o,proto.tensorflow.CollectionDef.AnyList.deserializeBinaryFromReader);e.setAnyList(o);break;default:t.skipField();break}}return e};proto.tensorflow.CollectionDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.CollectionDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.CollectionDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.CollectionDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getNodeList();r!=null&&t.writeMessage(1,r,proto.tensorflow.CollectionDef.NodeList.serializeBinaryToWriter);r=e.getBytesList();r!=null&&t.writeMessage(2,r,proto.tensorflow.CollectionDef.BytesList.serializeBinaryToWriter);r=e.getInt64List();r!=null&&t.writeMessage(3,r,proto.tensorflow.CollectionDef.Int64List.serializeBinaryToWriter);r=e.getFloatList();r!=null&&t.writeMessage(4,r,proto.tensorflow.CollectionDef.FloatList.serializeBinaryToWriter);r=e.getAnyList();r!=null&&t.writeMessage(5,r,proto.tensorflow.CollectionDef.AnyList.serializeBinaryToWriter)};proto.tensorflow.CollectionDef.NodeList.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.CollectionDef.NodeList.prototype.toObject=function(e){return proto.tensorflow.CollectionDef.NodeList.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.CollectionDef.NodeList} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.CollectionDef.NodeList.toObject=function(e,t){var r,o={valueList:(r=M.Message.getRepeatedField(t,1))==null?void 0:r};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.CollectionDef.NodeList}
 */proto.tensorflow.CollectionDef.NodeList.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.CollectionDef.NodeList;return proto.tensorflow.CollectionDef.NodeList.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.CollectionDef.NodeList} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.CollectionDef.NodeList}
 */proto.tensorflow.CollectionDef.NodeList.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.addValue(o);break;default:t.skipField();break}}return e};proto.tensorflow.CollectionDef.NodeList.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.CollectionDef.NodeList.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.CollectionDef.NodeList} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.CollectionDef.NodeList.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getValueList();r.length>0&&t.writeRepeatedString(1,r)};proto.tensorflow.CollectionDef.NodeList.prototype.getValueList=function(){/** @type {!Array<string>} */
return M.Message.getRepeatedField(this||D,1)};
/**
 * @param {!Array<string>} value
 * @return {!proto.tensorflow.CollectionDef.NodeList} returns this
 */proto.tensorflow.CollectionDef.NodeList.prototype.setValueList=function(e){return M.Message.setField(this||D,1,e||[])};
/**
 * @param {string} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.CollectionDef.NodeList} returns this
 */proto.tensorflow.CollectionDef.NodeList.prototype.addValue=function(e,t){return M.Message.addToRepeatedField(this||D,1,e,t)};proto.tensorflow.CollectionDef.NodeList.prototype.clearValueList=function(){return this.setValueList([])};proto.tensorflow.CollectionDef.BytesList.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.CollectionDef.BytesList.prototype.toObject=function(e){return proto.tensorflow.CollectionDef.BytesList.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.CollectionDef.BytesList} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.CollectionDef.BytesList.toObject=function(e,t){var r={valueList:t.getValueList_asB64()};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.CollectionDef.BytesList}
 */proto.tensorflow.CollectionDef.BytesList.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.CollectionDef.BytesList;return proto.tensorflow.CollectionDef.BytesList.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.CollectionDef.BytesList} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.CollectionDef.BytesList}
 */proto.tensorflow.CollectionDef.BytesList.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {!Uint8Array} */t.readBytes();e.addValue(o);break;default:t.skipField();break}}return e};proto.tensorflow.CollectionDef.BytesList.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.CollectionDef.BytesList.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.CollectionDef.BytesList} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.CollectionDef.BytesList.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getValueList_asU8();r.length>0&&t.writeRepeatedBytes(1,r)};proto.tensorflow.CollectionDef.BytesList.prototype.getValueList=function(){/** @type {!(Array<!Uint8Array>|Array<string>)} */
return M.Message.getRepeatedField(this||D,1)};proto.tensorflow.CollectionDef.BytesList.prototype.getValueList_asB64=function(){/** @type {!Array<string>} */
return M.Message.bytesListAsB64(this.getValueList())};proto.tensorflow.CollectionDef.BytesList.prototype.getValueList_asU8=function(){/** @type {!Array<!Uint8Array>} */
return M.Message.bytesListAsU8(this.getValueList())};
/**
 * @param {!(Array<!Uint8Array>|Array<string>)} value
 * @return {!proto.tensorflow.CollectionDef.BytesList} returns this
 */proto.tensorflow.CollectionDef.BytesList.prototype.setValueList=function(e){return M.Message.setField(this||D,1,e||[])};
/**
 * @param {!(string|Uint8Array)} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.CollectionDef.BytesList} returns this
 */proto.tensorflow.CollectionDef.BytesList.prototype.addValue=function(e,t){return M.Message.addToRepeatedField(this||D,1,e,t)};proto.tensorflow.CollectionDef.BytesList.prototype.clearValueList=function(){return this.setValueList([])};proto.tensorflow.CollectionDef.Int64List.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.CollectionDef.Int64List.prototype.toObject=function(e){return proto.tensorflow.CollectionDef.Int64List.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.CollectionDef.Int64List} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.CollectionDef.Int64List.toObject=function(e,t){var r,o={valueList:(r=M.Message.getRepeatedField(t,1))==null?void 0:r};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.CollectionDef.Int64List}
 */proto.tensorflow.CollectionDef.Int64List.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.CollectionDef.Int64List;return proto.tensorflow.CollectionDef.Int64List.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.CollectionDef.Int64List} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.CollectionDef.Int64List}
 */proto.tensorflow.CollectionDef.Int64List.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {!Array<number>} */t.isDelimited()?t.readPackedInt64():[t.readInt64()];for(var n=0;n<o.length;n++)e.addValue(o[n]);break;default:t.skipField();break}}return e};proto.tensorflow.CollectionDef.Int64List.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.CollectionDef.Int64List.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.CollectionDef.Int64List} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.CollectionDef.Int64List.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getValueList();r.length>0&&t.writePackedInt64(1,r)};proto.tensorflow.CollectionDef.Int64List.prototype.getValueList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedField(this||D,1)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.CollectionDef.Int64List} returns this
 */proto.tensorflow.CollectionDef.Int64List.prototype.setValueList=function(e){return M.Message.setField(this||D,1,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.CollectionDef.Int64List} returns this
 */proto.tensorflow.CollectionDef.Int64List.prototype.addValue=function(e,t){return M.Message.addToRepeatedField(this||D,1,e,t)};proto.tensorflow.CollectionDef.Int64List.prototype.clearValueList=function(){return this.setValueList([])};proto.tensorflow.CollectionDef.FloatList.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.CollectionDef.FloatList.prototype.toObject=function(e){return proto.tensorflow.CollectionDef.FloatList.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.CollectionDef.FloatList} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.CollectionDef.FloatList.toObject=function(e,t){var r,o={valueList:(r=M.Message.getRepeatedFloatingPointField(t,1))==null?void 0:r};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.CollectionDef.FloatList}
 */proto.tensorflow.CollectionDef.FloatList.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.CollectionDef.FloatList;return proto.tensorflow.CollectionDef.FloatList.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.CollectionDef.FloatList} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.CollectionDef.FloatList}
 */proto.tensorflow.CollectionDef.FloatList.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {!Array<number>} */t.isDelimited()?t.readPackedFloat():[t.readFloat()];for(var n=0;n<o.length;n++)e.addValue(o[n]);break;default:t.skipField();break}}return e};proto.tensorflow.CollectionDef.FloatList.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.CollectionDef.FloatList.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.CollectionDef.FloatList} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.CollectionDef.FloatList.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getValueList();r.length>0&&t.writePackedFloat(1,r)};proto.tensorflow.CollectionDef.FloatList.prototype.getValueList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedFloatingPointField(this||D,1)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.CollectionDef.FloatList} returns this
 */proto.tensorflow.CollectionDef.FloatList.prototype.setValueList=function(e){return M.Message.setField(this||D,1,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.CollectionDef.FloatList} returns this
 */proto.tensorflow.CollectionDef.FloatList.prototype.addValue=function(e,t){return M.Message.addToRepeatedField(this||D,1,e,t)};proto.tensorflow.CollectionDef.FloatList.prototype.clearValueList=function(){return this.setValueList([])};proto.tensorflow.CollectionDef.AnyList.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.CollectionDef.AnyList.prototype.toObject=function(e){return proto.tensorflow.CollectionDef.AnyList.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.CollectionDef.AnyList} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.CollectionDef.AnyList.toObject=function(e,t){var r={valueList:M.Message.toObjectList(t.getValueList(),proto.tensorflow.Any.toObject,e)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.CollectionDef.AnyList}
 */proto.tensorflow.CollectionDef.AnyList.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.CollectionDef.AnyList;return proto.tensorflow.CollectionDef.AnyList.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.CollectionDef.AnyList} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.CollectionDef.AnyList}
 */proto.tensorflow.CollectionDef.AnyList.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.Any;t.readMessage(o,proto.tensorflow.Any.deserializeBinaryFromReader);e.addValue(o);break;default:t.skipField();break}}return e};proto.tensorflow.CollectionDef.AnyList.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.CollectionDef.AnyList.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.CollectionDef.AnyList} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.CollectionDef.AnyList.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getValueList();r.length>0&&t.writeRepeatedMessage(1,r,proto.tensorflow.Any.serializeBinaryToWriter)};proto.tensorflow.CollectionDef.AnyList.prototype.getValueList=function(){/** @type{!Array<!proto.tensorflow.Any>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.Any,1)};
/**
 * @param {!Array<!proto.tensorflow.Any>} value
 * @return {!proto.tensorflow.CollectionDef.AnyList} returns this
*/proto.tensorflow.CollectionDef.AnyList.prototype.setValueList=function(e){return M.Message.setRepeatedWrapperField(this||D,1,e)};
/**
 * @param {!proto.tensorflow.Any=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Any}
 */proto.tensorflow.CollectionDef.AnyList.prototype.addValue=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,1,e,proto.tensorflow.Any,t)};proto.tensorflow.CollectionDef.AnyList.prototype.clearValueList=function(){return this.setValueList([])};proto.tensorflow.CollectionDef.prototype.getNodeList=function(){/** @type{?proto.tensorflow.CollectionDef.NodeList} */
return M.Message.getWrapperField(this||D,proto.tensorflow.CollectionDef.NodeList,1)};
/**
 * @param {?proto.tensorflow.CollectionDef.NodeList|undefined} value
 * @return {!proto.tensorflow.CollectionDef} returns this
*/proto.tensorflow.CollectionDef.prototype.setNodeList=function(e){return M.Message.setOneofWrapperField(this||D,1,proto.tensorflow.CollectionDef.oneofGroups_[0],e)};proto.tensorflow.CollectionDef.prototype.clearNodeList=function(){return this.setNodeList(void 0)};proto.tensorflow.CollectionDef.prototype.hasNodeList=function(){return M.Message.getField(this||D,1)!=null};proto.tensorflow.CollectionDef.prototype.getBytesList=function(){/** @type{?proto.tensorflow.CollectionDef.BytesList} */
return M.Message.getWrapperField(this||D,proto.tensorflow.CollectionDef.BytesList,2)};
/**
 * @param {?proto.tensorflow.CollectionDef.BytesList|undefined} value
 * @return {!proto.tensorflow.CollectionDef} returns this
*/proto.tensorflow.CollectionDef.prototype.setBytesList=function(e){return M.Message.setOneofWrapperField(this||D,2,proto.tensorflow.CollectionDef.oneofGroups_[0],e)};proto.tensorflow.CollectionDef.prototype.clearBytesList=function(){return this.setBytesList(void 0)};proto.tensorflow.CollectionDef.prototype.hasBytesList=function(){return M.Message.getField(this||D,2)!=null};proto.tensorflow.CollectionDef.prototype.getInt64List=function(){/** @type{?proto.tensorflow.CollectionDef.Int64List} */
return M.Message.getWrapperField(this||D,proto.tensorflow.CollectionDef.Int64List,3)};
/**
 * @param {?proto.tensorflow.CollectionDef.Int64List|undefined} value
 * @return {!proto.tensorflow.CollectionDef} returns this
*/proto.tensorflow.CollectionDef.prototype.setInt64List=function(e){return M.Message.setOneofWrapperField(this||D,3,proto.tensorflow.CollectionDef.oneofGroups_[0],e)};proto.tensorflow.CollectionDef.prototype.clearInt64List=function(){return this.setInt64List(void 0)};proto.tensorflow.CollectionDef.prototype.hasInt64List=function(){return M.Message.getField(this||D,3)!=null};proto.tensorflow.CollectionDef.prototype.getFloatList=function(){/** @type{?proto.tensorflow.CollectionDef.FloatList} */
return M.Message.getWrapperField(this||D,proto.tensorflow.CollectionDef.FloatList,4)};
/**
 * @param {?proto.tensorflow.CollectionDef.FloatList|undefined} value
 * @return {!proto.tensorflow.CollectionDef} returns this
*/proto.tensorflow.CollectionDef.prototype.setFloatList=function(e){return M.Message.setOneofWrapperField(this||D,4,proto.tensorflow.CollectionDef.oneofGroups_[0],e)};proto.tensorflow.CollectionDef.prototype.clearFloatList=function(){return this.setFloatList(void 0)};proto.tensorflow.CollectionDef.prototype.hasFloatList=function(){return M.Message.getField(this||D,4)!=null};proto.tensorflow.CollectionDef.prototype.getAnyList=function(){/** @type{?proto.tensorflow.CollectionDef.AnyList} */
return M.Message.getWrapperField(this||D,proto.tensorflow.CollectionDef.AnyList,5)};
/**
 * @param {?proto.tensorflow.CollectionDef.AnyList|undefined} value
 * @return {!proto.tensorflow.CollectionDef} returns this
*/proto.tensorflow.CollectionDef.prototype.setAnyList=function(e){return M.Message.setOneofWrapperField(this||D,5,proto.tensorflow.CollectionDef.oneofGroups_[0],e)};proto.tensorflow.CollectionDef.prototype.clearAnyList=function(){return this.setAnyList(void 0)};proto.tensorflow.CollectionDef.prototype.hasAnyList=function(){return M.Message.getField(this||D,5)!=null};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.SaverDef.prototype.toObject=function(e){return proto.tensorflow.SaverDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.SaverDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.SaverDef.toObject=function(e,t){var r={filenameTensorName:M.Message.getFieldWithDefault(t,1,""),saveTensorName:M.Message.getFieldWithDefault(t,2,""),restoreOpName:M.Message.getFieldWithDefault(t,3,""),maxToKeep:M.Message.getFieldWithDefault(t,4,0),sharded:M.Message.getBooleanFieldWithDefault(t,5,false),keepCheckpointEveryNHours:M.Message.getFloatingPointFieldWithDefault(t,6,0),version:M.Message.getFieldWithDefault(t,7,0)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.SaverDef}
 */proto.tensorflow.SaverDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.SaverDef;return proto.tensorflow.SaverDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.SaverDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.SaverDef}
 */proto.tensorflow.SaverDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setFilenameTensorName(o);break;case 2:o=/** @type {string} */t.readString();e.setSaveTensorName(o);break;case 3:o=/** @type {string} */t.readString();e.setRestoreOpName(o);break;case 4:o=/** @type {number} */t.readInt32();e.setMaxToKeep(o);break;case 5:o=/** @type {boolean} */t.readBool();e.setSharded(o);break;case 6:o=/** @type {number} */t.readFloat();e.setKeepCheckpointEveryNHours(o);break;case 7:o=/** @type {!proto.tensorflow.SaverDef.CheckpointFormatVersion} */t.readEnum();e.setVersion(o);break;default:t.skipField();break}}return e};proto.tensorflow.SaverDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.SaverDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.SaverDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.SaverDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getFilenameTensorName();r.length>0&&t.writeString(1,r);r=e.getSaveTensorName();r.length>0&&t.writeString(2,r);r=e.getRestoreOpName();r.length>0&&t.writeString(3,r);r=e.getMaxToKeep();r!==0&&t.writeInt32(4,r);r=e.getSharded();r&&t.writeBool(5,r);r=e.getKeepCheckpointEveryNHours();r!==0&&t.writeFloat(6,r);r=e.getVersion();r!==0&&t.writeEnum(7,r)};proto.tensorflow.SaverDef.CheckpointFormatVersion={LEGACY:0,V1:1,V2:2};proto.tensorflow.SaverDef.prototype.getFilenameTensorName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SaverDef} returns this
 */proto.tensorflow.SaverDef.prototype.setFilenameTensorName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.SaverDef.prototype.getSaveTensorName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SaverDef} returns this
 */proto.tensorflow.SaverDef.prototype.setSaveTensorName=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.SaverDef.prototype.getRestoreOpName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,3,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SaverDef} returns this
 */proto.tensorflow.SaverDef.prototype.setRestoreOpName=function(e){return M.Message.setProto3StringField(this||D,3,e)};proto.tensorflow.SaverDef.prototype.getMaxToKeep=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,4,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.SaverDef} returns this
 */proto.tensorflow.SaverDef.prototype.setMaxToKeep=function(e){return M.Message.setProto3IntField(this||D,4,e)};proto.tensorflow.SaverDef.prototype.getSharded=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,5,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.SaverDef} returns this
 */proto.tensorflow.SaverDef.prototype.setSharded=function(e){return M.Message.setProto3BooleanField(this||D,5,e)};proto.tensorflow.SaverDef.prototype.getKeepCheckpointEveryNHours=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,6,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.SaverDef} returns this
 */proto.tensorflow.SaverDef.prototype.setKeepCheckpointEveryNHours=function(e){return M.Message.setProto3FloatField(this||D,6,e)};proto.tensorflow.SaverDef.prototype.getVersion=function(){/** @type {!proto.tensorflow.SaverDef.CheckpointFormatVersion} */
return M.Message.getFieldWithDefault(this||D,7,0)};
/**
 * @param {!proto.tensorflow.SaverDef.CheckpointFormatVersion} value
 * @return {!proto.tensorflow.SaverDef} returns this
 */proto.tensorflow.SaverDef.prototype.setVersion=function(e){return M.Message.setProto3EnumField(this||D,7,e)};proto.tensorflow.TensorInfo.oneofGroups_=[[1,4]];proto.tensorflow.TensorInfo.EncodingCase={ENCODING_NOT_SET:0,NAME:1,COO_SPARSE:4};proto.tensorflow.TensorInfo.prototype.getEncodingCase=function(){/** @type {proto.tensorflow.TensorInfo.EncodingCase} */
return M.Message.computeOneofCase(this||D,proto.tensorflow.TensorInfo.oneofGroups_[0])};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.TensorInfo.prototype.toObject=function(e){return proto.tensorflow.TensorInfo.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.TensorInfo} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.TensorInfo.toObject=function(e,t){var r,o={name:M.Message.getFieldWithDefault(t,1,""),cooSparse:(r=t.getCooSparse())&&proto.tensorflow.TensorInfo.CooSparse.toObject(e,r),dtype:M.Message.getFieldWithDefault(t,2,0),tensorShape:(r=t.getTensorShape())&&proto.tensorflow.TensorShape.toObject(e,r)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.TensorInfo}
 */proto.tensorflow.TensorInfo.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.TensorInfo;return proto.tensorflow.TensorInfo.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.TensorInfo} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.TensorInfo}
 */proto.tensorflow.TensorInfo.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setName(o);break;case 4:o=new proto.tensorflow.TensorInfo.CooSparse;t.readMessage(o,proto.tensorflow.TensorInfo.CooSparse.deserializeBinaryFromReader);e.setCooSparse(o);break;case 2:o=/** @type {!proto.tensorflow.DataType} */t.readEnum();e.setDtype(o);break;case 3:o=new proto.tensorflow.TensorShape;t.readMessage(o,proto.tensorflow.TensorShape.deserializeBinaryFromReader);e.setTensorShape(o);break;default:t.skipField();break}}return e};proto.tensorflow.TensorInfo.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.TensorInfo.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.TensorInfo} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.TensorInfo.serializeBinaryToWriter=function(e,t){var r=void 0;r=/** @type {string} */M.Message.getField(e,1);r!=null&&t.writeString(1,r);r=e.getCooSparse();r!=null&&t.writeMessage(4,r,proto.tensorflow.TensorInfo.CooSparse.serializeBinaryToWriter);r=e.getDtype();r!==0&&t.writeEnum(2,r);r=e.getTensorShape();r!=null&&t.writeMessage(3,r,proto.tensorflow.TensorShape.serializeBinaryToWriter)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.TensorInfo.CooSparse.prototype.toObject=function(e){return proto.tensorflow.TensorInfo.CooSparse.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.TensorInfo.CooSparse} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.TensorInfo.CooSparse.toObject=function(e,t){var r={valuesTensorName:M.Message.getFieldWithDefault(t,1,""),indicesTensorName:M.Message.getFieldWithDefault(t,2,""),denseShapeTensorName:M.Message.getFieldWithDefault(t,3,"")};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.TensorInfo.CooSparse}
 */proto.tensorflow.TensorInfo.CooSparse.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.TensorInfo.CooSparse;return proto.tensorflow.TensorInfo.CooSparse.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.TensorInfo.CooSparse} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.TensorInfo.CooSparse}
 */proto.tensorflow.TensorInfo.CooSparse.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setValuesTensorName(o);break;case 2:o=/** @type {string} */t.readString();e.setIndicesTensorName(o);break;case 3:o=/** @type {string} */t.readString();e.setDenseShapeTensorName(o);break;default:t.skipField();break}}return e};proto.tensorflow.TensorInfo.CooSparse.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.TensorInfo.CooSparse.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.TensorInfo.CooSparse} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.TensorInfo.CooSparse.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getValuesTensorName();r.length>0&&t.writeString(1,r);r=e.getIndicesTensorName();r.length>0&&t.writeString(2,r);r=e.getDenseShapeTensorName();r.length>0&&t.writeString(3,r)};proto.tensorflow.TensorInfo.CooSparse.prototype.getValuesTensorName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.TensorInfo.CooSparse} returns this
 */proto.tensorflow.TensorInfo.CooSparse.prototype.setValuesTensorName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.TensorInfo.CooSparse.prototype.getIndicesTensorName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.TensorInfo.CooSparse} returns this
 */proto.tensorflow.TensorInfo.CooSparse.prototype.setIndicesTensorName=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.TensorInfo.CooSparse.prototype.getDenseShapeTensorName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,3,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.TensorInfo.CooSparse} returns this
 */proto.tensorflow.TensorInfo.CooSparse.prototype.setDenseShapeTensorName=function(e){return M.Message.setProto3StringField(this||D,3,e)};proto.tensorflow.TensorInfo.prototype.getName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.TensorInfo} returns this
 */proto.tensorflow.TensorInfo.prototype.setName=function(e){return M.Message.setOneofField(this||D,1,proto.tensorflow.TensorInfo.oneofGroups_[0],e)};proto.tensorflow.TensorInfo.prototype.clearName=function(){return M.Message.setOneofField(this||D,1,proto.tensorflow.TensorInfo.oneofGroups_[0],void 0)};proto.tensorflow.TensorInfo.prototype.hasName=function(){return M.Message.getField(this||D,1)!=null};proto.tensorflow.TensorInfo.prototype.getCooSparse=function(){/** @type{?proto.tensorflow.TensorInfo.CooSparse} */
return M.Message.getWrapperField(this||D,proto.tensorflow.TensorInfo.CooSparse,4)};
/**
 * @param {?proto.tensorflow.TensorInfo.CooSparse|undefined} value
 * @return {!proto.tensorflow.TensorInfo} returns this
*/proto.tensorflow.TensorInfo.prototype.setCooSparse=function(e){return M.Message.setOneofWrapperField(this||D,4,proto.tensorflow.TensorInfo.oneofGroups_[0],e)};proto.tensorflow.TensorInfo.prototype.clearCooSparse=function(){return this.setCooSparse(void 0)};proto.tensorflow.TensorInfo.prototype.hasCooSparse=function(){return M.Message.getField(this||D,4)!=null};proto.tensorflow.TensorInfo.prototype.getDtype=function(){/** @type {!proto.tensorflow.DataType} */
return M.Message.getFieldWithDefault(this||D,2,0)};
/**
 * @param {!proto.tensorflow.DataType} value
 * @return {!proto.tensorflow.TensorInfo} returns this
 */proto.tensorflow.TensorInfo.prototype.setDtype=function(e){return M.Message.setProto3EnumField(this||D,2,e)};proto.tensorflow.TensorInfo.prototype.getTensorShape=function(){/** @type{?proto.tensorflow.TensorShape} */
return M.Message.getWrapperField(this||D,proto.tensorflow.TensorShape,3)};
/**
 * @param {?proto.tensorflow.TensorShape|undefined} value
 * @return {!proto.tensorflow.TensorInfo} returns this
*/proto.tensorflow.TensorInfo.prototype.setTensorShape=function(e){return M.Message.setWrapperField(this||D,3,e)};proto.tensorflow.TensorInfo.prototype.clearTensorShape=function(){return this.setTensorShape(void 0)};proto.tensorflow.TensorInfo.prototype.hasTensorShape=function(){return M.Message.getField(this||D,3)!=null};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.SignatureDef.prototype.toObject=function(e){return proto.tensorflow.SignatureDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.SignatureDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.SignatureDef.toObject=function(e,t){var r,o={inputsMap:(r=t.getInputsMap())?r.toObject(e,proto.tensorflow.TensorInfo.toObject):[],outputsMap:(r=t.getOutputsMap())?r.toObject(e,proto.tensorflow.TensorInfo.toObject):[],methodName:M.Message.getFieldWithDefault(t,3,"")};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.SignatureDef}
 */proto.tensorflow.SignatureDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.SignatureDef;return proto.tensorflow.SignatureDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.SignatureDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.SignatureDef}
 */proto.tensorflow.SignatureDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=e.getInputsMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readMessage,proto.tensorflow.TensorInfo.deserializeBinaryFromReader,"",new proto.tensorflow.TensorInfo)}));break;case 2:o=e.getOutputsMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readMessage,proto.tensorflow.TensorInfo.deserializeBinaryFromReader,"",new proto.tensorflow.TensorInfo)}));break;case 3:o=/** @type {string} */t.readString();e.setMethodName(o);break;default:t.skipField();break}}return e};proto.tensorflow.SignatureDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.SignatureDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.SignatureDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.SignatureDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getInputsMap(true);r&&r.getLength()>0&&r.serializeBinary(1,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeMessage,proto.tensorflow.TensorInfo.serializeBinaryToWriter);r=e.getOutputsMap(true);r&&r.getLength()>0&&r.serializeBinary(2,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeMessage,proto.tensorflow.TensorInfo.serializeBinaryToWriter);r=e.getMethodName();r.length>0&&t.writeString(3,r)};
/**
 * map<string, TensorInfo> inputs = 1;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,!proto.tensorflow.TensorInfo>}
 */proto.tensorflow.SignatureDef.prototype.getInputsMap=function(e){/** @type {!jspb.Map<string,!proto.tensorflow.TensorInfo>} */
return M.Message.getMapField(this||D,1,e,proto.tensorflow.TensorInfo)};proto.tensorflow.SignatureDef.prototype.clearInputsMap=function(){this.getInputsMap().clear();return this||D};
/**
 * map<string, TensorInfo> outputs = 2;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,!proto.tensorflow.TensorInfo>}
 */proto.tensorflow.SignatureDef.prototype.getOutputsMap=function(e){/** @type {!jspb.Map<string,!proto.tensorflow.TensorInfo>} */
return M.Message.getMapField(this||D,2,e,proto.tensorflow.TensorInfo)};proto.tensorflow.SignatureDef.prototype.clearOutputsMap=function(){this.getOutputsMap().clear();return this||D};proto.tensorflow.SignatureDef.prototype.getMethodName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,3,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SignatureDef} returns this
 */proto.tensorflow.SignatureDef.prototype.setMethodName=function(e){return M.Message.setProto3StringField(this||D,3,e)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.AssetFileDef.prototype.toObject=function(e){return proto.tensorflow.AssetFileDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.AssetFileDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.AssetFileDef.toObject=function(e,t){var r,o={tensorInfo:(r=t.getTensorInfo())&&proto.tensorflow.TensorInfo.toObject(e,r),filename:M.Message.getFieldWithDefault(t,2,"")};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.AssetFileDef}
 */proto.tensorflow.AssetFileDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.AssetFileDef;return proto.tensorflow.AssetFileDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.AssetFileDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.AssetFileDef}
 */proto.tensorflow.AssetFileDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.TensorInfo;t.readMessage(o,proto.tensorflow.TensorInfo.deserializeBinaryFromReader);e.setTensorInfo(o);break;case 2:o=/** @type {string} */t.readString();e.setFilename(o);break;default:t.skipField();break}}return e};proto.tensorflow.AssetFileDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.AssetFileDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.AssetFileDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.AssetFileDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getTensorInfo();r!=null&&t.writeMessage(1,r,proto.tensorflow.TensorInfo.serializeBinaryToWriter);r=e.getFilename();r.length>0&&t.writeString(2,r)};proto.tensorflow.AssetFileDef.prototype.getTensorInfo=function(){/** @type{?proto.tensorflow.TensorInfo} */
return M.Message.getWrapperField(this||D,proto.tensorflow.TensorInfo,1)};
/**
 * @param {?proto.tensorflow.TensorInfo|undefined} value
 * @return {!proto.tensorflow.AssetFileDef} returns this
*/proto.tensorflow.AssetFileDef.prototype.setTensorInfo=function(e){return M.Message.setWrapperField(this||D,1,e)};proto.tensorflow.AssetFileDef.prototype.clearTensorInfo=function(){return this.setTensorInfo(void 0)};proto.tensorflow.AssetFileDef.prototype.hasTensorInfo=function(){return M.Message.getField(this||D,1)!=null};proto.tensorflow.AssetFileDef.prototype.getFilename=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.AssetFileDef} returns this
 */proto.tensorflow.AssetFileDef.prototype.setFilename=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.OpDef.repeatedFields_=[2,3,4];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.OpDef.prototype.toObject=function(e){return proto.tensorflow.OpDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.OpDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.OpDef.toObject=function(e,t){var r,o={name:M.Message.getFieldWithDefault(t,1,""),inputArgList:M.Message.toObjectList(t.getInputArgList(),proto.tensorflow.OpDef.ArgDef.toObject,e),outputArgList:M.Message.toObjectList(t.getOutputArgList(),proto.tensorflow.OpDef.ArgDef.toObject,e),attrList:M.Message.toObjectList(t.getAttrList(),proto.tensorflow.OpDef.AttrDef.toObject,e),deprecation:(r=t.getDeprecation())&&proto.tensorflow.OpDef.OpDeprecation.toObject(e,r),summary:M.Message.getFieldWithDefault(t,5,""),description:M.Message.getFieldWithDefault(t,6,""),isCommutative:M.Message.getBooleanFieldWithDefault(t,18,false),isAggregate:M.Message.getBooleanFieldWithDefault(t,16,false),isStateful:M.Message.getBooleanFieldWithDefault(t,17,false),allowsUninitializedInput:M.Message.getBooleanFieldWithDefault(t,19,false)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.OpDef}
 */proto.tensorflow.OpDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.OpDef;return proto.tensorflow.OpDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.OpDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.OpDef}
 */proto.tensorflow.OpDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setName(o);break;case 2:o=new proto.tensorflow.OpDef.ArgDef;t.readMessage(o,proto.tensorflow.OpDef.ArgDef.deserializeBinaryFromReader);e.addInputArg(o);break;case 3:o=new proto.tensorflow.OpDef.ArgDef;t.readMessage(o,proto.tensorflow.OpDef.ArgDef.deserializeBinaryFromReader);e.addOutputArg(o);break;case 4:o=new proto.tensorflow.OpDef.AttrDef;t.readMessage(o,proto.tensorflow.OpDef.AttrDef.deserializeBinaryFromReader);e.addAttr(o);break;case 8:o=new proto.tensorflow.OpDef.OpDeprecation;t.readMessage(o,proto.tensorflow.OpDef.OpDeprecation.deserializeBinaryFromReader);e.setDeprecation(o);break;case 5:o=/** @type {string} */t.readString();e.setSummary(o);break;case 6:o=/** @type {string} */t.readString();e.setDescription(o);break;case 18:o=/** @type {boolean} */t.readBool();e.setIsCommutative(o);break;case 16:o=/** @type {boolean} */t.readBool();e.setIsAggregate(o);break;case 17:o=/** @type {boolean} */t.readBool();e.setIsStateful(o);break;case 19:o=/** @type {boolean} */t.readBool();e.setAllowsUninitializedInput(o);break;default:t.skipField();break}}return e};proto.tensorflow.OpDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.OpDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.OpDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.OpDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getName();r.length>0&&t.writeString(1,r);r=e.getInputArgList();r.length>0&&t.writeRepeatedMessage(2,r,proto.tensorflow.OpDef.ArgDef.serializeBinaryToWriter);r=e.getOutputArgList();r.length>0&&t.writeRepeatedMessage(3,r,proto.tensorflow.OpDef.ArgDef.serializeBinaryToWriter);r=e.getAttrList();r.length>0&&t.writeRepeatedMessage(4,r,proto.tensorflow.OpDef.AttrDef.serializeBinaryToWriter);r=e.getDeprecation();r!=null&&t.writeMessage(8,r,proto.tensorflow.OpDef.OpDeprecation.serializeBinaryToWriter);r=e.getSummary();r.length>0&&t.writeString(5,r);r=e.getDescription();r.length>0&&t.writeString(6,r);r=e.getIsCommutative();r&&t.writeBool(18,r);r=e.getIsAggregate();r&&t.writeBool(16,r);r=e.getIsStateful();r&&t.writeBool(17,r);r=e.getAllowsUninitializedInput();r&&t.writeBool(19,r)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.OpDef.ArgDef.prototype.toObject=function(e){return proto.tensorflow.OpDef.ArgDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.OpDef.ArgDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.OpDef.ArgDef.toObject=function(e,t){var r={name:M.Message.getFieldWithDefault(t,1,""),description:M.Message.getFieldWithDefault(t,2,""),type:M.Message.getFieldWithDefault(t,3,0),typeAttr:M.Message.getFieldWithDefault(t,4,""),numberAttr:M.Message.getFieldWithDefault(t,5,""),typeListAttr:M.Message.getFieldWithDefault(t,6,""),isRef:M.Message.getBooleanFieldWithDefault(t,16,false)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.OpDef.ArgDef}
 */proto.tensorflow.OpDef.ArgDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.OpDef.ArgDef;return proto.tensorflow.OpDef.ArgDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.OpDef.ArgDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.OpDef.ArgDef}
 */proto.tensorflow.OpDef.ArgDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setName(o);break;case 2:o=/** @type {string} */t.readString();e.setDescription(o);break;case 3:o=/** @type {!proto.tensorflow.DataType} */t.readEnum();e.setType(o);break;case 4:o=/** @type {string} */t.readString();e.setTypeAttr(o);break;case 5:o=/** @type {string} */t.readString();e.setNumberAttr(o);break;case 6:o=/** @type {string} */t.readString();e.setTypeListAttr(o);break;case 16:o=/** @type {boolean} */t.readBool();e.setIsRef(o);break;default:t.skipField();break}}return e};proto.tensorflow.OpDef.ArgDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.OpDef.ArgDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.OpDef.ArgDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.OpDef.ArgDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getName();r.length>0&&t.writeString(1,r);r=e.getDescription();r.length>0&&t.writeString(2,r);r=e.getType();r!==0&&t.writeEnum(3,r);r=e.getTypeAttr();r.length>0&&t.writeString(4,r);r=e.getNumberAttr();r.length>0&&t.writeString(5,r);r=e.getTypeListAttr();r.length>0&&t.writeString(6,r);r=e.getIsRef();r&&t.writeBool(16,r)};proto.tensorflow.OpDef.ArgDef.prototype.getName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.ArgDef} returns this
 */proto.tensorflow.OpDef.ArgDef.prototype.setName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.OpDef.ArgDef.prototype.getDescription=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.ArgDef} returns this
 */proto.tensorflow.OpDef.ArgDef.prototype.setDescription=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.OpDef.ArgDef.prototype.getType=function(){/** @type {!proto.tensorflow.DataType} */
return M.Message.getFieldWithDefault(this||D,3,0)};
/**
 * @param {!proto.tensorflow.DataType} value
 * @return {!proto.tensorflow.OpDef.ArgDef} returns this
 */proto.tensorflow.OpDef.ArgDef.prototype.setType=function(e){return M.Message.setProto3EnumField(this||D,3,e)};proto.tensorflow.OpDef.ArgDef.prototype.getTypeAttr=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,4,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.ArgDef} returns this
 */proto.tensorflow.OpDef.ArgDef.prototype.setTypeAttr=function(e){return M.Message.setProto3StringField(this||D,4,e)};proto.tensorflow.OpDef.ArgDef.prototype.getNumberAttr=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,5,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.ArgDef} returns this
 */proto.tensorflow.OpDef.ArgDef.prototype.setNumberAttr=function(e){return M.Message.setProto3StringField(this||D,5,e)};proto.tensorflow.OpDef.ArgDef.prototype.getTypeListAttr=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,6,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.ArgDef} returns this
 */proto.tensorflow.OpDef.ArgDef.prototype.setTypeListAttr=function(e){return M.Message.setProto3StringField(this||D,6,e)};proto.tensorflow.OpDef.ArgDef.prototype.getIsRef=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,16,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.OpDef.ArgDef} returns this
 */proto.tensorflow.OpDef.ArgDef.prototype.setIsRef=function(e){return M.Message.setProto3BooleanField(this||D,16,e)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.OpDef.AttrDef.prototype.toObject=function(e){return proto.tensorflow.OpDef.AttrDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.OpDef.AttrDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.OpDef.AttrDef.toObject=function(e,t){var r,o={name:M.Message.getFieldWithDefault(t,1,""),type:M.Message.getFieldWithDefault(t,2,""),defaultValue:(r=t.getDefaultValue())&&proto.tensorflow.AttrValue.toObject(e,r),description:M.Message.getFieldWithDefault(t,4,""),hasMinimum:M.Message.getBooleanFieldWithDefault(t,5,false),minimum:M.Message.getFieldWithDefault(t,6,0),allowedValues:(r=t.getAllowedValues())&&proto.tensorflow.AttrValue.toObject(e,r)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.OpDef.AttrDef}
 */proto.tensorflow.OpDef.AttrDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.OpDef.AttrDef;return proto.tensorflow.OpDef.AttrDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.OpDef.AttrDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.OpDef.AttrDef}
 */proto.tensorflow.OpDef.AttrDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setName(o);break;case 2:o=/** @type {string} */t.readString();e.setType(o);break;case 3:o=new proto.tensorflow.AttrValue;t.readMessage(o,proto.tensorflow.AttrValue.deserializeBinaryFromReader);e.setDefaultValue(o);break;case 4:o=/** @type {string} */t.readString();e.setDescription(o);break;case 5:o=/** @type {boolean} */t.readBool();e.setHasMinimum(o);break;case 6:o=/** @type {number} */t.readInt64();e.setMinimum(o);break;case 7:o=new proto.tensorflow.AttrValue;t.readMessage(o,proto.tensorflow.AttrValue.deserializeBinaryFromReader);e.setAllowedValues(o);break;default:t.skipField();break}}return e};proto.tensorflow.OpDef.AttrDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.OpDef.AttrDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.OpDef.AttrDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.OpDef.AttrDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getName();r.length>0&&t.writeString(1,r);r=e.getType();r.length>0&&t.writeString(2,r);r=e.getDefaultValue();r!=null&&t.writeMessage(3,r,proto.tensorflow.AttrValue.serializeBinaryToWriter);r=e.getDescription();r.length>0&&t.writeString(4,r);r=e.getHasMinimum();r&&t.writeBool(5,r);r=e.getMinimum();r!==0&&t.writeInt64(6,r);r=e.getAllowedValues();r!=null&&t.writeMessage(7,r,proto.tensorflow.AttrValue.serializeBinaryToWriter)};proto.tensorflow.OpDef.AttrDef.prototype.getName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.AttrDef} returns this
 */proto.tensorflow.OpDef.AttrDef.prototype.setName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.OpDef.AttrDef.prototype.getType=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.AttrDef} returns this
 */proto.tensorflow.OpDef.AttrDef.prototype.setType=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.OpDef.AttrDef.prototype.getDefaultValue=function(){/** @type{?proto.tensorflow.AttrValue} */
return M.Message.getWrapperField(this||D,proto.tensorflow.AttrValue,3)};
/**
 * @param {?proto.tensorflow.AttrValue|undefined} value
 * @return {!proto.tensorflow.OpDef.AttrDef} returns this
*/proto.tensorflow.OpDef.AttrDef.prototype.setDefaultValue=function(e){return M.Message.setWrapperField(this||D,3,e)};proto.tensorflow.OpDef.AttrDef.prototype.clearDefaultValue=function(){return this.setDefaultValue(void 0)};proto.tensorflow.OpDef.AttrDef.prototype.hasDefaultValue=function(){return M.Message.getField(this||D,3)!=null};proto.tensorflow.OpDef.AttrDef.prototype.getDescription=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,4,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.AttrDef} returns this
 */proto.tensorflow.OpDef.AttrDef.prototype.setDescription=function(e){return M.Message.setProto3StringField(this||D,4,e)};proto.tensorflow.OpDef.AttrDef.prototype.getHasMinimum=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,5,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.OpDef.AttrDef} returns this
 */proto.tensorflow.OpDef.AttrDef.prototype.setHasMinimum=function(e){return M.Message.setProto3BooleanField(this||D,5,e)};proto.tensorflow.OpDef.AttrDef.prototype.getMinimum=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,6,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.OpDef.AttrDef} returns this
 */proto.tensorflow.OpDef.AttrDef.prototype.setMinimum=function(e){return M.Message.setProto3IntField(this||D,6,e)};proto.tensorflow.OpDef.AttrDef.prototype.getAllowedValues=function(){/** @type{?proto.tensorflow.AttrValue} */
return M.Message.getWrapperField(this||D,proto.tensorflow.AttrValue,7)};
/**
 * @param {?proto.tensorflow.AttrValue|undefined} value
 * @return {!proto.tensorflow.OpDef.AttrDef} returns this
*/proto.tensorflow.OpDef.AttrDef.prototype.setAllowedValues=function(e){return M.Message.setWrapperField(this||D,7,e)};proto.tensorflow.OpDef.AttrDef.prototype.clearAllowedValues=function(){return this.setAllowedValues(void 0)};proto.tensorflow.OpDef.AttrDef.prototype.hasAllowedValues=function(){return M.Message.getField(this||D,7)!=null};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.OpDef.OpDeprecation.prototype.toObject=function(e){return proto.tensorflow.OpDef.OpDeprecation.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.OpDef.OpDeprecation} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.OpDef.OpDeprecation.toObject=function(e,t){var r={version:M.Message.getFieldWithDefault(t,1,0),explanation:M.Message.getFieldWithDefault(t,2,"")};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.OpDef.OpDeprecation}
 */proto.tensorflow.OpDef.OpDeprecation.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.OpDef.OpDeprecation;return proto.tensorflow.OpDef.OpDeprecation.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.OpDef.OpDeprecation} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.OpDef.OpDeprecation}
 */proto.tensorflow.OpDef.OpDeprecation.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readInt32();e.setVersion(o);break;case 2:o=/** @type {string} */t.readString();e.setExplanation(o);break;default:t.skipField();break}}return e};proto.tensorflow.OpDef.OpDeprecation.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.OpDef.OpDeprecation.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.OpDef.OpDeprecation} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.OpDef.OpDeprecation.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getVersion();r!==0&&t.writeInt32(1,r);r=e.getExplanation();r.length>0&&t.writeString(2,r)};proto.tensorflow.OpDef.OpDeprecation.prototype.getVersion=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.OpDef.OpDeprecation} returns this
 */proto.tensorflow.OpDef.OpDeprecation.prototype.setVersion=function(e){return M.Message.setProto3IntField(this||D,1,e)};proto.tensorflow.OpDef.OpDeprecation.prototype.getExplanation=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef.OpDeprecation} returns this
 */proto.tensorflow.OpDef.OpDeprecation.prototype.setExplanation=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.OpDef.prototype.getName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef} returns this
 */proto.tensorflow.OpDef.prototype.setName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.OpDef.prototype.getInputArgList=function(){/** @type{!Array<!proto.tensorflow.OpDef.ArgDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.OpDef.ArgDef,2)};
/**
 * @param {!Array<!proto.tensorflow.OpDef.ArgDef>} value
 * @return {!proto.tensorflow.OpDef} returns this
*/proto.tensorflow.OpDef.prototype.setInputArgList=function(e){return M.Message.setRepeatedWrapperField(this||D,2,e)};
/**
 * @param {!proto.tensorflow.OpDef.ArgDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.OpDef.ArgDef}
 */proto.tensorflow.OpDef.prototype.addInputArg=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,2,e,proto.tensorflow.OpDef.ArgDef,t)};proto.tensorflow.OpDef.prototype.clearInputArgList=function(){return this.setInputArgList([])};proto.tensorflow.OpDef.prototype.getOutputArgList=function(){/** @type{!Array<!proto.tensorflow.OpDef.ArgDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.OpDef.ArgDef,3)};
/**
 * @param {!Array<!proto.tensorflow.OpDef.ArgDef>} value
 * @return {!proto.tensorflow.OpDef} returns this
*/proto.tensorflow.OpDef.prototype.setOutputArgList=function(e){return M.Message.setRepeatedWrapperField(this||D,3,e)};
/**
 * @param {!proto.tensorflow.OpDef.ArgDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.OpDef.ArgDef}
 */proto.tensorflow.OpDef.prototype.addOutputArg=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,3,e,proto.tensorflow.OpDef.ArgDef,t)};proto.tensorflow.OpDef.prototype.clearOutputArgList=function(){return this.setOutputArgList([])};proto.tensorflow.OpDef.prototype.getAttrList=function(){/** @type{!Array<!proto.tensorflow.OpDef.AttrDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.OpDef.AttrDef,4)};
/**
 * @param {!Array<!proto.tensorflow.OpDef.AttrDef>} value
 * @return {!proto.tensorflow.OpDef} returns this
*/proto.tensorflow.OpDef.prototype.setAttrList=function(e){return M.Message.setRepeatedWrapperField(this||D,4,e)};
/**
 * @param {!proto.tensorflow.OpDef.AttrDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.OpDef.AttrDef}
 */proto.tensorflow.OpDef.prototype.addAttr=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,4,e,proto.tensorflow.OpDef.AttrDef,t)};proto.tensorflow.OpDef.prototype.clearAttrList=function(){return this.setAttrList([])};proto.tensorflow.OpDef.prototype.getDeprecation=function(){/** @type{?proto.tensorflow.OpDef.OpDeprecation} */
return M.Message.getWrapperField(this||D,proto.tensorflow.OpDef.OpDeprecation,8)};
/**
 * @param {?proto.tensorflow.OpDef.OpDeprecation|undefined} value
 * @return {!proto.tensorflow.OpDef} returns this
*/proto.tensorflow.OpDef.prototype.setDeprecation=function(e){return M.Message.setWrapperField(this||D,8,e)};proto.tensorflow.OpDef.prototype.clearDeprecation=function(){return this.setDeprecation(void 0)};proto.tensorflow.OpDef.prototype.hasDeprecation=function(){return M.Message.getField(this||D,8)!=null};proto.tensorflow.OpDef.prototype.getSummary=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,5,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef} returns this
 */proto.tensorflow.OpDef.prototype.setSummary=function(e){return M.Message.setProto3StringField(this||D,5,e)};proto.tensorflow.OpDef.prototype.getDescription=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,6,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.OpDef} returns this
 */proto.tensorflow.OpDef.prototype.setDescription=function(e){return M.Message.setProto3StringField(this||D,6,e)};proto.tensorflow.OpDef.prototype.getIsCommutative=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,18,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.OpDef} returns this
 */proto.tensorflow.OpDef.prototype.setIsCommutative=function(e){return M.Message.setProto3BooleanField(this||D,18,e)};proto.tensorflow.OpDef.prototype.getIsAggregate=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,16,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.OpDef} returns this
 */proto.tensorflow.OpDef.prototype.setIsAggregate=function(e){return M.Message.setProto3BooleanField(this||D,16,e)};proto.tensorflow.OpDef.prototype.getIsStateful=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,17,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.OpDef} returns this
 */proto.tensorflow.OpDef.prototype.setIsStateful=function(e){return M.Message.setProto3BooleanField(this||D,17,e)};proto.tensorflow.OpDef.prototype.getAllowsUninitializedInput=function(){/** @type {boolean} */
return M.Message.getBooleanFieldWithDefault(this||D,19,false)};
/**
 * @param {boolean} value
 * @return {!proto.tensorflow.OpDef} returns this
 */proto.tensorflow.OpDef.prototype.setAllowsUninitializedInput=function(e){return M.Message.setProto3BooleanField(this||D,19,e)};proto.tensorflow.OpList.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.OpList.prototype.toObject=function(e){return proto.tensorflow.OpList.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.OpList} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.OpList.toObject=function(e,t){var r={opList:M.Message.toObjectList(t.getOpList(),proto.tensorflow.OpDef.toObject,e)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.OpList}
 */proto.tensorflow.OpList.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.OpList;return proto.tensorflow.OpList.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.OpList} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.OpList}
 */proto.tensorflow.OpList.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.OpDef;t.readMessage(o,proto.tensorflow.OpDef.deserializeBinaryFromReader);e.addOp(o);break;default:t.skipField();break}}return e};proto.tensorflow.OpList.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.OpList.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.OpList} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.OpList.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getOpList();r.length>0&&t.writeRepeatedMessage(1,r,proto.tensorflow.OpDef.serializeBinaryToWriter)};proto.tensorflow.OpList.prototype.getOpList=function(){/** @type{!Array<!proto.tensorflow.OpDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.OpDef,1)};
/**
 * @param {!Array<!proto.tensorflow.OpDef>} value
 * @return {!proto.tensorflow.OpList} returns this
*/proto.tensorflow.OpList.prototype.setOpList=function(e){return M.Message.setRepeatedWrapperField(this||D,1,e)};
/**
 * @param {!proto.tensorflow.OpDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.OpDef}
 */proto.tensorflow.OpList.prototype.addOp=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,1,e,proto.tensorflow.OpDef,t)};proto.tensorflow.OpList.prototype.clearOpList=function(){return this.setOpList([])};proto.tensorflow.MetaGraphDef.repeatedFields_=[6];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.MetaGraphDef.prototype.toObject=function(e){return proto.tensorflow.MetaGraphDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.MetaGraphDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.MetaGraphDef.toObject=function(e,t){var r,o={metaInfoDef:(r=t.getMetaInfoDef())&&proto.tensorflow.MetaGraphDef.MetaInfoDef.toObject(e,r),graphDef:(r=t.getGraphDef())&&proto.tensorflow.GraphDef.toObject(e,r),saverDef:(r=t.getSaverDef())&&proto.tensorflow.SaverDef.toObject(e,r),collectionDefMap:(r=t.getCollectionDefMap())?r.toObject(e,proto.tensorflow.CollectionDef.toObject):[],signatureDefMap:(r=t.getSignatureDefMap())?r.toObject(e,proto.tensorflow.SignatureDef.toObject):[],assetFileDefList:M.Message.toObjectList(t.getAssetFileDefList(),proto.tensorflow.AssetFileDef.toObject,e)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.MetaGraphDef}
 */proto.tensorflow.MetaGraphDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.MetaGraphDef;return proto.tensorflow.MetaGraphDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.MetaGraphDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.MetaGraphDef}
 */proto.tensorflow.MetaGraphDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.MetaGraphDef.MetaInfoDef;t.readMessage(o,proto.tensorflow.MetaGraphDef.MetaInfoDef.deserializeBinaryFromReader);e.setMetaInfoDef(o);break;case 2:o=new proto.tensorflow.GraphDef;t.readMessage(o,proto.tensorflow.GraphDef.deserializeBinaryFromReader);e.setGraphDef(o);break;case 3:o=new proto.tensorflow.SaverDef;t.readMessage(o,proto.tensorflow.SaverDef.deserializeBinaryFromReader);e.setSaverDef(o);break;case 4:o=e.getCollectionDefMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readMessage,proto.tensorflow.CollectionDef.deserializeBinaryFromReader,"",new proto.tensorflow.CollectionDef)}));break;case 5:o=e.getSignatureDefMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readMessage,proto.tensorflow.SignatureDef.deserializeBinaryFromReader,"",new proto.tensorflow.SignatureDef)}));break;case 6:o=new proto.tensorflow.AssetFileDef;t.readMessage(o,proto.tensorflow.AssetFileDef.deserializeBinaryFromReader);e.addAssetFileDef(o);break;default:t.skipField();break}}return e};proto.tensorflow.MetaGraphDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.MetaGraphDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.MetaGraphDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.MetaGraphDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getMetaInfoDef();r!=null&&t.writeMessage(1,r,proto.tensorflow.MetaGraphDef.MetaInfoDef.serializeBinaryToWriter);r=e.getGraphDef();r!=null&&t.writeMessage(2,r,proto.tensorflow.GraphDef.serializeBinaryToWriter);r=e.getSaverDef();r!=null&&t.writeMessage(3,r,proto.tensorflow.SaverDef.serializeBinaryToWriter);r=e.getCollectionDefMap(true);r&&r.getLength()>0&&r.serializeBinary(4,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeMessage,proto.tensorflow.CollectionDef.serializeBinaryToWriter);r=e.getSignatureDefMap(true);r&&r.getLength()>0&&r.serializeBinary(5,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeMessage,proto.tensorflow.SignatureDef.serializeBinaryToWriter);r=e.getAssetFileDefList();r.length>0&&t.writeRepeatedMessage(6,r,proto.tensorflow.AssetFileDef.serializeBinaryToWriter)};proto.tensorflow.MetaGraphDef.MetaInfoDef.repeatedFields_=[4];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.toObject=function(e){return proto.tensorflow.MetaGraphDef.MetaInfoDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.MetaGraphDef.MetaInfoDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.MetaGraphDef.MetaInfoDef.toObject=function(e,t){var r,o={metaGraphVersion:M.Message.getFieldWithDefault(t,1,""),strippedOpList:(r=t.getStrippedOpList())&&proto.tensorflow.OpList.toObject(e,r),anyInfo:(r=t.getAnyInfo())&&proto.tensorflow.Any.toObject(e,r),tagsList:(r=M.Message.getRepeatedField(t,4))==null?void 0:r,tensorflowVersion:M.Message.getFieldWithDefault(t,5,""),tensorflowGitVersion:M.Message.getFieldWithDefault(t,6,"")};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef}
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.MetaGraphDef.MetaInfoDef;return proto.tensorflow.MetaGraphDef.MetaInfoDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.MetaGraphDef.MetaInfoDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef}
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setMetaGraphVersion(o);break;case 2:o=new proto.tensorflow.OpList;t.readMessage(o,proto.tensorflow.OpList.deserializeBinaryFromReader);e.setStrippedOpList(o);break;case 3:o=new proto.tensorflow.Any;t.readMessage(o,proto.tensorflow.Any.deserializeBinaryFromReader);e.setAnyInfo(o);break;case 4:o=/** @type {string} */t.readString();e.addTags(o);break;case 5:o=/** @type {string} */t.readString();e.setTensorflowVersion(o);break;case 6:o=/** @type {string} */t.readString();e.setTensorflowGitVersion(o);break;default:t.skipField();break}}return e};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.MetaGraphDef.MetaInfoDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.MetaGraphDef.MetaInfoDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getMetaGraphVersion();r.length>0&&t.writeString(1,r);r=e.getStrippedOpList();r!=null&&t.writeMessage(2,r,proto.tensorflow.OpList.serializeBinaryToWriter);r=e.getAnyInfo();r!=null&&t.writeMessage(3,r,proto.tensorflow.Any.serializeBinaryToWriter);r=e.getTagsList();r.length>0&&t.writeRepeatedString(4,r);r=e.getTensorflowVersion();r.length>0&&t.writeString(5,r);r=e.getTensorflowGitVersion();r.length>0&&t.writeString(6,r)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.getMetaGraphVersion=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef} returns this
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.setMetaGraphVersion=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.getStrippedOpList=function(){/** @type{?proto.tensorflow.OpList} */
return M.Message.getWrapperField(this||D,proto.tensorflow.OpList,2)};
/**
 * @param {?proto.tensorflow.OpList|undefined} value
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef} returns this
*/proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.setStrippedOpList=function(e){return M.Message.setWrapperField(this||D,2,e)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.clearStrippedOpList=function(){return this.setStrippedOpList(void 0)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.hasStrippedOpList=function(){return M.Message.getField(this||D,2)!=null};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.getAnyInfo=function(){/** @type{?proto.tensorflow.Any} */
return M.Message.getWrapperField(this||D,proto.tensorflow.Any,3)};
/**
 * @param {?proto.tensorflow.Any|undefined} value
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef} returns this
*/proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.setAnyInfo=function(e){return M.Message.setWrapperField(this||D,3,e)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.clearAnyInfo=function(){return this.setAnyInfo(void 0)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.hasAnyInfo=function(){return M.Message.getField(this||D,3)!=null};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.getTagsList=function(){/** @type {!Array<string>} */
return M.Message.getRepeatedField(this||D,4)};
/**
 * @param {!Array<string>} value
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef} returns this
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.setTagsList=function(e){return M.Message.setField(this||D,4,e||[])};
/**
 * @param {string} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef} returns this
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.addTags=function(e,t){return M.Message.addToRepeatedField(this||D,4,e,t)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.clearTagsList=function(){return this.setTagsList([])};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.getTensorflowVersion=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,5,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef} returns this
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.setTensorflowVersion=function(e){return M.Message.setProto3StringField(this||D,5,e)};proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.getTensorflowGitVersion=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,6,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.MetaGraphDef.MetaInfoDef} returns this
 */proto.tensorflow.MetaGraphDef.MetaInfoDef.prototype.setTensorflowGitVersion=function(e){return M.Message.setProto3StringField(this||D,6,e)};proto.tensorflow.MetaGraphDef.prototype.getMetaInfoDef=function(){/** @type{?proto.tensorflow.MetaGraphDef.MetaInfoDef} */
return M.Message.getWrapperField(this||D,proto.tensorflow.MetaGraphDef.MetaInfoDef,1)};
/**
 * @param {?proto.tensorflow.MetaGraphDef.MetaInfoDef|undefined} value
 * @return {!proto.tensorflow.MetaGraphDef} returns this
*/proto.tensorflow.MetaGraphDef.prototype.setMetaInfoDef=function(e){return M.Message.setWrapperField(this||D,1,e)};proto.tensorflow.MetaGraphDef.prototype.clearMetaInfoDef=function(){return this.setMetaInfoDef(void 0)};proto.tensorflow.MetaGraphDef.prototype.hasMetaInfoDef=function(){return M.Message.getField(this||D,1)!=null};proto.tensorflow.MetaGraphDef.prototype.getGraphDef=function(){/** @type{?proto.tensorflow.GraphDef} */
return M.Message.getWrapperField(this||D,proto.tensorflow.GraphDef,2)};
/**
 * @param {?proto.tensorflow.GraphDef|undefined} value
 * @return {!proto.tensorflow.MetaGraphDef} returns this
*/proto.tensorflow.MetaGraphDef.prototype.setGraphDef=function(e){return M.Message.setWrapperField(this||D,2,e)};proto.tensorflow.MetaGraphDef.prototype.clearGraphDef=function(){return this.setGraphDef(void 0)};proto.tensorflow.MetaGraphDef.prototype.hasGraphDef=function(){return M.Message.getField(this||D,2)!=null};proto.tensorflow.MetaGraphDef.prototype.getSaverDef=function(){/** @type{?proto.tensorflow.SaverDef} */
return M.Message.getWrapperField(this||D,proto.tensorflow.SaverDef,3)};
/**
 * @param {?proto.tensorflow.SaverDef|undefined} value
 * @return {!proto.tensorflow.MetaGraphDef} returns this
*/proto.tensorflow.MetaGraphDef.prototype.setSaverDef=function(e){return M.Message.setWrapperField(this||D,3,e)};proto.tensorflow.MetaGraphDef.prototype.clearSaverDef=function(){return this.setSaverDef(void 0)};proto.tensorflow.MetaGraphDef.prototype.hasSaverDef=function(){return M.Message.getField(this||D,3)!=null};
/**
 * map<string, CollectionDef> collection_def = 4;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,!proto.tensorflow.CollectionDef>}
 */proto.tensorflow.MetaGraphDef.prototype.getCollectionDefMap=function(e){/** @type {!jspb.Map<string,!proto.tensorflow.CollectionDef>} */
return M.Message.getMapField(this||D,4,e,proto.tensorflow.CollectionDef)};proto.tensorflow.MetaGraphDef.prototype.clearCollectionDefMap=function(){this.getCollectionDefMap().clear();return this||D};
/**
 * map<string, SignatureDef> signature_def = 5;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,!proto.tensorflow.SignatureDef>}
 */proto.tensorflow.MetaGraphDef.prototype.getSignatureDefMap=function(e){/** @type {!jspb.Map<string,!proto.tensorflow.SignatureDef>} */
return M.Message.getMapField(this||D,5,e,proto.tensorflow.SignatureDef)};proto.tensorflow.MetaGraphDef.prototype.clearSignatureDefMap=function(){this.getSignatureDefMap().clear();return this||D};proto.tensorflow.MetaGraphDef.prototype.getAssetFileDefList=function(){/** @type{!Array<!proto.tensorflow.AssetFileDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.AssetFileDef,6)};
/**
 * @param {!Array<!proto.tensorflow.AssetFileDef>} value
 * @return {!proto.tensorflow.MetaGraphDef} returns this
*/proto.tensorflow.MetaGraphDef.prototype.setAssetFileDefList=function(e){return M.Message.setRepeatedWrapperField(this||D,6,e)};
/**
 * @param {!proto.tensorflow.AssetFileDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.AssetFileDef}
 */proto.tensorflow.MetaGraphDef.prototype.addAssetFileDef=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,6,e,proto.tensorflow.AssetFileDef,t)};proto.tensorflow.MetaGraphDef.prototype.clearAssetFileDefList=function(){return this.setAssetFileDefList([])};proto.tensorflow.SavedModel.repeatedFields_=[2];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.SavedModel.prototype.toObject=function(e){return proto.tensorflow.SavedModel.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.SavedModel} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.SavedModel.toObject=function(e,t){var r={savedModelSchemaVersion:M.Message.getFieldWithDefault(t,1,0),metaGraphsList:M.Message.toObjectList(t.getMetaGraphsList(),proto.tensorflow.MetaGraphDef.toObject,e)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.SavedModel}
 */proto.tensorflow.SavedModel.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.SavedModel;return proto.tensorflow.SavedModel.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.SavedModel} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.SavedModel}
 */proto.tensorflow.SavedModel.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readInt64();e.setSavedModelSchemaVersion(o);break;case 2:o=new proto.tensorflow.MetaGraphDef;t.readMessage(o,proto.tensorflow.MetaGraphDef.deserializeBinaryFromReader);e.addMetaGraphs(o);break;default:t.skipField();break}}return e};proto.tensorflow.SavedModel.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.SavedModel.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.SavedModel} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.SavedModel.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getSavedModelSchemaVersion();r!==0&&t.writeInt64(1,r);r=e.getMetaGraphsList();r.length>0&&t.writeRepeatedMessage(2,r,proto.tensorflow.MetaGraphDef.serializeBinaryToWriter)};proto.tensorflow.SavedModel.prototype.getSavedModelSchemaVersion=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.SavedModel} returns this
 */proto.tensorflow.SavedModel.prototype.setSavedModelSchemaVersion=function(e){return M.Message.setProto3IntField(this||D,1,e)};proto.tensorflow.SavedModel.prototype.getMetaGraphsList=function(){/** @type{!Array<!proto.tensorflow.MetaGraphDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.MetaGraphDef,2)};
/**
 * @param {!Array<!proto.tensorflow.MetaGraphDef>} value
 * @return {!proto.tensorflow.SavedModel} returns this
*/proto.tensorflow.SavedModel.prototype.setMetaGraphsList=function(e){return M.Message.setRepeatedWrapperField(this||D,2,e)};
/**
 * @param {!proto.tensorflow.MetaGraphDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.MetaGraphDef}
 */proto.tensorflow.SavedModel.prototype.addMetaGraphs=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,2,e,proto.tensorflow.MetaGraphDef,t)};proto.tensorflow.SavedModel.prototype.clearMetaGraphsList=function(){return this.setMetaGraphsList([])};proto.tensorflow.FunctionDefLibrary.repeatedFields_=[1,2];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.FunctionDefLibrary.prototype.toObject=function(e){return proto.tensorflow.FunctionDefLibrary.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.FunctionDefLibrary} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.FunctionDefLibrary.toObject=function(e,t){var r={functionList:M.Message.toObjectList(t.getFunctionList(),proto.tensorflow.FunctionDef.toObject,e),gradientList:M.Message.toObjectList(t.getGradientList(),proto.tensorflow.GradientDef.toObject,e)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.FunctionDefLibrary}
 */proto.tensorflow.FunctionDefLibrary.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.FunctionDefLibrary;return proto.tensorflow.FunctionDefLibrary.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.FunctionDefLibrary} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.FunctionDefLibrary}
 */proto.tensorflow.FunctionDefLibrary.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.FunctionDef;t.readMessage(o,proto.tensorflow.FunctionDef.deserializeBinaryFromReader);e.addFunction(o);break;case 2:o=new proto.tensorflow.GradientDef;t.readMessage(o,proto.tensorflow.GradientDef.deserializeBinaryFromReader);e.addGradient(o);break;default:t.skipField();break}}return e};proto.tensorflow.FunctionDefLibrary.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.FunctionDefLibrary.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.FunctionDefLibrary} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.FunctionDefLibrary.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getFunctionList();r.length>0&&t.writeRepeatedMessage(1,r,proto.tensorflow.FunctionDef.serializeBinaryToWriter);r=e.getGradientList();r.length>0&&t.writeRepeatedMessage(2,r,proto.tensorflow.GradientDef.serializeBinaryToWriter)};proto.tensorflow.FunctionDefLibrary.prototype.getFunctionList=function(){/** @type{!Array<!proto.tensorflow.FunctionDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.FunctionDef,1)};
/**
 * @param {!Array<!proto.tensorflow.FunctionDef>} value
 * @return {!proto.tensorflow.FunctionDefLibrary} returns this
*/proto.tensorflow.FunctionDefLibrary.prototype.setFunctionList=function(e){return M.Message.setRepeatedWrapperField(this||D,1,e)};
/**
 * @param {!proto.tensorflow.FunctionDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.FunctionDef}
 */proto.tensorflow.FunctionDefLibrary.prototype.addFunction=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,1,e,proto.tensorflow.FunctionDef,t)};proto.tensorflow.FunctionDefLibrary.prototype.clearFunctionList=function(){return this.setFunctionList([])};proto.tensorflow.FunctionDefLibrary.prototype.getGradientList=function(){/** @type{!Array<!proto.tensorflow.GradientDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.GradientDef,2)};
/**
 * @param {!Array<!proto.tensorflow.GradientDef>} value
 * @return {!proto.tensorflow.FunctionDefLibrary} returns this
*/proto.tensorflow.FunctionDefLibrary.prototype.setGradientList=function(e){return M.Message.setRepeatedWrapperField(this||D,2,e)};
/**
 * @param {!proto.tensorflow.GradientDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.GradientDef}
 */proto.tensorflow.FunctionDefLibrary.prototype.addGradient=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,2,e,proto.tensorflow.GradientDef,t)};proto.tensorflow.FunctionDefLibrary.prototype.clearGradientList=function(){return this.setGradientList([])};proto.tensorflow.FunctionDef.repeatedFields_=[3];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.FunctionDef.prototype.toObject=function(e){return proto.tensorflow.FunctionDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.FunctionDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.FunctionDef.toObject=function(e,t){var r,o={signature:(r=t.getSignature())&&proto.tensorflow.OpDef.toObject(e,r),attrMap:(r=t.getAttrMap())?r.toObject(e,proto.tensorflow.AttrValue.toObject):[],nodeDefList:M.Message.toObjectList(t.getNodeDefList(),proto.tensorflow.NodeDef.toObject,e),retMap:(r=t.getRetMap())?r.toObject(e,void 0):[]};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.FunctionDef}
 */proto.tensorflow.FunctionDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.FunctionDef;return proto.tensorflow.FunctionDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.FunctionDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.FunctionDef}
 */proto.tensorflow.FunctionDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.OpDef;t.readMessage(o,proto.tensorflow.OpDef.deserializeBinaryFromReader);e.setSignature(o);break;case 5:o=e.getAttrMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readMessage,proto.tensorflow.AttrValue.deserializeBinaryFromReader,"",new proto.tensorflow.AttrValue)}));break;case 3:o=new proto.tensorflow.NodeDef;t.readMessage(o,proto.tensorflow.NodeDef.deserializeBinaryFromReader);e.addNodeDef(o);break;case 4:o=e.getRetMap();t.readMessage(o,(function(e,t){M.Map.deserializeBinary(e,t,M.BinaryReader.prototype.readString,M.BinaryReader.prototype.readString,null,"","")}));break;default:t.skipField();break}}return e};proto.tensorflow.FunctionDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.FunctionDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.FunctionDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.FunctionDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getSignature();r!=null&&t.writeMessage(1,r,proto.tensorflow.OpDef.serializeBinaryToWriter);r=e.getAttrMap(true);r&&r.getLength()>0&&r.serializeBinary(5,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeMessage,proto.tensorflow.AttrValue.serializeBinaryToWriter);r=e.getNodeDefList();r.length>0&&t.writeRepeatedMessage(3,r,proto.tensorflow.NodeDef.serializeBinaryToWriter);r=e.getRetMap(true);r&&r.getLength()>0&&r.serializeBinary(4,t,M.BinaryWriter.prototype.writeString,M.BinaryWriter.prototype.writeString)};proto.tensorflow.FunctionDef.prototype.getSignature=function(){/** @type{?proto.tensorflow.OpDef} */
return M.Message.getWrapperField(this||D,proto.tensorflow.OpDef,1)};
/**
 * @param {?proto.tensorflow.OpDef|undefined} value
 * @return {!proto.tensorflow.FunctionDef} returns this
*/proto.tensorflow.FunctionDef.prototype.setSignature=function(e){return M.Message.setWrapperField(this||D,1,e)};proto.tensorflow.FunctionDef.prototype.clearSignature=function(){return this.setSignature(void 0)};proto.tensorflow.FunctionDef.prototype.hasSignature=function(){return M.Message.getField(this||D,1)!=null};
/**
 * map<string, AttrValue> attr = 5;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,!proto.tensorflow.AttrValue>}
 */proto.tensorflow.FunctionDef.prototype.getAttrMap=function(e){/** @type {!jspb.Map<string,!proto.tensorflow.AttrValue>} */
return M.Message.getMapField(this||D,5,e,proto.tensorflow.AttrValue)};proto.tensorflow.FunctionDef.prototype.clearAttrMap=function(){this.getAttrMap().clear();return this||D};proto.tensorflow.FunctionDef.prototype.getNodeDefList=function(){/** @type{!Array<!proto.tensorflow.NodeDef>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.NodeDef,3)};
/**
 * @param {!Array<!proto.tensorflow.NodeDef>} value
 * @return {!proto.tensorflow.FunctionDef} returns this
*/proto.tensorflow.FunctionDef.prototype.setNodeDefList=function(e){return M.Message.setRepeatedWrapperField(this||D,3,e)};
/**
 * @param {!proto.tensorflow.NodeDef=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.NodeDef}
 */proto.tensorflow.FunctionDef.prototype.addNodeDef=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,3,e,proto.tensorflow.NodeDef,t)};proto.tensorflow.FunctionDef.prototype.clearNodeDefList=function(){return this.setNodeDefList([])};
/**
 * map<string, string> ret = 4;
 * @param {boolean=} opt_noLazyCreate Do not create the map if
 * empty, instead returning `undefined`
 * @return {!jspb.Map<string,string>}
 */proto.tensorflow.FunctionDef.prototype.getRetMap=function(e){/** @type {!jspb.Map<string,string>} */
return M.Message.getMapField(this||D,4,e,null)};proto.tensorflow.FunctionDef.prototype.clearRetMap=function(){this.getRetMap().clear();return this||D};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.GradientDef.prototype.toObject=function(e){return proto.tensorflow.GradientDef.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.GradientDef} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.GradientDef.toObject=function(e,t){var r={functionName:M.Message.getFieldWithDefault(t,1,""),gradientFunc:M.Message.getFieldWithDefault(t,2,"")};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.GradientDef}
 */proto.tensorflow.GradientDef.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.GradientDef;return proto.tensorflow.GradientDef.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.GradientDef} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.GradientDef}
 */proto.tensorflow.GradientDef.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setFunctionName(o);break;case 2:o=/** @type {string} */t.readString();e.setGradientFunc(o);break;default:t.skipField();break}}return e};proto.tensorflow.GradientDef.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.GradientDef.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.GradientDef} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.GradientDef.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getFunctionName();r.length>0&&t.writeString(1,r);r=e.getGradientFunc();r.length>0&&t.writeString(2,r)};proto.tensorflow.GradientDef.prototype.getFunctionName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.GradientDef} returns this
 */proto.tensorflow.GradientDef.prototype.setFunctionName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.GradientDef.prototype.getGradientFunc=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.GradientDef} returns this
 */proto.tensorflow.GradientDef.prototype.setGradientFunc=function(e){return M.Message.setProto3StringField(this||D,2,e)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.SummaryDescription.prototype.toObject=function(e){return proto.tensorflow.SummaryDescription.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.SummaryDescription} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.SummaryDescription.toObject=function(e,t){var r={typeHint:M.Message.getFieldWithDefault(t,1,"")};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.SummaryDescription}
 */proto.tensorflow.SummaryDescription.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.SummaryDescription;return proto.tensorflow.SummaryDescription.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.SummaryDescription} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.SummaryDescription}
 */proto.tensorflow.SummaryDescription.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setTypeHint(o);break;default:t.skipField();break}}return e};proto.tensorflow.SummaryDescription.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.SummaryDescription.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.SummaryDescription} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.SummaryDescription.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getTypeHint();r.length>0&&t.writeString(1,r)};proto.tensorflow.SummaryDescription.prototype.getTypeHint=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SummaryDescription} returns this
 */proto.tensorflow.SummaryDescription.prototype.setTypeHint=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.HistogramProto.repeatedFields_=[6,7];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.HistogramProto.prototype.toObject=function(e){return proto.tensorflow.HistogramProto.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.HistogramProto} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.HistogramProto.toObject=function(e,t){var r,o={min:M.Message.getFloatingPointFieldWithDefault(t,1,0),max:M.Message.getFloatingPointFieldWithDefault(t,2,0),num:M.Message.getFloatingPointFieldWithDefault(t,3,0),sum:M.Message.getFloatingPointFieldWithDefault(t,4,0),sumSquares:M.Message.getFloatingPointFieldWithDefault(t,5,0),bucketLimitList:(r=M.Message.getRepeatedFloatingPointField(t,6))==null?void 0:r,bucketList:(r=M.Message.getRepeatedFloatingPointField(t,7))==null?void 0:r};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.HistogramProto}
 */proto.tensorflow.HistogramProto.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.HistogramProto;return proto.tensorflow.HistogramProto.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.HistogramProto} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.HistogramProto}
 */proto.tensorflow.HistogramProto.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readDouble();e.setMin(o);break;case 2:o=/** @type {number} */t.readDouble();e.setMax(o);break;case 3:o=/** @type {number} */t.readDouble();e.setNum(o);break;case 4:o=/** @type {number} */t.readDouble();e.setSum(o);break;case 5:o=/** @type {number} */t.readDouble();e.setSumSquares(o);break;case 6:var n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedDouble():[t.readDouble()];for(var a=0;a<n.length;a++)e.addBucketLimit(n[a]);break;case 7:n=/** @type {!Array<number>} */t.isDelimited()?t.readPackedDouble():[t.readDouble()];for(a=0;a<n.length;a++)e.addBucket(n[a]);break;default:t.skipField();break}}return e};proto.tensorflow.HistogramProto.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.HistogramProto.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.HistogramProto} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.HistogramProto.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getMin();r!==0&&t.writeDouble(1,r);r=e.getMax();r!==0&&t.writeDouble(2,r);r=e.getNum();r!==0&&t.writeDouble(3,r);r=e.getSum();r!==0&&t.writeDouble(4,r);r=e.getSumSquares();r!==0&&t.writeDouble(5,r);r=e.getBucketLimitList();r.length>0&&t.writePackedDouble(6,r);r=e.getBucketList();r.length>0&&t.writePackedDouble(7,r)};proto.tensorflow.HistogramProto.prototype.getMin=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.setMin=function(e){return M.Message.setProto3FloatField(this||D,1,e)};proto.tensorflow.HistogramProto.prototype.getMax=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,2,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.setMax=function(e){return M.Message.setProto3FloatField(this||D,2,e)};proto.tensorflow.HistogramProto.prototype.getNum=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,3,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.setNum=function(e){return M.Message.setProto3FloatField(this||D,3,e)};proto.tensorflow.HistogramProto.prototype.getSum=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,4,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.setSum=function(e){return M.Message.setProto3FloatField(this||D,4,e)};proto.tensorflow.HistogramProto.prototype.getSumSquares=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,5,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.setSumSquares=function(e){return M.Message.setProto3FloatField(this||D,5,e)};proto.tensorflow.HistogramProto.prototype.getBucketLimitList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedFloatingPointField(this||D,6)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.setBucketLimitList=function(e){return M.Message.setField(this||D,6,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.addBucketLimit=function(e,t){return M.Message.addToRepeatedField(this||D,6,e,t)};proto.tensorflow.HistogramProto.prototype.clearBucketLimitList=function(){return this.setBucketLimitList([])};proto.tensorflow.HistogramProto.prototype.getBucketList=function(){/** @type {!Array<number>} */
return M.Message.getRepeatedFloatingPointField(this||D,7)};
/**
 * @param {!Array<number>} value
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.setBucketList=function(e){return M.Message.setField(this||D,7,e||[])};
/**
 * @param {number} value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.HistogramProto} returns this
 */proto.tensorflow.HistogramProto.prototype.addBucket=function(e,t){return M.Message.addToRepeatedField(this||D,7,e,t)};proto.tensorflow.HistogramProto.prototype.clearBucketList=function(){return this.setBucketList([])};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.SummaryMetadata.prototype.toObject=function(e){return proto.tensorflow.SummaryMetadata.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.SummaryMetadata} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.SummaryMetadata.toObject=function(e,t){var r,o={pluginData:(r=t.getPluginData())&&proto.tensorflow.SummaryMetadata.PluginData.toObject(e,r),displayName:M.Message.getFieldWithDefault(t,2,""),summaryDescription:M.Message.getFieldWithDefault(t,3,""),dataClass:M.Message.getFieldWithDefault(t,4,0)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.SummaryMetadata}
 */proto.tensorflow.SummaryMetadata.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.SummaryMetadata;return proto.tensorflow.SummaryMetadata.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.SummaryMetadata} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.SummaryMetadata}
 */proto.tensorflow.SummaryMetadata.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.SummaryMetadata.PluginData;t.readMessage(o,proto.tensorflow.SummaryMetadata.PluginData.deserializeBinaryFromReader);e.setPluginData(o);break;case 2:o=/** @type {string} */t.readString();e.setDisplayName(o);break;case 3:o=/** @type {string} */t.readString();e.setSummaryDescription(o);break;case 4:o=/** @type {!proto.tensorflow.DataClass} */t.readEnum();e.setDataClass(o);break;default:t.skipField();break}}return e};proto.tensorflow.SummaryMetadata.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.SummaryMetadata.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.SummaryMetadata} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.SummaryMetadata.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getPluginData();r!=null&&t.writeMessage(1,r,proto.tensorflow.SummaryMetadata.PluginData.serializeBinaryToWriter);r=e.getDisplayName();r.length>0&&t.writeString(2,r);r=e.getSummaryDescription();r.length>0&&t.writeString(3,r);r=e.getDataClass();r!==0&&t.writeEnum(4,r)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.SummaryMetadata.PluginData.prototype.toObject=function(e){return proto.tensorflow.SummaryMetadata.PluginData.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.SummaryMetadata.PluginData} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.SummaryMetadata.PluginData.toObject=function(e,t){var r={pluginName:M.Message.getFieldWithDefault(t,1,""),content:t.getContent_asB64()};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.SummaryMetadata.PluginData}
 */proto.tensorflow.SummaryMetadata.PluginData.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.SummaryMetadata.PluginData;return proto.tensorflow.SummaryMetadata.PluginData.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.SummaryMetadata.PluginData} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.SummaryMetadata.PluginData}
 */proto.tensorflow.SummaryMetadata.PluginData.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {string} */t.readString();e.setPluginName(o);break;case 2:o=/** @type {!Uint8Array} */t.readBytes();e.setContent(o);break;default:t.skipField();break}}return e};proto.tensorflow.SummaryMetadata.PluginData.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.SummaryMetadata.PluginData.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.SummaryMetadata.PluginData} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.SummaryMetadata.PluginData.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getPluginName();r.length>0&&t.writeString(1,r);r=e.getContent_asU8();r.length>0&&t.writeBytes(2,r)};proto.tensorflow.SummaryMetadata.PluginData.prototype.getPluginName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SummaryMetadata.PluginData} returns this
 */proto.tensorflow.SummaryMetadata.PluginData.prototype.setPluginName=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.SummaryMetadata.PluginData.prototype.getContent=function(){/** @type {!(string|Uint8Array)} */
return M.Message.getFieldWithDefault(this||D,2,"")};proto.tensorflow.SummaryMetadata.PluginData.prototype.getContent_asB64=function(){/** @type {string} */
return M.Message.bytesAsB64(this.getContent())};proto.tensorflow.SummaryMetadata.PluginData.prototype.getContent_asU8=function(){/** @type {!Uint8Array} */
return M.Message.bytesAsU8(this.getContent())};
/**
 * @param {!(string|Uint8Array)} value
 * @return {!proto.tensorflow.SummaryMetadata.PluginData} returns this
 */proto.tensorflow.SummaryMetadata.PluginData.prototype.setContent=function(e){return M.Message.setProto3BytesField(this||D,2,e)};proto.tensorflow.SummaryMetadata.prototype.getPluginData=function(){/** @type{?proto.tensorflow.SummaryMetadata.PluginData} */
return M.Message.getWrapperField(this||D,proto.tensorflow.SummaryMetadata.PluginData,1)};
/**
 * @param {?proto.tensorflow.SummaryMetadata.PluginData|undefined} value
 * @return {!proto.tensorflow.SummaryMetadata} returns this
*/proto.tensorflow.SummaryMetadata.prototype.setPluginData=function(e){return M.Message.setWrapperField(this||D,1,e)};proto.tensorflow.SummaryMetadata.prototype.clearPluginData=function(){return this.setPluginData(void 0)};proto.tensorflow.SummaryMetadata.prototype.hasPluginData=function(){return M.Message.getField(this||D,1)!=null};proto.tensorflow.SummaryMetadata.prototype.getDisplayName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,2,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SummaryMetadata} returns this
 */proto.tensorflow.SummaryMetadata.prototype.setDisplayName=function(e){return M.Message.setProto3StringField(this||D,2,e)};proto.tensorflow.SummaryMetadata.prototype.getSummaryDescription=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,3,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.SummaryMetadata} returns this
 */proto.tensorflow.SummaryMetadata.prototype.setSummaryDescription=function(e){return M.Message.setProto3StringField(this||D,3,e)};proto.tensorflow.SummaryMetadata.prototype.getDataClass=function(){/** @type {!proto.tensorflow.DataClass} */
return M.Message.getFieldWithDefault(this||D,4,0)};
/**
 * @param {!proto.tensorflow.DataClass} value
 * @return {!proto.tensorflow.SummaryMetadata} returns this
 */proto.tensorflow.SummaryMetadata.prototype.setDataClass=function(e){return M.Message.setProto3EnumField(this||D,4,e)};proto.tensorflow.Summary.repeatedFields_=[1];if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.Summary.prototype.toObject=function(e){return proto.tensorflow.Summary.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.Summary} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.Summary.toObject=function(e,t){var r={valueList:M.Message.toObjectList(t.getValueList(),proto.tensorflow.Summary.Value.toObject,e)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.Summary}
 */proto.tensorflow.Summary.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.Summary;return proto.tensorflow.Summary.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.Summary} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.Summary}
 */proto.tensorflow.Summary.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=new proto.tensorflow.Summary.Value;t.readMessage(o,proto.tensorflow.Summary.Value.deserializeBinaryFromReader);e.addValue(o);break;default:t.skipField();break}}return e};proto.tensorflow.Summary.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.Summary.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.Summary} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.Summary.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getValueList();r.length>0&&t.writeRepeatedMessage(1,r,proto.tensorflow.Summary.Value.serializeBinaryToWriter)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.Summary.Image.prototype.toObject=function(e){return proto.tensorflow.Summary.Image.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.Summary.Image} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.Summary.Image.toObject=function(e,t){var r={height:M.Message.getFieldWithDefault(t,1,0),width:M.Message.getFieldWithDefault(t,2,0),colorspace:M.Message.getFieldWithDefault(t,3,0),encodedImageString:t.getEncodedImageString_asB64()};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.Summary.Image}
 */proto.tensorflow.Summary.Image.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.Summary.Image;return proto.tensorflow.Summary.Image.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.Summary.Image} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.Summary.Image}
 */proto.tensorflow.Summary.Image.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readInt32();e.setHeight(o);break;case 2:o=/** @type {number} */t.readInt32();e.setWidth(o);break;case 3:o=/** @type {number} */t.readInt32();e.setColorspace(o);break;case 4:o=/** @type {!Uint8Array} */t.readBytes();e.setEncodedImageString(o);break;default:t.skipField();break}}return e};proto.tensorflow.Summary.Image.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.Summary.Image.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.Summary.Image} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.Summary.Image.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getHeight();r!==0&&t.writeInt32(1,r);r=e.getWidth();r!==0&&t.writeInt32(2,r);r=e.getColorspace();r!==0&&t.writeInt32(3,r);r=e.getEncodedImageString_asU8();r.length>0&&t.writeBytes(4,r)};proto.tensorflow.Summary.Image.prototype.getHeight=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Summary.Image} returns this
 */proto.tensorflow.Summary.Image.prototype.setHeight=function(e){return M.Message.setProto3IntField(this||D,1,e)};proto.tensorflow.Summary.Image.prototype.getWidth=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,2,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Summary.Image} returns this
 */proto.tensorflow.Summary.Image.prototype.setWidth=function(e){return M.Message.setProto3IntField(this||D,2,e)};proto.tensorflow.Summary.Image.prototype.getColorspace=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,3,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Summary.Image} returns this
 */proto.tensorflow.Summary.Image.prototype.setColorspace=function(e){return M.Message.setProto3IntField(this||D,3,e)};proto.tensorflow.Summary.Image.prototype.getEncodedImageString=function(){/** @type {!(string|Uint8Array)} */
return M.Message.getFieldWithDefault(this||D,4,"")};proto.tensorflow.Summary.Image.prototype.getEncodedImageString_asB64=function(){/** @type {string} */
return M.Message.bytesAsB64(this.getEncodedImageString())};proto.tensorflow.Summary.Image.prototype.getEncodedImageString_asU8=function(){/** @type {!Uint8Array} */
return M.Message.bytesAsU8(this.getEncodedImageString())};
/**
 * @param {!(string|Uint8Array)} value
 * @return {!proto.tensorflow.Summary.Image} returns this
 */proto.tensorflow.Summary.Image.prototype.setEncodedImageString=function(e){return M.Message.setProto3BytesField(this||D,4,e)};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.Summary.Audio.prototype.toObject=function(e){return proto.tensorflow.Summary.Audio.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.Summary.Audio} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.Summary.Audio.toObject=function(e,t){var r={sampleRate:M.Message.getFloatingPointFieldWithDefault(t,1,0),numChannels:M.Message.getFieldWithDefault(t,2,0),lengthFrames:M.Message.getFieldWithDefault(t,3,0),encodedAudioString:t.getEncodedAudioString_asB64(),contentType:M.Message.getFieldWithDefault(t,5,"")};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.Summary.Audio}
 */proto.tensorflow.Summary.Audio.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.Summary.Audio;return proto.tensorflow.Summary.Audio.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.Summary.Audio} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.Summary.Audio}
 */proto.tensorflow.Summary.Audio.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readFloat();e.setSampleRate(o);break;case 2:o=/** @type {number} */t.readInt64();e.setNumChannels(o);break;case 3:o=/** @type {number} */t.readInt64();e.setLengthFrames(o);break;case 4:o=/** @type {!Uint8Array} */t.readBytes();e.setEncodedAudioString(o);break;case 5:o=/** @type {string} */t.readString();e.setContentType(o);break;default:t.skipField();break}}return e};proto.tensorflow.Summary.Audio.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.Summary.Audio.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.Summary.Audio} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.Summary.Audio.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getSampleRate();r!==0&&t.writeFloat(1,r);r=e.getNumChannels();r!==0&&t.writeInt64(2,r);r=e.getLengthFrames();r!==0&&t.writeInt64(3,r);r=e.getEncodedAudioString_asU8();r.length>0&&t.writeBytes(4,r);r=e.getContentType();r.length>0&&t.writeString(5,r)};proto.tensorflow.Summary.Audio.prototype.getSampleRate=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Summary.Audio} returns this
 */proto.tensorflow.Summary.Audio.prototype.setSampleRate=function(e){return M.Message.setProto3FloatField(this||D,1,e)};proto.tensorflow.Summary.Audio.prototype.getNumChannels=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,2,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Summary.Audio} returns this
 */proto.tensorflow.Summary.Audio.prototype.setNumChannels=function(e){return M.Message.setProto3IntField(this||D,2,e)};proto.tensorflow.Summary.Audio.prototype.getLengthFrames=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,3,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Summary.Audio} returns this
 */proto.tensorflow.Summary.Audio.prototype.setLengthFrames=function(e){return M.Message.setProto3IntField(this||D,3,e)};proto.tensorflow.Summary.Audio.prototype.getEncodedAudioString=function(){/** @type {!(string|Uint8Array)} */
return M.Message.getFieldWithDefault(this||D,4,"")};proto.tensorflow.Summary.Audio.prototype.getEncodedAudioString_asB64=function(){/** @type {string} */
return M.Message.bytesAsB64(this.getEncodedAudioString())};proto.tensorflow.Summary.Audio.prototype.getEncodedAudioString_asU8=function(){/** @type {!Uint8Array} */
return M.Message.bytesAsU8(this.getEncodedAudioString())};
/**
 * @param {!(string|Uint8Array)} value
 * @return {!proto.tensorflow.Summary.Audio} returns this
 */proto.tensorflow.Summary.Audio.prototype.setEncodedAudioString=function(e){return M.Message.setProto3BytesField(this||D,4,e)};proto.tensorflow.Summary.Audio.prototype.getContentType=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,5,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.Summary.Audio} returns this
 */proto.tensorflow.Summary.Audio.prototype.setContentType=function(e){return M.Message.setProto3StringField(this||D,5,e)};proto.tensorflow.Summary.Value.oneofGroups_=[[2,3,4,5,6,8]];proto.tensorflow.Summary.Value.ValueCase={VALUE_NOT_SET:0,SIMPLE_VALUE:2,OBSOLETE_OLD_STYLE_HISTOGRAM:3,IMAGE:4,HISTO:5,AUDIO:6,TENSOR:8};proto.tensorflow.Summary.Value.prototype.getValueCase=function(){/** @type {proto.tensorflow.Summary.Value.ValueCase} */
return M.Message.computeOneofCase(this||D,proto.tensorflow.Summary.Value.oneofGroups_[0])};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.Summary.Value.prototype.toObject=function(e){return proto.tensorflow.Summary.Value.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.Summary.Value} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.Summary.Value.toObject=function(e,t){var r,o={nodeName:M.Message.getFieldWithDefault(t,7,""),tag:M.Message.getFieldWithDefault(t,1,""),metadata:(r=t.getMetadata())&&proto.tensorflow.SummaryMetadata.toObject(e,r),simpleValue:M.Message.getFloatingPointFieldWithDefault(t,2,0),obsoleteOldStyleHistogram:t.getObsoleteOldStyleHistogram_asB64(),image:(r=t.getImage())&&proto.tensorflow.Summary.Image.toObject(e,r),histo:(r=t.getHisto())&&proto.tensorflow.HistogramProto.toObject(e,r),audio:(r=t.getAudio())&&proto.tensorflow.Summary.Audio.toObject(e,r),tensor:(r=t.getTensor())&&proto.tensorflow.Tensor.toObject(e,r)};e&&(o.$jspbMessageInstance=t);return o}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.Summary.Value}
 */proto.tensorflow.Summary.Value.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.Summary.Value;return proto.tensorflow.Summary.Value.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.Summary.Value} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.Summary.Value}
 */proto.tensorflow.Summary.Value.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 7:var o=/** @type {string} */t.readString();e.setNodeName(o);break;case 1:o=/** @type {string} */t.readString();e.setTag(o);break;case 9:o=new proto.tensorflow.SummaryMetadata;t.readMessage(o,proto.tensorflow.SummaryMetadata.deserializeBinaryFromReader);e.setMetadata(o);break;case 2:o=/** @type {number} */t.readFloat();e.setSimpleValue(o);break;case 3:o=/** @type {!Uint8Array} */t.readBytes();e.setObsoleteOldStyleHistogram(o);break;case 4:o=new proto.tensorflow.Summary.Image;t.readMessage(o,proto.tensorflow.Summary.Image.deserializeBinaryFromReader);e.setImage(o);break;case 5:o=new proto.tensorflow.HistogramProto;t.readMessage(o,proto.tensorflow.HistogramProto.deserializeBinaryFromReader);e.setHisto(o);break;case 6:o=new proto.tensorflow.Summary.Audio;t.readMessage(o,proto.tensorflow.Summary.Audio.deserializeBinaryFromReader);e.setAudio(o);break;case 8:o=new proto.tensorflow.Tensor;t.readMessage(o,proto.tensorflow.Tensor.deserializeBinaryFromReader);e.setTensor(o);break;default:t.skipField();break}}return e};proto.tensorflow.Summary.Value.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.Summary.Value.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.Summary.Value} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.Summary.Value.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getNodeName();r.length>0&&t.writeString(7,r);r=e.getTag();r.length>0&&t.writeString(1,r);r=e.getMetadata();r!=null&&t.writeMessage(9,r,proto.tensorflow.SummaryMetadata.serializeBinaryToWriter);r=/** @type {number} */M.Message.getField(e,2);r!=null&&t.writeFloat(2,r);r=/** @type {!(string|Uint8Array)} */M.Message.getField(e,3);r!=null&&t.writeBytes(3,r);r=e.getImage();r!=null&&t.writeMessage(4,r,proto.tensorflow.Summary.Image.serializeBinaryToWriter);r=e.getHisto();r!=null&&t.writeMessage(5,r,proto.tensorflow.HistogramProto.serializeBinaryToWriter);r=e.getAudio();r!=null&&t.writeMessage(6,r,proto.tensorflow.Summary.Audio.serializeBinaryToWriter);r=e.getTensor();r!=null&&t.writeMessage(8,r,proto.tensorflow.Tensor.serializeBinaryToWriter)};proto.tensorflow.Summary.Value.prototype.getNodeName=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,7,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.Summary.Value} returns this
 */proto.tensorflow.Summary.Value.prototype.setNodeName=function(e){return M.Message.setProto3StringField(this||D,7,e)};proto.tensorflow.Summary.Value.prototype.getTag=function(){/** @type {string} */
return M.Message.getFieldWithDefault(this||D,1,"")};
/**
 * @param {string} value
 * @return {!proto.tensorflow.Summary.Value} returns this
 */proto.tensorflow.Summary.Value.prototype.setTag=function(e){return M.Message.setProto3StringField(this||D,1,e)};proto.tensorflow.Summary.Value.prototype.getMetadata=function(){/** @type{?proto.tensorflow.SummaryMetadata} */
return M.Message.getWrapperField(this||D,proto.tensorflow.SummaryMetadata,9)};
/**
 * @param {?proto.tensorflow.SummaryMetadata|undefined} value
 * @return {!proto.tensorflow.Summary.Value} returns this
*/proto.tensorflow.Summary.Value.prototype.setMetadata=function(e){return M.Message.setWrapperField(this||D,9,e)};proto.tensorflow.Summary.Value.prototype.clearMetadata=function(){return this.setMetadata(void 0)};proto.tensorflow.Summary.Value.prototype.hasMetadata=function(){return M.Message.getField(this||D,9)!=null};proto.tensorflow.Summary.Value.prototype.getSimpleValue=function(){/** @type {number} */
return M.Message.getFloatingPointFieldWithDefault(this||D,2,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.Summary.Value} returns this
 */proto.tensorflow.Summary.Value.prototype.setSimpleValue=function(e){return M.Message.setOneofField(this||D,2,proto.tensorflow.Summary.Value.oneofGroups_[0],e)};proto.tensorflow.Summary.Value.prototype.clearSimpleValue=function(){return M.Message.setOneofField(this||D,2,proto.tensorflow.Summary.Value.oneofGroups_[0],void 0)};proto.tensorflow.Summary.Value.prototype.hasSimpleValue=function(){return M.Message.getField(this||D,2)!=null};proto.tensorflow.Summary.Value.prototype.getObsoleteOldStyleHistogram=function(){/** @type {!(string|Uint8Array)} */
return M.Message.getFieldWithDefault(this||D,3,"")};proto.tensorflow.Summary.Value.prototype.getObsoleteOldStyleHistogram_asB64=function(){/** @type {string} */
return M.Message.bytesAsB64(this.getObsoleteOldStyleHistogram())};proto.tensorflow.Summary.Value.prototype.getObsoleteOldStyleHistogram_asU8=function(){/** @type {!Uint8Array} */
return M.Message.bytesAsU8(this.getObsoleteOldStyleHistogram())};
/**
 * @param {!(string|Uint8Array)} value
 * @return {!proto.tensorflow.Summary.Value} returns this
 */proto.tensorflow.Summary.Value.prototype.setObsoleteOldStyleHistogram=function(e){return M.Message.setOneofField(this||D,3,proto.tensorflow.Summary.Value.oneofGroups_[0],e)};proto.tensorflow.Summary.Value.prototype.clearObsoleteOldStyleHistogram=function(){return M.Message.setOneofField(this||D,3,proto.tensorflow.Summary.Value.oneofGroups_[0],void 0)};proto.tensorflow.Summary.Value.prototype.hasObsoleteOldStyleHistogram=function(){return M.Message.getField(this||D,3)!=null};proto.tensorflow.Summary.Value.prototype.getImage=function(){/** @type{?proto.tensorflow.Summary.Image} */
return M.Message.getWrapperField(this||D,proto.tensorflow.Summary.Image,4)};
/**
 * @param {?proto.tensorflow.Summary.Image|undefined} value
 * @return {!proto.tensorflow.Summary.Value} returns this
*/proto.tensorflow.Summary.Value.prototype.setImage=function(e){return M.Message.setOneofWrapperField(this||D,4,proto.tensorflow.Summary.Value.oneofGroups_[0],e)};proto.tensorflow.Summary.Value.prototype.clearImage=function(){return this.setImage(void 0)};proto.tensorflow.Summary.Value.prototype.hasImage=function(){return M.Message.getField(this||D,4)!=null};proto.tensorflow.Summary.Value.prototype.getHisto=function(){/** @type{?proto.tensorflow.HistogramProto} */
return M.Message.getWrapperField(this||D,proto.tensorflow.HistogramProto,5)};
/**
 * @param {?proto.tensorflow.HistogramProto|undefined} value
 * @return {!proto.tensorflow.Summary.Value} returns this
*/proto.tensorflow.Summary.Value.prototype.setHisto=function(e){return M.Message.setOneofWrapperField(this||D,5,proto.tensorflow.Summary.Value.oneofGroups_[0],e)};proto.tensorflow.Summary.Value.prototype.clearHisto=function(){return this.setHisto(void 0)};proto.tensorflow.Summary.Value.prototype.hasHisto=function(){return M.Message.getField(this||D,5)!=null};proto.tensorflow.Summary.Value.prototype.getAudio=function(){/** @type{?proto.tensorflow.Summary.Audio} */
return M.Message.getWrapperField(this||D,proto.tensorflow.Summary.Audio,6)};
/**
 * @param {?proto.tensorflow.Summary.Audio|undefined} value
 * @return {!proto.tensorflow.Summary.Value} returns this
*/proto.tensorflow.Summary.Value.prototype.setAudio=function(e){return M.Message.setOneofWrapperField(this||D,6,proto.tensorflow.Summary.Value.oneofGroups_[0],e)};proto.tensorflow.Summary.Value.prototype.clearAudio=function(){return this.setAudio(void 0)};proto.tensorflow.Summary.Value.prototype.hasAudio=function(){return M.Message.getField(this||D,6)!=null};proto.tensorflow.Summary.Value.prototype.getTensor=function(){/** @type{?proto.tensorflow.Tensor} */
return M.Message.getWrapperField(this||D,proto.tensorflow.Tensor,8)};
/**
 * @param {?proto.tensorflow.Tensor|undefined} value
 * @return {!proto.tensorflow.Summary.Value} returns this
*/proto.tensorflow.Summary.Value.prototype.setTensor=function(e){return M.Message.setOneofWrapperField(this||D,8,proto.tensorflow.Summary.Value.oneofGroups_[0],e)};proto.tensorflow.Summary.Value.prototype.clearTensor=function(){return this.setTensor(void 0)};proto.tensorflow.Summary.Value.prototype.hasTensor=function(){return M.Message.getField(this||D,8)!=null};proto.tensorflow.Summary.prototype.getValueList=function(){/** @type{!Array<!proto.tensorflow.Summary.Value>} */
return M.Message.getRepeatedWrapperField(this||D,proto.tensorflow.Summary.Value,1)};
/**
 * @param {!Array<!proto.tensorflow.Summary.Value>} value
 * @return {!proto.tensorflow.Summary} returns this
*/proto.tensorflow.Summary.prototype.setValueList=function(e){return M.Message.setRepeatedWrapperField(this||D,1,e)};
/**
 * @param {!proto.tensorflow.Summary.Value=} opt_value
 * @param {number=} opt_index
 * @return {!proto.tensorflow.Summary.Value}
 */proto.tensorflow.Summary.prototype.addValue=function(e,t){return M.Message.addToRepeatedWrapperField(this||D,1,e,proto.tensorflow.Summary.Value,t)};proto.tensorflow.Summary.prototype.clearValueList=function(){return this.setValueList([])};if(M.Message.GENERATE_TO_OBJECT){
/**
   * Creates an object representation of this proto.
   * Field names that are reserved in JavaScript and will be renamed to pb_name.
   * Optional fields that are not set will be set to undefined.
   * To access a reserved field use, foo.pb_<name>, eg, foo.pb_default.
   * For the list of reserved names please see:
   *     net/proto2/compiler/js/internal/generator.cc#kKeyword.
   * @param {boolean=} opt_includeInstance Deprecated. whether to include the
   *     JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @return {!Object}
   */
proto.tensorflow.HistogramPluginData.prototype.toObject=function(e){return proto.tensorflow.HistogramPluginData.toObject(e,this||D)};
/**
   * Static version of the {@see toObject} method.
   * @param {boolean|undefined} includeInstance Deprecated. Whether to include
   *     the JSPB instance for transitional soy proto support:
   *     http://goto/soy-param-migration
   * @param {!proto.tensorflow.HistogramPluginData} msg The msg instance to transform.
   * @return {!Object}
   * @suppress {unusedLocalVariables} f is only used for nested messages
   */proto.tensorflow.HistogramPluginData.toObject=function(e,t){var r={version:M.Message.getFieldWithDefault(t,1,0)};e&&(r.$jspbMessageInstance=t);return r}}
/**
 * Deserializes binary data (in protobuf wire format).
 * @param {jspb.ByteSource} bytes The bytes to deserialize.
 * @return {!proto.tensorflow.HistogramPluginData}
 */proto.tensorflow.HistogramPluginData.deserializeBinary=function(e){var t=new M.BinaryReader(e);var r=new proto.tensorflow.HistogramPluginData;return proto.tensorflow.HistogramPluginData.deserializeBinaryFromReader(r,t)};
/**
 * Deserializes binary data (in protobuf wire format) from the
 * given reader into the given message object.
 * @param {!proto.tensorflow.HistogramPluginData} msg The message object to deserialize into.
 * @param {!jspb.BinaryReader} reader The BinaryReader to use.
 * @return {!proto.tensorflow.HistogramPluginData}
 */proto.tensorflow.HistogramPluginData.deserializeBinaryFromReader=function(e,t){while(t.nextField()){if(t.isEndGroup())break;var r=t.getFieldNumber();switch(r){case 1:var o=/** @type {number} */t.readInt32();e.setVersion(o);break;default:t.skipField();break}}return e};proto.tensorflow.HistogramPluginData.prototype.serializeBinary=function(){var e=new M.BinaryWriter;proto.tensorflow.HistogramPluginData.serializeBinaryToWriter(this||D,e);return e.getResultBuffer()};
/**
 * Serializes the given message to binary data (in protobuf wire
 * format), writing to the given BinaryWriter.
 * @param {!proto.tensorflow.HistogramPluginData} message
 * @param {!jspb.BinaryWriter} writer
 * @suppress {unusedLocalVariables} f is only used for nested messages
 */proto.tensorflow.HistogramPluginData.serializeBinaryToWriter=function(e,t){var r=void 0;r=e.getVersion();r!==0&&t.writeInt32(1,r)};proto.tensorflow.HistogramPluginData.prototype.getVersion=function(){/** @type {number} */
return M.Message.getFieldWithDefault(this||D,1,0)};
/**
 * @param {number} value
 * @return {!proto.tensorflow.HistogramPluginData} returns this
 */proto.tensorflow.HistogramPluginData.prototype.setVersion=function(e){return M.Message.setProto3IntField(this||D,1,e)};proto.tensorflow.DataType={DT_INVALID:0,DT_FLOAT:1,DT_DOUBLE:2,DT_INT32:3,DT_UINT8:4,DT_INT16:5,DT_INT8:6,DT_STRING:7,DT_COMPLEX64:8,DT_INT64:9,DT_BOOL:10,DT_QINT8:11,DT_QUINT8:12,DT_QINT32:13,DT_BFLOAT16:14,DT_FLOAT_REF:101,DT_DOUBLE_REF:102,DT_INT32_REF:103,DT_UINT8_REF:104,DT_INT16_REF:105,DT_INT8_REF:106,DT_STRING_REF:107,DT_COMPLEX64_REF:108,DT_INT64_REF:109,DT_BOOL_REF:110,DT_QINT8_REF:111,DT_QUINT8_REF:112,DT_QINT32_REF:113,DT_BFLOAT16_REF:114};proto.tensorflow.DataClass={DATA_CLASS_UNKNOWN:0,DATA_CLASS_SCALAR:1,DATA_CLASS_TENSOR:2,DATA_CLASS_BLOB_SEQUENCE:3};S.object.extend(F,proto.tensorflow);var O=e;try{"default"in e&&(O=e.default)}catch(e){}var _=t;try{"default"in t&&(_=t.default)}catch(e){}var N={};var A=n;
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
 */var B=N&&N.__extends||function(){var extendStatics=function(e,t){extendStatics=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(e,t){e.__proto__=t}||function(e,t){for(var r in t)Object.prototype.hasOwnProperty.call(t,r)&&(e[r]=t[r])};return extendStatics(e,t)};return function(e,t){if(typeof t!=="function"&&t!==null)throw new TypeError("Class extends value "+String(t)+" is not a constructor or null");extendStatics(e,t);function __(){this.constructor=e}e.prototype=t===null?Object.create(t):(__.prototype=t.prototype,new __)}}();var C=N&&N.__awaiter||function(e,t,r,o){function adopt(e){return e instanceof r?e:new r((function(t){t(e)}))}return new(r||(r=Promise))((function(r,n){function fulfilled(e){try{step(o.next(e))}catch(e){n(e)}}function rejected(e){try{step(o.throw(e))}catch(e){n(e)}}function step(e){e.done?r(e.value):adopt(e.value).then(fulfilled,rejected)}step((o=o.apply(e,t||[])).next())}))};var I=N&&N.__generator||function(e,t){var r,o,n,a,i={label:0,sent:function(){if(n[0]&1)throw n[1];return n[1]},trys:[],ops:[]};return a={next:verb(0),throw:verb(1),return:verb(2)},typeof Symbol==="function"&&(a[Symbol.iterator]=function(){return this}),a;function verb(e){return function(t){return step([e,t])}}function step(s){if(r)throw new TypeError("Generator is already executing.");while(a&&(a=0,s[0]&&(i=0)),i)try{if(r=1,o&&(n=s[0]&2?o.return:s[0]?o.throw||((n=o.return)&&n.call(o),0):o.next)&&!(n=n.call(o,s[1])).done)return n;(o=0,n)&&(s=[s[0]&2,n.value]);switch(s[0]){case 0:case 1:n=s;break;case 4:i.label++;return{value:s[1],done:false};case 5:i.label++;o=s[1];s=[0];continue;case 7:s=i.ops.pop();i.trys.pop();continue;default:if(!(n=i.trys,n=n.length>0&&n[n.length-1])&&(s[0]===6||s[0]===2)){i=0;continue}if(s[0]===3&&(!n||s[1]>n[0]&&s[1]<n[3])){i.label=s[1];break}if(s[0]===6&&i.label<n[1]){i.label=n[1];n=s;break}if(n&&i.label<n[2]){i.label=n[2];i.ops.push(s);break}n[2]&&i.ops.pop();i.trys.pop();continue}s=t.call(e,i)}catch(e){s=[6,e];o=0}finally{r=n=0}if(s[0]&5)throw s[1];return{value:s[0]?s[1]:void 0,done:true}}};Object.defineProperty(N,"__esModule",{value:true});N.ensureTensorflowBackend=N.createOpAttr=N.createTensorsTypeOpAttr=N.getTFDType=N.nodeBackend=N.NodeJSKernelBackend=void 0;var L=O;var R=O;var P=_;var V=y;var x=F;var W=function(e){B(NodeJSKernelBackend,e);function NodeJSKernelBackend(t,r){var o=e.call(this)||this;o.binding=t;o.isGPUPackage=r==="@tensorflow/tfjs-node-gpu";o.isUsingGpuDevice=o.binding.isUsingGpuDevice();o.tensorMap=new L.DataStorage(o,L.engine());return o}NodeJSKernelBackend.prototype.getDTypeInteger=function(e){switch(e){case"float32":return this.binding.TF_FLOAT;case"int32":return this.binding.TF_INT32;case"bool":return this.binding.TF_BOOL;case"complex64":return this.binding.TF_COMPLEX64;case"string":return this.binding.TF_STRING;default:throw new Error("Unsupported DType: ".concat(e))}};NodeJSKernelBackend.prototype.typeAttributeFromTensor=function(e){return this.getDTypeInteger(e.dtype)};NodeJSKernelBackend.prototype.createOutputTensor=function(e){var t={};this.tensorMap.set(t,{shape:e.shape,dtype:e.dtype,id:e.id,values:null,refCount:1});var r;switch(e.dtype){case this.binding.TF_FLOAT:r="float32";break;case this.binding.TF_INT32:r="int32";break;case this.binding.TF_INT64:console.warn("INT64 output tensor will be stored as BigInt64Array.");r="int32";break;case this.binding.TF_BOOL:r="bool";break;case this.binding.TF_COMPLEX64:r="complex64";break;case this.binding.TF_STRING:r="string";break;case this.binding.TF_RESOURCE:r="string";break;case this.binding.TF_UINT8:r="int32";break;default:throw new Error("Unknown dtype enum ".concat(e.dtype))}var o={dataId:t,shape:e.shape,dtype:r};return L.engine().makeTensorFromTensorInfo(o)};NodeJSKernelBackend.prototype.getInputTensorIds=function(e){var t=[];for(var r=0;r<e.length;r++)if(e[r]instanceof V.Int64Scalar){var o=e[r].valueArray;var n=this.binding.createTensor([],this.binding.TF_INT64,o);t.push(n)}else{var a=this.tensorMap.get(e[r].dataId);if(a.values!=null){a.id=this.binding.createTensor(a.shape,a.dtype,a.values);a.values=null}t.push(a.id)}return t};NodeJSKernelBackend.prototype.createReductionOpAttrs=function(e,t){t===void 0&&(t=false);return[{name:"keep_dims",type:this.binding.TF_ATTR_BOOL,value:t},createTensorsTypeOpAttr("T",e.dtype),createTensorsTypeOpAttr("Tidx","int32")]};NodeJSKernelBackend.prototype.floatPrecision=function(){return 32};NodeJSKernelBackend.prototype.epsilon=function(){return e.prototype.epsilon.call(this)};
/**
   * Executes an op that has a single input and output.
   *
   * Helper function to wrap executeSingleOutput in a particular case.
   * @param name The name of the Op to execute.
   * @param input The input Tensor for the Op.
   */NodeJSKernelBackend.prototype.executeSingleInput=function(e,t){var r=[createTensorsTypeOpAttr("T",t.dtype)];return this.executeSingleOutput(e,r,[t])};
/**
   * Executes a TensorFlow Eager Op that provides one output Tensor.
   * @param name The name of the Op to execute.
   * @param opAttrs The list of Op attributes required to execute.
   * @param inputs The list of input Tensors for the Op.
   * @return A resulting Tensor from Op execution.
   */NodeJSKernelBackend.prototype.executeSingleOutput=function(e,t,r){var o=this.binding.executeOp(e,t,this.getInputTensorIds(r),1);return this.createOutputTensor(o[0])};
/**
   * Executes a TensorFlow Eager Op that provides multiple output Tensors.
   * @param name The name of the Op to execute.
   * @param opAttrs The list of Op attributes required to execute.
   * @param inputs The list of input Tensors for the Op.
   * @param numOutputs The number of output Tensors for Op execution.
   * @return A resulting Tensor array from Op execution.
   */NodeJSKernelBackend.prototype.executeMultipleOutputs=function(e,t,r,o){var n=this;var a=this.binding.executeOp(e,t,this.getInputTensorIds(r),o);return a.map((function(e){return n.createOutputTensor(e)}))};NodeJSKernelBackend.prototype.numDataIds=function(){return this.tensorMap.numDataIds()};NodeJSKernelBackend.prototype.dispose=function(){};NodeJSKernelBackend.prototype.read=function(e){return C(this,void 0,void 0,(function(){return I(this,(function(t){return[2,this.readSync(e)]}))}))};NodeJSKernelBackend.prototype.readSync=function(e){if(!this.tensorMap.has(e))throw new Error("Tensor ".concat(e," was not registered!"));var t=this.tensorMap.get(e);return t.values!=null?t.values:this.binding.tensorDataSync(t.id)};
/**
   * Dispose the memory if the dataId has 0 refCount. Return true if the memory
   * is released, false otherwise.
   * @param dataId
   * @oaram force Optional, remove the data regardless of refCount
   */NodeJSKernelBackend.prototype.disposeData=function(e,t){t===void 0&&(t=false);if(this.tensorMap.has(e)){var r=this.tensorMap.get(e).id;this.tensorMap.get(e).refCount--;if(!t&&this.tensorMap.get(e).refCount>0)return false;r!=null&&r>=0&&this.binding.deleteTensor(r);this.tensorMap.delete(e)}return true};NodeJSKernelBackend.prototype.refCount=function(e){if(this.tensorMap.has(e)){var t=this.tensorMap.get(e);return t.refCount}return 0};NodeJSKernelBackend.prototype.incRef=function(e){this.tensorMap.get(e).refCount++};NodeJSKernelBackend.prototype.move=function(e,t,r,o,n){this.tensorMap.set(e,{shape:r,dtype:getTFDType(o),values:t,id:-1,refCount:n})};NodeJSKernelBackend.prototype.write=function(e,t,r){var o={};this.move(o,e,t,r,1);return o};NodeJSKernelBackend.prototype.applyActivation=function(e,t,r,o){var n=e;if(t!=null)if(t==="linear");else if(t==="relu")n=L.relu(n);else if(t==="prelu")n=L.prelu(n,r);else if(t==="leakyrelu")n=L.leakyRelu(n,o);else if(t==="elu")n=L.elu(n);else if(t==="relu6")n=L.relu6(n);else{if(t!=="sigmoid")throw new Error("Activation: ".concat(t," has not been implemented for the Node.js backend"));n=L.sigmoid(n)}return n};NodeJSKernelBackend.prototype.divide=function(e,t){var r=[createTensorsTypeOpAttr("T",R.backend_util.upcastType(e.dtype,t.dtype))];return this.executeSingleOutput("Div",r,[e,t])};NodeJSKernelBackend.prototype.divNoNan=function(e,t){var r=[createTensorsTypeOpAttr("T",R.backend_util.upcastType(e.dtype,t.dtype))];return this.executeSingleOutput("DivNoNan",r,[e,t])};NodeJSKernelBackend.prototype.where=function(e){return this.executeSingleOutput("Where",[],[e])};NodeJSKernelBackend.prototype.topKValues=function(e,t){throw new Error("Method not implemented.")};NodeJSKernelBackend.prototype.topKIndices=function(e,t){throw new Error("Method not implemented.")};NodeJSKernelBackend.prototype.int=function(e){throw new Error("Method not implemented.")};NodeJSKernelBackend.prototype.decodeJpeg=function(e,t,r,o,n,a,i){var s=[{name:"channels",type:this.binding.TF_ATTR_INT,value:t},{name:"ratio",type:this.binding.TF_ATTR_INT,value:r},{name:"fancy_upscaling",type:this.binding.TF_ATTR_BOOL,value:o},{name:"try_recover_truncated",type:this.binding.TF_ATTR_BOOL,value:n},{name:"acceptable_fraction",type:this.binding.TF_ATTR_FLOAT,value:a},{name:"dct_method",type:this.binding.TF_ATTR_STRING,value:i}];var l=[(0,R.scalar)(e,"string")];return this.executeSingleOutput("DecodeJpeg",s,l)};NodeJSKernelBackend.prototype.decodePng=function(e,t){var r=[{name:"channels",type:this.binding.TF_ATTR_INT,value:t}];var o=[(0,R.scalar)(e,"string")];return this.executeSingleOutput("DecodePng",r,o)};NodeJSKernelBackend.prototype.decodeBmp=function(e,t){var r=[{name:"channels",type:this.binding.TF_ATTR_INT,value:t}];var o=[(0,R.scalar)(e,"string")];return this.executeSingleOutput("DecodeBmp",r,o)};NodeJSKernelBackend.prototype.decodeGif=function(e){var t=[(0,R.scalar)(e,"string")];return this.executeSingleOutput("DecodeGif",[],t)};NodeJSKernelBackend.prototype.executeEncodeImageOp=function(e,t,r,o){var n=this.binding.createTensor(o,this.binding.TF_UINT8,r);var a=this.binding.executeOp(e,t,[n],1);this.binding.deleteTensor(n);var i=a[0];i.dtype=this.binding.TF_UINT8;return this.createOutputTensor(i)};NodeJSKernelBackend.prototype.encodeJpeg=function(e,t,r,o,n,a,i,s,l,p,u){var f=[{name:"format",type:this.binding.TF_ATTR_STRING,value:r},{name:"quality",type:this.binding.TF_ATTR_INT,value:o},{name:"progressive",type:this.binding.TF_ATTR_BOOL,value:n},{name:"optimize_size",type:this.binding.TF_ATTR_BOOL,value:a},{name:"chroma_downsampling",type:this.binding.TF_ATTR_BOOL,value:i},{name:"density_unit",type:this.binding.TF_ATTR_STRING,value:s},{name:"x_density",type:this.binding.TF_ATTR_INT,value:l},{name:"y_density",type:this.binding.TF_ATTR_INT,value:p},{name:"xmp_metadata",type:this.binding.TF_ATTR_STRING,value:u}];return this.executeEncodeImageOp("EncodeJpeg",f,e,t)};NodeJSKernelBackend.prototype.encodePng=function(e,t,r){var o=[{name:"compression",type:this.binding.TF_ATTR_INT,value:r}];return this.executeEncodeImageOp("EncodePng",o,e,t)};NodeJSKernelBackend.prototype.deleteSavedModel=function(e){this.binding.deleteSavedModel(e)};NodeJSKernelBackend.prototype.loadSavedModelMetaGraph=function(e,t){return this.binding.loadSavedModel(e,t)};NodeJSKernelBackend.prototype.getMappedInputTensorIds=function(e,t){var r=this.getInputTensorIds(e);var o=[];for(var n=0;n<e.length;n++)if(t[n]!=null)if(t[n].tfDtype==="DT_UINT8"){var a=Uint8Array.from(e[n].dataSync());var i=this.binding.createTensor(e[n].shape,this.binding.TF_UINT8,a);r[n]=i;o.push(n)}else if(t[n].tfDtype==="DT_INT64"){a=(0,V.encodeInt32ArrayAsInt64)(e[n].dataSync());i=this.binding.createTensor(e[n].shape,this.binding.TF_INT64,a);r[n]=i;o.push(n)}return{tensorIds:r,newTensors:o}};NodeJSKernelBackend.prototype.runSavedModel=function(e,t,r,o){var n=this;var a=this.getMappedInputTensorIds(t,r),i=a.tensorIds,s=a.newTensors;var l=this.binding.runSavedModel(e,i,r.map((function(e){return e.name})).join(","),o.join(","));for(var p=0;p<i.length;p++)s.includes(p)&&this.binding.deleteTensor(i[p]);return l.map((function(e){return n.createOutputTensor(e)}))};NodeJSKernelBackend.prototype.summaryWriter=function(e){var t=[{name:"shared_name",type:this.binding.TF_ATTR_STRING,value:"logdir:".concat(e)},{name:"container",type:this.binding.TF_ATTR_STRING,value:""}];var r=this.executeSingleOutput("SummaryWriter",t,[]);return r};NodeJSKernelBackend.prototype.createSummaryFileWriter=function(e,t,r,o,n){var a=[e,(0,R.scalar)(t),(0,R.scalar)(r==null?10:r,"int32"),(0,R.scalar)(o==null?12e4:o,"int32"),(0,R.scalar)(n==null?".v2":n)];this.executeMultipleOutputs("CreateSummaryFileWriter",[],a,0)};NodeJSKernelBackend.prototype.writeScalarSummary=function(e,t,r,o){var n=this;(0,R.tidy)((function(){R.util.assert(Number.isInteger(t),(function(){return"step is expected to be an integer, but is instead ".concat(t)}));var a=[e,new V.Int64Scalar(t),(0,R.scalar)(r,"string")];var i;if(typeof o==="number"){a.push((0,R.scalar)(o));i=n.binding.TF_FLOAT}else{R.util.assert(o.rank===0,(function(){return"A non-scalar tensor (rank ".concat(o.rank,") is passed to ")+"writeScalarSummary()"}));a.push(o);i=n.typeAttributeFromTensor(o)}var s=[{name:"T",type:n.binding.TF_ATTR_TYPE,value:i}];var l=n.getInputTensorIds(a);n.binding.executeOp("WriteScalarSummary",s,l,0);n.binding.deleteTensor(l[1])}))};NodeJSKernelBackend.prototype.writeHistogramSummary=function(e,t,r,o,n,a){var i=this;(0,R.tidy)((function(){R.util.assert(Number.isInteger(t),(function(){return"step is expected to be an integer, but is instead ".concat(t)}));var s=(new x.HistogramPluginData).setVersion(0);var l=(new x.SummaryMetadata.PluginData).setPluginName("histograms").setContent(s.serializeBinary());var p=(new x.SummaryMetadata).setPluginData(l).setDisplayName(null).setSummaryDescription(a);var u=(0,R.scalar)(p.serializeBinary(),"string");var f=(0,R.scalar)(r,"string");var d=new V.Int64Scalar(t);var c=i.buckets(o,n);R.util.assert(c.rank===2&&c.shape[1]===3,(function(){return"Expected buckets to have shape [k, 3], but they had shape ".concat(c.shape)}));R.util.assert(c.dtype==="float32",(function(){return"Expected buckets to have dtype float32, but they had dtype ".concat(c.dtype)}));var g=[e,d,c,f,u];var v=i.typeAttributeFromTensor(c);var y=[{name:"T",type:i.binding.TF_ATTR_TYPE,value:v}];var h=i.getInputTensorIds(g);i.binding.executeOp("WriteSummary",y,h,0);i.binding.deleteTensor(h[1])}))};NodeJSKernelBackend.prototype.flushSummaryWriter=function(e){var t=[e];this.executeMultipleOutputs("FlushSummaryWriter",[],t,0)};
/**
   * Group data into histogram buckets.
   *
   * @param data A `Tensor` of any shape. Must be castable to `float32`
   * @param bucketCount Optional positive `number`
   * @returns A `Tensor` of shape `[k, 3]` and type `float32`. The `i`th row
   *     is
   *   a triple `[leftEdge, rightEdge, count]` for a single bucket. The value
   * of `k` is either `bucketCount`, `1` or `0`.
   */NodeJSKernelBackend.prototype.buckets=function(e,t){if(e.size===0)return L.tensor([],[0,3],"float32");t=t!==void 0?t:30;R.util.assert(Number.isInteger(t)&&t>0,(function(){return"Expected bucket count to be a strictly positive integer, but it was "+"".concat(t)}));e=e.flatten();e=e.cast("float32");var r=e.min();var o=e.max();var n=o.sub(r);var a=n.equal(0).arraySync()!==0;if(a){var i=r;var s=i.sub(.5);var l=i.add(.5);var p=L.scalar(e.size,"float32");return L.concat([s,l,p]).reshape([1,3])}var u=n.div(t);var f=e.sub(r);var d=f.floorDiv(u).cast("int32");var c=L.minimum(d,t-1).cast("int32");var g=L.oneHot(c,t);var v=g.sum(0).cast("int32");var y=L.linspace(r.arraySync(),o.arraySync(),t+1);y=L.concat([y.slice(0,t),o.reshape([1])],0);var h=y.slice(0,t);var w=y.slice(1,t);return L.stack([h,w,v.cast("float32")]).transpose()};NodeJSKernelBackend.prototype.memory=function(){return{unreliable:true}};NodeJSKernelBackend.prototype.time=function(e){return C(this,void 0,void 0,(function(){var t,r;return I(this,(function(o){t=A.hrtime();e();r=A.hrtime(t);return[2,{kernelMs:r[0]*1e3+r[1]/1e6}]}))}))};NodeJSKernelBackend.prototype.getNumOfSavedModels=function(){return this.binding.getNumOfSavedModels()};NodeJSKernelBackend.prototype.getNumOfTFTensors=function(){return this.binding.getNumOfTensors()};return NodeJSKernelBackend}(R.KernelBackend);N.NodeJSKernelBackend=W;function nodeBackend(){return L.findBackend("tensorflow")}N.nodeBackend=nodeBackend;function getTFDType(e){var t=nodeBackend().binding;switch(e){case"float32":return t.TF_FLOAT;case"int32":return t.TF_INT32;case"bool":return t.TF_BOOL;case"complex64":return t.TF_COMPLEX64;case"string":return t.TF_STRING;case"int64":return t.TF_INT64;default:var r="Unknown dtype: ".concat(e);throw new Error(r)}}N.getTFDType=getTFDType;function createTensorsTypeOpAttr(e,t){if((0,P.isNullOrUndefined)(t))throw new Error("Invalid input tensors value.");return{name:e,type:nodeBackend().binding.TF_ATTR_TYPE,value:t instanceof L.Tensor||Array.isArray(t)?getTFDTypeForInputs(t):getTFDType(t)}}N.createTensorsTypeOpAttr=createTensorsTypeOpAttr;function createOpAttr(e,t,r){if((0,P.isNullOrUndefined)(t))throw new Error("Invalid input tensors value.");return{name:e,type:nodeBackend().binding.TF_BOOL,value:r}}N.createOpAttr=createOpAttr;function getTFDTypeForInputs(e){if((0,P.isNullOrUndefined)(e))throw new Error("Invalid input tensors value.");if((0,P.isArray)(e)){for(var t=0;t<e.length;t++)return getTFDType(e[t].dtype);return-1}return getTFDType(e.dtype)}function ensureTensorflowBackend(){L.util.assert(L.getBackend()==="tensorflow",(function(){return'Expect the current backend to be "tensorflow", but got "'.concat(L.getBackend(),'"')}))}N.ensureTensorflowBackend=ensureTensorflowBackend;var E=e;try{"default"in e&&(E=e.default)}catch(e){}var G={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(G,"__esModule",{value:true});G.absConfig=void 0;var j=E;var z=N;G.absConfig={kernelName:j.Abs,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;if(t.dtype==="complex64"){var o=[(0,z.createTensorsTypeOpAttr)("T",t.dtype),(0,z.createTensorsTypeOpAttr)("Tout","float32")];return r.executeSingleOutput("ComplexAbs",o,[t])}return r.executeSingleInput(j.Abs,t)}};var H=e;try{"default"in e&&(H=e.default)}catch(e){}var U={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(U,"__esModule",{value:true});U.acosConfig=void 0;var J=H;U.acosConfig={kernelName:J.Acos,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(J.Acos,t)}};var q=e;try{"default"in e&&(q=e.default)}catch(e){}var K={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(K,"__esModule",{value:true});K.acoshConfig=void 0;var $=q;K.acoshConfig={kernelName:$.Acosh,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput($.Acosh,t)}};var Y=e;try{"default"in e&&(Y=e.default)}catch(e){}var X={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(X,"__esModule",{value:true});X.addConfig=void 0;var Q=Y;var Z=N;X.addConfig={kernelName:Q.Add,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Z.createTensorsTypeOpAttr)("T",Q.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(Q.Add,a,[r,o])}};var ee=e;try{"default"in e&&(ee=e.default)}catch(e){}var te={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(te,"__esModule",{value:true});te.addNConfig=void 0;var re=ee;var oe=N;te.addNConfig={kernelName:re.AddN,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs;var r=e.backend;var o=[(0,oe.createTensorsTypeOpAttr)("T",t[0].dtype),{name:"N",type:r.binding.TF_ATTR_INT,value:t.length}];return r.executeSingleOutput(re.AddN,o,t)}};var ne=e;try{"default"in e&&(ne=e.default)}catch(e){}var ae={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ae,"__esModule",{value:true});ae.allConfig=void 0;var ie=ne;var se=N;ae.allConfig={kernelName:ie.All,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.keepDims;var i=ie.util.parseAxisParam(n,t.shape);var s=[{name:"keep_dims",type:r.binding.TF_ATTR_BOOL,value:a},(0,se.createTensorsTypeOpAttr)("Tidx","int32")];var l=(0,ie.tensor1d)(i,"int32");var p=r.executeSingleOutput(ie.All,s,[t,l]);l.dispose();return p}};var le=e;try{"default"in e&&(le=e.default)}catch(e){}var pe={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(pe,"__esModule",{value:true});pe.anyConfig=void 0;var ue=le;var fe=N;pe.anyConfig={kernelName:ue.Any,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.keepDims;var i=ue.util.parseAxisParam(n,t.shape);var s=[{name:"keep_dims",type:r.binding.TF_ATTR_BOOL,value:a},(0,fe.createTensorsTypeOpAttr)("Tidx","int32")];var l=(0,ue.tensor1d)(i,"int32");var p=r.executeSingleOutput(ue.Any,s,[t,l]);l.dispose();return p}};var de=e;try{"default"in e&&(de=e.default)}catch(e){}var ce={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ce,"__esModule",{value:true});ce.argMaxConfig=void 0;var ge=de;var ve=N;ce.argMaxConfig={kernelName:ge.ArgMax,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.axis;var n=[];var a=t;if(t.dtype==="bool"){a=t.toInt();n.push(a)}var i=(0,ge.scalar)(o,"int32");n.push(i);var s=[(0,ve.createTensorsTypeOpAttr)("T",a.dtype),(0,ve.createTensorsTypeOpAttr)("Tidx","int32"),(0,ve.createTensorsTypeOpAttr)("output_type","int32")];var l=r.executeSingleOutput(ge.ArgMax,s,[a,i]);n.forEach((function(e){return e.dispose()}));return l}};var ye=e;try{"default"in e&&(ye=e.default)}catch(e){}var he={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(he,"__esModule",{value:true});he.argMinConfig=void 0;var we=ye;var me=N;he.argMinConfig={kernelName:we.ArgMin,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.axis;var n=[];var a=t;if(t.dtype==="bool"){a=t.toInt();n.push(a)}var i=(0,we.scalar)(o,"int32");n.push(i);var s=[(0,me.createTensorsTypeOpAttr)("T",a.dtype),(0,me.createTensorsTypeOpAttr)("Tidx","int32"),(0,me.createTensorsTypeOpAttr)("output_type","int32")];var l=r.executeSingleOutput(we.ArgMin,s,[a,i]);n.forEach((function(e){return e.dispose()}));return l}};var Te=e;try{"default"in e&&(Te=e.default)}catch(e){}var be={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(be,"__esModule",{value:true});be.asinConfig=void 0;var De=Te;be.asinConfig={kernelName:De.Asin,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(De.Asin,t)}};var Fe=e;try{"default"in e&&(Fe=e.default)}catch(e){}var Me={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Me,"__esModule",{value:true});Me.asinhConfig=void 0;var Se=Fe;Me.asinhConfig={kernelName:Se.Asinh,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Se.Asinh,t)}};var ke=e;try{"default"in e&&(ke=e.default)}catch(e){}var Oe={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Oe,"__esModule",{value:true});Oe.atanConfig=void 0;var _e=ke;Oe.atanConfig={kernelName:_e.Atan,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(_e.Atan,t)}};var Ne=e;try{"default"in e&&(Ne=e.default)}catch(e){}var Ae={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ae,"__esModule",{value:true});Ae.atan2Config=void 0;var Be=Ne;var Ce=N;Ae.atan2Config={kernelName:Be.Atan2,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Ce.createTensorsTypeOpAttr)("T",r.dtype)];return n.executeSingleOutput(Be.Atan2,a,[r,o])}};var Ie=e;try{"default"in e&&(Ie=e.default)}catch(e){}var Le={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Le,"__esModule",{value:true});Le.atanhConfig=void 0;var Re=Ie;Le.atanhConfig={kernelName:Re.Atanh,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Re.Atanh,t)}};var Pe=e;try{"default"in e&&(Pe=e.default)}catch(e){}var Ve={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ve,"__esModule",{value:true});Ve.avgPoolConfig=void 0;var xe=Pe;var We=N;Ve.avgPoolConfig={kernelName:xe.AvgPool,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.filterSize,a=o.strides,i=o.pad,s=o.dimRoundingMode;var l=xe.backend_util.computePool2DInfo(t.shape,n,a,1,i,s);if(l.padInfo.type!=="VALID"&&l.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(l.padInfo.type));var p=[1,l.filterHeight,l.filterWidth,1];var u=[1,l.strideHeight,l.strideWidth,1];var f=l.padInfo.type;var d=l.dataFormat==="channelsLast"?"NHWC":"NCHW";var c=[(0,We.createTensorsTypeOpAttr)("T",t.dtype),{name:"ksize",type:r.binding.TF_ATTR_INT,value:p},{name:"strides",type:r.binding.TF_ATTR_INT,value:u},{name:"padding",type:r.binding.TF_ATTR_STRING,value:f},{name:"data_format",type:r.binding.TF_ATTR_STRING,value:d}];return r.executeSingleOutput(xe.AvgPool,c,[t])}};var Ee=e;try{"default"in e&&(Ee=e.default)}catch(e){}var Ge={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ge,"__esModule",{value:true});Ge.avgPool3DConfig=void 0;var je=Ee;var ze=N;Ge.avgPool3DConfig={kernelName:je.AvgPool3D,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.filterSize,a=o.strides,i=o.pad,s=o.dimRoundingMode,l=o.dataFormat;var p=je.backend_util.computePool3DInfo(t.shape,n,a,1,i,s,l);if(p.padInfo.type!=="VALID"&&p.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(p.padInfo.type));var u=[1,p.filterDepth,p.filterHeight,p.filterWidth,1];var f=[1,p.strideDepth,p.strideHeight,p.strideWidth,1];var d=p.padInfo.type;var c=p.dataFormat==="channelsLast"?"NDHWC":"NCDHW";var g=[(0,ze.createTensorsTypeOpAttr)("T",t.dtype),{name:"ksize",type:r.binding.TF_ATTR_INT,value:u},{name:"strides",type:r.binding.TF_ATTR_INT,value:f},{name:"padding",type:r.binding.TF_ATTR_STRING,value:d},{name:"data_format",type:r.binding.TF_ATTR_STRING,value:c}];return r.executeSingleOutput(je.AvgPool3D,g,[t])}};var He=e;try{"default"in e&&(He=e.default)}catch(e){}var Ue={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ue,"__esModule",{value:true});Ue.avgPool3DGradConfig=void 0;var Je=He;var qe=N;Ue.avgPool3DGradConfig={kernelName:Je.AvgPool3DGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.input;var n=e.backend;var a=e.attrs,i=a.filterSize,s=a.strides,l=a.pad,p=a.dimRoundingMode;var u=Je.backend_util.computePool3DInfo(o.shape,i,s,1,l,p);if(u.padInfo.type!=="VALID"&&u.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding type was ".concat(u.padInfo.type));var f=[1,u.filterDepth,u.filterHeight,u.filterWidth,1];var d=[1,u.strideDepth,u.strideHeight,u.strideWidth,1];var c=u.padInfo.type;var g=u.dataFormat==="channelsLast"?"NDHWC":"NCDHW";var v=[(0,qe.createTensorsTypeOpAttr)("T",o.dtype),{name:"ksize",type:n.binding.TF_ATTR_INT,value:f},{name:"strides",type:n.binding.TF_ATTR_INT,value:d},{name:"padding",type:n.binding.TF_ATTR_STRING,value:c},{name:"data_format",type:n.binding.TF_ATTR_STRING,value:g}];var y=(0,Je.tensor1d)(o.shape,"int32");var h=n.executeSingleOutput(Je.AvgPool3DGrad,v,[y,r]);y.dispose();return h}};var Ke=e;try{"default"in e&&(Ke=e.default)}catch(e){}var $e={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty($e,"__esModule",{value:true});$e.avgPoolGradConfig=void 0;var Ye=Ke;var Xe=N;$e.avgPoolGradConfig={kernelName:Ye.AvgPoolGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.input;var n=e.backend;var a=e.attrs,i=a.filterSize,s=a.strides,l=a.pad;var p=Ye.backend_util.computePool2DInfo(o.shape,i,s,1,l);if(p.padInfo.type!=="VALID"&&p.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding type was ".concat(p.padInfo.type));var u=[1,p.filterHeight,p.filterWidth,1];var f=[1,p.strideHeight,p.strideWidth,1];var d=p.padInfo.type;var c=p.dataFormat==="channelsLast"?"NHWC":"NCHW";var g=[(0,Xe.createTensorsTypeOpAttr)("T",o.dtype),{name:"ksize",type:n.binding.TF_ATTR_INT,value:u},{name:"strides",type:n.binding.TF_ATTR_INT,value:f},{name:"padding",type:n.binding.TF_ATTR_STRING,value:d},{name:"data_format",type:n.binding.TF_ATTR_STRING,value:c}];var v=(0,Ye.tensor1d)(o.shape,"int32");var y=n.executeSingleOutput(Ye.AvgPoolGrad,g,[v,r]);v.dispose();return y}};var Qe=e;try{"default"in e&&(Qe=e.default)}catch(e){}var Ze={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ze,"__esModule",{value:true});Ze.batchMatMulConfig=void 0;var et=Qe;var tt=N;Ze.batchMatMulConfig={kernelName:et.BatchMatMul,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=e.attrs,i=a.transposeA,s=a.transposeB;var l=[(0,tt.createTensorsTypeOpAttr)("T",r.dtype),{name:"adj_x",type:n.binding.TF_ATTR_BOOL,value:i},{name:"adj_y",type:n.binding.TF_ATTR_BOOL,value:s}];return n.executeSingleOutput("BatchMatMulV2",l,[r,o])}};var rt=e;try{"default"in e&&(rt=e.default)}catch(e){}var ot={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ot,"__esModule",{value:true});ot.batchToSpaceNDConfig=void 0;var nt=rt;var at=N;ot.batchToSpaceNDConfig={kernelName:nt.BatchToSpaceND,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.blockShape,a=o.crops;var i=(0,nt.tensor1d)(n,"int32");var s=(0,nt.tensor2d)(a,[a.length,a[0].length],"int32");var l=[(0,at.createTensorsTypeOpAttr)("T",t.dtype),(0,at.createTensorsTypeOpAttr)("Tblock_shape","int32"),(0,at.createTensorsTypeOpAttr)("Tcrops",s.dtype)];var p=r.executeSingleOutput(nt.BatchToSpaceND,l,[t,i,s]);s.dispose();i.dispose();return p}};var it=e;try{"default"in e&&(it=e.default)}catch(e){}var st={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(st,"__esModule",{value:true});st.bincountConfig=void 0;var lt=it;var pt=N;st.bincountConfig={kernelName:lt.Bincount,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=t,a=n.x,i=n.weights;var s=o.size;var l=r;var p=(0,lt.scalar)(s,"int32");var u=[(0,pt.createTensorsTypeOpAttr)("T",i.dtype)];var f=l.executeSingleOutput(lt.Bincount,u,[a,p,i]);p.dispose();return f}};var ut=e;try{"default"in e&&(ut=e.default)}catch(e){}var ft={};
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
 */Object.defineProperty(ft,"__esModule",{value:true});ft.broadcastArgsConfig=void 0;var dt=ut;var ct=N;ft.broadcastArgsConfig={kernelName:dt.BroadcastArgs,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.s0,o=t.s1;var n=e.backend;var a=[(0,ct.createTensorsTypeOpAttr)("T",dt.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(dt.BroadcastArgs,a,[r,o])}};var gt=e;try{"default"in e&&(gt=e.default)}catch(e){}var vt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(vt,"__esModule",{value:true});vt.castConfig=void 0;var yt=gt;var ht=N;vt.castConfig={kernelName:yt.Cast,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.dtype;var n=[(0,ht.createTensorsTypeOpAttr)("SrcT",t.dtype),(0,ht.createTensorsTypeOpAttr)("DstT",o),{name:"Truncate",type:r.binding.TF_ATTR_BOOL,value:false}];return r.executeSingleOutput(yt.Cast,n,[t])}};var wt=e;try{"default"in e&&(wt=e.default)}catch(e){}var mt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(mt,"__esModule",{value:true});mt.ceilConfig=void 0;var Tt=wt;mt.ceilConfig={kernelName:Tt.Ceil,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Tt.Ceil,t)}};var bt=e;try{"default"in e&&(bt=e.default)}catch(e){}var Dt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Dt,"__esModule",{value:true});Dt.clipByValueConfig=void 0;var Ft=bt;Dt.clipByValueConfig={kernelName:Ft.ClipByValue,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.attrs,o=r.clipValueMin,n=r.clipValueMax;return(0,Ft.tidy)((function(){var e=(0,Ft.minimum)(t,(0,Ft.scalar)(n,t.dtype));return(0,Ft.maximum)(e,(0,Ft.scalar)(o,t.dtype))}))}};var Mt=e;try{"default"in e&&(Mt=e.default)}catch(e){}var St={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(St,"__esModule",{value:true});St.complexConfig=void 0;var kt=Mt;var Ot=N;St.complexConfig={kernelName:kt.Complex,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.real,o=t.imag;var n=e.backend;var a=[(0,Ot.createTensorsTypeOpAttr)("T",r),{name:"Tout",type:n.binding.TF_ATTR_TYPE,value:n.binding.TF_COMPLEX64}];var i=[r,o];return n.executeSingleOutput(kt.Complex,a,i)}};var _t=e;try{"default"in e&&(_t=e.default)}catch(e){}var Nt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Nt,"__esModule",{value:true});Nt.complexAbsConfig=void 0;var At=_t;var Bt=N;Nt.complexAbsConfig={kernelName:At.ComplexAbs,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=[(0,Bt.createTensorsTypeOpAttr)("T",t.dtype),(0,Bt.createTensorsTypeOpAttr)("Tout","float32")];return r.executeSingleOutput(At.ComplexAbs,o,[t])}};var Ct=e;try{"default"in e&&(Ct=e.default)}catch(e){}var It={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(It,"__esModule",{value:true});It.concatConfig=void 0;var Lt=Ct;var Rt=N;It.concatConfig={kernelName:Lt.Concat,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs;var r=e.backend;var o=e.attrs.axis;var n=[{name:"N",type:r.binding.TF_ATTR_INT,value:t.length},{name:"Tidx",type:r.binding.TF_ATTR_TYPE,value:r.binding.TF_INT32},(0,Rt.createTensorsTypeOpAttr)("T",t)];var a=Array.from(t);var i=(0,Lt.scalar)(o,"int32");a.push(i);var s=r.executeSingleOutput("ConcatV2",n,a);i.dispose();return s}};var Pt=e;try{"default"in e&&(Pt=e.default)}catch(e){}var Vt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */var xt=Vt&&Vt.__spreadArray||function(e,t,r){if(r||arguments.length===2)for(var o,n=0,a=t.length;n<a;n++)if(o||!(n in t)){o||(o=Array.prototype.slice.call(t,0,n));o[n]=t[n]}return e.concat(o||Array.prototype.slice.call(t))};Object.defineProperty(Vt,"__esModule",{value:true});Vt.conv2dImpl=Vt.conv2DConfig=void 0;var Wt=Pt;var Et=N;Vt.conv2DConfig={kernelName:Wt.Conv2D,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.filter;var n=e.backend;var a=e.attrs,i=a.strides,s=a.pad,l=a.dataFormat,p=a.dilations,u=a.dimRoundingMode;var f=Wt.backend_util.convertConv2DDataFormat(l);var d=Wt.backend_util.computeConv2DInfo(r.shape,o.shape,i,p,s,u,false,f);return conv2dImpl(r,o,d,n)}};function conv2dImpl(e,t,r,o){if(r.padInfo.type!=="VALID"&&r.padInfo.type!=="SAME"&&r.padInfo.type!=="EXPLICIT")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(r.padInfo.type));var n=[1,r.strideHeight,r.strideWidth,1];var a=r.padInfo.type;var i=r.dataFormat==="channelsLast"?"NHWC":"NCHW";var s=[1,r.dilationHeight,r.dilationWidth,1];var l=[(0,Et.createTensorsTypeOpAttr)("T",e.dtype),{name:"strides",type:o.binding.TF_ATTR_INT,value:n},{name:"padding",type:o.binding.TF_ATTR_STRING,value:a},{name:"data_format",type:o.binding.TF_ATTR_STRING,value:i},{name:"use_cudnn_on_gpu",type:o.binding.TF_ATTR_BOOL,value:true},{name:"dilations",type:o.binding.TF_ATTR_INT,value:s}];if(a==="EXPLICIT"){var p=[r.padInfo.top,r.padInfo.bottom,r.padInfo.left,r.padInfo.right];l.push({name:"explicit_paddings",type:o.binding.TF_ATTR_INT,value:i==="NHWC"?xt(xt([0,0],p,true),[0,0],false):xt([0,0,0,0],p,true)})}return o.executeSingleOutput(Wt.Conv2D,l,[e,t])}Vt.conv2dImpl=conv2dImpl;var Gt=e;try{"default"in e&&(Gt=e.default)}catch(e){}var jt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(jt,"__esModule",{value:true});jt.conv2DBackpropFilterConfig=void 0;var zt=Gt;var Ht=N;jt.conv2DBackpropFilterConfig={kernelName:zt.Conv2DBackpropFilter,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.dy;var n=e.backend;var a=e.attrs,i=a.strides,s=a.pad,l=a.dataFormat,p=a.dimRoundingMode,u=a.filterShape;var f=zt.backend_util.convertConv2DDataFormat(l);var d=zt.backend_util.computeConv2DInfo(r.shape,u,i,1,s,p,false,f);return conv2DBackpropFilterImpl(o,r,d,n)}};function conv2DBackpropFilterImpl(e,t,r,o){if(r.padInfo.type!=="VALID"&&r.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(r.padInfo.type));var n=[1,r.strideHeight,r.strideWidth,1];var a=r.padInfo.type;var i=r.dataFormat==="channelsLast"?"NHWC":"NCHW";var s=[1,r.dilationHeight,r.dilationWidth,1];var l=[(0,Ht.createTensorsTypeOpAttr)("T","float32"),{name:"strides",type:o.binding.TF_ATTR_INT,value:n},{name:"padding",type:o.binding.TF_ATTR_STRING,value:a},{name:"data_format",type:o.binding.TF_ATTR_STRING,value:i},{name:"use_cudnn_on_gpu",type:o.binding.TF_ATTR_BOOL,value:true},{name:"dilations",type:o.binding.TF_ATTR_INT,value:s}];var p=(0,zt.tensor1d)(r.filterShape,"int32");var u=o.executeSingleOutput(zt.Conv2DBackpropFilter,l,[t,p,e]);p.dispose();return u}var Ut=e;try{"default"in e&&(Ut=e.default)}catch(e){}var Jt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Jt,"__esModule",{value:true});Jt.conv2DBackpropInputConfig=void 0;var qt=Ut;var Kt=N;Jt.conv2DBackpropInputConfig={kernelName:qt.Conv2DBackpropInput,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.filter;var n=e.backend;var a=e.attrs,i=a.strides,s=a.pad,l=a.dataFormat,p=a.dimRoundingMode,u=a.inputShape;var f=qt.backend_util.convertConv2DDataFormat(l);var d=qt.backend_util.computeConv2DInfo(u,o.shape,i,1,s,p,false,f);return conv2DBackpropInputImpl(r,o,d,n)}};function conv2DBackpropInputImpl(e,t,r,o){if(r.padInfo.type!=="VALID"&&r.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(r.padInfo.type));var n=[1,r.strideHeight,r.strideWidth,1];var a=r.padInfo.type;var i=r.dataFormat==="channelsLast"?"NHWC":"NCHW";var s=[1,r.dilationHeight,r.dilationWidth,1];var l=[(0,Kt.createTensorsTypeOpAttr)("T","float32"),{name:"strides",type:o.binding.TF_ATTR_INT,value:n},{name:"padding",type:o.binding.TF_ATTR_STRING,value:a},{name:"data_format",type:o.binding.TF_ATTR_STRING,value:i},{name:"use_cudnn_on_gpu",type:o.binding.TF_ATTR_BOOL,value:true},{name:"dilations",type:o.binding.TF_ATTR_INT,value:s}];var p=(0,qt.tensor1d)(r.inShape,"int32");var u=o.executeSingleOutput(qt.Conv2DBackpropInput,l,[p,t,e]);p.dispose();return u}var $t=e;try{"default"in e&&($t=e.default)}catch(e){}var Yt={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Yt,"__esModule",{value:true});Yt.conv3DConfig=void 0;var Xt=$t;var Qt=N;Yt.conv3DConfig={kernelName:Xt.Conv3D,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.filter;var n=e.backend;var a=e.attrs,i=a.strides,s=a.pad,l=a.dilations;var p=Xt.backend_util.computeConv3DInfo(r.shape,o.shape,i,l,s);var u=[1,p.strideDepth,p.strideHeight,p.strideWidth,1];var f=p.padInfo.type;var d=p.dataFormat==="channelsLast"?"NDHWC":"NCDHW";if(!n.isGPUPackage&&p.dilationDepth>1)throw new Error("CPU Dilation depth must be 1");var c=[1,p.dilationDepth,p.dilationHeight,p.dilationWidth,1];var g=[(0,Qt.createTensorsTypeOpAttr)("T",r.dtype),{name:"strides",type:n.binding.TF_ATTR_INT,value:u},{name:"padding",type:n.binding.TF_ATTR_STRING,value:f},{name:"data_format",type:n.binding.TF_ATTR_STRING,value:d},{name:"dilations",type:n.binding.TF_ATTR_INT,value:c}];return n.executeSingleOutput(Xt.Conv3D,g,[r,o])}};var Zt=e;try{"default"in e&&(Zt=e.default)}catch(e){}var er={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(er,"__esModule",{value:true});er.conv3DBackpropFilterV2Config=void 0;var tr=Zt;var rr=N;er.conv3DBackpropFilterV2Config={kernelName:tr.Conv3DBackpropFilterV2,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.dy;var n=e.backend;var a=e.attrs,i=a.strides,s=a.pad,l=a.filterShape;var p=1;var u=tr.backend_util.computeConv3DInfo(r.shape,l,i,p,s);var f=[1,u.strideDepth,u.strideHeight,u.strideWidth,1];var d=u.padInfo.type;var c=u.dataFormat==="channelsLast"?"NDHWC":"NCDHW";if(!n.isGPUPackage&&u.dilationDepth>1)throw new Error("CPU Dilation depth must be 1");var g=[1,u.dilationDepth,u.dilationHeight,u.dilationWidth,1];var v=[(0,rr.createTensorsTypeOpAttr)("T",r.dtype),{name:"strides",type:n.binding.TF_ATTR_INT,value:f},{name:"padding",type:n.binding.TF_ATTR_STRING,value:d},{name:"data_format",type:n.binding.TF_ATTR_STRING,value:c},{name:"dilations",type:n.binding.TF_ATTR_INT,value:g}];var y=(0,tr.tensor1d)(l,"int32");var h=n.executeSingleOutput(tr.Conv3DBackpropFilterV2,v,[r,y,o]);y.dispose();return h}};var or=e;try{"default"in e&&(or=e.default)}catch(e){}var nr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(nr,"__esModule",{value:true});nr.conv3DBackpropInputV2Config=void 0;var ar=or;var ir=N;nr.conv3DBackpropInputV2Config={kernelName:ar.Conv3DBackpropInputV2,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.filter;var n=e.backend;var a=e.attrs,i=a.strides,s=a.pad,l=a.inputShape;var p=1;var u=ar.backend_util.computeConv3DInfo(l,o.shape,i,p,s);var f=[1,u.strideDepth,u.strideHeight,u.strideWidth,1];var d=u.padInfo.type;var c=u.dataFormat==="channelsLast"?"NDHWC":"NCDHW";if(!n.isGPUPackage&&u.dilationDepth>1)throw new Error("CPU Dilation depth must be 1");var g=[1,u.dilationDepth,u.dilationHeight,u.dilationWidth,1];var v=[(0,ir.createTensorsTypeOpAttr)("T",r.dtype),{name:"strides",type:n.binding.TF_ATTR_INT,value:f},{name:"padding",type:n.binding.TF_ATTR_STRING,value:d},{name:"data_format",type:n.binding.TF_ATTR_STRING,value:c},{name:"dilations",type:n.binding.TF_ATTR_INT,value:g},(0,ir.createTensorsTypeOpAttr)("Tshape","int32")];var y=(0,ar.tensor1d)(l,"int32");var h=n.executeSingleOutput(ar.Conv3DBackpropInputV2,v,[y,o,r]);y.dispose();return h}};var sr=e;try{"default"in e&&(sr=e.default)}catch(e){}var lr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(lr,"__esModule",{value:true});lr.cosConfig=void 0;var pr=sr;lr.cosConfig={kernelName:pr.Cos,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(pr.Cos,t)}};var ur=e;try{"default"in e&&(ur=e.default)}catch(e){}var fr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(fr,"__esModule",{value:true});fr.coshConfig=void 0;var dr=ur;fr.coshConfig={kernelName:dr.Cosh,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(dr.Cosh,t)}};var cr=e;try{"default"in e&&(cr=e.default)}catch(e){}var gr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(gr,"__esModule",{value:true});gr.cropAndResizeConfig=void 0;var vr=cr;var yr=N;gr.cropAndResizeConfig={kernelName:vr.CropAndResize,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.image,o=t.boxes,n=t.boxInd;var a=e.backend;var i=e.attrs,s=i.cropSize,l=i.method,p=i.extrapolationValue;var u=[(0,yr.createTensorsTypeOpAttr)("T",r.dtype),{name:"method",type:a.binding.TF_ATTR_STRING,value:l},{name:"extrapolation_value",type:a.binding.TF_ATTR_FLOAT,value:p}];var f=(0,vr.tensor1d)(s,"int32");var d=a.executeSingleOutput(vr.CropAndResize,u,[r,o,n,f]);f.dispose();return d}};var hr=e;try{"default"in e&&(hr=e.default)}catch(e){}var wr={};
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
 */Object.defineProperty(wr,"__esModule",{value:true});wr.cumprodConfig=void 0;var mr=hr;var Tr=N;wr.cumprodConfig={kernelName:mr.Cumprod,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.exclusive,i=o.reverse;var s=(0,mr.scalar)(n,"int32");var l=[{name:"exclusive",type:r.binding.TF_ATTR_BOOL,value:a},{name:"reverse",type:r.binding.TF_ATTR_BOOL,value:i},(0,Tr.createTensorsTypeOpAttr)("T",t.dtype),(0,Tr.createTensorsTypeOpAttr)("Tidx","int32")];var p=r.executeSingleOutput(mr.Cumprod,l,[t,s]);s.dispose();return p}};var br=e;try{"default"in e&&(br=e.default)}catch(e){}var Dr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Dr,"__esModule",{value:true});Dr.cumsumConfig=void 0;var Fr=br;var Mr=N;Dr.cumsumConfig={kernelName:Fr.Cumsum,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.exclusive,i=o.reverse;var s=(0,Fr.scalar)(n,"int32");var l=[{name:"exclusive",type:r.binding.TF_ATTR_BOOL,value:a},{name:"reverse",type:r.binding.TF_ATTR_BOOL,value:i},(0,Mr.createTensorsTypeOpAttr)("T",t.dtype),(0,Mr.createTensorsTypeOpAttr)("Tidx","int32")];var p=r.executeSingleOutput(Fr.Cumsum,l,[t,s]);s.dispose();return p}};var Sr=e;try{"default"in e&&(Sr=e.default)}catch(e){}var kr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(kr,"__esModule",{value:true});kr.depthToSpaceConfig=void 0;var Or=Sr;var _r=N;kr.depthToSpaceConfig={kernelName:Or.DepthToSpace,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.blockSize,a=o.dataFormat;var i=[(0,_r.createTensorsTypeOpAttr)("T",t),{name:"block_size",type:r.binding.TF_ATTR_INT,value:n<2?2:n},{name:"data_format",type:r.binding.TF_ATTR_STRING,value:a}];var s=[t];return r.executeSingleOutput(Or.DepthToSpace,i,s)}};var Nr=e;try{"default"in e&&(Nr=e.default)}catch(e){}var Ar={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */var Br=Ar&&Ar.__spreadArray||function(e,t,r){if(r||arguments.length===2)for(var o,n=0,a=t.length;n<a;n++)if(o||!(n in t)){o||(o=Array.prototype.slice.call(t,0,n));o[n]=t[n]}return e.concat(o||Array.prototype.slice.call(t))};Object.defineProperty(Ar,"__esModule",{value:true});Ar.depthwiseConv2dNativeImpl=Ar.depthwiseConv2dNativeConfig=void 0;var Cr=Nr;var Ir=N;Ar.depthwiseConv2dNativeConfig={kernelName:Cr.DepthwiseConv2dNative,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.filter;var n=e.backend;var a=e.attrs,i=a.strides,s=a.pad,l=a.dilations,p=a.dimRoundingMode;var u=l;u==null&&(u=[1,1]);var f=Cr.backend_util.computeConv2DInfo(r.shape,o.shape,i,u,s,p,true);return depthwiseConv2dNativeImpl(r,o,f,n)}};function depthwiseConv2dNativeImpl(e,t,r,o){if(r.padInfo.type!=="VALID"&&r.padInfo.type!=="SAME"&&r.padInfo.type!=="EXPLICIT")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(r.padInfo.type));var n=[1,r.strideHeight,r.strideWidth,1];var a=r.padInfo.type;var i=r.dataFormat==="channelsLast"?"NHWC":"NCHW";var s=[1,r.dilationHeight,r.dilationWidth,1];var l=[(0,Ir.createTensorsTypeOpAttr)("T",e.dtype),{name:"strides",type:o.binding.TF_ATTR_INT,value:n},{name:"padding",type:o.binding.TF_ATTR_STRING,value:a},{name:"data_format",type:o.binding.TF_ATTR_STRING,value:i},{name:"dilations",type:o.binding.TF_ATTR_INT,value:s}];if(a==="EXPLICIT"){var p=[r.padInfo.top,r.padInfo.bottom,r.padInfo.left,r.padInfo.right];l.push({name:"explicit_paddings",type:o.binding.TF_ATTR_INT,value:i==="NHWC"?Br(Br([0,0],p,true),[0,0],false):Br([0,0,0,0],p,true)})}return o.executeSingleOutput(Cr.DepthwiseConv2dNative,l,[e,t])}Ar.depthwiseConv2dNativeImpl=depthwiseConv2dNativeImpl;var Lr=e;try{"default"in e&&(Lr=e.default)}catch(e){}var Rr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Rr,"__esModule",{value:true});Rr.depthwiseConv2dNativeBackpropFilterConfig=void 0;var Pr=Lr;var Vr=N;Rr.depthwiseConv2dNativeBackpropFilterConfig={kernelName:Pr.DepthwiseConv2dNativeBackpropFilter,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.dy;var n=e.backend;var a=e.attrs,i=a.strides,s=a.dilations,l=a.pad,p=a.dimRoundingMode,u=a.filterShape;var f=Pr.backend_util.computeConv2DInfo(r.shape,u,i,s,l,p,true);return depthwiseConv2dNativeBackpropFilterImpl(r,o,f,n)}};function depthwiseConv2dNativeBackpropFilterImpl(e,t,r,o){var n=[1,r.strideHeight,r.strideWidth,1];var a=r.padInfo.type;var i=r.dataFormat==="channelsLast"?"NHWC":"NCHW";var s=[1,r.dilationHeight,r.dilationWidth,1];var l=[(0,Vr.createTensorsTypeOpAttr)("T","float32"),{name:"strides",type:o.binding.TF_ATTR_INT,value:n},{name:"padding",type:o.binding.TF_ATTR_STRING,value:a},{name:"data_format",type:o.binding.TF_ATTR_STRING,value:i},{name:"dilations",type:o.binding.TF_ATTR_INT,value:s}];var p=(0,Pr.tensor1d)(r.filterShape,"int32");var u=o.executeSingleOutput(Pr.DepthwiseConv2dNativeBackpropFilter,l,[e,p,t]);p.dispose();return u}var xr=e;try{"default"in e&&(xr=e.default)}catch(e){}var Wr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Wr,"__esModule",{value:true});Wr.depthwiseConv2dNativeBackpropInputConfig=void 0;var Er=xr;var Gr=N;Wr.depthwiseConv2dNativeBackpropInputConfig={kernelName:Er.DepthwiseConv2dNativeBackpropInput,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.filter;var n=e.backend;var a=e.attrs,i=a.strides,s=a.dilations,l=a.pad,p=a.dimRoundingMode,u=a.inputShape;var f=Er.backend_util.computeConv2DInfo(u,o.shape,i,s,l,p,true);return depthwiseConv2dNativeBackpropInputImpl(r,o,f,n)}};function depthwiseConv2dNativeBackpropInputImpl(e,t,r,o){var n=[1,r.strideHeight,r.strideWidth,1];var a=r.padInfo.type;var i=r.dataFormat==="channelsLast"?"NHWC":"NCHW";var s=[1,r.dilationHeight,r.dilationWidth,1];var l=[(0,Gr.createTensorsTypeOpAttr)("T","float32"),{name:"strides",type:o.binding.TF_ATTR_INT,value:n},{name:"padding",type:o.binding.TF_ATTR_STRING,value:a},{name:"data_format",type:o.binding.TF_ATTR_STRING,value:i},{name:"dilations",type:o.binding.TF_ATTR_INT,value:s}];var p=(0,Er.tensor1d)(r.inShape,"int32");var u=o.executeSingleOutput(Er.DepthwiseConv2dNativeBackpropInput,l,[p,t,e]);p.dispose();return u}var jr=e;try{"default"in e&&(jr=e.default)}catch(e){}var zr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(zr,"__esModule",{value:true});zr.diagConfig=void 0;var Hr=jr;zr.diagConfig={kernelName:Hr.Diag,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Hr.Diag,t)}};var Ur=e;try{"default"in e&&(Ur=e.default)}catch(e){}var Jr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Jr,"__esModule",{value:true});Jr.dilation2dConfig=void 0;var qr=Ur;var Kr=N;Jr.dilation2dConfig={kernelName:qr.Dilation2D,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=t,a=n.x,i=n.filter;var s=o,l=s.strides,p=s.pad,u=s.dilations;var f=qr.backend_util.computeDilation2DInfo(a.shape,i.shape,l,p,"NHWC",u),d=f.dilationHeight,c=f.dilationWidth,g=f.padInfo,v=f.strideHeight,y=f.strideWidth;var h=[1,v,y,1];var w=[1,d,c,1];var m=r;var T=[(0,Kr.createTensorsTypeOpAttr)("T",a.dtype),{name:"strides",type:m.binding.TF_ATTR_INT,value:h},{name:"rates",type:m.binding.TF_ATTR_INT,value:w},{name:"padding",type:m.binding.TF_ATTR_STRING,value:g.type}];return m.executeSingleOutput(qr.Dilation2D,T,[a,i])}};var $r=e;try{"default"in e&&($r=e.default)}catch(e){}var Yr={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Yr,"__esModule",{value:true});Yr.dilation2dBackpropFilterConfig=void 0;var Xr=$r;var Qr=N;Yr.dilation2dBackpropFilterConfig={kernelName:Xr.Dilation2DBackpropFilter,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=t,a=n.x,i=n.filter,s=n.dy;var l=o,p=l.strides,u=l.pad,f=l.dilations;var d=Xr.backend_util.computeDilation2DInfo(a.shape,i.shape,p,u,"NHWC",f),c=d.dilationHeight,g=d.dilationWidth,v=d.padInfo,y=d.strideHeight,h=d.strideWidth;var w=[1,y,h,1];var m=[1,c,g,1];var T=r;var b=[(0,Qr.createTensorsTypeOpAttr)("T",a.dtype),{name:"strides",type:T.binding.TF_ATTR_INT,value:w},{name:"rates",type:T.binding.TF_ATTR_INT,value:m},{name:"padding",type:T.binding.TF_ATTR_STRING,value:v.type}];return T.executeSingleOutput(Xr.Dilation2DBackpropFilter,b,[a,i,s])}};var Zr=e;try{"default"in e&&(Zr=e.default)}catch(e){}var eo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(eo,"__esModule",{value:true});eo.dilation2dBackpropInputConfig=void 0;var to=Zr;var ro=N;eo.dilation2dBackpropInputConfig={kernelName:to.Dilation2DBackpropInput,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=t,a=n.x,i=n.filter,s=n.dy;var l=o,p=l.strides,u=l.pad,f=l.dilations;var d=to.backend_util.computeDilation2DInfo(a.shape,i.shape,p,u,"NHWC",f),c=d.dilationHeight,g=d.dilationWidth,v=d.padInfo,y=d.strideHeight,h=d.strideWidth;var w=[1,y,h,1];var m=[1,c,g,1];var T=r;var b=[(0,ro.createTensorsTypeOpAttr)("T",a.dtype),{name:"strides",type:T.binding.TF_ATTR_INT,value:w},{name:"rates",type:T.binding.TF_ATTR_INT,value:m},{name:"padding",type:T.binding.TF_ATTR_STRING,value:v.type}];return T.executeSingleOutput(to.Dilation2DBackpropInput,b,[a,i,s])}};var oo=e;try{"default"in e&&(oo=e.default)}catch(e){}var no={};
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
 */Object.defineProperty(no,"__esModule",{value:true});no.einsumConfig=void 0;var ao=oo;var io=N;no.einsumConfig={kernelName:ao.Einsum,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.attrs;var o=t;var n=e.backend;var a=r.equation;var i=[{name:"N",type:n.binding.TF_ATTR_INT,value:o.length},{name:"equation",type:n.binding.TF_ATTR_STRING,value:a},(0,io.createTensorsTypeOpAttr)("T",o)];var s=Array.from(o);return n.executeSingleOutput(ao.Einsum,i,s)}};var so=e;try{"default"in e&&(so=e.default)}catch(e){}var lo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(lo,"__esModule",{value:true});lo.eluConfig=void 0;var po=so;lo.eluConfig={kernelName:po.Elu,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(po.Elu,t)}};var uo=e;try{"default"in e&&(uo=e.default)}catch(e){}var fo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(fo,"__esModule",{value:true});fo.eluGradConfig=void 0;var co=uo;var go=N;fo.eluGradConfig={kernelName:co.EluGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.y;var n=e.backend;var a=[(0,go.createTensorsTypeOpAttr)("T",o.dtype)];return n.executeSingleOutput(co.EluGrad,a,[r,o])}};var vo=e;try{"default"in e&&(vo=e.default)}catch(e){}var yo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(yo,"__esModule",{value:true});yo.equalConfig=void 0;var ho=vo;var wo=N;yo.equalConfig={kernelName:ho.Equal,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,wo.createTensorsTypeOpAttr)("T",ho.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(ho.Equal,a,[r,o])}};var mo=e;try{"default"in e&&(mo=e.default)}catch(e){}var To={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(To,"__esModule",{value:true});To.erfConfig=void 0;var bo=mo;To.erfConfig={kernelName:bo.Erf,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(bo.Erf,t)}};var Do=e;try{"default"in e&&(Do=e.default)}catch(e){}var Fo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Fo,"__esModule",{value:true});Fo.expConfig=void 0;var Mo=Do;Fo.expConfig={kernelName:Mo.Exp,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=t;if(t.dtype==="int32"){o=t.toFloat();t.dispose()}return r.executeSingleInput(Mo.Exp,o)}};var So=e;try{"default"in e&&(So=e.default)}catch(e){}var ko={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ko,"__esModule",{value:true});ko.expandDimsConfig=void 0;var Oo=So;ko.expandDimsConfig={kernelName:Oo.ExpandDims,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.input;var r=e.backend;var o=e.attrs.dim;var n=(0,Oo.scalar)(o,"int32");var a=r.executeSingleOutput(Oo.ExpandDims,[],[t,n]);n.dispose();return a}};var _o=e;try{"default"in e&&(_o=e.default)}catch(e){}var No={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(No,"__esModule",{value:true});No.expm1Config=void 0;var Ao=_o;No.expm1Config={kernelName:Ao.Expm1,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Ao.Expm1,t)}};var Bo=e;try{"default"in e&&(Bo=e.default)}catch(e){}var Co={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Co,"__esModule",{value:true});Co.FFTConfig=void 0;var Io=Bo;var Lo=N;Co.FFTConfig={kernelName:Io.FFT,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.input;var r=e.backend;var o=[(0,Lo.createTensorsTypeOpAttr)("Tcomplex",t.dtype)];return r.executeSingleOutput(Io.FFT,o,[t])}};var Ro=e;try{"default"in e&&(Ro=e.default)}catch(e){}var Po={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Po,"__esModule",{value:true});Po.fillConfig=void 0;var Vo=Ro;Po.fillConfig={kernelName:Vo.Fill,backendName:"tensorflow",kernelFunc:function(e){var t=e.backend;var r=e.attrs,o=r.shape,n=r.value;var a=e.attrs.dtype;a==null&&(a=typeof n==="number"?"float32":"string");var i=(0,Vo.tensor1d)(o,"int32");var s=(0,Vo.scalar)(n,a);var l=[{name:"T",type:t.binding.TF_ATTR_TYPE,value:t.getDTypeInteger(a)},{name:"index_type",type:t.binding.TF_ATTR_TYPE,value:t.binding.TF_INT32}];var p=t.executeSingleOutput(Vo.Fill,l,[i,s]);i.dispose();s.dispose();return p}};var xo=a;try{"default"in a&&(xo=a.default)}catch(e){}var Wo={};
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
 */Object.defineProperty(Wo,"__esModule",{value:true});Wo.flipLeftRightConfig=void 0;var Eo=xo;var Go=N;Wo.flipLeftRightConfig={kernelName:Eo.FlipLeftRight,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend;var o=r;var n=t.image;var a=[(0,Go.createTensorsTypeOpAttr)("Tidx","int32"),(0,Go.createTensorsTypeOpAttr)("T",n.dtype)];var i=Eo.util.parseAxisParam([2],n.shape);var s=(0,Eo.tensor1d)(i,"int32");var l=o.executeSingleOutput("ReverseV2",a,[n,s]);s.dispose();return l}};var jo=e;try{"default"in e&&(jo=e.default)}catch(e){}var zo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(zo,"__esModule",{value:true});zo.floorConfig=void 0;var Ho=jo;zo.floorConfig={kernelName:Ho.Floor,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Ho.Floor,t)}};var Uo=e;try{"default"in e&&(Uo=e.default)}catch(e){}var Jo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Jo,"__esModule",{value:true});Jo.floorDivConfig=void 0;var qo=Uo;var Ko=N;Jo.floorDivConfig={kernelName:qo.FloorDiv,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Ko.createTensorsTypeOpAttr)("T",qo.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(qo.FloorDiv,a,[r,o])}};var $o=e;try{"default"in e&&($o=e.default)}catch(e){}var Yo={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Yo,"__esModule",{value:true});Yo.fusedBatchNormConfig=void 0;var Xo=$o;var Qo=N;Yo.fusedBatchNormConfig={kernelName:Xo.FusedBatchNorm,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.mean,n=t.variance;var a=e.inputs,i=a.scale,s=a.offset;var l=e.backend;var p=e.attrs.varianceEpsilon;return(0,Xo.tidy)((function(){if(o.rank>1){var e=(0,Xo.rsqrt)((0,Xo.add)(n,(0,Xo.scalar)(p)));i!=null&&(e=(0,Xo.mul)(e,i));var t=(0,Xo.mul)((0,Xo.sub)(r,o),e);return s!=null?(0,Xo.add)(t,s):t}var a="NHWC";var u=r.shape[3];var f=[(0,Qo.createTensorsTypeOpAttr)("T",r.dtype),{name:"epsilon",type:l.binding.TF_ATTR_FLOAT,value:p},{name:"data_format",type:l.binding.TF_ATTR_STRING,value:a},{name:"is_training",type:l.binding.TF_ATTR_BOOL,value:false}];var d=5;i==null&&(i=(0,Xo.fill)([u],1));s==null&&(s=(0,Xo.fill)([u],0));return l.executeMultipleOutputs(Xo.FusedBatchNorm,f,[r,i,s,o,n],d)[0]}))}};var Zo=e;try{"default"in e&&(Zo=e.default)}catch(e){}var en={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(en,"__esModule",{value:true});en.fusedConv2DConfig=void 0;var tn=Zo;var rn=Vt;en.fusedConv2DConfig={kernelName:tn.FusedConv2D,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.filter,n=t.bias,a=t.preluActivationWeights;var i=e.backend;var s=e.attrs,l=s.strides,p=s.pad,u=s.dataFormat,f=s.dilations,d=s.dimRoundingMode,c=s.activation,g=s.leakyreluAlpha;if(u!=="NHWC")throw new Error("Node backend FusedConv2D does not support dataFormat:'"+"".concat(u,"'. Please use 'NHWC'."));var v=tn.backend_util.convertConv2DDataFormat(u);var y=tn.backend_util.computeConv2DInfo(r.shape,o.shape,l,f,p,d,false,v);var h=(0,rn.conv2dImpl)(r,o,y,i);var w=[];if(n!=null){w.push(h);h=(0,tn.add)(h,n)}var m=h;h=i.applyActivation(h,c,a,g);m!==h&&w.push(m);w.forEach((function(e){return e.dispose()}));return h}};var on=e;try{"default"in e&&(on=e.default)}catch(e){}var nn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(nn,"__esModule",{value:true});nn.fusedDepthwiseConv2DConfig=void 0;var an=on;var sn=Ar;nn.fusedDepthwiseConv2DConfig={kernelName:an.FusedDepthwiseConv2D,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.filter,n=t.bias,a=t.preluActivationWeights;var i=e.backend;var s=e.attrs,l=s.strides,p=s.pad,u=s.dilations,f=s.dimRoundingMode,d=s.activation,c=s.leakyreluAlpha;var g=u;g==null&&(g=[1,1]);var v=an.backend_util.computeConv2DInfo(r.shape,o.shape,l,g,p,f,true);var y=(0,sn.depthwiseConv2dNativeImpl)(r,o,v,i);var h=[];if(n!=null){h.push(y);y=(0,an.add)(y,n)}var w=y;y=i.applyActivation(y,d,a,c);w!==y&&h.push(w);h.forEach((function(e){return e.dispose()}));return y}};var ln=e;try{"default"in e&&(ln=e.default)}catch(e){}var pn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(pn,"__esModule",{value:true});pn.gatherNdConfig=void 0;var un=ln;var fn=N;pn.gatherNdConfig={kernelName:un.GatherNd,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.params,o=t.indices;var n=e.backend;var a=[(0,fn.createTensorsTypeOpAttr)("Tparams",r.dtype),(0,fn.createTensorsTypeOpAttr)("Tindices","int32")];return n.executeSingleOutput(un.GatherNd,a,[r,o])}};var dn=e;try{"default"in e&&(dn=e.default)}catch(e){}var cn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(cn,"__esModule",{value:true});cn.gatherV2Config=void 0;var gn=dn;var vn=N;cn.gatherV2Config={kernelName:gn.GatherV2,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.indices;var n=e.backend;var a=e.attrs,i=a.axis,s=a.batchDims;var l=n.readSync(o.dataId);var p=r.shape[i];var _loop_1=function(e){var t=l[e];gn.util.assert(t<=p-1&&t>=0,(function(){return"GatherV2: the index value ".concat(t," is not in [0, ").concat(p-1,"]")}))};for(var u=0;u<l.length;++u)_loop_1(u);gn.backend_util.segment_util.collectGatherOpShapeInfo(r,o,i,s);var f=(0,gn.scalar)(i,"int32");var d=[{name:"batch_dims",type:n.binding.TF_ATTR_INT,value:s},(0,vn.createTensorsTypeOpAttr)("Tparams",r.dtype),(0,vn.createTensorsTypeOpAttr)("Tindices",o.dtype),(0,vn.createTensorsTypeOpAttr)("Taxis","int32")];var c=n.executeSingleOutput(gn.GatherV2,d,[r,o,f]);f.dispose();return c}};var yn=e;try{"default"in e&&(yn=e.default)}catch(e){}var hn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(hn,"__esModule",{value:true});hn.greaterConfig=void 0;var wn=yn;var mn=N;hn.greaterConfig={kernelName:wn.Greater,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,mn.createTensorsTypeOpAttr)("T",wn.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(wn.Greater,a,[r,o])}};var Tn=e;try{"default"in e&&(Tn=e.default)}catch(e){}var bn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(bn,"__esModule",{value:true});bn.greaterEqualConfig=void 0;var Dn=Tn;var Fn=N;bn.greaterEqualConfig={kernelName:Dn.GreaterEqual,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Fn.createTensorsTypeOpAttr)("T",Dn.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(Dn.GreaterEqual,a,[r,o])}};var Mn=e;try{"default"in e&&(Mn=e.default)}catch(e){}var Sn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Sn,"__esModule",{value:true});Sn.identityConfig=void 0;var kn=Mn;Sn.identityConfig={kernelName:kn.Identity,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;e.backend.incRef(t.dataId);return{dataId:t.dataId,shape:t.shape,dtype:t.dtype}}};var On=e;try{"default"in e&&(On=e.default)}catch(e){}var _n={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(_n,"__esModule",{value:true});_n.IFFTConfig=void 0;var Nn=On;var An=N;_n.IFFTConfig={kernelName:Nn.IFFT,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.input;var r=e.backend;var o=[(0,An.createTensorsTypeOpAttr)("Tcomplex",t.dtype)];return r.executeSingleOutput(Nn.IFFT,o,[t])}};var Bn=e;try{"default"in e&&(Bn=e.default)}catch(e){}var Cn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Cn,"__esModule",{value:true});Cn.imagConfig=void 0;var In=Bn;Cn.imagConfig={kernelName:In.Imag,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.input;var r=e.backend;var o=[{name:"T",type:r.binding.TF_ATTR_TYPE,value:r.binding.TF_COMPLEX64},{name:"Tout",type:r.binding.TF_ATTR_TYPE,value:r.binding.TF_FLOAT}];var n=[t];return r.executeSingleOutput(In.Imag,o,n)}};var Ln=e;try{"default"in e&&(Ln=e.default)}catch(e){}var Rn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Rn,"__esModule",{value:true});Rn.isFiniteConfig=void 0;var Pn=Ln;Rn.isFiniteConfig={kernelName:Pn.IsFinite,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Pn.IsFinite,t)}};var Vn=e;try{"default"in e&&(Vn=e.default)}catch(e){}var xn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(xn,"__esModule",{value:true});xn.isInfConfig=void 0;var Wn=Vn;xn.isInfConfig={kernelName:Wn.IsInf,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Wn.IsInf,t)}};var En=e;try{"default"in e&&(En=e.default)}catch(e){}var Gn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Gn,"__esModule",{value:true});Gn.isNanConfig=void 0;var jn=En;Gn.isNanConfig={kernelName:jn.IsNan,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(jn.IsNan,t)}};var zn=e;try{"default"in e&&(zn=e.default)}catch(e){}var Hn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Hn,"__esModule",{value:true});Hn.leakyReluConfig=void 0;var Un=zn;var Jn=N;Hn.leakyReluConfig={kernelName:Un.LeakyRelu,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs;var r=e.attrs;var o=e.backend;var n=t.x;var a=r.alpha;var i=[{name:"alpha",type:o.binding.TF_ATTR_FLOAT,value:a},(0,Jn.createTensorsTypeOpAttr)("T",n.dtype)];return o.executeSingleOutput(Un.LeakyRelu,i,[n])}};var qn=e;try{"default"in e&&(qn=e.default)}catch(e){}var Kn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Kn,"__esModule",{value:true});Kn.lessConfig=void 0;var $n=qn;var Yn=N;Kn.lessConfig={kernelName:$n.Less,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Yn.createTensorsTypeOpAttr)("T",$n.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput($n.Less,a,[r,o])}};var Xn=e;try{"default"in e&&(Xn=e.default)}catch(e){}var Qn={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Qn,"__esModule",{value:true});Qn.lessEqualConfig=void 0;var Zn=Xn;var ea=N;Qn.lessEqualConfig={kernelName:Zn.LessEqual,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,ea.createTensorsTypeOpAttr)("T",Zn.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(Zn.LessEqual,a,[r,o])}};var ta=e;try{"default"in e&&(ta=e.default)}catch(e){}var ra={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ra,"__esModule",{value:true});ra.linSpaceConfig=void 0;var oa=ta;var na=N;ra.linSpaceConfig={kernelName:oa.LinSpace,backendName:"tensorflow",kernelFunc:function(e){var t=e.backend;var r=e.attrs,o=r.start,n=r.stop,a=r.num;var i=[(0,na.createTensorsTypeOpAttr)("T","float32"),(0,na.createTensorsTypeOpAttr)("Tidx","int32")];return(0,oa.tidy)((function(){var e=[(0,oa.scalar)(o,"float32"),(0,oa.scalar)(n,"float32"),(0,oa.scalar)(a,"int32")];return t.executeSingleOutput(oa.LinSpace,i,e)}))}};var aa=e;try{"default"in e&&(aa=e.default)}catch(e){}var ia={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ia,"__esModule",{value:true});ia.logConfig=void 0;var sa=aa;ia.logConfig={kernelName:sa.Log,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(sa.Log,t)}};var la=e;try{"default"in e&&(la=e.default)}catch(e){}var pa={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(pa,"__esModule",{value:true});pa.log1pConfig=void 0;var ua=la;pa.log1pConfig={kernelName:ua.Log1p,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(ua.Log1p,t)}};var fa=e;try{"default"in e&&(fa=e.default)}catch(e){}var da={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(da,"__esModule",{value:true});da.logicalAndConfig=void 0;var ca=fa;da.logicalAndConfig={kernelName:ca.LogicalAnd,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;return n.executeSingleOutput(ca.LogicalAnd,[],[r,o])}};var ga=e;try{"default"in e&&(ga=e.default)}catch(e){}var va={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(va,"__esModule",{value:true});va.logicalNotConfig=void 0;var ya=ga;va.logicalNotConfig={kernelName:ya.LogicalNot,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleOutput(ya.LogicalNot,[],[t])}};var ha=e;try{"default"in e&&(ha=e.default)}catch(e){}var wa={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(wa,"__esModule",{value:true});wa.logicalOrConfig=void 0;var ma=ha;wa.logicalOrConfig={kernelName:ma.LogicalOr,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;return n.executeSingleOutput(ma.LogicalOr,[],[r,o])}};var Ta=e;try{"default"in e&&(Ta=e.default)}catch(e){}var ba={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ba,"__esModule",{value:true});ba.LRNConfig=void 0;var Da=Ta;var Fa=N;ba.LRNConfig={kernelName:Da.LRN,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.depthRadius,a=o.bias,i=o.alpha,s=o.beta;var l=[(0,Fa.createTensorsTypeOpAttr)("T",t.dtype),{name:"depth_radius",type:r.binding.TF_ATTR_INT,value:n},{name:"bias",type:r.binding.TF_ATTR_FLOAT,value:a},{name:"alpha",type:r.binding.TF_ATTR_FLOAT,value:i},{name:"beta",type:r.binding.TF_ATTR_FLOAT,value:s}];return r.executeSingleOutput(Da.LRN,l,[t])}};var Ma=e;try{"default"in e&&(Ma=e.default)}catch(e){}var Sa={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Sa,"__esModule",{value:true});Sa.LRNGradConfig=void 0;var ka=Ma;var Oa=N;Sa.LRNGradConfig={kernelName:ka.LRNGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.y,n=t.dy;var a=e.backend;var i=e.attrs,s=i.depthRadius,l=i.bias,p=i.alpha,u=i.beta;var f=[(0,Oa.createTensorsTypeOpAttr)("T",n.dtype),{name:"depth_radius",type:a.binding.TF_ATTR_INT,value:s},{name:"bias",type:a.binding.TF_ATTR_FLOAT,value:l},{name:"alpha",type:a.binding.TF_ATTR_FLOAT,value:p},{name:"beta",type:a.binding.TF_ATTR_FLOAT,value:u}];return a.executeSingleOutput(ka.LRNGrad,f,[n,r,o])}};var _a=e;try{"default"in e&&(_a=e.default)}catch(e){}var Na={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Na,"__esModule",{value:true});Na.maxConfig=void 0;var Aa=_a;Na.maxConfig={kernelName:Aa.Max,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.reductionIndices,a=o.keepDims;var i=Aa.util.parseAxisParam(n,t.shape);var s=(0,Aa.tensor1d)(i,"int32");var l=r.executeSingleOutput(Aa.Max,r.createReductionOpAttrs(t,a),[t,s]);s.dispose();return l}};var Ba=e;try{"default"in e&&(Ba=e.default)}catch(e){}var Ca={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ca,"__esModule",{value:true});Ca.maximumConfig=void 0;var Ia=Ba;var La=N;Ca.maximumConfig={kernelName:Ia.Maximum,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,La.createTensorsTypeOpAttr)("T",Ia.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(Ia.Maximum,a,[r,o])}};var Ra=e;try{"default"in e&&(Ra=e.default)}catch(e){}var Pa={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Pa,"__esModule",{value:true});Pa.maxPoolConfig=void 0;var Va=Ra;var xa=N;Pa.maxPoolConfig={kernelName:Va.MaxPool,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.filterSize,a=o.strides,i=o.pad,s=o.dimRoundingMode;var l=Va.backend_util.computePool2DInfo(t.shape,n,a,1,i,s);if(l.padInfo.type!=="VALID"&&l.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(l.padInfo.type));var p=[1,l.filterHeight,l.filterWidth,1];var u=[1,l.strideHeight,l.strideWidth,1];var f=l.padInfo.type;var d=l.dataFormat==="channelsLast"?"NHWC":"NCHW";var c=[(0,xa.createTensorsTypeOpAttr)("T",t.dtype),{name:"ksize",type:r.binding.TF_ATTR_INT,value:p},{name:"strides",type:r.binding.TF_ATTR_INT,value:u},{name:"padding",type:r.binding.TF_ATTR_STRING,value:f},{name:"data_format",type:r.binding.TF_ATTR_STRING,value:d}];return r.executeSingleOutput(Va.MaxPool,c,[t])}};var Wa=e;try{"default"in e&&(Wa=e.default)}catch(e){}var Ea={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ea,"__esModule",{value:true});Ea.maxPool3DConfig=void 0;var Ga=Wa;var ja=N;Ea.maxPool3DConfig={kernelName:Ga.MaxPool3D,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.filterSize,a=o.strides,i=o.pad,s=o.dataFormat,l=o.dimRoundingMode;var p=Ga.backend_util.computePool3DInfo(t.shape,n,a,1,i,l,s);if(p.padInfo.type!=="VALID"&&p.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding was ".concat(p.padInfo.type));var u=[1,p.filterDepth,p.filterHeight,p.filterWidth,1];var f=[1,p.strideDepth,p.strideHeight,p.strideWidth,1];var d=p.padInfo.type;var c=p.dataFormat==="channelsLast"?"NDHWC":"NCDHW";var g=[(0,ja.createTensorsTypeOpAttr)("T",t.dtype),{name:"ksize",type:r.binding.TF_ATTR_INT,value:u},{name:"strides",type:r.binding.TF_ATTR_INT,value:f},{name:"padding",type:r.binding.TF_ATTR_STRING,value:d},{name:"data_format",type:r.binding.TF_ATTR_STRING,value:c}];return r.executeSingleOutput(Ga.MaxPool3D,g,[t])}};var za=e;try{"default"in e&&(za=e.default)}catch(e){}var Ha={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ha,"__esModule",{value:true});Ha.maxPool3DGradConfig=void 0;var Ua=za;var Ja=N;Ha.maxPool3DGradConfig={kernelName:Ua.MaxPool3DGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.input,n=t.output;var a=e.backend;var i=e.attrs,s=i.filterSize,l=i.strides,p=i.pad,u=i.dimRoundingMode;var f=Ua.backend_util.computePool3DInfo(o.shape,s,l,1,p,u);if(f.padInfo.type!=="VALID"&&f.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding type was ".concat(f.padInfo.type));var d=[1,f.filterDepth,f.filterHeight,f.filterWidth,1];var c=[1,f.strideDepth,f.strideHeight,f.strideWidth,1];var g=f.padInfo.type;var v=f.dataFormat==="channelsLast"?"NDHWC":"NCDHW";var y=[(0,Ja.createTensorsTypeOpAttr)("T",o.dtype),{name:"ksize",type:a.binding.TF_ATTR_INT,value:d},{name:"strides",type:a.binding.TF_ATTR_INT,value:c},{name:"padding",type:a.binding.TF_ATTR_STRING,value:g},{name:"data_format",type:a.binding.TF_ATTR_STRING,value:v}];return a.executeSingleOutput(Ua.MaxPool3DGrad,y,[o,n,r])}};var qa=e;try{"default"in e&&(qa=e.default)}catch(e){}var Ka={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ka,"__esModule",{value:true});Ka.maxPoolGradConfig=void 0;var $a=qa;var Ya=N;Ka.maxPoolGradConfig={kernelName:$a.MaxPoolGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.dy,o=t.input,n=t.output;var a=e.backend;var i=e.attrs,s=i.filterSize,l=i.strides,p=i.pad,u=i.dimRoundingMode;var f=$a.backend_util.computePool2DInfo(o.shape,s,l,1,p,u);if(f.padInfo.type!=="VALID"&&f.padInfo.type!=="SAME")throw new Error("TF Backend supports only 'valid' and 'same' padding "+"while padding type was ".concat(f.padInfo.type));var d=[1,f.filterHeight,f.filterWidth,1];var c=[1,f.strideHeight,f.strideWidth,1];var g=f.padInfo.type;var v=f.dataFormat==="channelsLast"?"NHWC":"NCHW";var y=[(0,Ya.createTensorsTypeOpAttr)("T",o.dtype),{name:"ksize",type:a.binding.TF_ATTR_INT,value:d},{name:"strides",type:a.binding.TF_ATTR_INT,value:c},{name:"padding",type:a.binding.TF_ATTR_STRING,value:g},{name:"data_format",type:a.binding.TF_ATTR_STRING,value:v}];return a.executeSingleOutput($a.MaxPoolGrad,y,[o,n,r])}};var Xa=e;try{"default"in e&&(Xa=e.default)}catch(e){}var Qa={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Qa,"__esModule",{value:true});Qa.meanConfig=void 0;var Za=Xa;Qa.meanConfig={kernelName:Za.Mean,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.keepDims;var i=Za.util.parseAxisParam(n,t.shape);var s=(0,Za.tensor1d)(i,"int32");var l=(0,Za.cast)(t,"float32");var p=r.executeSingleOutput(Za.Mean,r.createReductionOpAttrs(t,a),[l,s]);l.dispose();s.dispose();return p}};var ei=e;try{"default"in e&&(ei=e.default)}catch(e){}var ti={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ti,"__esModule",{value:true});ti.minConfig=void 0;var ri=ei;ti.minConfig={kernelName:ri.Min,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.keepDims;var i=ri.util.parseAxisParam(n,t.shape);var s=(0,ri.tensor1d)(i,"int32");var l=r.executeSingleOutput(ri.Min,r.createReductionOpAttrs(t,a),[t,s]);s.dispose();return l}};var oi=e;try{"default"in e&&(oi=e.default)}catch(e){}var ni={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ni,"__esModule",{value:true});ni.minimumConfig=void 0;var ai=oi;var ii=N;ni.minimumConfig={kernelName:ai.Minimum,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,ii.createTensorsTypeOpAttr)("T",ai.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(ai.Minimum,a,[r,o])}};var si=e;try{"default"in e&&(si=e.default)}catch(e){}var li={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(li,"__esModule",{value:true});li.mirrorPadConfig=void 0;var pi=si;var ui=N;li.mirrorPadConfig={kernelName:pi.MirrorPad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=t.x;var a=o,i=a.paddings,s=a.mode;var l=r;var p=(0,pi.tensor2d)(i,[i.length,2],"int32");var u=[(0,ui.createTensorsTypeOpAttr)("T",n.dtype),(0,ui.createTensorsTypeOpAttr)("Tpaddings",p.dtype),{name:"mode",type:l.binding.TF_ATTR_STRING,value:s.toUpperCase()}];var f=l.executeSingleOutput("MirrorPad",u,[n,p]);p.dispose();return f}};var fi=e;try{"default"in e&&(fi=e.default)}catch(e){}var di={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(di,"__esModule",{value:true});di.modConfig=void 0;var ci=fi;var gi=N;di.modConfig={kernelName:ci.Mod,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,gi.createTensorsTypeOpAttr)("T",r.dtype)];return n.executeSingleOutput("FloorMod",a,[r,o])}};var vi=e;try{"default"in e&&(vi=e.default)}catch(e){}var yi={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(yi,"__esModule",{value:true});yi.multinomialConfig=void 0;var hi=vi;var wi=N;yi.multinomialConfig={kernelName:hi.Multinomial,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.logits;var r=e.backend;var o=e.attrs,n=o.numSamples,a=o.seed,i=o.normalized;if(i)throw new Error("TF Node backend does not support normalized logits passed to multinomial");var s=[(0,wi.createTensorsTypeOpAttr)("T",t.dtype),(0,wi.createTensorsTypeOpAttr)("output_dtype","int32"),{name:"seed",type:r.binding.TF_ATTR_INT,value:a},{name:"seed2",type:r.binding.TF_ATTR_INT,value:a*a}];var l=(0,hi.scalar)(n,"int32");var p=r.executeSingleOutput(hi.Multinomial,s,[t,l]);l.dispose();return p}};var mi=e;try{"default"in e&&(mi=e.default)}catch(e){}var Ti={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ti,"__esModule",{value:true});Ti.multiplyConfig=void 0;var bi=mi;var Di=N;Ti.multiplyConfig={kernelName:bi.Multiply,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Di.createTensorsTypeOpAttr)("T",bi.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput("Mul",a,[r,o])}};var Fi=e;try{"default"in e&&(Fi=e.default)}catch(e){}var Mi={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Mi,"__esModule",{value:true});Mi.negConfig=void 0;var Si=Fi;Mi.negConfig={kernelName:Si.Neg,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Si.Neg,t)}};var ki=e;try{"default"in e&&(ki=e.default)}catch(e){}var Oi={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Oi,"__esModule",{value:true});Oi.nonMaxSuppressionV3Config=void 0;var _i=ki;var Ni=N;Oi.nonMaxSuppressionV3Config={kernelName:_i.NonMaxSuppressionV3,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.boxes,o=t.scores;var n=e.backend;var a=e.attrs,i=a.maxOutputSize,s=a.iouThreshold,l=a.scoreThreshold;var p=[(0,Ni.createTensorsTypeOpAttr)("T",r.dtype)];var u=(0,_i.scalar)(i,"int32");var f=(0,_i.scalar)(s);var d=(0,_i.scalar)(l);var c=n.executeSingleOutput(_i.NonMaxSuppressionV3,p,[r,o,u,f,d]);u.dispose();f.dispose();d.dispose();return c}};var Ai=e;try{"default"in e&&(Ai=e.default)}catch(e){}var Bi={};
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
 */Object.defineProperty(Bi,"__esModule",{value:true});Bi.nonMaxSuppressionV4Config=void 0;var Ci=Ai;var Ii=N;Bi.nonMaxSuppressionV4Config={kernelName:Ci.NonMaxSuppressionV4,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=t,a=n.boxes,i=n.scores;var s=o,l=s.maxOutputSize,p=s.iouThreshold,u=s.scoreThreshold,f=s.padToMaxOutputSize;var d=(0,Ci.scalar)(l,"int32");var c=(0,Ci.scalar)(p,"float32");var g=(0,Ci.scalar)(u,"float32");var v=r;var y=[(0,Ii.createTensorsTypeOpAttr)("T",a.dtype),(0,Ii.createTensorsTypeOpAttr)("T_threshold","float32"),{name:"pad_to_max_output_size",type:v.binding.TF_ATTR_BOOL,value:f}];var h=v.executeMultipleOutputs("NonMaxSuppressionV4",y,[a,i,d,c,g],2),w=h[0],m=h[1];d.dispose();c.dispose();g.dispose();return[w,m]}};var Li=e;try{"default"in e&&(Li=e.default)}catch(e){}var Ri={};
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
 */Object.defineProperty(Ri,"__esModule",{value:true});Ri.nonMaxSuppressionV5Config=void 0;var Pi=Li;var Vi=N;Ri.nonMaxSuppressionV5Config={kernelName:"NonMaxSuppressionV5",backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=t,a=n.boxes,i=n.scores;var s=o,l=s.maxOutputSize,p=s.iouThreshold,u=s.scoreThreshold,f=s.softNmsSigma;var d=(0,Pi.scalar)(l,"int32");var c=(0,Pi.scalar)(p);var g=(0,Pi.scalar)(u);var v=(0,Pi.scalar)(f);var y=[(0,Vi.createTensorsTypeOpAttr)("T",a.dtype)];var h=r;var w=h.executeMultipleOutputs("NonMaxSuppressionV5",y,[a,i,d,c,g,v],3),m=w[0],T=w[1],b=w[2];d.dispose();c.dispose();g.dispose();v.dispose();b.dispose();return[m,T]}};var xi=e;try{"default"in e&&(xi=e.default)}catch(e){}var Wi={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Wi,"__esModule",{value:true});Wi.notEqualConfig=void 0;var Ei=xi;var Gi=N;Wi.notEqualConfig={kernelName:Ei.NotEqual,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Gi.createTensorsTypeOpAttr)("T",Ei.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(Ei.NotEqual,a,[r,o])}};var ji=e;try{"default"in e&&(ji=e.default)}catch(e){}var zi={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(zi,"__esModule",{value:true});zi.oneHotConfig=void 0;var Hi=ji;var Ui=N;zi.oneHotConfig={kernelName:Hi.OneHot,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.indices;var r=e.backend;var o=e.attrs,n=o.dtype,a=o.depth,i=o.onValue,s=o.offValue;var l=(0,Hi.scalar)(a,"int32");var p=(0,Hi.scalar)(i,n);var u=(0,Hi.scalar)(s,n);var f=[{name:"axis",type:r.binding.TF_ATTR_INT,value:-1},(0,Ui.createTensorsTypeOpAttr)("T",n),(0,Ui.createTensorsTypeOpAttr)("TI",t.dtype)];var d=r.executeSingleOutput(Hi.OneHot,f,[t,l,p,u]);l.dispose();p.dispose();u.dispose();return d}};var Ji=e;try{"default"in e&&(Ji=e.default)}catch(e){}var qi={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(qi,"__esModule",{value:true});qi.onesLikeConfig=void 0;var Ki=Ji;qi.onesLikeConfig={kernelName:Ki.OnesLike,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=[{name:"T",type:r.binding.TF_ATTR_TYPE,value:r.getDTypeInteger(t.dtype)}];return r.executeSingleOutput(Ki.OnesLike,o,[t])}};var $i=e;try{"default"in e&&($i=e.default)}catch(e){}var Yi={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Yi,"__esModule",{value:true});Yi.packConfig=Yi.pack=void 0;var Xi=$i;var Qi=N;function pack(e){var t=e.inputs,r=e.backend,o=e.attrs;var n=o.axis;var a=[{name:"N",type:r.binding.TF_ATTR_INT,value:t.length},(0,Qi.createTensorsTypeOpAttr)("T",t),{name:"axis",type:r.binding.TF_ATTR_INT,value:n}];var i=r.executeSingleOutput(Xi.Pack,a,t);return i}Yi.pack=pack;Yi.packConfig={kernelName:Xi.Pack,backendName:"tensorflow",kernelFunc:pack};var Zi=e;try{"default"in e&&(Zi=e.default)}catch(e){}var es={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(es,"__esModule",{value:true});es.padV2Config=void 0;var ts=Zi;var rs=N;es.padV2Config={kernelName:ts.PadV2,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.paddings,a=o.constantValue;var i=(0,ts.tensor2d)(n,[n.length,2],"int32");var s=(0,ts.scalar)(a,t.dtype);var l=[(0,rs.createTensorsTypeOpAttr)("T",t.dtype),(0,rs.createTensorsTypeOpAttr)("Tpaddings",i.dtype)];var p=r.executeSingleOutput(ts.PadV2,l,[t,i,s]);i.dispose();s.dispose();return p}};var os=e;try{"default"in e&&(os=e.default)}catch(e){}var ns={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ns,"__esModule",{value:true});ns.powConfig=void 0;var as=os;var is=N;ns.powConfig={kernelName:as.Pow,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=as.backend_util.upcastType(r.dtype,o.dtype);var i=[(0,is.createTensorsTypeOpAttr)("T",a)];return(0,as.tidy)((function(){return n.executeSingleOutput(as.Pow,i,[(0,as.cast)(r,a),(0,as.cast)(o,a)])}))}};var ss=e;try{"default"in e&&(ss=e.default)}catch(e){}var ls={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ls,"__esModule",{value:true});ls.preluConfig=void 0;var ps=ss;ls.preluConfig={kernelName:ps.Prelu,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs;var r=t.x;var o=t.alpha;return(0,ps.tidy)((function(){var e=(0,ps.relu)(r);var t=o.mul(r.sub((0,ps.abs)(r))).mul(.5);return e.add(t)}))}};var us=e;try{"default"in e&&(us=e.default)}catch(e){}var fs={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(fs,"__esModule",{value:true});fs.prodConfig=void 0;var ds=us;var cs=N;fs.prodConfig={kernelName:ds.Prod,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.keepDims;var i=ds.util.parseAxisParam(n,t.shape);var s=(0,ds.tensor1d)(i,"int32");var l=[{name:"keep_dims",type:r.binding.TF_ATTR_BOOL,value:a},(0,cs.createTensorsTypeOpAttr)("T",t.dtype),(0,cs.createTensorsTypeOpAttr)("Tidx","int32")];var p=r.executeSingleOutput(ds.Prod,l,[t,s]);s.dispose();return p}};var gs=e;try{"default"in e&&(gs=e.default)}catch(e){}var vs={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(vs,"__esModule",{value:true});vs.rangeConfig=void 0;var ys=gs;var hs=N;vs.rangeConfig={kernelName:ys.Range,backendName:"tensorflow",kernelFunc:function(e){var t=e.backend;var r=e.attrs,o=r.start,n=r.stop,a=r.dtype;var i=e.attrs.step;var s=o===n;var l=o<n&&i<0;var p=n<o&&i>1;if(s||l||p)return(0,ys.zeros)([0],a);n<o&&i===1&&(i=-1);var u=[(0,hs.createTensorsTypeOpAttr)("Tidx",a)];var f=(0,ys.scalar)(o,a);var d=(0,ys.scalar)(n,a);var c=(0,ys.scalar)(i,a);var g=t.executeSingleOutput(ys.Range,u,[f,d,c]);f.dispose();d.dispose();c.dispose();return g}};var ws=e;try{"default"in e&&(ws=e.default)}catch(e){}var ms={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ms,"__esModule",{value:true});ms.realConfig=void 0;var Ts=ws;var bs=N;ms.realConfig={kernelName:Ts.Real,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.input;var r=e.backend;var o=[(0,bs.createTensorsTypeOpAttr)("T",t),{name:"Tout",type:r.binding.TF_ATTR_TYPE,value:r.binding.TF_FLOAT}];var n=[t];return r.executeSingleOutput(Ts.Real,o,n)}};var Ds=e;try{"default"in e&&(Ds=e.default)}catch(e){}var Fs={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Fs,"__esModule",{value:true});Fs.realDivConfig=void 0;var Ms=Ds;var Ss=N;Fs.realDivConfig={kernelName:Ms.RealDiv,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Ss.createTensorsTypeOpAttr)("T",Ms.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(Ms.RealDiv,a,[r,o])}};var ks=e;try{"default"in e&&(ks=e.default)}catch(e){}var Os={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Os,"__esModule",{value:true});Os.reciprocalConfig=void 0;var _s=ks;Os.reciprocalConfig={kernelName:_s.Reciprocal,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(_s.Reciprocal,t)}};var Ns=e;try{"default"in e&&(Ns=e.default)}catch(e){}var As={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(As,"__esModule",{value:true});As.reluConfig=void 0;var Bs=Ns;As.reluConfig={kernelName:Bs.Relu,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Bs.Relu,t)}};var Cs=e;try{"default"in e&&(Cs=e.default)}catch(e){}var Is={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Is,"__esModule",{value:true});Is.relu6Config=void 0;var Ls=Cs;Is.relu6Config={kernelName:Ls.Relu6,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Ls.Relu6,t)}};var Rs=e;try{"default"in e&&(Rs=e.default)}catch(e){}var Ps={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ps,"__esModule",{value:true});Ps.reshapeConfig=void 0;var Vs=Rs;var xs=N;Ps.reshapeConfig={kernelName:Vs.Reshape,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.shape;var n=(0,Vs.tensor1d)(o,"int32");var a=[(0,xs.createTensorsTypeOpAttr)("T",t.dtype),(0,xs.createTensorsTypeOpAttr)("Tshape",n.dtype)];var i=r.executeSingleOutput(Vs.Reshape,a,[t,n]);n.dispose();return i}};var Ws=e;try{"default"in e&&(Ws=e.default)}catch(e){}var Es={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Es,"__esModule",{value:true});Es.resizeBilinearConfig=void 0;var Gs=Ws;var js=N;Es.resizeBilinearConfig={kernelName:Gs.ResizeBilinear,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.images;var r=e.backend;var o=e.attrs,n=o.alignCorners,a=o.halfPixelCenters,i=o.size;var s=[(0,js.createTensorsTypeOpAttr)("T",t.dtype),{name:"align_corners",type:r.binding.TF_ATTR_BOOL,value:n},{name:"half_pixel_centers",type:r.binding.TF_ATTR_BOOL,value:a}];var l=i[0],p=i[1];var u=(0,Gs.tensor1d)([l,p],"int32");var f=r.executeSingleOutput(Gs.ResizeBilinear,s,[t,u]);u.dispose();return f}};var zs=e;try{"default"in e&&(zs=e.default)}catch(e){}var Hs={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Hs,"__esModule",{value:true});Hs.resizeBilinearGradConfig=void 0;var Us=zs;var Js=N;Hs.resizeBilinearGradConfig={kernelName:Us.ResizeBilinearGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.images,o=t.dy;var n=e.backend;var a=e.attrs.alignCorners;var i=[(0,Js.createTensorsTypeOpAttr)("T",r.dtype),{name:"align_corners",type:n.binding.TF_ATTR_BOOL,value:a}];return n.executeSingleOutput(Us.ResizeBilinearGrad,i,[o,r])}};var qs=e;try{"default"in e&&(qs=e.default)}catch(e){}var Ks={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ks,"__esModule",{value:true});Ks.resizeNearestNeighborConfig=void 0;var $s=qs;var Ys=N;Ks.resizeNearestNeighborConfig={kernelName:$s.ResizeNearestNeighbor,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.images;var r=e.backend;var o=e.attrs,n=o.alignCorners,a=o.halfPixelCenters,i=o.size;var s=[(0,Ys.createTensorsTypeOpAttr)("T",t.dtype),{name:"align_corners",type:r.binding.TF_ATTR_BOOL,value:n},{name:"half_pixel_centers",type:r.binding.TF_ATTR_BOOL,value:a}];var l=i[0],p=i[1];var u=(0,$s.tensor1d)([l,p],"int32");var f=r.executeSingleOutput($s.ResizeNearestNeighbor,s,[t,u]);u.dispose();return f}};var Xs=e;try{"default"in e&&(Xs=e.default)}catch(e){}var Qs={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Qs,"__esModule",{value:true});Qs.resizeNearestNeighborGradConfig=void 0;var Zs=Xs;var el=N;Qs.resizeNearestNeighborGradConfig={kernelName:Zs.ResizeNearestNeighborGrad,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.images,o=t.dy;var n=e.backend;var a=e.attrs.alignCorners;var i=[(0,el.createTensorsTypeOpAttr)("T",r.dtype),{name:"align_corners",type:n.binding.TF_ATTR_BOOL,value:a}];var s=r.shape,l=s[1],p=s[2];var u=(0,Zs.tensor1d)([l,p],"int32");var f=n.executeSingleOutput(Zs.ResizeNearestNeighborGrad,i,[o,u]);u.dispose();return f}};var tl=e;try{"default"in e&&(tl=e.default)}catch(e){}var rl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(rl,"__esModule",{value:true});rl.reverseConfig=void 0;var ol=tl;var nl=N;rl.reverseConfig={kernelName:ol.Reverse,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.dims;var n=[(0,nl.createTensorsTypeOpAttr)("Tidx","int32"),(0,nl.createTensorsTypeOpAttr)("T",t.dtype)];var a=ol.util.parseAxisParam(o,t.shape);var i=(0,ol.tensor1d)(a,"int32");var s=r.executeSingleOutput("ReverseV2",n,[t,i]);i.dispose();return s}};var al=e;try{"default"in e&&(al=e.default)}catch(e){}var il={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(il,"__esModule",{value:true});il.roundConfig=void 0;var sl=al;il.roundConfig={kernelName:sl.Round,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(sl.Round,t)}};var ll=e;try{"default"in e&&(ll=e.default)}catch(e){}var pl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(pl,"__esModule",{value:true});pl.rsqrtConfig=void 0;var ul=ll;pl.rsqrtConfig={kernelName:ul.Rsqrt,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(ul.Rsqrt,t)}};var fl=e;try{"default"in e&&(fl=e.default)}catch(e){}var dl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(dl,"__esModule",{value:true});dl.scatterNdConfig=void 0;var cl=fl;var gl=N;dl.scatterNdConfig={kernelName:cl.ScatterNd,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.indices,o=t.updates;var n=e.backend;var a=e.attrs.shape;var i=[(0,gl.createTensorsTypeOpAttr)("T",o.dtype),(0,gl.createTensorsTypeOpAttr)("Tindices","int32")];var s=(0,cl.tensor1d)(a,"int32");var l=n.executeSingleOutput(cl.ScatterNd,i,[r,o,s]);s.dispose();return l}};var vl=e;try{"default"in e&&(vl=e.default)}catch(e){}var yl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(yl,"__esModule",{value:true});yl.selectConfig=void 0;var hl=vl;var wl=N;yl.selectConfig={kernelName:hl.Select,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.condition,o=t.t,n=t.e;var a=e.backend;var i=[(0,wl.createTensorsTypeOpAttr)("T",hl.backend_util.upcastType(o.dtype,n.dtype))];return a.executeSingleOutput(hl.Select,i,[r,o,n])}};var ml=e;try{"default"in e&&(ml=e.default)}catch(e){}var Tl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Tl,"__esModule",{value:true});Tl.seluConfig=void 0;var bl=ml;Tl.seluConfig={kernelName:bl.Selu,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(bl.Selu,t)}};var Dl=e;try{"default"in e&&(Dl=e.default)}catch(e){}var Fl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Fl,"__esModule",{value:true});Fl.sigmoidConfig=void 0;var Ml=Dl;Fl.sigmoidConfig={kernelName:Ml.Sigmoid,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Ml.Sigmoid,t)}};var Sl=e;try{"default"in e&&(Sl=e.default)}catch(e){}var kl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(kl,"__esModule",{value:true});kl.signConfig=void 0;var Ol=Sl;kl.signConfig={kernelName:Ol.Sign,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Ol.Sign,t)}};var _l=e;try{"default"in e&&(_l=e.default)}catch(e){}var Nl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Nl,"__esModule",{value:true});Nl.sinConfig=void 0;var Al=_l;Nl.sinConfig={kernelName:Al.Sin,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Al.Sin,t)}};var Bl=e;try{"default"in e&&(Bl=e.default)}catch(e){}var Cl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Cl,"__esModule",{value:true});Cl.sinhConfig=void 0;var Il=Bl;Cl.sinhConfig={kernelName:Il.Sinh,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Il.Sinh,t)}};var Ll=e;try{"default"in e&&(Ll=e.default)}catch(e){}var Rl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Rl,"__esModule",{value:true});Rl.sliceConfig=void 0;var Pl=Ll;var Vl=N;Rl.sliceConfig={kernelName:Pl.Slice,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.begin,a=o.size;var i=[(0,Vl.createTensorsTypeOpAttr)("T",t.dtype),(0,Vl.createTensorsTypeOpAttr)("Index","int32")];var s=Pl.backend_util.slice_util.parseSliceParams(t,n,a),l=s[0],p=s[1];var u=(0,Pl.tensor1d)(l,"int32");var f=(0,Pl.tensor1d)(p,"int32");var d=r.executeSingleOutput(Pl.Slice,i,[t,u,f]);u.dispose();f.dispose();return d}};var xl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(xl,"__esModule",{value:true});xl.softmaxConfig=void 0;var Wl=N;xl.softmaxConfig={kernelName:"Softmax",backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=e.backend;var o=t.logits;var n=[(0,Wl.createTensorsTypeOpAttr)("T",o.dtype)];var a=r;return a.executeSingleOutput("Softmax",n,[o])}};var El=e;try{"default"in e&&(El=e.default)}catch(e){}var Gl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Gl,"__esModule",{value:true});Gl.softplusConfig=void 0;var jl=El;Gl.softplusConfig={kernelName:jl.Softplus,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(jl.Softplus,t)}};var zl=e;try{"default"in e&&(zl=e.default)}catch(e){}var Hl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Hl,"__esModule",{value:true});Hl.spaceToBatchNDConfig=void 0;var Ul=zl;var Jl=N;Hl.spaceToBatchNDConfig={kernelName:Ul.SpaceToBatchND,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.blockShape,a=o.paddings;var i=(0,Ul.tensor1d)(n,"int32");var s=(0,Ul.tensor2d)(a,[a.length,a[0].length],"int32");var l=[(0,Jl.createTensorsTypeOpAttr)("T",t.dtype),(0,Jl.createTensorsTypeOpAttr)("Tblock_shape","int32"),(0,Jl.createTensorsTypeOpAttr)("Tpaddings",s.dtype)];var p=r.executeSingleOutput(Ul.SpaceToBatchND,l,[t,i,s]);i.dispose();s.dispose();return p}};var ql=e;try{"default"in e&&(ql=e.default)}catch(e){}var Kl={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Kl,"__esModule",{value:true});Kl.sparseToDenseConfig=void 0;var $l=ql;var Yl=N;Kl.sparseToDenseConfig={kernelName:$l.SparseToDense,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.sparseIndices,o=t.sparseValues,n=t.defaultValue;var a=e.backend;var i=e.attrs.outputShape;var s=[{name:"validate_indices",type:a.binding.TF_ATTR_BOOL,value:true},(0,Yl.createTensorsTypeOpAttr)("T",o.dtype),(0,Yl.createTensorsTypeOpAttr)("Tindices",r.dtype)];var l=(0,$l.tensor1d)(i,"int32");var p=a.executeSingleOutput($l.SparseToDense,s,[r,l,o,n]);l.dispose();return p}};var Xl=e;try{"default"in e&&(Xl=e.default)}catch(e){}var Ql={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ql,"__esModule",{value:true});Ql.splitVConfig=void 0;var Zl=Xl;var ep=N;Ql.splitVConfig={kernelName:Zl.SplitV,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.numOrSizeSplits,a=o.axis;var i=Zl.util.parseAxisParam(a,t.shape)[0];var s=Zl.backend_util.prepareSplitSize(t,n,i);var l=[{name:"num_split",type:r.binding.TF_ATTR_INT,value:s.length},(0,ep.createTensorsTypeOpAttr)("T",t),{name:"Tlen",type:r.binding.TF_ATTR_TYPE,value:r.binding.TF_INT32}];var p=[t];return(0,Zl.tidy)((function(){p.push((0,Zl.tensor1d)(s,"int32"));p.push((0,Zl.scalar)(i,"int32"));return r.executeMultipleOutputs(Zl.SplitV,l,p,s.length)}))}};var tp=e;try{"default"in e&&(tp=e.default)}catch(e){}var rp={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(rp,"__esModule",{value:true});rp.sqrtConfig=void 0;var op=tp;rp.sqrtConfig={kernelName:op.Sqrt,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(op.Sqrt,t)}};var np=e;try{"default"in e&&(np=e.default)}catch(e){}var ap={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(ap,"__esModule",{value:true});ap.squareConfig=void 0;var ip=np;ap.squareConfig={kernelName:ip.Square,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(ip.Square,t)}};var sp=e;try{"default"in e&&(sp=e.default)}catch(e){}var lp={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(lp,"__esModule",{value:true});lp.squaredDifferenceConfig=void 0;var pp=sp;var up=N;lp.squaredDifferenceConfig={kernelName:pp.SquaredDifference,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,up.createTensorsTypeOpAttr)("T",r.dtype)];return n.executeSingleOutput(pp.SquaredDifference,a,[r,o])}};var fp=e;try{"default"in e&&(fp=e.default)}catch(e){}var dp={};
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
 */Object.defineProperty(dp,"__esModule",{value:true});dp.staticRegexReplaceConfig=void 0;var cp=fp;dp.staticRegexReplaceConfig={kernelName:cp.StaticRegexReplace,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs;var r=e.backend;var o=e.attrs,n=o.pattern,a=o.rewrite,i=o.replaceGlobal;var s=[{name:"pattern",type:r.binding.TF_ATTR_STRING,value:n},{name:"rewrite",type:r.binding.TF_ATTR_STRING,value:a},{name:"replace_global",type:r.binding.TF_ATTR_BOOL,value:i}];var l=[t.x];return r.executeSingleOutput("StaticRegexReplace",s,l)}};var gp=e;try{"default"in e&&(gp=e.default)}catch(e){}var vp={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(vp,"__esModule",{value:true});vp.stepConfig=void 0;var yp=gp;var hp=N;vp.stepConfig={kernelName:yp.Step,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.alpha;var n=t.dtype;return(0,yp.tidy)((function(){var e=(0,yp.isNaN)(t);var a=(0,yp.where)((0,yp.greater)(t,(0,yp.scalar)(0,n)),(0,yp.ones)(t.shape),(0,yp.fill)(t.shape,o,n));var i=[(0,hp.createTensorsTypeOpAttr)("T",yp.backend_util.upcastType(t.dtype,a.dtype))];return r.executeSingleOutput("Select",i,[e,t,a])}))}};var wp=e;try{"default"in e&&(wp=e.default)}catch(e){}var mp={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(mp,"__esModule",{value:true});mp.stridedSliceConfig=void 0;var Tp=wp;var bp=N;mp.stridedSliceConfig={kernelName:Tp.StridedSlice,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.beginMask,a=o.endMask,i=o.ellipsisMask,s=o.newAxisMask,l=o.shrinkAxisMask;var p=e.attrs;var u=p.begin.slice();var f=p.end.slice();var d=p.strides;return(0,Tp.tidy)((function(){var e=(0,Tp.tensor1d)(u,"int32");var o=(0,Tp.tensor1d)(f,"int32");var p=(0,Tp.tensor1d)(d,"int32");var c=[(0,bp.createTensorsTypeOpAttr)("T",t.dtype),(0,bp.createTensorsTypeOpAttr)("Index","int32"),{name:"begin_mask",type:r.binding.TF_ATTR_INT,value:n},{name:"end_mask",type:r.binding.TF_ATTR_INT,value:a},{name:"ellipsis_mask",type:r.binding.TF_ATTR_INT,value:i},{name:"new_axis_mask",type:r.binding.TF_ATTR_INT,value:s},{name:"shrink_axis_mask",type:r.binding.TF_ATTR_INT,value:l}];return r.executeSingleOutput(Tp.StridedSlice,c,[t,e,o,p])}))}};var Dp=e;try{"default"in e&&(Dp=e.default)}catch(e){}var Fp={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Fp,"__esModule",{value:true});Fp.subConfig=void 0;var Mp=Dp;var Sp=N;Fp.subConfig={kernelName:Mp.Sub,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.a,o=t.b;var n=e.backend;var a=[(0,Sp.createTensorsTypeOpAttr)("T",Mp.backend_util.upcastType(r.dtype,o.dtype))];return n.executeSingleOutput(Mp.Sub,a,[r,o])}};var kp=e;try{"default"in e&&(kp=e.default)}catch(e){}var Op={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Op,"__esModule",{value:true});Op.sumConfig=void 0;var _p=kp;Op.sumConfig={kernelName:_p.Sum,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.axis,a=o.keepDims;var i=_p.util.parseAxisParam(n,t.shape);var s=(0,_p.tensor1d)(i,"int32");var l=r.executeSingleOutput(_p.Sum,r.createReductionOpAttrs(t,a),[t,s]);s.dispose();return l}};var Np=e;try{"default"in e&&(Np=e.default)}catch(e){}var Ap={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ap,"__esModule",{value:true});Ap.tanConfig=void 0;var Bp=Np;Ap.tanConfig={kernelName:Bp.Tan,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Bp.Tan,t)}};var Cp=e;try{"default"in e&&(Cp=e.default)}catch(e){}var Ip={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ip,"__esModule",{value:true});Ip.tanhConfig=void 0;var Lp=Cp;Ip.tanhConfig={kernelName:Lp.Tanh,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;return r.executeSingleInput(Lp.Tanh,t)}};var Rp=e;try{"default"in e&&(Rp=e.default)}catch(e){}var Pp={};
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
 */Object.defineProperty(Pp,"__esModule",{value:true});Pp.tensorScatterUpdateConfig=void 0;var Vp=Rp;var xp=N;Pp.tensorScatterUpdateConfig={kernelName:Vp.TensorScatterUpdate,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.tensor,o=t.indices,n=t.updates;var a=e.backend;e.attrs;var i=[(0,xp.createTensorsTypeOpAttr)("T",n.dtype),(0,xp.createTensorsTypeOpAttr)("Tindices","int32")];var s=a.executeSingleOutput(Vp.TensorScatterUpdate,i,[r,o,n]);return s}};var Wp=e;try{"default"in e&&(Wp=e.default)}catch(e){}var Ep={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Ep,"__esModule",{value:true});Ep.tileConfig=void 0;var Gp=Wp;var jp=N;Ep.tileConfig={kernelName:Gp.Tile,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.reps;var n=[(0,jp.createTensorsTypeOpAttr)("T",t.dtype),(0,jp.createTensorsTypeOpAttr)("Tmultiples","int32")];var a=(0,Gp.tensor1d)(o,"int32");var i=r.executeSingleOutput(Gp.Tile,n,[t,a]);a.dispose();return i}};var zp=e;try{"default"in e&&(zp=e.default)}catch(e){}var Hp=t;try{"default"in t&&(Hp=t.default)}catch(e){}var Up={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Up,"__esModule",{value:true});Up.topKConfig=void 0;var Jp=zp;var qp=Hp;var Kp=N;Up.topKConfig={kernelName:Jp.TopK,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs,n=o.k,a=o.sorted;var i=(0,qp.isNullOrUndefined)(n)?1:n;var s=!!(0,qp.isNullOrUndefined)(a)||a;var l=[{name:"sorted",type:r.binding.TF_ATTR_BOOL,value:s},(0,Kp.createTensorsTypeOpAttr)("T",t.dtype)];var p=(0,Jp.scalar)(i,"int32");var u=r.executeMultipleOutputs("TopKV2",l,[t,p],2);p.dispose();return u}};var $p=e;try{"default"in e&&($p=e.default)}catch(e){}var Yp={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(Yp,"__esModule",{value:true});Yp.transposeConfig=void 0;var Xp=$p;var Qp=N;Yp.transposeConfig={kernelName:Xp.Transpose,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.perm;var n=(0,Xp.tensor1d)(o,"int32");var a=[(0,Qp.createTensorsTypeOpAttr)("T",t.dtype),(0,Qp.createTensorsTypeOpAttr)("Tperm","int32")];var i=r.executeSingleOutput(Xp.Transpose,a,[t,n]);n.dispose();return i}};var Zp=e;try{"default"in e&&(Zp=e.default)}catch(e){}var eu={};
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
 */Object.defineProperty(eu,"__esModule",{value:true});eu.uniqueConfig=void 0;var tu=Zp;var ru=N;eu.uniqueConfig={kernelName:tu.Unique,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=e.attrs.axis,n=o===void 0?0:o;var a=(0,tu.tensor1d)([n],"int32");try{var i=[(0,ru.createTensorsTypeOpAttr)("T",t.dtype),(0,ru.createTensorsTypeOpAttr)("Taxis","int32"),(0,ru.createTensorsTypeOpAttr)("out_idx","int32")];var s=[t,a];return r.executeMultipleOutputs("UniqueV2",i,s,2)}finally{a.dispose()}}};var ou=e;try{"default"in e&&(ou=e.default)}catch(e){}var nu={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(nu,"__esModule",{value:true});nu.unpackConfig=void 0;var au=ou;var iu=N;nu.unpackConfig={kernelName:au.Unpack,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.value;var r=e.backend;var o=e.attrs.axis;o<0&&(o+=t.shape.length);if(o>=t.shape.length)throw new Error("Invalid axis supplied: ".concat(o," shape length: ").concat(t.shape.length));var n=t.shape[o];var a=[{name:"num",type:r.binding.TF_ATTR_INT,value:n},(0,iu.createTensorsTypeOpAttr)("T",t.dtype),{name:"axis",type:r.binding.TF_ATTR_INT,value:o}];return r.executeMultipleOutputs(au.Unpack,a,[t],n)}};var su=e;try{"default"in e&&(su=e.default)}catch(e){}var lu={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(lu,"__esModule",{value:true});lu.unsortedSegmentSumConfig=void 0;var pu=su;var uu=N;lu.unsortedSegmentSumConfig={kernelName:pu.UnsortedSegmentSum,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs,r=t.x,o=t.segmentIds;var n=e.backend;var a=e.attrs.numSegments;var i=[(0,uu.createTensorsTypeOpAttr)("T",r.dtype),(0,uu.createTensorsTypeOpAttr)("Tindices","int32"),(0,uu.createTensorsTypeOpAttr)("Tnumsegments","int32")];var s=(0,pu.scalar)(a,"int32");var l=n.executeSingleOutput(pu.UnsortedSegmentSum,i,[r,o,s]);s.dispose();return l}};var fu=e;try{"default"in e&&(fu=e.default)}catch(e){}var du={};
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */Object.defineProperty(du,"__esModule",{value:true});du.zerosLikeConfig=void 0;var cu=fu;du.zerosLikeConfig={kernelName:cu.ZerosLike,backendName:"tensorflow",kernelFunc:function(e){var t=e.inputs.x;var r=e.backend;var o=[{name:"T",type:r.binding.TF_ATTR_TYPE,value:r.getDTypeInteger(t.dtype)}];return r.executeSingleOutput(cu.ZerosLike,o,[t])}};var gu=e;try{"default"in e&&(gu=e.default)}catch(e){}var vu={};Object.defineProperty(vu,"__esModule",{value:true});
/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */var yu=gu;var hu=d;var wu=G;var mu=U;var Tu=K;var bu=X;var Du=te;var Fu=ae;var Mu=pe;var Su=ce;var ku=he;var Ou=be;var _u=Me;var Nu=Oe;var Au=Ae;var Bu=Le;var Cu=Ve;var Iu=Ge;var Lu=Ue;var Ru=$e;var Pu=Ze;var Vu=ot;var xu=st;var Wu=ft;var Eu=vt;var Gu=mt;var ju=Dt;var zu=St;var Hu=Nt;var Uu=It;var Ju=Vt;var qu=jt;var Ku=Jt;var $u=Yt;var Yu=er;var Xu=nr;var Qu=lr;var Zu=fr;var ef=gr;var tf=wr;var rf=Dr;var of=kr;var nf=Ar;var af=Rr;var sf=Wr;var lf=zr;var pf=Jr;var uf=Yr;var ff=eo;var df=no;var cf=lo;var gf=fo;var vf=yo;var yf=To;var hf=Fo;var wf=ko;var mf=No;var Tf=Co;var bf=Po;var Df=Wo;var Ff=zo;var Mf=Jo;var Sf=Yo;var kf=en;var Of=nn;var _f=pn;var Nf=cn;var Af=hn;var Bf=bn;var Cf=Sn;var If=_n;var Lf=Cn;var Rf=Rn;var Pf=xn;var Vf=Gn;var xf=Hn;var Wf=Kn;var Ef=Qn;var Gf=ra;var jf=ia;var zf=pa;var Hf=da;var Uf=va;var Jf=wa;var qf=ba;var Kf=Sa;var $f=Na;var Yf=Ca;var Xf=Pa;var Qf=Ea;var Zf=Ha;var ed=Ka;var td=Qa;var rd=ti;var od=ni;var nd=li;var ad=di;var id=yi;var sd=Ti;var ld=Mi;var pd=Oi;var ud=Bi;var fd=Ri;var dd=Wi;var cd=zi;var gd=qi;var vd=Yi;var yd=es;var hd=ns;var wd=ls;var md=fs;var Td=vs;var bd=ms;var Dd=Fs;var Fd=Os;var Md=As;var Sd=Is;var kd=Ps;var Od=Es;var _d=Hs;var Nd=Ks;var Ad=Qs;var Bd=rl;var Cd=il;var Id=pl;var Ld=dl;var Rd=yl;var Pd=Tl;var Vd=Fl;var xd=kl;var Wd=Nl;var Ed=Cl;var Gd=Rl;var jd=xl;var zd=Gl;var Hd=Hl;var Ud=Kl;var Jd=Ql;var qd=rp;var Kd=ap;var $d=lp;var Yd=dp;var Xd=vp;var Qd=mp;var Zd=Fp;var ec=Op;var tc=Ap;var rc=Ip;var oc=Pp;var nc=Ep;var ac=Up;var ic=Yp;var sc=eu;var lc=nu;var pc=lu;var uc=du;var fc=[Tf.FFTConfig,If.IFFTConfig,qf.LRNConfig,Kf.LRNGradConfig,hu._fusedMatMulConfig,wu.absConfig,mu.acosConfig,Tu.acoshConfig,bu.addConfig,Du.addNConfig,Fu.allConfig,Mu.anyConfig,Su.argMaxConfig,ku.argMinConfig,Ou.asinConfig,_u.asinhConfig,Au.atan2Config,Nu.atanConfig,Bu.atanhConfig,Iu.avgPool3DConfig,Lu.avgPool3DGradConfig,Cu.avgPoolConfig,Ru.avgPoolGradConfig,Pu.batchMatMulConfig,Vu.batchToSpaceNDConfig,Wu.broadcastArgsConfig,Eu.castConfig,Gu.ceilConfig,ju.clipByValueConfig,Hu.complexAbsConfig,zu.complexConfig,Uu.concatConfig,qu.conv2DBackpropFilterConfig,Ku.conv2DBackpropInputConfig,Ju.conv2DConfig,Yu.conv3DBackpropFilterV2Config,Xu.conv3DBackpropInputV2Config,$u.conv3DConfig,Qu.cosConfig,Zu.coshConfig,ef.cropAndResizeConfig,tf.cumprodConfig,rf.cumsumConfig,xu.bincountConfig,of.depthToSpaceConfig,af.depthwiseConv2dNativeBackpropFilterConfig,sf.depthwiseConv2dNativeBackpropInputConfig,nf.depthwiseConv2dNativeConfig,lf.diagConfig,uf.dilation2dBackpropFilterConfig,ff.dilation2dBackpropInputConfig,pf.dilation2dConfig,cf.eluConfig,gf.eluGradConfig,df.einsumConfig,vf.equalConfig,yf.erfConfig,hf.expConfig,wf.expandDimsConfig,mf.expm1Config,bf.fillConfig,Df.flipLeftRightConfig,Ff.floorConfig,Mf.floorDivConfig,Sf.fusedBatchNormConfig,kf.fusedConv2DConfig,Of.fusedDepthwiseConv2DConfig,_f.gatherNdConfig,Nf.gatherV2Config,Af.greaterConfig,Bf.greaterEqualConfig,Cf.identityConfig,Lf.imagConfig,Rf.isFiniteConfig,Pf.isInfConfig,Vf.isNanConfig,xf.leakyReluConfig,Wf.lessConfig,Ef.lessEqualConfig,Gf.linSpaceConfig,zf.log1pConfig,jf.logConfig,Hf.logicalAndConfig,Uf.logicalNotConfig,Jf.logicalOrConfig,$f.maxConfig,Qf.maxPool3DConfig,Zf.maxPool3DGradConfig,Xf.maxPoolConfig,ed.maxPoolGradConfig,Yf.maximumConfig,td.meanConfig,rd.minConfig,od.minimumConfig,nd.mirrorPadConfig,ad.modConfig,id.multinomialConfig,sd.multiplyConfig,ld.negConfig,pd.nonMaxSuppressionV3Config,ud.nonMaxSuppressionV4Config,fd.nonMaxSuppressionV5Config,dd.notEqualConfig,cd.oneHotConfig,gd.onesLikeConfig,vd.packConfig,yd.padV2Config,hd.powConfig,wd.preluConfig,md.prodConfig,Td.rangeConfig,bd.realConfig,Dd.realDivConfig,Fd.reciprocalConfig,Sd.relu6Config,Md.reluConfig,kd.reshapeConfig,Od.resizeBilinearConfig,_d.resizeBilinearGradConfig,Nd.resizeNearestNeighborConfig,Ad.resizeNearestNeighborGradConfig,Bd.reverseConfig,Cd.roundConfig,Id.rsqrtConfig,Ld.scatterNdConfig,Rd.selectConfig,Pd.seluConfig,Vd.sigmoidConfig,xd.signConfig,Wd.sinConfig,Ed.sinhConfig,Gd.sliceConfig,jd.softmaxConfig,zd.softplusConfig,Hd.spaceToBatchNDConfig,Ud.sparseToDenseConfig,Jd.splitVConfig,qd.sqrtConfig,Kd.squareConfig,$d.squaredDifferenceConfig,Yd.staticRegexReplaceConfig,Xd.stepConfig,Qd.stridedSliceConfig,Zd.subConfig,ec.sumConfig,tc.tanConfig,rc.tanhConfig,oc.tensorScatterUpdateConfig,nc.tileConfig,ac.topKConfig,ic.transposeConfig,sc.uniqueConfig,lc.unpackConfig,pc.unsortedSegmentSumConfig,uc.zerosLikeConfig];for(var dc=0,cc=fc;dc<cc.length;dc++){var gc=cc[dc];(0,yu.registerKernel)(gc)}var vc=e;try{"default"in e&&(vc=e.default)}catch(e){}var yc={};
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
 */Object.defineProperty(yc,"__esModule",{value:true});yc.summaryFileWriter=yc.SummaryFileWriter=void 0;var hc=vc;var wc=N;var mc=function(){function SummaryFileWriter(e){this.resourceHandle=e;(0,wc.ensureTensorflowBackend)();this.backend=(0,wc.nodeBackend)()}
/**
   * Write a scalar summary.
   *
   * @param name A name of the summary. The summary tag for TensorBoard will be
   *   this name.
   * @param value A real numeric scalar value, as `tf.Scalar` or a JavaScript
   *   `number`.
   * @param step Required `int64`-castable, monotonically-increasing step value.
   * @param description Optional long-form description for this summary, as a
   *   `string`. *Not implemented yet*.
   */SummaryFileWriter.prototype.scalar=function(e,t,r,o){if(o!=null)throw new Error("scalar() does not support description yet");this.backend.writeScalarSummary(this.resourceHandle,r,e,t)};
/**
   * Write a histogram summary, for later analysis in TensorBoard's 'Histograms'
   * and 'Distributions' dashboards (data written using this API will appear in
   * both places). Like `SummaryFileWriter.scalar` points, each histogram is
   * associated with a `step` and a `name`. All the histograms with the same
   * `name` constitute a time series of histograms.
   *
   * The histogram is calculated over all the elements of the given `Tensor`
   * without regard to its shape or rank.
   *
   * @param name  A name for this summary. The summary tag used for TensorBoard
   *     will be this name.
   * @param data  A Tensor of any shape. The histogram is computed over its
   *     elements, which must be castable to `float32`.
   * @param step  Monotonically-increasing step value.
   * @param buckets  Optional positive `number`. The output will have this many
   *     buckets, except in two edge cases. If there is no data, then there are
   *     no buckets. If there is data but all points have the same value, then
   *     there is one bucket whose left and right endpoints are the same.
   * @param description Optional long-form description for this summary, as a
   *    `string`. Markdown is supported. Defaults to empty.
   */SummaryFileWriter.prototype.histogram=function(e,t,r,o,n){this.backend.writeHistogramSummary(this.resourceHandle,r,e,t,o,n)};SummaryFileWriter.prototype.flush=function(){this.backend.flushSummaryWriter(this.resourceHandle)};return SummaryFileWriter}();yc.SummaryFileWriter=mc;var Tc={};
/**
 * Create a summary file writer for TensorBoard.
 *
 * Example:
 * ```js
 * const tf = require('@tensorflow/tfjs-node');
 *
 * const summaryWriter = tf.node.summaryFileWriter('/tmp/tfjs_tb_logdir');
 *
 * for (let step = 0; step < 100; ++step) {
 *  summaryWriter.scalar('dummyValue', Math.sin(2 * Math.PI * step / 8), step);
 * }
 * ```
 *
 * @param logdir Log directory in which the summary data will be written.
 * @param maxQueue Maximum queue length (default: `10`).
 * @param flushMillis Flush every __ milliseconds (default: `120e3`, i.e,
 *   `120` seconds).
 * @param filenameSuffix Suffix of the protocol buffer file names to be
 *   written in the `logdir` (default: `.v2`).
 * @returns An instance of `SummaryFileWriter`.
 *
 * @doc {heading: 'TensorBoard', namespace: 'node'}
 */function summaryFileWriter(e,t,r,o){t===void 0&&(t=10);r===void 0&&(r=12e4);o===void 0&&(o=".v2");hc.util.assert(e!=null&&typeof e==="string"&&e.length>0,(function(){return"Invalid logdir: ".concat(e,". Expected a non-empty string for logdir.")}));if(!(e in Tc)){(0,wc.ensureTensorflowBackend)();var n=(0,wc.nodeBackend)();var a=n.summaryWriter(e);n.createSummaryFileWriter(a,e,t,r,o);Tc[e]=new mc(a)}return Tc[e]}yc.summaryFileWriter=summaryFileWriter;var bc=e;try{"default"in e&&(bc=e.default)}catch(e){}var Dc=i;try{"default"in i&&(Dc=i.default)}catch(e){}var Fc=s;try{"default"in s&&(Fc=s.default)}catch(e){}var Mc={};var Sc=n;
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
 */var kc=Mc&&Mc.__extends||function(){var extendStatics=function(e,t){extendStatics=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(e,t){e.__proto__=t}||function(e,t){for(var r in t)Object.prototype.hasOwnProperty.call(t,r)&&(e[r]=t[r])};return extendStatics(e,t)};return function(e,t){if(typeof t!=="function"&&t!==null)throw new TypeError("Class extends value "+String(t)+" is not a constructor or null");extendStatics(e,t);function __(){this.constructor=e}e.prototype=t===null?Object.create(t):(__.prototype=t.prototype,new __)}}();var Oc=Mc&&Mc.__awaiter||function(e,t,r,o){function adopt(e){return e instanceof r?e:new r((function(t){t(e)}))}return new(r||(r=Promise))((function(r,n){function fulfilled(e){try{step(o.next(e))}catch(e){n(e)}}function rejected(e){try{step(o.throw(e))}catch(e){n(e)}}function step(e){e.done?r(e.value):adopt(e.value).then(fulfilled,rejected)}step((o=o.apply(e,t||[])).next())}))};var _c=Mc&&Mc.__generator||function(e,t){var r,o,n,a,i={label:0,sent:function(){if(n[0]&1)throw n[1];return n[1]},trys:[],ops:[]};return a={next:verb(0),throw:verb(1),return:verb(2)},typeof Symbol==="function"&&(a[Symbol.iterator]=function(){return this}),a;function verb(e){return function(t){return step([e,t])}}function step(s){if(r)throw new TypeError("Generator is already executing.");while(a&&(a=0,s[0]&&(i=0)),i)try{if(r=1,o&&(n=s[0]&2?o.return:s[0]?o.throw||((n=o.return)&&n.call(o),0):o.next)&&!(n=n.call(o,s[1])).done)return n;(o=0,n)&&(s=[s[0]&2,n.value]);switch(s[0]){case 0:case 1:n=s;break;case 4:i.label++;return{value:s[1],done:false};case 5:i.label++;o=s[1];s=[0];continue;case 7:s=i.ops.pop();i.trys.pop();continue;default:if(!(n=i.trys,n=n.length>0&&n[n.length-1])&&(s[0]===6||s[0]===2)){i=0;continue}if(s[0]===3&&(!n||s[1]>n[0]&&s[1]<n[3])){i.label=s[1];break}if(s[0]===6&&i.label<n[1]){i.label=n[1];n=s;break}if(n&&i.label<n[2]){i.label=n[2];i.ops.push(s);break}n[2]&&i.ops.pop();i.trys.pop();continue}s=t.call(e,i)}catch(e){s=[6,e];o=0}finally{r=n=0}if(s[0]&5)throw s[1];return{value:s[0]?s[1]:void 0,done:true}}};Object.defineProperty(Mc,"__esModule",{value:true});Mc.tensorBoard=Mc.TensorBoardCallback=Mc.getDisplayDecimalPlaces=Mc.getSuccinctNumberDisplay=Mc.ProgbarLogger=Mc.progressBarHelper=void 0;var Nc=bc;var Ac=Dc;var Bc=Fc;var Cc=yc;Mc.progressBarHelper={ProgressBar:Bc,log:console.log};var Ic=function(e){kc(ProgbarLogger,e);function ProgbarLogger(){var t=e.call(this,{onTrainBegin:function(e){return Oc(t,void 0,void 0,(function(){var e,t,r;return _c(this,(function(o){e=this.params.samples;t=this.params.batchSize;r=this.params.steps;this.numTrainBatchesPerEpoch=e!=null||r!=null?e!=null?Math.ceil(e/t):r:0;return[2]}))}))},onEpochBegin:function(e,r){return Oc(t,void 0,void 0,(function(){return _c(this,(function(t){Mc.progressBarHelper.log("Epoch ".concat(e+1," / ").concat(this.params.epochs));this.currentEpochBegin=Nc.util.now();this.epochDurationMillis=null;this.usPerStep=null;this.batchesInLatestEpoch=0;this.terminalWidth=Sc.stderr.columns;return[2]}))}))},onBatchEnd:function(e,r){return Oc(t,void 0,void 0,(function(){var t,o;return _c(this,(function(n){switch(n.label){case 0:this.batchesInLatestEpoch++;e===0&&(this.progressBar=new Mc.progressBarHelper.ProgressBar("eta=:eta :bar :placeholderForLossesAndMetrics",{width:Math.floor(.5*this.terminalWidth),total:this.numTrainBatchesPerEpoch+1,head:">",renderThrottle:this.RENDER_THROTTLE_MS}));t=Math.floor(this.terminalWidth*.5-12);o={placeholderForLossesAndMetrics:this.formatLogsAsMetricsContent(r,t)};this.numTrainBatchesPerEpoch===0?this.progressBar.tick(0,o):this.progressBar.tick(o);return[4,(0,Nc.nextFrame)()];case 1:n.sent();if(e===this.numTrainBatchesPerEpoch-1){this.epochDurationMillis=Nc.util.now()-this.currentEpochBegin;this.usPerStep=this.params.samples!=null?this.epochDurationMillis/this.params.samples*1e3:this.epochDurationMillis/this.batchesInLatestEpoch*1e3}return[2]}}))}))},onEpochEnd:function(e,r){return Oc(t,void 0,void 0,(function(){var e;return _c(this,(function(t){switch(t.label){case 0:if(this.epochDurationMillis==null){this.epochDurationMillis=Nc.util.now()-this.currentEpochBegin;this.usPerStep=this.epochDurationMillis/this.batchesInLatestEpoch*1e3}this.progressBar.tick({placeholderForLossesAndMetrics:""});e=this.formatLogsAsMetricsContent(r);Mc.progressBarHelper.log("".concat(this.epochDurationMillis.toFixed(0),"ms ")+"".concat(this.usPerStep.toFixed(0),"us/step - ")+"".concat(e));return[4,(0,Nc.nextFrame)()];case 1:t.sent();return[2]}}))}))}})||this;t.RENDER_THROTTLE_MS=50;return t}ProgbarLogger.prototype.formatLogsAsMetricsContent=function(e,t){var r="";var o=Object.keys(e).sort();for(var n=0,a=o;n<a.length;n++){var i=a[n];if(this.isFieldRelevant(i)){var s=e[i];r+="".concat(i,"=").concat(getSuccinctNumberDisplay(s)," ")}}t!=null&&r.length>t&&(r=r.slice(0,t-3)+"...");return r};ProgbarLogger.prototype.isFieldRelevant=function(e){return e!=="batch"&&e!=="size"};return ProgbarLogger}(Nc.CustomCallback);Mc.ProgbarLogger=Ic;var Lc=2;var Rc=4;
/**
 * Get a succint string representation of a number.
 *
 * Uses decimal notation if the number isn't too small.
 * Otherwise, use engineering notation.
 *
 * @param x Input number.
 * @return Succinct string representing `x`.
 */function getSuccinctNumberDisplay(e){var t=getDisplayDecimalPlaces(e);return t>Rc?e.toExponential(Lc):e.toFixed(t)}Mc.getSuccinctNumberDisplay=getSuccinctNumberDisplay;
/**
 * Determine the number of decimal places to display.
 *
 * @param x Number to display.
 * @return Number of decimal places to display for `x`.
 */function getDisplayDecimalPlaces(e){return!Number.isFinite(e)||e===0||e>1||e<-1?Lc:Lc-Math.floor(Math.log10(Math.abs(e)))}Mc.getDisplayDecimalPlaces=getDisplayDecimalPlaces;var Pc=function(e){kc(TensorBoardCallback,e);function TensorBoardCallback(t,r){t===void 0&&(t="./logs");var o=e.call(this,{onBatchEnd:function(e,t){return Oc(o,void 0,void 0,(function(){return _c(this,(function(e){this.batchesSeen++;this.args.updateFreq!=="epoch"&&this.logMetrics(t,"batch_",this.batchesSeen);return[2]}))}))},onEpochEnd:function(e,t){return Oc(o,void 0,void 0,(function(){return _c(this,(function(r){this.logMetrics(t,"epoch_",e+1);this.args.histogramFreq>0&&e%this.args.histogramFreq===0&&this.logWeights(e);return[2]}))}))},onTrainEnd:function(e){return Oc(o,void 0,void 0,(function(){return _c(this,(function(e){this.trainWriter!=null&&this.trainWriter.flush();this.valWriter!=null&&this.valWriter.flush();return[2]}))}))}})||this;o.logdir=t;o.model=null;o.args=r==null?{}:r;o.args.updateFreq==null&&(o.args.updateFreq="epoch");Nc.util.assert(["batch","epoch"].indexOf(o.args.updateFreq)!==-1,(function(){return"Expected updateFreq to be 'batch' or 'epoch', but got "+"".concat(o.args.updateFreq)}));o.args.histogramFreq==null&&(o.args.histogramFreq=0);Nc.util.assert(Number.isInteger(o.args.histogramFreq)&&o.args.histogramFreq>=0,(function(){return"Expected histogramFreq to be a positive integer, but got "+"".concat(o.args.histogramFreq)}));o.batchesSeen=0;return o}TensorBoardCallback.prototype.setModel=function(e){this.model=e};TensorBoardCallback.prototype.logMetrics=function(e,t,r){for(var o in e)if(o!=="batch"&&o!=="size"&&o!=="num_steps"){var n="val_";if(o.startsWith(n)){this.ensureValWriterCreated();var a=t+o.slice(n.length);this.valWriter.scalar(a,e[o],r)}else{this.ensureTrainWriterCreated();this.trainWriter.scalar("".concat(t).concat(o),e[o],r)}}};TensorBoardCallback.prototype.logWeights=function(e){for(var t=0,r=this.model.weights;t<r.length;t++){var o=r[t];this.trainWriter.histogram(o.name,o.read(),e)}};TensorBoardCallback.prototype.ensureTrainWriterCreated=function(){this.trainWriter=(0,Cc.summaryFileWriter)(Ac.join(this.logdir,"train"))};TensorBoardCallback.prototype.ensureValWriterCreated=function(){this.valWriter=(0,Cc.summaryFileWriter)(Ac.join(this.logdir,"val"))};return TensorBoardCallback}(Nc.CustomCallback);Mc.TensorBoardCallback=Pc;
/**
 * Callback for logging to TensorBoard during training.
 *
 * Writes the loss and metric values (if any) to the specified log directory
 * (`logdir`) which can be ingested and visualized by TensorBoard.
 * This callback is usually passed as a callback to `tf.Model.fit()` or
 * `tf.Model.fitDataset()` calls during model training. The frequency at which
 * the values are logged can be controlled with the `updateFreq` field of the
 * configuration object (2nd argument).
 *
 * Usage example:
 * ```js
 * // Constructor a toy multilayer-perceptron regressor for demo purpose.
 * const model = tf.sequential();
 * model.add(
 *     tf.layers.dense({units: 100, activation: 'relu', inputShape: [200]}));
 * model.add(tf.layers.dense({units: 1}));
 * model.compile({
 *   loss: 'meanSquaredError',
 *   optimizer: 'sgd',
 *   metrics: ['MAE']
 * });
 *
 * // Generate some random fake data for demo purpose.
 * const xs = tf.randomUniform([10000, 200]);
 * const ys = tf.randomUniform([10000, 1]);
 * const valXs = tf.randomUniform([1000, 200]);
 * const valYs = tf.randomUniform([1000, 1]);
 *
 * // Start model training process.
 * await model.fit(xs, ys, {
 *   epochs: 100,
 *   validationData: [valXs, valYs],
 *    // Add the tensorBoard callback here.
 *   callbacks: tf.node.tensorBoard('/tmp/fit_logs_1')
 * });
 * ```
 *
 * Then you can use the following commands to point tensorboard
 * to the logdir:
 *
 * ```sh
 * pip install tensorboard  # Unless you've already installed it.
 * tensorboard --logdir /tmp/fit_logs_1
 * ```
 *
 * @param logdir Directory to which the logs will be written.
 * @param args Optional configuration arguments.
 * @returns An instance of `TensorBoardCallback`, which is a subclass of
 *   `tf.CustomCallback`.
 *
 * @doc {heading: 'TensorBoard', namespace: 'node'}
 */function tensorBoard(e,t){e===void 0&&(e="./logs");return new Pc(e,t)}Mc.tensorBoard=tensorBoard;var Vc=e;try{"default"in e&&(Vc=e.default)}catch(e){}var xc={};
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
 */Object.defineProperty(xc,"__esModule",{value:true});xc.nodeHTTPRequestRouter=xc.nodeHTTPRequest=void 0;var Wc=Vc;
/**
 * Factory function for HTTP IO Handler in Node.js.
 *
 * @param path URL path or an array of them.
 * @param requestInit Request init for the HTTP IOHandler. May include fields
 *   such as "credentials" and "cache". (Optional)
 * @param weightPathPrefix A path prefix for weight loading . (Optional).
 */function nodeHTTPRequest(e,t,r){return Wc.io.browserHTTPRequest(e,{requestInit:t,weightPathPrefix:r})}xc.nodeHTTPRequest=nodeHTTPRequest;var nodeHTTPRequestRouter=function(e){var t=true;t=Array.isArray(e)?e.every((function(e){return Wc.io.isHTTPScheme(e)})):Wc.io.isHTTPScheme(e);return t?nodeHTTPRequest(e):null};xc.nodeHTTPRequestRouter=nodeHTTPRequestRouter;var Ec={};
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
 */Object.defineProperty(Ec,"__esModule",{value:true});Ec.nodeHTTPRequest=Ec.fileSystem=void 0;var Gc=l;Object.defineProperty(Ec,"fileSystem",{enumerable:true,get:function(){return Gc.fileSystem}});var jc=xc;Object.defineProperty(Ec,"nodeHTTPRequest",{enumerable:true,get:function(){return jc.nodeHTTPRequest}});var zc={};
/** @license See the LICENSE file. */Object.defineProperty(zc,"__esModule",{value:true});zc.version=void 0;var Hc="4.20.0";zc.version=Hc;var Uc=e;try{"default"in e&&(Uc=e.default)}catch(e){}var Jc={};
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
 */var qc=Jc&&Jc.__awaiter||function(e,t,r,o){function adopt(e){return e instanceof r?e:new r((function(t){t(e)}))}return new(r||(r=Promise))((function(r,n){function fulfilled(e){try{step(o.next(e))}catch(e){n(e)}}function rejected(e){try{step(o.throw(e))}catch(e){n(e)}}function step(e){e.done?r(e.value):adopt(e.value).then(fulfilled,rejected)}step((o=o.apply(e,t||[])).next())}))};var Kc=Jc&&Jc.__generator||function(e,t){var r,o,n,a,i={label:0,sent:function(){if(n[0]&1)throw n[1];return n[1]},trys:[],ops:[]};return a={next:verb(0),throw:verb(1),return:verb(2)},typeof Symbol==="function"&&(a[Symbol.iterator]=function(){return this}),a;function verb(e){return function(t){return step([e,t])}}function step(s){if(r)throw new TypeError("Generator is already executing.");while(a&&(a=0,s[0]&&(i=0)),i)try{if(r=1,o&&(n=s[0]&2?o.return:s[0]?o.throw||((n=o.return)&&n.call(o),0):o.next)&&!(n=n.call(o,s[1])).done)return n;(o=0,n)&&(s=[s[0]&2,n.value]);switch(s[0]){case 0:case 1:n=s;break;case 4:i.label++;return{value:s[1],done:false};case 5:i.label++;o=s[1];s=[0];continue;case 7:s=i.ops.pop();i.trys.pop();continue;default:if(!(n=i.trys,n=n.length>0&&n[n.length-1])&&(s[0]===6||s[0]===2)){i=0;continue}if(s[0]===3&&(!n||s[1]>n[0]&&s[1]<n[3])){i.label=s[1];break}if(s[0]===6&&i.label<n[1]){i.label=n[1];n=s;break}if(n&&i.label<n[2]){i.label=n[2];i.ops.push(s);break}n[2]&&i.ops.pop();i.trys.pop();continue}s=t.call(e,i)}catch(e){s=[6,e];o=0}finally{r=n=0}if(s[0]&5)throw s[1];return{value:s[0]?s[1]:void 0,done:true}}};Object.defineProperty(Jc,"__esModule",{value:true});Jc.getImageType=Jc.encodePng=Jc.encodeJpeg=Jc.decodeImage=Jc.decodeGif=Jc.decodeBmp=Jc.decodePng=Jc.decodeJpeg=Jc.ImageType=void 0;var $c=Uc;var Yc=N;var Xc;(function(e){e.JPEG="jpeg";e.PNG="png";e.GIF="gif";e.BMP="BMP"})(Xc=Jc.ImageType||(Jc.ImageType={}));
/**
 * Decode a JPEG-encoded image to a 3D Tensor of dtype `int32`.
 *
 * @param contents The JPEG-encoded image in an Uint8Array.
 * @param channels An optional int. Defaults to 0. Accepted values are
 *     0: use the number of channels in the JPEG-encoded image.
 *     1: output a grayscale image.
 *     3: output an RGB image.
 * @param ratio An optional int. Defaults to 1. Downscaling ratio. It is used
 *     when image is type Jpeg.
 * @param fancyUpscaling An optional bool. Defaults to True. If true use a
 *     slower but nicer upscaling of the chroma planes. It is used when image is
 *     type Jpeg.
 * @param tryRecoverTruncated An optional bool. Defaults to False. If true try
 *     to recover an image from truncated input. It is used when image is type
 *     Jpeg.
 * @param acceptableFraction An optional float. Defaults to 1. The minimum
 *     required fraction of lines before a truncated input is accepted. It is
 *     used when image is type Jpeg.
 * @param dctMethod An optional string. Defaults to "". string specifying a hint
 *     about the algorithm used for decompression. Defaults to "" which maps to
 *     a system-specific default. Currently valid values are ["INTEGER_FAST",
 *     "INTEGER_ACCURATE"]. The hint may be ignored (e.g., the internal jpeg
 *     library changes to a version that does not have that specific option.) It
 *     is used when image is type Jpeg.
 * @returns A 3D Tensor of dtype `int32` with shape [height, width, 1/3].
 *
 * @doc {heading: 'Operations', subheading: 'Images', namespace: 'node'}
 */function decodeJpeg(e,t,r,o,n,a,i){t===void 0&&(t=0);r===void 0&&(r=1);o===void 0&&(o=true);n===void 0&&(n=false);a===void 0&&(a=1);i===void 0&&(i="");(0,Yc.ensureTensorflowBackend)();return(0,$c.tidy)((function(){return(0,Yc.nodeBackend)().decodeJpeg(e,t,r,o,n,a,i).toInt()}))}Jc.decodeJpeg=decodeJpeg;
/**
 * Decode a PNG-encoded image to a 3D Tensor of dtype `int32`.
 *
 * @param contents The PNG-encoded image in an Uint8Array.
 * @param channels An optional int. Defaults to 0. Accepted values are
 *      0: use the number of channels in the PNG-encoded image.
 *      1: output a grayscale image.
 *      3: output an RGB image.
 *      4: output an RGBA image.
 * @param dtype The data type of the result. Only `int32` is supported at this
 *     time.
 * @returns A 3D Tensor of dtype `int32` with shape [height, width, 1/3/4].
 *
 * @doc {heading: 'Operations', subheading: 'Images', namespace: 'node'}
 */function decodePng(e,t,r){t===void 0&&(t=0);r===void 0&&(r="int32");$c.util.assert(r==="int32",(function(){return"decodeImage could only return Tensor of type `int32` for now."}));(0,Yc.ensureTensorflowBackend)();return(0,$c.tidy)((function(){return(0,Yc.nodeBackend)().decodePng(e,t).toInt()}))}Jc.decodePng=decodePng;
/**
 * Decode the first frame of a BMP-encoded image to a 3D Tensor of dtype
 * `int32`.
 *
 * @param contents The BMP-encoded image in an Uint8Array.
 * @param channels An optional int. Defaults to 0. Accepted values are
 *      0: use the number of channels in the BMP-encoded image.
 *      3: output an RGB image.
 *      4: output an RGBA image.
 * @returns A 3D Tensor of dtype `int32` with shape [height, width, 3/4].
 *
 * @doc {heading: 'Operations', subheading: 'Images', namespace: 'node'}
 */function decodeBmp(e,t){t===void 0&&(t=0);(0,Yc.ensureTensorflowBackend)();return(0,$c.tidy)((function(){return(0,Yc.nodeBackend)().decodeBmp(e,t).toInt()}))}Jc.decodeBmp=decodeBmp;
/**
 * Decode the frame(s) of a GIF-encoded image to a 4D Tensor of dtype `int32`.
 *
 * @param contents The GIF-encoded image in an Uint8Array.
 * @returns A 4D Tensor of dtype `int32` with shape [num_frames, height, width,
 *     3]. RGB channel order.
 *
 * @doc {heading: 'Operations', subheading: 'Images', namespace: 'node'}
 */function decodeGif(e){(0,Yc.ensureTensorflowBackend)();return(0,$c.tidy)((function(){return(0,Yc.nodeBackend)().decodeGif(e).toInt()}))}Jc.decodeGif=decodeGif;
/**
 * Given the encoded bytes of an image, it returns a 3D or 4D tensor of the
 * decoded image. Supports BMP, GIF, JPEG and PNG formats.
 *
 * @param content The encoded image in an Uint8Array.
 * @param channels An optional int. Defaults to 0, use the number of channels in
 *     the image. Number of color channels for the decoded image. It is used
 *     when image is type Png, Bmp, or Jpeg.
 * @param dtype The data type of the result. Only `int32` is supported at this
 *     time.
 * @param expandAnimations A boolean which controls the shape of the returned
 *     op's output. If True, the returned op will produce a 3-D tensor for PNG,
 *     JPEG, and BMP files; and a 4-D tensor for all GIFs, whether animated or
 *     not. If, False, the returned op will produce a 3-D tensor for all file
 *     types and will truncate animated GIFs to the first frame.
 * @returns A Tensor with dtype `int32` and a 3- or 4-dimensional shape,
 *     depending on the file type. For gif file the returned Tensor shape is
 *     [num_frames, height, width, 3], and for jpeg/png/bmp the returned Tensor
 *     shape is [height, width, channels]
 *
 * @doc {heading: 'Operations', subheading: 'Images', namespace: 'node'}
 */function decodeImage(e,t,r,o){t===void 0&&(t=0);r===void 0&&(r="int32");o===void 0&&(o=true);$c.util.assert(r==="int32",(function(){return"decodeImage could only return Tensor of type `int32` for now."}));var n=getImageType(e);switch(n){case Xc.JPEG:return decodeJpeg(e,t);case Xc.PNG:return decodePng(e,t);case Xc.GIF:return(0,$c.tidy)((function(){var t=decodeGif(e);return o?t:t.slice(0,1).squeeze([0])}));case Xc.BMP:return decodeBmp(e,t);default:return null}}Jc.decodeImage=decodeImage;
/**
 * Encodes an image tensor to JPEG.
 *
 * @param image A 3-D uint8 Tensor of shape [height, width, channels].
 * @param format An optional string from: "", "grayscale", "rgb".
 *     Defaults to "". Per pixel image format.
 *     - '': Use a default format based on the number of channels in the image.
 *     - grayscale: Output a grayscale JPEG image. The channels dimension of
 *       image must be 1.
 *     - rgb: Output an RGB JPEG image. The channels dimension of image must
 *       be 3.
 * @param quality An optional int. Defaults to 95. Quality of the compression
 *     from 0 to 100 (higher is better and slower).
 * @param progressive An optional bool. Defaults to False. If True, create a
 *     JPEG that loads progressively (coarse to fine).
 * @param optimizeSize An optional bool. Defaults to False. If True, spend
 *     CPU/RAM to reduce size with no quality change.
 * @param chromaDownsampling  An optional bool. Defaults to True.
 *     See http://en.wikipedia.org/wiki/Chroma_subsampling.
 * @param densityUnit An optional string from: "in", "cm". Defaults to "in".
 *     Unit used to specify x_density and y_density: pixels per inch ('in') or
 *     centimeter ('cm').
 * @param xDensity An optional int. Defaults to 300. Horizontal pixels per
 *     density unit.
 * @param yDensity An optional int. Defaults to 300. Vertical pixels per
 *     density unit.
 * @param xmpMetadata An optional string. Defaults to "". If not empty, embed
 *     this XMP metadata in the image header.
 * @returns The JPEG encoded data as an Uint8Array.
 *
 * @doc {heading: 'Operations', subheading: 'Images', namespace: 'node'}
 */function encodeJpeg(e,t,r,o,n,a,i,s,l,p){t===void 0&&(t="");r===void 0&&(r=95);o===void 0&&(o=false);n===void 0&&(n=false);a===void 0&&(a=true);i===void 0&&(i="in");s===void 0&&(s=300);l===void 0&&(l=300);p===void 0&&(p="");return qc(this,void 0,void 0,(function(){var u;return Kc(this,(function(f){(0,Yc.ensureTensorflowBackend)();u=function(u){return(0,Yc.nodeBackend)().encodeJpeg(u,e.shape,t,r,o,n,a,i,s,l,p)};return[2,encodeImage(e,u)]}))}))}Jc.encodeJpeg=encodeJpeg;
/**
 * Encodes an image tensor to PNG.
 *
 * @param image A 3-D uint8 Tensor of shape [height, width, channels].
 * @param compression An optional int. Defaults to 1. Compression level.
 * @returns The PNG encoded data as an Uint8Array.
 *
 * @doc {heading: 'Operations', subheading: 'Images', namespace: 'node'}
 */function encodePng(e,t){t===void 0&&(t=1);return qc(this,void 0,void 0,(function(){var r;return Kc(this,(function(o){(0,Yc.ensureTensorflowBackend)();r=function(r){return(0,Yc.nodeBackend)().encodePng(r,e.shape,t)};return[2,encodeImage(e,r)]}))}))}Jc.encodePng=encodePng;function encodeImage(e,t){return qc(this,void 0,void 0,(function(){var r,o,n,a;return Kc(this,(function(i){switch(i.label){case 0:o=t;n=Uint8Array.bind;return[4,e.data()];case 1:r=o.apply(void 0,[new(n.apply(Uint8Array,[void 0,i.sent()]))]);return[4,r.data()];case 2:a=i.sent()[0];r.dispose();return[2,a]}}))}))}function getImageType(e){if(e.length>3&&e[0]===255&&e[1]===216&&e[2]===255)return Xc.JPEG;if(e.length>4&&e[0]===71&&e[1]===73&&e[2]===70&&e[3]===56)return Xc.GIF;if(e.length>8&&e[0]===137&&e[1]===80&&e[2]===78&&e[3]===71&&e[4]===13&&e[5]===10&&e[6]===26&&e[7]===10)return Xc.PNG;if(e.length>3&&e[0]===66&&e[1]===77)return Xc.BMP;throw new Error("Expected image (BMP, JPEG, PNG, or GIF), but got unsupported image type")}Jc.getImageType=getImageType;var Qc=e;try{"default"in e&&(Qc=e.default)}catch(e){}var Zc=u;try{"default"in u&&(Zc=u.default)}catch(e){}var eg=t;try{"default"in t&&(eg=t.default)}catch(e){}var tg={};
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
 */var rg=tg&&tg.__awaiter||function(e,t,r,o){function adopt(e){return e instanceof r?e:new r((function(t){t(e)}))}return new(r||(r=Promise))((function(r,n){function fulfilled(e){try{step(o.next(e))}catch(e){n(e)}}function rejected(e){try{step(o.throw(e))}catch(e){n(e)}}function step(e){e.done?r(e.value):adopt(e.value).then(fulfilled,rejected)}step((o=o.apply(e,t||[])).next())}))};var og=tg&&tg.__generator||function(e,t){var r,o,n,a,i={label:0,sent:function(){if(n[0]&1)throw n[1];return n[1]},trys:[],ops:[]};return a={next:verb(0),throw:verb(1),return:verb(2)},typeof Symbol==="function"&&(a[Symbol.iterator]=function(){return this}),a;function verb(e){return function(t){return step([e,t])}}function step(s){if(r)throw new TypeError("Generator is already executing.");while(a&&(a=0,s[0]&&(i=0)),i)try{if(r=1,o&&(n=s[0]&2?o.return:s[0]?o.throw||((n=o.return)&&n.call(o),0):o.next)&&!(n=n.call(o,s[1])).done)return n;(o=0,n)&&(s=[s[0]&2,n.value]);switch(s[0]){case 0:case 1:n=s;break;case 4:i.label++;return{value:s[1],done:false};case 5:i.label++;o=s[1];s=[0];continue;case 7:s=i.ops.pop();i.trys.pop();continue;default:if(!(n=i.trys,n=n.length>0&&n[n.length-1])&&(s[0]===6||s[0]===2)){i=0;continue}if(s[0]===3&&(!n||s[1]>n[0]&&s[1]<n[3])){i.label=s[1];break}if(s[0]===6&&i.label<n[1]){i.label=n[1];n=s;break}if(n&&i.label<n[2]){i.label=n[2];i.ops.push(s);break}n[2]&&i.ops.pop();i.trys.pop();continue}s=t.call(e,i)}catch(e){s=[6,e];o=0}finally{r=n=0}if(s[0]&5)throw s[1];return{value:s[0]?s[1]:void 0,done:true}}};Object.defineProperty(tg,"__esModule",{value:true});tg.getNumOfSavedModels=tg.loadSavedModel=tg.TFSavedModel=tg.getSignatureDefEntryFromMetaGraphInfo=tg.getMetaGraphsFromSavedModel=tg.readSavedModelProto=tg.getEnumKeyFromValue=void 0;var ng=Qc;var ag=Zc;var ig=eg;var sg=N;var lg=(0,ig.promisify)(ag.readFile);var pg=F;var ug="/saved_model.pb";var fg="__saved_model_init_op";var dg=new Map;var cg=0;
/**
 * Get a key in an object by its value. This is used to get protobuf enum value
 * from index.
 *
 * @param object
 * @param value
 */function getEnumKeyFromValue(e,t){return Object.keys(e).find((function(r){return e[r]===t}))}tg.getEnumKeyFromValue=getEnumKeyFromValue;
/**
 * Read SavedModel proto message from path.
 *
 * @param path Path to SavedModel folder.
 */function readSavedModelProto(e){return rg(this,void 0,void 0,(function(){var t,r;return og(this,(function(o){switch(o.label){case 0:try{ag.accessSync(e+ug,ag.constants.R_OK)}catch(t){throw new Error("There is no saved_model.pb file in the directory: "+e)}return[4,lg(e+ug)];case 1:t=o.sent();r=new Uint8Array(t);return[2,pg.SavedModel.deserializeBinary(r)]}}))}))}tg.readSavedModelProto=readSavedModelProto;
/**
 * Inspect the MetaGraphs of the SavedModel from the provided path. This
 * function will return an array of `MetaGraphInfo` objects.
 *
 * @param path Path to SavedModel folder.
 *
 * @doc {heading: 'Models', subheading: 'SavedModel', namespace: 'node'}
 */function getMetaGraphsFromSavedModel(e){return rg(this,void 0,void 0,(function(){var t,r,o,n,a,i,s,l,p,u,f,d,c,g,v,y,h,w,m,T,b,D,F,M;return og(this,(function(S){switch(S.label){case 0:t=[];return[4,readSavedModelProto(e)];case 1:r=S.sent();o=r.getMetaGraphsList();for(n=0;n<o.length;n++){a={};i=o[n].getMetaInfoDef().getTagsList();a.tags=i;s={};l=o[n].getSignatureDefMap();p=l.keys();while(true){u=p.next();if(u.done)break;if(u.value!==fg){f=l.get(u.value);d=f.getInputsMap();c=d.keys();g={};while(true){v=c.next();if(v.done)break;y=d.get(v.value);h={};M=getEnumKeyFromValue(pg.DataType,y.getDtype());h.dtype=mapTFDtypeToJSDtype(M);h.tfDtype=M;h.name=y.getName();h.shape=y.getTensorShape().getDimList();g[v.value]=h}w=f.getOutputsMap();m=w.keys();T={};while(true){b=m.next();if(b.done)break;D=w.get(b.value);F={};M=getEnumKeyFromValue(pg.DataType,D.getDtype());F.dtype=mapTFDtypeToJSDtype(M);F.tfDtype=M;F.name=D.getName();F.shape=D.getTensorShape().getDimList();T[b.value]=F}s[u.value]={inputs:g,outputs:T}}}a.signatureDefs=s;t.push(a)}return[2,t]}}))}))}tg.getMetaGraphsFromSavedModel=getMetaGraphsFromSavedModel;
/**
 * Get SignatureDefEntry from SavedModel metagraphs info. The SignatureDefEntry
 * will be used when executing a SavedModel signature.
 *
 * @param savedModelInfo The MetaGraphInfo array loaded through
 *     getMetaGraphsFromSavedModel().
 * @param tags The tags of the MetaGraph to get input/output node names from.
 * @param signature The signature to get input/output node names from.
 */function getSignatureDefEntryFromMetaGraphInfo(e,t,r){for(var o=0;o<e.length;o++){var n=e[o];if(stringArraysHaveSameElements(t,n.tags)){if(n.signatureDefs[r]==null)throw new Error("The SavedModel does not have signature: "+r);return n.signatureDefs[r]}}throw new Error("The SavedModel does not have tags: ".concat(t))}tg.getSignatureDefEntryFromMetaGraphInfo=getSignatureDefEntryFromMetaGraphInfo;var gg=function(){function TFSavedModel(e,t,r,o){this.sessionId=e;this.jsid=t;this.signature=r;this.backend=o;this.disposed=false}Object.defineProperty(TFSavedModel.prototype,"inputs",{get:function(){var e=this.signature.inputs;var t=Object.keys(e).map((function(t){return e[t]}));t.forEach((function(e){e.name=e.name.replace(/:0$/,"")}));return t},enumerable:false,configurable:true});Object.defineProperty(TFSavedModel.prototype,"outputs",{get:function(){var e=this.signature.outputs;var t=Object.keys(e).map((function(t){return e[t]}));t.forEach((function(e){e.name=e.name.replace(/:0$/,"")}));return t},enumerable:false,configurable:true});TFSavedModel.prototype.dispose=function(){if(this.disposed)throw new Error("This SavedModel has already been deleted.");this.disposed=true;dg.delete(this.jsid);for(var e=0,t=Array.from(dg.keys());e<t.length;e++){var r=t[e];var o=dg.get(r);if(o.sessionId===this.sessionId)return}this.backend.deleteSavedModel(this.sessionId)};Object.defineProperty(TFSavedModel.prototype,"outputNodeNames",{get:function(){var e=this;if(this.outputNodeNames_!=null)return this.outputNodeNames_;this.outputNodeNames_=Object.keys(this.signature.outputs).reduce((function(t,r){t[r]=e.signature.outputs[r].name;return t}),{});return this.outputNodeNames_},enumerable:false,configurable:true});
/**
   * Execute the inference for the input tensors.
   *
   * @param input The input tensors, when there is single input for the model,
   * inputs param should be a Tensor. For models with multiple inputs, inputs
   * params should be in either Tensor[] if the input order is fixed, or
   * otherwise NamedTensorMap format. The keys in the NamedTensorMap are the
   * name of input tensors in SavedModel signatureDef. It can be found through
   * `tf.node.getMetaGraphsFromSavedModel()`.
   *
   * For batch inference execution, the tensors for each input need to be
   * concatenated together. For example with mobilenet, the required input shape
   * is [1, 244, 244, 3], which represents the [batch, height, width, channel].
   * If we are provide a batched data of 100 images, the input tensor should be
   * in the shape of [100, 244, 244, 3].
   *
   * @param config Prediction configuration for specifying the batch size.
   *
   * @returns Inference result tensors. The output would be single Tensor if
   * model has single output node, otherwise Tensor[] or NamedTensorMap[] will
   * be returned for model with multiple outputs.
   *
   * @doc {heading: 'Models', subheading: 'SavedModel'}
   */TFSavedModel.prototype.predict=function(e,t){var r=this;if(this.disposed)throw new Error("The TFSavedModel has already been deleted!");var o=[];if(e instanceof ng.Tensor){o.push(e);var n=this.backend.runSavedModel(this.sessionId,o,Object.values(this.signature.inputs),Object.values(this.outputNodeNames));return n.length>1?n:n[0]}if(Array.isArray(e)){o=e;return this.backend.runSavedModel(this.sessionId,o,Object.values(this.signature.inputs),Object.values(this.outputNodeNames))}var a=Object.keys(this.signature.inputs);var i=Object.keys(e);if(!stringArraysHaveSameElements(a,i))throw new Error("The model signatureDef input names are ".concat(a.join(),", however the provided input names are ").concat(i.join(),"."));var s=[];for(var l=0;l<a.length;l++){o.push(e[a[l]]);s.push(this.signature.inputs[a[l]])}var p=Object.keys(this.outputNodeNames);var u=[];for(l=0;l<p.length;l++)u.push(this.outputNodeNames[p[l]]);var f=this.backend.runSavedModel(this.sessionId,o,s,u);ng.util.assert(f.length===u.length,(function(){return"Output tensors do not match output node names, "+"receive ".concat(f.length,") output tensors but ")+"there are ".concat(r.outputNodeNames.length," output nodes.")}));var d={};for(l=0;l<p.length;l++)d[p[l]]=f[l];return d};
/**
   * Execute the inference for the input tensors and return activation
   * values for specified output node names without batching.
   *
   * @param input The input tensors, when there is single input for the model,
   * inputs param should be a Tensor. For models with multiple inputs, inputs
   * params should be in either Tensor[] if the input order is fixed, or
   * otherwise NamedTensorMap format.
   *
   * @param outputs string|string[]. List of output node names to retrieve
   * activation from.
   *
   * @returns Activation values for the output nodes result tensors. The return
   * type matches specified parameter outputs type. The output would be single
   * Tensor if single output is specified, otherwise Tensor[] for multiple
   * outputs.
   *
   * @doc {heading: 'Models', subheading: 'SavedModel'}
   */TFSavedModel.prototype.execute=function(e,t){throw new Error("execute() of TFSavedModel is not supported yet.")};return TFSavedModel}();tg.TFSavedModel=gg;
/**
 * Load a TensorFlow SavedModel from disk. TensorFlow SavedModel is different
 * from TensorFlow.js model format. A SavedModel is a directory containing
 * serialized signatures and the states needed to run them. The directory has a
 * saved_model.pb (or saved_model.pbtxt) file storing the actual TensorFlow
 * program, or model, and a set of named signatures, each identifying a
 * function. The directory also has a variables directory contains a standard
 * training checkpoint. The directory may also has a assets directory contains
 * files used by the TensorFlow graph, for example text files used to initialize
 * vocabulary tables. These are supported datatypes: float32, int32, complex64,
 * string.For more information, see this guide:
 * https://www.tensorflow.org/guide/saved_model.
 *
 * @param path The path to the SavedModel.
 * @param tags The tags of the MetaGraph to load. The available tags of a
 *     SavedModel can be retrieved through tf.node.getMetaGraphsFromSavedModel()
 *     API. Defaults to ['serve'].
 * @param signature The name of the SignatureDef to load. The available
 *     SignatureDefs of a SavedModel can be retrieved through
 *     tf.node.getMetaGraphsFromSavedModel() API. Defaults to 'serving_default'.
 *
 * @doc {heading: 'Models', subheading: 'SavedModel', namespace: 'node'}
 */function loadSavedModel(e,t,r){t===void 0&&(t=["serve"]);r===void 0&&(r="serving_default");return rg(this,void 0,void 0,(function(){var o,n,a,i,s,l,p,u,f,d,c;return og(this,(function(g){switch(g.label){case 0:(0,sg.ensureTensorflowBackend)();o=(0,sg.nodeBackend)();return[4,getMetaGraphsFromSavedModel(e)];case 1:n=g.sent();a=getSignatureDefEntryFromMetaGraphInfo(n,t,r);for(s=0,l=Array.from(dg.keys());s<l.length;s++){p=l[s];u=dg.get(p);u.path===e&&stringArraysHaveSameElements(u.tags,t)&&(i=u.sessionId)}if(i==null){f=t.join(",");i=o.loadSavedModelMetaGraph(e,f)}d=cg++;c=new gg(i,d,a,o);dg.set(d,{path:e,tags:t,sessionId:i});return[2,c]}}))}))}tg.loadSavedModel=loadSavedModel;
/**
 * Compare if two unsorted arrays of string have the same elements.
 * @param arrayA
 * @param arrayB
 */function stringArraysHaveSameElements(e,t){return e.length===t.length&&e.sort().join()===t.sort().join()}function mapTFDtypeToJSDtype(e){switch(e){case"DT_FLOAT":return"float32";case"DT_INT64":case"DT_INT32":case"DT_UINT8":return"int32";case"DT_BOOL":return"bool";case"DT_COMPLEX64":return"complex64";case"DT_STRING":return"string";default:throw new Error("Unsupported tensor DataType: "+e+", try to modify the model in python to convert the datatype")}}function getNumOfSavedModels(){(0,sg.ensureTensorflowBackend)();var e=(0,sg.nodeBackend)();return e.getNumOfSavedModels()}tg.getNumOfSavedModels=getNumOfSavedModels;var vg={};
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
 */Object.defineProperty(vg,"__esModule",{value:true});vg.node=void 0;var yg=Mc;var hg=Jc;var wg=tg;var mg=yc;vg.node={decodeImage:hg.decodeImage,decodeBmp:hg.decodeBmp,decodeGif:hg.decodeGif,decodePng:hg.decodePng,decodeJpeg:hg.decodeJpeg,encodeJpeg:hg.encodeJpeg,encodePng:hg.encodePng,summaryFileWriter:mg.summaryFileWriter,tensorBoard:yg.tensorBoard,getMetaGraphsFromSavedModel:wg.getMetaGraphsFromSavedModel,getNumOfSavedModels:wg.getNumOfSavedModels,loadSavedModel:wg.loadSavedModel};var Tg={name:"@tensorflow/tfjs-node",version:"4.20.0",main:"dist/index.js",types:"dist/index.d.ts",gypfile:true,repository:{type:"git",url:"https://github.com/tensorflow/tfjs.git",directory:"tfjs-node"},license:"Apache-2.0",engines:{node:">=8.11.0"},scripts:{build:"tsc && npx mkdirp dist/proto && cp src/proto/api_pb.js dist/proto/api_pb.js","build-ci":"tsc && npx mkdirp dist/proto && cp src/proto/api_pb.js dist/proto/api_pb.js","build-link-package":"cd ../link-package && yarn build-deps-for tfjs-node","build-union":"cd ../tfjs && yarn && yarn build","build-union-ci":"cd ../tfjs && yarn && yarn build-ci","build-deps":"yarn build-link-package && yarn build-union","build-deps-ci":"yarn build-link-package && yarn build-union-ci","build-npm":"./scripts/build-npm.sh","build-and-upload-addon":"./scripts/build-and-upload-addon.sh","build-addon-from-source":"node-pre-gyp install --build-from-source","clean-deps":"rm -rf deps && rm -rf lib",coverage:"nyc yarn ts-node -P tsconfig.test.json src/run_tests.ts","enable-gpu":"node scripts/install.js gpu download && yarn && yarn build-addon-from-source","ensure-cpu-gpu-packages-align":"node scripts/ensure-cpu-gpu-packages-align.js",format:"clang-format -i -style=Google binding/*.cc binding/*.h",install:"node scripts/install.js","install-from-source":"yarn clean-deps && yarn && yarn build-addon-from-source","link-local":"yalc link",lint:"tslint -p . -t verbose",prep:"cd node_modules/@tensorflow/tfjs-core && yarn && yarn build","publish-local":"yarn prep && yalc push","publish-npm":"yarn build-and-upload-addon publish && npm publish",test:"yarn && yarn build-deps && yarn build && ts-node --transpile-only --skip-ignore -P tsconfig.test.json src/run_tests.ts","test-dev":"tsc && ts-node --transpile-only --skip-ignore -P tsconfig.test.json src/run_tests.ts","test-ci":"ts-node --transpile-only --skip-ignore -P tsconfig.test.json src/run_tests.ts","upload-windows-addon":"./scripts/build-and-upload-windows-addon.bat"},devDependencies:{"@tensorflow/tfjs-core":"4.20.0","@types/jasmine":"~4.0.3","@types/node":"^10.5.1","@types/progress":"^2.0.1","@types/rimraf":"~2.0.2","@types/yargs":"^13.0.3","clang-format":"~1.8.0",jasmine:"~4.2.1","node-fetch":"~2.6.1",nyc:"^15.1.0",tmp:"^0.0.33","ts-node":"~8.8.2",tslint:"~6.1.3","tslint-no-circular-imports":"^0.7.0",typescript:"5.0.4",yalc:"~1.0.0-pre.50",yargs:"^16.2.0"},dependencies:{"@mapbox/node-pre-gyp":"1.0.9","@tensorflow/tfjs":"4.20.0","adm-zip":"^0.5.2","google-protobuf":"^3.9.2","https-proxy-agent":"^2.2.1",progress:"^2.0.0",rimraf:"^2.6.2",tar:"^6.2.1"},binary:{module_name:"tfjs_binding",module_path:"./lib/napi-v{napi_build_version}",host:"https://storage.googleapis.com/tf-builds/pre-built-binary",remote_path:"./napi-v{napi_build_version}/{version}/",napi_versions:[3,4,5,6,7,8]}};var bg=e;try{"default"in e&&(bg=e.default)}catch(e){}var Dg=i;try{"default"in i&&(Dg=i.default)}catch(e){}var Fg=p;try{"default"in p&&(Fg=p.default)}catch(e){}var Mg=u;try{"default"in u&&(Mg=u.default)}catch(e){}var Sg={};function _nullRequire(e){var t=new Error("Cannot find module '"+e+"'");t.code="MODULE_NOT_FOUND";throw t}
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
 */var kg=Sg&&Sg.__assign||function(){kg=Object.assign||function(e){for(var t,r=1,o=arguments.length;r<o;r++){t=arguments[r];for(var n in t)Object.prototype.hasOwnProperty.call(t,n)&&(e[n]=t[n])}return e};return kg.apply(this,arguments)};var Og=Sg&&Sg.__createBinding||(Object.create?function(e,t,r,o){o===void 0&&(o=r);var n=Object.getOwnPropertyDescriptor(t,r);n&&!("get"in n?!t.__esModule:n.writable||n.configurable)||(n={enumerable:true,get:function(){return t[r]}});Object.defineProperty(e,o,n)}:function(e,t,r,o){o===void 0&&(o=r);e[o]=t[r]});var _g=Sg&&Sg.__exportStar||function(e,t){for(var r in e)r==="default"||Object.prototype.hasOwnProperty.call(t,r)||Og(t,e,r)};Object.defineProperty(Sg,"__esModule",{value:true});Sg.io=Sg.version=void 0;vu;var Ng=bg;var Ag=Dg;var Bg=Mc;var Cg=l;var Ig=Ec;var Lg=N;var Rg=zc;var Pg=Fg;var Vg=Pg.find(Ag.resolve(Ag.join(new URL(import.meta.url.slice(0,import.meta.url.lastIndexOf("/"))).pathname,"/../package.json")));var xg=Mg;if(!xg.existsSync(Vg))throw new Error("The Node.js native addon module (tfjs_binding.node) can not be found at path: "+String(Vg)+". \nPlease run command 'npm rebuild @tensorflow/tfjs-node"+(String(Vg).indexOf("tfjs-node-gpu")>0?"-gpu":"")+" --build-addon-from-source' to rebuild the native addon module. \nIf you have problem with building the addon module, please check https://github.com/tensorflow/tfjs/blob/master/tfjs-node/WINDOWS_TROUBLESHOOTING.md or file an issue.");var Wg=_nullRequire(Vg);Sg.version=kg(kg({},Ng.version),{"tfjs-node":Rg.version});Sg.io=kg(kg({},Ng.io),Ig);_g(bg,Sg);_g(vg,Sg);var Eg=Tg;Ng.registerBackend("tensorflow",(function(){return new Lg.NodeJSKernelBackend(Wg,Eg.name)}),3);var Gg=Ng.setBackend("tensorflow");if(!Gg)throw new Error("Could not initialize TensorFlow backend.");Ng.io.registerLoadRouter(Cg.nodeFileSystemRouter);Ng.io.registerSaveRouter(Cg.nodeFileSystemRouter);Ng.registerCallbackConstructor(1,Bg.ProgbarLogger);const jg=Sg.__esModule,zg=Sg.io,Hg=Sg.version,Ug=Sg.node;export{jg as __esModule,Sg as default,zg as io,Ug as node,Hg as version};

