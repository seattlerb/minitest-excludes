require 'test/metametameta'
require 'minitest/excludes'

class TestMinitestExcludes < MetaMetaMetaTestCase
  def test_cls_excludes
    Minitest.seed = 42 if Minitest.respond_to?(:seed=)
    srand 42
    old_exclude_base = Minitest::Test::EXCLUDE_DIR

    @assertion_count = 0

    Dir.mktmpdir do |path|
      Minitest::Test::EXCLUDE_DIR.replace(path)
      Dir.mkdir File.join path, "ATestCase"

      s = 'exclude :test_test2, "because it is borked"'

      File.write File.join(path, "ATestCase.rb"), s
      File.write File.join(path, "ATestCase/Nested.rb"), s

      tc1 = tc2 = nil

      tc1 = Class.new(Minitest::Test) do
        def test_test1; assert true  end
        def test_test2; assert false end # oh noes!
        def test_test3; assert true  end

        tc2 = Class.new(Minitest::Test) do
          def test_test1; assert true  end
          def test_test2; assert false end # oh noes!
          def test_test3; assert true  end
        end
      end

      Object.const_set(:ATestCase, tc1)
      ATestCase.const_set(:Nested, tc2)

      @tus = [tc1, tc2]

      assert_equal %w(test_test1 test_test3), ATestCase.runnable_methods.sort
      assert_equal %w(test_test1 test_test3), ATestCase::Nested.runnable_methods.sort

      expected = <<-EOM.gsub(/^ {8}/, '')
        ATestCase#test_test3 = 0.00 s = .
        ATestCase#test_test1 = 0.00 s = .
        ATestCase::Nested#test_test3 = 0.00 s = .
        ATestCase::Nested#test_test1 = 0.00 s = .

        Finished in 0.00

        4 runs, 4 assertions, 0 failures, 0 errors, 0 skips
      EOM
      assert_report expected, %w[--seed 42 --verbose]
    end
  ensure
    Minitest::Test::EXCLUDE_DIR.replace(old_exclude_base)
  end
end
