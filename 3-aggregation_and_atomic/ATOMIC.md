# Update Atomic Operations & Delete

MongoDB provides `atomic` operations for modifying documents. These operations ensure that updates to documents are consistent, meaning that they either completely succeed or fail without leaving the document in an intermediate state. This feature is crucial for applications where data integrity and consistency are critical, especially in scenarios where multiple processes may attempt to update the same document at the same time.

**Key Concepts**

- 1. Atomicity in MongoDB:

- In MongoDB, atomic operations are guaranteed on a single document level. This means that even if multiple clients are trying to update the same document, each operation will complete successfully, or no operation will be performed at all.

- 2. Update Operations:

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

