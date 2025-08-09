FROM jenkins/jenkins:lts-jdk17

USER root
# utilitários
RUN apt-get update && apt-get install -y curl bash git && rm -rf /var/lib/apt/lists/*

USER jenkins
# Instala plugins necessários via jenkins-plugin-cli
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Habilita logs com timestamps no console por padrão
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=true"
