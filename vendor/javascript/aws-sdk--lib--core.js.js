import e,{__dew as t}from"aws-sdk/lib/core.js";import"../_/fc78fb0d.js";import r from"process";import"fs";import"../apis/metadata.json.js";import"uuid";import{d as a}from"../_/25af3ce5.js";import"./region_config_data.json.js";import"../_/408f9a13.js";import{d as n}from"../_/b9671cbd.js";import{d as i,a as s,b as o,c as u,e as l}from"../_/a168bb1a.js";import"../_/ad21f04e.js";import{d as c}from"../_/cbbdfb11.js";import{d}from"../_/a632c903.js";import p from"util";import f from"jmespath";import{d as h}from"../_/6dc48ed9.js";var v={},m=false;function dew(){if(m)return v;m=true;var e=a();function JsonBuilder(){}JsonBuilder.prototype.build=function(e,t){return JSON.stringify(translate(e,t))};function translate(e,t){if(t&&void 0!==e&&null!==e)switch(t.type){case"structure":return translateStructure(e,t);case"map":return translateMap(e,t);case"list":return translateList(e,t);default:return translateScalar(e,t)}}function translateStructure(t,r){var a={};e.each(t,(function(e,t){var n=r.members[e];if(n){if("body"!==n.location)return;var i=n.isLocationName?n.name:e;var s=translate(t,n);void 0!==s&&(a[i]=s)}}));return a}function translateList(t,r){var a=[];e.arrayEach(t,(function(e){var t=translate(e,r.member);void 0!==t&&a.push(t)}));return a}function translateMap(t,r){var a={};e.each(t,(function(e,t){var n=translate(t,r.value);void 0!==n&&(a[e]=n)}));return a}function translateScalar(e,t){return t.toWireFormat(e)}v=JsonBuilder;return v}var g={},y=false;function dew$1(){if(y)return g;y=true;var e=a();function JsonParser(){}JsonParser.prototype.parse=function(e,t){return translate(JSON.parse(e),t)};function translate(e,t){if(t&&void 0!==e)switch(t.type){case"structure":return translateStructure(e,t);case"map":return translateMap(e,t);case"list":return translateList(e,t);default:return translateScalar(e,t)}}function translateStructure(t,r){if(null!=t){var a={};var n=r.members;e.each(n,(function(e,r){var n=r.isLocationName?r.name:e;if(Object.prototype.hasOwnProperty.call(t,n)){var i=t[n];var s=translate(i,r);void 0!==s&&(a[e]=s)}}));return a}}function translateList(t,r){if(null!=t){var a=[];e.arrayEach(t,(function(e){var t=translate(e,r.member);void 0===t?a.push(null):a.push(t)}));return a}}function translateMap(t,r){if(null!=t){var a={};e.each(t,(function(e,t){var n=translate(t,r.value);a[e]=void 0===n?null:n}));return a}}function translateScalar(e,t){return t.toType(e)}g=JsonParser;return g}var E={},R=false;function dew$2(){if(R)return E;R=true;var r=a();var n=t?t():e;function populateHostPrefix(e){var t=e.service.config.hostPrefixEnabled;if(!t)return e;var r=e.service.api.operations[e.operation];if(hasEndpointDiscover(e))return e;if(r.endpoint&&r.endpoint.hostPrefix){var a=r.endpoint.hostPrefix;var n=expandHostPrefix(a,e.params,r.input);prependEndpointPrefix(e.httpRequest.endpoint,n);validateHostname(e.httpRequest.endpoint.hostname)}return e}function hasEndpointDiscover(e){var t=e.service.api;var a=t.operations[e.operation];var n=t.endpointOperation&&t.endpointOperation===r.string.lowerFirst(a.name);return"NULL"!==a.endpointDiscoveryRequired||true===n}function expandHostPrefix(e,t,a){r.each(a.members,(function(a,n){if(true===n.hostLabel){if("string"!==typeof t[a]||""===t[a])throw r.error(new Error,{message:"Parameter "+a+" should be a non-empty string.",code:"InvalidParameter"});var i=new RegExp("\\{"+a+"\\}","g");e=e.replace(i,t[a])}}));return e}function prependEndpointPrefix(e,t){e.host&&(e.host=t+e.host);e.hostname&&(e.hostname=t+e.hostname)}function validateHostname(e){var t=e.split(".");var a=/^[a-zA-Z0-9]{1}$|^[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]$/;r.arrayEach(t,(function(e){if(!e.length||e.length<1||e.length>63)throw r.error(new Error,{code:"ValidationError",message:"Hostname label length should be between 1 to 63 characters, inclusive."});if(!a.test(e))throw n.util.error(new Error,{code:"ValidationError",message:e+" is not hostname compatible."})}))}E={populateHostPrefix:populateHostPrefix};return E}var b={},S=false;function dew$3(){if(S)return b;S=true;var e=a();var t=dew();var r=dew$1();var n=dew$2().populateHostPrefix;function buildRequest(e){var r=e.httpRequest;var a=e.service.api;var i=a.targetPrefix+"."+a.operations[e.operation].name;var s=a.jsonVersion||"1.0";var o=a.operations[e.operation].input;var u=new t;1===s&&(s="1.0");r.body=u.build(e.params||{},o);r.headers["Content-Type"]="application/x-amz-json-"+s;r.headers["X-Amz-Target"]=i;n(e)}function extractError(t){var r={};var a=t.httpResponse;r.code=a.headers["x-amzn-errortype"]||"UnknownError";"string"===typeof r.code&&(r.code=r.code.split(":")[0]);if(a.body.length>0)try{var n=JSON.parse(a.body.toString());var i=n.__type||n.code||n.Code;i&&(r.code=i.split("#").pop());"RequestEntityTooLarge"===r.code?r.message="Request body must be less than 1 MB":r.message=n.message||n.Message||null}catch(n){r.statusCode=a.statusCode;r.message=a.statusMessage}else{r.statusCode=a.statusCode;r.message=a.statusCode.toString()}t.error=e.error(new Error,r)}function extractData(e){var t=e.httpResponse.body.toString()||"{}";if(false===e.request.service.config.convertResponseTypes)e.data=JSON.parse(t);else{var a=e.request.service.api.operations[e.request.operation];var n=a.output||{};var i=new r;e.data=i.parse(t,n)}}b={buildRequest:buildRequest,extractError:extractError,extractData:extractData};return b}var T={},C=false;var w="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$4(){if(C)return T;C=true;var e=a();function QueryParamSerializer(){}QueryParamSerializer.prototype.serialize=function(e,t,r){serializeStructure("",e,t,r)};function ucfirst(e){return e.isQueryName||"ec2"!==e.api.protocol?e.name:e.name[0].toUpperCase()+e.name.substr(1)}function serializeStructure(t,r,a,n){e.each(a.members,(function(e,a){var i=r[e];if(null!==i&&void 0!==i){var s=ucfirst(a);s=t?t+"."+s:s;serializeMember(s,i,a,n)}}))}function serializeMap(t,r,a,n){var i=1;e.each(r,(function(e,r){var s=a.flattened?".":".entry.";var o=s+i+++".";var u=o+(a.key.name||"key");var l=o+(a.value.name||"value");serializeMember(t+u,e,a.key,n);serializeMember(t+l,r,a.value,n)}))}function serializeList(t,r,a,n){var i=a.member||{};0!==r.length?e.arrayEach(r,(function(e,r){var s="."+(r+1);if("ec2"===a.api.protocol)s+="";else if(a.flattened){if(i.name){var o=t.split(".");o.pop();o.push(ucfirst(i));t=o.join(".")}}else s="."+(i.name?i.name:"member")+s;serializeMember(t+s,e,i,n)})):n.call(this||w,t,null)}function serializeMember(e,t,r,a){null!==t&&void 0!==t&&("structure"===r.type?serializeStructure(e,t,r,a):"list"===r.type?serializeList(e,t,r,a):"map"===r.type?serializeMap(e,t,r,a):a(e,r.toWireFormat(t).toString()))}T=QueryParamSerializer;return T}var A={},q=false;function dew$5(){if(q)return A;q=true;var r=t?t():e;var i=a();var s=dew$4();var o=n();var u=dew$2().populateHostPrefix;function buildRequest(e){var t=e.service.api.operations[e.operation];var r=e.httpRequest;r.headers["Content-Type"]="application/x-www-form-urlencoded; charset=utf-8";r.params={Version:e.service.api.apiVersion,Action:t.name};var a=new s;a.serialize(e.params,t.input,(function(e,t){r.params[e]=t}));r.body=i.queryParamsToString(r.params);u(e)}function extractError(e){var t,a=e.httpResponse.body.toString();if(a.match("<UnknownOperationException"))t={Code:"UnknownOperation",Message:"Unknown operation "+e.request.operation};else try{t=(new r.XML.Parser).parse(a)}catch(r){t={Code:e.httpResponse.statusCode,Message:e.httpResponse.statusMessage}}t.requestId&&!e.requestId&&(e.requestId=t.requestId);t.Errors&&(t=t.Errors);t.Error&&(t=t.Error);t.Code?e.error=i.error(new Error,{code:t.Code,message:t.Message}):e.error=i.error(new Error,{code:e.httpResponse.statusCode,message:null})}function extractData(e){var t=e.request;var a=t.service.api.operations[t.operation];var n=a.output||{};var s=n;if(s.resultWrapper){var u=o.create({type:"structure"});u.members[s.resultWrapper]=n;u.memberNames=[s.resultWrapper];i.property(n,"name",n.resultWrapper);n=u}var l=new r.XML.Parser;if(n&&n.members&&!n.members._XAMZRequestId){var c=o.create({type:"string"},{api:{protocol:"query"}},"requestId");n.members._XAMZRequestId=c}var d=l.parse(e.httpResponse.body.toString(),n);e.requestId=d._XAMZRequestId||d.requestId;d._XAMZRequestId&&delete d._XAMZRequestId;if(s.resultWrapper&&d[s.resultWrapper]){i.update(d,d[s.resultWrapper]);delete d[s.resultWrapper]}e.data=d}A={buildRequest:buildRequest,extractError:extractError,extractData:extractData};return A}var x={},L=false;function dew$6(){if(L)return x;L=true;var e=a();var t=dew$2().populateHostPrefix;function populateMethod(e){e.httpRequest.method=e.service.api.operations[e.operation].httpMethod}function generateURI(t,r,a,n){var i=[t,r].join("/");i=i.replace(/\/+/g,"/");var s={},o=false;e.each(a.members,(function(t,r){var a=n[t];if(null!==a&&void 0!==a)if("uri"===r.location){var u=new RegExp("\\{"+r.name+"(\\+)?\\}");i=i.replace(u,(function(t,r){var n=r?e.uriEscapePath:e.uriEscape;return n(String(a))}))}else if("querystring"===r.location){o=true;"list"===r.type?s[r.name]=a.map((function(t){return e.uriEscape(r.member.toWireFormat(t).toString())})):"map"===r.type?e.each(a,(function(t,r){Array.isArray(r)?s[t]=r.map((function(t){return e.uriEscape(String(t))})):s[t]=e.uriEscape(String(r))})):s[r.name]=e.uriEscape(r.toWireFormat(a).toString())}}));if(o){i+=i.indexOf("?")>=0?"&":"?";var u=[];e.arrayEach(Object.keys(s).sort(),(function(t){Array.isArray(s[t])||(s[t]=[s[t]]);for(var r=0;r<s[t].length;r++)u.push(e.uriEscape(String(t))+"="+s[t][r])}));i+=u.join("&")}return i}function populateURI(e){var t=e.service.api.operations[e.operation];var r=t.input;var a=generateURI(e.httpRequest.endpoint.path,t.httpPath,r,e.params);e.httpRequest.path=a}function populateHeaders(t){var r=t.service.api.operations[t.operation];e.each(r.input.members,(function(r,a){var n=t.params[r];if(null!==n&&void 0!==n)if("headers"===a.location&&"map"===a.type)e.each(n,(function(e,r){t.httpRequest.headers[a.name+e]=r}));else if("header"===a.location){n=a.toWireFormat(n).toString();a.isJsonValue&&(n=e.base64.encode(n));t.httpRequest.headers[a.name]=n}}))}function buildRequest(e){populateMethod(e);populateURI(e);populateHeaders(e);t(e)}function extractError(){}function extractData(t){var r=t.request;var a={};var n=t.httpResponse;var i=r.service.api.operations[r.operation];var s=i.output;var o={};e.each(n.headers,(function(e,t){o[e.toLowerCase()]=t}));e.each(s.members,(function(t,r){var i=(r.name||t).toLowerCase();if("headers"===r.location&&"map"===r.type){a[t]={};var s=r.isLocationName?r.name:"";var u=new RegExp("^"+s+"(.+)","i");e.each(n.headers,(function(e,r){var n=e.match(u);null!==n&&(a[t][n[1]]=r)}))}else if("header"===r.location){if(void 0!==o[i]){var l=r.isJsonValue?e.base64.decode(o[i]):o[i];a[t]=r.toType(l)}}else"statusCode"===r.location&&(a[t]=parseInt(n.statusCode,10))}));t.data=a}x={buildRequest:buildRequest,extractError:extractError,extractData:extractData,generateURI:generateURI};return x}var P={},D=false;function dew$7(){if(D)return P;D=true;var e=a();var t=dew$6();var r=dew$3();var n=dew();var i=dew$1();function populateBody(e){var t=new n;var r=e.service.api.operations[e.operation].input;if(r.payload){var a={};var i=r.members[r.payload];a=e.params[r.payload];if(void 0===a)return;if("structure"===i.type){e.httpRequest.body=t.build(a,i);applyContentTypeHeader(e)}else{e.httpRequest.body=a;("binary"===i.type||i.isStreaming)&&applyContentTypeHeader(e,true)}}else{var s=t.build(e.params,r);"{}"===s&&"GET"===e.httpRequest.method||(e.httpRequest.body=s);applyContentTypeHeader(e)}}function applyContentTypeHeader(e,t){var r=e.service.api.operations[e.operation];var a=r.input;if(!e.httpRequest.headers["Content-Type"]){var n=t?"binary/octet-stream":"application/json";e.httpRequest.headers["Content-Type"]=n}}function buildRequest(e){t.buildRequest(e);["HEAD","DELETE"].indexOf(e.httpRequest.method)<0&&populateBody(e)}function extractError(e){r.extractError(e)}function extractData(a){t.extractData(a);var n=a.request;var s=n.service.api.operations[n.operation];var o=n.service.api.operations[n.operation].output||{};var u;var l=s.hasEventOutput;if(o.payload){var c=o.members[o.payload];var d=a.httpResponse.body;if(c.isEventStream){u=new i;a.data[payload]=e.createEventStream(2===AWS.HttpClient.streamsApiVersion?a.httpResponse.stream:d,u,c)}else if("structure"===c.type||"list"===c.type){var u=new i;a.data[o.payload]=u.parse(d,c)}else"binary"===c.type||c.isStreaming?a.data[o.payload]=d:a.data[o.payload]=c.toType(d)}else{var p=a.data;r.extractData(a);a.data=e.merge(p,a.data)}}P={buildRequest:buildRequest,extractError:extractError,extractData:extractData};return P}var N={},_=false;function dew$8(){if(_)return N;_=true;var r=t?t():e;var n=a();var i=dew$6();function populateBody(e){var t=e.service.api.operations[e.operation].input;var a=new r.XML.Builder;var i=e.params;var s=t.payload;if(s){var o=t.members[s];i=i[s];if(void 0===i)return;if("structure"===o.type){var u=o.name;e.httpRequest.body=a.toXML(i,o,u,true)}else e.httpRequest.body=i}else e.httpRequest.body=a.toXML(i,t,t.name||t.shape||n.string.upperFirst(e.operation)+"Request")}function buildRequest(e){i.buildRequest(e);["GET","HEAD"].indexOf(e.httpRequest.method)<0&&populateBody(e)}function extractError(e){i.extractError(e);var t;try{t=(new r.XML.Parser).parse(e.httpResponse.body.toString())}catch(r){t={Code:e.httpResponse.statusCode,Message:e.httpResponse.statusMessage}}t.Errors&&(t=t.Errors);t.Error&&(t=t.Error);t.Code?e.error=n.error(new Error,{code:t.Code,message:t.Message}):e.error=n.error(new Error,{code:e.httpResponse.statusCode,message:null})}function extractData(e){i.extractData(e);var t;var a=e.request;var s=e.httpResponse.body;var o=a.service.api.operations[a.operation];var u=o.output;var l=o.hasEventOutput;var c=u.payload;if(c){var d=u.members[c];if(d.isEventStream){t=new r.XML.Parser;e.data[c]=n.createEventStream(2===r.HttpClient.streamsApiVersion?e.httpResponse.stream:e.httpResponse.body,t,d)}else if("structure"===d.type){t=new r.XML.Parser;e.data[c]=t.parse(s.toString(),d)}else"binary"===d.type||d.isStreaming?e.data[c]=s:e.data[c]=d.toType(s)}else if(s.length>0){t=new r.XML.Parser;var p=t.parse(s.toString(),u);n.update(e.data,p)}}N={buildRequest:buildRequest,extractError:extractError,extractData:extractData};return N}var I={},O=false;function dew$9(){if(O)return I;O=true;function escapeAttribute(e){return e.replace(/&/g,"&amp;").replace(/'/g,"&apos;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;")}I={escapeAttribute:escapeAttribute};return I}var k={},H=false;var M="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$a(){if(H)return k;H=true;var e=dew$9().escapeAttribute;function XmlNode(e,t){void 0===t&&(t=[]);(this||M).name=e;(this||M).children=t;(this||M).attributes={}}XmlNode.prototype.addAttribute=function(e,t){(this||M).attributes[e]=t;return this||M};XmlNode.prototype.addChildNode=function(e){(this||M).children.push(e);return this||M};XmlNode.prototype.removeAttribute=function(e){delete(this||M).attributes[e];return this||M};XmlNode.prototype.toString=function(){var t=Boolean((this||M).children.length);var r="<"+(this||M).name;var a=(this||M).attributes;for(var n=0,i=Object.keys(a);n<i.length;n++){var s=i[n];var o=a[s];"undefined"!==typeof o&&null!==o&&(r+=" "+s+'="'+e(""+o)+'"')}return r+=t?">"+(this||M).children.map((function(e){return e.toString()})).join("")+"</"+(this||M).name+">":"/>"};k={XmlNode:XmlNode};return k}var z={},$=false;function dew$b(){if($)return z;$=true;function escapeElement(e){return e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")}z={escapeElement:escapeElement};return z}var U={},V=false;var j="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$c(){if(V)return U;V=true;var e=dew$b().escapeElement;function XmlText(e){(this||j).value=e}XmlText.prototype.toString=function(){return e(""+(this||j).value)};U={XmlText:XmlText};return U}var X={},B=false;function dew$d(){if(B)return X;B=true;var e=a();var t=dew$a().XmlNode;var r=dew$c().XmlText;function XmlBuilder(){}XmlBuilder.prototype.toXML=function(e,r,a,n){var i=new t(a);applyNamespaces(i,r,true);serialize(i,e,r);return i.children.length>0||n?i.toString():""};function serialize(e,t,r){switch(r.type){case"structure":return serializeStructure(e,t,r);case"map":return serializeMap(e,t,r);case"list":return serializeList(e,t,r);default:return serializeScalar(e,t,r)}}function serializeStructure(r,a,n){e.arrayEach(n.memberNames,(function(e){var i=n.members[e];if("body"===i.location){var s=a[e];var o=i.name;if(void 0!==s&&null!==s)if(i.isXmlAttribute)r.addAttribute(o,s);else if(i.flattened)serialize(r,s,i);else{var u=new t(o);r.addChildNode(u);applyNamespaces(u,i);serialize(u,s,i)}}}))}function serializeMap(r,a,n){var i=n.key.name||"key";var s=n.value.name||"value";e.each(a,(function(e,a){var o=new t(n.flattened?n.name:"entry");r.addChildNode(o);var u=new t(i);var l=new t(s);o.addChildNode(u);o.addChildNode(l);serialize(u,e,n.key);serialize(l,a,n.value)}))}function serializeList(r,a,n){n.flattened?e.arrayEach(a,(function(e){var a=n.member.name||n.name;var i=new t(a);r.addChildNode(i);serialize(i,e,n.member)})):e.arrayEach(a,(function(e){var a=n.member.name||"member";var i=new t(a);r.addChildNode(i);serialize(i,e,n.member)}))}function serializeScalar(e,t,a){e.addChildNode(new r(a.toWireFormat(t)))}function applyNamespaces(e,t,r){var a,n="xmlns";if(t.xmlNamespaceUri){a=t.xmlNamespaceUri;t.xmlNamespacePrefix&&(n+=":"+t.xmlNamespacePrefix)}else r&&t.api.xmlNamespaceUri&&(a=t.api.xmlNamespaceUri);a&&e.addAttribute(n,a)}X=XmlBuilder;return X}var K={},F=false;function dew$e(){if(F)return K;F=true;function apiLoader(e,t){if(!apiLoader.services.hasOwnProperty(e))throw new Error("InvalidService: Failed to load api for "+e);return apiLoader.services[e][t]}apiLoader.services={};K=apiLoader;return K}var W={},G=false;function dew$f(){if(G)return W;G=true;Object.defineProperty(W,"__esModule",{value:true});var e=function(){function LinkedListNode(e,t){this.key=e;this.value=t}return LinkedListNode}();var t=function(){function LRUCache(e){this.nodeMap={};this.size=0;if("number"!==typeof e||e<1)throw new Error("Cache size can only be positive number");this.sizeLimit=e}Object.defineProperty(LRUCache.prototype,"length",{get:function(){return this.size},enumerable:true,configurable:true});LRUCache.prototype.prependToList=function(e){if(this.headerNode){this.headerNode.prev=e;e.next=this.headerNode}else this.tailNode=e;this.headerNode=e;this.size++};LRUCache.prototype.removeFromTail=function(){if(this.tailNode){var e=this.tailNode;var t=e.prev;t&&(t.next=void 0);e.prev=void 0;this.tailNode=t;this.size--;return e}};LRUCache.prototype.detachFromList=function(e){this.headerNode===e&&(this.headerNode=e.next);this.tailNode===e&&(this.tailNode=e.prev);e.prev&&(e.prev.next=e.next);e.next&&(e.next.prev=e.prev);e.next=void 0;e.prev=void 0;this.size--};LRUCache.prototype.get=function(e){if(this.nodeMap[e]){var t=this.nodeMap[e];this.detachFromList(t);this.prependToList(t);return t.value}};LRUCache.prototype.remove=function(e){if(this.nodeMap[e]){var t=this.nodeMap[e];this.detachFromList(t);delete this.nodeMap[e]}};LRUCache.prototype.put=function(t,r){if(this.nodeMap[t])this.remove(t);else if(this.size===this.sizeLimit){var a=this.removeFromTail();var n=a.key;delete this.nodeMap[n]}var i=new e(t,r);this.nodeMap[t]=i;this.prependToList(i)};LRUCache.prototype.empty=function(){var e=Object.keys(this.nodeMap);for(var t=0;t<e.length;t++){var r=e[t];var a=this.nodeMap[r];this.detachFromList(a);delete this.nodeMap[r]}};return LRUCache}();W.LRUCache=t;return W}var J={},Z=false;function dew$g(){if(Z)return J;Z=true;Object.defineProperty(J,"__esModule",{value:true});var e=dew$f();var t=1e3;var r=function(){function EndpointCache(r){void 0===r&&(r=t);this.maxSize=r;this.cache=new e.LRUCache(r)}Object.defineProperty(EndpointCache.prototype,"size",{get:function(){return this.cache.length},enumerable:true,configurable:true});EndpointCache.prototype.put=function(e,t){var r="string"!==typeof e?EndpointCache.getKeyString(e):e;var a=this.populateValue(t);this.cache.put(r,a)};EndpointCache.prototype.get=function(e){var t="string"!==typeof e?EndpointCache.getKeyString(e):e;var r=Date.now();var a=this.cache.get(t);if(a)for(var n=0;n<a.length;n++){var i=a[n];if(i.Expire<r){this.cache.remove(t);return}}return a};EndpointCache.getKeyString=function(e){var t=[];var r=Object.keys(e).sort();for(var a=0;a<r.length;a++){var n=r[a];void 0!==e[n]&&t.push(e[n])}return t.join(" ")};EndpointCache.prototype.populateValue=function(e){var t=Date.now();return e.map((function(e){return{Address:e.Address||"",Expire:t+60*(e.CachePeriodInMinutes||1)*1e3}}))};EndpointCache.prototype.empty=function(){this.cache.empty()};EndpointCache.prototype.remove=function(e){var t="string"!==typeof e?EndpointCache.getKeyString(e):e;this.cache.remove(t)};return EndpointCache}();J.EndpointCache=r;return J}var Y={},Q=false;var ee="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$h(){if(Q)return Y;Q=true;var r=t?t():e;
/**
   * @api private
   * @!method on(eventName, callback)
   *   Registers an event listener callback for the event given by `eventName`.
   *   Parameters passed to the callback function depend on the individual event
   *   being triggered. See the event documentation for those parameters.
   *
   *   @param eventName [String] the event name to register the listener for
   *   @param callback [Function] the listener callback function
   *   @param toHead [Boolean] attach the listener callback to the head of callback array if set to true.
   *     Default to be false.
   *   @return [AWS.SequentialExecutor] the same object for chaining
   */r.SequentialExecutor=r.util.inherit({constructor:function SequentialExecutor(){(this||ee)._events={}},listeners:function listeners(e){return(this||ee)._events[e]?(this||ee)._events[e].slice(0):[]},on:function on(e,t,r){(this||ee)._events[e]?r?(this||ee)._events[e].unshift(t):(this||ee)._events[e].push(t):(this||ee)._events[e]=[t];return this||ee},onAsync:function onAsync(e,t,r){t._isAsync=true;return this.on(e,t,r)},removeListener:function removeListener(e,t){var r=(this||ee)._events[e];if(r){var a=r.length;var n=-1;for(var i=0;i<a;++i)r[i]===t&&(n=i);n>-1&&r.splice(n,1)}return this||ee},removeAllListeners:function removeAllListeners(e){e?delete(this||ee)._events[e]:(this||ee)._events={};return this||ee},emit:function emit(e,t,r){r||(r=function(){});var a=this.listeners(e);var n=a.length;this.callListeners(a,t,r);return n>0},callListeners:function callListeners(e,t,a,n){var i=this||ee;var s=n||null;function callNextListener(n){if(n){s=r.util.error(s||new Error,n);if(i._haltHandlersOnError)return a.call(i,s)}i.callListeners(e,t,a,s)}while(e.length>0){var o=e.shift();if(o._isAsync){o.apply(i,t.concat([callNextListener]));return}try{o.apply(i,t)}catch(e){s=r.util.error(s||new Error,e)}if(s&&i._haltHandlersOnError){a.call(i,s);return}}a.call(i,s)},
/**
     * Adds or copies a set of listeners from another list of
     * listeners or SequentialExecutor object.
     *
     * @param listeners [map<String,Array<Function>>, AWS.SequentialExecutor]
     *   a list of events and callbacks, or an event emitter object
     *   containing listeners to add to this emitter object.
     * @return [AWS.SequentialExecutor] the emitter object, for chaining.
     * @example Adding listeners from a map of listeners
     *   emitter.addListeners({
     *     event1: [function() { ... }, function() { ... }],
     *     event2: [function() { ... }]
     *   });
     *   emitter.emit('event1'); // emitter has event1
     *   emitter.emit('event2'); // emitter has event2
     * @example Adding listeners from another emitter object
     *   var emitter1 = new AWS.SequentialExecutor();
     *   emitter1.on('event1', function() { ... });
     *   emitter1.on('event2', function() { ... });
     *   var emitter2 = new AWS.SequentialExecutor();
     *   emitter2.addListeners(emitter1);
     *   emitter2.emit('event1'); // emitter2 has event1
     *   emitter2.emit('event2'); // emitter2 has event2
     */
addListeners:function addListeners(e){var t=this||ee;e._events&&(e=e._events);r.util.each(e,(function(e,a){"function"===typeof a&&(a=[a]);r.util.arrayEach(a,(function(r){t.on(e,r)}))}));return t},
/**
     * Registers an event with {on} and saves the callback handle function
     * as a property on the emitter object using a given `name`.
     *
     * @param name [String] the property name to set on this object containing
     *   the callback function handle so that the listener can be removed in
     *   the future.
     * @param (see on)
     * @return (see on)
     * @example Adding a named listener DATA_CALLBACK
     *   var listener = function() { doSomething(); };
     *   emitter.addNamedListener('DATA_CALLBACK', 'data', listener);
     *
     *   // the following prints: true
     *   console.log(emitter.DATA_CALLBACK == listener);
     */
addNamedListener:function addNamedListener(e,t,r,a){(this||ee)[e]=r;this.addListener(t,r,a);return this||ee},addNamedAsyncListener:function addNamedAsyncListener(e,t,r,a){r._isAsync=true;return this.addNamedListener(e,t,r,a)},
/**
     * Helper method to add a set of named listeners using
     * {addNamedListener}. The callback contains a parameter
     * with a handle to the `addNamedListener` method.
     *
     * @callback callback function(add)
     *   The callback function is called immediately in order to provide
     *   the `add` function to the block. This simplifies the addition of
     *   a large group of named listeners.
     *   @param add [Function] the {addNamedListener} function to call
     *     when registering listeners.
     * @example Adding a set of named listeners
     *   emitter.addNamedListeners(function(add) {
     *     add('DATA_CALLBACK', 'data', function() { ... });
     *     add('OTHER', 'otherEvent', function() { ... });
     *     add('LAST', 'lastEvent', function() { ... });
     *   });
     *
     *   // these properties are now set:
     *   emitter.DATA_CALLBACK;
     *   emitter.OTHER;
     *   emitter.LAST;
     */
addNamedListeners:function addNamedListeners(e){var t=this||ee;e((function(){t.addNamedListener.apply(t,arguments)}),(function(){t.addNamedAsyncListener.apply(t,arguments)}));return this||ee}});r.SequentialExecutor.prototype.addListener=r.SequentialExecutor.prototype.on;Y=r.SequentialExecutor;return Y}var te={},re=false;function dew$i(){if(re)return te;re=true;var n=r;var i=t?t():e;var s=a();var o=["AWS_ENABLE_ENDPOINT_DISCOVERY","AWS_ENDPOINT_DISCOVERY_ENABLED"];function getCacheKey(e){var t=e.service;var r=t.api||{};var a=r.operations;var n={};t.config.region&&(n.region=t.config.region);r.serviceId&&(n.serviceId=r.serviceId);t.config.credentials.accessKeyId&&(n.accessKeyId=t.config.credentials.accessKeyId);return n}function marshallCustomIdentifiersHelper(e,t,r){r&&void 0!==t&&null!==t&&"structure"===r.type&&r.required&&r.required.length>0&&s.arrayEach(r.required,(function(a){var n=r.members[a];if(true===n.endpointDiscoveryId){var i=n.isLocationName?n.name:a;e[i]=String(t[a])}else marshallCustomIdentifiersHelper(e,t[a],n)}))}
/**
   * Get custom identifiers for cache key.
   * Identifies custom identifiers by checking each shape's `endpointDiscoveryId` trait.
   * @param [object] request object
   * @param [object] input shape of the given operation's api
   * @api private
   */function marshallCustomIdentifiers(e,t){var r={};marshallCustomIdentifiersHelper(r,e.params,t);return r}
/**
   * Call endpoint discovery operation when it's optional.
   * When endpoint is available in cache then use the cached endpoints. If endpoints
   * are unavailable then use regional endpoints and call endpoint discovery operation
   * asynchronously. This is turned off by default.
   * @param [object] request object
   * @api private
   */function optionalDiscoverEndpoint(e){var t=e.service;var r=t.api;var a=r.operations?r.operations[e.operation]:void 0;var n=a?a.input:void 0;var o=marshallCustomIdentifiers(e,n);var u=getCacheKey(e);if(Object.keys(o).length>0){u=s.update(u,o);a&&(u.operation=a.name)}var l=i.endpointCache.get(u);if(!l||1!==l.length||""!==l[0].Address)if(l&&l.length>0)e.httpRequest.updateEndpoint(l[0].Address);else{var c=t.makeRequest(r.endpointOperation,{Operation:a.name,Identifiers:o});addApiVersionHeader(c);c.removeListener("validate",i.EventListeners.Core.VALIDATE_PARAMETERS);c.removeListener("retry",i.EventListeners.Core.RETRY_CHECK);i.endpointCache.put(u,[{Address:"",CachePeriodInMinutes:1}]);c.send((function(e,t){t&&t.Endpoints?i.endpointCache.put(u,t.Endpoints):e&&i.endpointCache.put(u,[{Address:"",CachePeriodInMinutes:1}])}))}}var u={};
/**
   * Call endpoint discovery operation when it's required.
   * When endpoint is available in cache then use cached ones. If endpoints are
   * unavailable then SDK should call endpoint operation then use returned new
   * endpoint for the api call. SDK will automatically attempt to do endpoint
   * discovery. This is turned off by default
   * @param [object] request object
   * @api private
   */function requiredDiscoverEndpoint(e,t){var r=e.service;var a=r.api;var n=a.operations?a.operations[e.operation]:void 0;var o=n?n.input:void 0;var l=marshallCustomIdentifiers(e,o);var c=getCacheKey(e);if(Object.keys(l).length>0){c=s.update(c,l);n&&(c.operation=n.name)}var d=i.EndpointCache.getKeyString(c);var p=i.endpointCache.get(d);if(p&&1===p.length&&""===p[0].Address){u[d]||(u[d]=[]);u[d].push({request:e,callback:t})}else if(p&&p.length>0){e.httpRequest.updateEndpoint(p[0].Address);t()}else{var f=r.makeRequest(a.endpointOperation,{Operation:n.name,Identifiers:l});f.removeListener("validate",i.EventListeners.Core.VALIDATE_PARAMETERS);addApiVersionHeader(f);i.endpointCache.put(d,[{Address:"",CachePeriodInMinutes:60}]);f.send((function(r,a){if(r){e.response.error=s.error(r,{retryable:false});i.endpointCache.remove(c);if(u[d]){var n=u[d];s.arrayEach(n,(function(e){e.request.response.error=s.error(r,{retryable:false});e.callback()}));delete u[d]}}else if(a){i.endpointCache.put(d,a.Endpoints);e.httpRequest.updateEndpoint(a.Endpoints[0].Address);if(u[d]){var n=u[d];s.arrayEach(n,(function(e){e.request.httpRequest.updateEndpoint(a.Endpoints[0].Address);e.callback()}));delete u[d]}}t()}))}}function addApiVersionHeader(e){var t=e.service.api;var r=t.apiVersion;r&&!e.httpRequest.headers["x-amz-api-version"]&&(e.httpRequest.headers["x-amz-api-version"]=r)}function invalidateCachedEndpoints(e){var t=e.error;var r=e.httpResponse;if(t&&("InvalidEndpointException"===t.code||421===r.statusCode)){var a=e.request;var n=a.service.api.operations||{};var o=n[a.operation]?n[a.operation].input:void 0;var u=marshallCustomIdentifiers(a,o);var l=getCacheKey(a);if(Object.keys(u).length>0){l=s.update(l,u);n[a.operation]&&(l.operation=n[a.operation].name)}i.endpointCache.remove(l)}}
/**
   * If endpoint is explicitly configured, SDK should not do endpoint discovery in anytime.
   * @param [object] client Service client object.
   * @api private
   */function hasCustomEndpoint(e){if(e._originalConfig&&e._originalConfig.endpoint&&true===e._originalConfig.endpointDiscoveryEnabled)throw s.error(new Error,{code:"ConfigurationException",message:"Custom endpoint is supplied; endpointDiscoveryEnabled must not be true."});var t=i.config[e.serviceIdentifier]||{};return Boolean(i.config.endpoint||t.endpoint||e._originalConfig&&e._originalConfig.endpoint)}function isFalsy(e){return["false","0"].indexOf(e)>=0}
/**
   * If endpoint discovery should perform for this request when no operation requires endpoint
   * discovery for the given service.
   * SDK performs config resolution in order like below:
   * 1. If set in client configuration.
   * 2. If set in env AWS_ENABLE_ENDPOINT_DISCOVERY.
   * 3. If set in shared ini config file with key 'endpoint_discovery_enabled'.
   * @param [object] request request object.
   * @returns [boolean|undefined] if endpoint discovery config is not set in any source, this
   *  function returns undefined
   * @api private
   */function resolveEndpointDiscoveryConfig(e){var t=e.service||{};if(void 0!==t.config.endpointDiscoveryEnabled)return t.config.endpointDiscoveryEnabled;if(!s.isBrowser()){for(var r=0;r<o.length;r++){var a=o[r];if(Object.prototype.hasOwnProperty.call(n.env,a)){if(""===n.env[a]||void 0===n.env[a])throw s.error(new Error,{code:"ConfigurationException",message:"environmental variable "+a+" cannot be set to nothing"});return!isFalsy(n.env[a])}}var u={};try{u=i.util.iniLoader?i.util.iniLoader.loadFrom({isConfig:true,filename:n.env[i.util.sharedConfigFileEnv]}):{}}catch(e){}var l=u[n.env.AWS_PROFILE||i.util.defaultProfile]||{};if(Object.prototype.hasOwnProperty.call(l,"endpoint_discovery_enabled")){if(void 0===l.endpoint_discovery_enabled)throw s.error(new Error,{code:"ConfigurationException",message:"config file entry 'endpoint_discovery_enabled' cannot be set to nothing"});return!isFalsy(l.endpoint_discovery_enabled)}}}
/**
   * attach endpoint discovery logic to request object
   * @param [object] request
   * @api private
   */function discoverEndpoint(e,t){var r=e.service||{};if(hasCustomEndpoint(r)||e.isPresigned())return t();var a=r.api.operations||{};var n=a[e.operation];var i=n?n.endpointDiscoveryRequired:"NULL";var o=resolveEndpointDiscoveryConfig(e);var u=r.api.hasRequiredEndpointDiscovery;(o||u)&&e.httpRequest.appendToUserAgent("endpoint-discovery");switch(i){case"OPTIONAL":if(o||u){optionalDiscoverEndpoint(e);e.addNamedListener("INVALIDATE_CACHED_ENDPOINTS","extractError",invalidateCachedEndpoints)}t();break;case"REQUIRED":if(false===o){e.response.error=s.error(new Error,{code:"ConfigurationException",message:"Endpoint Discovery is disabled but "+r.api.className+"."+e.operation+"() requires it. Please check your configurations."});t();break}e.addNamedListener("INVALIDATE_CACHED_ENDPOINTS","extractError",invalidateCachedEndpoints);requiredDiscoverEndpoint(e,t);break;case"NULL":default:t();break}}te={discoverEndpoint:discoverEndpoint,requiredDiscoverEndpoint:requiredDiscoverEndpoint,optionalDiscoverEndpoint:optionalDiscoverEndpoint,marshallCustomIdentifiers:marshallCustomIdentifiers,getCacheKey:getCacheKey,invalidateCachedEndpoint:invalidateCachedEndpoints};return te}var ae={},ne=false;var ie="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$j(){if(ne)return ae;ne=true;var r=t?t():e;var a=dew$h();var n=dew$i().discoverEndpoint;r.EventListeners={Core:{}};function getOperationAuthtype(e){if(!e.service.api.operations)return"";var t=e.service.api.operations[e.operation];return t?t.authtype:""}r.EventListeners={Core:(new a).addNamedListeners((function(e,t){t("VALIDATE_CREDENTIALS","validate",(function VALIDATE_CREDENTIALS(e,t){if(!e.service.api.signatureVersion&&!e.service.config.signatureVersion)return t();e.service.config.getCredentials((function(a){a&&(e.response.error=r.util.error(a,{code:"CredentialsError",message:"Missing credentials in config, if using AWS_CONFIG_FILE, set AWS_SDK_LOAD_CONFIG=1"}));t()}))}));e("VALIDATE_REGION","validate",(function VALIDATE_REGION(e){if(!e.service.isGlobalEndpoint){var t=new RegExp(/^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9])$/);e.service.config.region?t.test(e.service.config.region)||(e.response.error=r.util.error(new Error,{code:"ConfigError",message:"Invalid region in config"})):e.response.error=r.util.error(new Error,{code:"ConfigError",message:"Missing region in config"})}}));e("BUILD_IDEMPOTENCY_TOKENS","validate",(function BUILD_IDEMPOTENCY_TOKENS(e){if(e.service.api.operations){var t=e.service.api.operations[e.operation];if(t){var a=t.idempotentMembers;if(a.length){var n=r.util.copy(e.params);for(var i=0,s=a.length;i<s;i++)n[a[i]]||(n[a[i]]=r.util.uuid.v4());e.params=n}}}}));e("VALIDATE_PARAMETERS","validate",(function VALIDATE_PARAMETERS(e){if(e.service.api.operations){var t=e.service.api.operations[e.operation].input;var a=e.service.config.paramValidation;new r.ParamValidator(a).validate(t,e.params)}}));t("COMPUTE_SHA256","afterBuild",(function COMPUTE_SHA256(e,t){e.haltHandlersOnError();if(e.service.api.operations){var a=e.service.api.operations[e.operation];var n=a?a.authtype:"";if(!e.service.api.signatureVersion&&!n&&!e.service.config.signatureVersion)return t();if(e.service.getSignerClass(e)===r.Signers.V4){var i=e.httpRequest.body||"";if(n.indexOf("unsigned-body")>=0){e.httpRequest.headers["X-Amz-Content-Sha256"]="UNSIGNED-PAYLOAD";return t()}r.util.computeSha256(i,(function(r,a){if(r)t(r);else{e.httpRequest.headers["X-Amz-Content-Sha256"]=a;t()}}))}else t()}}));e("SET_CONTENT_LENGTH","afterBuild",(function SET_CONTENT_LENGTH(e){var t=getOperationAuthtype(e);var a=r.util.getRequestPayloadShape(e);if(void 0===e.httpRequest.headers["Content-Length"])try{var n=r.util.string.byteLength(e.httpRequest.body);e.httpRequest.headers["Content-Length"]=n}catch(r){if(a&&a.isStreaming){if(a.requiresLength)throw r;if(t.indexOf("unsigned-body")>=0){e.httpRequest.headers["Transfer-Encoding"]="chunked";return}throw r}throw r}}));e("SET_HTTP_HOST","afterBuild",(function SET_HTTP_HOST(e){e.httpRequest.headers["Host"]=e.httpRequest.endpoint.host}));e("RESTART","restart",(function RESTART(){var e=(this||ie).response.error;if(e&&e.retryable){(this||ie).httpRequest=new r.HttpRequest((this||ie).service.endpoint,(this||ie).service.region);(this||ie).response.retryCount<(this||ie).service.config.maxRetries?(this||ie).response.retryCount++:(this||ie).response.error=null}}));var a=true;t("DISCOVER_ENDPOINT","sign",n,a);t("SIGN","sign",(function SIGN(e,t){var r=e.service;var a=e.service.api.operations||{};var n=a[e.operation];var i=n?n.authtype:"";if(!r.api.signatureVersion&&!i&&!r.config.signatureVersion)return t();r.config.getCredentials((function(a,i){if(a){e.response.error=a;return t()}try{var s=r.getSkewCorrectedDate();var o=r.getSignerClass(e);var u=new o(e.httpRequest,r.api.signingName||r.api.endpointPrefix,{signatureCache:r.config.signatureCache,operation:n,signatureVersion:r.api.signatureVersion});u.setServiceClientId(r._clientId);delete e.httpRequest.headers["Authorization"];delete e.httpRequest.headers["Date"];delete e.httpRequest.headers["X-Amz-Date"];u.addAuthorization(i,s);e.signedAt=s}catch(t){e.response.error=t}t()}))}));e("VALIDATE_RESPONSE","validateResponse",(function VALIDATE_RESPONSE(e){if((this||ie).service.successfulResponse(e,this||ie)){e.data={};e.error=null}else{e.data=null;e.error=r.util.error(new Error,{code:"UnknownError",message:"An unknown error occurred."})}}));t("SEND","send",(function SEND(e,t){e.httpResponse._abortCallback=t;e.error=null;e.data=null;function callback(a){e.httpResponse.stream=a;var n=e.request.httpRequest.stream;var i=e.request.service;var s=i.api;var o=e.request.operation;var u=s.operations[o]||{};a.on("headers",(function onHeaders(n,s,o){e.request.emit("httpHeaders",[n,s,e,o]);if(!e.httpResponse.streaming)if(2===r.HttpClient.streamsApiVersion){if(u.hasEventOutput&&i.successfulResponse(e)){e.request.emit("httpDone");t();return}a.on("readable",(function onReadable(){var t=a.read();null!==t&&e.request.emit("httpData",[t,e])}))}else a.on("data",(function onData(t){e.request.emit("httpData",[t,e])}))}));a.on("end",(function onEnd(){if(!n||!n.didCallback){if(2===r.HttpClient.streamsApiVersion&&u.hasEventOutput&&i.successfulResponse(e))return;e.request.emit("httpDone");t()}}))}function progress(t){t.on("sendProgress",(function onSendProgress(t){e.request.emit("httpUploadProgress",[t,e])}));t.on("receiveProgress",(function onReceiveProgress(t){e.request.emit("httpDownloadProgress",[t,e])}))}function error(a){if("RequestAbortedError"!==a.code){var n="TimeoutError"===a.code?a.code:"NetworkingError";a=r.util.error(a,{code:n,region:e.request.httpRequest.region,hostname:e.request.httpRequest.endpoint.hostname,retryable:true})}e.error=a;e.request.emit("httpError",[e.error,e],(function(){t()}))}function executeSend(){var t=r.HttpClient.getInstance();var a=e.request.service.config.httpOptions||{};try{var n=t.handleRequest(e.request.httpRequest,a,callback,error);progress(n)}catch(e){error(e)}}var a=(e.request.service.getSkewCorrectedDate()-(this||ie).signedAt)/1e3;a>=60*10?this.emit("sign",[this||ie],(function(e){e?t(e):executeSend()})):executeSend()}));e("HTTP_HEADERS","httpHeaders",(function HTTP_HEADERS(e,t,a,n){a.httpResponse.statusCode=e;a.httpResponse.statusMessage=n;a.httpResponse.headers=t;a.httpResponse.body=r.util.buffer.toBuffer("");a.httpResponse.buffers=[];a.httpResponse.numBytes=0;var i=t.date||t.Date;var s=a.request.service;if(i){var o=Date.parse(i);s.config.correctClockSkew&&s.isClockSkewed(o)&&s.applyClockOffset(o)}}));e("HTTP_DATA","httpData",(function HTTP_DATA(e,t){if(e){if(r.util.isNode()){t.httpResponse.numBytes+=e.length;var a=t.httpResponse.headers["content-length"];var n={loaded:t.httpResponse.numBytes,total:a};t.request.emit("httpDownloadProgress",[n,t])}t.httpResponse.buffers.push(r.util.buffer.toBuffer(e))}}));e("HTTP_DONE","httpDone",(function HTTP_DONE(e){if(e.httpResponse.buffers&&e.httpResponse.buffers.length>0){var t=r.util.buffer.concat(e.httpResponse.buffers);e.httpResponse.body=t}delete e.httpResponse.numBytes;delete e.httpResponse.buffers}));e("FINALIZE_ERROR","retry",(function FINALIZE_ERROR(e){if(e.httpResponse.statusCode){e.error.statusCode=e.httpResponse.statusCode;void 0===e.error.retryable&&(e.error.retryable=(this||ie).service.retryableError(e.error,this||ie))}}));e("INVALIDATE_CREDENTIALS","retry",(function INVALIDATE_CREDENTIALS(e){if(e.error)switch(e.error.code){case"RequestExpired":case"ExpiredTokenException":case"ExpiredToken":e.error.retryable=true;e.request.service.config.credentials.expired=true}}));e("EXPIRED_SIGNATURE","retry",(function EXPIRED_SIGNATURE(e){var t=e.error;t&&"string"===typeof t.code&&"string"===typeof t.message&&t.code.match(/Signature/)&&t.message.match(/expired/)&&(e.error.retryable=true)}));e("CLOCK_SKEWED","retry",(function CLOCK_SKEWED(e){e.error&&(this||ie).service.clockSkewError(e.error)&&(this||ie).service.config.correctClockSkew&&(e.error.retryable=true)}));e("REDIRECT","retry",(function REDIRECT(e){if(e.error&&e.error.statusCode>=300&&e.error.statusCode<400&&e.httpResponse.headers["location"]){(this||ie).httpRequest.endpoint=new r.Endpoint(e.httpResponse.headers["location"]);(this||ie).httpRequest.headers["Host"]=(this||ie).httpRequest.endpoint.host;e.error.redirect=true;e.error.retryable=true}}));e("RETRY_CHECK","retry",(function RETRY_CHECK(e){e.error&&(e.error.redirect&&e.redirectCount<e.maxRedirects?e.error.retryDelay=0:e.retryCount<e.maxRetries&&(e.error.retryDelay=(this||ie).service.retryDelays(e.retryCount,e.error)||0))}));t("RESET_RETRY_STATE","afterRetry",(function RESET_RETRY_STATE(e,t){var r,a=false;if(e.error){r=e.error.retryDelay||0;if(e.error.retryable&&e.retryCount<e.maxRetries){e.retryCount++;a=true}else if(e.error.redirect&&e.redirectCount<e.maxRedirects){e.redirectCount++;a=true}}if(a&&r>=0){e.error=null;setTimeout(t,r)}else t()}))})),CorePost:(new a).addNamedListeners((function(e){e("EXTRACT_REQUEST_ID","extractData",r.util.extractRequestId);e("EXTRACT_REQUEST_ID","extractError",r.util.extractRequestId);e("ENOTFOUND_ERROR","httpError",(function ENOTFOUND_ERROR(e){function isDNSError(e){return"ENOTFOUND"===e.errno||"number"===typeof e.errno&&"function"===typeof r.util.getSystemErrorName&&["EAI_NONAME","EAI_NODATA"].indexOf(r.util.getSystemErrorName(e.errno)>=0)}if("NetworkingError"===e.code&&isDNSError(e)){var t="Inaccessible host: `"+e.hostname+"'. This service may not be available in the `"+e.region+"' region.";(this||ie).response.error=r.util.error(new Error(t),{code:"UnknownEndpoint",region:e.region,hostname:e.hostname,retryable:true,originalError:e})}}))})),Logger:(new a).addNamedListeners((function(e){e("LOG_REQUEST","complete",(function LOG_REQUEST(e){var t=e.request;var a=t.service.config.logger;if(a){var n=buildMessage();"function"===typeof a.log?a.log(n):"function"===typeof a.write&&a.write(n+"\n")}function filterSensitiveLog(e,t){if(!t)return t;if(e.isSensitive)return"***SensitiveInformation***";switch(e.type){case"structure":var a={};r.util.each(t,(function(t,r){Object.prototype.hasOwnProperty.call(e.members,t)?a[t]=filterSensitiveLog(e.members[t],r):a[t]=r}));return a;case"list":var n=[];r.util.arrayEach(t,(function(t,r){n.push(filterSensitiveLog(e.member,t))}));return n;case"map":var i={};r.util.each(t,(function(t,r){i[t]=filterSensitiveLog(e.value,r)}));return i;default:return t}}function buildMessage(){var n=e.request.service.getSkewCorrectedDate().getTime();var i=(n-t.startTime.getTime())/1e3;var s=!!a.isTTY;var o=e.httpResponse.statusCode;var u=t.params;if(t.service.api.operations&&t.service.api.operations[t.operation]&&t.service.api.operations[t.operation].input){var l=t.service.api.operations[t.operation].input;u=filterSensitiveLog(l,t.params)}var c=p.inspect(u,true,null);var d="";s&&(d+="[33m");d+="[AWS "+t.service.serviceIdentifier+" "+o;d+=" "+i.toString()+"s "+e.retryCount+" retries]";s&&(d+="[0;1m");d+=" "+r.util.string.lowerFirst(t.operation);d+="("+c+")";s&&(d+="[0m");return d}}))})),Json:(new a).addNamedListeners((function(e){var t=dew$3();e("BUILD","build",t.buildRequest);e("EXTRACT_DATA","extractData",t.extractData);e("EXTRACT_ERROR","extractError",t.extractError)})),Rest:(new a).addNamedListeners((function(e){var t=dew$6();e("BUILD","build",t.buildRequest);e("EXTRACT_DATA","extractData",t.extractData);e("EXTRACT_ERROR","extractError",t.extractError)})),RestJson:(new a).addNamedListeners((function(e){var t=dew$7();e("BUILD","build",t.buildRequest);e("EXTRACT_DATA","extractData",t.extractData);e("EXTRACT_ERROR","extractError",t.extractError)})),RestXml:(new a).addNamedListeners((function(e){var t=dew$8();e("BUILD","build",t.buildRequest);e("EXTRACT_DATA","extractData",t.extractData);e("EXTRACT_ERROR","extractError",t.extractError)})),Query:(new a).addNamedListeners((function(e){var t=dew$5();e("BUILD","build",t.buildRequest);e("EXTRACT_DATA","extractData",t.extractData);e("EXTRACT_ERROR","extractError",t.extractError)}))};return ae}var se={},oe=false;var ue="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$k(){if(oe)return se;oe=true;function AcceptorStateMachine(e,t){(this||ue).currentState=t||null;(this||ue).states=e||{}}AcceptorStateMachine.prototype.runTo=function runTo(e,t,r,a){if("function"===typeof e){a=r;r=t;t=e;e=null}var n=this||ue;var i=n.states[n.currentState];i.fn.call(r||n,a,(function(a){if(a){if(!i.fail)return t?t.call(r,a):null;n.currentState=i.fail}else{if(!i.accept)return t?t.call(r):null;n.currentState=i.accept}if(n.currentState===e)return t?t.call(r,a):null;n.runTo(e,t,r,a)}))};AcceptorStateMachine.prototype.addState=function addState(e,t,r,a){if("function"===typeof t){a=t;t=null;r=null}else if("function"===typeof r){a=r;r=null}(this||ue).currentState||((this||ue).currentState=e);(this||ue).states[e]={accept:t,fail:r,fn:a};return this||ue};se=AcceptorStateMachine;return se}var le={},ce=false;var de="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$l(){if(ce)return le;ce=true;var a=r;var n=t?t():e;var i=dew$k();var s=n.util.inherit;var o=n.util.domain;var u=f;var l={success:1,error:1,complete:1};function isTerminalState(e){return Object.prototype.hasOwnProperty.call(l,e._asm.currentState)}var c=new i;c.setupStates=function(){var transition=function(e,t){var r=this||de;r._haltHandlersOnError=false;r.emit(r._asm.currentState,(function(e){if(e)if(isTerminalState(r)){if(!(o&&r.domain instanceof o.Domain))throw e;e.domainEmitter=r;e.domain=r.domain;e.domainThrown=false;r.domain.emit("error",e)}else{r.response.error=e;t(e)}else t(r.response.error)}))};this.addState("validate","build","error",transition);this.addState("build","afterBuild","restart",transition);this.addState("afterBuild","sign","restart",transition);this.addState("sign","send","retry",transition);this.addState("retry","afterRetry","afterRetry",transition);this.addState("afterRetry","sign","error",transition);this.addState("send","validateResponse","retry",transition);this.addState("validateResponse","extractData","extractError",transition);this.addState("extractError","extractData","retry",transition);this.addState("extractData","success","retry",transition);this.addState("restart","build","error",transition);this.addState("success","complete","complete",transition);this.addState("error","complete","complete",transition);this.addState("complete",null,null,transition)};c.setupStates();
/**
   * ## Asynchronous Requests
   *
   * All requests made through the SDK are asynchronous and use a
   * callback interface. Each service method that kicks off a request
   * returns an `AWS.Request` object that you can use to register
   * callbacks.
   *
   * For example, the following service method returns the request
   * object as "request", which can be used to register callbacks:
   *
   * ```javascript
   * // request is an AWS.Request object
   * var request = ec2.describeInstances();
   *
   * // register callbacks on request to retrieve response data
   * request.on('success', function(response) {
   *   console.log(response.data);
   * });
   * ```
   *
   * When a request is ready to be sent, the {send} method should
   * be called:
   *
   * ```javascript
   * request.send();
   * ```
   *
   * Since registered callbacks may or may not be idempotent, requests should only
   * be sent once. To perform the same operation multiple times, you will need to
   * create multiple request objects, each with its own registered callbacks.
   *
   * ## Removing Default Listeners for Events
   *
   * Request objects are built with default listeners for the various events,
   * depending on the service type. In some cases, you may want to remove
   * some built-in listeners to customize behaviour. Doing this requires
   * access to the built-in listener functions, which are exposed through
   * the {AWS.EventListeners.Core} namespace. For instance, you may
   * want to customize the HTTP handler used when sending a request. In this
   * case, you can remove the built-in listener associated with the 'send'
   * event, the {AWS.EventListeners.Core.SEND} listener and add your own.
   *
   * ## Multiple Callbacks and Chaining
   *
   * You can register multiple callbacks on any request object. The
   * callbacks can be registered for different events, or all for the
   * same event. In addition, you can chain callback registration, for
   * example:
   *
   * ```javascript
   * request.
   *   on('success', function(response) {
   *     console.log("Success!");
   *   }).
   *   on('error', function(error, response) {
   *     console.log("Error!");
   *   }).
   *   on('complete', function(response) {
   *     console.log("Always!");
   *   }).
   *   send();
   * ```
   *
   * The above example will print either "Success! Always!", or "Error! Always!",
   * depending on whether the request succeeded or not.
   *
   * @!attribute httpRequest
   *   @readonly
   *   @!group HTTP Properties
   *   @return [AWS.HttpRequest] the raw HTTP request object
   *     containing request headers and body information
   *     sent by the service.
   *
   * @!attribute startTime
   *   @readonly
   *   @!group Operation Properties
   *   @return [Date] the time that the request started
   *
   * @!group Request Building Events
   *
   * @!event validate(request)
   *   Triggered when a request is being validated. Listeners
   *   should throw an error if the request should not be sent.
   *   @param request [Request] the request object being sent
   *   @see AWS.EventListeners.Core.VALIDATE_CREDENTIALS
   *   @see AWS.EventListeners.Core.VALIDATE_REGION
   *   @example Ensuring that a certain parameter is set before sending a request
   *     var req = s3.putObject(params);
   *     req.on('validate', function() {
   *       if (!req.params.Body.match(/^Hello\s/)) {
   *         throw new Error('Body must start with "Hello "');
   *       }
   *     });
   *     req.send(function(err, data) { ... });
   *
   * @!event build(request)
   *   Triggered when the request payload is being built. Listeners
   *   should fill the necessary information to send the request
   *   over HTTP.
   *   @param (see AWS.Request~validate)
   *   @example Add a custom HTTP header to a request
   *     var req = s3.putObject(params);
   *     req.on('build', function() {
   *       req.httpRequest.headers['Custom-Header'] = 'value';
   *     });
   *     req.send(function(err, data) { ... });
   *
   * @!event sign(request)
   *   Triggered when the request is being signed. Listeners should
   *   add the correct authentication headers and/or adjust the body,
   *   depending on the authentication mechanism being used.
   *   @param (see AWS.Request~validate)
   *
   * @!group Request Sending Events
   *
   * @!event send(response)
   *   Triggered when the request is ready to be sent. Listeners
   *   should call the underlying transport layer to initiate
   *   the sending of the request.
   *   @param response [Response] the response object
   *   @context [Request] the request object that was sent
   *   @see AWS.EventListeners.Core.SEND
   *
   * @!event retry(response)
   *   Triggered when a request failed and might need to be retried or redirected.
   *   If the response is retryable, the listener should set the
   *   `response.error.retryable` property to `true`, and optionally set
   *   `response.error.retryDelay` to the millisecond delay for the next attempt.
   *   In the case of a redirect, `response.error.redirect` should be set to
   *   `true` with `retryDelay` set to an optional delay on the next request.
   *
   *   If a listener decides that a request should not be retried,
   *   it should set both `retryable` and `redirect` to false.
   *
   *   Note that a retryable error will be retried at most
   *   {AWS.Config.maxRetries} times (based on the service object's config).
   *   Similarly, a request that is redirected will only redirect at most
   *   {AWS.Config.maxRedirects} times.
   *
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *   @example Adding a custom retry for a 404 response
   *     request.on('retry', function(response) {
   *       // this resource is not yet available, wait 10 seconds to get it again
   *       if (response.httpResponse.statusCode === 404 && response.error) {
   *         response.error.retryable = true;   // retry this error
   *         response.error.retryDelay = 10000; // wait 10 seconds
   *       }
   *     });
   *
   * @!group Data Parsing Events
   *
   * @!event extractError(response)
   *   Triggered on all non-2xx requests so that listeners can extract
   *   error details from the response body. Listeners to this event
   *   should set the `response.error` property.
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *
   * @!event extractData(response)
   *   Triggered in successful requests to allow listeners to
   *   de-serialize the response body into `response.data`.
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *
   * @!group Completion Events
   *
   * @!event success(response)
   *   Triggered when the request completed successfully.
   *   `response.data` will contain the response data and
   *   `response.error` will be null.
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *
   * @!event error(error, response)
   *   Triggered when an error occurs at any point during the
   *   request. `response.error` will contain details about the error
   *   that occurred. `response.data` will be null.
   *   @param error [Error] the error object containing details about
   *     the error that occurred.
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *
   * @!event complete(response)
   *   Triggered whenever a request cycle completes. `response.error`
   *   should be checked, since the request may have failed.
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *
   * @!group HTTP Events
   *
   * @!event httpHeaders(statusCode, headers, response, statusMessage)
   *   Triggered when headers are sent by the remote server
   *   @param statusCode [Integer] the HTTP response code
   *   @param headers [map<String,String>] the response headers
   *   @param (see AWS.Request~send)
   *   @param statusMessage [String] A status message corresponding to the HTTP
   *                                 response code
   *   @context (see AWS.Request~send)
   *
   * @!event httpData(chunk, response)
   *   Triggered when data is sent by the remote server
   *   @param chunk [Buffer] the buffer data containing the next data chunk
   *     from the server
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *   @see AWS.EventListeners.Core.HTTP_DATA
   *
   * @!event httpUploadProgress(progress, response)
   *   Triggered when the HTTP request has uploaded more data
   *   @param progress [map] An object containing the `loaded` and `total` bytes
   *     of the request.
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *   @note This event will not be emitted in Node.js 0.8.x.
   *
   * @!event httpDownloadProgress(progress, response)
   *   Triggered when the HTTP request has downloaded more data
   *   @param progress [map] An object containing the `loaded` and `total` bytes
   *     of the request.
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *   @note This event will not be emitted in Node.js 0.8.x.
   *
   * @!event httpError(error, response)
   *   Triggered when the HTTP request failed
   *   @param error [Error] the error object that was thrown
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *
   * @!event httpDone(response)
   *   Triggered when the server is finished sending data
   *   @param (see AWS.Request~send)
   *   @context (see AWS.Request~send)
   *
   * @see AWS.Response
   */n.Request=s({
/**
     * Creates a request for an operation on a given service with
     * a set of input parameters.
     *
     * @param service [AWS.Service] the service to perform the operation on
     * @param operation [String] the operation to perform on the service
     * @param params [Object] parameters to send to the operation.
     *   See the operation's documentation for the format of the
     *   parameters.
     */
constructor:function Request(e,t,r){var a=e.endpoint;var s=e.config.region;var u=e.config.customUserAgent;e.isGlobalEndpoint&&(s=e.signingRegion?e.signingRegion:"us-east-1");(this||de).domain=o&&o.active;(this||de).service=e;(this||de).operation=t;(this||de).params=r||{};(this||de).httpRequest=new n.HttpRequest(a,s);(this||de).httpRequest.appendToUserAgent(u);(this||de).startTime=e.getSkewCorrectedDate();(this||de).response=new n.Response(this||de);(this||de)._asm=new i(c.states,"validate");(this||de)._haltHandlersOnError=false;n.SequentialExecutor.call(this||de);(this||de).emit=(this||de).emitEvent},
/**
     * @overload send(callback = null)
     *   Sends the request object.
     *
     *   @callback callback function(err, data)
     *     If a callback is supplied, it is called when a response is returned
     *     from the service.
     *     @context [AWS.Request] the request object being sent.
     *     @param err [Error] the error object returned from the request.
     *       Set to `null` if the request is successful.
     *     @param data [Object] the de-serialized data returned from
     *       the request. Set to `null` if a request error occurs.
     *   @example Sending a request with a callback
     *     request = s3.putObject({Bucket: 'bucket', Key: 'key'});
     *     request.send(function(err, data) { console.log(err, data); });
     *   @example Sending a request with no callback (using event handlers)
     *     request = s3.putObject({Bucket: 'bucket', Key: 'key'});
     *     request.on('complete', function(response) { ... }); // register a callback
     *     request.send();
     */
send:function send(e){if(e){(this||de).httpRequest.appendToUserAgent("callback");this.on("complete",(function(t){e.call(t,t.error,t.data)}))}this.runTo();return(this||de).response},
/**
     * @!method  promise()
     *   Sends the request and returns a 'thenable' promise.
     *
     *   Two callbacks can be provided to the `then` method on the returned promise.
     *   The first callback will be called if the promise is fulfilled, and the second
     *   callback will be called if the promise is rejected.
     *   @callback fulfilledCallback function(data)
     *     Called if the promise is fulfilled.
     *     @param data [Object] the de-serialized data returned from the request.
     *   @callback rejectedCallback function(error)
     *     Called if the promise is rejected.
     *     @param error [Error] the error object returned from the request.
     *   @return [Promise] A promise that represents the state of the request.
     *   @example Sending a request using promises.
     *     var request = s3.putObject({Bucket: 'bucket', Key: 'key'});
     *     var result = request.promise();
     *     result.then(function(data) { ... }, function(error) { ... });
     */
build:function build(e){return this.runTo("send",e)},runTo:function runTo(e,t){(this||de)._asm.runTo(e,t,this||de);return this||de},abort:function abort(){this.removeAllListeners("validateResponse");this.removeAllListeners("extractError");this.on("validateResponse",(function addAbortedError(e){e.error=n.util.error(new Error("Request aborted by user"),{code:"RequestAbortedError",retryable:false})}));if((this||de).httpRequest.stream&&!(this||de).httpRequest.stream.didCallback){(this||de).httpRequest.stream.abort();(this||de).httpRequest._abortCallback?(this||de).httpRequest._abortCallback():this.removeAllListeners("send")}return this||de},
/**
     * Iterates over each page of results given a pageable request, calling
     * the provided callback with each page of data. After all pages have been
     * retrieved, the callback is called with `null` data.
     *
     * @note This operation can generate multiple requests to a service.
     * @example Iterating over multiple pages of objects in an S3 bucket
     *   var pages = 1;
     *   s3.listObjects().eachPage(function(err, data) {
     *     if (err) return;
     *     console.log("Page", pages++);
     *     console.log(data);
     *   });
     * @example Iterating over multiple pages with an asynchronous callback
     *   s3.listObjects(params).eachPage(function(err, data, done) {
     *     doSomethingAsyncAndOrExpensive(function() {
     *       // The next page of results isn't fetched until done is called
     *       done();
     *     });
     *   });
     * @callback callback function(err, data, [doneCallback])
     *   Called with each page of resulting data from the request. If the
     *   optional `doneCallback` is provided in the function, it must be called
     *   when the callback is complete.
     *
     *   @param err [Error] an error object, if an error occurred.
     *   @param data [Object] a single page of response data. If there is no
     *     more data, this object will be `null`.
     *   @param doneCallback [Function] an optional done callback. If this
     *     argument is defined in the function declaration, it should be called
     *     when the next page is ready to be retrieved. This is useful for
     *     controlling serial pagination across asynchronous operations.
     *   @return [Boolean] if the callback returns `false`, pagination will
     *     stop.
     *
     * @see AWS.Request.eachItem
     * @see AWS.Response.nextPage
     * @since v1.4.0
     */
eachPage:function eachPage(e){e=n.util.fn.makeAsync(e,3);function wrappedCallback(t){e.call(t,t.error,t.data,(function(r){false!==r&&(t.hasNextPage()?t.nextPage().on("complete",wrappedCallback).send():e.call(t,null,null,n.util.fn.noop))}))}this.on("complete",wrappedCallback).send()},eachItem:function eachItem(e){var t=this||de;function wrappedCallback(r,a){if(r)return e(r,null);if(null===a)return e(null,null);var i=t.service.paginationConfig(t.operation);var s=i.resultKey;Array.isArray(s)&&(s=s[0]);var o=u.search(a,s);var l=true;n.util.arrayEach(o,(function(t){l=e(null,t);if(false===l)return n.util.abort}));return l}this.eachPage(wrappedCallback)},isPageable:function isPageable(){return!!(this||de).service.paginationConfig((this||de).operation)},createReadStream:function createReadStream(){var e=n.util.stream;var t=this||de;var r=null;if(2===n.HttpClient.streamsApiVersion){r=new e.PassThrough;a.nextTick((function(){t.send()}))}else{r=new e.Stream;r.readable=true;r.sent=false;r.on("newListener",(function(e){if(!r.sent&&"data"===e){r.sent=true;a.nextTick((function(){t.send()}))}}))}this.on("error",(function(e){r.emit("error",e)}));this.on("httpHeaders",(function streamHeaders(a,i,s){if(a<300){t.removeListener("httpData",n.EventListeners.Core.HTTP_DATA);t.removeListener("httpError",n.EventListeners.Core.HTTP_ERROR);t.on("httpError",(function streamHttpError(e){s.error=e;s.error.retryable=false}));var o=false;var u;"HEAD"!==t.httpRequest.method&&(u=parseInt(i["content-length"],10));if(void 0!==u&&!isNaN(u)&&u>=0){o=true;var l=0}var c=function checkContentLengthAndEmit(){o&&l!==u?r.emit("error",n.util.error(new Error("Stream content length mismatch. Received "+l+" of "+u+" bytes."),{code:"StreamContentLengthMismatch"})):2===n.HttpClient.streamsApiVersion?r.end():r.emit("end")};var d=s.httpResponse.createUnbufferedStream();if(2===n.HttpClient.streamsApiVersion)if(o){var p=new e.PassThrough;p._write=function(t){t&&t.length&&(l+=t.length);return e.PassThrough.prototype._write.apply(this||de,arguments)};p.on("end",c);r.on("error",(function(e){o=false;d.unpipe(p);p.emit("end");p.end()}));d.pipe(p).pipe(r,{end:false})}else d.pipe(r);else{o&&d.on("data",(function(e){e&&e.length&&(l+=e.length)}));d.on("data",(function(e){r.emit("data",e)}));d.on("end",c)}d.on("error",(function(e){o=false;r.emit("error",e)}))}}));return r},
/**
     * @param [Array,Response] args This should be the response object,
     *   or an array of args to send to the event.
     * @api private
     */
emitEvent:function emit(e,t,r){if("function"===typeof t){r=t;t=null}r||(r=function(){});t||(t=this.eventParameters(e,(this||de).response));var a=n.SequentialExecutor.prototype.emit;a.call(this||de,e,t,(function(e){e&&((this||de).response.error=e);r.call(this||de,e)}))},eventParameters:function eventParameters(e){switch(e){case"restart":case"validate":case"sign":case"build":case"afterValidate":case"afterBuild":return[this||de];case"error":return[(this||de).response.error,(this||de).response];default:return[(this||de).response]}},presign:function presign(e,t){if(!t&&"function"===typeof e){t=e;e=null}return(new n.Signers.Presign).sign(this.toGet(),e,t)},isPresigned:function isPresigned(){return Object.prototype.hasOwnProperty.call((this||de).httpRequest.headers,"presigned-expires")},toUnauthenticated:function toUnauthenticated(){(this||de)._unAuthenticated=true;this.removeListener("validate",n.EventListeners.Core.VALIDATE_CREDENTIALS);this.removeListener("sign",n.EventListeners.Core.SIGN);return this||de},toGet:function toGet(){if("query"===(this||de).service.api.protocol||"ec2"===(this||de).service.api.protocol){this.removeListener("build",(this||de).buildAsGet);this.addListener("build",(this||de).buildAsGet)}return this||de},buildAsGet:function buildAsGet(e){e.httpRequest.method="GET";e.httpRequest.path=e.service.endpoint.path+"?"+e.httpRequest.body;e.httpRequest.body="";delete e.httpRequest.headers["Content-Length"];delete e.httpRequest.headers["Content-Type"]},haltHandlersOnError:function haltHandlersOnError(){(this||de)._haltHandlersOnError=true}});n.Request.addPromisesToClass=function addPromisesToClass(e){(this||de).prototype.promise=function promise(){var t=this||de;(this||de).httpRequest.appendToUserAgent("promise");return new e((function(e,r){t.on("complete",(function(t){t.error?r(t.error):e(Object.defineProperty(t.data||{},"$response",{value:t}))}));t.runTo()}))}};n.Request.deletePromisesFromClass=function deletePromisesFromClass(){delete(this||de).prototype.promise};n.util.addPromises(n.Request);n.util.mixin(n.Request,n.SequentialExecutor);return le}var pe={},fe=false;var he="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$m(){if(fe)return pe;fe=true;var r=t?t():e;var a=r.util.inherit;var n=f;r.Response=a({constructor:function Response(e){(this||he).request=e;(this||he).data=null;(this||he).error=null;(this||he).retryCount=0;(this||he).redirectCount=0;(this||he).httpResponse=new r.HttpResponse;if(e){(this||he).maxRetries=e.service.numRetries();(this||he).maxRedirects=e.service.config.maxRedirects}},
/**
     * Creates a new request for the next page of response data, calling the
     * callback with the page data if a callback is provided.
     *
     * @callback callback function(err, data)
     *   Called when a page of data is returned from the next request.
     *
     *   @param err [Error] an error object, if an error occurred in the request
     *   @param data [Object] the next page of data, or null, if there are no
     *     more pages left.
     * @return [AWS.Request] the request object for the next page of data
     * @return [null] if no callback is provided and there are no pages left
     *   to retrieve.
     * @since v1.4.0
     */
