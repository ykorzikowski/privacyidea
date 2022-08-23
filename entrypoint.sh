#!/bin/sh

WORKERS=${PI_WORKERS:4}
PI_CFG=/config/pi.cfg
source bin/activate

if [ ! -f ${PI_CFG} ]; then
  PEPPER="$(tr -dc A-Za-z0-9_ </dev/urandom | head -c24)"
  echo "PI_PEPPER = '$PEPPER'" >> ${PI_CFG}
  SECRET="$(tr -dc A-Za-z0-9_ </dev/urandom | head -c24)"
  echo "SECRET_KEY = '$SECRET'" >> ${PI_CFG}

  echo ${SQLALCHEMY_DATABASE_URI} >> ${PI_CFG}
fi

gunicorn --workers=${WORKERS} privacyidea:app
