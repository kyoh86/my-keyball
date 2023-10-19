#!env zsh

clean() {
  rm -rf ./qmk_firmware/
  rm -rf ./keyball/
  rm -rf ./qmk_cli/
}

install-cli() {
  python3 -m venv qmk_cli
  source ./qmk_cli/bin/activate
  python3 -m pip install qmk
}

clone-firmware() {
  git clone --recursive -j 10 https://github.com/qmk/qmk_firmware &
  git clone https://github.com/Yowkees/keyball &
  wait
}

patch-firmware() {
  cp -r ./keyball/qmk_firmware/keyboards/keyball ./qmk_firmware/keyboards/keyball
  cp -r ./qmk_firmware/keyboards/keyball/keyball61/keymaps/{via,kyoh86}
  patch ./qmk_firmware/keyboards/keyball/keyball61/keymaps/kyoh86 < kyoh86.patch
}

build-firmware() {
  make -C qmk_firmware keyball/keyball61:via
  make -C qmk_firmware keyball/keyball61:kyoh86
  cp ./qmk_firmware/keyball_keyball61_kyoh86.hex keyball61_kyoh86.hex
}

clean

install-cli &
clone-firmware &
wait

patch-firmware
build-firmware