nextPage:function nextPage(e){var t;var a=(this||he).request.service;var n=(this||he).request.operation;try{t=a.paginationConfig(n,true)}catch(e){(this||he).error=e}if(!this.hasNextPage()){if(e)e((this||he).error,null);else if((this||he).error)throw(this||he).error;return null}var i=r.util.copy((this||he).request.params);if((this||he).nextPageTokens){var s=t.inputToken;"string"===typeof s&&(s=[s]);for(var o=0;o<s.length;o++)i[s[o]]=(this||he).nextPageTokens[o];return a.makeRequest((this||he).request.operation,i,e)}return e?e(null,null):null},hasNextPage:function hasNextPage(){this.cacheNextPageTokens();return!!(this||he).nextPageTokens||void 0===(this||he).nextPageTokens&&void 0},cacheNextPageTokens:function cacheNextPageTokens(){if(Object.prototype.hasOwnProperty.call(this||he,"nextPageTokens"))return(this||he).nextPageTokens;(this||he).nextPageTokens=void 0;var e=(this||he).request.service.paginationConfig((this||he).request.operation);if(!e)return(this||he).nextPageTokens;(this||he).nextPageTokens=null;if(e.moreResults&&!n.search((this||he).data,e.moreResults))return(this||he).nextPageTokens;var t=e.outputToken;"string"===typeof t&&(t=[t]);r.util.arrayEach.call(this||he,t,(function(e){var t=n.search((this||he).data,e);if(t){(this||he).nextPageTokens=(this||he).nextPageTokens||[];(this||he).nextPageTokens.push(t)}}));return(this||he).nextPageTokens}});return pe}var ve={},me=false;var ge="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$n(){if(me)return ve;me=true;var r=t?t():e;var a=r.util.inherit;var n=f;function CHECK_ACCEPTORS(e){var t=e.request._waiter;var r=t.config.acceptors;var a=false;var n="retry";r.forEach((function(r){if(!a){var i=t.matchers[r.matcher];if(i&&i(e,r.expected,r.argument)){a=true;n=r.state}}}));!a&&e.error&&(n="failure");"success"===n?t.setSuccess(e):t.setError(e,"retry"===n)}r.ResourceWaiter=a({
/**
     * Waits for a given state on a service object
     * @param service [Service] the service object to wait on
     * @param state [String] the state (defined in waiter configuration) to wait
     *   for.
     * @example Create a waiter for running EC2 instances
     *   var ec2 = new AWS.EC2;
     *   var waiter = new AWS.ResourceWaiter(ec2, 'instanceRunning');
     */
