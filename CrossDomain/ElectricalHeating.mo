within AnomalyLibrary.CrossDomain;
model ElectricalHeating "Additional electrical dissipation transferred to a thermal port"
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
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort "Thermal connection for electrical dissipation" annotation(Placement(transformation(origin={0,-100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,-100},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Voltage v "Voltage from p to n";
  Modelica.Units.SI.Current i "Current entering pin p";
  Modelica.Units.SI.Power lossPower "Electrical power dissipated in the branch";
  parameter Modelica.Units.SI.Resistance R(min=0)=10 "Resistance of the added heating branch at full effect";

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(R>0,"Heating resistance must be positive.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  v=p.v-n.v;
  i=p.i;
  n.i=-i;
  i=effectLevel*v/R;
  lossPower=v*i;
  heatPort.Q_flow=-lossPower;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-36,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-36,-17},{36,17}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{36,0},{100,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-27,-12},{27,13}}, textString="R", textColor={0,0,127}, fontSize=0),
        Line(points={{-15,-31},{-15,-61}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{15,-31},{15,-61}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{0,-65},{0,-100}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The electrical branch draws <code>i=effectLevel*(p.v-n.v)/R</code>. Its dissipated power <code>lossPower=v*i</code> is transferred unchanged through <code>heatPort.Q_flow=-lossPower</code>. At zero effect both the additional electrical current and thermal flow are zero. The model has no internal electrical or thermal storage.</p><p>Connect p and n as a parallel branch and connect heatPort to the receiving thermal network. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.CrossDomainEffects\">CrossDomainEffects</a> for connections.</p></html>"));
end ElectricalHeating;
