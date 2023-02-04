FROM openjdk:8-jdk-alpine
RUN apk update && apk add --no-cache curl tar bash procps openssh sshpass

#Aruments Downloading and installing gradle
ARG GRADLE_VERSION=4.0.2
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
#ARG GRADLE_SHA=79ac421342bd11f6a4f404e0988baa9c1f5fabf07e3c6fa65b0c15c1c31dda22

RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
    && echo "Downloading gradle hash" \
    && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
    \
#    && echo "Checking download hash" \
#    && echo "${GRADLE_SHA} /tmp/gradle.zip" | sha256sum -c - \
#    \
    && echo "Unzipping gradle" \
    && unzip -d /usr/share/gradle /tmp/gradle.zip \
    \
    && echo "Cleaning and setting links" \
    && rm -f /tmp/gradle.zip \
    && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle
    
#Setting environment varibale for gradle
ENV GRADLE_VERSION 4.0.2
ENV GRADLE_HOME /usr/bin/gradle
ENV GRADLE_USER_HOME /cache

ENV PATH $PATH:$GRADLE_HOME/bin

VOLUME $GRADLE_USER_HOME


#create jenkins user

RUN adduser -D -s /bin/bash jenkins && echo "jenkins:jenkins" | chpasswd

#setup ssh server
RUN sed -i /etc/ssh/sshd_config \
    -e 's/#PermitRootLogin.*/PermitRootLogin yes/' \
    -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
    -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
    -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
    -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd
EXPOSE 22
CMD [""]



