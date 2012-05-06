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
