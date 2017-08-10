cd ./deploy

# ENV Variables that are used the the platform-service-deploy.sh script
export ECS_CLUSTER=$ECS_CLUSTER_STG
export ECS_SERVICE=$ECS_SERVICE_STG
export SERVICE_CONTAINER_NAME=$ECS_SERVICE_STG
export CONTAINER_IMAGE=$ECR_REPOSITORY:${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}
export SERVICE_TOKEN=D80BA375-8BE2-4D1F-B415-EDC0CBBAE9AC

#download latest deploy script
aws s3 cp "s3://flipp-platform-"$WISHABI_ENVIRONMENT"/deploy/platform-service-deploy.sh" platform-service-deploy.sh
chmod +x platform-service-deploy.sh
#Execute the deployment Scripts
./platform-service-deploy.sh

