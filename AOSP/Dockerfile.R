FROM ubuntu:18.04

RUN apt update && \
    apt install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig && \
    apt autoremove

VOLUME ["/aosp"] 
WORKDIR /aosp

CMD ["/bin/sh" "-c" "source build/envsetup.sh && make idegen && development/tools/idegen/idegen.sh"]



