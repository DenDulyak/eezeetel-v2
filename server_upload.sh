#!/bin/bash -x
set -o nounset
set -o errexit


CURRENT_DIR=$(pwd)
echo "Current directory is: $CURRENT_DIR"

mvn clean install
mv target/eezeetel-0.0.1-SNAPSHOT.war target/eezeetel.war

ENV=${1:-dev}
case ${ENV} in
  demo)
	PROJECT_NAME="eezeetel-demo"
	SERVER_NAME="demo"
  ;;
  prod)
	PROJECT_NAME="eezeetel-prod"
	SERVER_NAME="prod"
  ;;
  *)
	PROJECT_NAME="eezeetel-test"
	SERVER_NAME="test"
  ;;
esac

echo "Uploading the war file to ${PROJECT_NAME}/${SERVER_NAME}"
gcloud compute copy-files target/eezeetel.war rkasanagottu_gmail_com@${SERVER_NAME}:/tmp --project ${PROJECT_NAME}
gcloud compute ssh ${SERVER_NAME}  --project ${PROJECT_NAME} --command="sudo /opt/eezeetel/server.sh"
echo "Upload completed for ${ENV}"
