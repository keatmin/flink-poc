resource "kafka-connect_connector" "web_traffic" {
  name = "datagen"

  config = {
    "connector.class" = "io.confluent.kafka.connect.datagen.DatagenConnector"
    "key.converter"   = "org.apache.kafka.connect.storage.StringConverter"
    "kafka.topic"     = "ratings"
    "max.interval"    = 30000
    "quickstart"      = "ratings"
    "tasks.max"       = 1
    "name"            = "datagen"
  }
}
