set -e
AUTOSSH_POLL=5
AUTOSSH_GATETIME=0
if [[ ! -f /sshkey ]]; then
    echo "no /sshkey file"
    exit -1
fi
cp /sshkey /tmp/sshkey
# echo $SSH_KEY | base64 -d > /tmp/sshkey
chmod 600 /tmp/sshkey
rm -f $HOME/.ssh/known_hosts* || true
# # Dockerfile
# apt-get update
# apt-get install -yq openssh-client autossh sshpass gettext-base
apk add --update openssh-client autossh sshpass
#################################
cat <<EOF > /etc/nginx/nginx.conf
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        off;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
}
stream 
{
    include /etc/nginx/streams/*.conf;
}
EOF
mkdir -p /etc/nginx/streams
cat <<EOF > /etc/nginx/streams/config.template
upstream up_\${N} 
{
    server 127.0.0.1:510\${N};
    server 127.0.0.1:520\${N};
    server 127.0.0.1:530\${N};
    server 127.0.0.1:540\${N};
    server 127.0.0.1:550\${N};
    server 127.0.0.1:560\${N};
    server 127.0.0.1:570\${N};
    server 127.0.0.1:580\${N};
    server 127.0.0.1:590\${N};
}
server {
    listen 500\${N};
    proxy_pass up_\${N} ;
}
EOF
for j in $(seq 99)
do
    i=$(printf '%02d' $j)
    export N=$i;
    envsubst < /etc/nginx/streams/config.template > /etc/nginx/streams/config_$i.conf;
done
myssh () {
N=$1
COLDSTART=$2
ALIVEINTERVAL=$3
ALIVECOUNT=$4
REMOTE_ADDRESS=$(getent hosts $REMOTE_ADDRESS | awk '{ print $1 }')
SSH_SERVER=$(getent hosts $SSH_SERVER | awk '{ print $1 }')
AUTOSSH_POLL=5
AUTOSSH_GATETIME=0
while true
do
    sleep $COLDSTART
    echo ssh N=$N
    autossh -M 0 \
        -N \
        -i /tmp/sshkey \
        -o "StrictHostKeyChecking no" \
        -o "BatchMode yes" \
        -o "ExitOnForwardFailure yes" \
        -o "ServerAliveInterval $ALIVEINTERVAL" \
        -o "ServerAliveCountMax $ALIVECOUNT" \
        -o "GatewayPorts yes" \
        -p $SSH_PORT \
        -L 0.0.0.0:$((50001+N*1000)):$REMOTE_ADDRESS:40001 \
        -L 0.0.0.0:$((50002+N*1000)):$REMOTE_ADDRESS:40002 \
        -L 0.0.0.0:$((50003+N*1000)):$REMOTE_ADDRESS:40003 \
        -L 0.0.0.0:$((50004+N*1000)):$REMOTE_ADDRESS:40004 \
        -L 0.0.0.0:$((50005+N*1000)):$REMOTE_ADDRESS:40005 \
        -L 0.0.0.0:$((50006+N*1000)):$REMOTE_ADDRESS:40006 \
        -L 0.0.0.0:$((50007+N*1000)):$REMOTE_ADDRESS:40007 \
        -L 0.0.0.0:$((50008+N*1000)):$REMOTE_ADDRESS:40008 \
        -L 0.0.0.0:$((50009+N*1000)):$REMOTE_ADDRESS:40009 \
        -L 0.0.0.0:$((50010+N*1000)):$REMOTE_ADDRESS:40010 \
        -L 0.0.0.0:$((50011+N*1000)):$REMOTE_ADDRESS:40011 \
        -L 0.0.0.0:$((50012+N*1000)):$REMOTE_ADDRESS:40012 \
        -L 0.0.0.0:$((50013+N*1000)):$REMOTE_ADDRESS:40013 \
        -L 0.0.0.0:$((50014+N*1000)):$REMOTE_ADDRESS:40014 \
        -L 0.0.0.0:$((50015+N*1000)):$REMOTE_ADDRESS:40015 \
        -L 0.0.0.0:$((50016+N*1000)):$REMOTE_ADDRESS:40016 \
        -L 0.0.0.0:$((50017+N*1000)):$REMOTE_ADDRESS:40017 \
        -L 0.0.0.0:$((50018+N*1000)):$REMOTE_ADDRESS:40018 \
        -L 0.0.0.0:$((50019+N*1000)):$REMOTE_ADDRESS:40019 \
        -L 0.0.0.0:$((50020+N*1000)):$REMOTE_ADDRESS:40020 \
        -L 0.0.0.0:$((50021+N*1000)):$REMOTE_ADDRESS:40021 \
        -L 0.0.0.0:$((50022+N*1000)):$REMOTE_ADDRESS:40022 \
        -L 0.0.0.0:$((50023+N*1000)):$REMOTE_ADDRESS:40023 \
        -L 0.0.0.0:$((50024+N*1000)):$REMOTE_ADDRESS:40024 \
        -L 0.0.0.0:$((50025+N*1000)):$REMOTE_ADDRESS:40025 \
        -L 0.0.0.0:$((50026+N*1000)):$REMOTE_ADDRESS:40026 \
        -L 0.0.0.0:$((50027+N*1000)):$REMOTE_ADDRESS:40027 \
        -L 0.0.0.0:$((50028+N*1000)):$REMOTE_ADDRESS:40028 \
        -L 0.0.0.0:$((50029+N*1000)):$REMOTE_ADDRESS:40029 \
        -L 0.0.0.0:$((50030+N*1000)):$REMOTE_ADDRESS:40030 \
        -L 0.0.0.0:$((50031+N*1000)):$REMOTE_ADDRESS:40031 \
        -L 0.0.0.0:$((50032+N*1000)):$REMOTE_ADDRESS:40032 \
        -L 0.0.0.0:$((50033+N*1000)):$REMOTE_ADDRESS:40033 \
        -L 0.0.0.0:$((50034+N*1000)):$REMOTE_ADDRESS:40034 \
        -L 0.0.0.0:$((50035+N*1000)):$REMOTE_ADDRESS:40035 \
        -L 0.0.0.0:$((50036+N*1000)):$REMOTE_ADDRESS:40036 \
        -L 0.0.0.0:$((50037+N*1000)):$REMOTE_ADDRESS:40037 \
        -L 0.0.0.0:$((50038+N*1000)):$REMOTE_ADDRESS:40038 \
        -L 0.0.0.0:$((50039+N*1000)):$REMOTE_ADDRESS:40039 \
        -L 0.0.0.0:$((50040+N*1000)):$REMOTE_ADDRESS:40040 \
        -L 0.0.0.0:$((50041+N*1000)):$REMOTE_ADDRESS:40041 \
        -L 0.0.0.0:$((50042+N*1000)):$REMOTE_ADDRESS:40042 \
        -L 0.0.0.0:$((50043+N*1000)):$REMOTE_ADDRESS:40043 \
        -L 0.0.0.0:$((50044+N*1000)):$REMOTE_ADDRESS:40044 \
        -L 0.0.0.0:$((50045+N*1000)):$REMOTE_ADDRESS:40045 \
        -L 0.0.0.0:$((50046+N*1000)):$REMOTE_ADDRESS:40046 \
        -L 0.0.0.0:$((50047+N*1000)):$REMOTE_ADDRESS:40047 \
        -L 0.0.0.0:$((50048+N*1000)):$REMOTE_ADDRESS:40048 \
        -L 0.0.0.0:$((50049+N*1000)):$REMOTE_ADDRESS:40049 \
        -L 0.0.0.0:$((50050+N*1000)):$REMOTE_ADDRESS:40050 \
        -L 0.0.0.0:$((50051+N*1000)):$REMOTE_ADDRESS:40051 \
        -L 0.0.0.0:$((50052+N*1000)):$REMOTE_ADDRESS:40052 \
        -L 0.0.0.0:$((50053+N*1000)):$REMOTE_ADDRESS:40053 \
        -L 0.0.0.0:$((50054+N*1000)):$REMOTE_ADDRESS:40054 \
        -L 0.0.0.0:$((50055+N*1000)):$REMOTE_ADDRESS:40055 \
        -L 0.0.0.0:$((50056+N*1000)):$REMOTE_ADDRESS:40056 \
        -L 0.0.0.0:$((50057+N*1000)):$REMOTE_ADDRESS:40057 \
        -L 0.0.0.0:$((50058+N*1000)):$REMOTE_ADDRESS:40058 \
        -L 0.0.0.0:$((50059+N*1000)):$REMOTE_ADDRESS:40059 \
        -L 0.0.0.0:$((50060+N*1000)):$REMOTE_ADDRESS:40060 \
        -L 0.0.0.0:$((50061+N*1000)):$REMOTE_ADDRESS:40061 \
        -L 0.0.0.0:$((50062+N*1000)):$REMOTE_ADDRESS:40062 \
        -L 0.0.0.0:$((50063+N*1000)):$REMOTE_ADDRESS:40063 \
        -L 0.0.0.0:$((50064+N*1000)):$REMOTE_ADDRESS:40064 \
        -L 0.0.0.0:$((50065+N*1000)):$REMOTE_ADDRESS:40065 \
        -L 0.0.0.0:$((50066+N*1000)):$REMOTE_ADDRESS:40066 \
        -L 0.0.0.0:$((50067+N*1000)):$REMOTE_ADDRESS:40067 \
        -L 0.0.0.0:$((50068+N*1000)):$REMOTE_ADDRESS:40068 \
        -L 0.0.0.0:$((50069+N*1000)):$REMOTE_ADDRESS:40069 \
        -L 0.0.0.0:$((50070+N*1000)):$REMOTE_ADDRESS:40070 \
        -L 0.0.0.0:$((50071+N*1000)):$REMOTE_ADDRESS:40071 \
        -L 0.0.0.0:$((50072+N*1000)):$REMOTE_ADDRESS:40072 \
        -L 0.0.0.0:$((50073+N*1000)):$REMOTE_ADDRESS:40073 \
        -L 0.0.0.0:$((50074+N*1000)):$REMOTE_ADDRESS:40074 \
        -L 0.0.0.0:$((50075+N*1000)):$REMOTE_ADDRESS:40075 \
        -L 0.0.0.0:$((50076+N*1000)):$REMOTE_ADDRESS:40076 \
        -L 0.0.0.0:$((50077+N*1000)):$REMOTE_ADDRESS:40077 \
        -L 0.0.0.0:$((50078+N*1000)):$REMOTE_ADDRESS:40078 \
        -L 0.0.0.0:$((50079+N*1000)):$REMOTE_ADDRESS:40079 \
        -L 0.0.0.0:$((50080+N*1000)):$REMOTE_ADDRESS:40080 \
        -L 0.0.0.0:$((50081+N*1000)):$REMOTE_ADDRESS:40081 \
        -L 0.0.0.0:$((50082+N*1000)):$REMOTE_ADDRESS:40082 \
        -L 0.0.0.0:$((50083+N*1000)):$REMOTE_ADDRESS:40083 \
        -L 0.0.0.0:$((50084+N*1000)):$REMOTE_ADDRESS:40084 \
        -L 0.0.0.0:$((50085+N*1000)):$REMOTE_ADDRESS:40085 \
        -L 0.0.0.0:$((50086+N*1000)):$REMOTE_ADDRESS:40086 \
        -L 0.0.0.0:$((50087+N*1000)):$REMOTE_ADDRESS:40087 \
        -L 0.0.0.0:$((50088+N*1000)):$REMOTE_ADDRESS:40088 \
        -L 0.0.0.0:$((50089+N*1000)):$REMOTE_ADDRESS:40089 \
        -L 0.0.0.0:$((50090+N*1000)):$REMOTE_ADDRESS:40090 \
        -L 0.0.0.0:$((50091+N*1000)):$REMOTE_ADDRESS:40091 \
        -L 0.0.0.0:$((50092+N*1000)):$REMOTE_ADDRESS:40092 \
        -L 0.0.0.0:$((50093+N*1000)):$REMOTE_ADDRESS:40093 \
        -L 0.0.0.0:$((50094+N*1000)):$REMOTE_ADDRESS:40094 \
        -L 0.0.0.0:$((50095+N*1000)):$REMOTE_ADDRESS:40095 \
        -L 0.0.0.0:$((50096+N*1000)):$REMOTE_ADDRESS:40096 \
        -L 0.0.0.0:$((50097+N*1000)):$REMOTE_ADDRESS:40097 \
        -L 0.0.0.0:$((50098+N*1000)):$REMOTE_ADDRESS:40098 \
        -L 0.0.0.0:$((50099+N*1000)):$REMOTE_ADDRESS:40099 \
        $SSH_USER@$SSH_SERVER
done
}

myssh  1   5  5  5  &
myssh  2  10 10 10  &
myssh  3  15 15 15  &
myssh  4  20 20 10  &
myssh  5  25 25 25  &
myssh  6  30 30 10  &
myssh  7  35 35 35  &
myssh  8  40 40 10  &
myssh  9  45 45 45  &

sleep 50 && nginx -g "daemon off;"

