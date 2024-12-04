# MongoDB Query Cheat Sheet

| **Query Type**         | **Query Syntax**                                                                                     | **Example**                                                                                         |
|-------------------------|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| **Switch Database**     | `use <database_name>`                                                                              | `use my_database`                                                                                  |
| **Show Collections**    | `show collections`                                                                                 | N/A                                                                                                 |
| **Insert One**          | `db.<collection>.insertOne({<field>: <value>, ...})`                                               | `db.users.insertOne({name: "John", age: 30})`                                                      |
| **Insert Many**         | `db.<collection>.insertMany([{<field>: <value>, ...}, {...}])`                                      | `db.users.insertMany([{name: "Alice"}, {name: "Bob"}])`                                            |
| **Find All Documents**  | `db.<collection>.find()`                                                                           | `db.users.find()`                                                                                   |
| **Find with Filter**    | `db.<collection>.find({<field>: <value>, ...})`                                                    | `db.users.find({age: 30})`                                                                          |
| **Projection**          | `db.<collection>.find({}, {<field>: 1, <field>: 0})`                                               | `db.users.find({}, {name: 1, _id: 0})`                                                             |
| **Find One Document**   | `db.<collection>.findOne({<field>: <value>})`                                                      | `db.users.findOne({name: "Alice"})`                                                                |
| **Update One**          | `db.<collection>.updateOne({<filter>}, {$<operator>: {<field>: <value>, ...}})`                     | `db.users.updateOne({name: "John"}, {$set: {age: 31}})`                                            |
| **Update Many**         | `db.<collection>.updateMany({<filter>}, {$<operator>: {<field>: <value>, ...}})`                    | `db.users.updateMany({age: {$gt: 25}}, {$set: {status: "senior"}})`                                |
| **Delete One**          | `db.<collection>.deleteOne({<field>: <value>})`                                                    | `db.users.deleteOne({name: "Bob"})`                                                                |
| **Delete Many**         | `db.<collection>.deleteMany({<field>: <value>, ...})`                                              | `db.users.deleteMany({age: {$lt: 20}})`                                                            |
| **Create Index**        | `db.<collection>.createIndex({<field>: 1})`                                                        | `db.users.createIndex({age: 1})`                                                                   |
| **Aggregation**         | `db.<collection>.aggregate([<stages>])`                                                            | `db.users.aggregate([{ $group: { _id: "$status", total: { $sum: 1 } } }])`                         |
| **Count Documents**     | `db.<collection>.countDocuments({<filter>})`                                                       | `db.users.countDocuments({status: "active"})`                                                      |
| **Distinct Values**     | `db.<collection>.distinct(<field>, {<filter>})`                                                    | `db.users.distinct("status")`                                                                      |
| **Rename Collection**   | `db.<collection>.renameCollection(<new_name>)`                                                     | `db.users.renameCollection("app_users")`                                                           |
| **Drop Collection**     | `db.<collection>.drop()`                                                                           | `db.users.drop()`                                                                                  |
| **Backup Database**     | Use `mongodump` command                                                                            | `mongodump --db=my_database --out=/path/to/backup`                                                 |
| **Restore Database**    | Use `mongorestore` command                                                                         | `mongorestore --db=my_database /path/to/backup/my_database`                                        |
| **Text Search**         | Create index: `db.<collection>.createIndex({<field>: "text"})`, Query: `$text: { $search: <text>}` | `db.articles.find({ $text: { $search: "mongodb tutorial" } })`                                     |
| **Transaction**         | Use session: `db.getMongo().startSession()`                                                        | See detailed transaction example below.                                                           |

---

## Transaction Example in MongoDB Shell
```javascript
// Start a session
session = db.getMongo().startSession()
session.startTransaction()

try {
    session.getDatabase("my_database").users.insertOne({ name: "Transactional User" })
    session.commitTransaction()
} catch (e) {
    session.abortTransaction()
    print("Transaction aborted: " + e)
} finally {
    session.endSession()
}
```

## Basic Text Search
Inorder to use following queries you have to define text index first on given collection to have better query timing.

```js
db.products.find({ $text: { $search: "laptop" } });
db.products.find({ $text: { $search: "laptop \"gamind\"" } }); // means gaming must be in document
db.products.find({ $text: { $search: "\"gaming laptop\"" } }); // exact phrase
db.products.find({ $text: { $search: "laptop -gaming" } }); // laptop but not gaming
db.products.find({ $text: { $search: "laptop desktop" } }); // search for laptop or desktop
```

Inorder to search document and sort them with document relevant score use followign query the text search score provides a number that rates the relevancy of the document based on how many times the word appeared in the document.

```js
db.products.find({ $text: { $search: "laptop" } }, { score: { $meta: "textScore" } }).sort({ score: { $meta: "textScore" } });
```

## Additional Notes
- Mongodb shell used `javascrypt` allowing you to write loops and ocnditions and etc.
- Remember to use index to perform queries in better time, but keep in mind that indexing also have a cost.

## How drivers work
- Object-id generation process are done in driver-side instead of server-side inorder to prevent bottomleck on adding _id field into database collections. uniquness are guaranteed in the context of driver.

This table provides a concise yet comprehensive reference for MongoDB shell commands and includes examples of their usage.
