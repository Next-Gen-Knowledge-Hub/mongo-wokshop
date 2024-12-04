# Scaling your system with sharding

## 1. Sharding overview
Sharding is the process of partitioning a large dataset into smaller, more manageable pieces.

## 2. Undestanding components of a sharded cluster

### 2.1 Shards

`shard` store the application data. In a sharded cluster, only the mongos routers or system administrators should be connecting directly to the shards. Like an unsharded deployment, each shard can be a single node for development and testing, but should be a replica set in production.

### 2.2 Mongos

`mongos` routers (center) cache the cluster metadata and use it to route operations to the correct shard or shards.

### 2.3 Config servers

`config servers` persistently store metadata about the cluster, including which shard has what subset of the data.

## 3. Distributing data in a sharded cluster
    
**4 level of granularity** in mongodb (`document`, `chunk "group of documents with same field value"`, `collection`, `database`) sharding level On the level of partitions or chunks of a collection, where the documents within a collection itself are divided up and spread out over multiple shards, based on values of a field or set of fields called the shard key in the documents.

## 4. Building a sample shard cluster

### 4.1 Starting the mongod and mongos servers

The first step in setting up a sharded cluster is to start all the required mongod and mongos processes.

### 4.2 Config the cluster

### 4.3 Sharding the collection

### 4.4 Write into the sharded cluster

```js    
db.chunks.findOne();
```

`minKey` and `maxKey`, `Splits` and migrations, ask `gpt` for more info.

## 5. Quering and indexing a shard cluster
    
From the application's perspective, there's no difference between querying a sharded cluster and querying a single mongod.

### 5.1 Query routing

"targeted query" and "scatter/gather query" two type of query routing scenario(ask `gpt` for more).

### 5.2 Indexing in a sharded cluster
    
No matter how well-targeted your queries are, they must eventually run on at least one shard. This means that if your shards are slow to respond to queries, your cluster will be slow as well.

## 6. Choosing a shard key

### 6.1 Imbalanced writes (hostspots)

But there's one glaring problem with using an Object ID as a shard key: its values are strictly ascending. This means that every new document will have a shard key larger than any other document in the collection. that means we have many write queries ahead into one of the shards. (Uniqueness gotchas)

### 6.2 Unsplittable chunks (coarse granularity)

There's just one problem with this field: it's so coarse that we may end up in a situation where one chunk grows without bound. To see this, imagine that the user "Verch" decides to store `10 GB` of spreadsheet data. This would bring the size of the chunk containing the documents with a username of "Verch" well above our `64 MB` maximum.

### 6.3 Poor targeting (shard key not present in queries)

Select a shard key that didn't presents in queries who resaults in scatter/gather query.

### 6.4 Ideal shard keys

```js
{username : 1, _id : 1 }
```

Is a good sharding key who have all of the defined criterias.
