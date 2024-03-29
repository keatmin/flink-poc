# Flink
## Datastream vs Table API
- Table API is an API that unifies both batch and stream
- Datastream is an API to implement stream processing application

## Latency vs completeness
- WATERMARK is a way Apache Flink is using to set a limit on how long to wait for an event. The trade-off with this compared to a batch is batch gets the completeness of data in the specific time. Watermark is assertion that stream is complete up to time t. Anything later than t is late data.
- Small t for watermark means possibly wrong result(incomplete), produced quickly.

## time
There are 3 types of time attributes:
- event time -> Time the event is produced, event time processing would yield completely consistent and deterministic results in a perfect world, there will be a latency when events are out of order
- processing time -> when an operator start processing the event, based on the clock of the machine. (in distributed and asynchronous environments processing time does not provide determinism)
- ingestion time -> timestamp recorded by Flink when it ingested the data

Watermarks are generated by each parallel subtask independently.
## Windows
There are 3 types of window that Flink supports:
- Tumbling - page views per minute
- Sliding - page views per minute computed every 10s
- Session - page views per session where sessions are computed by a gap of at least 30 minutes per session.

All can use event time or processing time, however using processing time have the limitations of:
- can not correctly process historic data
- can not correctly handle out-of-order data
- results will be non-deterministic

## Stateful Stream Processing
### Barriers
- Flink inserts a stream barrier that flows with the stream. It determines which data should be in the current snapshot or not.
- When there is more than 1 parallel stream, operator waits for both barrier of snapshot n to arrive before creating a snapshot and emitting barrier to output.
### snapshot
- Snapshot is stored in configurable state backend. By default, Job Manager's memory but a distributed one should be used in prd.

## Gotchas
- Flink window can only be called on time attribute column, defined either using WATERMARK or processing time attribute using proc AS PROCTIME()
- Need print connector to print to stdout
- Need to learn what set_parallelism does
- Time window is aligned to epoch, one hour window means window will close on the dot even if the app started at 1:05
