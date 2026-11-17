within AnomalyLibrary.Thermal;
model HeatFlow "Prescribed heat-flow disturbance with an energy integral"
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

  parameter Modelica.Units.SI.HeatFlowRate Q=10 "Heat flow supplied to the connected system at full effect";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port "Thermal connection to the affected body" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.HeatFlowRate heatFlow "Heat flow supplied to the connected system";
  Modelica.Units.SI.Energy injectedEnergy(start=0,fixed=true) "Cumulative signed heat supplied to the connected system";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

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
    Documentation(info="<html><p>The supplied heat flow is <code>Q*effectLevel</code>. Positive <code>Q</code> injects heat into the connected system, while negative <code>Q</code> removes heat. <code>injectedEnergy</code> integrates this signed heat flow from zero. The component is an ideal thermal source and does not prescribe the receiving temperature.</p><p>Connect port to a thermal node and set the signed heat-flow parameter Q. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">ThermalPulseAndEnvironment</a> for connections.</p></html>"));
end HeatFlow;
