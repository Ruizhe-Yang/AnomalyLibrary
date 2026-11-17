within AnomalyLibrary.Utilities.Types;
type FrameMode = enumeration(Drop,Delay,Reorder,Duplicate,Timestamp,Throttle,Corrupt,Outage,Replay) "Deterministic frame-processing policy" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-64,66},{64,-2}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-67,-29},{67,-65}}, textString="FRAME", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p>Select the policy applied by <code>Utilities.Internal.FrameQueue</code>: <code>Drop</code>, <code>Delay</code>, <code>Reorder</code>, <code>Duplicate</code>, <code>Timestamp</code>, <code>Throttle</code>, <code>Corrupt</code>, <code>Outage</code> or <code>Replay</code>.</p><p>The policy acts only during activation. Each mode uses the queue parameters relevant to that operation.</p></html>"));
