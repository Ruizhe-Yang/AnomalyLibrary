within AnomalyLibrary.Thermal;
model AmbientShift "Shift an environmental temperature across a finite thermal conductance"
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

  parameter Modelica.Units.SI.Temperature referenceTemperature(min=0)=293.15;
  parameter Modelica.Units.SI.TemperatureDifference deltaT=10;
  parameter Modelica.Units.SI.ThermalConductance G(min=0)=2;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Temperature environment;
  Modelica.Units.SI.HeatFlowRate heatFlow;
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

initial equation
  assert(G>=0 and referenceTemperature>0 and referenceTemperature+min(0,deltaT)>0,"Invalid temperature boundary.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  environment=referenceTemperature+deltaT*effectLevel;
  heatFlow=G*(environment-port.T);
  port.Q_flow=-heatFlow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-57,-19},{-41,43}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=7),
        Ellipse(extent={{-65,-43},{-33,-11}}, lineColor={64,64,64}, fillColor={191,0,0}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-49,-20},{-49,29}}, color={191,0,0}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-26,0},{-10,0}}, color={191,0,0}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-10,-23},{28,23}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-4,15},{22,-15}}, textString="G", textColor={191,0,0}, fontSize=0),
        Line(points={{28,0},{100,0}}, color={191,0,0}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-25,48},{15,48},{15,68},{42,68}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Shift an environmental temperature across a finite thermal conductance.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Modelica.Units.SI.Temperature referenceTemperature(min=0)=293.15; parameter Modelica.Units.SI.TemperatureDifference deltaT=10; parameter Modelica.Units.SI.ThermalConductance G(min=0)=2</p><p><b>Behavior</b> Shift an environmental temperature across a finite thermal conductance</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. The inactive reference is the original finite boundary conductance at referenceTemperature.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">AnomalyLibrary.Examples.ThermalPulseAndEnvironment</a></p></html>"));
end AmbientShift;
