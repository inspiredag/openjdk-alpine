FROM openjdk:8-jre-alpine

### Install necessary tools
RUN apk --no-cache add curl

### Set base paths and other envs
ENV APP_ROOT=/opt/app-root CERTIFICATES_ROOT=/certificates PERSISTENCE_ROOT=/persistent KEYSTORES_ROOT=/keystores
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT} KEYSTORE_PATH=${KEYSTORES_ROOT}/cacerts

### Setup user for build execution and application runtime
COPY entrypoint.sh ${APP_ROOT}/bin/
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Setup Path for persistent Data
RUN mkdir ${PERSISTENCE_ROOT} && \
    chgrp -R 0 ${PERSISTENCE_ROOT} &&\
    chmod -R g=u ${PERSISTENCE_ROOT}

### Setup Path for Certificates with default for Development environments
ADD certificates/i.test_dev_wildcard_cert.pem ${CERTIFICATES_ROOT}/server_cert.pem
ADD certificates/i.test_dev_wildcard_key.pem ${CERTIFICATES_ROOT}/server_key.pem
ADD certificates/i.test_dev_wildcard.p12 ${CERTIFICATES_ROOT}/server.p12
ADD certificates/Inspired_Development_CA.pem ${CERTIFICATES_ROOT}/ca.pem
RUN mkdir ${KEYSTORES_ROOT} &&\
    chgrp -R 0 ${KEYSTORES_ROOT} &&\
    chmod -R g=u ${KEYSTORES_ROOT} &&\
    mv /etc/ssl/certs/java/cacerts ${KEYSTORES_ROOT} &&\
    ln -s ${KEYSTORES_ROOT}/cacerts /etc/ssl/certs/java/cacerts &&\
    chmod 660 ${KEYSTORES_ROOT}/cacerts &&\
    chgrp -R 0 ${CERTIFICATES_ROOT} &&\
    chmod -R g=u ${CERTIFICATES_ROOT}

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}
ENTRYPOINT [ "bin/entrypoint.sh" ]
