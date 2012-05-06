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
  end
end