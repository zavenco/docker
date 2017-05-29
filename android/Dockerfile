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

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-7-openjdk-$(dpkg --print-architecture)" /docker-java-home



# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes unzip expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Download Android SDK
RUN wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN tar xzf ./android-sdk.tgz -C /opt
RUN rm -f ./android-sdk.tgz

RUN chown -R root.root /opt/android-sdk-linux

# Install google-repository
RUN /opt/tools/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools,build-tools-22.0.1,build-tools-23.0.3,build-tools-24.0.3,build-tools-25.0.0,build-tools-25.0.1,build-tools-25.0.3,android-21,android-22,android-23,android-24,android-25,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services"

# Export variables
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools/
ENV GRADLE_USER_HOME $(pwd)/.gradle/

RUN mkdir -p "${ANDROID_HOME}/licenses"
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_HOME}/licenses/android-sdk-preview-license"
RUN echo -e "\nd975f751698a77b662f1254ddbeed3901e976f5a" > "${ANDROID_HOME}/licenses/intel-android-extra-license"

# Install openssh
RUN apt-get update -y
RUN apt-get install -y nasm openssh-client
RUN eval $(ssh-agent -s)
RUN mkdir -p ~/.ssh

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
