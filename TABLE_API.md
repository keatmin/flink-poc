## Table API
### Table environments
- TableEnvironment is responsible for:
1. Registering a table in the internal catalog
2. Registering catalogs
3. Loading pluggable modules
4. Executing SQL queries
5. Registering user defined function
6. Converting between Datastream and Table

A table is always bound to a TableEnvironment

### Tables in catalog
- TableEnvironment maintains a map of catalogs of tables which are created with an identifier; an identifier consists of 3 parts, catalog name, database name and object name. Default value will be used if catalog and database is not specified.
- Views can be created from existing Table object, usually a result of Table API or SQL. Table describes external data.

#### Perm vs Temp
- Table can be temporary and tied to a lifecycle of a single Flink session or permanent across multiple Flink sessions and clusters.
- Permanent table requires a catalog.
