within AnomalyLibrary.Signals;
block NoiseInjection "Add an externally supplied disturbance to a real signal"
  parameter Boolean enabled = true "Enable the anomaly";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "Inclusive start of the event window";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "Exclusive end of the event window";
  Modelica.Blocks.Interfaces.BooleanOutput active "The enabled event window contains the current time" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  parameter Real gain = 1 "Dimensionless disturbance multiplier";
  Modelica.Blocks.Interfaces.RealInput noise "Externally supplied disturbance in the input signal unit" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime) "Fixed half-open activation window";
equation
  active = eventWindow.active;
  y = u + (if active then gain*noise else 0);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{14,-28},{62,20}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{25,-4},{51,-4}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{38,-17},{38,9}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-64,-4},{14,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-61,39},{-53,50},{-44,27},{-36,44},{-27,22},{-18,40},{-7,34},{0,52},{9,37},{38,37},{38,20}}, color={0,0,255}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{62,-4},{74,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="u + noise", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="NoiseInjection")}),
    Documentation(info="<html><p>The active output is <code>y = u + gain*noise</code>. The <code>noise</code> input must use the same unit as <code>u</code>. The block does not generate random samples; reproducibility is determined by the supplied disturbance sequence.</p><p>The effect is enabled by default over <code>[eventStartTime,eventEndTime)</code>. Set <code>enabled=false</code> for direct transmission throughout the simulation. This interface has no external trigger or severity parameter.</p></html>"));
end NoiseInjection;
