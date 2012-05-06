require 'helper'

class TestSysViewer < Test::Unit::TestCase

  test "OS specific inclusion" do
    case RUBY_PLATFORM
      when /darwin/
        SysViewer.include?(SysViewer::Osx)
      when /linux/
        SysViewer.include?(SysViewer::Linux)
    end
  end

  test "hostname" do
    assert SysViewer.hostname.kind_of?(String)
  end

  test "user" do
    assert SysViewer.user.kind_of?(String)
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
      assert key.kind_of?(String)
      assert value.has_key?(:total)
      assert value[:total].kind_of?(String)
      assert value.has_key?(:used)
      assert value[:used].kind_of?(String)
      assert value.has_key?(:free)
      assert value[:free].kind_of?(String)
      assert value.has_key?(:percent)
      assert value[:percent].kind_of?(String)
      assert value.has_key?(:path)
      assert value[:path].kind_of?(String)
    end
  end

  test "uptime exists" do
    assert_respond_to SysViewer, :uptime
  end

  test "uptime" do
    response = SysViewer.uptime

    assert response.kind_of?(Hash)

    assert response.has_key?(:days)
    assert response[:days].kind_of?(Integer)
    assert response.has_key?(:hours)
    assert response[:hours].kind_of?(Integer)
    assert response.has_key?(:minutes)
    assert response[:minutes].kind_of?(Integer)
    assert response.has_key?(:seconds)
    assert response[:seconds].kind_of?(Integer)
  end

  test "load_average exists" do
    assert_respond_to SysViewer, :load_average
  end

  test "load_average" do
    response = SysViewer.load_average

    assert response.kind_of?(Hash)

    assert response.has_key?(:minute)
    assert response[:minute].kind_of?(Float)
    assert response.has_key?(:five_minutes)
    assert response[:five_minutes].kind_of?(Float)
    assert response.has_key?(:fifteen_minutes)
    assert response[:fifteen_minutes].kind_of?(Float)
    assert response.has_key?(:cores)
    assert response[:cores].kind_of?(Integer)
  end

  test "cpu_utilization exists" do
    assert_respond_to SysViewer, :cpu_utilization
  end

  test "cpu_utilization" do
    response = SysViewer.cpu_utilization

    assert response.kind_of?(Hash)

    assert response.has_key?(:user)
    assert response[:user].kind_of?(Float)
    assert response.has_key?(:system)
    assert response[:system].kind_of?(Float)
    assert response.has_key?(:idle)
    assert response[:idle].kind_of?(Float)
  end

  test "network_traffic exists" do
    assert_respond_to SysViewer, :network_traffic
  end

  test "network_traffic" do
    response = SysViewer.network_traffic

    assert response.kind_of?(Hash)

    response.each do | key, value |
      assert key.kind_of?(String)
      assert value.has_key?(:received)
      assert value[:received].kind_of?(Integer)
      assert value.has_key?(:transmitted)
      assert value[:transmitted].kind_of?(Integer)
    end
  end

end
