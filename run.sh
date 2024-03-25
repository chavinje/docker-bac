docker rm apache-1
docker run -p 8080:80 -v $(pwd)/web:/web --name apache-1 jcg/apache:0.1
