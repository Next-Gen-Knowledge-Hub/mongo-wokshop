## WiredTiger And Plugable Storages

### 1. Plugable Storage Engine Api

A storage engine is an interface between the database and the hardware. A storage engine doesn't change how you perform your queries in the shell or in the driver, and it doesn't interfere with MongoDB at the cluster level.

### 2. Comparission With MMAPv1

Feature/Aspect            | WiredTiger                                | MMAPv1
--------------------------|-------------------------------------------|---------------------------------------------
Concurrency               | Document-level locking, high concurrency. | Global or collection-level locking, limited concurrency.
Compression               | Supports Snappy and zlib compression.     | No compression, higher disk usage.
Performance               | Optimized for mixed read/write workloads. | Better for read-heavy workloads, struggles with writes.
Write Efficiency          | Uses a write-ahead log (WAL) for durability. | Writes directly to memory-mapped files.
Crash Recovery            | Faster recovery using journaling.         | Slower recovery using journaling.
Storage Format            | Efficient B-tree-like structure.          | Memory-mapped files, less efficient.
Use of Memory             | Configurable cache for efficient use.     | Relies on OS virtual memory for caching.
Maximum Document Size     | 16 MB (default, same as MMAPv1).           | 16 MB (default).
Indexing                  | Compressed indexes for smaller sizes.     | Uncompressed indexes, more storage usage.
Data Durability           | Durable by default with journaling.       | Less durable; slower recovery.
Parallelism               | High parallelism with finer-grained locking. | Limited due to global or collection-level locking.
Compatibility             | Default since MongoDB 3.2.                | Deprecated as of MongoDB 4.0.
Use Cases                 | Best for high concurrency and modern workloads. | Suitable for legacy or simple, read-heavy applications.
Configuration Options     | Highly tunable (cache size, compression). | Limited options.
Disk Space Usage          | Lower, due to compression.                | Higher, no compression.
Scalability               | Scales well with multi-core processors.   | Struggles in write-heavy environments.