constructor:function constructor(e,t){(this||ge).service=e;(this||ge).state=t;this.loadWaiterConfig((this||ge).state)},service:null,state:null,config:null,matchers:{path:function(e,t,r){try{var a=n.search(e.data,r)}catch(e){return false}return n.strictDeepEqual(a,t)},pathAll:function(e,t,r){try{var a=n.search(e.data,r)}catch(e){return false}Array.isArray(a)||(a=[a]);var i=a.length;if(!i)return false;for(var s=0;s<i;s++)if(!n.strictDeepEqual(a[s],t))return false;return true},pathAny:function(e,t,r){try{var a=n.search(e.data,r)}catch(e){return false}Array.isArray(a)||(a=[a]);var i=a.length;for(var s=0;s<i;s++)if(n.strictDeepEqual(a[s],t))return true;return false},status:function(e,t){var r=e.httpResponse.statusCode;return"number"===typeof r&&r===t},error:function(e,t){return"string"===typeof t&&e.error?t===e.error.code:t===!!e.error}},listeners:(new r.SequentialExecutor).addNamedListeners((function(e){e("RETRY_CHECK","retry",(function(e){var t=e.request._waiter;e.error&&"ResourceNotReady"===e.error.code&&(e.error.retryDelay=1e3*(t.config.delay||0))}));e("CHECK_OUTPUT","extractData",CHECK_ACCEPTORS);e("CHECK_ERROR","extractError",CHECK_ACCEPTORS)})),wait:function wait(e,t){if("function"===typeof e){t=e;e=void 0}if(e&&e.$waiter){e=r.util.copy(e);"number"===typeof e.$waiter.delay&&((this||ge).config.delay=e.$waiter.delay);"number"===typeof e.$waiter.maxAttempts&&((this||ge).config.maxAttempts=e.$waiter.maxAttempts);delete e.$waiter}var a=(this||ge).service.makeRequest((this||ge).config.operation,e);a._waiter=this||ge;a.response.maxRetries=(this||ge).config.maxAttempts;a.addListeners((this||ge).listeners);t&&a.send(t);return a},setSuccess:function setSuccess(e){e.error=null;e.data=e.data||{};e.request.removeAllListeners("extractData")},setError:function setError(e,t){e.data=null;e.error=r.util.error(e.error||new Error,{code:"ResourceNotReady",message:"Resource is not in the state "+(this||ge).state,retryable:t})},loadWaiterConfig:function loadWaiterConfig(e){if(!(this||ge).service.api.waiters[e])throw new r.util.error(new Error,{code:"StateNotFoundError",message:"State "+e+" not found."});(this||ge).config=r.util.copy((this||ge).service.api.waiters[e])}});return ve}var ye={},Ee=false;var Re="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$o(){if(Ee)return ye;Ee=true;var r=t?t():e;var a=r.util.inherit;r.Signers.V2=a(r.Signers.RequestSigner,{addAuthorization:function addAuthorization(e,t){t||(t=r.util.date.getDate());var a=(this||Re).request;a.params.Timestamp=r.util.date.iso8601(t);a.params.SignatureVersion="2";a.params.SignatureMethod="HmacSHA256";a.params.AWSAccessKeyId=e.accessKeyId;e.sessionToken&&(a.params.SecurityToken=e.sessionToken);delete a.params.Signature;a.params.Signature=this.signature(e);a.body=r.util.queryParamsToString(a.params);a.headers["Content-Length"]=a.body.length},signature:function signature(e){return r.util.crypto.hmac(e.secretAccessKey,this.stringToSign(),"base64")},stringToSign:function stringToSign(){var e=[];e.push((this||Re).request.method);e.push((this||Re).request.endpoint.host.toLowerCase());e.push((this||Re).request.pathname());e.push(r.util.queryParamsToString((this||Re).request.params));return e.join("\n")}});ye=r.Signers.V2;return ye}var be={},Se=false;var Te="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$p(){if(Se)return be;Se=true;var r=t?t():e;var a=r.util.inherit;r.Signers.V3=a(r.Signers.RequestSigner,{addAuthorization:function addAuthorization(e,t){var a=r.util.date.rfc822(t);(this||Te).request.headers["X-Amz-Date"]=a;e.sessionToken&&((this||Te).request.headers["x-amz-security-token"]=e.sessionToken);(this||Te).request.headers["X-Amzn-Authorization"]=this.authorization(e,a)},authorization:function authorization(e){return"AWS3 "+"AWSAccessKeyId="+e.accessKeyId+","+"Algorithm=HmacSHA256,"+"SignedHeaders="+this.signedHeaders()+","+"Signature="+this.signature(e)},signedHeaders:function signedHeaders(){var e=[];r.util.arrayEach(this.headersToSign(),(function iterator(t){e.push(t.toLowerCase())}));return e.sort().join(";")},canonicalHeaders:function canonicalHeaders(){var e=(this||Te).request.headers;var t=[];r.util.arrayEach(this.headersToSign(),(function iterator(r){t.push(r.toLowerCase().trim()+":"+String(e[r]).trim())}));return t.sort().join("\n")+"\n"},headersToSign:function headersToSign(){var e=[];r.util.each((this||Te).request.headers,(function iterator(t){("Host"===t||"Content-Encoding"===t||t.match(/^X-Amz/i))&&e.push(t)}));return e},signature:function signature(e){return r.util.crypto.hmac(e.secretAccessKey,this.stringToSign(),"base64")},stringToSign:function stringToSign(){var e=[];e.push((this||Te).request.method);e.push("/");e.push("");e.push(this.canonicalHeaders());e.push((this||Te).request.body);return r.util.crypto.sha256(e.join("\n"))}});be=r.Signers.V3;return be}var Ce={},we=false;var Ae="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$q(){if(we)return Ce;we=true;var r=t?t():e;var a=r.util.inherit;dew$p();r.Signers.V3Https=a(r.Signers.V3,{authorization:function authorization(e){return"AWS3-HTTPS "+"AWSAccessKeyId="+e.accessKeyId+","+"Algorithm=HmacSHA256,"+"Signature="+this.signature(e)},stringToSign:function stringToSign(){return(this||Ae).request.headers["X-Amz-Date"]}});Ce=r.Signers.V3Https;return Ce}var qe={},xe=false;var Le="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$r(){if(xe)return qe;xe=true;var r=t?t():e;var a=r.util.inherit;r.Signers.S3=a(r.Signers.RequestSigner,{subResources:{acl:1,accelerate:1,analytics:1,cors:1,lifecycle:1,delete:1,inventory:1,location:1,logging:1,metrics:1,notification:1,partNumber:1,policy:1,requestPayment:1,replication:1,restore:1,tagging:1,torrent:1,uploadId:1,uploads:1,versionId:1,versioning:1,versions:1,website:1},responseHeaders:{"response-content-type":1,"response-content-language":1,"response-expires":1,"response-cache-control":1,"response-content-disposition":1,"response-content-encoding":1},addAuthorization:function addAuthorization(e,t){(this||Le).request.headers["presigned-expires"]||((this||Le).request.headers["X-Amz-Date"]=r.util.date.rfc822(t));e.sessionToken&&((this||Le).request.headers["x-amz-security-token"]=e.sessionToken);var a=this.sign(e.secretAccessKey,this.stringToSign());var n="AWS "+e.accessKeyId+":"+a;(this||Le).request.headers["Authorization"]=n},stringToSign:function stringToSign(){var e=(this||Le).request;var t=[];t.push(e.method);t.push(e.headers["Content-MD5"]||"");t.push(e.headers["Content-Type"]||"");t.push(e.headers["presigned-expires"]||"");var r=this.canonicalizedAmzHeaders();r&&t.push(r);t.push(this.canonicalizedResource());return t.join("\n")},canonicalizedAmzHeaders:function canonicalizedAmzHeaders(){var e=[];r.util.each((this||Le).request.headers,(function(t){t.match(/^x-amz-/i)&&e.push(t)}));e.sort((function(e,t){return e.toLowerCase()<t.toLowerCase()?-1:1}));var t=[];r.util.arrayEach.call(this||Le,e,(function(e){t.push(e.toLowerCase()+":"+String((this||Le).request.headers[e]))}));return t.join("\n")},canonicalizedResource:function canonicalizedResource(){var e=(this||Le).request;var t=e.path.split("?");var a=t[0];var n=t[1];var i="";e.virtualHostedBucket&&(i+="/"+e.virtualHostedBucket);i+=a;if(n){var s=[];r.util.arrayEach.call(this||Le,n.split("&"),(function(e){var t=e.split("=")[0];var r=e.split("=")[1];if((this||Le).subResources[t]||(this||Le).responseHeaders[t]){var a={name:t};void 0!==r&&((this||Le).subResources[t]?a.value=r:a.value=decodeURIComponent(r));s.push(a)}}));s.sort((function(e,t){return e.name<t.name?-1:1}));if(s.length){n=[];r.util.arrayEach(s,(function(e){void 0===e.value?n.push(e.name):n.push(e.name+"="+e.value)}));i+="?"+n.join("&")}}return i},sign:function sign(e,t){return r.util.crypto.hmac(e,t,"base64","sha1")}});qe=r.Signers.S3;return qe}var Pe={},De=false;var Ne="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$s(){if(De)return Pe;De=true;var r=t?t():e;var a=r.util.inherit;var n="presigned-expires";function signedUrlBuilder(e){var t=e.httpRequest.headers[n];var a=e.service.getSignerClass(e);delete e.httpRequest.headers["User-Agent"];delete e.httpRequest.headers["X-Amz-User-Agent"];if(a===r.Signers.V4){if(t>604800){var i="Presigning does not support expiry time greater "+"than a week with SigV4 signing.";throw r.util.error(new Error,{code:"InvalidExpiryTime",message:i,retryable:false})}e.httpRequest.headers[n]=t}else{if(a!==r.Signers.S3)throw r.util.error(new Error,{message:"Presigning only supports S3 or SigV4 signing.",code:"UnsupportedSigner",retryable:false});var s=e.service?e.service.getSkewCorrectedDate():r.util.date.getDate();e.httpRequest.headers[n]=parseInt(r.util.date.unixTimestamp(s)+t,10).toString()}}function signedUrlSigner(e){var t=e.httpRequest.endpoint;var a=r.util.urlParse(e.httpRequest.path);var i={};a.search&&(i=r.util.queryStringParse(a.search.substr(1)));var s=e.httpRequest.headers["Authorization"].split(" ");if("AWS"===s[0]){s=s[1].split(":");i["Signature"]=s.pop();i["AWSAccessKeyId"]=s.join(":");r.util.each(e.httpRequest.headers,(function(e,t){e===n&&(e="Expires");if(0===e.indexOf("x-amz-meta-")){delete i[e];e=e.toLowerCase()}i[e]=t}));delete e.httpRequest.headers[n];delete i["Authorization"];delete i["Host"]}else if("AWS4-HMAC-SHA256"===s[0]){s.shift();var o=s.join(" ");var u=o.match(/Signature=(.*?)(?:,|\s|\r?\n|$)/)[1];i["X-Amz-Signature"]=u;delete i["Expires"]}t.pathname=a.pathname;t.search=r.util.queryParamsToString(i)}r.Signers.Presign=a({sign:function sign(e,t,a){e.httpRequest.headers[n]=t||3600;e.on("build",signedUrlBuilder);e.on("sign",signedUrlSigner);e.removeListener("afterBuild",r.EventListeners.Core.SET_CONTENT_LENGTH);e.removeListener("afterBuild",r.EventListeners.Core.COMPUTE_SHA256);e.emit("beforePresign",[e]);if(!a){e.build();if(e.response.error)throw e.response.error;return r.util.urlFormat(e.httpRequest.endpoint)}e.build((function(){(this||Ne).response.error?a((this||Ne).response.error):a(null,r.util.urlFormat(e.httpRequest.endpoint))}))}});Pe=r.Signers.Presign;return Pe}var _e={},Ie=false;var Oe="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$t(){if(Ie)return _e;Ie=true;var r=t?t():e;var a=r.util.inherit;r.Signers.RequestSigner=a({constructor:function RequestSigner(e){(this||Oe).request=e},setServiceClientId:function setServiceClientId(e){(this||Oe).serviceClientId=e},getServiceClientId:function getServiceClientId(){return(this||Oe).serviceClientId}});r.Signers.RequestSigner.getVersion=function getVersion(e){switch(e){case"v2":return r.Signers.V2;case"v3":return r.Signers.V3;case"s3v4":return r.Signers.V4;case"v4":return r.Signers.V4;case"s3":return r.Signers.S3;case"v3https":return r.Signers.V3Https}throw new Error("Unknown signing version "+e)};dew$o();dew$p();dew$q();h();dew$r();dew$s();return _e}var ke={},He=false;var Me="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;function dew$u(){if(He)return ke;He=true;var r=t?t():e;r.ParamValidator=r.util.inherit({
/**
     * Create a new validator object.
     *
     * @param validation [Boolean|map] whether input parameters should be
     *     validated against the operation description before sending the
     *     request. Pass a map to enable any of the following specific
     *     validation features:
     *
     *     * **min** [Boolean] &mdash; Validates that a value meets the min
     *       constraint. This is enabled by default when paramValidation is set
     *       to `true`.
     *     * **max** [Boolean] &mdash; Validates that a value meets the max
     *       constraint.
     *     * **pattern** [Boolean] &mdash; Validates that a string value matches a
     *       regular expression.
     *     * **enum** [Boolean] &mdash; Validates that a string value matches one
     *       of the allowable enum values.
     */
