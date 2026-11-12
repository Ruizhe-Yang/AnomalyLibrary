within AnomalyLibrary.CrossDomain;
model PressureForce "Convert a prescribed pressure difference into an external force"
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

  parameter Boolean useSupport=false;
  Modelica.Mechanics.Translational.Interfaces.Flange_b flange annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Translational.Interfaces.Support support if useSupport annotation(Placement(transformation(origin={0,-100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,-100},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Force applied;
  Modelica.Units.SI.Power externalPower;
  parameter Modelica.Units.SI.Area A(min=0)=1e-4;
  Modelica.Blocks.Interfaces.RealInput dp(unit="Pa") annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);
  Modelica.Units.SI.Position reference;

initial equation
  assert(A>=0,"Negative piston area.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  applied=(A*dp)*effectLevel;
  flange.f=-applied;
  if useSupport then
    support.f=applied;
    reference=support.s;
  else
    reference=0;
  end if;
  externalPower=applied*der(flange.s-reference);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-41,-33},{27,33}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{8,-28},{8,28}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{8,0},{100,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-72,65},{-15,40}}, textString="dp", textColor={64,64,64}, fontSize=0),
        Line(points={{-23,13},{-3,13}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-23,-13},{-3,-13}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-22,-34},{-22,-61},{0,-61},{0,-100}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-67,-49},{-30,-73}}, textString="A", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Convert a prescribed pressure difference into an external force.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Mechanics.Translational.Interfaces.Flange_b flange; Modelica.Blocks.Interfaces.RealInput dp(unit=\"Pa\")</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Boolean useSupport=false; parameter Modelica.Units.SI.Area A(min=0)=1e-4</p><p><b>Behavior</b> Convert a prescribed pressure difference into an external force</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. Positive effort acts in the positive flange coordinate. Support carries the equal reaction or a fixed world reference. Pressure is an information input. No fluid volume or hydraulic power transformation is modeled.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.CrossDomainEffects\">AnomalyLibrary.Examples.CrossDomainEffects</a></p></html>"));
end PressureForce;
