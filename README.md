# AnomalyLibrary

## Name and purpose

Deterministic anomalies in signals, messages and physical interfaces.

## Scope and non-goals

Deterministic signal, frame, physical-path and boundary disturbances. Observables report the injected effect.

## Requirements

- Modelica Standard Library 4.0.0.
- Tested with OpenModelica 1.25.5 (64-bit), DASSL and relative tolerance 1e-6. 9/9 default examples completed in the recorded runs.
- Other Modelica tools are compatibility targets pending separate verification.

## Installation

Extract the source tree, load Modelica 4.0.0, then open `AnomalyLibrary/package.mo`. Confirm the Modelica version in your tool. Open an example from the package tree and use its declared experiment settings.

## Package structure

```text
AnomalyLibrary/
    UsersGuide/
    Signals/
    Communication/
    Electrical/
    Thermal/
    Mechanics/
    Fluid/
    CrossDomain/
    Utilities/
    Examples/
```

The model catalog lists each class, its interfaces, an example and its recorded validation level.

## Core concepts and usage

- For a serial insertion, connect the original source to u and y to the consumer. Attach a physical branch using its declared domain connectors.
- Set enabled, [startTime,endTime) and severity, or connect the optional trigger. Distinguish active from effectLevel.
- Publish one txCount increment per source frame with sequence, payload, sourceTime and validity. Use rxCount changes to identify received frames. Inspect overflow, droppedCount and availability.

## Examples

| Example | Stop time (s) | Purpose | Suggested observables |
|---|---:|---|---|
| SignalDeviationAndRecovery | 4 | Compare offset, capture and gain on the same ramp | biasValue, freezeValue, gainValue, each active and effectLevel. |
| UnsafeCommandPatterns | 4 | Apply independent omission, spurious, timing and duration operations | The four output edges and pulse lengths. Inspect effectActive after the triggering window closes. |
| DeterministicCommunication | 4 | Compare four independent frame policies on a shared service grid | Each rxCount, receivedSequence, receivedSourceTime, droppedCount and overflow. |
| ElectricalDisturbances | 4 | Separate a parallel conductance from a series voltage disturbance | extraPath.i, extraPath.lossPower, seriesRipple.v and rippleLoad.i. |
| ThermalPulseAndEnvironment | 5 | Compare a prescribed heat pulse with distinct finite environmental boundaries | pulse.injectedEnergy, pulseBody.T, ambient.heatFlow and radiation.heatFlow. |
| MechanicalImpulseAndContact | 5 | Measure free-body impulse responses and an independent compression stop | forceBody.v, torqueBody.w and contact.reaction. |
| FluidPathDisturbances | 5 | Open a parallel path between two explicit fluid boundaries | mainPath.port_a.m_flow, extraPath.massFlow and each stream enthalpy. |
| CrossDomainEffects | 5 | Route electrical loss to heat and a pressure signal to prescribed force | heater.lossPower, body.T and force.applied. |
| CombinedAnomalies | 6 | Route the same ramp through serial and direct paths | modified, nominal and the three active signals. |

## Limitations and numerical assumptions

- Frame service is finite and deterministic. One queued frame may be received per service instant.
- Physical branches need the declared reference, external boundary or return path. An external energy boundary may supply energy.
- Removing a reversible disturbance restores its nominal relation while the host retains its evolved state.

## Version and license

Version 0.3.0. See LICENSE for the terms supplied with the original source.
