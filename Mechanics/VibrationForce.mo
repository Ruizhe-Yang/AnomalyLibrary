within AnomalyLibrary.Mechanics;
model VibrationForce "Sinusoidal external force during a scheduled interval"
  parameter Boolean enabled = true "Enable the configured disturbance";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "Inclusive start of the event interval";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "Exclusive end of the event interval";
  Modelica.Blocks.Interfaces.BooleanOutput active "The scheduled vibration interval is active" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Modelica.Units.SI.Force amplitude = 10 "Amplitude of the sinusoidal applied force";
  parameter Modelica.Units.SI.Frequency frequency(min=0) = 10 "Sinusoidal frequency";
  Modelica.Mechanics.Translational.Interfaces.Flange_b flange "Driven translational flange" annotation(Placement(transformation(extent={{-7,-107},{7,-93}}), iconTransformation(extent={{-7,-107},{7,-93}})));
  Modelica.Blocks.Interfaces.RealOutput appliedForce(unit="N") "Force applied along the positive flange coordinate" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
protected
  Modelica.Mechanics.Translational.Sources.Force source "Ideal prescribed force source";
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime) "Scheduled event interval";
initial equation
  assert(frequency >= 0, "Frequency must be nonnegative.");
equation
  active = eventWindow.active;
  appliedForce = if active then amplitude*sin(2*Modelica.Constants.pi*frequency*(time-eventStartTime)) else 0;
  source.f = appliedForce;
  connect(source.flange, flange);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-37,-36},{37,25}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Line(points={{0,-36},{0,-100}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-48,-47},{48,-47}}, color={160,160,164}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-62,57},{-58.9,61.94},{-55.8,66.4},{-52.7,69.94},{-49.6,72.22},{-46.5,73},{-43.4,72.22},{-40.3,69.94},{-37.2,66.4},{-34.1,61.94},{-31,57},{-27.9,52.06},{-24.8,47.6},{-21.7,44.06},{-18.6,41.78},{-15.5,41},{-12.4,41.78},{-9.3,44.06},{-6.2,47.6},{-3.1,52.06},{0,57},{3.1,61.94},{6.2,66.4},{9.3,69.94},{12.4,72.22},{15.5,73},{18.6,72.22},{21.7,69.94},{24.8,66.4},{27.9,61.94},{31,57},{34.1,52.06},{37.2,47.6},{40.3,44.06},{43.4,41.78},{46.5,41},{49.6,41.78},{52.7,44.06},{55.8,47.6},{58.9,52.06},{62,57}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-29,-17},{29,15}}, textString="F(t)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="VibrationForce")}),
    Documentation(info="<html><p>With <code>enabled=true</code>, the applied force is <code>amplitude*sin(2*pi*frequency*(time-eventStartTime))</code> during <code>[eventStartTime,eventEndTime)</code> and zero otherwise. The phase starts at the scheduled event boundary. There is no activation ramp, so termination away from a zero crossing causes a force step. <code>appliedForce</code> is positive along the flange coordinate.</p><p>Connect flange to a translational body and set amplitude, frequency and the event interval.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">MechanicalImpulseAndContact</a> for connections.</p></html>"));
end VibrationForce;