constructor:function ParamValidator(e){true!==e&&void 0!==e||(e={min:true});(this||Me).validation=e},validate:function validate(e,t,a){(this||Me).errors=[];this.validateMember(e,t||{},a||"params");if((this||Me).errors.length>1){var n=(this||Me).errors.join("\n* ");n="There were "+(this||Me).errors.length+" validation errors:\n* "+n;throw r.util.error(new Error(n),{code:"MultipleValidationErrors",errors:(this||Me).errors})}if(1===(this||Me).errors.length)throw(this||Me).errors[0];return true},fail:function fail(e,t){(this||Me).errors.push(r.util.error(new Error(t),{code:e}))},validateStructure:function validateStructure(e,t,r){this.validateType(t,r,["object"],"structure");var a;for(var n=0;e.required&&n<e.required.length;n++){a=e.required[n];var i=t[a];void 0!==i&&null!==i||this.fail("MissingRequiredParameter","Missing required key '"+a+"' in "+r)}for(a in t)if(Object.prototype.hasOwnProperty.call(t,a)){var s=t[a],o=e.members[a];if(void 0!==o){var u=[r,a].join(".");this.validateMember(o,s,u)}else this.fail("UnexpectedParameter","Unexpected key '"+a+"' found in "+r)}return true},validateMember:function validateMember(e,t,r){switch(e.type){case"structure":return this.validateStructure(e,t,r);case"list":return this.validateList(e,t,r);case"map":return this.validateMap(e,t,r);default:return this.validateScalar(e,t,r)}},validateList:function validateList(e,t,r){if(this.validateType(t,r,[Array])){this.validateRange(e,t.length,r,"list member count");for(var a=0;a<t.length;a++)this.validateMember(e.member,t[a],r+"["+a+"]")}},validateMap:function validateMap(e,t,r){if(this.validateType(t,r,["object"],"map")){var a=0;for(var n in t)if(Object.prototype.hasOwnProperty.call(t,n)){this.validateMember(e.key,n,r+"[key='"+n+"']");this.validateMember(e.value,t[n],r+"['"+n+"']");a++}this.validateRange(e,a,r,"map member count")}},validateScalar:function validateScalar(e,t,r){switch(e.type){case null:case void 0:case"string":return this.validateString(e,t,r);case"base64":case"binary":return this.validatePayload(t,r);case"integer":case"float":return this.validateNumber(e,t,r);case"boolean":return this.validateType(t,r,["boolean"]);case"timestamp":return this.validateType(t,r,[Date,/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z$/,"number"],"Date object, ISO-8601 string, or a UNIX timestamp");default:return this.fail("UnkownType","Unhandled type "+e.type+" for "+r)}},validateString:function validateString(e,t,r){var a=["string"];e.isJsonValue&&(a=a.concat(["number","object","boolean"]));if(null!==t&&this.validateType(t,r,a)){this.validateEnum(e,t,r);this.validateRange(e,t.length,r,"string length");this.validatePattern(e,t,r);this.validateUri(e,t,r)}},validateUri:function validateUri(e,t,r){"uri"===e["location"]&&0===t.length&&this.fail("UriParameterError","Expected uri parameter to have length >= 1,"+' but found "'+t+'" for '+r)},validatePattern:function validatePattern(e,t,r){(this||Me).validation["pattern"]&&void 0!==e["pattern"]&&(new RegExp(e["pattern"]).test(t)||this.fail("PatternMatchError",'Provided value "'+t+'" '+"does not match regex pattern /"+e["pattern"]+"/ for "+r))},validateRange:function validateRange(e,t,r,a){(this||Me).validation["min"]&&void 0!==e["min"]&&t<e["min"]&&this.fail("MinRangeError","Expected "+a+" >= "+e["min"]+", but found "+t+" for "+r);(this||Me).validation["max"]&&void 0!==e["max"]&&t>e["max"]&&this.fail("MaxRangeError","Expected "+a+" <= "+e["max"]+", but found "+t+" for "+r)},validateEnum:function validateRange(e,t,r){(this||Me).validation["enum"]&&void 0!==e["enum"]&&-1===e["enum"].indexOf(t)&&this.fail("EnumError","Found string value of "+t+", but "+"expected "+e["enum"].join("|")+" for "+r)},validateType:function validateType(e,t,a,n){if(null===e||void 0===e)return false;var i=false;for(var s=0;s<a.length;s++){if("string"===typeof a[s]){if(typeof e===a[s])return true}else if(a[s]instanceof RegExp){if((e||"").toString().match(a[s]))return true}else{if(e instanceof a[s])return true;if(r.util.isType(e,a[s]))return true;n||i||(a=a.slice());a[s]=r.util.typeName(a[s])}i=true}var o=n;o||(o=a.join(", ").replace(/,([^,]+)$/,", or$1"));var u=o.match(/^[aeiou]/i)?"n":"";this.fail("InvalidParameterType","Expected "+t+" to be a"+u+" "+o);return false},validateNumber:function validateNumber(e,t,r){if(null!==t&&void 0!==t){if("string"===typeof t){var a=parseFloat(t);a.toString()===t&&(t=a)}this.validateType(t,r,["number"])&&this.validateRange(e,t,r,"numeric value")}},validatePayload:function validatePayload(e,t){if(null!==e&&void 0!==e&&"string"!==typeof e&&(!e||"number"!==typeof e.byteLength)){if(r.util.isNode()){var a=r.util.stream.Stream;if(r.util.Buffer.isBuffer(e)||e instanceof a)return}else if(void 0!==typeof Blob&&e instanceof Blob)return;var n=["Buffer","Stream","File","Blob","ArrayBuffer","DataView"];if(e)for(var i=0;i<n.length;i++){if(r.util.isType(e,n[i]))return;if(r.util.typeName(e.constructor)===n[i])return}this.fail("InvalidParameterType","Expected "+t+" to be a "+"string, Buffer, Stream, Blob, or typed array object")}}});return ke}var ze={},$e=false;function dew$v(){if($e)return ze;$e=true;var e={util:a()};var t={};t.toString();ze=e;e.util.update(e,{VERSION:"2.756.0",Signers:{},Protocol:{Json:dew$3(),Query:dew$5(),Rest:dew$6(),RestJson:dew$7(),RestXml:dew$8()},XML:{Builder:dew$d(),Parser:null},JSON:{Builder:dew(),Parser:dew$1()},Model:{Api:i(),Operation:s(),Shape:n(),Paginator:o(),ResourceWaiter:u()},apiLoader:dew$e(),EndpointCache:dew$g().EndpointCache});dew$h();l();c();d();dew$j();dew$l();dew$m();dew$n();dew$t();dew$u();e.events=new e.SequentialExecutor;e.util.memoizedProperty(e,"endpointCache",(function(){return new e.EndpointCache(e.config.endpointCacheSize)}),true);return ze}var Ue=dew$v();export default Ue;export{dew$v as __dew};

