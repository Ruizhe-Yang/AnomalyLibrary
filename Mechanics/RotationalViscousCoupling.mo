within AnomalyLibrary.Mechanics;
model RotationalViscousCoupling "Additional rotational viscous coupling"
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

  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a "First rotational flange" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b "Second rotational flange" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Real displacement(unit="rad") "Angle of flange_b relative to flange_a";
  Real relativeSpeed(unit="rad/s") "Relative angular velocity";
  Real effort(unit="N.m") "Torque entering flange_b";
  Modelica.Units.SI.Power lossPower "Power dissipated by damping";
  parameter Real d(min=0,unit="N.m.s/rad")=1 "Viscous damping coefficient";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(d>=0,"Negative damping.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  displacement=flange_b.phi-flange_a.phi;
  relativeSpeed=der(displacement);
  flange_b.tau=effort;
  flange_a.tau=-effort;
  effort=d*effectLevel*relativeSpeed;
  lossPower=effort*relativeSpeed;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-43,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{11,0},{100,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-43,-30},{-43,30},{28,30}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-43,-30},{28,-30}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{11,-24},{11,24}}, color={64,64,64}, thickness=1.5, pattern=LinePattern.Solid),
        Line(points={{-20,49},{-5,66},{22,62},{36,46}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-28,-39},{26,-65}}, textString="d", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The torque entering <code>flange_b</code> is <code>d*effectLevel*der(flange_b.phi-flange_a.phi)</code>, with equal and opposite torque at <code>flange_a</code>. The coupling dissipates <code>d*effectLevel*relativeSpeed^2</code> and applies no torque at zero effect. It introduces neither stiffness nor inertia.</p><p>Connect the two rotational flanges and set the damping coefficient d. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">MechanicalImpulseAndContact</a> for connections.</p></html>"));
end RotationalViscousCoupling;
