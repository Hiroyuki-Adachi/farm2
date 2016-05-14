[gem]: https://rubygems.org/gems/debase
[travis]: https://travis-ci.org/denofevil/debase

# debase
[![Gem Version](https://badge.fury.io/rb/debase.png)][gem]
[![Build Status](https://secure.travis-ci.org/denofevil/debase.png)][travis]

## Overview

debase is a fast implementation of the standard debugger debug.rb for
Ruby 2.0.0. The faster execution speed and 2.0.0 compatibility is achieved
by utilizing a TracePoint mechanism in the Ruby C API.

## Requirements

debase requires Ruby 2.0.0 or higher.

## Install

debase is provided as a RubyGem.  To install:

<tt>gem install debase</tt>

## License

debase contains parts of the code from ruby-debug-base gem.
See MIT_LICENSE and LICENSE for license information.
