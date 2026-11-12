within AnomalyLibrary.Thermal;
model HeatFlow "Deliver a prescribed heat flow and accumulate its energy"
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

  parameter Modelica.Units.SI.HeatFlowRate Q=10;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.HeatFlowRate heatFlow;
  Modelica.Units.SI.Energy injectedEnergy(start=0,fixed=true);
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  heatFlow=Q*effectLevel;
  port.Q_flow=-heatFlow;
  der(injectedEnergy)=heatFlow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-48,-48},{48,48}}, lineColor={191,0,0}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{48,0},{100,0}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-26,-11},{25,-11}}, color={191,0,0}, thickness=1.1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-26,28},{26,3}}, textString="Q", textColor={191,0,0}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Deliver a prescribed heat flow and accumulate its energy.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Modelica.Units.SI.HeatFlowRate Q=10</p><p><b>Behavior</b> Deliver a prescribed heat flow and accumulate its energy</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. Positive Q adds heat to the receiving network. An external source supplies this energy.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">AnomalyLibrary.Examples.ThermalPulseAndEnvironment</a></p></html>"));
end HeatFlow;
