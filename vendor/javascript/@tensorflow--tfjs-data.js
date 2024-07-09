import*as t from"@tensorflow/tfjs-core";import{util as e,env as r,tensor as s,tensor1d as i,tensor2d as a,browser as n,cast as o,expandDims as c,image as l,reshape as h,tidy as u}from"@tensorflow/tfjs-core";import*as m from"seedrandom";import{i as f,a as d,b as w,c as p,d as y,Z as g,e as b,f as C,L as z,O as S}from"../_/7mV6sfA6.js";
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
 *
 * =============================================================================
 */
class Dataset{constructor(){this.size=null}
/**
     * Groups elements into batches.
     *
     * It is assumed that each of the incoming dataset elements has the same
     * structure -- i.e. the same set of keys at each location in an object
     * hierarchy.  For each key, the resulting `Dataset` provides a batched
     * element collecting all of the incoming values for that key.
     *
     *  * Incoming primitives are grouped into a 1-D Tensor.
     *  * Incoming Tensors are grouped into a new Tensor where the 0th axis is
     *    the batch dimension.
     *  * Incoming arrays are converted to Tensor and then batched.
     *  * A nested array is interpreted as an n-D Tensor, so the batched result
     *    has n+1 dimensions.
     *  * An array that cannot be converted to Tensor produces an error.
     *
     * If an array should not be batched as a unit, it should first be converted
     * to an object with integer keys.
     *
     * Here are a few examples:
     *
     * Batch a dataset of numbers:
     * ```js
     * const a = tf.data.array([1, 2, 3, 4, 5, 6, 7, 8]).batch(4);
     * await a.forEachAsync(e => e.print());
     * ```
     *
     * Batch a dataset of arrays:
     * ```js
     * const b = tf.data.array([[1], [2], [3], [4], [5], [6], [7], [8]]).batch(4);
     * await b.forEachAsync(e => e.print());
     * ```
     *
     * Batch a dataset of objects:
     * ```js
     * const c = tf.data.array([{a: 1, b: 11}, {a: 2, b: 12}, {a: 3, b: 13},
     *   {a: 4, b: 14}, {a: 5, b: 15}, {a: 6, b: 16}, {a: 7, b: 17},
     *   {a: 8, b: 18}]).batch(4);
     * await c.forEachAsync(e => {
     *   console.log('{');
     *   for(var key in e) {
     *     console.log(key+':');
     *     e[key].print();
     *   }
     *   console.log('}');
     * })
     * ```
     *
     * @param batchSize The number of elements desired per batch.
     * @param smallLastBatch Whether to emit the final batch when it has fewer
     *   than batchSize elements. Default true.
     * @returns A `Dataset`, from which a stream of batches can be obtained.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */
batch(e,r=true){const s=this;t.util.assert(e>0,(()=>`batchSize needs to be positive, but it is\n      ${e}`));let i;i=this.size===Infinity||this.size==null?this.size:r?Math.ceil(this.size/e):Math.floor(this.size/e);return datasetFromIteratorFn((async()=>(await s.iterator()).columnMajorBatch(e,r,deepBatchConcat)),i)}
/**
     * Concatenates this `Dataset` with another.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3]);
     * const b = tf.data.array([4, 5, 6]);
     * const c = a.concatenate(b);
     * await c.forEachAsync(e => console.log(e));
     * ```
     *
     * @param dataset A `Dataset` to be concatenated onto this one.
     * @returns A `Dataset`.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */concatenate(t){const e=this;let r;r=this.size===Infinity||t.size===Infinity?Infinity:this.size!=null&&t.size!=null?this.size+t.size:null;return datasetFromIteratorFn((async()=>(await e.iterator()).concatenate(await t.iterator())),r)}
/**
     * Filters this dataset according to `predicate`.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
     *   .filter(x => x%2 === 0);
     * await a.forEachAsync(e => console.log(e));
     * ```
     *
     * @param predicate A function mapping a dataset element to a boolean or a
     * `Promise` for one.
     *
     * @returns A `Dataset` of elements for which the predicate was true.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */filter(e){const r=this;let s;s=this.size===Infinity?Infinity:null;return datasetFromIteratorFn((async()=>(await r.iterator()).filter((r=>t.tidy((()=>e(r)))))),s)}
/**
     * Apply a function to every element of the dataset.
     *
     * After the function is applied to a dataset element, any Tensors contained
     * within that element are disposed.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3]);
     * await a.forEachAsync(e => console.log(e));
     * ```
     *
     * @param f A function to apply to each dataset element.
     * @returns A `Promise` that resolves after all elements have been processed.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */async forEachAsync(t){return(await this.iterator()).forEachAsync(t)}
/**
     * Maps this dataset through a 1-to-1 transform.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3]).map(x => x*x);
     * await a.forEachAsync(e => console.log(e));
     * ```
     *
     * @param transform A function mapping a dataset element to a transformed
     *   dataset element.
     *
     * @returns A `Dataset` of transformed elements.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */map(e){const r=this;return datasetFromIteratorFn((async()=>(await r.iterator()).map((r=>t.tidy((()=>e(r)))))),this.size)}
/**
     * Maps this dataset through an async 1-to-1 transform.
     *
     * ```js
     * const a =
     *  tf.data.array([1, 2, 3]).mapAsync(x => new Promise(function(resolve){
     *    setTimeout(() => {
     *      resolve(x * x);
     *    }, Math.random()*1000 + 500);
     *  }));
     * console.log(await a.toArray());
     * ```
     *
     * @param transform A function mapping a dataset element to a `Promise` for a
     *   transformed dataset element.  This transform is responsible for disposing
     *   any intermediate `Tensor`s, i.e. by wrapping its computation in
     *   `tf.tidy()`; that cannot be automated here (as it is in the synchronous
     *   `map()` case).
     *
     * @returns A `Dataset` of transformed elements.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */mapAsync(t){const e=this;return datasetFromIteratorFn((async()=>(await e.iterator()).mapAsync(t)),this.size)}
/**
     *  Creates a `Dataset` that prefetches elements from this dataset.
     *
     * @param bufferSize: An integer specifying the number of elements to be
     *   prefetched.
     * @returns A `Dataset`.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */prefetch(t){if(t==null)throw new RangeError("`Dataset.prefetch()` requires bufferSize to be specified.");const e=this;return datasetFromIteratorFn((async()=>(await e.iterator()).prefetch(t)),this.size)}
/**
     * Repeats this dataset `count` times.
     *
     * NOTE: If this dataset is a function of global state (e.g. a random number
     * generator), then different repetitions may produce different elements.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3]).repeat(3);
     * await a.forEachAsync(e => console.log(e));
     * ```
     *
     * @param count: (Optional) An integer, representing the number of times
     *   the dataset should be repeated. The default behavior (if `count` is
     *   `undefined` or negative) is for the dataset be repeated indefinitely.
     * @returns A `Dataset`.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */repeat(t){const e=this;let r;r=this.size!=null&&t>0?this.size*t:t===0?0:this.size!=null&&(t===void 0||t<0)?Infinity:null;return datasetFromIteratorFn((async()=>{const r=f((async()=>({value:await e.iterator(),done:false})));return d(r.take(t))}),r)}
/**
     * Creates a `Dataset` that skips `count` initial elements from this dataset.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3, 4, 5, 6]).skip(3);
     * await a.forEachAsync(e => console.log(e));
     * ```
     *
     * @param count: The number of elements of this dataset that should be skipped
     *   to form the new dataset.  If `count` is greater than the size of this
     *   dataset, the new dataset will contain no elements.  If `count`
     *   is `undefined` or negative, skips the entire dataset.
     *
     * @returns A `Dataset`.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */skip(t){const e=this;let r;r=this.size!=null&&t>=0&&this.size>=t?this.size-t:this.size!=null&&(this.size<t||t===void 0||t<0)?0:null;return datasetFromIteratorFn((async()=>(await e.iterator()).skip(t)),r)}
/**
     * Pseudorandomly shuffles the elements of this dataset. This is done in a
     * streaming manner, by sampling from a given number of prefetched elements.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3, 4, 5, 6]).shuffle(3);
     * await a.forEachAsync(e => console.log(e));
     * ```
     *
     * @param bufferSize: An integer specifying the number of elements from this
     *   dataset from which the new dataset will sample.
     * @param seed: (Optional) An integer specifying the random seed that will
     *   be used to create the distribution.
     * @param reshuffleEachIteration: (Optional) A boolean, which if true
     *   indicates that the dataset should be pseudorandomly reshuffled each time
     *   it is iterated over. If false, elements will be returned in the same
     *   shuffled order on each iteration. (Defaults to `true`.)
     * @returns A `Dataset`.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */shuffle(e,r,s=true){if(e==null||e<0)throw this.size==null?new RangeError("`Dataset.shuffle()` requires bufferSize to be specified."):new RangeError(`\`Dataset.shuffle()\` requires bufferSize to be specified.  If your data fits in main memory (for regular JS objects), and/or GPU memory (for \`tf.Tensor\`s), consider setting bufferSize to the dataset size (${this.size} elements)`);const i=this;const a=m.alea(r||t.util.now().toString());return datasetFromIteratorFn((async()=>{let t=a.int32();s&&(t+=a.int32());return(await i.iterator()).shuffle(e,t.toString())}),this.size)}
/**
     * Creates a `Dataset` with at most `count` initial elements from this
     * dataset.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3, 4, 5, 6]).take(3);
     * await a.forEachAsync(e => console.log(e));
     * ```
     *
     * @param count: The number of elements of this dataset that should be taken
     *   to form the new dataset.  If `count` is `undefined` or negative, or if
     *   `count` is greater than the size of this dataset, the new dataset will
     *   contain all elements of this dataset.
     * @returns A `Dataset`.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */take(t){const e=this;let r;r=this.size!=null&&this.size>t?t:this.size!=null&&this.size<=t?this.size:null;return datasetFromIteratorFn((async()=>(await e.iterator()).take(t)),r)}
/**
     * Collect all elements of this dataset into an array.
     *
     * Obviously this will succeed only for small datasets that fit in memory.
     * Useful for testing and generally should be avoided if possible.
     *
     * ```js
     * const a = tf.data.array([1, 2, 3, 4, 5, 6]);
     * console.log(await a.toArray());
     * ```
     *
     * @returns A Promise for an array of elements, which will resolve
     *   when a new stream has been obtained and fully consumed.
     *
     * @doc {heading: 'Data', subheading: 'Classes'}
     */async toArray(){if(this.size===Infinity)throw new Error("Can not convert infinite data stream to array.");return(await this.iterator()).toArray()}
/**
     * Collect all elements of this dataset into an array with prefetching 100
     * elements. This is useful for testing, because the prefetch changes the
     * order in which the Promises are resolved along the processing pipeline.
     * This may help expose bugs where results are dependent on the order of
     * Promise resolution rather than on the logical order of the stream (i.e.,
     * due to hidden mutable state).
     *
     * @returns A Promise for an array of elements, which will resolve
     *   when a new stream has been obtained and fully consumed.
     */async toArrayForTest(){if(this.size===Infinity)throw new Error("Can not convert infinite data stream to array.");return(await this.iterator()).toArrayForTest()}}Dataset.MAX_BUFFER_SIZE=1e4;function datasetFromIteratorFn(t,e=null){return new class extends Dataset{constructor(){super(...arguments);this.size=e}async iterator(){return t()}}}
