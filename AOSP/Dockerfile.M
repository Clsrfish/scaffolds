FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip python openjdk-7-jdk && \
    apt-get autoremove

VOLUME ["/aosp"] 
WORKDIR /asop

CMD ["/bin/sh" "-c" "make idegen && development/tools/idegen/idegen.sh"]



