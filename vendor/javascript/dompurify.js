// dompurify@3.2.6 downloaded from https://ga.jspm.io/npm:dompurify@3.2.6/dist/purify.es.mjs

/*! @license DOMPurify 3.2.6 | (c) Cure53 and other contributors | Released under the Apache license 2.0 and Mozilla Public License 2.0 | github.com/cure53/DOMPurify/blob/3.2.6/LICENSE */
const{entries:e,setPrototypeOf:t,isFrozen:n,getPrototypeOf:o,getOwnPropertyDescriptor:r}=Object;let{freeze:i,seal:a,create:l}=Object;let{apply:s,construct:c}=typeof Reflect!=="undefined"&&Reflect;i||(i=function(e){return e});a||(a=function(e){return e});s||(s=function(e,t,n){return e.apply(t,n)});c||(c=function(e,t){return new e(...t)});const u=b(Array.prototype.forEach);const f=b(Array.prototype.lastIndexOf);const m=b(Array.prototype.pop);const p=b(Array.prototype.push);const d=b(Array.prototype.splice);const h=b(String.prototype.toLowerCase);const g=b(String.prototype.toString);const T=b(String.prototype.match);const y=b(String.prototype.replace);const E=b(String.prototype.indexOf);const A=b(String.prototype.trim);const _=b(Object.prototype.hasOwnProperty);const N=b(RegExp.prototype.test);const S=w(TypeError);
/**
 * Creates a new function that calls the given function with a specified thisArg and arguments.
 *
 * @param func - The function to be wrapped and called.
 * @returns A new function that calls the given function with a specified thisArg and arguments.
 */function b(e){return function(t){t instanceof RegExp&&(t.lastIndex=0);for(var n=arguments.length,o=new Array(n>1?n-1:0),r=1;r<n;r++)o[r-1]=arguments[r];return s(e,t,o)}}
/**
 * Creates a new function that constructs an instance of the given constructor function with the provided arguments.
 *
 * @param func - The constructor function to be wrapped and called.
 * @returns A new function that constructs an instance of the given constructor function with the provided arguments.
 */function w(e){return function(){for(var t=arguments.length,n=new Array(t),o=0;o<t;o++)n[o]=arguments[o];return c(e,n)}}
/**
 * Add properties to a lookup table
 *
 * @param set - The set to which elements will be added.
 * @param array - The array containing elements to be added to the set.
 * @param transformCaseFunc - An optional function to transform the case of each element before adding to the set.
 * @returns The modified set with added elements.
 */function R(e,o){let r=arguments.length>2&&arguments[2]!==void 0?arguments[2]:h;t&&t(e,null);let i=o.length;while(i--){let t=o[i];if(typeof t==="string"){const e=r(t);if(e!==t){n(o)||(o[i]=e);t=e}}e[t]=true}return e}
/**
 * Clean up an array to harden against CSPP
 *
 * @param array - The array to be cleaned.
 * @returns The cleaned version of the array
 */function L(e){for(let t=0;t<e.length;t++){const n=_(e,t);n||(e[t]=null)}return e}
/**
 * Shallow clone an object
 *
 * @param object - The object to be cloned.
 * @returns A new object that copies the original.
 */function O(t){const n=l(null);for(const[o,r]of e(t)){const e=_(t,o);e&&(Array.isArray(r)?n[o]=L(r):r&&typeof r==="object"&&r.constructor===Object?n[o]=O(r):n[o]=r)}return n}
