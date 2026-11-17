within AnomalyLibrary;
package Utilities "Shared types and implementation helpers"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-45.08,-48.76},{20.24,18.4}}, color={128,128,128}, thickness=11, pattern=LinePattern.Solid),
        Polygon(points={{-0.92,21.16},{0,44.16},{17.48,59.8},{34.04,63.48},{23,38.64},{38.64,23},{62.56,34.04},{58.88,15.64},{43.24,0.92},{20.24,0},{-0.92,21.16}}, lineColor={128,128,128}, fillColor={128,128,128}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5)
      }));
  annotation(Documentation(info="<html><p>Types and internal helpers used by the public anomaly components. <code>Types</code> defines frame policies; <code>Internal</code> provides activation and finite-queue implementations.</p></html>"));
end Utilities;
