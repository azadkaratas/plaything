
cp -a ${BR2_EXTERNAL_APPLICATION_PATH}/board/rpi5/overlay/system/* ${TARGET_DIR}/
cp ${BR2_EXTERNAL_APPLICATION_PATH}/package/qt-menu/S99qtmenu ${TARGET_DIR}/etc/init.d/S99qtmenu

cp package/busybox/S10mdev ${TARGET_DIR}/etc/init.d/S10mdev
chmod 755 ${TARGET_DIR}/etc/init.d/S10mdev
cp package/busybox/mdev.conf ${TARGET_DIR}/etc/mdev.conf
