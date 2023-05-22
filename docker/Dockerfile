FROM jenkins/jenkins:lts-alpine

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
 
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY jenkins-user /run/secrets/jenkins-user
COPY jenkins-pass /run/secrets/jenkins-pass

RUN jenkins-plugin-cli \
    --plugins \
    git \
    pipeline-aws \
    amazon-ecs \
    configuration-as-code \
    credentials-binding \
    workflow-aggregator \
    workflow-job \
    plasticscm-plugin:4.2