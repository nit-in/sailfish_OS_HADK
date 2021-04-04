#!/bin/sh

report_error(){

	error_code=$1;
	error_desc=$2;
	echo "$error_code : $error_desc has occured";
}

init_host(){
	
	echo "Setting up host files";
	read -p "name of the device vendor:	" VENDOR_NAME;
	read -p "codename of the device:	" DEVICE_CODENAME;
	read -p "Sailfish Version:	" RELEASE_VERSION;
	read -p "extra:	" EXTRA_NAME;
	mkdir $HOME/hadk;
	PLATFORM_SDK_ROOT="/srv/mer";
	JOLLA_SDK="Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2";

 }

 init_platform_sdk(){

 	sudo mkdir -p $PLATFORM_SDK_ROOT/sdks/sfossdk ;
 	sudo tar --numeric-owner -p -xjf $JOLLA_SDK -C $PLATFORM_SDK_ROOT/sdks/sfossdk;
 	echo "export PLATFORM_SDK_ROOT=$PLATFORM_SDK_ROOT" >> ~/.bashrc;
	echo 'alias sfossdk=$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot' >> ~/.bashrc ;
 }


init_ubu_chroot(){

	TARBALL=ubuntu-trusty-20180613-android-rootfs.tar.bz2;
	wget -c https://releases.sailfishos.org/ubu/$TARBALL;
	UBUNTU_CHROOT=$PLATFORM_SDK_ROOT/sdks/ubuntu;
	sudo mkdir -p $UBUNTU_CHROOT;
	sudo tar --numeric-owner -xjf $TARBALL -C $UBUNTU_CHROOT;

}

init_hadk_env(){

	echo "copying .hadk.env to $HOME";
	cp .hadk.env $HOME/.hadk.env;
	echo "copying .mersdk.profile to $HOME";
	cp .mersdk.profile $HOME/.mersdk.profile;
	echo "copying .mersdkubu.profile to $HOME";
	cp .mersdkubu.profile $HOME/.mersdkubu.profile;
	echo "$VENDOR_NAME";
	echo "$JOLLA_SDK";
	echo "Updating env and profiles";
	sed -i "s/%VENDOR_NAME%/$VENDOR_NAME/g" $HOME/.hadk.env;
	sed -i "s/%DEVICE_CODENAME%/$DEVICE_CODENAME/g" $HOME/.hadk.env;
	sed -i "s/%RELEASE_VERSION%/$RELEASE_VERSION/g" $HOME/.hadk.env;
	sed -i "s/%EXTRA_NAME%/-$EXTRA_NAME/g" $HOME/.hadk.env;
	if [ -e $JOLLA_SDK ]
		then
		   echo "$JOLLA_SDK exists";
		   init_platform_sdk || report_error "2" "Failed to extract SFOS Platform SDK";
		else
		   echo "$JOLLA_SDK does not exist";
		   wget -c http://releases.sailfishos.org/sdk/installers/latest/$JOLLA_SDK ;
		   init_platform_sdk || report_error "2" "Failed to extract SFOS Platform SDK";
	fi


}


init_host
init_hadk_env
init_ubu_chroot || report_error "3" "Failed to extract ubuntu chroot"
