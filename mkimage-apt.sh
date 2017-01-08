#!/usr/bin/env bash
#
# Script to create Alt Linux base images for integration with VM containers (docker, lxc , etc.).
# 
# Based on mkimage-urpmi.sh (https://github.com/juanluisbaptiste/docker-brew-mageia)
#

rootfsDir="$(realpath .)/rootfsDir" 
basePackages="basesystem etcnet apt apt-repo mc eepm"
tarFile="$(realpath .)/rootfs.tar.xz"

mkdir -p $rootfsDir/var/lib/rpm
echo $rootfsDir

(
        rpm --initdb --root=$rootfsDir
        #apt-get -o "RPM::RootDir=$rootfsDir" update
        apt-get -o "RPM::RootDir=$rootfsDir" install -y $basePackages 
)

  cd "$rootfsDir"
  
  # Clean 
	#  locales
	#rm -rf usr/{{lib,share}/locale,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}
	#  docs
	rm -rf usr/share/{man,doc,info,gnome/help}
	#  cracklib
	rm -rf usr/share/cracklib
	#  i18n
	rm -rf usr/share/i18n
	#  urpmi cache
	rm -rf var/cache/apt
	mkdir -p --mode=0755 var/cache/apt
	#  sln
	rm -rf sbin/sln
	#  ldconfig
	#rm -rf sbin/ldconfig
	rm -rf etc/ld.so.cache var/cache/ldconfig
	mkdir -p --mode=0755 var/cache/ldconfig
 cd ..
# Docker mounts tmpfs at /dev and procfs at /proc so we can remove them
rm -rf "$rootfsDir/dev" "$rootfsDir/proc"
mkdir -p "$rootfsDir/dev" "$rootfsDir/proc"

# make sure /etc/resolv.conf has something useful in it
mkdir -p "$rootfsDir/etc"
cat > "$rootfsDir/etc/resolv.conf" <<'EOF'
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
    
touch "$tarFile"

(
        set -x
        tar --numeric-owner -caf "$tarFile" -C "$rootfsDir" --transform='s,^./,,' .
)

( set -x; rm -rf "$rootfsDir" )