/**
 * This method automatically checks if the prop is function or getter and behaves accordingly.
 *
 * @param object - The object to look up the getter function in its prototype chain.
 * @param prop - The property name for which to find the getter function.
 * @returns The getter function found in the prototype chain or a fallback function.
 */function v(e,t){while(e!==null){const n=r(e,t);if(n){if(n.get)return b(n.get);if(typeof n.value==="function")return b(n.value)}e=o(e)}function n(){return null}return n}const x=i(["a","abbr","acronym","address","area","article","aside","audio","b","bdi","bdo","big","blink","blockquote","body","br","button","canvas","caption","center","cite","code","col","colgroup","content","data","datalist","dd","decorator","del","details","dfn","dialog","dir","div","dl","dt","element","em","fieldset","figcaption","figure","font","footer","form","h1","h2","h3","h4","h5","h6","head","header","hgroup","hr","html","i","img","input","ins","kbd","label","legend","li","main","map","mark","marquee","menu","menuitem","meter","nav","nobr","ol","optgroup","option","output","p","picture","pre","progress","q","rp","rt","ruby","s","samp","section","select","shadow","small","source","spacer","span","strike","strong","style","sub","summary","sup","table","tbody","td","template","textarea","tfoot","th","thead","time","tr","track","tt","u","ul","var","video","wbr"]);const C=i(["svg","a","altglyph","altglyphdef","altglyphitem","animatecolor","animatemotion","animatetransform","circle","clippath","defs","desc","ellipse","filter","font","g","glyph","glyphref","hkern","image","line","lineargradient","marker","mask","metadata","mpath","path","pattern","polygon","polyline","radialgradient","rect","stop","style","switch","symbol","text","textpath","title","tref","tspan","view","vkern"]);const D=i(["feBlend","feColorMatrix","feComponentTransfer","feComposite","feConvolveMatrix","feDiffuseLighting","feDisplacementMap","feDistantLight","feDropShadow","feFlood","feFuncA","feFuncB","feFuncG","feFuncR","feGaussianBlur","feImage","feMerge","feMergeNode","feMorphology","feOffset","fePointLight","feSpecularLighting","feSpotLight","feTile","feTurbulence"]);const I=i(["animate","color-profile","cursor","discard","font-face","font-face-format","font-face-name","font-face-src","font-face-uri","foreignobject","hatch","hatchpath","mesh","meshgradient","meshpatch","meshrow","missing-glyph","script","set","solidcolor","unknown","use"]);const k=i(["math","menclose","merror","mfenced","mfrac","mglyph","mi","mlabeledtr","mmultiscripts","mn","mo","mover","mpadded","mphantom","mroot","mrow","ms","mspace","msqrt","mstyle","msub","msup","msubsup","mtable","mtd","mtext","mtr","munder","munderover","mprescripts"]);const M=i(["maction","maligngroup","malignmark","mlongdiv","mscarries","mscarry","msgroup","mstack","msline","msrow","semantics","annotation","annotation-xml","mprescripts","none"]);const U=i(["#text"]);const P=i(["accept","action","align","alt","autocapitalize","autocomplete","autopictureinpicture","autoplay","background","bgcolor","border","capture","cellpadding","cellspacing","checked","cite","class","clear","color","cols","colspan","controls","controlslist","coords","crossorigin","datetime","decoding","default","dir","disabled","disablepictureinpicture","disableremoteplayback","download","draggable","enctype","enterkeyhint","face","for","headers","height","hidden","high","href","hreflang","id","inputmode","integrity","ismap","kind","label","lang","list","loading","loop","low","max","maxlength","media","method","min","minlength","multiple","muted","name","nonce","noshade","novalidate","nowrap","open","optimum","pattern","placeholder","playsinline","popover","popovertarget","popovertargetaction","poster","preload","pubdate","radiogroup","readonly","rel","required","rev","reversed","role","rows","rowspan","spellcheck","scope","selected","shape","size","sizes","span","srclang","start","src","srcset","step","style","summary","tabindex","title","translate","type","usemap","valign","value","width","wrap","xmlns","slot"]);const z=i(["accent-height","accumulate","additive","alignment-baseline","amplitude","ascent","attributename","attributetype","azimuth","basefrequency","baseline-shift","begin","bias","by","class","clip","clippathunits","clip-path","clip-rule","color","color-interpolation","color-interpolation-filters","color-profile","color-rendering","cx","cy","d","dx","dy","diffuseconstant","direction","display","divisor","dur","edgemode","elevation","end","exponent","fill","fill-opacity","fill-rule","filter","filterunits","flood-color","flood-opacity","font-family","font-size","font-size-adjust","font-stretch","font-style","font-variant","font-weight","fx","fy","g1","g2","glyph-name","glyphref","gradientunits","gradienttransform","height","href","id","image-rendering","in","in2","intercept","k","k1","k2","k3","k4","kerning","keypoints","keysplines","keytimes","lang","lengthadjust","letter-spacing","kernelmatrix","kernelunitlength","lighting-color","local","marker-end","marker-mid","marker-start","markerheight","markerunits","markerwidth","maskcontentunits","maskunits","max","mask","media","method","mode","min","name","numoctaves","offset","operator","opacity","order","orient","orientation","origin","overflow","paint-order","path","pathlength","patterncontentunits","patterntransform","patternunits","points","preservealpha","preserveaspectratio","primitiveunits","r","rx","ry","radius","refx","refy","repeatcount","repeatdur","restart","result","rotate","scale","seed","shape-rendering","slope","specularconstant","specularexponent","spreadmethod","startoffset","stddeviation","stitchtiles","stop-color","stop-opacity","stroke-dasharray","stroke-dashoffset","stroke-linecap","stroke-linejoin","stroke-miterlimit","stroke-opacity","stroke","stroke-width","style","surfacescale","systemlanguage","tabindex","tablevalues","targetx","targety","transform","transform-origin","text-anchor","text-decoration","text-rendering","textlength","type","u1","u2","unicode","values","viewbox","visibility","version","vert-adv-y","vert-origin-x","vert-origin-y","width","word-spacing","wrap","writing-mode","xchannelselector","ychannelselector","x","x1","x2","xmlns","y","y1","y2","z","zoomandpan"]);const H=i(["accent","accentunder","align","bevelled","close","columnsalign","columnlines","columnspan","denomalign","depth","dir","display","displaystyle","encoding","fence","frame","height","href","id","largeop","length","linethickness","lspace","lquote","mathbackground","mathcolor","mathsize","mathvariant","maxsize","minsize","movablelimits","notation","numalign","open","rowalign","rowlines","rowspacing","rowspan","rspace","rquote","scriptlevel","scriptminsize","scriptsizemultiplier","selection","separator","separators","stretchy","subscriptshift","supscriptshift","symmetric","voffset","width","xmlns"]);const F=i(["xlink:href","xml:id","xlink:title","xml:space","xmlns:xlink"]);const B=a(/\{\{[\w\W]*|[\w\W]*\}\}/gm);const W=a(/<%[\w\W]*|[\w\W]*%>/gm);const G=a(/\$\{[\w\W]*/gm);const Y=a(/^data-[\-\w.\u00B7-\uFFFF]+$/);const j=a(/^aria-[\-\w]+$/);const X=a(/^(?:(?:(?:f|ht)tps?|mailto|tel|callto|sms|cid|xmpp|matrix):|[^a-z]|[a-z+.\-]+(?:[^a-z+.\-:]|$))/i);const q=a(/^(?:\w+script|data):/i);const $=a(/[\u0000-\u0020\u00A0\u1680\u180E\u2000-\u2029\u205F\u3000]/g);const K=a(/^html$/i);const V=a(/^[a-z][.\w]*(-[.\w]+)+$/i);var Z=Object.freeze({__proto__:null,ARIA_ATTR:j,ATTR_WHITESPACE:$,CUSTOM_ELEMENT:V,DATA_ATTR:Y,DOCTYPE_NAME:K,ERB_EXPR:W,IS_ALLOWED_URI:X,IS_SCRIPT_OR_DATA:q,MUSTACHE_EXPR:B,TMPLIT_EXPR:G});
/* eslint-disable @typescript-eslint/indent */const J={element:1,attribute:2,text:3,cdataSection:4,entityReference:5,entityNode:6,progressingInstruction:7,comment:8,document:9,documentType:10,documentFragment:11,notation:12};const Q=function(){return typeof window==="undefined"?null:window};
/**
 * Creates a no-op policy for internal use only.
 * Don't export this function outside this module!
 * @param trustedTypes The policy factory.
 * @param purifyHostElement The Script element used to load DOMPurify (to determine policy name suffix).
 * @return The policy created (or null, if Trusted Types
 * are not supported or creating the policy failed).
 */const ee=function(e,t){if(typeof e!=="object"||typeof e.createPolicy!=="function")return null;let n=null;const o="data-tt-policy-suffix";t&&t.hasAttribute(o)&&(n=t.getAttribute(o));const r="dompurify"+(n?"#"+n:"");try{return e.createPolicy(r,{createHTML(e){return e},createScriptURL(e){return e}})}catch(e){console.warn("TrustedTypes policy "+r+" could not be created.");return null}};const te=function(){return{afterSanitizeAttributes:[],afterSanitizeElements:[],afterSanitizeShadowDOM:[],beforeSanitizeAttributes:[],beforeSanitizeElements:[],beforeSanitizeShadowDOM:[],uponSanitizeAttribute:[],uponSanitizeElement:[],uponSanitizeShadowNode:[]}};function ne(){let t=arguments.length>0&&arguments[0]!==void 0?arguments[0]:Q();const n=e=>ne(e);n.version="3.2.6";n.removed=[];if(!t||!t.document||t.document.nodeType!==J.document||!t.Element){n.isSupported=false;return n}let{document:o}=t;const r=o;const a=r.currentScript;const{DocumentFragment:s,HTMLTemplateElement:c,Node:b,Element:w,NodeFilter:L,NamedNodeMap:B=t.NamedNodeMap||t.MozNamedAttrMap,HTMLFormElement:W,DOMParser:G,trustedTypes:Y}=t;const j=w.prototype;const q=v(j,"cloneNode");const $=v(j,"remove");const V=v(j,"nextSibling");const oe=v(j,"childNodes");const re=v(j,"parentNode");if(typeof c==="function"){const e=o.createElement("template");e.content&&e.content.ownerDocument&&(o=e.content.ownerDocument)}let ie;let ae="";const{implementation:le,createNodeIterator:se,createDocumentFragment:ce,getElementsByTagName:ue}=o;const{importNode:fe}=r;let me=te();n.isSupported=typeof e==="function"&&typeof re==="function"&&le&&le.createHTMLDocument!==void 0;const{MUSTACHE_EXPR:pe,ERB_EXPR:de,TMPLIT_EXPR:he,DATA_ATTR:ge,ARIA_ATTR:Te,IS_SCRIPT_OR_DATA:ye,ATTR_WHITESPACE:Ee,CUSTOM_ELEMENT:Ae}=Z;let{IS_ALLOWED_URI:_e}=Z;let Ne=null;const Se=R({},[...x,...C,...D,...k,...U]);let be=null;const we=R({},[...P,...z,...H,...F]);let Re=Object.seal(l(null,{tagNameCheck:{writable:true,configurable:false,enumerable:true,value:null},attributeNameCheck:{writable:true,configurable:false,enumerable:true,value:null},allowCustomizedBuiltInElements:{writable:true,configurable:false,enumerable:true,value:false}}));let Le=null;let Oe=null;let ve=true;let xe=true;let Ce=false;let De=true;let Ie=false;let ke=true;let Me=false;let Ue=false;let Pe=false;let ze=false;let He=false;let Fe=false;let Be=true;let We=false;const Ge="user-content-";let Ye=true;let je=false;let Xe={};let qe=null;const $e=R({},["annotation-xml","audio","colgroup","desc","foreignobject","head","iframe","math","mi","mn","mo","ms","mtext","noembed","noframes","noscript","plaintext","script","style","svg","template","thead","title","video","xmp"]);let Ke=null;const Ve=R({},["audio","video","img","source","image","track"]);let Ze=null;const Je=R({},["alt","class","for","id","label","name","pattern","placeholder","role","summary","title","value","style","xmlns"]);const Qe="http://www.w3.org/1998/Math/MathML";const et="http://www.w3.org/2000/svg";const tt="http://www.w3.org/1999/xhtml";let nt=tt;let ot=false;let rt=null;const it=R({},[Qe,et,tt],g);let at=R({},["mi","mo","mn","ms","mtext"]);let lt=R({},["annotation-xml"]);const st=R({},["title","style","font","a","script"]);let ct=null;const ut=["application/xhtml+xml","text/html"];const ft="text/html";let mt=null;let pt=null;const dt=o.createElement("form");const ht=function(e){return e instanceof RegExp||e instanceof Function};
/**
   * _parseConfig
   *
   * @param cfg optional config literal
   */const gt=function(){let e=arguments.length>0&&arguments[0]!==void 0?arguments[0]:{};if(!pt||pt!==e){e&&typeof e==="object"||(e={});e=O(e);ct=ut.indexOf(e.PARSER_MEDIA_TYPE)===-1?ft:e.PARSER_MEDIA_TYPE;mt=ct==="application/xhtml+xml"?g:h;Ne=_(e,"ALLOWED_TAGS")?R({},e.ALLOWED_TAGS,mt):Se;be=_(e,"ALLOWED_ATTR")?R({},e.ALLOWED_ATTR,mt):we;rt=_(e,"ALLOWED_NAMESPACES")?R({},e.ALLOWED_NAMESPACES,g):it;Ze=_(e,"ADD_URI_SAFE_ATTR")?R(O(Je),e.ADD_URI_SAFE_ATTR,mt):Je;Ke=_(e,"ADD_DATA_URI_TAGS")?R(O(Ve),e.ADD_DATA_URI_TAGS,mt):Ve;qe=_(e,"FORBID_CONTENTS")?R({},e.FORBID_CONTENTS,mt):$e;Le=_(e,"FORBID_TAGS")?R({},e.FORBID_TAGS,mt):O({});Oe=_(e,"FORBID_ATTR")?R({},e.FORBID_ATTR,mt):O({});Xe=!!_(e,"USE_PROFILES")&&e.USE_PROFILES;ve=e.ALLOW_ARIA_ATTR!==false;xe=e.ALLOW_DATA_ATTR!==false;Ce=e.ALLOW_UNKNOWN_PROTOCOLS||false;De=e.ALLOW_SELF_CLOSE_IN_ATTR!==false;Ie=e.SAFE_FOR_TEMPLATES||false;ke=e.SAFE_FOR_XML!==false;Me=e.WHOLE_DOCUMENT||false;ze=e.RETURN_DOM||false;He=e.RETURN_DOM_FRAGMENT||false;Fe=e.RETURN_TRUSTED_TYPE||false;Pe=e.FORCE_BODY||false;Be=e.SANITIZE_DOM!==false;We=e.SANITIZE_NAMED_PROPS||false;Ye=e.KEEP_CONTENT!==false;je=e.IN_PLACE||false;_e=e.ALLOWED_URI_REGEXP||X;nt=e.NAMESPACE||tt;at=e.MATHML_TEXT_INTEGRATION_POINTS||at;lt=e.HTML_INTEGRATION_POINTS||lt;Re=e.CUSTOM_ELEMENT_HANDLING||{};e.CUSTOM_ELEMENT_HANDLING&&ht(e.CUSTOM_ELEMENT_HANDLING.tagNameCheck)&&(Re.tagNameCheck=e.CUSTOM_ELEMENT_HANDLING.tagNameCheck);e.CUSTOM_ELEMENT_HANDLING&&ht(e.CUSTOM_ELEMENT_HANDLING.attributeNameCheck)&&(Re.attributeNameCheck=e.CUSTOM_ELEMENT_HANDLING.attributeNameCheck);e.CUSTOM_ELEMENT_HANDLING&&typeof e.CUSTOM_ELEMENT_HANDLING.allowCustomizedBuiltInElements==="boolean"&&(Re.allowCustomizedBuiltInElements=e.CUSTOM_ELEMENT_HANDLING.allowCustomizedBuiltInElements);Ie&&(xe=false);He&&(ze=true);if(Xe){Ne=R({},U);be=[];if(Xe.html===true){R(Ne,x);R(be,P)}if(Xe.svg===true){R(Ne,C);R(be,z);R(be,F)}if(Xe.svgFilters===true){R(Ne,D);R(be,z);R(be,F)}if(Xe.mathMl===true){R(Ne,k);R(be,H);R(be,F)}}if(e.ADD_TAGS){Ne===Se&&(Ne=O(Ne));R(Ne,e.ADD_TAGS,mt)}if(e.ADD_ATTR){be===we&&(be=O(be));R(be,e.ADD_ATTR,mt)}e.ADD_URI_SAFE_ATTR&&R(Ze,e.ADD_URI_SAFE_ATTR,mt);if(e.FORBID_CONTENTS){qe===$e&&(qe=O(qe));R(qe,e.FORBID_CONTENTS,mt)}Ye&&(Ne["#text"]=true);Me&&R(Ne,["html","head","body"]);if(Ne.table){R(Ne,["tbody"]);delete Le.tbody}if(e.TRUSTED_TYPES_POLICY){if(typeof e.TRUSTED_TYPES_POLICY.createHTML!=="function")throw S('TRUSTED_TYPES_POLICY configuration option must provide a "createHTML" hook.');if(typeof e.TRUSTED_TYPES_POLICY.createScriptURL!=="function")throw S('TRUSTED_TYPES_POLICY configuration option must provide a "createScriptURL" hook.');ie=e.TRUSTED_TYPES_POLICY;ae=ie.createHTML("")}else{ie===void 0&&(ie=ee(Y,a));ie!==null&&typeof ae==="string"&&(ae=ie.createHTML(""))}i&&i(e);pt=e}};const Tt=R({},[...C,...D,...I]);const yt=R({},[...k,...M]);
/**
   * @param element a DOM element whose namespace is being checked
   * @returns Return false if the element has a
   *  namespace that a spec-compliant parser would never
   *  return. Return true otherwise.
   */const Et=function(e){let t=re(e);t&&t.tagName||(t={namespaceURI:nt,tagName:"template"});const n=h(e.tagName);const o=h(t.tagName);return!!rt[e.namespaceURI]&&(e.namespaceURI===et?t.namespaceURI===tt?n==="svg":t.namespaceURI===Qe?n==="svg"&&(o==="annotation-xml"||at[o]):Boolean(Tt[n]):e.namespaceURI===Qe?t.namespaceURI===tt?n==="math":t.namespaceURI===et?n==="math"&&lt[o]:Boolean(yt[n]):e.namespaceURI===tt?!(t.namespaceURI===et&&!lt[o])&&(!(t.namespaceURI===Qe&&!at[o])&&(!yt[n]&&(st[n]||!Tt[n]))):!(ct!=="application/xhtml+xml"||!rt[e.namespaceURI]))};
/**
   * _forceRemove
   *
   * @param node a DOM node
   */const At=function(e){p(n.removed,{element:e});try{re(e).removeChild(e)}catch(t){$(e)}};
/**
   * _removeAttribute
   *
   * @param name an Attribute name
   * @param element a DOM node
   */const _t=function(e,t){try{p(n.removed,{attribute:t.getAttributeNode(e),from:t})}catch(e){p(n.removed,{attribute:null,from:t})}t.removeAttribute(e);if(e==="is")if(ze||He)try{At(t)}catch(e){}else try{t.setAttribute(e,"")}catch(e){}};
/**
   * _initDocument
   *
   * @param dirty - a string of dirty markup
   * @return a DOM, filled with the dirty markup
   */const Nt=function(e){let t=null;let n=null;if(Pe)e="<remove></remove>"+e;else{const t=T(e,/^[\r\n\t ]+/);n=t&&t[0]}ct==="application/xhtml+xml"&&nt===tt&&(e='<html xmlns="http://www.w3.org/1999/xhtml"><head></head><body>'+e+"</body></html>");const r=ie?ie.createHTML(e):e;if(nt===tt)try{t=(new G).parseFromString(r,ct)}catch(e){}if(!t||!t.documentElement){t=le.createDocument(nt,"template",null);try{t.documentElement.innerHTML=ot?ae:r}catch(e){}}const i=t.body||t.documentElement;e&&n&&i.insertBefore(o.createTextNode(n),i.childNodes[0]||null);return nt===tt?ue.call(t,Me?"html":"body")[0]:Me?t.documentElement:i};
/**
   * Creates a NodeIterator object that you can use to traverse filtered lists of nodes or elements in a document.
   *
   * @param root The root element or node to start traversing on.
   * @return The created NodeIterator
   */const St=function(e){return se.call(e.ownerDocument||e,e,L.SHOW_ELEMENT|L.SHOW_COMMENT|L.SHOW_TEXT|L.SHOW_PROCESSING_INSTRUCTION|L.SHOW_CDATA_SECTION,null)};
/**
   * _isClobbered
   *
   * @param element element to check for clobbering attacks
   * @return true if clobbered, false if safe
   */const bt=function(e){return e instanceof W&&(typeof e.nodeName!=="string"||typeof e.textContent!=="string"||typeof e.removeChild!=="function"||!(e.attributes instanceof B)||typeof e.removeAttribute!=="function"||typeof e.setAttribute!=="function"||typeof e.namespaceURI!=="string"||typeof e.insertBefore!=="function"||typeof e.hasChildNodes!=="function")};
/**
   * Checks whether the given object is a DOM node.
   *
   * @param value object to check whether it's a DOM node
   * @return true is object is a DOM node
   */const wt=function(e){return typeof b==="function"&&e instanceof b};function Rt(e,t,o){u(e,(e=>{e.call(n,t,o,pt)}))}
/**
   * _sanitizeElements
   *
   * @protect nodeName
   * @protect textContent
   * @protect removeChild
   * @param currentNode to check for permission to exist
   * @return true if node was killed, false if left alive
   */const Lt=function(e){let t=null;Rt(me.beforeSanitizeElements,e,null);if(bt(e)){At(e);return true}const o=mt(e.nodeName);Rt(me.uponSanitizeElement,e,{tagName:o,allowedTags:Ne});if(ke&&e.hasChildNodes()&&!wt(e.firstElementChild)&&N(/<[/\w!]/g,e.innerHTML)&&N(/<[/\w!]/g,e.textContent)){At(e);return true}if(e.nodeType===J.progressingInstruction){At(e);return true}if(ke&&e.nodeType===J.comment&&N(/<[/\w]/g,e.data)){At(e);return true}if(!Ne[o]||Le[o]){if(!Le[o]&&vt(o)){if(Re.tagNameCheck instanceof RegExp&&N(Re.tagNameCheck,o))return false;if(Re.tagNameCheck instanceof Function&&Re.tagNameCheck(o))return false}if(Ye&&!qe[o]){const t=re(e)||e.parentNode;const n=oe(e)||e.childNodes;if(n&&t){const o=n.length;for(let r=o-1;r>=0;--r){const o=q(n[r],true);o.__removalCount=(e.__removalCount||0)+1;t.insertBefore(o,V(e))}}}At(e);return true}if(e instanceof w&&!Et(e)){At(e);return true}if((o==="noscript"||o==="noembed"||o==="noframes")&&N(/<\/no(script|embed|frames)/i,e.innerHTML)){At(e);return true}if(Ie&&e.nodeType===J.text){t=e.textContent;u([pe,de,he],(e=>{t=y(t,e," ")}));if(e.textContent!==t){p(n.removed,{element:e.cloneNode()});e.textContent=t}}Rt(me.afterSanitizeElements,e,null);return false};
/**
   * _isValidAttribute
   *
   * @param lcTag Lowercase tag name of containing element.
   * @param lcName Lowercase attribute name.
   * @param value Attribute value.
   * @return Returns true if `value` is valid, otherwise false.
   */const Ot=function(e,t,n){if(Be&&(t==="id"||t==="name")&&(n in o||n in dt))return false;if(xe&&!Oe[t]&&N(ge,t));else if(ve&&N(Te,t));else if(!be[t]||Oe[t]){if(!(vt(e)&&(Re.tagNameCheck instanceof RegExp&&N(Re.tagNameCheck,e)||Re.tagNameCheck instanceof Function&&Re.tagNameCheck(e))&&(Re.attributeNameCheck instanceof RegExp&&N(Re.attributeNameCheck,t)||Re.attributeNameCheck instanceof Function&&Re.attributeNameCheck(t))||t==="is"&&Re.allowCustomizedBuiltInElements&&(Re.tagNameCheck instanceof RegExp&&N(Re.tagNameCheck,n)||Re.tagNameCheck instanceof Function&&Re.tagNameCheck(n))))return false}else if(Ze[t]);else if(N(_e,y(n,Ee,"")));else if(t!=="src"&&t!=="xlink:href"&&t!=="href"||e==="script"||E(n,"data:")!==0||!Ke[e]){if(Ce&&!N(ye,y(n,Ee,"")));else if(n)return false}else;return true};
/**
   * _isBasicCustomElement
   * checks if at least one dash is included in tagName, and it's not the first char
   * for more sophisticated checking see https://github.com/sindresorhus/validate-element-name
   *
   * @param tagName name of the tag of the node to sanitize
   * @returns Returns true if the tag name meets the basic criteria for a custom element, otherwise false.
   */const vt=function(e){return e!=="annotation-xml"&&T(e,Ae)};
/**
   * _sanitizeAttributes
   *
   * @protect attributes
   * @protect nodeName
   * @protect removeAttribute
   * @protect setAttribute
   *
   * @param currentNode to sanitize
   */const xt=function(e){Rt(me.beforeSanitizeAttributes,e,null);const{attributes:t}=e;if(!t||bt(e))return;const o={attrName:"",attrValue:"",keepAttr:true,allowedAttributes:be,forceKeepAttr:void 0};let r=t.length;while(r--){const i=t[r];const{name:a,namespaceURI:l,value:s}=i;const c=mt(a);const f=s;let p=a==="value"?f:A(f);o.attrName=c;o.attrValue=p;o.keepAttr=true;o.forceKeepAttr=void 0;Rt(me.uponSanitizeAttribute,e,o);p=o.attrValue;if(We&&(c==="id"||c==="name")){_t(a,e);p=Ge+p}if(ke&&N(/((--!?|])>)|<\/(style|title)/i,p)){_t(a,e);continue}if(o.forceKeepAttr)continue;if(!o.keepAttr){_t(a,e);continue}if(!De&&N(/\/>/i,p)){_t(a,e);continue}Ie&&u([pe,de,he],(e=>{p=y(p,e," ")}));const d=mt(e.nodeName);if(Ot(d,c,p)){if(ie&&typeof Y==="object"&&typeof Y.getAttributeType==="function")if(l);else switch(Y.getAttributeType(d,c)){case"TrustedHTML":p=ie.createHTML(p);break;case"TrustedScriptURL":p=ie.createScriptURL(p);break}if(p!==f)try{l?e.setAttributeNS(l,a,p):e.setAttribute(a,p);bt(e)?At(e):m(n.removed)}catch(t){_t(a,e)}}else _t(a,e)}Rt(me.afterSanitizeAttributes,e,null)};
/**
   * _sanitizeShadowDOM
   *
   * @param fragment to iterate over recursively
   */const Ct=function e(t){let n=null;const o=St(t);Rt(me.beforeSanitizeShadowDOM,t,null);while(n=o.nextNode()){Rt(me.uponSanitizeShadowNode,n,null);Lt(n);xt(n);n.content instanceof s&&e(n.content)}Rt(me.afterSanitizeShadowDOM,t,null)};n.sanitize=function(e){let t=arguments.length>1&&arguments[1]!==void 0?arguments[1]:{};let o=null;let i=null;let a=null;let l=null;ot=!e;ot&&(e="\x3c!--\x3e");if(typeof e!=="string"&&!wt(e)){if(typeof e.toString!=="function")throw S("toString is not a function");e=e.toString();if(typeof e!=="string")throw S("dirty is not a string, aborting")}if(!n.isSupported)return e;Ue||gt(t);n.removed=[];typeof e==="string"&&(je=false);if(je){if(e.nodeName){const t=mt(e.nodeName);if(!Ne[t]||Le[t])throw S("root node is forbidden and cannot be sanitized in-place")}}else if(e instanceof b){o=Nt("\x3c!----\x3e");i=o.ownerDocument.importNode(e,true);i.nodeType===J.element&&i.nodeName==="BODY"||i.nodeName==="HTML"?o=i:o.appendChild(i)}else{if(!ze&&!Ie&&!Me&&e.indexOf("<")===-1)return ie&&Fe?ie.createHTML(e):e;o=Nt(e);if(!o)return ze?null:Fe?ae:""}o&&Pe&&At(o.firstChild);const c=St(je?e:o);while(a=c.nextNode()){Lt(a);xt(a);a.content instanceof s&&Ct(a.content)}if(je)return e;if(ze){if(He){l=ce.call(o.ownerDocument);while(o.firstChild)l.appendChild(o.firstChild)}else l=o;(be.shadowroot||be.shadowrootmode)&&(l=fe.call(r,l,true));return l}let f=Me?o.outerHTML:o.innerHTML;Me&&Ne["!doctype"]&&o.ownerDocument&&o.ownerDocument.doctype&&o.ownerDocument.doctype.name&&N(K,o.ownerDocument.doctype.name)&&(f="<!DOCTYPE "+o.ownerDocument.doctype.name+">\n"+f);Ie&&u([pe,de,he],(e=>{f=y(f,e," ")}));return ie&&Fe?ie.createHTML(f):f};n.setConfig=function(){let e=arguments.length>0&&arguments[0]!==void 0?arguments[0]:{};gt(e);Ue=true};n.clearConfig=function(){pt=null;Ue=false};n.isValidAttribute=function(e,t,n){pt||gt({});const o=mt(e);const r=mt(t);return Ot(o,r,n)};n.addHook=function(e,t){typeof t==="function"&&p(me[e],t)};n.removeHook=function(e,t){if(t!==void 0){const n=f(me[e],t);return n===-1?void 0:d(me[e],n,1)[0]}return m(me[e])};n.removeHooks=function(e){me[e]=[]};n.removeAllHooks=function(){me=te()};return n}var oe=ne();export{oe as default};

