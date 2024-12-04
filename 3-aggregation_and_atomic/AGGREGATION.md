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

- **$group** groups the documents by userId and calculates the total number of orders for each user.
- **$sort** sorts the results by the totalOrders field in descending order.

### 2.2 Example: Filtering and Grouping

This example filters orders with a total amount greater than 100, groups them by userId, and calculates the average amount.

```js
db.orders.aggregate([
  { $match: { amount: { $gt: 100 } } },
  { $group: { _id: "$userId", avgAmount: { $avg: "$amount" } } }
]);
```

- **$match** filters documents where the `amount` is greater than 100.
- **$group** calculates the average `amount` for each user.

## 3. Common Aggregation Operators

### 3.1 **$match**

The `$match` stage filters documents based on the specified query conditions. It is similar to the find query but is used within the aggregation pipeline.

```js
{ $match: { status: "shipped" } }
```

### 3.2 **$group**

The `$group` stage groups documents by a specified field and applies aggregation functions. Common aggregation functions include:

- `$sum`: Calculates the sum of a field.
- `$avg`: Calculates the average of a field.
- `$min`: Finds the minimum value.
- `$max`: Finds the maximum value.
- `$push`: Adds a value to an array.

Example:

```js
{ $group: { _id: "$category", totalAmount: { $sum: "$amount" } } }
```

### 3.3 **$sort**

The `$sort` stage sorts the documents in either ascending or descending order based on a specified field.

```javascript
{ $sort: { amount: -1 } }  // Sort by amount in descending order
```

### 3.4 **$project**

The `$project` stage reshapes the documents. You can include, exclude, or rename fields.

```javascript
{ $project: { name: 1, totalAmount: { $multiply: ["$quantity", "$price"] } } }
```

### 3.5 **$limit** and **$skip**

`$limit` limits the number of documents passed to the next stage.
`$skip` skips the specified number of documents.

```javascript
{ $limit: 5 }
{ $skip: 10 }
```

### 3.6 **$unwind**

The `$unwind` stage deconstructs an array into individual documents. Each document contains one element from the array.

```javascript
{ $unwind: "$items" }
```

## 4. Aggregation Example with Multiple Stages

This example demonstrates a more complex aggregation pipeline to calculate the total sales per category, filter out categories with less than $1000 in total sales, and sort by the total sales in descending order.

```javascript
db.sales.aggregate([
  { $unwind: "$items" },
  { $group: { _id: "$items.category", totalSales: { $sum: "$items.amount" } } },
  { $match: { totalSales: { $gt: 1000 } } },
  { $sort: { totalSales: -1 } }
]);
```

- **$unwind** deconstructs the items array into individual documents.
- **$group** calculates the total sales by category.
- **$match** filters categories with total sales greater than 1000.
- **$sort** sorts the result by totalSales in descending order.

## 5. Aggregation with Lookup (Joins)

The `$lookup` stage allows you to join documents from another collection, similar to SQL JOIN.

```javascript
db.orders.aggregate([
  { $lookup: {
      from: "users",
      localField: "userId",
      foreignField: "_id",
      as: "userDetails"
  }}
]);
```

- **$lookup** joins documents from the users collection where userId in orders matches the _id in users.

## Conclusion

MongoDB’s aggregation framework is a powerful tool that enables complex data transformations and computations within the database itself. By using stages like `$match`, `$group`, `$sort`, `$project`, and `others`, you can perform a wide range of operations to summarize and manipulate data. Understanding the aggregation pipeline and its operators is essential for working with large datasets and performing advanced analytics in MongoDB.
