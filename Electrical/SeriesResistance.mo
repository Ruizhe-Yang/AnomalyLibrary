within AnomalyLibrary.Electrical;
model SeriesResistance "Additional series resistance with optional heat transfer"
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
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if useHeatPort "Thermal connection for electrical dissipation" annotation(Placement(transformation(origin={0,-100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,-100},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Voltage v "Voltage from p to n";
  Modelica.Units.SI.Current i "Current entering pin p";
  Modelica.Units.SI.Power lossPower "Electrical power dissipated in the branch";

  parameter Modelica.Units.SI.Resistance R_add(min=0)=1 "Series resistance at full effect";
  parameter Boolean useHeatPort=false "Expose a thermal port for electrical dissipation";

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(R_add>=0,"Negative added resistance.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  v=p.v-n.v;
  i=p.i;
  n.i=-i;
  v=R_add*effectLevel*i;
  lossPower=v*i;
  if useHeatPort then heatPort.Q_flow=-lossPower; end if;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-36,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-36,-17},{36,17}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{36,0},{100,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-32,-11},{32,14}}, textString="R+", textColor={0,0,127}, fontSize=0),
        Line(points={{-11,-34},{-11,-54}}, color={191,0,0}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{11,-34},{11,-54}}, color={191,0,0}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The voltage drop is <code>R_add*effectLevel*i</code>, so the zero-effect relation is an ideal electrical connection. <code>lossPower=v*i</code> reports Joule dissipation. With <code>useHeatPort=true</code>, the same power leaves the component through <code>heatPort</code>; otherwise the loss is reported without a thermal connection.</p><p>Insert p and n in series; enable useHeatPort to connect the dissipation to a thermal network. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">ElectricalDisturbances</a> for connections.</p></html>"));
end SeriesResistance;
