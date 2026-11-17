within AnomalyLibrary.Signals;
block Spike "Add a triangular pulse over a specified event window"
  parameter Boolean enabled = true "Enable the anomaly";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "Inclusive start of the event window";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "Exclusive end of the event window";
  Modelica.Blocks.Interfaces.BooleanOutput active "The enabled event window contains the current time" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  parameter Real amplitude = 1 "Signed disturbance amplitude in the input signal unit";
protected
  Real phase "Fractional position within the event window";
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime) "Fixed half-open activation window";
equation
  active = eventWindow.active;
  phase = (time-eventStartTime)/(eventEndTime-eventStartTime);
  y = u + (if active then amplitude*(1 - abs(2*phase-1)) else 0);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-58,-21},{-18,-21},{0,48},{18,-21},{61,-21}}, color={191,0,0}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="pulse", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="Spike")}),
    Documentation(info="<html><p>The added disturbance rises linearly from zero at <code>eventStartTime</code> to <code>amplitude</code> at the window midpoint, then falls to zero at <code>eventEndTime</code>. The endpoints must be strictly ordered.</p><p>The effect is enabled by default over <code>[eventStartTime,eventEndTime)</code>. Set <code>enabled=false</code> for direct transmission throughout the simulation. This interface has no external trigger or severity parameter.</p></html>"));
end Spike;
