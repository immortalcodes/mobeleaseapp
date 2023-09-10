docker stop server
docker rm server
docker build -t serverimage .
docker run -d -p 8000:8000  --network host --name server serverimage