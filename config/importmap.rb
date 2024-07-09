# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin_all_from "app/javascript/i18n-js", under: "i18n-js"
pin "i18n-js", to: "https://ga.jspm.io/npm:i18n-js@4.4.3/dist/import/index.js"
pin "face-api.js" # @0.22.2
pin "@tensorflow/tfjs-core", to: "@tensorflow--tfjs-core.js" # @4.20.0
pin "crypto" # @2.0.1
pin "node-fetch" # @2.1.2
pin "seedrandom" # @3.0.5
pin "tslib" # @1.14.1
pin "util" # @2.0.1
pin "@tensorflow/tfjs-node", to: "@tensorflow--tfjs-node.js" # @4.20.0
pin "#lib/internal/streams/from.js", to: "#lib--internal--streams--from.js.js" # @3.6.2
pin "#lib/internal/streams/stream.js", to: "#lib--internal--streams--stream.js.js" # @3.6.2
pin "#lib/rng.js", to: "#lib--rng.js.js" # @3.3.2
pin "@mapbox/node-pre-gyp", to: "@mapbox--node-pre-gyp.js" # @1.0.9
pin "@tensorflow/tfjs", to: "@tensorflow--tfjs.js" # @4.20.0
pin "@tensorflow/tfjs-backend-cpu", to: "@tensorflow--tfjs-backend-cpu.js" # @4.20.0
pin "@tensorflow/tfjs-backend-cpu/dist/shared", to: "@tensorflow--tfjs-backend-cpu--dist--shared.js" # @4.20.0
pin "@tensorflow/tfjs-backend-webgl", to: "@tensorflow--tfjs-backend-webgl.js" # @4.20.0
pin "@tensorflow/tfjs-converter", to: "@tensorflow--tfjs-converter.js" # @4.20.0
pin "@tensorflow/tfjs-core/dist/io/io_utils", to: "@tensorflow--tfjs-core--dist--io--io_utils.js" # @4.20.0
pin "@tensorflow/tfjs-core/dist/ops/ops_for_converter", to: "@tensorflow--tfjs-core--dist--ops--ops_for_converter.js" # @4.20.0
pin "@tensorflow/tfjs-core/dist/public/chained_ops/register_all_chained_ops", to: "@tensorflow--tfjs-core--dist--public--chained_ops--register_all_chained_ops.js" # @4.20.0
pin "@tensorflow/tfjs-core/dist/register_all_gradients", to: "@tensorflow--tfjs-core--dist--register_all_gradients.js" # @4.20.0
pin "@tensorflow/tfjs-data", to: "@tensorflow--tfjs-data.js" # @4.20.0
pin "@tensorflow/tfjs-layers", to: "@tensorflow--tfjs-layers.js" # @4.20.0
pin "abbrev" # @1.1.1
pin "ansi-regex" # @5.0.1
pin "aproba" # @2.0.0
pin "are-we-there-yet" # @2.0.0
pin "assert" # @2.0.1
pin "aws-sdk" # @2.756.0
pin "aws-sdk/lib/core.js", to: "aws-sdk--lib--core.js.js" # @2.756.0
pin "aws-sdk/lib/node_loader.js", to: "aws-sdk--lib--node_loader.js.js" # @2.756.0
pin "balanced-match" # @1.0.2
pin "base64-js" # @1.5.1
pin "bluebird" # @3.7.2
pin "brace-expansion" # @1.1.11
pin "child_process" # @2.0.1
pin "color-support" # @1.1.3
pin "concat-map" # @0.0.1
pin "console-control-strings" # @1.1.0
pin "constants" # @2.0.1
pin "debug" # @4.3.5
pin "delegates" # @1.0.0
pin "detect-libc" # @2.0.3
pin "emoji-regex" # @8.0.0
pin "events" # @2.0.1
pin "fs" # @2.0.1
pin "fs-extra" # @7.0.1
pin "fs.realpath" # @1.0.0
pin "gauge" # @3.0.2
pin "glob" # @7.2.3
pin "google-protobuf" # @3.21.2
pin "graceful-fs" # @4.2.11
pin "has-unicode" # @2.0.1
pin "http" # @2.0.1
pin "https" # @2.0.1
pin "ieee754" # @1.2.1
pin "inflight" # @1.0.6
pin "inherits" # @2.0.4
pin "is-fullwidth-code-point" # @3.0.0
pin "isarray" # @1.0.0
pin "jmespath" # @0.15.0
pin "json-stringify-safe" # @5.0.1
pin "jsonfile" # @4.0.0
pin "long" # @4.0.0
pin "minimatch" # @3.1.2
pin "mock-aws-s3" # @4.0.2
pin "ms" # @2.1.2
pin "nock" # @13.5.4
pin "nopt" # @5.0.0
pin "npmlog" # @5.0.1
pin "object-assign" # @4.1.1
pin "once" # @1.4.0
pin "os" # @2.0.1
pin "path" # @2.0.1
pin "path-is-absolute" # @1.0.1
pin "progress" # @2.0.3
pin "propagate" # @2.0.1
pin "punycode" # @1.3.2
pin "querystring" # @0.2.0
pin "readable-stream" # @3.6.2
pin "rimraf" # @3.0.2
pin "semver" # @7.6.2
pin "set-blocking" # @2.0.0
pin "signal-exit" # @3.0.7
pin "stream" # @2.0.1
pin "string-width" # @4.2.3
pin "string_decoder" # @1.3.0
pin "strip-ansi" # @6.0.1
pin "timers" # @2.0.1
pin "underscore" # @1.12.1
pin "universalify" # @0.1.2
pin "url" # @2.0.1
pin "util-deprecate" # @1.0.2
pin "uuid" # @3.3.2
pin "wide-align" # @1.1.5
pin "wrappy" # @1.0.2
pin "zlib" # @2.0.1
pin "@fortawesome/fontawesome-free", to: "@fortawesome--fontawesome-free.js" # @6.5.2
pin "moment" # @2.30.1
pin "serialize-javascript" # @6.0.2
pin "buffer" # @2.0.1
pin "process" # @2.0.1
pin "randombytes" # @2.1.0
pin "safe-buffer" # @5.2.1
pin "sortablejs" # @1.15.2
pin "@tarekraafat/autocomplete.js", to: "@tarekraafat--autocomplete.js.js" # @10.2.7
pin_all_from "app/javascript/i18n-js", under: "i18n-js"
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.4
pin "i18n-js" # @4.4.3
pin "lodash", to: "https://cdn.jsdelivr.net/npm/lodash/lodash.min.js"
pin "make-plural" # @7.4.0
pin "bignumber.js" # @9.1.2
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.2
pin "decimal.js" # @10.4.3
pin "base64-js" # @1.5.1
pin "ieee754" # @1.2.1
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.4
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @7.1.3
pin "chart.js/auto", to: "https://ga.jspm.io/npm:chart.js@4.4.3/auto/auto.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
