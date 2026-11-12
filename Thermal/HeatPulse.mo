within AnomalyLibrary.Thermal;
model HeatPulse "Deliver a finite rectangular thermal energy pulse"
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

  parameter Modelica.Units.SI.Energy energy=10;
  parameter Modelica.Units.SI.Time duration(min=0)=1;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.HeatFlowRate heatFlow;
  Modelica.Units.SI.Energy injectedEnergy(start=0,fixed=true);
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);
  discrete Modelica.Units.SI.Time began(start=0,fixed=true);
  discrete Boolean seen(start=false,fixed=true);
initial equation
  assert(duration>0,"Heat pulse needs a positive duration.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  when {initial(),active} then
    began=time;
    seen=active;
  end when;
  heatFlow=if seen and time<began+duration then energy/duration else 0;
  port.Q_flow=-heatFlow;
  der(injectedEnergy)=heatFlow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-48,-48},{48,48}}, lineColor={191,0,0}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{48,0},{100,0}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-35,-17},{-19,-17},{-19,21},{18,21},{18,-17},{35,-17}}, color={191,0,0}, thickness=1.1, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Deliver a finite rectangular thermal energy pulse.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; final parameter Modelica.Units.SI.Time endTime=startTime+duration; final parameter Modelica.Units.SI.Time transitionTime=0; parameter Modelica.Units.SI.Energy energy=10; parameter Modelica.Units.SI.Time duration(min=0)=1</p><p><b>Behavior</b> Deliver a finite rectangular thermal energy pulse</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. A triggered pulse lasts for duration. Select a longer separation than duration for distinct pulse energy accounting.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">AnomalyLibrary.Examples.ThermalPulseAndEnvironment</a></p></html>"));
end HeatPulse;
