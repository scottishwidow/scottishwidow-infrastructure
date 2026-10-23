# 19. The Sensor holds no long-lived AWS credential

Date: 2026-10-23

## Status

Accepted

## Context

The Sensor must write telemetry to the Corpus. It is the one Honeynet host with a
public IPv4, and it sits at the edge of a hostile network. An IAM user access key
on it would be lasting access to the account if it leaked.

AWS Private CA costs USD 400 each month in general-purpose mode. IAM Roles
Anywhere is free, and it accepts an external certificate bundle as a trust anchor.

## Decision

IAM Roles Anywhere issues short-lived credentials to the Sensor. The trust anchor
is an external, self-signed CA. The Operator generates the CA private key on the
workstation, and it stays there. The Sensor holds only its own certificate and
private key. Ansible places them, owned by root and not readable by all.

The PKI is new each time the Honeynet is provisioned. ADR-0012 does the same for
the OpenVPN PKI. The trust anchor certificate is therefore an input to the
`corpus` root that changes each cycle. The `corpus` root is applied each
provisioning, although it is never destroyed.

The role permits `s3:PutObject` and `s3:AbortMultipartUpload` on the Corpus prefix.
It permits nothing else. The Vector S3 sink healthcheck is disabled, because that
healthcheck needs `s3:ListBucket`. That permission would let a compromised Sensor
read which days and which sources hold data.

The role trust policy is conditioned on `aws:SourceIp`. The value is the Sensor
public IPv4. There is no CRL. To revoke, disable the Roles Anywhere profile.

## Consequences

- A stolen certificate is inert away from the Sensor address. A TLS session cannot
  spoof its source address.
- The condition is in the trust policy and not in the permission policy. A request
  from another address fails at `CreateSession`, and the verification run asserts
  that failure.
- Nothing on the Sensor renews the certificate. The Sensor has no signing key and
  no credential before it has a valid certificate. Reissue is an Operator step in
  `make configure`.
- Certificate expiry stops shipping with no error anywhere. The verification run
  asserts the validity that is left.
- The CA generation step must come before the `corpus` apply in each provisioning.
- If the Sensor public IPv4 changes, shipping stops. The address is a primary IP in
  the `bootstrap` root with `delete_protection = true`, following ADR-0009.
