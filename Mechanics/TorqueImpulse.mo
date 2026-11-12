within AnomalyLibrary.Mechanics;
model TorqueImpulse "Deliver a finite rectangular angular impulse"
parameter Boolean enabled=false;
  parameter Boolean useExternalTrigger=false;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time startTime=1;
  final parameter Modelica.Units.SI.Time endTime=startTime+duration;
  final parameter Modelica.Units.SI.Time transitionTime=0;
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active;
  output Real effectLevel;
  output Integer activationCount;

  parameter Boolean useSupport=false;
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Support support if useSupport annotation(Placement(transformation(origin={0,-100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,-100},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Torque applied;
  Modelica.Units.SI.Power externalPower;
  parameter Real angularImpulse(unit="N.m.s")=0.2;
  parameter Modelica.Units.SI.Time duration(min=0)=0.1;


protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);
  Modelica.Units.SI.Angle reference;
  discrete Modelica.Units.SI.Time began(start=0,fixed=true);
  discrete Boolean seen(start=false,fixed=true);
initial equation
  assert(duration>0,"Torque impulse needs a positive duration.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  when {initial(),active} then began=time; seen=active; end when;

  applied=(if seen and time<began+duration then angularImpulse/duration else 0);
  flange.tau=-applied;
  if useSupport then
    support.tau=applied;
    reference=support.phi;
  else
    reference=0;
  end if;
  externalPower=applied*der(flange.phi-reference);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-54,-37},{42,37}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{42,0},{100,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-7,-37},{-7,-61},{0,-61},{0,-100}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-23,5},{-20,22},{1,29},{22,17},{25,-4},{9,-21},{-11,-20}}, color={64,64,64}, thickness=1.1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-52,51},{-28,51},{-28,75},{11,75},{11,51},{44,51}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Deliver a finite rectangular angular impulse.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Mechanics.Rotational.Interfaces.Flange_b flange</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; final parameter Modelica.Units.SI.Time endTime=startTime+duration; final parameter Modelica.Units.SI.Time transitionTime=0; parameter Boolean useSupport=false; parameter Real angularImpulse(unit=\"N.m.s\")=0.2; parameter Modelica.Units.SI.Time duration(min=0)=0.1</p><p><b>Behavior</b> Deliver a finite rectangular angular impulse</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. Positive effort acts in the positive flange coordinate. Support carries the equal reaction or a fixed world reference. </p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">AnomalyLibrary.Examples.MechanicalImpulseAndContact</a></p></html>"));
end TorqueImpulse;
