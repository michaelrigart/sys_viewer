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
      uptime = File.open('/proc/uptime', &:readline).split[0].to_f

      minute = 60
      hour = minute * 60
      day = hour * 24

      days = (uptime / day).to_i
      hours = ((uptime % day) / hour).to_i
      minutes = ((uptime % hour) / minute).to_i
      seconds = (uptime % minute).to_i

      { days: days, hours: hours, minutes: minutes, seconds: seconds }
    end

    def load_average
      loadavg = { minute: 0, five_minutes: 0, fifteen_minutes: 0, cores: 0 }
      loadavg[:minute], loadavg[:five_minutes], loadavg[:fifteen_minutes] = File.open('/proc/loadavg', &:readline).scan(/\d+.\d+/).map { |value| value.to_f } 
    
      loadavg
    end


    def cpu_utilization
      stdin, stdout, stderr = Open3.popen3('sar', '1', '1')
      average_stats = stdout.readlines.last
      values = average_stats.scan(/\d+[\.,]\d+/)
 
      { user: values[0].to_f , system: values[2].to_f , idle: values[5].to_f }
    end

    def network_traffic
      stdin, stdout, stderr = Open3.popen3('sar', '-n', 'DEV', '1', '1')

      data = stdout.readlines
      7.times { data.shift } # remove first 7 lines

      network_data = {}
      data.each do |line|
        values = line.split
        # rxkB/s - Total number of kilobytes received per second  
        # txkB/s - Total number of kilobytes transmitted per second
        network_data[values[1]] = { received: values[4].to_f, transmitted: values[5].to_f }
      end

      network_data
    end

  end
end
