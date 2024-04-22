LATESTARTSERVICE=false
POSTFSDATA=false
PROPFILE=false
SKIPMOUNT=false
SKIPUNZIP=0

# 定义打印模块信息的函数
print_modname() {
  ui_print "*******************************"
  ui_print "模块版本号：1.2.2"
  ui_print "*******************************"
  ui_print "优化开机速度，QQ微信内存压制😋"
  ui_print "优化内存管理，凌晨自动优化🥳"
  ui_print "补全高级材质，高级材质2.0👀"
  ui_print "开启桌面多线程渲染🔥"
  ui_print "开启游戏进入三倍速特性👻"
  ui_print "优化QQ异常卡顿🤣"
  ui_print "补全哈曼卡顿，优化音质👉👈"
  ui_print "禁用logd，凌晨自动优化🥰"
  ui_print "*******************************"
}

key_check() {
  ui_print "你是否要安装本模块🤔"
  ui_print "向↑音量键确定安装🥰"
  ui_print "向↓音量键取消安装💣"
  while true; do
    key_check=$(/system/bin/getevent -qlc 1)
    key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_VOLUME')
    key_status=$(echo "$key_check" | awk '{ print $4 }')
    if [[ "$key_event" == *"KEY_VOLUMEUP"* && "$key_status" == "DOWN" ]]; then
      ui_print "确定安装本模块😆"
      break
    elif [[ "$key_event" == *"KEY_VOLUMEDOWN"* && "$key_status" == "DOWN" ]]; then
      ui_print "我得好好思考🤔"
      exit 0
      break
    fi
  done
}

# 定义释放文件并设置权限的函数
extract_and_set_permissions() {
  unzip -o "$ZIPFILE" "$1" -d /data/adb/modules/Hyper_Optimize >&2
  chmod 777 "/data/adb/modules/Hyper_Optimize/$1"
}

# 定义创建文件夹函数
create_folder() {
  mknod "/data/adb/modules/Hyper_Optimize/$1" c 0 0
}

# 定义释放文件的函数
optimization() {
  ui_print "- 正在释放文件💫"
  ui_print "感谢使用本模块🥰🥰🥰"
  
  # 解压文件
  unzip -o "$ZIPFILE" 'root' -d /data/adb/modules/Hyper_Optimize >&2
  unzip -o "$ZIPFILE" 'Timed_execution.sh' -d /data/adb/modules/Hyper_Optimize >&2
  unzip -o "$ZIPFILE" 'system.prop' -d /data/adb/modules/Hyper_Optimize >&2
  unzip -o "$ZIPFILE" 'service.sh' -d /data/adb/modules/Hyper_Optimize >&2
  
  # 创建空文件夹以删除文件
  create_folder 'file_to_delete'
}

# 定义内存优化函数
Writeback(){
  loop=$(cat /sys/block/zram0/backing_dev | grep -o "loop[0-50]*")
  echo none > /sys/block/$loop/queue/scheduler
  echo 1024 /sys/block/$loop/queue/read_ahead_kb
}
Compress(){
  change_task(){
    local ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
      for temp_tid in $(ls "/proc/$temp_pid/task/"); do
        taskset -p "$2" "$temp_tid"
        renice "$3" -p "$temp_tid"
      done
    done
  }
  change_task "kswapd" "e0" "-2"
  change_task "oom_reaper" "8" "-2"
  echo true > /sys/kernel/mm/swap/vma_ra_enabled
  echo 3 /proc/sys/vm/page-cluster
}

# 定义内存优化安装函数
optimize_install() {
  ui_print "- 安装内存优化中👻"
  Compress
  Writeback
  ui_print "完成🥳"
}

# 定义优化开机速度函数
Optimized_startup() {
  ui_print "- 正在优化开机速度💫"
  ui_print "执行时间较长，不是格机！！！🥰🥰🥰"
  ui_print "- First step🫡 3/1"
  su -mm -c mount -t tmpfs tmpfs /data/adb/modules/
  ui_print "- Second step🫡 2/1"
  su -c /system/bin/restorecon -Rv -F /data
  ui_print "- Third step🫡 1/1"
  su -c umount -l /data/adb/modules/
  ui_print "安装完成，重启生效！🥳"
}

# 根据不同的情况执行相应的操作
if [ "$KSU" == "true" ]; then
  ui_print "- 当前正在使用KernelSU安装"
  ui_print "- KernelSU 用户空间当前的版本号: $KSU_VER_CODE"
  print_modname
  key_check
  optimization
  optimize_install
elif [ "$BOOTMODE" ] && [ "$APATCH" ]; then
  ui_print "- 当前正在使用APatch安装"
  print_modname
  key_check
  optimization
  optimize_install
else
  ui_print "- 当前正在使用Magisk安装"
  ui_print "- Magisk 版本: $MAGISK_VER_CODE"
  print_modname
  key_check
  optimization
  optimize_install
  Optimized_startup
  if [ "$MAGISK_VER_CODE" -lt 26000 ]; then
    ui_print "*********************************************"
    ui_print "! 请安装 Magisk 26.0+"
    abort "*********************************************"
    exit 0
  fi
fi
