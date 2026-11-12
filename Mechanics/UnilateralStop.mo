within AnomalyLibrary.Mechanics;
model UnilateralStop "Finite one-sided stop"
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

  Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Real displacement(unit="m");
  Real relativeSpeed(unit="m/s");
  Real effort(unit="N");
  Modelica.Units.SI.Power lossPower;

  parameter Modelica.Units.SI.Position gap(min=0)=0.01;
  parameter Real k(min=0,unit="N/m")=1000;
  parameter Real d(min=0,unit="N.s/m")=10;
  parameter Modelica.Units.SI.Length smoothingLength(min=0)=0.001;
  Real penetration(unit="m");
  Real reaction(unit="N");
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

initial equation
  assert(gap>=0 and k>=0 and d>=0 and smoothingLength>0,"Invalid contact coefficients.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  displacement=flange_b.s-flange_a.s;
  relativeSpeed=der(displacement);
  flange_b.f=effort;
  flange_a.f=-effort;

  penetration=max(0,displacement-gap);
  reaction=effectLevel*(k*penetration+d*penetration/(smoothingLength+penetration)*max(0,relativeSpeed));
  effort=reaction;
  lossPower=effectLevel*d*penetration/(smoothingLength+penetration)*max(0,relativeSpeed)^2;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-42,0}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Rectangle(extent={{-42,-30},{-8,30}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Line(points={{28,-48},{28,48}}, color={64,64,64}, thickness=2, pattern=LinePattern.Solid),
        Line(points={{28,0},{100,0}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{28,-43},{46,-29}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{28,-22},{46,-8}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{28,-1},{46,13}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{28,20},{46,34}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-6,56},{26,56}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-8,57},{28,80}}, textString="s", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Finite one-sided stop.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a; Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Modelica.Units.SI.Position gap(min=0)=0.01; parameter Real k(min=0,unit=\"N/m\")=1000; parameter Real d(min=0,unit=\"N.s/m\")=10; parameter Modelica.Units.SI.Length smoothingLength(min=0)=0.001</p><p><b>Behavior</b> Finite one-sided stop</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. Compressive forces vanish continuously at the gap. High-impact contacts require a validated contact stiffness and timestep.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">AnomalyLibrary.Examples.MechanicalImpulseAndContact</a></p></html>"));
end UnilateralStop;
