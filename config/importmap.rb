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
