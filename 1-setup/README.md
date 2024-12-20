# MongoDB Go Driver

The MongoDB supported driver for Go.

See the following resources to learn more about upgrading from version 1.x to 2.0.:

- [v2.0 What's New](https://www.mongodb.com/docs/drivers/go/upcoming/whats-new/#what-s-new-in-2.0)

## Requirements

- Go 1.18 or higher. We aim to support the latest versions of Go.
- Go 1.22 or higher is required to run the driver test suite.
- MongoDB 3.6 and higher.

## Installation

The recommended way to get started using the MongoDB Go driver is by using Go modules to install the dependency in
your project. This can be done either by importing packages from `go.mongodb.org/mongo-driver` and having the build
step install the dependency or by explicitly running

```bash
go get go.mongodb.org/mongo-driver/v2/mongo
```

When using a version of Go that does not support modules, the driver can be installed using `dep` by running

```bash
dep ensure -add "go.mongodb.org/mongo-driver/v2/mongo"
```

## Usage

To get started with the driver, import the `mongo` package and create a `mongo.Client` with the `Connect` function:

```go
import (
    "context"
    "time"

    "go.mongodb.org/mongo-driver/v2/mongo"
    "go.mongodb.org/mongo-driver/v2/mongo/options"
    "go.mongodb.org/mongo-driver/v2/mongo/readpref"
)

client, _ := mongo.Connect(options.Client().ApplyURI("mongodb://localhost:27017"))
```

Make sure to defer a call to `Disconnect` after instantiating your client:

```go
defer func() {
    if err = client.Disconnect(ctx); err != nil {
        panic(err)
    }
}()
```

For more advanced configuration and authentication, see the [documentation for mongo.Connect](https://pkg.go.dev/go.mongodb.org/mongo-driver/v2/mongo#Connect).

Calling `Connect` does not block for server discovery. If you wish to know if a MongoDB server has been found and connected to,
use the `Ping` method:

```go
ctx, cancel = context.WithTimeout(context.Background(), 2*time.Second)
defer cancel()

_ = client.Ping(ctx, readpref.Primary())
```

To insert a document into a collection, first retrieve a `Database` and then `Collection` instance from the `Client`:

```go
collection := client.Database("testing").Collection("numbers")
```

The `Collection` instance can then be used to insert documents:

```go
ctx, cancel = context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

res, _ := collection.InsertOne(ctx, bson.D{{"name", "pi"}, {"value", 3.14159}})
id := res.InsertedID
```

To use `bson.D`, you will need to add `"go.mongodb.org/mongo-driver/v2/bson"` to your imports.

Your import statement should now look like this:

```go
import (
    "context"
    "log"
    "time"

    "go.mongodb.org/mongo-driver/v2/bson"
    "go.mongodb.org/mongo-driver/v2/mongo"
    "go.mongodb.org/mongo-driver/v2/mongo/options"
    "go.mongodb.org/mongo-driver/v2/mongo/readpref"
)
```

Several query methods return a cursor, which can be used like this:

```go
ctx, cancel = context.WithTimeout(context.Background(), 30*time.Second)
defer cancel()

cur, err := collection.Find(ctx, bson.D{})
if err != nil {
  log.Fatal(err)
}

defer cur.Close(ctx)
for cur.Next(ctx) {
    var result bson.D
    if err := cur.Decode(&result); err != nil {
      log.Fatal(err)
    }

    // do something with result....
}

if err := cur.Err(); err != nil {
    log.Fatal(err)
}
```

For methods that return a single item, a `SingleResult` instance is returned:

```go
var result struct {
    Value float64
}

filter := bson.D{{"name", "pi"}}
ctx, cancel = context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

err = collection.FindOne(ctx, filter).Decode(&result)
if errors.Is(err, mongo.ErrNoDocuments) {
    // Do something when no record was found
} else if err != nil {
    log.Fatal(err)
}

// Do something with result...
```

Additional examples and documentation can be found under the examples directory and [on the MongoDB Documentation website](https://www.mongodb.com/docs/drivers/go/current/).

### Network Compression

Network compression will reduce bandwidth requirements between MongoDB and the application.

The Go Driver supports the following compression algorithms:

1. [Snappy](https://google.github.io/snappy/) (`snappy`): available in MongoDB 3.4 and later.
1. [Zlib](https://zlib.net/) (`zlib`): available in MongoDB 3.6 and later.
1. [Zstandard](https://github.com/facebook/zstd/) (`zstd`): available in MongoDB 4.2 and later.

#### Specify Compression Algorithms

Compression can be enabled using the `compressors` parameter on the connection string or by using [`ClientOptions.SetCompressors`](https://pkg.go.dev/go.mongodb.org/mongo-driver/mongo/options#ClientOptions.SetCompressors):

```go
opts := options.Client().ApplyURI("mongodb://localhost:27017/?compressors=snappy,zlib,zstd")
client, _ := mongo.Connect(opts)
```

```go
opts := options.Client().SetCompressors([]string{"snappy", "zlib", "zstd"})
client, _ := mongo.Connect(opts)
```

If compressors are set, the Go Driver negotiates with the server to select the first common compressor. For server configuration and defaults, refer to [`networkMessageCompressors`](https://www.mongodb.com/docs/manual/reference/program/mongod/#std-option-mongod.--networkMessageCompressors).

Messages compress when both parties enable network compression; otherwise, messages remain uncompressed.
