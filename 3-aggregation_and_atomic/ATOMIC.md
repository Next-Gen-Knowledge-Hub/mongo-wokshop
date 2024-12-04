# Update Atomic Operations & Delete

MongoDB provides `atomic` operations for modifying documents. These operations ensure that updates to documents are consistent, meaning that they either completely succeed or fail without leaving the document in an intermediate state. This feature is crucial for applications where data integrity and consistency are critical, especially in scenarios where multiple processes may attempt to update the same document at the same time.


**Atomicity in MongoDB**:

- In MongoDB, atomic operations are guaranteed on a single document level. This means that even if multiple clients are trying to update the same document, each operation will complete successfully, or no operation will be performed at all.

**Update Operations**:

- MongoDB provides several update operators to perform atomic updates on documents. These operators can modify fields, add new ones, remove existing ones, or perform other transformations.

## 1. Document Update

### 1.1 Modify by replacement

```js
db.users.update({_id: user_id}, new-doc);
```

This operation will rewrite the document with given id.

### 1.2 Modify an specific field

```js
db.users.update({_id: user_id}, {$set: {email: "user-new-email"}});
```

Update the email field of user document.

### 1.3 Compare both methods

The replacement approach, as before, fetches the user document from the server, modifies it, and then resends it. The update statement here is similar to the one you used to update the email address. By contrast, the targeted update uses a different update operator, $inc, to increment the value in total_reviews.

## 2. Update with Multiple Operators

MongoDB allows combining multiple update operators in a single update statement.

```javascript
db.users.updateOne(
  { _id: 1 },
  {
    $set: { name: "John" },
    $inc: { age: 1 },
    $push: { friends: "Sarah" }
  }
);
```

In this example:

- The `name` field is updated to "John".
- The `age` field is incremented by 1.
- A new value "Sarah" is `added` to the `friends array`.

## 3. Update with Conditions (Conditional Updates)

You can apply update operations conditionally based on the current value of a field. For example, using the `$setOnInsert` operator for an upsert operation or `$min` and `$max` to set a field only if the new value is greater or less than the existing one.

Example with `$min`:

```javascript
db.users.updateOne(
  { _id: 1 },
  { $min: { score: 50 } }  // Only updates if the current score is greater than 50
);
```

Example with `$setOnInsert`:

```javascript
db.users.updateOne(
  { _id: 1 },
  { 
    $setOnInsert: { name: "New User" },  // Only if the document does not exist
    $set: { lastUpdated: new Date() }
  },
  { upsert: true }  // If no document matches, a new document is created
);
```

## 4. Bulk Write Operations

For performance reasons, MongoDB allows multiple update operations to be executed in a single batch. The `bulkWrite()` method allows you to execute multiple operations (insert, update, delete) at once.

Example:

```javascript
db.users.bulkWrite([
  { updateOne: { filter: { _id: 1 }, update: { $set: { name: "John" } } } },
  { updateOne: { filter: { _id: 2 }, update: { $inc: { age: 1 } } } },
  { updateMany: { filter: { status: "inactive" }, update: { $set: { status: "active" } } } }
]);
```

This example updates multiple documents in one go:

- Sets the `name` of the user with `_id: 1` to "John".
- Increments the `age` of the user with `_id: 2`.
- Updates the `status` field of all users with status: `"inactive"` to `"active"`.

## 5. Transactions for Multi-Document Updates

MongoDB 4.0+ supports multi-document `transactions`, ensuring atomicity across multiple documents and collections. These transactions can be used to guarantee that updates to `multiple` documents or `collections` are either fully `committed` or fully `rolled back`.

Example:

```javascript
const session = client.startSession();

try {
  session.startTransaction();

  db.users.updateOne({ _id: 1 }, { $set: { name: "Alice" } }, { session });
  db.accounts.updateOne({ _id: 1 }, { $inc: { balance: 100 } }, { session });

  session.commitTransaction();
} catch (error) {
  session.abortTransaction();
} finally {
  session.endSession();
}
```

In this example:

- A `transaction` is started with `startSession()`.
- The `users` and `accounts` collections are updated as part of the same transaction.
- If any operation fails, the transaction is aborted using `abortTransaction()`, ensuring atomicity.

## 6. Delete in Transactions

If you're performing a `multi-document` or `multi-collection` delete operation and need to guarantee that either all operations succeed or none are applied, you can use a transaction.

Example: Delete in `Transaction`

```javascript
const session = client.startSession();

try {
  session.startTransaction();

  db.orders.deleteOne({ _id: 1 }, { session });
  db.users.deleteOne({ _id: 1 }, { session });

  session.commitTransaction();
} catch (error) {
  session.abortTransaction();
} finally {
  session.endSession();
}
```

This example deletes a `document` from both `orders` and `users` collections within a single transaction. If any operation fails, the transaction is aborted, and no changes are made.

## Conclusion

MongoDB’s atomic update operations ensure that changes to documents are safe and consistent. Whether you are performing a simple update or a complex multi-document transaction, MongoDB provides several options to guarantee the integrity of your data. Understanding these atomic update operations is critical for building robust and reliable applications with MongoDB.
