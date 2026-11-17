within AnomalyLibrary.Signals;
block IntermittentLoss "Apply periodic dropout intervals to a real signal"
  parameter Boolean enabled = true "Enable the anomaly";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "Inclusive start of the event window";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "Exclusive end of the event window";
  Modelica.Blocks.Interfaces.BooleanOutput active "The enabled event window contains the current time" annotation(Placement(transformation(extent={{94,42},{106,54}}), iconTransformation(extent={{94,42},{106,54}})));
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  parameter Modelica.Units.SI.Time period(min=Modelica.Constants.small) = 0.5 "Repetition period of the dropout cycle";
  parameter Real lossFraction(min=0,max=1) = 0.2 "Fraction at the start of each cycle during which the signal is lost";
  parameter Real fallback = 0 "Value supplied during each loss interval";
  Modelica.Blocks.Interfaces.BooleanOutput valid "The current output is transmitted from u rather than a fallback" annotation(Placement(transformation(extent={{94,-54},{106,-42}}), iconTransformation(extent={{94,-54},{106,-42}})));
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime) "Fixed half-open activation window";
initial equation
  assert(period > 0 and lossFraction >= 0 and lossFraction <= 1, "Invalid loss cycle.");
equation
  active = eventWindow.active;
  valid = not (active and mod(time-eventStartTime, period) < period*lossFraction);
  y = if valid then u else fallback;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-58,24},{-43,24},{-43,-30},{-24,-30},{-24,24},{-4,24},{-4,-30},{15,-30},{15,24},{35,24},{35,-30},{53,-30},{53,24},{63,24}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="on / off", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="IntermittentLoss")}),
    Documentation(info="<html><p>Within the event window, the first <code>lossFraction</code> of each <code>period</code> transmits <code>fallback</code> and sets <code>valid=false</code>. The cycle is referenced to <code>eventStartTime</code>; the remaining part of each cycle transmits the current input. Fractions zero and one give no dropout and continuous dropout, respectively.</p><p>The effect is enabled by default over <code>[eventStartTime,eventEndTime)</code>. Set <code>enabled=false</code> for direct transmission throughout the simulation. This interface has no external trigger or severity parameter.</p></html>"));
end IntermittentLoss;
