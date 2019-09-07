#!/usr/bin/bash
./configure --target-list=x86_64-softmmu \
--enable-kvm \
--enable-linux-aio \
--enable-virtfs \
--disable-xen \
--enable-tcg \
--enable-spice \
--enable-trace-backends=simple \
--prefix=$HOME/qemu-nvme \
--enable-debug \
--enable-debug-tcg \
--enable-gtk \
--enable-sdl \
--enable-vnc \
--enable-tcg-interpreter \
--enable-debug-stack-usage \
