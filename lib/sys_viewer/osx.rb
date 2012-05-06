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
  end
end