a=$(dumpsys window displays | grep mTopFullscreenOpaqueWindowState 2>> /dev/null | awk -F ' ' '{print $NF}')
b=`echo "$a" 2>> /dev/null | awk -F '/' '{print $1}'`

screen=`dumpsys window policy | grep "mInputRestricted"|cut -d= -f2`

c=com.tencent.mm
if [ $b != $c -a $screen = false ]; then
mm=`pgrep mm:toolsmp`
kill -9 $mm
mm1=`pgrep mm:appbrand1`
kill -9 $mm1
mm2=`pgrep mm:support`
kill -9 $mm2
mm3=`pgrep mm:tools`
kill -9 $mm3
mm4=`pgrep mm:appbrand2`
kill -9 $mm4
mm5=`pgrep mm:appbrand0`
kill -9 $mm5
mm6=`pgrep mm:jectl`
kill -9 $mm6
mm7=`pgrep mm:hotpot`
kill -9 $mm7
mm8=`pgrep mm:xweb`
kill -9 $mm8
fi

d=com.tencent.mobileqq
if [ $b != $d -a $screen = false ]; then
qq=`pgrep mobileqq:mini3`
kill -9 $qq
qq1=`pgrep mobileqq:mini`
kill -9 $qq1
qq2=`pgrep mobileqq:qzone`
kill -9 $qq2
qq3=`pgrep mobileqq:tool`
kill -9 $qq3
fi

e=com.xunmeng.pinduoduo
if [ $b != $e -a $screen = false ]; then
pdd=`pgrep pinduoduo`
kill -9 $pdd
fi

f=com.moji.mjweather.light
if [ $b != $f -a $screen = false ]; then
mj=`pgrep mjweather`
kill -9 $mj
fi
