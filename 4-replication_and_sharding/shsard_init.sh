mkdir -p mongo_cluster/{config1,config2,config3,shard1,shard2,router}

# Start Config Servers

# Config Server 1
docker run --rm --net=host --name config1 \
    -v $(pwd)/mongo_cluster/config1:/data/configdb \
    mongo:latest \
    mongod --configsvr --replSet configReplSet --dbpath /data/configdb --bind_ip_all

# Config Server 2
docker run --rm --net=host --name config2 \
    -v $(pwd)/mongo_cluster/config2:/data/configdb \
    mongo:latest \
    mongod --configsvr --replSet configReplSet --dbpath /data/configdb --bind_ip_all

# Config Server 3
docker run --rm --net=host --name config3 \
    -v $(pwd)/mongo_cluster/config3:/data/configdb \
    mongo:latest \
    mongod --configsvr --replSet configReplSet --dbpath /data/configdb --bind_ip_all

# initial config server replica set

# Initialize Config Server Replica Set

docker exec -it config1 mongosh

# rs.initiate({
#   _id: "configReplSet",
#   configsvr: true,
#   members: [
#     { _id: 0, host: "localhost:27019" },  // Port for config1
#     { _id: 1, host: "localhost:27020" },  // Port for config2
#     { _id: 2, host: "localhost:27021" }   // Port for config3
#   ]
# });

# Start Shard Servers

# Shard 1
docker run --rm --net=host --name shard1 \
    -v $(pwd)/mongo_cluster/shard1:/data/db \
    mongo:latest \
    mongod --shardsvr --replSet shard1ReplSet --dbpath /data/db --bind_ip_all

# Shard 2
docker run --rm --net=host --name shard2 \
    -v $(pwd)/mongo_cluster/shard2:/data/db \
    mongo:latest \
    mongod --shardsvr --replSet shard2ReplSet --dbpath /data/db --bind_ip_all

# Initialize Shard Replica Sets

docker exec -it shard1 mongosh
# rs.initiate({
#   _id: "shard1ReplSet",
#   members: [{ _id: 0, host: "localhost:27022" }]  // Port for shard1
# });

docker exec -it shard2 mongosh
# rs.initiate({
#   _id: "shard2ReplSet",
#   members: [{ _id: 0, host: "localhost:27023" }]  // Port for shard2
# });

# Start Mongos Router

docker run --rm --net=host --name mongos \
    mongo:latest \
    mongos --configdb configReplSet/localhost:27019,localhost:27020,localhost:27021 --bind_ip_all

# Add Shards to the Cluste

docker exec -it mongos mongosh
#sh.addShard("shard1ReplSet/localhost:27022");
#sh.addShard("shard2ReplSet/localhost:27023");

# sh.status();

# sh.enableSharding("cloud-docs");

# Cleanup

# docker stop config1 config2 config3 shard1 shard2 mongos
# docker rm config1 config2 config3 shard1 shard2 mongos
