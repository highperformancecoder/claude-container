#docker login --username=highperformancecoder 
docker build --pull --network=host --tag highperformancecoder/claude-container .
docker push highperformancecoder/claude-container
