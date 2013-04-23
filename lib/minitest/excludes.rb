require 'minitest/unit'

module MiniTest::Unit::Excludes # :nodoc:
  VERSION = "1.0.2" # :nodoc:
end

##
# minitest/excludes.rb extends MiniTest::Unit::TestCase to provide a
# clean API for excluding certain tests you don't want to run under
# certain conditions.
#
# For example, in test/test_xyz.rb you have:
#
#   class TestXYZ < MiniTest::Unit::TestCase
#     def test_good
#       # test that passes
#     end
#
#     def test_bad
#       # test that fails only on jruby
#     end
#   end
#
# For jruby runs, you can add test/excludes/TestXYZ.rb with:
#
#   exclude :test_bad, "Uses ObjectSpace" if jruby?
#
# The file is instance_eval'd on TestXYZ so you can call the exclude
# class method directly. Since it is ruby you can provide any sort
# of conditions you want to figure out if your tests should be
# excluded.
#
# TestCase.exclude removes test methods entirely so they don't run
# setup/teardown at all.
#
# If you want to change where the exclude files are located, you can
# set the EXCLUDE_DIR environment variable.

class MiniTest::Unit::TestCase
  EXCLUDE_DIR = ENV['EXCLUDE_DIR'] || "test/excludes"

  ##
  # Exclude a test from a testcase. This is intended to be used by
  # exclusion files.

  def self.exclude name, reason
    return warn "Method #{self}##{name} is not defined" unless
      method_defined? name

    undef_method name
  end

  ##
  # Loads the exclusion file for the class, if any.

  def self.load_excludes
    @__load_excludes__ ||=
      begin
        if name and not name.empty? then
          file = File.join EXCLUDE_DIR, "#{name.gsub(/::/, '/')}.rb"
          instance_eval File.read(file), file if File.exist? file
        end
        true
      end
  end

  class << self
    alias :old_test_methods :test_methods # :nodoc:

    def test_methods # :nodoc:
      load_excludes
      old_test_methods
    end
  end
end
