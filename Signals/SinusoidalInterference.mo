within AnomalyLibrary.Signals;
block SinusoidalInterference "Add sinusoidal interference within an event window"
  parameter Boolean enabled = true "Enable the anomaly";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "Inclusive start of the event window";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "Exclusive end of the event window";
  Modelica.Blocks.Interfaces.BooleanOutput active "The enabled event window contains the current time" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  parameter Real amplitude = 0.1 "Signed disturbance amplitude in the input signal unit";
  parameter Modelica.Units.SI.Frequency frequency(min=0) = 5 "Interference frequency in hertz";
  parameter Modelica.Units.SI.Angle phase = 0 "Phase angle at eventStartTime in radians";
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime) "Fixed half-open activation window";
initial equation
  assert(frequency >= 0, "Frequency must be nonnegative.");
equation
  active = eventWindow.active;
  y = u + (if active then amplitude*sin(2*Modelica.Constants.pi*frequency*(time-eventStartTime)+phase) else 0);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-66,28},{-64.25,32.2},{-62.5,36.17},{-60.75,39.69},{-59,42.56},{-57.25,44.63},{-55.5,45.78},{-53.75,45.94},{-52,45.12},{-50.25,43.35},{-48.5,40.73},{-46.75,37.4},{-45,33.56},{-43.25,29.41},{-41.5,25.18},{-39.75,21.11},{-38,17.42},{-36.25,14.31},{-34.5,11.96},{-32.75,10.5},{-31,10},{-29.25,10.5},{-27.5,11.96},{-25.75,14.31},{-24,17.42},{-22.25,21.11},{-20.5,25.18},{-18.75,29.41},{-17,33.56},{-15.25,37.4},{-13.5,40.73},{-11.75,43.35},{-10,45.12},{-8.25,45.94},{-6.5,45.78},{-4.75,44.63},{-3,42.56},{-1.25,39.69},{0.5,36.17},{2.25,32.2},{4,28}}, color={0,0,255}, thickness=1.2, pattern=LinePattern.Solid),
        Ellipse(extent={{17,-26},{61,18}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{28,-4},{50,-4}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{39,-15},{39,7}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{4,28},{39,28},{39,18}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-65,-4},{17,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{61,-4},{74,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="u + sin", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="SinusoidalInterference")}),
    Documentation(info="<html><p>The active disturbance is <code>amplitude*sin(2*pi*frequency*(time-eventStartTime) + phase)</code>. The signed amplitude uses the input unit, frequency is in hertz and phase is in radians. A non-zero phase can produce a step when the window opens or closes.</p><p>The effect is enabled by default over <code>[eventStartTime,eventEndTime)</code>. Set <code>enabled=false</code> for direct transmission throughout the simulation. This interface has no external trigger or severity parameter.</p></html>"));
end SinusoidalInterference;
