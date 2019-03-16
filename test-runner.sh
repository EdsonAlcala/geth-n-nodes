CONTAINER_NAME="geth-n-nodes"
echo "$CONTAINER_NAME"
docker container stop ${CONTAINER_NAME}
docker container rm ${CONTAINER_NAME}
docker build --no-cache -t ${CONTAINER_NAME} .
docker run -it --rm --name ${CONTAINER_NAME} -p 9001-9004:9001-9004 ${CONTAINER_NAME}
# docker run -t -d --name ${CONTAINER_NAME} -p 9001-9004:9001-9004 ${CONTAINER_NAME}
# docker exec -it ${CONTAINER_NAME} start-nodes
# docker exec -it ${CONTAINER_NAME} start-nodes