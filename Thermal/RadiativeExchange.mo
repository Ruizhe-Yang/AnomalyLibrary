within AnomalyLibrary.Thermal;
model RadiativeExchange "Exchange radiation with an explicit absolute environment temperature"
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

  parameter Real emissivity(min=0,max=1)=0.8;
  parameter Modelica.Units.SI.Area area(min=0)=0.2;
  parameter Modelica.Units.SI.Temperature environment(min=0)=320;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.HeatFlowRate heatFlow;
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

initial equation
  assert(emissivity>=0 and emissivity<=1 and area>=0 and environment>=0,"Invalid radiation boundary.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  assert(port.T>=0,"Radiation requires absolute temperature.");
  heatFlow=effectLevel*emissivity*Modelica.Constants.sigma*area*(environment^4-port.T^4);
  port.Q_flow=-heatFlow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-61,-37},{-46,37}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{39,-37},{53,37}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-37,15},{-35.14,16.57},{-33.28,18.07},{-31.42,19.41},{-29.56,20.52},{-27.69,21.34},{-25.83,21.85},{-23.97,22},{-22.11,21.79},{-20.25,21.24},{-18.39,20.36},{-16.53,19.21},{-14.67,17.85},{-12.81,16.34},{-10.94,14.76},{-9.08,13.19},{-7.22,11.71},{-5.36,10.41},{-3.5,9.34},{-1.64,8.56},{0.22,8.11},{2.08,8.01},{3.94,8.27},{5.81,8.88},{7.67,9.8},{9.53,10.98},{11.39,12.38},{13.25,13.9},{15.11,15.49},{16.97,17.05},{18.83,18.5},{20.69,19.77},{22.56,20.8},{24.42,21.54},{26.28,21.93},{28.14,21.97},{30,21.66}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{30,-12},{28.14,-10.43},{26.28,-8.93},{24.42,-7.59},{22.56,-6.48},{20.69,-5.66},{18.83,-5.15},{16.97,-5},{15.11,-5.21},{13.25,-5.76},{11.39,-6.64},{9.53,-7.79},{7.67,-9.15},{5.81,-10.66},{3.94,-12.24},{2.08,-13.81},{0.22,-15.29},{-1.64,-16.59},{-3.5,-17.66},{-5.36,-18.44},{-7.22,-18.89},{-9.08,-18.99},{-10.94,-18.73},{-12.81,-18.12},{-14.67,-17.2},{-16.53,-16.02},{-18.39,-14.62},{-20.25,-13.1},{-22.11,-11.51},{-23.97,-9.95},{-25.83,-8.5},{-27.69,-7.23},{-29.56,-6.2},{-31.42,-5.46},{-33.28,-5.07},{-35.14,-5.03},{-37,-5.34}}, color={128,128,128}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{53,0},{100,0}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-48,49},{47,77}}, textString="T^4", textColor={191,0,0}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Exchange radiation with an explicit absolute environment temperature.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Real emissivity(min=0,max=1)=0.8; parameter Modelica.Units.SI.Area area(min=0)=0.2; parameter Modelica.Units.SI.Temperature environment(min=0)=320</p><p><b>Behavior</b> Exchange radiation with an explicit absolute environment temperature</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. This is a one-surface diffuse boundary with the stated effective emissivity.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">AnomalyLibrary.Examples.ThermalPulseAndEnvironment</a></p></html>"));
end RadiativeExchange;
