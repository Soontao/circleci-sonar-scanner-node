FROM openjdk:8-jre-slim

SHELL ["/bin/bash", "-c"]

ENV SONAR_SCANNER_VERSION 3.3.0.1492
ENV SONAR_OPTS ''

RUN apt-get update && apt-get install -y wget git openssh-client unzip build-essential

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip

RUN unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux

RUN ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner /usr/bin/sonar-scanner
RUN chmod +x /usr/bin/sonar-scanner

VOLUME /project
WORKDIR /project

ADD run-sonar-scanner.sh /usr/bin/run-sonar-scanner
CMD run-sonar-scanner
