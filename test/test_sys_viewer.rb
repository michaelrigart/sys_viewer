require 'helper'

class TestSysViewer < Test::Unit::TestCase

  test "OS specific inclusion" do
    case RUBY_PLATFORM
      when /darwin/
        SysViewer.include?(SysViewer::Osx)
    end
  end

  test "hostname" do
    assert_equal "Skynet.local", SysViewer.hostname
  end

  test "user" do
    assert_equal "michael", SysViewer.user
  end
end