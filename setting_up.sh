#!/bin/sh

welcome(){

	echo -e "\n\tWelcome!";
}

setup_variables(){

	PLATFORM_SDK_ROOT="/srv/mer";
	HADK_DIR="$HOME/hadk";
	SFOSSDK="$PLATFORM_SDK_ROOT/sdks/sfossdk";
	JOLLA_SDK="Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2";
	UBUNTU_CHROOT=$PLATFORM_SDK_ROOT/sdks/ubuntu;
	UBU_TARBALL=ubuntu-trusty-20180613-android-rootfs.tar.bz2;
	HADK_ENV=".hadk.env";
	MERSDK_PROFILE=".mersdk.profile";
	MERSDKUBU_PROFILE=".mersdkubu.profile";
}

filler(){

	echo -e "\n";
	echo -e "----------------";
	echo -e "\n";

}

report_error(){

	error_code=$1;
	error_desc=$2;
	echo "$error_code : $error_desc has occured";

}

extract_tar(){

	TARBALL=$1
	EXTRACT_DIR=$2
	sudo tar --checkpoint=20408 --checkpoint-action=echo="%{}T" --numeric-owner -xjf $TARBALL -C $EXTRACT_DIR;

}


setup_dirs(){

	echo "Setting up directories ...";

	for DIR in $SFOSSDK $HADK_DIR $UBUNTU_CHROOT
		do
			if [ -d $DIR ]
				then
					echo "$DIR already exists";
				else
					echo "$DIR doesn't exists";
					echo "Making $DIR ...";
					sudo mkdir -p $DIR;
			fi
		done
}

init_host(){
	
	echo "Setting up host files";
	read -p "name of the device vendor:	" VENDOR_NAME;
	read -p "codename of the device:	" DEVICE_CODENAME;
	read -p "Sailfish Version:	" RELEASE_VERSION;
	read -p "extra:	" EXTRA_NAME;
	

 }

 init_platform_sdk(){
 	
 	echo "export PLATFORM_SDK_ROOT=$PLATFORM_SDK_ROOT" >> ~/.bashrc;
	echo 'alias sfossdk=$SFOSSDK/mer-sdk-chroot' >> ~/.bashrc ;
 }


init_chroot(){


	if [ -e $JOLLA_SDK ]
		then
		   echo "$JOLLA_SDK already exists";
		   extract_tar $JOLLA_SDK $SFOSSDK && echo "$JOLLA_SDK extracted" || report_error "2" "Failed to extract SFOS Platform SDK";
		else
		   echo "$JOLLA_SDK does not exist";
		   wget -c http://releases.sailfishos.org/sdk/installers/latest/$JOLLA_SDK ;
		   extract_tar $JOLLA_SDK $SFOSSDK && echo "$JOLLA_SDK extracted" || report_error "2" "Failed to extract SFOS Platform SDK";
	fi

	filler

	if [ -e $UBU_TARBALL ]
		then
			echo "$UBU_TARBALL already exists";
			extract_tar $UBU_TARBALL $UBUNTU_CHROOT && echo "$UBUNTU_CHROOT extracted" || report_error "3" "Failed to extract $UBUNTU_CHROOT";
		else
			wget -c https://releases.sailfishos.org/ubu/$TARBALL;
			extract_tar $UBU_TARBALL $UBUNTU_CHROOT && echo "$UBUNTU_CHROOT extracted" || report_error "3" "Failed to extract $UBUNTU_CHROOT";
	fi

}

init_hadk_env(){

	for ENV_FILE in $HADK_ENV $MERSDK_PROFILE $MERSDKUBU_PROFILE
		do
			echo "copying $ENV_FILE to $HOME";
			cp $ENV_FILE $HOME/$ENV_FILE;
		done

	echo "Updating env and profiles";
	sed -i "s/%VENDOR_NAME%/$VENDOR_NAME/g" $HOME/.hadk.env;
	sed -i "s/%DEVICE_CODENAME%/$DEVICE_CODENAME/g" $HOME/.hadk.env;
	sed -i "s/%RELEASE_VERSION%/$RELEASE_VERSION/g" $HOME/.hadk.env;
	sed -i "s/%EXTRA_NAME%/-$EXTRA_NAME/g" $HOME/.hadk.env;

}

welcome
filler
setup_variables
setup_dirs
filler
init_host
filler
init_hadk_env
init_platform_sdk
filler
init_chroot
filler
