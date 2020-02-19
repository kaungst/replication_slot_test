# Replication Slot Test

## Overview

We are trying to test what happens when a replication slot is lost and how devs generally
handle DR in this case. 

Build the `omada_kafka_connect_dev` image:

    $ ./refresh_image.sh

Start up Connect and its related containers:

    $ docker-compose up -d

* `omada-kafka-connect_connect_*` is our Connect container.
* `omada-kafka-connect_dummy_app_db_*` represents a source DB that we want to stream data from.

Use the following script to register a debezium connector, set up a table `public.test_table1`, a topic `dummy_app.public.test_table1`, and an initial row:

    $ ./run.sh script/reset.sh

In a separate consumer tab we can confirm the changes have been streamed

    $ ./run.sh kafka-avro-console-consumer --bootstrap-server broker:9092 --property schema.registry.url=http://schema-registry:8081 --topic dummy_app.public.test_table1 --from-beginning

Next we stop the Connect cluster and restart the 

    $ docker-compose stop connect

In a separate postgres tab, confirm the replication slot is still there, drop it, confirm it's gone, then insert a new row.

    $ docker-compose exec dummy_app_db psql -U postgres
    postgres=#\c dummy_app_dev;
    dummy_app_dev=#select * from pg_replication_slots; 
    dummy_app_dev=#select pg_drop_replication_slot('debezium');
    dummy_app_dev=#select * from pg_replication_slots; 
    dummy_app_dev=#INSERT INTO test_table1 (col1) VALUES ('second record');

Restart the connect service. Note, this will cause the first record to be reconsumed b/c the replication slot is recreated. We believe this is default behavior for debezium

    $ docker-compose up -d

After about 10 - 15 seconds you should see the replication slot registered in the postgres tab.

    dummy_app_dev=#select * from pg_replication_slots;

You'll see the message didn't make it into the consumer tab (no 'second record');

If you insert another row in the postgres tabl you'll see it in the consumer tab.

    dummy_app_dev=#INSERT INTO dummy_app_db.test_table1 (col1) VALUES ('third record');


We understand this is a failure mode that's cautioned against in the debezium docs:
- https://debezium.io/documentation/reference/1.0/connectors/postgresql.html#when-things-go-wrong

There doesn't seem to be much guidance on how to handle the issue and we're wondering if/how others
work around it.

Cleanup == `docker-compose down -v`
