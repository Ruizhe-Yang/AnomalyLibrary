within AnomalyLibrary.Mechanics;
model CompliantRelease "Reduction of a rotational connection to residual stiffness and damping"
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

  parameter Real k(min=0,unit="N.m/rad")=100 "Nominal torsional stiffness";
  parameter Real d(min=0,unit="N.m.s/rad")=1 "Nominal torsional damping coefficient";
  parameter Real residualK(min=0,unit="N.m/rad")=0.1 "Torsional stiffness at full effect";
  parameter Real residualD(min=0,unit="N.m.s/rad")=0.01 "Torsional damping coefficient at full effect";
  Real kEffective(unit="N.m/rad") "Current torsional stiffness";
  Real dEffective(unit="N.m.s/rad") "Current torsional damping coefficient";
  Modelica.Units.SI.Energy storedEnergy "Elastic energy in the current compliant connection";
  Modelica.Units.SI.Power parameterPower "Power associated with changing stiffness";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(k>=residualK and residualK>=0 and d>=residualD and residualD>=0,"Invalid residual compliance.");
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

  kEffective=(1-effectLevel)*k+effectLevel*residualK;
  dEffective=(1-effectLevel)*d+effectLevel*residualD;
  effort=kEffective*displacement+dEffective*relativeSpeed;
  lossPower=dEffective*relativeSpeed^2;
  storedEnergy=0.5*kEffective*displacement^2;
  parameterPower=der(storedEnergy)-effort*relativeSpeed+lossPower;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-65,0},{-65,27},{-44,27}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-44,27},{-34,42},{-20,12},{-6,42},{8,12},{22,42},{34,27},{65,27},{65,0},{100,0}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-65,0},{-65,-29},{-33,-29}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-33,-47},{-33,-12},{18,-12}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-33,-47},{18,-47}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{3,-41},{3,-18}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{3,-29},{65,-29},{65,0}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-36,57},{36,81}}, textString="k,d", textColor={64,64,64}, fontSize=0),
        Line(points={{43,75},{43,49}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The model interpolates stiffness from <code>k</code> to <code>residualK</code> and damping from <code>d</code> to <code>residualD</code> using <code>effectLevel</code>. Zero effect retains the nominal spring-damper connection. <code>storedEnergy</code>, <code>lossPower</code> and <code>parameterPower</code> distinguish elastic storage, damping loss and the power associated with changing stiffness.</p><p>Use the model as the nominal flexible connection, then set residualK and residualD for release. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">MechanicalImpulseAndContact</a> for connections.</p></html>"));
end CompliantRelease;
