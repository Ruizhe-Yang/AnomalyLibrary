within AnomalyLibrary.Signals;
block PolarityReversal "Reverse the sign of a real signal within an event window"
  parameter Boolean enabled = true "Enable the anomaly";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "Inclusive start of the event window";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "Exclusive end of the event window";
  Modelica.Blocks.Interfaces.BooleanOutput active "The enabled event window contains the current time" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime) "Fixed half-open activation window";
equation
  active = eventWindow.active;
  y = if active then -u else u;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,0},{68,0}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{0,-55},{0,58}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-53,43},{53,-43}}, color={0,0,255}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{25,25},{65,56}}, textString="-1", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="PolarityReversal")}),
    Documentation(info="<html><p>The output is <code>-u</code> during the active event window and <code>u</code> otherwise. Switching changes the signal sign instantaneously without changing its unit.</p><p>The effect is enabled by default over <code>[eventStartTime,eventEndTime)</code>. Set <code>enabled=false</code> for direct transmission throughout the simulation. This interface has no external trigger or severity parameter.</p></html>"));
end PolarityReversal;
