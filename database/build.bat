docker stop dbcont
docker rm dbcont
docker build -t dbimg .
docker run -d -p 5432:5432   --name dbcont dbimg
docker exec -it dbcont bash 
