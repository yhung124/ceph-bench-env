#!/bin/bash

sysctl_arg="vm.swappiness = 0"

echo "TASK [ Ceph system tuning ] *************"
ansible osds.hdd -m shell -a "echo deadline | sudo tee /sys/block/sdb/queue/scheduler"
ansible osds.hdd -m shell -a "echo deadline | sudo tee /sys/block/sdc/queue/scheduler"
ansible osds.hdd -m shell -a "echo 8192 | sudo tee /sys/block/sda/queue/read_ahead_kb"
ansible osds.hdd -m shell -a "echo 4194303 | sudo tee /proc/sys/kernel/pid_max"
ansible osds.hdd -m shell -a "echo ${sysctl_arg} | sudo tee  /etc/sysctl.conf"
ansible osds.hdd -m shell -a 'for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do [ -f $CPUFREQ ] || continue; echo -n performance | sudo tee $CPUFREQ; done'
ansible osds.hdd -a "sudo sysctl -p"
