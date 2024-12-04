package query_and_indexing

import (
	"context"
	"testing"
)

func Test_NewClient(t *testing.T) {
	c := NewClient()
	t.Log(c)

	users, err := c.GetUsers(context.TODO())
	if err != nil {
		t.Error(err)
	}

	for _, u := range users {
		t.Log(u)
	}
}
