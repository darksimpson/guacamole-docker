BASEDIR="$(cd "$(dirname "$0")" && pwd)"

docker build -t darksimpson/guacd:1.1.0 ${BASEDIR}/guacamole-server-1.1.0
