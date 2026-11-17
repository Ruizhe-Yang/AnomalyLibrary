within AnomalyLibrary.Thermal;
model AddedConductance "Additional thermal conductance between two ports"
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

  parameter Modelica.Units.SI.ThermalConductance G(min=0)=1 "Thermal conductance at full effect";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a "First thermal port" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b "Second thermal port" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.HeatFlowRate heatFlow "Heat flow from port_a to port_b";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(G>=0,"Negative conductance.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  heatFlow=effectLevel*G*(port_a.T-port_b.T);
  port_a.Q_flow=heatFlow;
  port_b.Q_flow=-heatFlow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-29,0}}, color={191,0,0}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{29,0},{100,0}}, color={191,0,0}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-29,-32},{-12,32}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{12,-32},{29,32}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-5,-27},{5,27}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-37,44},{37,70}}, textString="G+", textColor={191,0,0}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The heat flow from <code>port_a</code> to <code>port_b</code> is <code>effectLevel*G*(port_a.T-port_b.T)</code>. Equal and opposite port flows conserve energy through the connection. Zero effect removes the additional heat transfer; the component has no thermal storage.</p><p>Connect port_a and port_b to the two thermal nodes and set G. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">ThermalPulseAndEnvironment</a> for connections.</p></html>"));
end AddedConductance;
