#!/bin/bash

if which mongosh > /dev/null 2>&1; then
  mongo_init_bin='mongosh'
else
  mongo_init_bin='mongo'
fi
"${mongo_init_bin}" <<EOF
use admin
db.auth("root", "${MONGO_ROOT_PASSWORD}")
db.createUser({
  user: "unifi",
  pwd: "${MONGO_SERVICE_PASSWORD}",
  roles: [
    { db: "unifi", role: "dbOwner" },
    { db: "unifi_stat", role: "dbOwner" }
  ]
})
EOF
