import*as n from"child_process";import t from"process";import*as e from"fs";var r={};var c=t;const isLinux$1=()=>c.platform==="linux";let s=null;const getReport$1=()=>{if(!s)if(isLinux$1()&&c.report){const n=c.report.excludeNetwork;c.report.excludeNetwork=true;s=c.report.getReport();c.report.excludeNetwork=n}else s={};return s};r={isLinux:isLinux$1,getReport:getReport$1};var i=r;var o=e;try{"default"in e&&(o=e.default)}catch(n){}var l={};const a=o;const u="/usr/bin/ldd";
/**
 * Read the content of a file synchronous
 *
 * @param {string} path
 * @returns {string}
 */const readFileSync$1=n=>a.readFileSync(n,"utf-8")
/**
 * Read the content of a file
 *
 * @param {string} path
 * @returns {Promise<string>}
 */;const readFile$1=n=>new Promise(((t,e)=>{a.readFile(n,"utf-8",((n,r)=>{n?e(n):t(r)}))}));l={LDD_PATH:u,readFileSync:readFileSync$1,readFile:readFile$1};var d=l;var f=n;try{"default"in n&&(f=n.default)}catch(n){}var y={};const m=f;const{isLinux:v,getReport:L}=i;const{LDD_PATH:p,readFile:h,readFileSync:S}=d;let b;let x;const w="getconf GNU_LIBC_VERSION 2>&1 || true; ldd --version 2>&1 || true";let N="";const safeCommand=()=>N||new Promise((n=>{m.exec(w,((t,e)=>{N=t?" ":e;n(N)}))}));const safeCommandSync=()=>{if(!N)try{N=m.execSync(w,{encoding:"utf8"})}catch(n){N=" "}return N};
/**
 * A String constant containing the value `glibc`.
 * @type {string}
 * @public
 */const G="glibc";
/**
 * A Regexp constant to get the GLIBC Version.
 * @type {string}
 */const g=/LIBC[a-z0-9 \-).]*?(\d+\.\d+)/i;
/**
 * A String constant containing the value `musl`.
 * @type {string}
 * @public
 */const R="musl";const isFileMusl=n=>n.includes("libc.musl-")||n.includes("ld-musl-");const familyFromReport=()=>{const n=L();return n.header&&n.header.glibcVersionRuntime?G:Array.isArray(n.sharedObjects)&&n.sharedObjects.some(isFileMusl)?R:null};const familyFromCommand=n=>{const[t,e]=n.split(/[\r\n]+/);return t&&t.includes(G)?G:e&&e.includes(R)?R:null};const getFamilyFromLddContent=n=>n.includes("musl")?R:n.includes("GNU C Library")?G:null;const familyFromFilesystem=async()=>{if(b!==void 0)return b;b=null;try{const n=await h(p);b=getFamilyFromLddContent(n)}catch(n){}return b};const familyFromFilesystemSync=()=>{if(b!==void 0)return b;b=null;try{const n=S(p);b=getFamilyFromLddContent(n)}catch(n){}return b};
/**
 * Resolves with the libc family when it can be determined, `null` otherwise.
 * @returns {Promise<?string>}
 */const family=async()=>{let n=null;if(v()){n=await familyFromFilesystem();n||(n=familyFromReport());if(!n){const t=await safeCommand();n=familyFromCommand(t)}}return n};
/**
 * Returns the libc family when it can be determined, `null` otherwise.
 * @returns {?string}
 */const familySync=()=>{let n=null;if(v()){n=familyFromFilesystemSync();n||(n=familyFromReport());if(!n){const t=safeCommandSync();n=familyFromCommand(t)}}return n};
/**
 * Resolves `true` only when the platform is Linux and the libc family is not `glibc`.
 * @returns {Promise<boolean>}
 */const isNonGlibcLinux=async()=>v()&&await family()!==G
/**
 * Returns `true` only when the platform is Linux and the libc family is not `glibc`.
 * @returns {boolean}
 */;const isNonGlibcLinuxSync=()=>v()&&familySync()!==G;const versionFromFilesystem=async()=>{if(x!==void 0)return x;x=null;try{const n=await h(p);const t=n.match(g);t&&(x=t[1])}catch(n){}return x};const versionFromFilesystemSync=()=>{if(x!==void 0)return x;x=null;try{const n=S(p);const t=n.match(g);t&&(x=t[1])}catch(n){}return x};const versionFromReport=()=>{const n=L();return n.header&&n.header.glibcVersionRuntime?n.header.glibcVersionRuntime:null};const versionSuffix=n=>n.trim().split(/\s+/)[1];const versionFromCommand=n=>{const[t,e,r]=n.split(/[\r\n]+/);return t&&t.includes(G)?versionSuffix(t):e&&r&&e.includes(R)?versionSuffix(r):null};
/**
 * Resolves with the libc version when it can be determined, `null` otherwise.
 * @returns {Promise<?string>}
 */const version=async()=>{let n=null;if(v()){n=await versionFromFilesystem();n||(n=versionFromReport());if(!n){const t=await safeCommand();n=versionFromCommand(t)}}return n};
/**
 * Returns the libc version when it can be determined, `null` otherwise.
 * @returns {?string}
 */const versionSync=()=>{let n=null;if(v()){n=versionFromFilesystemSync();n||(n=versionFromReport());if(!n){const t=safeCommandSync();n=versionFromCommand(t)}}return n};y={GLIBC:G,MUSL:R,family:family,familySync:familySync,isNonGlibcLinux:isNonGlibcLinux,isNonGlibcLinuxSync:isNonGlibcLinuxSync,version:version,versionSync:versionSync};var C=y;const F=y.GLIBC,I=y.MUSL,B=y.family,U=y.familySync,_=y.isNonGlibcLinux,A=y.isNonGlibcLinuxSync,D=y.version,P=y.versionSync;export{F as GLIBC,I as MUSL,C as default,B as family,U as familySync,_ as isNonGlibcLinux,A as isNonGlibcLinuxSync,D as version,P as versionSync};

