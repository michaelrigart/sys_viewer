require 'socket'
require 'sys_viewer/version'
require 'sys_viewer/osx'

module SysViewer
  class << self

    case RUBY_PLATFORM
      when /darwin/
        include SysViewer::Osx
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