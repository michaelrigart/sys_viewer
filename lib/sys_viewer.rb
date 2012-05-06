require 'socket'
require 'sys_viewer/version'

module SysViewer
  class << self

    def hostname
      Socket.gethostname
    end

    def user
      ENV['USER']
    end
  end
end