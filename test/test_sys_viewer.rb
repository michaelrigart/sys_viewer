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

  test "memory_info" do
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
end