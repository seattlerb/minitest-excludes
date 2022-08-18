= minitest-excludes

home :: https://github.com/seattlerb/minitest-excludes
rdoc :: http://docs.seattlerb.org/minitest-excludes

== DESCRIPTION:

minitest/excludes.rb extends Minitest::Test to provide a
clean API for excluding certain tests you don't want to run under
certain conditions.

== FEATURES/PROBLEMS:

* Simple API to conditionally remove tests you don't want to run.
* Uses plain ruby so you can use conditional logic if need be.

== SYNOPSIS:

    class TestXYZ < Minitest::Test
      def test_good
        test that passes
      end

      def test_bad
        test that fails only on jruby
      end
    end

For jruby runs, you can add test/excludes/TestXYZ.rb with:

    exclude :test_bad, "Uses ObjectSpace" if jruby?

== REQUIREMENTS:

* minitest

== INSTALL:

* sudo gem install minitest-excludes

== LICENSE:

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
