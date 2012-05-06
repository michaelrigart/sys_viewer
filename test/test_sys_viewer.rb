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

  test "memory_info exists" do
    assert_respond_to SysViewer, :memory_info
  end

  test "memory info" do
    response = SysViewer.memory_info

    assert response.kind_of?(Hash)

    assert response.has_key?(:memtotal)
    assert response.has_key?(:memused)
    assert response.has_key?(:memfree)
    assert response.has_key?(:swaptotal)
    assert response.has_key?(:swapused)
    assert response.has_key?(:swapfree)

    response.each { |key, value| assert value.kind_of?(Float) }
  end

  test "disk_usage exists" do
    assert_respond_to SysViewer, :disk_usage
  end

  test "disk_usage" do
    response = SysViewer.disk_usage

    assert response.kind_of?(Hash)

    response.each do | key, value |
      assert value.has_key?(:total)
      assert value.has_key?(:used)
      assert value.has_key?(:free)
      assert value.has_key?(:percent)
      assert value.has_key?(:path)
    end
  end
end