# Changelog
* 1.1.0 Fixed issue with options initialization, options now used only with initialization by specific input id
* 1.0.9 Fixed a problem in the change function. It was trying to parse as JSON a undefined value
* 1.0.8 Options can be passed to jQuery autocomplete initializer
* 1.0.7
  * mongoid: escape regular expression in search
  * When possible, use jQuery .on() rather than .live()
* 1.0.6 Postgres or non-postgres queries are now determined at model level
* 1.0.3 Fixed Formtastic 2.0 + Ruby 1.8.7 compat issue
* 1.0.2 Fixed issue #93, #94
* 1.0.1 Formtastic 2.0 compatibility fix
* 1.0.0 Rails 3.1 asset pipeline support
* 0.9.1 Fixes issues #96 and #32
* 0.9.0 Massive rewrite
* 0.8.0 Compressed JS file
* 0.7.5 Pull request #46
* 0.7.4 Allows Rails 3.1
* 0.7.3 MongoMapper
* 0.7.2 Steak helper
* 0.7.1 Fixed joined scopes (Issue #43)
* 0.7.0 Scopes
* 0.6.6 ILIKE for postgres
* 0.6.5 JS select event
* 0.6.4 Use YAJL instead of JSON
* 0.6.3 SimpleForm plugin
* 0.6.2 Fix Issue #8
* 0.6.1 Allow specifying fully qualified class name for model object as an option to autocomplete
* 0.6.0 JS Code cleanup
* 0.5.1 Add STI support
* 0.5.0 Formtastic support
* 0.4.0 MongoID support
* 0.3.6 Using .live() to put autocomplete on dynamic fields

