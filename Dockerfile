FROM openjdk:jre-alpine
# RUN adduser -h '/home/propertymanager' -s '/bin/sh' -D user

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY uid_entrypoint.sh ${APP_ROOT}/bin/
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}
ENTRYPOINT [ "bin/uid_entrypoint.sh" ]
