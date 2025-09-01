#!/usr/bin/env bash

# These are some Ubuntu code names. The ones that I found on archive.ubuntu.com
# Oldest one is xenial (16.04)
for DIST in bionic focal jammy noble oracular plucky questing trusty xenial; do
  echo ./set_up_apt_mirror.sh "/mnt/hgfs/VM_share/mirrors/debmirror/$DIST/" "$DIST"
  # ./set_up_apt_mirror.sh "/mnt/hgfs/VM_share/mirrors/debmirror/$DIST/" "$DIST"
done

# Here's a mapping of all Ubuntu versions. 6.06, 8.04, 10.04, ... (all .04) are LTS.
# 4.10 	Warty Warthog
# 5.04 	Hoary Hedgehog
# 5.10 	Breezy Badger
# 6.06 LTS 	Dapper Drake
# 6.10 	Edgy Eft
# 7.04 	Feisty Fawn
# 7.10 	Gutsy Gibbon
# 8.04 LTS 	Hardy Heron
# 8.10 	Intrepid Ibex
# 9.04 	Jaunty Jackalope
# 9.10 	Karmic Koala
# 10.04 LTS 	Lucid Lynx
# 10.10 	Maverick Meerkat
# 11.04 	Natty Narwhal
# 11.10 	Oneiric Ocelot
# 12.04 LTS 	Precise Pangolin
# 12.10 	Quantal Quetzal
# 13.04 	Raring Ringtail
# 13.10 	Saucy Salamander
# 14.04 LTS 	Trusty Tahr
# 14.10 	Utopic Unicorn
# 15.04 	Vivid Vervet
# 15.10 	Wily Werewolf
# 16.04 LTS 	Xenial Xerus
# 16.10 	Yakkety Yak
# 17.04 	Zesty Zapus
# 17.10 	Artful Aardvark
# 18.04 LTS 	Bionic Beaver
# 18.10 	Cosmic Cuttlefish
# 19.04 	Disco Dingo
# 19.10 	Eoan Ermine
# 20.04 LTS 	Focal Fossa
# 20.10 	Groovy Gorilla
# 21.04 	Hirsute Hippo
# 21.10 	Impish Indri
# 22.04 LTS 	Jammy Jellyfish
# 22.10 	Kinetic Kudu
# 23.04 	Lunar Lobster
# 23.10 	Mantic Minotaur
# 24.04 LTS 	Noble Numbat
# 24.10 	Oracular Oriole
# 25.04 	Plucky Puffin
# 25.10 	Questing Quokka
