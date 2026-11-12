within AnomalyLibrary.Mechanics;
model TranslationalViscousCoupling "Add a passive viscous coupling between two ports"
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
  parameter Real d(min=0,unit="N.s/m")=1;
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

initial equation
  assert(d>=0,"Negative damping.");
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
  effort=d*effectLevel*relativeSpeed;
  lossPower=effort*relativeSpeed;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-43,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{11,0},{100,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-43,-30},{-43,30},{28,30}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-43,-30},{28,-30}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{11,-24},{11,24}}, color={64,64,64}, thickness=1.5, pattern=LinePattern.Solid),
        Line(points={{-34,55},{35,55}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-28,-39},{26,-65}}, textString="d", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Add a passive viscous coupling between two ports.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a; Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Real d(min=0,unit=\"N.s/m\")=1</p><p><b>Behavior</b> Add a passive viscous coupling between two ports</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. Additional damping is zero outside activation.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">AnomalyLibrary.Examples.MechanicalImpulseAndContact</a></p></html>"));
end TranslationalViscousCoupling;
