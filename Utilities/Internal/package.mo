within AnomalyLibrary.Utilities;
package Internal "Internal activation and frame-processing helpers"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-50.6,-50.6},{50.6,50.6}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-31.28,-31.28},{31.28,31.28}}, color={128,128,128}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-31.28,31.28},{31.28,-31.28}}, color={128,128,128}, thickness=1.2, pattern=LinePattern.Solid)
      }));
  annotation(Documentation(info="<html><p>Implementation helpers for activation ramps, event intervals and deterministic frame processing. Use the public anomaly components when assembling a model; the helpers expose the lower-level state and queue behaviour used by those components.</p></html>"));
end Internal;
