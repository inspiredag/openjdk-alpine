#!/bin/sh

# Add user to root group
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
    echo -e "\nContainer user added to root group."
  fi
fi

# Import CA if provided
if [ -e "${CERTIFICATES_ROOT}/ca.pem" ]; then
  echo -e "\nWill add CA to the java keystore.\n"
  keytool -import -noprompt -alias ca_trusted_during_container_startup -file ${CERTIFICATES_ROOT}/ca.pem -keystore ${KEYSTORE_PATH} -storepass changeit
fi

# Import server certificate if provided
if [ -e "${CERTIFICATES_ROOT}/server.p12" ]; then
  echo -e "\nWill add PKCS12 type Server cert and key to the java keystore.\n"
  keytool -importkeystore -noprompt -srckeystore ${CERTIFICATES_ROOT}/server.p12 -srcstoretype PKCS12 -srcstorepass ${PKCS12_PASSWORD:-""} -keystore $KEYSTORE_PATH -storepass changeit
fi

exec "$@"
