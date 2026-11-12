within AnomalyLibrary.Electrical;
model VoltageSag "Insert a series voltage drop from an explicit independent reference"
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

  Modelica.Electrical.Analog.Interfaces.PositivePin p annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

  Modelica.Units.SI.Voltage v;
  Modelica.Units.SI.Current i;
  Modelica.Units.SI.Power lossPower;
  parameter Real depth(min=0,max=1)=0.25;
  Modelica.Units.SI.Power externalPower;
  Modelica.Blocks.Interfaces.RealInput vReference(unit="V") annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

initial equation
  assert(depth>=0 and depth<=1,"Sag depth outside [0,1].");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  v=p.v-n.v;
  i=p.i;
  n.i=-i;
  v=depth*effectLevel*vReference;
  lossPower=0;
  externalPower=-v*i;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-45,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-45,-44},{45,44}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{45,0},{100,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-34,16},{-19,16},{-8,-15},{15,-15},{25,16},{35,16}}, color={191,0,0}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-32,52},{32,76}}, textString="ref", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Insert a series voltage drop from an explicit independent reference.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Electrical.Analog.Interfaces.PositivePin p; Modelica.Electrical.Analog.Interfaces.NegativePin n; Modelica.Blocks.Interfaces.RealInput vReference(unit=\"V\")</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Real depth(min=0,max=1)=0.25</p><p><b>Behavior</b> Insert a series voltage drop from an explicit independent reference</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. Use the nominal supply as a feed-forward reference.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">AnomalyLibrary.Examples.ElectricalDisturbances</a></p></html>"));
end VoltageSag;
