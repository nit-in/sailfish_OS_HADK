install_repo(){

mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo
	
}


checkout_hadk_repos(){


repo init --depth=1 --no-repo-verify -u https://github.com/mer-hybris/android.git -b hybris-16.0 -g default,-device,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8
rm -rf .repo/project-objects

}

install_repo
checkout_hadk_repos
