# copy-libs.sh: -*- Shell-script -*-  DESCRIPTIVE TEXT.
# 
#  Copyright (c) 2014 Brian J. Fox
#  Author: Brian J. Fox (bfox@opuslogica.com) Sun Nov 23 11:15:42 2014.
mydir=$(dirname $(dirname $0))
if [[ $CORDOVA_CMDLINE == *android* ]]; then
   echo "Copying Vitamio libraries into the project from the plugin.xml hook."
   cp ${mydir}/Vitamio/Vitamio.jar platforms/android/libs
   cp -r ${mydir}/Vitamio/libs/* platforms/android/libs
   cp -a platforms/android/libs/raw platforms/android/res/
fi
