sleep 5

am kill logd
killall -9 logd

am kill logd.rc
killall -9 logd.rc

#开机释放缓存（尝试清理）
sleep 10
echo 3 > /proc/sys/vm/drop_caches
echo 1 > /proc/sys/vm/compact_memory

#清理wifi 日志
rm -rf /data/vendor/wlan_logs
touch /data/vendor/wlan_logs
chmod 000 /data/vendor/wlan_logs

# 创建并写入定时任务
echo "0 0 * * * /data/adb/modules/Hyper_Optimize/cron.sh" > /data/adb/modules/Hyper_Optimize

# 创建并写入定时执行脚本
cat <<EOF > /data/cron.sh
#!/bin/bash
fstrim /data /cache /system
sync
echo 3 > /proc/sys/vm/drop_caches
echo 1 > /proc/sys/vm/compact_memory
EOF
chmod 755 /data/

# 安卓tcp优化
while read r; do
    ip route change \$r initcwnd 20;
    ip route change \$r initrwnd 20;
done < <(ip route)

# 预读优化
echo 4096 > /sys/block/vda/queue/read_ahead_kb

# 进程可打开文件数优化
echo 2390251 > /proc/sys/fs/file-max

# io调度优化
echo noop > /sys/block/mmcblk0/queue/scheduler

# 启动crond定时进程
crond -c /data/adb/modules/Hyper_Optimize/cron.d &