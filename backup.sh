#!/bin/bash

#### Replace config vars
sed -i "s,_SCALEWAY_ENDPOINT_URL_,${SCALEWAY_ENDPOINT_URL},g" /root/.aws/config
sed -i "s,_SCALEWAY_REGION_,${SCALEWAY_REGION},g" /root/.aws/config

#### Replace credentials vars
sed -i "s,_SCALEWAY_ACCESS_KEY_,${SCALEWAY_ACCESS_KEY},g" /root/.aws/credentials
sed -i "s,_SCALEWAY_SECRET_KEY_,${SCALEWAY_SECRET_KEY},g" /root/.aws/credentials

#### Generate Backup

DUMP_DIR="./dump"

# Ensure there is no old backup
rm -rf $DUMP_DIR

echo "Starting backup..."

if [ -z "${MONGODB_USERNAME}" ] && [ -z "${MONGODB_PASSWORD}" ]; then
  auth=""
else
  auth="${MONGODB_USERNAME}:${MONGODB_PASSWORD}@"
fi

if [ -z "${MONGODB_EXTRA_PARAMS}" ]; then
  extraParams=""
else
  extraParams="?${MONGODB_EXTRA_PARAMS}"
fi

if [ -z "${MONGODB_PREFIX_USE_SRV}" ]; then
  mongoPrefix="mongodb+srv"
else
  extraParams="mongodb"
fi

uri="${mongoPrefix}://${auth}${MONGODB_HOST}/${MONGODB_DATABASE}${extraParams}";

mongodump --uri="${uri}" --out=${DUMP_DIR}

echo "Backup complete."
echo "Compressing backup..."

if [ -z "${BACKUP_PREFIX}" ]; then
  fileName=`date +%Y-%m-%d-%H%M%S.zip`
else
  fileName=`date +%Y-%m-%d-%H%M%S.zip`
  fileName="${BACKUP_PREFIX}-${fileName}"
fi

zip -r $fileName $DUMP_DIR

echo "Compression complete"
echo "Uploading ..."

path=`date +%Y/%m/%d`;
path="${SCALEWAY_BUCKET_PATH}/$path"

aws s3 cp $fileName s3://${SCALEWAY_BUCKET_NAME}/$path/$fileName

echo "Uploaded"
