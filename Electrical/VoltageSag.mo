within AnomalyLibrary.Electrical;
model VoltageSag "Series voltage drop proportional to an independent reference"
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
  parameter Real depth(min=0,max=1)=0.25 "Fraction of vReference imposed as a series voltage drop";
  Modelica.Units.SI.Power externalPower "Signed power supplied to the connected system";
  Modelica.Blocks.Interfaces.RealInput vReference(unit="V") "Independent reference supply voltage" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(depth>=0 and depth<=1,"Sag depth outside [0,1].");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  v=p.v-n.v;
  i=p.i;
  n.i=-i;
  v=depth*effectLevel*vReference;
  lossPower=0;
  externalPower=-v*i;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-45,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-45,-44},{45,44}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{45,0},{100,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-34,16},{-19,16},{-8,-15},{15,-15},{25,16},{35,16}}, color={191,0,0}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-32,52},{32,76}}, textString="ref", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The imposed drop is <code>p.v-n.v=depth*effectLevel*vReference</code>, with <code>depth</code> between zero and one. Use a feed-forward nominal supply reference to define the intended sag. Zero effect gives zero series drop. The ideal source exchanges power with the circuit, reported by <code>externalPower</code>.</p><p>Insert p and n in series and supply an independent nominal voltage to vReference. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">ElectricalDisturbances</a> for connections.</p></html>"));
end VoltageSag;