/**
 * Create a `Dataset` from an array of elements.
 *
 * Create a Dataset from an array of objects:
 * ```js
 * const a = tf.data.array([{'item': 1}, {'item': 2}, {'item': 3}]);
 * await a.forEachAsync(e => console.log(e));
 * ```
 *
 * Create a Dataset from an array of numbers:
 * ```js
 * const a = tf.data.array([4, 5, 6]);
 * await a.forEachAsync(e => console.log(e));
 * ```
 * @param items An array of elements that will be parsed as items in a dataset.
 *
 * @doc {heading: 'Data', subheading: 'Creation', namespace: 'data'}
 */function array(t){return datasetFromIteratorFn((async()=>w(t)),t.length)}function zip(t){if(!p(t))throw new Error("The argument to zip() must be an object or array.");let e;if(Array.isArray(t))for(let r=0;r<t.length;r++)e=e==null?t[r].size:Math.min(e,t[r].size);else if(t instanceof Object)for(const r in t)e=e==null?t[r].size:Math.min(e,t[r].size);return datasetFromIteratorFn((async()=>{const e=await y(t,(t=>{if(t instanceof Dataset)return{value:t.iterator(),recurse:false};if(p(t))return{value:null,recurse:true};throw new Error("Leaves of the structure passed to zip() must be Datasets, not primitives.")}));return b(e,g.SHORTEST)}),e)}function deepBatchConcat(t){if(t===null)return null;const e=t[0];if(C(e)){const e=batchConcat(t);return{value:e,recurse:false}}return{value:null,recurse:true}}function batchConcat(e){if(e.length===0)throw new Error("Can't make a batch of zero elements.");return e[0]instanceof t.Tensor?t.stack(e):t.tensor(e)}
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
 *
 * =============================================================================
 */class TextLineDataset extends Dataset{
/**
     * Create a `TextLineDataset`.
     *
     * @param input A `DataSource` providing a chunked, UTF8-encoded byte stream.
     */
constructor(t){super();this.input=t}async iterator(){const t=await this.input.iterator();const e=t.decodeUTF8();const r=e.split("\n").map((t=>{t.endsWith("\r")&&(t=t.slice(0,-1));return t}));return r}}
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
 *
 * =============================================================================
 */const v='"';const I=Symbol("out");const F=Symbol("field");const E=Symbol("quote");const D=Symbol("quoteafterquote");const k=Symbol("quoteinquote");class CSVDataset extends Dataset{async columnNames(){this.columnNamesValidated||await this.setColumnNames();return this.configuredColumnsOnly?Object.keys(this.columnConfigs):this.fullColumnNames}async setColumnNames(){const t=await this.maybeReadHeaderLine();if(!this.fullColumnNames&&!t)throw new Error("Column names must be provided if there is no header line.");this.fullColumnNames&&t&&e.assert(t.length===this.fullColumnNames.length,(()=>"The length of provided columnNames ("+this.fullColumnNames.length.toString()+") does not match the length of the header line read from file ("+t.length.toString()+")."));this.fullColumnNames||(this.fullColumnNames=t);const r=this.fullColumnNames.reduce(((t,e)=>{t[e]=t[e]+1||1;return t}),{});const s=Object.keys(r).filter((t=>r[t]>1));e.assert(s.length===0,(()=>"Duplicate column names found: "+s.toString()));if(this.columnConfigs)for(const t of Object.keys(this.columnConfigs)){const e=this.fullColumnNames.indexOf(t);if(e===-1)throw new Error('The key "'+t+'" provided in columnConfigs does not match any of the column names ('+this.fullColumnNames.toString()+").")}this.columnNamesValidated=true}async maybeReadHeaderLine(){if(this.hasHeader){const t=await this.base.iterator();const e=await t.next();if(e.done)throw new Error("No data was found for CSV parsing.");const r=e.value;const s=this.parseRow(r,false);return s}return null}
/**
     * Create a `CSVDataset`.
     *
     * @param input A `DataSource` providing a chunked, UTF8-encoded byte stream.
     * @param csvConfig (Optional) A CSVConfig object that contains configurations
     *     of reading and decoding from CSV file(s).
     *
     *     hasHeader: (Optional) A boolean value that indicates whether the first
     *     row of provided CSV file is a header line with column names, and should
     *     not be included in the data. Defaults to `true`.
     *
     *     columnNames: (Optional) A list of strings that corresponds to
     *     the CSV column names, in order. If provided, it ignores the column
     *     names inferred from the header row. If not provided, infers the column
     *     names from the first row of the records. If hasHeader is false and
     *     columnNames is not provided, this method throws an error.
     *
     *     columnConfigs: (Optional) A dictionary whose key is column names, value
     *     is an object stating if this column is required, column's data type,
     *     default value, and if this column is label. If provided, keys must
     *     correspond to names provided in columnNames or inferred from the file
     *     header lines. If isLabel is true any column, returns an array of two
     *     items: the first item is a dict of features key/value pairs, the second
     *     item is a dict of labels key/value pairs. If no feature is marked as
     *     label, returns a dict of features only.
     *
     *     configuredColumnsOnly (Optional) If true, only columns provided in
     *     columnConfigs will be parsed and provided during iteration.
     *
     *     delimiter (Optional) The string used to parse each line of the input
     *     file. Defaults to `,`.
     */constructor(t,r){super();this.input=t;this.hasHeader=true;this.fullColumnNames=null;this.columnNamesValidated=false;this.columnConfigs=null;this.configuredColumnsOnly=false;this.delimiter=",";this.delimWhitespace=false;this.base=new TextLineDataset(t);r||(r={});this.hasHeader=r.hasHeader!==false;this.fullColumnNames=r.columnNames;this.columnConfigs=r.columnConfigs;this.configuredColumnsOnly=r.configuredColumnsOnly;if(r.delimWhitespace){e.assert(r.delimiter==null,(()=>"Delimiter should not be provided when delimWhitespace is true."));this.delimWhitespace=true;this.delimiter=" "}else this.delimiter=r.delimiter?r.delimiter:","}async iterator(){this.columnNamesValidated||await this.setColumnNames();let t=await this.base.iterator();this.hasHeader&&(t=t.skip(1));return t.map((t=>this.makeDataElement(t)))}makeDataElement(t){const e=this.parseRow(t);const r={};const s={};for(let i=0;i<this.fullColumnNames.length;i++){const a=this.fullColumnNames[i];const n=this.columnConfigs?this.columnConfigs[a]:null;if(!this.configuredColumnsOnly||n){const o=e[i];let c=null;if(o==="")if(n&&n.default!==void 0)c=n.default;else{if(n&&(n.required||n.isLabel))throw new Error(`Required column ${a} is empty in this line: ${t}`);c=void 0}else{const t=Number(o);if(isNaN(t))c=n&&n.dtype==="bool"?this.getBoolean(o):o;else if(n&&n.dtype)switch(n.dtype){case"float32":c=t;break;case"int32":c=Math.floor(t);break;case"bool":c=this.getBoolean(o);break;default:c=t}else c=t}n&&n.isLabel?s[a]=c:r[a]=c}}return Object.keys(s).length===0?r:{xs:r,ys:s}}getBoolean(t){return t==="1"||t.toLowerCase()==="true"?1:0}parseRow(t,e=true){const r=[];let s=0;const i=t.length;let a=I;for(let e=0;e<i;e++)switch(a){case I:switch(t.charAt(e)){case v:s=e+1;a=E;break;case this.delimiter:s=e+1;if(this.delimiter===" "&&this.delimWhitespace)break;r.push("");a=I;break;default:a=F;s=e;break}break;case F:switch(t.charAt(e)){case this.delimiter:r.push(t.substring(s,e));a=I;s=e+1;break;default:}break;case E:switch(t.charAt(e)){case v:a=D;break;default:}break;case D:switch(t.charAt(e)){case this.delimiter:r.push(t.substring(s,e-1));a=I;s=e+1;break;case v:a=E;break;default:a=k;break}break;case k:switch(t.charAt(e)){case v:a=E;break;default:}break;default:}a===D?r.push(t.substring(s,i-1)):r.push(t.substring(s));if(e&&r.length!==this.fullColumnNames.length)throw new Error(`Invalid row in csv file. Should have ${this.fullColumnNames.length} elements in a row, but got ${r}`);return r}}
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
 *
 * =============================================================================
 */class MicrophoneIterator extends z{constructor(t){super();this.microphoneConfig=t;this.isClosed=false;this.fftSize=t.fftSize||1024;const e=Math.log2(this.fftSize);if(this.fftSize<0||e<4||e>14||!Number.isInteger(e))throw new Error(`Invalid fftSize: it must be a power of 2 between 2 to 4 and 2 to 14, but got ${this.fftSize}`);this.numFrames=t.numFramesPerSpectrogram||43;this.sampleRateHz=t.sampleRateHz;this.columnTruncateLength=t.columnTruncateLength||this.fftSize;this.audioTrackConstraints=t.audioTrackConstraints;this.smoothingTimeConstant=t.smoothingTimeConstant||0;this.includeSpectrogram=t.includeSpectrogram!==false;this.includeWaveform=t.includeWaveform===true;if(!this.includeSpectrogram&&!this.includeWaveform)throw new Error("Both includeSpectrogram and includeWaveform are false. At least one type of data should be returned.")}summary(){return"microphone"}static async create(t={}){if(!r().get("IS_BROWSER"))throw new Error("microphone API is only supported in browser environment.");const e=new MicrophoneIterator(t);await e.start();return e}async start(){try{this.stream=await navigator.mediaDevices.getUserMedia({audio:this.audioTrackConstraints==null||this.audioTrackConstraints,video:false})}catch(t){throw new Error(`Error thrown while initializing video stream: ${t.message}`)}if(!this.stream)throw new Error("Could not obtain audio from microphone.");const t=window.AudioContext||window.webkitAudioContext;this.audioContext=new t;if(this.sampleRateHz){if(this.audioContext.sampleRate!==this.sampleRateHz)throw new Error(`Mismatch in sampling rate: Expected: ${this.sampleRateHz}; Actual: ${this.audioContext.sampleRate}`)}else this.sampleRateHz=this.audioContext.sampleRate;const e=this.audioContext.createMediaStreamSource(this.stream);this.analyser=this.audioContext.createAnalyser();this.analyser.fftSize=this.fftSize*2;this.analyser.smoothingTimeConstant=this.smoothingTimeConstant;e.connect(this.analyser);this.freqData=new Float32Array(this.fftSize);this.timeData=new Float32Array(this.fftSize)}async next(){if(this.isClosed)return{value:null,done:true};let t;let e;const r=await this.getAudioData();if(this.includeSpectrogram){const e=this.flattenQueue(r.freqDataQueue);t=this.getTensorFromAudioDataArray(e,[this.numFrames,this.columnTruncateLength,1])}if(this.includeWaveform){const t=this.flattenQueue(r.timeDataQueue);e=this.getTensorFromAudioDataArray(t,[this.numFrames*this.fftSize,1])}return{value:{spectrogram:t,waveform:e},done:false}}async capture(){return(await this.next()).value}async getAudioData(){const t=[];const e=[];let r=0;return new Promise((s=>{const i=setInterval((()=>{if(this.includeSpectrogram){this.analyser.getFloatFrequencyData(this.freqData);this.freqData[0]===-Infinity&&s({freqDataQueue:t,timeDataQueue:e});t.push(this.freqData.slice(0,this.columnTruncateLength))}if(this.includeWaveform){this.analyser.getFloatTimeDomainData(this.timeData);e.push(this.timeData.slice())}if(++r===this.numFrames){clearInterval(i);s({freqDataQueue:t,timeDataQueue:e})}}),this.fftSize/this.sampleRateHz*1e3)}))}stop(){if(!this.isClosed){this.isClosed=true;this.analyser.disconnect();this.audioContext.close();this.stream!=null&&this.stream.getTracks().length>0&&this.stream.getTracks()[0].stop()}}toArray(){throw new Error("Can not convert infinite audio stream to array.")}getSampleRate(){return this.sampleRateHz}flattenQueue(t){const e=t[0].length;const r=new Float32Array(t.length*e);t.forEach(((t,s)=>r.set(t,s*e)));return r}getTensorFromAudioDataArray(t,r){const i=new Float32Array(e.sizeFromShape(r));i.set(t,i.length-t.length);return s(i,r)}}
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
 *
 * =============================================================================
 */class WebcamIterator extends z{constructor(t,e){super();this.webcamVideoElement=t;this.webcamConfig=e;this.isClosed=true;this.resize=false;if(this.needToResize()){this.resize=true;this.cropSize=[this.webcamConfig.resizeHeight,this.webcamConfig.resizeWidth];this.cropBoxInd=i([0],"int32");if(this.webcamConfig.centerCrop){const t=this.webcamConfig.resizeWidth*1/this.webcamVideoElement.width;const e=this.webcamConfig.resizeHeight*1/this.webcamVideoElement.height;const r=(1-t)/2;const s=(1-e)/2;const i=r+t;const n=e+s;this.cropBox=a([s,r,n,i],[1,4])}else this.cropBox=a([0,0,1,1],[1,4])}}summary(){return"webcam"}static async create(t,e={}){if(!r().get("IS_BROWSER"))throw new Error("tf.data.webcam is only supported in browser environment.");if(!t){t=document.createElement("video");if(!e.resizeWidth||!e.resizeHeight)throw new Error("Please provide webcam video element, or resizeWidth and resizeHeight to create a hidden video element.");t.width=e.resizeWidth;t.height=e.resizeHeight}const s=new WebcamIterator(t,e);await s.start();return s}async start(){this.webcamConfig.facingMode&&e.assert(this.webcamConfig.facingMode==="user"||this.webcamConfig.facingMode==="environment",(()=>`Invalid webcam facing mode: ${this.webcamConfig.facingMode}. Please provide 'user' or 'environment'`));try{this.stream=await navigator.mediaDevices.getUserMedia({video:{deviceId:this.webcamConfig.deviceId,facingMode:this.webcamConfig.facingMode?this.webcamConfig.facingMode:"user",width:this.webcamVideoElement.width,height:this.webcamVideoElement.height}})}catch(t){t.message=`Error thrown while initializing video stream: ${t.message}`;throw t}if(!this.stream)throw new Error("Could not obtain video from webcam.");try{this.webcamVideoElement.srcObject=this.stream}catch(t){console.log(t);this.webcamVideoElement.src=window.URL.createObjectURL(this.stream)}this.webcamVideoElement.play();this.isClosed=false;return new Promise((t=>{this.webcamVideoElement.onloadedmetadata=()=>{t()}}))}async next(){if(this.isClosed)return{value:null,done:true};let t;try{t=n.fromPixels(this.webcamVideoElement)}catch(t){throw new Error(`Error thrown converting video to pixels: ${JSON.stringify(t)}`)}if(!this.resize)return{value:t,done:false};try{return{value:this.cropAndResizeFrame(t),done:false}}catch(t){throw new Error(`Error thrown cropping the video: ${t.message}`)}finally{t.dispose()}}needToResize(){return!(!this.webcamConfig.resizeWidth||!this.webcamConfig.resizeHeight||this.webcamVideoElement.width===this.webcamConfig.resizeWidth&&this.webcamVideoElement.height===this.webcamConfig.resizeHeight)}cropAndResizeFrame(t){return u((()=>{const e=c(o(t,"float32"),0);let r;r=l.cropAndResize(e,this.cropBox,this.cropBoxInd,this.cropSize,"bilinear");const s=r.shape;return h(r,s.slice(1))}))}async capture(){return(await this.next()).value}stop(){const t=this.stream.getTracks();t.forEach((t=>t.stop()));try{this.webcamVideoElement.srcObject=null}catch(t){console.log(t);this.webcamVideoElement.src=null}this.isClosed=true}toArray(){throw new Error("Can not convert infinite video stream to array.")}}
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
 *
 * =============================================================================
 */class DataSource{}
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
 *
 * =============================================================================
 */class StringIterator extends z{
/**
     * Splits a string stream on a given separator.
     *
     * It is assumed that the incoming chunk boundaries have no semantic meaning,
     * so conceptually the incoming stream is treated simply as the concatenation
     * of its elements.
     *
     * The outgoing stream provides chunks corresponding to the results of the
     * standard string split() operation (even if such a chunk spanned incoming
     * chunks).  The separators are not included.
     *
     * A typical usage is to split a text file (represented as a stream with
     * arbitrary chunk boundaries) into lines.
     *
     * @param upstream A readable stream of strings that can be treated as
     *   concatenated.
     * @param separator A character to split on.
     */
split(t){return new SplitIterator(this,t)}}class SplitIterator extends StringIterator{constructor(t,e){super();this.upstream=t;this.impl=new SplitIteratorImpl(t,e)}summary(){return this.impl.summary()}async next(){return this.impl.next()}}class SplitIteratorImpl extends S{constructor(t,e){super();this.upstream=t;this.separator=e;this.carryover=""}summary(){return`${this.upstream.summary()} -> Split('${this.separator}')`}async pump(){const t=await this.upstream.next();if(t.done){if(this.carryover==="")return false;this.outputQueue.push(this.carryover);this.carryover="";return true}const e=t.value.split(this.separator);e[0]=this.carryover+e[0];for(const t of e.slice(0,-1))this.outputQueue.push(t);this.carryover=e[e.length-1];return true}}
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
 *
 * =============================================================================
 */class ByteChunkIterator extends z{decodeUTF8(){return new Utf8Iterator(this)}}class Utf8Iterator extends StringIterator{constructor(t){super();this.upstream=t;this.impl=new Utf8IteratorImpl(t)}summary(){return this.impl.summary()}async next(){return this.impl.next()}}
