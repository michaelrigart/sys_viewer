module SysViewer
  module Osx

    def memory_info
      memory = { memtotal: 0, memused: 0, memfree: 0, swaptotal: 0, swapused: 0, swapfree: 0 }

      stdin, stdout, stderr = Open3.popen3('sysctl', '-n', 'hw.memsize')
      memory[:memtotal] = stdout.gets.to_f / 1048576

      stdin, stdout, stderr = Open3.popen3('vm_stat')
      vm_lines = stdout.readlines
      vm_lines.pop # remove footer
      vm_lines.shift # remove header

      vm_stats = {}
      vm_lines.each do |line|
        element = line.split(/:[\s]+/)
        vm_stats[element[0]] = element[1].gsub!(/.[\n]+/, '').to_f * 4096
      end
      memory[:memfree] = vm_stats['Pages free'] / 1048576 + vm_stats['Pages speculative'] / 1048576
      memory[:memused] = memory[:memtotal] - memory[:memfree]

      stdin, stdout, stderr = Open3.popen3('sysctl', '-n', 'vm.swapusage')
      swap_info = stdout.gets.split(/[\s]+/)

      memory[:swaptotal] = swap_info[2].gsub('M', '').to_f
      memory[:swapused] = swap_info[5].gsub('M', '').to_f
      memory[:swapfree] = swap_info[8].gsub('M', '').to_f

      memory
    end

    def disk_usage
      stdin, stdout, stderr = Open3.popen3('df', '-h')
      volumes = stdout.readlines
      volumes.shift # remove header

      data = {}

      volumes.each do |volume|
        columns = { total: '', used: '', free: '', percent: '', path: '' }
        line = volume.split(/[ ]{2,}/, 6)

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
      stdin, stdout, stderr = Open3.popen3('sysctl', 'kern.boottime')

      uptime = stdout.gets.scan(/sec = \d+/)[0].split('=')[1].strip.to_f
      uptime = Time.now.to_i - uptime

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
      stdin, stdout, stderr = Open3.popen3('sysctl', 'vm.loadavg')

      loadavg = { minute: 0, five_minutes: 0, fifteen_minutes: 0, cores: 0 }
      loadavg[:minute], loadavg[:five_minutes], loadavg[:fifteen_minutes] = stdout.gets.scan(/\d+.\d+/).map { |value| value.to_f }

      stdin, stdout, stderr = Open3.popen3('sysctl', '-n', 'hw.logicalcpu')

      loadavg[:cores] = stdout.gets.to_i
      loadavg
    end

    def cpu_utilization
      stdin, stdout, stderr = Open3.popen3('iostat')

      lines = stdout.readlines
      values = lines[2].split

      { user: values[3].to_i, system: values[4].to_i, idle: values[5].to_i }
    end

    def network_traffic
      stdin, stdout, stderr = Open3.popen3('sar', '-n', 'DEV', '1', '1')

      data = stdout.readlines
      4.times { data.shift } # remove first 4 lines

      network_data = {}
      data.each do |line|
        if line.start_with?("Average")
          values = line.split
          # Ipkts/s   - Packets received per second
          # Ibytes/s  - Bytes received per second
          # Opkts/s   - Packets transmitted per second
          # Obytes/s  - Bytes tranmitted per second
          network_data[values[1]] = { received: values[3].to_i, transmitted: values[5].to_i}
        end
      end

      network_data
    end

  end
end