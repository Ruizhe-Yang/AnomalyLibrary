within AnomalyLibrary.Electrical;
model SupplyRipple "Sinusoidal series voltage disturbance"
parameter Boolean enabled=false "Enable the configured disturbance";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the scheduled time window";
  parameter Real severity(min=0,max=1)=1 "Multiplier applied to the activation envelope";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the scheduled activation window";
  parameter Modelica.Units.SI.Time endTime=2 "Exclusive end of the scheduled activation window";
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05 "Duration of a full-scale activation or recovery ramp";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Activation request state";
  output Real effectLevel "Severity scaled activation envelope";
  output Integer activationCount "Number of activation starts";

  Modelica.Electrical.Analog.Interfaces.PositivePin p "Positive electrical pin" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative electrical pin" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

  Modelica.Units.SI.Voltage v "Voltage from p to n";
  Modelica.Units.SI.Current i "Current entering pin p";
  Modelica.Units.SI.Power lossPower "Declared internal dissipation, zero for this ideal source";

  parameter Modelica.Units.SI.Voltage amplitude(min=0)=1 "Amplitude of the sinusoidal voltage drop at full effect";
  parameter Modelica.Units.SI.Frequency frequency(min=0)=10 "Sinusoidal frequency";
  parameter Modelica.Units.SI.Angle phase=0 "Carrier phase at startTime";
  Modelica.Units.SI.Power externalPower "Signed power supplied to the connected system";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(frequency>=0 and amplitude>=0,"Invalid ripple parameters.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  v=p.v-n.v;
  i=p.i;
  n.i=-i;
  v=effectLevel*amplitude*sin(2*Modelica.Constants.pi*frequency*(time-startTime)+phase);
  lossPower=0;
  externalPower=-v*i;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-42,0}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Ellipse(extent={{-42,-42},{42,42}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{42,0},{100,0}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-30,0},{-28.5,2.82},{-27,5.56},{-25.5,8.17},{-24,10.58},{-22.5,12.73},{-21,14.56},{-19.5,16.04},{-18,17.12},{-16.5,17.78},{-15,18},{-13.5,17.78},{-12,17.12},{-10.5,16.04},{-9,14.56},{-7.5,12.73},{-6,10.58},{-4.5,8.17},{-3,5.56},{-1.5,2.82},{0,0},{1.5,-2.82},{3,-5.56},{4.5,-8.17},{6,-10.58},{7.5,-12.73},{9,-14.56},{10.5,-16.04},{12,-17.12},{13.5,-17.78},{15,-18},{16.5,-17.78},{18,-17.12},{19.5,-16.04},{21,-14.56},{22.5,-12.73},{24,-10.58},{25.5,-8.17},{27,-5.56},{28.5,-2.82},{30,0}}, color={0,0,255}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="~ V", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The voltage drop is <code>effectLevel*amplitude*sin(2*pi*frequency*(time-startTime)+phase)</code>. The carrier phase remains referenced to <code>startTime</code>, including when an external trigger is used. A finite or partial-cycle activation need not have zero mean. <code>externalPower</code> reports the ideal source power exchange.</p><p>Insert the source in series and set amplitude, frequency and phase. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">ElectricalDisturbances</a> for connections.</p></html>"));
end SupplyRipple;