/**
 * Decode a stream of UTF8-encoded byte arrays to a stream of strings.
 *
 * This is tricky because the incoming byte array boundaries may disrupt a
 * multi-byte UTF8 character. Thus any incomplete character data at the end of
 * a chunk must be carried over and prepended to the next chunk before
 * decoding. Luckily with native decoder, TextDecoder in browser and
 * string_decoder in node, byte array boundaries are handled automatically.
 *
 * In the context of an input pipeline for machine learning, UTF8 decoding is
 * needed to parse text files containing training examples or prediction
 * requests (e.g., formatted as CSV or JSON). We cannot use the built-in
 * decoding provided by FileReader.readAsText() because here we are in a
 * streaming context, which FileReader does not support.
 *
 * @param upstream A `LazyIterator` of `Uint8Arrays` containing UTF8-encoded
 *   text, which should be interpreted as concatenated.  No assumptions are
 *   made about the boundaries of the incoming chunks, so a multi-byte UTF8
 *   encoding of a character may span the boundary between chunks.  This
 *   naturally happens, for instance, when reading fixed-size byte arrays from a
 *   file.
 */class Utf8IteratorImpl extends S{constructor(t){super();this.upstream=t;if(r().get("IS_BROWSER"))this.decoder=new TextDecoder("utf-8");else{const{StringDecoder:t}=require("string_decoder");this.decoder=new t("utf8")}}summary(){return`${this.upstream.summary()} -> Utf8`}async pump(){const t=await this.upstream.next();let e;if(t.done)return false;e=t.value;let s;s=r().get("IS_BROWSER")?this.decoder.decode(e,{stream:true}):this.decoder.write(Buffer.from(e.buffer));this.outputQueue.push(s);return true}}
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
 *
 * =============================================================================
 */
