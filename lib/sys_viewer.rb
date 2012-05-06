require 'socket'
require 'open3'
require 'sys_viewer/version'
require 'sys_viewer/osx'
require 'sys_viewer/linux'

module SysViewer
  class << self

    case RUBY_PLATFORM
      when /darwin/
        include SysViewer::Osx
      when /linux/
        include SysViewer::Linux
      else raise "Platform not yet supported"
    end

    def hostname
      Socket.gethostname
    end

    def user
      ENV['USER']
    end
  end
end
