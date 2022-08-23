#!/bin/bash

set -eux

WORKERS=${PI_WORKERS:=4}
export PI_CFG=/etc/privacyidea/pi.cfg
export PI_LOGFILE=/logs/privacyidea.log
source bin/activate

if [ ! -f ${PI_CFG} ]; then
  PEPPER="$(tr -dc A-Za-z0-9_ </dev/urandom | head -c24)"
  echo "PI_PEPPER = '$PEPPER'" >> ${PI_CFG}
  SECRET="$(tr -dc A-Za-z0-9_ </dev/urandom | head -c24)"
  echo "SECRET_KEY = '$SECRET'" >> ${PI_CFG}
  echo "PI_LOGFILE = '$PI_LOGFILE'" >> ${PI_CFG}
  echo "PI_AUDIT_SQL_TRUNCATE = True" >> ${PI_CFG}
  echo "PI_LOGLEVEL = 20" >> ${PI_CFG}

  echo ${SQLALCHEMY_DATABASE_URI} >> ${PI_CFG}


  ./pi-manage createdb
  ./pi-manage create_enckey
  ./pi-manage db stamp head -d migrations/
  ./pi-manage create_audit_keys
  ./pi-manage admin add admin # TODO: this is asking for password
  
fi

gunicorn -b "0.0.0.0:8000" --workers=${WORKERS} "privacyidea.app:create_app()"
