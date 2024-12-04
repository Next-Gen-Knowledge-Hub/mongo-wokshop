# Query Performance Comparison: Without Index vs. With Index

This document illustrates the performance difference of a MongoDB query executed without an index and after creating an index, using the `explain()` method.

---
## Example Dataset

Assume the following `products` collection:

```json
{ "_id": 1, "name": "Laptop", "category": "Electronics", "price": 1200 }
{ "_id": 2, "name": "Headphones", "category": "Electronics", "price": 150 }
{ "_id": 3, "name": "Coffee Mug", "category": "Kitchenware", "price": 10 }
```

---
## Query Without Index

We query for all products with `Electronics` cateogry.

```js
db.products.find({ category: "Electronics" }).explain("executionStats");
```

### Output Without Indexing

```json
{
  "queryPlanner": {
    "plannerVersion": 1,
    "namespace": "test.products",
    "indexFilterSet": false,
    "parsedQuery": { "category": { "$eq": "Electronics" } },
    "winningPlan": {
      "stage": "COLLSCAN",
      "filter": { "category": { "$eq": "Electronics" } },
      "direction": "forward"
    },
    "rejectedPlans": []
  },
  "executionStats": {
    "executionSuccess": true,
    "nReturned": 2,
    "executionTimeMillis": 10,
    "totalKeysExamined": 0,
    "totalDocsExamined": 3
  }
}
```

### Observations
- _Stage_: `COLLSCAN` sann all of the documents.
- _Document Examined_: The entire collection.
- _Execution Time_: High time because of scanning all of the collection.

---
## Creating An Index

We create and index on `category` field.

```js
db.products.createIndex({ category: 1 });
```

## Query After Indexing

```js
db.products.find({ category: "Electronics" }).explain("executionStats");
```

### Output With Indexing

```json
{
  "queryPlanner": {
    "plannerVersion": 1,
    "namespace": "test.products",
    "indexFilterSet": false,
    "parsedQuery": { "category": { "$eq": "Electronics" } },
    "winningPlan": {
      "stage": "IXSCAN",
      "keyPattern": { "category": 1 },
      "indexName": "category_1",
      "direction": "forward",
      "indexBounds": { "category": ["[\"Electronics\", \"Electronics\"]"] }
    },
    "rejectedPlans": []
  },
  "executionStats": {
    "executionSuccess": true,
    "nReturned": 2,
    "executionTimeMillis": 1,
    "totalKeysExamined": 2,
    "totalDocsExamined": 2
  }
}
```

### Observations
- _Stage_: `IXSCAN` sann with using index.
- _Key Examined_: Number of keys examined on `index` field.
- _Execution Time_: Very low because of using `index`.
- _Docs Examined_: Number of documents examined for query.

---
# Comparison Table: Query Performance (Without Index vs. With Index)

| **Metric**             | **Without Index (COLLSCAN)** | **With Index (IXSCAN)** |
|------------------------|------------------------------|--------------------------|
| **Execution Time**     | 10ms                        | 1ms                     |
| **Keys Examined**      | 0                           | 2                       |
| **Documents Examined** | 3                           | 2                       |
| **Query Stage**        | `COLLSCAN`                  | `IXSCAN`                |

