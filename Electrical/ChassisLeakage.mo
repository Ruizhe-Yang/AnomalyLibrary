within AnomalyLibrary.Electrical;
model ChassisLeakage "Additional conductance to a chassis connection"
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
  Modelica.Electrical.Analog.Interfaces.NegativePin chassis "Electrical chassis connection" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

  Modelica.Units.SI.Voltage v "Voltage from p to chassis";
  Modelica.Units.SI.Current i "Current entering pin p";
  Modelica.Units.SI.Power lossPower "Electrical power dissipated in the branch";
  parameter Modelica.Units.SI.Conductance G_fault(min=0)=0.01 "Conductance at full effect";

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(G_fault>=0,"Negative leakage conductance.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  v=p.v-chassis.v;
  i=p.i;
  chassis.i=-i;
  i=G_fault*effectLevel*v;
  lossPower=v*i;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-36,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-36,-17},{36,17}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{36,0},{100,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-26,-12},{26,15}}, textString="G", textColor={0,0,127}, fontSize=0),
        Line(points={{58,-13},{58,-45},{30,-45}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{30,-37},{21,-53}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{43,-37},{34,-53}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{56,-37},{47,-53}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The leakage current is <code>G_fault*effectLevel*(p.v-chassis.v)</code>. The two pins carry equal and opposite currents. The component supplies no ground reference and has zero branch current at zero effect; connect <code>chassis</code> explicitly. Dissipation is available as <code>lossPower</code>.</p><p>Connect p to the affected node and chassis to the intended electrical return. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">ElectricalDisturbances</a> for connections.</p></html>"));
end ChassisLeakage;
