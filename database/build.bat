docker stop testcont
docker rm testcont
docker build -t tesdb .
docker run -d -p 5431:5432   --name testcont tesdb
docker exec -it testcont bash 
