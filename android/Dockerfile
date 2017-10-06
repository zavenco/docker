FROM ubuntu:16.04


# Clean and update sources
RUN apt-get clean && apt-get update

# Install openjdk
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-8-jdk
  
# Script from official openjdk image to get cross-architecture-safe JAVA_HOME
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

RUN ln -svT "/usr/lib/jvm/java-7-openjdk-$(dpkg --print-architecture)" /docker-java-home

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes unzip expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Download Android SDK
RUN wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
RUN unzip android-sdk.tgz && mv ./tools /opt/tools

# Export variables
ENV ANDROID_HOME /opt/tools
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools/:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/emulator

# Install and update tools
RUN mkdir /root/.android && echo 'count=0' > /root/.android/repositories.cfg


RUN echo yes | sdkmanager "tools"

RUN echo yes | sdkmanager "platform-tools"

RUN echo yes | sdkmanager "build-tools;26.0.2"
RUN echo yes | sdkmanager "build-tools;26.0.1"
RUN echo yes | sdkmanager "build-tools;26.0.0"
RUN echo yes | sdkmanager "build-tools;25.0.3"
RUN echo yes | sdkmanager "build-tools;25.0.1"
RUN echo yes | sdkmanager "build-tools;25.0.0"
RUN echo yes | sdkmanager "build-tools;24.0.3"
RUN echo yes | sdkmanager "build-tools;23.0.3"
RUN echo yes | sdkmanager "build-tools;22.0.1"

RUN echo yes | sdkmanager "platforms;android-26"
RUN echo yes | sdkmanager "platforms;android-25"
RUN echo yes | sdkmanager "platforms;android-24"
RUN echo yes | sdkmanager "platforms;android-23"
RUN echo yes | sdkmanager "platforms;android-22"
RUN echo yes | sdkmanager "platforms;android-21"

RUN echo yes | sdkmanager "extras;android;m2repository"
RUN echo yes | sdkmanager "extras;google;google_play_services"
RUN echo yes | sdkmanager "extras;google;m2repository"

RUN echo yes | sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"
RUN echo yes | sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"

RUN echo yes | sdkmanager "system-images;android-24;google_apis;x86_64"

# Fix QT by copying libs to local directory
RUN cp -a $ANDROID_HOME/emulator/lib64/qt/lib/. /usr/lib/x86_64-linux-gnu

# Create AVD
RUN echo no | avdmanager create avd -n test -k "system-images;android-24;google_apis;x86_64" -f --abi "x86_64" --tag "google_apis"

# Install openssh
RUN apt-get update -y
RUN apt-get install -y nasm openssh-client
RUN eval $(ssh-agent -s)
RUN mkdir -p ~/.ssh

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
