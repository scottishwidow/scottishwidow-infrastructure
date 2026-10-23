# 18. The Corpus is an S3 bucket in the shared AWS account

Date: 2026-10-23

## Status

Accepted

## Context

The Honeynet keeps Suricata telemetry on the Sensor for 14 days. A Sensor
replacement deletes it. Threat hunting needs telemetry that outlives the host
that produced it, and that holds months and not days.

Hetzner Object Storage was an option. The `hcloud` provider has no resource for
it. Its S3 keys come only from the console. It costs a flat EUR 4.99 each month.
The same volume in S3 costs about USD 1 each month.

This estate has one AWS account. It also holds Nextcloud and the Terraform state
buckets. A dedicated account is the correct boundary for hostile telemetry. It is
more work than this change can carry.

The Hunt Host reads the Corpus. It parses content that an attacker controls.

## Decision

The Corpus is an S3 bucket in the existing AWS account, in `eu-central-1`. IAM is
the boundary between the Corpus and the other workloads in that account. There is
no account boundary. This is an accepted risk.

The Hunt Host gets its own VPC. It shares no network with Nextcloud. The reason is
trust separation, not cost.

`live/aws/honeynet/` is a logical environment inside the shared account. It is not
an account. The provider-first directory convention gives the path its shape.

## Consequences

- An IAM mistake in that account can expose the Corpus. No account boundary stops
  it.
- Hostile content is parsed in the same account as Nextcloud. The VPC boundary
  separates the hosts. It does not separate the account.
- A reader of the path `live/aws/honeynet/` could believe that a `honeynet` AWS
  account exists. `CONTEXT-MAP.md` records that it does not.
- A move to a dedicated account is tracked as its own issue. To move, replace this
  decision.
