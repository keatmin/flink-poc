"""main"""
import os

from pyflink.datastream import StreamExecutionEnvironment
from pyflink.table import EnvironmentSettings
from pyflink.table import StreamTableEnvironment


def main():
    """main"""
    env = StreamExecutionEnvironment.get_execution_environment()
    env.set_parallelism(1)
    settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    tbl_env = StreamTableEnvironment.create(
        stream_execution_environment=env, environment_settings=settings
    )
    kafka_jar = os.path.join(
        os.path.abspath(os.path.dirname(__file__)),
        "flink-sql-connector-kafka-1.15.2.jar",
    )
    # jar to read confluent-avro
    avro_jar = os.path.join(
        os.path.abspath(os.path.dirname(__file__)),
        "flink-sql-avro-confluent-registry-1.15.2.jar",
    )
    tbl_env.get_config().get_configuration().set_string(
        "pipeline.jars", f"file://{kafka_jar};file://{avro_jar}"
    )

    fleet_mgmt = """
        CREATE TABLE fleet_mgmt (
            vehicle_id INT,
            engine_temperature INT,
            average_rpm INT,
            record_time TIMESTAMP(3) METADATA from 'timestamp',
            WATERMARK FOR record_time AS record_time - INTERVAL '5' SECONDS
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'fleet_mgmt_sensors',
            'properties.bootstrap.servers' = 'localhost:9092',
            'properties.group.id' = 'fleet_mgmt_sensors',
            'scan.startup.mode' = 'latest-offset',
            'value.format' = 'avro-confluent',
            'value.avro-confluent.url' = 'http://localhost:8081'
        )
    """
    tbl_env.execute_sql(fleet_mgmt)
    fleet_mgmt = tbl_env.from_path("fleet_mgmt")
    print("Created fleet_mgmt table")
    # Print table to print data into stdout
    print_table = """
        CREATE TABLE sink (
            window_end TIMESTAMP(3),
            number_of_vehicles BIGINT) WITH
            ('connector' = 'print')
            """
    tbl_env.execute_sql(print_table)
    print("Created sink")

    sql = """
        SELECT
          TUMBLE_END(record_time, INTERVAL '5' SECONDS) AS window_end,
          count(distinct vehicle_id) AS number_of_vehicles
        FROM fleet_mgmt
        GROUP BY
          TUMBLE(record_time, INTERVAL '5' SECONDS)
    """
    wdw = tbl_env.sql_query(sql)
    print("Executing insert")
    wdw.execute_insert("sink").wait()


if __name__ == "__main__":
    main()
