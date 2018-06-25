# Alpine based Openjdk JRE Image

This image is based on the official `openjdk:8-jre-alpine` image and runs as a non-root user.

## Configuration

| Path                           | Description                                        |
|------                          |-------------                                       |
|  /opt/app-root/bin             | Path to place runables.                            |
|  /persistent                   | Path where persitent data should be stored.        |
|  /certificates                 | Path where certificates are stored.                |
|  /certificates/ca.pem          | File path to a custom CA certificate.              |
|  /certificates/server.p12      | File path to a PKCS12 type server certificate/key. |
|  /certificates/server_cert.pem | File path to a PEM formatted server certificate.   |
|  /certificates/server_key.pem  | File path to a PEM formatted server key.           |
|  /keystores                    | Path were java keystore or other keystores are stored |
|  /keystores/cacerts            | Java keystore with symlink to ``/etc/ssl/certs/java/cacerts` |


| env                   | Description                                                         |
|------                 |-------------                                                        |
|  APP_ROOT             | Path to place binaries and scripts. Can be used in scripts.         |
|  PERSISTENCE_ROOT     | Path where persistent data should be stored. Can be used in scripts.|
|  CERTIFICATES_ROOT    | Path where certificates are stored. Can be used in scripts.         |
|  KEYSTORES_ROOT       | Path where keystores are stored.                                    |
|  KEYSTORE_PATH        | Path of Java keystore. Can be used in scripts.                      |
|  KEYSTORE_PASSWORD    | Password of custom keystore if added. Defaults to `changeit`.       |
|  PKCS12_PASSWORD      | Password of server.p12. Defaults to `""` (empty string).            |
|  PKCS12_ALIAS         | Alias of PrivateKeyEntry in server.p12. Defaults to `servercert`.   |

### Application Binary

One can use **/opt/app-root/bin** (env `APP_ROOT`) to place and run its **.jar**
file.

### Persistent Data

For persistent data the folder **/persistent** (env `PERSISTENCE_ROOT`) is foreseen.

### SSL Certificates

Under **/certificates** (env `CERTIFICATES_ROOT`) a set of certificates is stored,
that can be used for Development. The certificates are valid for the domain
**i.test** and are signed by an internal Certificate Authority that was created
for testing only. By default the certificate for this CA is added to the truststore
that is located under **/keystores/cacerts**. One can either supply its own
truststore by replacing **/keystores/cacerts** or store its custom CA cert
as .pem file under **/certificates/ca.pem**. The entrypoint.sh script will then add
it to the truststore. To add a custom server certificate, place a PKCS12 type
server certificate/key to **/certificates/server.p12**. You can specify the
password of this PKCS12 archive with the env variable `PKCS12_PASSWORD`. If no
password was specified, an empty string will be used as password. You might also
want to specify the alias used to store the private key entry with `PKCS12_ALIAS`
so that an application can access the private key if it was addded to the keystore.

## How to use

Add your *.jar* file from your project

`ADD target/scala-2.12/ bin/`

specify the command how to start it

`CMD java -jar bin/myproject.jar`

build your image and run it.
