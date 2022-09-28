resource "kafka-connect_connector" "orders" {
  name = "orders"

  config = {
    "connector.class" = "io.confluent.kafka.connect.datagen.DatagenConnector"
    "key.converter"   = "org.apache.kafka.connect.storage.StringConverter"
    "value.converter" : "org.apache.kafka.connect.json.JsonConverter"
    "kafka.topic"  = "orders"
    "max.interval" = 30000
    "quickstart"   = "orders"
    "tasks.max"    = 1
    "name"         = "orders"
  }
}

resource "kafka-connect_connector" "fleet_mgmt_sensors" {
  name = "fleet_mgmt"

  config = {
    "connector.class" = "io.confluent.kafka.connect.datagen.DatagenConnector"
    "key.converter"   = "org.apache.kafka.connect.storage.StringConverter"
    "kafka.topic"     = "fleet_mgmt_sensors"
    "max.interval"    = 30000
    "quickstart"      = "fleet_mgmt_sensors"
    "tasks.max"       = 1
    "name"            = "fleet_mgmt"
  }
}
