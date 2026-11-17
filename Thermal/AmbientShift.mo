within AnomalyLibrary.Thermal;
model AmbientShift "Environment temperature shift through a finite conductance"
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

  parameter Modelica.Units.SI.Temperature referenceTemperature(min=0)=293.15 "Nominal absolute environment temperature";
  parameter Modelica.Units.SI.TemperatureDifference deltaT=10 "Environment temperature change at full effect";
  parameter Modelica.Units.SI.ThermalConductance G(min=0)=2 "Conductance between the environment and the body";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port "Thermal connection to the affected body" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Temperature environment "Current absolute environment temperature";
  Modelica.Units.SI.HeatFlowRate heatFlow "Heat flow supplied to the connected system";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

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
    Documentation(info="<html><p>The environmental temperature is <code>referenceTemperature+deltaT*effectLevel</code>. Heat enters the connected body at <code>G*(environment-port.T)</code>. At zero effect the nominal conductance to <code>referenceTemperature</code> remains present, so this model is part of the nominal thermal boundary. The declared temperatures must remain positive in kelvin.</p><p>Connect port to the body and configure the nominal environment temperature, deltaT and G. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">ThermalPulseAndEnvironment</a> for connections.</p></html>"));
end AmbientShift;
