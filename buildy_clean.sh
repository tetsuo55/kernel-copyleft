export ARCH=arm
export PATH=../arm-eabi-4.9/bin/:$PATH
export CROSS_COMPILE=arm-eabi-


# make clean
rm -rf ../../zombie/build_yuga/zImage
rm -rf ../../zombie/build_yuga/boot.img
rm -rf ../../zombie/zip_yuga/boot.img
rm -rf ../../zombie/zip_yuga/Zombie.zip

make distclean

# build kernel
make lp_yuga_defconfig
make -j5

cp arch/arm/boot/zImage ../../zombie/build_yuga
cp arch/arm/mach-msm/msm-buspm-dev.ko ../../zombie/zip_yuga/system/lib/modules
cp crypto/ansi_cprng.ko ../../zombie/zip_yuga/system/lib/modules
cp arch/arm/mach-msm/reset_modem.ko ../../zombie/zip_yuga/system/lib/modules
cp drivers/char/adsprpc.ko ../../zombie/zip_yuga/system/lib/modules
cp drivers/media/radio/radio-iris-transport.ko ../../zombie/zip_yuga/system/lib/modules
cp drivers/media/video/gspca/gspca_main.ko ../../zombie/zip_yuga/system/lib/modules
cp drivers/staging/prima/wlan.ko ../../zombie/zip_yuga/system/lib/modules/prima
cp drivers/video/backlight/lcd.ko ../../zombie/zip_yuga/system/lib/modules

# build image
cd ../../zombie/build_yuga

./mkbootimg --base 0x80200000 --kernel zImage --ramdisk_offset 0x02000000 --pagesize 2048 --cmdline "androidboot.hardware=qcom user_debug=23 msm_rtb.filter=0x3F ehci-hcd.park=3 vmalloc=400M androidboot.bootdevice=msm_sdcc.1" --ramdisk ramdisk.cpio.gz -o boot.img

cp boot.img ../../zombie/zip_yuga

cd ../../zombie/zip_yuga

mv system/lib/modules/prima/wlan.ko system/lib/modules/prima/prima_wlan.ko 
zip -r Zombie.zip META-INF system scripts boot.img

cd ../../zombie/kernel_yuga
