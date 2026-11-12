within AnomalyLibrary.Mechanics;
model CompliantRelease "Reduce a rotational flexible connection toward explicit residual coefficients"
parameter Boolean enabled=false;
  parameter Boolean useExternalTrigger=false;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time startTime=1;
  parameter Modelica.Units.SI.Time endTime=2;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05;
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active;
  output Real effectLevel;
  output Integer activationCount;

  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Real displacement(unit="rad");
  Real relativeSpeed(unit="rad/s");
  Real effort(unit="N.m");
  Modelica.Units.SI.Power lossPower;

  parameter Real k(min=0,unit="N.m/rad")=100;
  parameter Real d(min=0,unit="N.m.s/rad")=1;
  parameter Real residualK(min=0,unit="N.m/rad")=0.1;
  parameter Real residualD(min=0,unit="N.m.s/rad")=0.01;
  Real kEffective(unit="N.m/rad");
  Real dEffective(unit="N.m.s/rad");
  Modelica.Units.SI.Energy storedEnergy;
  Modelica.Units.SI.Power parameterPower;
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

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
    Documentation(info="<html><p><b>Purpose</b> Reduce a rotational flexible connection toward explicit residual coefficients.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a; Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Real k(min=0,unit=\"N.m/rad\")=100; parameter Real d(min=0,unit=\"N.m.s/rad\")=1; parameter Real residualK(min=0,unit=\"N.m/rad\")=0.1; parameter Real residualD(min=0,unit=\"N.m.s/rad\")=0.01</p><p><b>Behavior</b> Reduce a rotational flexible connection toward explicit residual coefficients</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. The nominal reference is the same flexible connection at k and d. The parameter-power channel accounts for changing stiffness.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">AnomalyLibrary.Examples.MechanicalImpulseAndContact</a></p></html>"));
end CompliantRelease;
