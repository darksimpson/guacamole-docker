BASEDIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ${BASEDIR}/.m2

docker run -it --rm --name guacamole-client-1.1.0-build --volume "${BASEDIR}/guacamole-client-1.1.0":/usr/src/app -w /usr/src/app --volume "${BASEDIR}/.m2":/root/.m2 maven:3-jdk-8-alpine mvn clean package -DskipTests

cp ${BASEDIR}/guacamole-client-1.1.0/guacamole/target/guacamole-1.1.0.war ${BASEDIR}/guacamole-1.1.0.war
cp ${BASEDIR}/guacamole-client-1.1.0/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/target/guacamole-auth-jdbc-mysql-1.1.0.jar ${BASEDIR}/guacamole-auth-jdbc-mysql-1.1.0.jar
