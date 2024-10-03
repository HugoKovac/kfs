FROM debian:bullseye

RUN apt-get update && apt-get install -y nasm genisoimage build-essential qemu-system binutils grub2-common

ADD ./src /root/src
ADD ./iso /root/iso
ADD ./obj /root/obj
ADD ./Makefile /root/Makefile

WORKDIR /root
