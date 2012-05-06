require 'helper'

class TestSysViewer < Test::Unit::TestCase

  test "hostname" do
    assert_equal "Skynet.local", SysViewer.hostname
  end

  test "user" do
    assert_equal "michael", SysViewer.user
  end
end