/**
 * Provide a stream of chunks from a File, Blob, or Uint8Array.
 * @param file The source File, Blob or Uint8Array.
 * @param options Optional settings controlling file reading.
 * @returns a lazy Iterator of Uint8Arrays containing sequential chunks of the
 *   input File, Blob or Uint8Array.
 */class FileChunkIterator extends ByteChunkIterator{constructor(t,s={}){super();this.file=t;this.options=s;e.assert(t instanceof Uint8Array||!!r().get("IS_BROWSER")&&(t instanceof File||t instanceof Blob),(()=>"FileChunkIterator only supports File, Blob and Uint8Array right now."));this.offset=s.offset||0;this.chunkSize=s.chunkSize||1048576}summary(){return`FileChunks ${this.file}`}async next(){if(this.offset>=(this.file instanceof Uint8Array?this.file.byteLength:this.file.size))return{value:null,done:true};const t=new Promise(((t,e)=>{const r=this.offset+this.chunkSize;if(this.file instanceof Uint8Array)t(new Uint8Array(this.file.slice(this.offset,r)));else{const s=new FileReader;s.onload=r=>{let i=s.result;i instanceof ArrayBuffer&&(i=new Uint8Array(i));if(!(i instanceof Uint8Array))return e(new TypeError("FileReader returned unknown type."));t(i)};s.onabort=t=>e(new Error("Aborted"));s.onerror=t=>e(new Error(t.type));const i=this.file.slice(this.offset,r);s.readAsArrayBuffer(i)}this.offset=r}));return{value:await t,done:false}}}
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
 *
 * =============================================================================
 */async function urlChunkIterator(t,r={},s){let i;let a;if(typeof t==="string")i=t;else{i=t.url;a=getRequestInitFromRequest(t)}const n=await(s||e.fetch)(i,a);if(n.ok){const t=new Uint8Array(await n.arrayBuffer());return new FileChunkIterator(t,r)}throw new Error(n.statusText)}const getRequestInitFromRequest=t=>{const e={method:t.method,headers:t.headers,body:t.body,mode:t.mode,credentials:t.credentials,cache:t.cache,redirect:t.redirect,referrer:t.referrer,integrity:t.integrity};return e};
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
 *
 * =============================================================================
 */function isLocalPath(t){return typeof t==="string"&&t.slice(0,7)==="file://"}
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
 *
 * =============================================================================
 */class FileDataSource extends DataSource{
/**
     * Create a `FileDataSource`.
     *
     * @param input Local file path, or `File`/`Blob`/`Uint8Array` object to
     *     read. Local file only works in node environment.
     * @param options Options passed to the underlying `FileChunkIterator`s,
     *   such as {chunksize: 1024}.
     */
constructor(t,e={}){super();this.input=t;this.options=e}async iterator(){if(isLocalPath(this.input)&&r().get("IS_NODE")){const t=require("fs");this.input=t.readFileSync(this.input.slice(7))}return new FileChunkIterator(this.input,this.options)}}
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
 *
 * =============================================================================
 */class URLDataSource extends DataSource{
/**
     * Create a `URLDataSource`.
     *
     * @param url A source URL string, or a `Request` object.
     * @param options Options passed to the underlying `FileChunkIterator`s,
     *   such as {chunksize: 1024}.
     */
constructor(t,e={}){super();this.url=t;this.fileOptions=e}async iterator(){return isLocalPath(this.url)?new FileDataSource(this.url,this.fileOptions).iterator():urlChunkIterator(this.url,this.fileOptions)}}
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
 *
 * =============================================================================
 */
