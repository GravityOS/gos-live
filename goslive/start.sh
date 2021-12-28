#!/usr/bin/env bash

# MIT License
# 
# Copyright (c) 2020 Tom Meyers
# Copyright (c) 2021 Ethan Lane <ethan@vylpes.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# This is a simple script to build an iso image. It prepares the build directory and then starts the build
./version_builder.sh
version=$(cat airootfs/etc/version)
iso_version=$(date +%Y.%m.%d)
iso_normal=$(echo gravityos-"$iso_version"-x86_64 | tr '.' '-')
append=""

function build() {
  # Install needed dependencies
  if [[ "$(which mkarchiso)" != "/usr/bin/mkarchiso" ]]; then
    paru -Syu archiso || exit 1
  fi
  
  if ! paru -Q | grep -q mkinitcpio-archiso; then
    paru -Syu mkinitcpio-archiso || exit 1
  fi

  # do a complete remove of the working directory since we are building multiple different version using it
  rm -rf work || exit 1

  mkarchiso -v . || exit 1

  if [[ ! -d "images/server" ]]; then
    mkdir -p images/server
  fi

  if [[ ! -d "images/desktop" ]]; then
    mkdir -p images/desktop
  fi

  if [[ "$1" == "-d" ]]; then
    cp out/gravityos*.iso images/desktop/"$iso_normal""$append".iso
    mv out/gravityos*.iso out/gravityos-desktop.iso
  fi

  if [[ "$1" == "-s" ]]; then
    cp out/gravityos*.iso images/server/"$iso_normal""$append".iso
    mv out/graviyos*.iso out/gravityos-server.iso
  fi

}

if [[ "$1" == "-h" ]]; then
  echo "-h | help message"
  echo "-s | compile iso in server mode"
  echo "-d | compile iso in desktop mode"
  exit 0
fi

if [[ "$1" == "-d" ]]; then
  cp packages.x86_64_desktop packages.x86_64
  build "$1" "$2"
fi

if [[ "$1" == "-s" ]]; then
  cp packages.x86_64_server packages.x86_64
  build "$1" "$2"
fi