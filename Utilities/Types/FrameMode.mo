within AnomalyLibrary.Utilities.Types;
type FrameMode = enumeration(Drop,Delay,Reorder,Duplicate,Timestamp,Throttle,Corrupt,Outage,Replay) "Deterministic frame policy" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-64,66},{64,-2}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-67,-29},{67,-65}}, textString="FRAME", textColor={255,255,255}, fontSize=0)
      }));
