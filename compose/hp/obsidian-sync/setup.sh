#!/bin/sh -xe
# Generate the password and store it in a variable

ADMIN_PASSWORD=$(base32 /dev/random |head -1|cut -c-24)
# Print the credentials to the console for easy retrieval from Docker logs

echo "CouchDB Admin Username: dbadmin"
echo "CouchDB Admin Password: ${ADMIN_PASSWORD}"

cat >/opt/couchdb/etc/local.ini <<EOF
[couchdb]
single_node=true

[admins]
dbadmin = ${ADMIN_PASSWORD}
EOF

nohup bash -c "/docker-entrypoint.sh /opt/couchdb/bin/couchdb &"
sleep 15

curl -X PUT http://127.0.0.1:5984/_users
curl -X PUT http://127.0.0.1:5984/_replicator