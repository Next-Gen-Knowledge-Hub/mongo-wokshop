package query_and_indexing

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

type MongoClient struct {
	client     *mongo.Client
	database   string
	collection string
}

func NewClient() *MongoClient {
	uri := "mongodb://127.0.0.1:27017"
	client, err := mongo.Connect(options.Client().ApplyURI(uri))
	if err != nil {
		panic(err)
	}

	c := MongoClient{
		client:     client,
		database:   "r&d",
		collection: "users",
	}

	ctx, cf := context.WithTimeout(context.TODO(), time.Second)
	defer cf()

	err = client.Ping(ctx, nil)
	if err != nil {
		panic(err)
	}

	return &c
}

func (c *MongoClient) GetUsers(ctx context.Context) ([]bson.M, error) {
	resaults := make([]bson.M, 0)
	curser, err := c.client.Database(c.database).Collection(c.collection).Find(ctx, bson.D{{}})
	if err != nil {
		return nil, err
	}

	defer curser.Close(context.Background())

	for curser.Next(ctx) {
		resault := bson.M{}
		err = curser.Decode(&resault)
		if err != nil {
			return nil, err
		}

		resaults = append(resaults, resault)
	}

	if err = curser.Err(); err != nil {
		return nil, err
	}

	return resaults, nil
}
