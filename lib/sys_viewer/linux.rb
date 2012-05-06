module SysViewer
  module Linux
  
    def memory_info
      memory = { memtotal: 0, memused: 0, memfree: 0, swaptotal: 0, swapused: 0, swapfree: 0 }

      mem_hash = {}  
      File.open('/proc/meminfo', 'r') do |file|
        file.readlines.each do |line|
          rule = line.split(/:[ ]{2,}/)
          mem_hash[rule[0]] = rule[1].to_f / 1024
        end 
      end

      memory[:memtotal] = mem_hash['MemTotal']
      memory[:memused] = mem_hash['MemTotal'] - mem_hash['MemFree']
      memory[:memfree] = mem_hash['MemFree']
      memory[:swaptotal] = mem_hash['SwapTotal']
      memory[:swapused] = mem_hash['SwapTotal'] - mem_hash['SwapFree']
      memory[:swapfree] = mem_hash['SwapFree']
      
      memory
    end

    def disk_usage
      stdin, stdout, stderr = Open3.popen3('df', '-h')
      volumes = stdout.readlines
      volumes.shift # remove header

      data = {}

      volumes.each do |volume|
        columns = { total: '', used: '', free: '', percent: '', path: '' }
        line = volume.split(/[ ]{1,}/, 6)

        columns[:total] = line[1]
        columns[:used] = line[2]
        columns[:free] = line[3]
        columns[:percent] = line[4]
        columns[:path] = line[5].gsub(/[\n]+/,'')

        data[line[0]] = columns
      end
      
      data
    end

    def uptime

    end

    def load_average

    end


    def cpu_utilization

    end

    def network_traffic

    end

  end
end
