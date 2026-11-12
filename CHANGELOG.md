# Changelog

## 0.3.0

- Rename `AbnormalEventLibrary` to `AnomalyLibrary`.
- Move signals, frame policies and physical interventions into their functional domains.
- Add the common trigger, bounded frame queue and independent source/reception identity.
- Retire old overlapping demonstration entrances.

### Migration

- Wire optional trigger only when useExternalTrigger is true. Use enabled explicitly when inserting an anomaly into a nominal host.
- Frame policies use txCount with source sequence and time. Configure FrameDropout.dropSequences for an explicit old burst sequence. Read a new reception on rxCount changes.