/**
 * Create a `CSVDataset` by reading and decoding CSV file(s) from provided URL
 * or local path if it's in Node environment.
 *
 * Note: If isLabel in columnConfigs is `true` for at least one column, the
 * element in returned `CSVDataset` will be an object of
 * `{xs:features, ys:labels}`: xs is a dict of features key/value pairs, ys
 * is a dict of labels key/value pairs. If no column is marked as label,
 * returns a dict of features only.
 *
 * ```js
 * const csvUrl =
 * 'https://storage.googleapis.com/tfjs-examples/multivariate-linear-regression/data/boston-housing-train.csv';
 *
 * async function run() {
 *   // We want to predict the column "medv", which represents a median value of
 *   // a home (in $1000s), so we mark it as a label.
 *   const csvDataset = tf.data.csv(
 *     csvUrl, {
 *       columnConfigs: {
 *         medv: {
 *           isLabel: true
 *         }
 *       }
 *     });
 *
 *   // Number of features is the number of column names minus one for the label
 *   // column.
 *   const numOfFeatures = (await csvDataset.columnNames()).length - 1;
 *
 *   // Prepare the Dataset for training.
 *   const flattenedDataset =
 *     csvDataset
 *     .map(({xs, ys}) =>
 *       {
 *         // Convert xs(features) and ys(labels) from object form (keyed by
 *         // column name) to array form.
 *         return {xs:Object.values(xs), ys:Object.values(ys)};
 *       })
 *     .batch(10);
 *
 *   // Define the model.
 *   const model = tf.sequential();
 *   model.add(tf.layers.dense({
 *     inputShape: [numOfFeatures],
 *     units: 1
 *   }));
 *   model.compile({
 *     optimizer: tf.train.sgd(0.000001),
 *     loss: 'meanSquaredError'
 *   });
 *
 *   // Fit the model using the prepared Dataset
 *   return model.fitDataset(flattenedDataset, {
 *     epochs: 10,
 *     callbacks: {
 *       onEpochEnd: async (epoch, logs) => {
 *         console.log(epoch + ':' + logs.loss);
 *       }
 *     }
 *   });
 * }
 *
 * await run();
 * ```
 *
 * @param source URL or local path to get CSV file. If it's a local path, it
 * must have prefix `file://` and it only works in node environment.
 * @param csvConfig (Optional) A CSVConfig object that contains configurations
 *     of reading and decoding from CSV file(s).
 *
 * @doc {
 *   heading: 'Data',
 *   subheading: 'Creation',
 *   namespace: 'data',
 *   configParamIndices: [1]
 *  }
 */function csv(t,e={}){return new CSVDataset(new URLDataSource(t),e)}
