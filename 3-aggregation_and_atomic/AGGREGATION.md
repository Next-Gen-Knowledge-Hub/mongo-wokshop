# MongoDB Aggregation Framework

The MongoDB Aggregation Framework is a powerful tool for performing advanced data processing and transformation within MongoDB. It allows you to perform operations like filtering, grouping, sorting, reshaping documents, and performing calculations within the database, all within a single query.

## 1. Aggregation Basics

Aggregation operations process data records and return computed results. They are used to summarize, analyze, and transform data from the database. The aggregation framework processes data in stages, where each stage performs a specific operation on the data.

### 1.1 Key Stages in Aggregation

Each aggregation pipeline consists of multiple stages, where the output of one stage is passed as input to the next stage. Common stages in the aggregation pipeline include:

- **$match**: Filters the documents based on a condition (similar to `find`).
- **$group**: Groups the documents by a specified identifier and performs aggregation functions (e.g., sum, average).
- **$sort**: Sorts the documents by a specific field.
- **$project**: Shapes the documents by adding, removing, or renaming fields.
- **$limit**: Limits the number of documents returned.
- **$skip**: Skips a number of documents.
- **$unwind**: Deconstructs an array field from the documents and creates a new document for each element in the array.

## 2. Aggregation Pipeline

An aggregation pipeline is an ordered list of stages. Each stage applies an operation to the documents and passes the result to the next stage in the pipeline.

### 2.1 Example: Simple Aggregation Pipeline

This example finds the total number of orders placed by each user and sorts the result by the total number of orders.

```javascript
db.orders.aggregate([
  { $group: { _id: "$userId", totalOrders: { $sum: 1 } } },
  { $sort: { totalOrders: -1 } }
]);
```