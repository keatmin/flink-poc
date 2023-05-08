## Job Manager
### Application Mode
- Can be started with `standalone-job` argument when starting a task Manager
- Jar files have to be included with the image if this is the case

### Session Mode
- Can be started when jobmanager `cmd` is added

## Task Manager



## Cluster configuration


## Hudi
- Seems to be the best format that works well with Flink. It's jvm.
- Needs a hudi-flink-bundle jar, would require testing with Table API
- Doesn't need a standalone client


## Apache Beam
- Uses flink runner to run unified transform
- Might not play well with Hudi yet. Might need a separate I/O connector that is maintained by the community
- Requires a client to send job to flink-master
- This is tempting as pyflink, is not very well documented and documentation can be messy.
- Beam supports Python and Golang but might not have full support depending on the language