/**
 * Create a `Dataset` that produces each element by calling a provided function.
 *
 * Note that repeated iterations over this `Dataset` may produce different
 * results, because the function will be called anew for each element of each
 * iteration.
 *
 * Also, beware that the sequence of calls to this function may be out of order
 * in time with respect to the logical order of the Dataset. This is due to the
 * asynchronous lazy nature of stream processing, and depends on downstream
 * transformations (e.g. .shuffle()). If the provided function is pure, this is
 * no problem, but if it is a closure over a mutable state (e.g., a traversal
 * pointer), then the order of the produced elements may be scrambled.
 *
 * ```js
 * let i = -1;
 * const func = () =>
 *    ++i < 5 ? {value: i, done: false} : {value: null, done: true};
 * const ds = tf.data.func(func);
 * await ds.forEachAsync(e => console.log(e));
 * ```
 *
 * @param f A function that produces one data element on each call.
 */function func(t){const e=f(t);return datasetFromIteratorFn((async()=>e))}
/**
 * Create a `Dataset` that produces each element from provided JavaScript
 * generator, which is a function*
 * (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators#Generator_functions),
 * or a function that returns an
 * iterator
 * (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators#Generator_functions).
 *
 * The returned iterator should have `.next()` function that returns element in
 * format of `{value: TensorContainer, done:boolean}`.
 *
 * Example of creating a dataset from an iterator factory:
 * ```js
 * function makeIterator() {
 *   const numElements = 10;
 *   let index = 0;
 *
 *   const iterator = {
 *     next: () => {
 *       let result;
 *       if (index < numElements) {
 *         result = {value: index, done: false};
 *         index++;
 *         return result;
 *       }
 *       return {value: index, done: true};
 *     }
 *   };
 *   return iterator;
 * }
 * const ds = tf.data.generator(makeIterator);
 * await ds.forEachAsync(e => console.log(e));
 * ```
 *
 * Example of creating a dataset from a generator:
 * ```js
 * function* dataGenerator() {
 *   const numElements = 10;
 *   let index = 0;
 *   while (index < numElements) {
 *     const x = index;
 *     index++;
 *     yield x;
 *   }
 * }
 *
 * const ds = tf.data.generator(dataGenerator);
 * await ds.forEachAsync(e => console.log(e));
 * ```
 *
 * @param generator A JavaScript generator function that returns a JavaScript
 *     iterator.
 *
 * @doc {
 *   heading: 'Data',
 *   subheading: 'Creation',
 *   namespace: 'data',
 *   configParamIndices: [1]
 *  }
 */function generator(t){return datasetFromIteratorFn((async()=>{const e=await t();return f((()=>e.next()))}))}
