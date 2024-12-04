docker run -d --name mongo1 -p 27017:27017 mongo mongod --replSet rs0 --bind_ip_all
docker run -d --name mongo2 -p 27018:27017 mongo mongod --replSet rs0 --bind_ip_all
docker run -d --name mongo3 -p 27019:27017 mongo mongod --replSet rs0 --bind_ip_all

docker exec -it mongo1 mongosh

# rs.initiate({
#     _id: "rs0",
#     members: [
#         { _id: 0, host: "mongo1:27017" },
#         { _id: 1, host: "mongo2:27017" },
#         { _id: 2, host: "mongo3:27017" }
#     ]
# });
# rs.status();

docker exec -it mongo1 mongosh
# rs.status();
