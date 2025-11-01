# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@fortawesome/fontawesome-free", to: "@fortawesome--fontawesome-free.js" # @6.5.2
pin "moment" # @2.30.1
pin "serialize-javascript" # @6.0.2
pin "buffer" # @2.0.1
pin "process" # @2.0.1
pin "randombytes" # @2.1.0
pin "safe-buffer" # @5.2.1
pin "sortablejs" # @1.15.2
pin "@tarekraafat/autocomplete.js", to: "@tarekraafat--autocomplete.js.js", preload: false # @10.2.7
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
pin "chart.js/auto", to: "https://ga.jspm.io/npm:chart.js@4.5.1/auto/auto.js"
pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.2.102
pin "bootstrap", to: "bootstrap.bundle.min.js" # @5.3.8
pin "qr-scanner", to: "/javascripts/qr-scanner/qr-scanner.min.js"
pin "marked" # @12.0.2
pin "dompurify" # @3.2.6
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers", preload: false
pin_all_from "app/javascript/pages", under: "pages", preload: false
pin "controllers/application", to: "controllers/application.js"
pin "terra-draw", preload: false # @1.18.1
pin "terra-draw-google-maps-adapter", preload: false # @1.1.0