/**
 * Create an iterator that generates `Tensor`s from webcam video stream. This
 * API only works in Browser environment when the device has webcam.
 *
 * Note: this code snippet only works when the device has a webcam. It will
 * request permission to open the webcam when running.
 * ```js
 * const videoElement = document.createElement('video');
 * videoElement.width = 100;
 * videoElement.height = 100;
 * const cam = await tf.data.webcam(videoElement);
 * const img = await cam.capture();
 * img.print();
 * cam.stop();
 * ```
 *
 * @param webcamVideoElement A `HTMLVideoElement` used to play video from
 *     webcam. If this element is not provided, a hidden `HTMLVideoElement` will
 *     be created. In that case, `resizeWidth` and `resizeHeight` must be
 *     provided to set the generated tensor shape.
 * @param webcamConfig A `WebcamConfig` object that contains configurations of
 *     reading and manipulating data from webcam video stream.
 *
 * @doc {
 *   heading: 'Data',
 *   subheading: 'Creation',
 *   namespace: 'data',
 *   ignoreCI: true
 *  }
 */async function webcam(t,e){return WebcamIterator.create(t,e)}
/**
 * Create an iterator that generates frequency-domain spectrogram `Tensor`s from
 * microphone audio stream with browser's native FFT. This API only works in
 * browser environment when the device has microphone.
 *
 * Note: this code snippet only works when the device has a microphone. It will
 * request permission to open the microphone when running.
 * ```js
 * const mic = await tf.data.microphone({
 *   fftSize: 1024,
 *   columnTruncateLength: 232,
 *   numFramesPerSpectrogram: 43,
 *   sampleRateHz:44100,
 *   includeSpectrogram: true,
 *   includeWaveform: true
 * });
 * const audioData = await mic.capture();
 * const spectrogramTensor = audioData.spectrogram;
 * spectrogramTensor.print();
 * const waveformTensor = audioData.waveform;
 * waveformTensor.print();
 * mic.stop();
 * ```
 *
 * @param microphoneConfig A `MicrophoneConfig` object that contains
 *     configurations of reading audio data from microphone.
 *
 * @doc {
 *   heading: 'Data',
 *   subheading: 'Creation',
 *   namespace: 'data',
 *   ignoreCI: true
 *  }
 */async function microphone(t){return MicrophoneIterator.create(t)}
/** @license See the LICENSE file. */const x="4.20.0";
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
 */export{CSVDataset,Dataset,FileDataSource,TextLineDataset,URLDataSource,array,csv,func,generator,microphone,x as version_data,webcam,zip};

