#!/bin/sh
#
# Настройки distmaker
#
export TARGET="/home/chara/distmaker3/_mnt"                            # Директория пути установки	
export RELEASE="stable"                                                # Релиз Debian
export MIRROR="http://ftp.ru.debian.org/debian"                        # Зеркало Debian
export CHROOT="qemu-arm-static -L $TARGET $TARGET/sbin/chroot $TARGET" # Команда chroot'а

# Конец настроек --------
# Проверка на рут привелегии, т.к. для всего всего нам нужны рут права
check_root() {
	if [[ $(whoami) != "root" ]]; then
		echo "distmaker must run as root."
		exit 1
	fi
}

# Монтирование dev, sys, etc...
chroot_mounts() {
	mount -t proc /proc $TARGET/proc
	mount --rbind /sys $TARGET/sys
	mount --make-rslave $TARGET/sys
	mount --rbind /dev $TARGET/dev
	mount --make-rslave $TARGET/dev
	mount -t tmpfs tmpfs $TARGET/tmp
}

# Размонтирование
chroot_umounts() {
	umount -R -l $TARGET/proc
	umount -R -l $TARGET/sys
	umount -R -l $TARGET/dev
	umount -R -l $TARGET/tmp
}

# Переменные к путям папок build и files
export _FILES="$(realpath files)"
export _SCRIPTS="$(realpath scripts)"

# Сборка
check_root
#ask_user_to_continue
echo "BUILD: Making a system... *w*"
for name in $(ls $_SCRIPTS); do
	echo "BUILD: Running $name"
	if [[ $(echo $name | cut -d"." -f2) == chroot ]]; then
		# Если скрипт имеет расширение .chroot, то он будет копироваться на 
		# TARGET и выполнятся от chroot
		chroot_mounts
		cp $_SCRIPTS/$name $TARGET/build
		$CHROOT /build
		rm $TARGET/build
		chroot_umounts
	else
		# Если скрипт не имеет расширение .chroot, то просто по обычному работаем
		$_SCRIPTS/$name
		E=$?
		if [[ $E != "0" ]]; then
			echo "BUILD: Error! $name returned with exit code $E. Aborting..."
			exit 2
		fi
	fi
done
echo "BUILD: Done! -w-"
