# SysViewer

Small library for viewing some system data. Nothing fancy, just created it to play around with some stuff.

# Install

$ gem install sys_viewer

# Usage
$ irb
>> require 'sys_viewer'

&gt;&gt; SysViewer.hostname
=&gt; "Skynet.local"
&gt;&gt; SysViewer.user
=&gt; "michael"
&gt;&gt; SysViewer.memory_info
=&gt; {:memtotal=>8192.0, :memused=>3715.296875, :memfree=>4476.703125, :swaptotal=>64.0, :swapused=>0.0, :swapfree=>64.0}
&gt;&gt; SysViewer.disk_usage
=&gt; {"/dev/disk0s2"=>{:total=>"596Gi", :used=>"149Gi", :free=>"447Gi", :percent=>"26%", :path=>"/"}, "devfs"=>{:total=>"109Ki", :used=>"109Ki", :free=>"0Bi", :percent=>"100%", :path=>"/dev"}, "map -hosts"=>{:total=>"0Bi", :used=>"0Bi", :free=>"0Bi", :percent=>"100%", :path=>"/net"}, "map auto_home"=>{:total=>"0Bi", :used=>"0Bi", :free=>"0Bi", :percent=>"100%", :path=>"/home"}}
&gt;&gt; SysViewer.uptime
=&gt; {:days=>0, :hours=>2, :minutes=>36, :seconds=>11}
&gt;&gt; SysViewer.load_average
=&gt; {:minute=>0.69, :five_minutes=>0.45, :fifteen_minutes=>0.39, :cores=>16}
&gt;&gt; SysViewer.cpu_utilization
=&gt; {:user=>1, :system=>1, :idle=>98}
&gt;&gt; SysViewer.network_traffic
=&gt; {"lo0"=>{:received=>0, :transmitted=>0}, "gif0"=>{:received=>0, :transmitted=>0}, "stf0"=>{:received=>0, :transmitted=>0}, "en0"=>{:received=>183, :transmitted=>233}, "en1"=>{:received=>0, :transmitted=>0}, "en2"=>{:received=>0, :transmitted=>0}, "fw0"=>{:received=>0, :transmitted=>0}, "en4"=>{:received=>0, :transmitted=>0}}

# Todo

- This only works on OS X
- Some exception handling would be nice

# Copyright

See LICENSE for details

