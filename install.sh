#!/bin/sh

echo Install rpitx - some package need internet connection -

sudo apt-get update
sudo apt-get install -y libsndfile1-dev git
sudo apt-get install -y imagemagick libfftw3-dev libraspberrypi-dev
#For rtl-sdr use
sudo apt-get install -y rtl-sdr buffer
# We use CSDR as a dsp for analogs modes thanks to HA7ILM
git clone git@github.com:radomd92/csdr
cd csdr || exit
make && sudo make install
cd ../ || exit

cd src || exit
git clone git@github.com:radomd92/librpitx
cd librpitx/src || exit
make && sudo make install
cd ../../ || exit

cd pift8
git clone git@github.com:radomd92/ft8_lib
cd ft8_lib
make && sudo make install
cd ../
make
cd ../

make
sudo make install
cd .. || exit

printf "\n\n"
printf "In order to run properly, rpitx need to modify /boot/config.txt. Are you sure (y/n) "
read -r CONT

if [ "$CONT" = "y" ]; then
  echo "Set GPU to 250Mhz in order to be stable"
   LINE='gpu_freq=250'
   if [ ! -f /boot/firmware/config.txt ]; then
   echo "Raspbian 11 or below detected using /boot/config.txt"
   FILE='/boot/config.txt'
   else
   echo "Raspbian 12 detected using /boot/firmware/config.txt"
   FILE='/boot/firmware/config.txt'
   fi
   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
   #PI4
   LINE='force_turbo=1'
   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
   echo "Installation completed !"
else
  echo "Warning : Rpitx should be instable and stop from transmitting !";
fi


