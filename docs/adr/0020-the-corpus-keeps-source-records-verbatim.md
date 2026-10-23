# 20. The Corpus keeps source records verbatim and normalises at query time

Date: 2026-10-23

## Status

Accepted

## Context

A transform in a shipping pipeline is a decision about which fields matter. The
pipeline makes it before the hunt that needs them. A field that the pipeline drops
is lost for all 13 months.

Suricata `eve.json` holds nine event types with different shapes. A schema that is
inferred from a sample finds a field in one month and misses it in another, and
types change across the Corpus.

## Decision

No record's bytes are rewritten, and no field is dropped. The pipeline may read a
field to choose a partition. It may not change the record. The partition date `dt`
is therefore the event time and not the ingest time.

Partitions are `source=<suricata|cowrie|opencanary>/host=<host>/dt=<YYYY-MM-DD>`.
The scheme is the same for all three sources. Records are gzip NDJSON.

Each line is read into one `JSON` column. Normalising SQL views extract the fields
and cast the types. The views live in this repository. The Hunt Host Ansible
deploys them at each provisioning.

The join contract is `src_ip`, `src_port` and a window of 5 seconds. The Sensor
DNAT rewrites only the destination, so the attacker source address and port reach
the Honeypot.

The join needs synchronised clocks. Containment stops a Honeypot from reaching any
time source on the internet. Chrony on the Sensor serves time to the Honeynet
range. The verification run asserts a skew below 1 second. The join window is at
least five times the asserted skew.

## Consequences

- A field that nobody kept is still in the object. A later view can read it.
- A view that is rewritten after a hunt re-runs across all 13 months.
- Schema inference is not used, so a field that appears in one month only does not
  change the schema.
- A Honeypot that buffers for two days files its evidence under the event date. A
  seasonal comparison is not skewed by outage history.
- A 13-month query must prune by `dt`, or aggregate as it streams. A materialising
  13-month join does not complete on the Hunt Host, because gzip is not splittable
  and the host has 4 GB.
- `event_type` is not a partition key. About 20 GB across 13 months is about 50 MB
  for each day, so `dt` prunes enough. Add `event_type` with Parquet compaction, if
  hunts get slow.
