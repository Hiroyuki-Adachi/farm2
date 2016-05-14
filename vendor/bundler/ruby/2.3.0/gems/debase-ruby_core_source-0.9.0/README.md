## Description
Fork of [debugger-ruby\_core\_source](https://github.com/cldwalker/debugger-ruby_core_source)
that uses included Ruby headers (\*.h and \*.inc) instead of downloading
them. Used by [debase](http://github.com/denofevil/debase).
Only ruby >= 2.0.0 is supported (debase doesn't work for older rubies)

##Usage

Example use in extconf.rb:

```ruby
require 'debase/ruby_core_source'
hdrs = proc { have_header("vm_core.h") and have_header("iseq.h") }
dir_config("ruby") # allow user to pass in non-standard core include directory
if !Debase::RubyCoreSource::create_makefile_with_core(hdrs, "foo")
  # error
  exit(1)
end
```

To add another ruby version's source to this gem's directory:

    $ rake add_source VERSION=2.1.3 PATCHLEVEL=242

(for pre-releases PATCHLEVEL should not be provided)
add_source can use pre-downloaded .tgz (use TGZ_FILE_NAME to pass it)
also it can extract patch level from version.h of downloaded sources, so
PATCHLEVEL variable is optional.

##Credits

* @dirknilius for 2.2.3 headers
* @andremedeiros for 2.1.1 headers
* @formigarafa for fixing 2.1.0 headers

## LICENSE
Ruby library code is MIT license, see LICENSE.txt.  Included ruby headers,
lib/debase/ruby\_core\_source/, are mostly Ruby license, see RUBY\_LICENSE. Some headers have
their own licenses, see LEGAL.
