within AnomalyLibrary.Fluid;
model AddedResistance "Additional linear series pressure-drop resistance"
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
  replaceable package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  parameter Real R_flow(min=0,unit="Pa.s/kg")=100000 "Linear resistance relating pressure drop to mass flow";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium) "Fluid port a" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium) "Fluid port b" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.PressureDifference dp "Pressure at port_a minus pressure at port_b";
  Modelica.Units.SI.MassFlowRate massFlow "Mass flow from port_a to port_b";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(R_flow>0,"Flow resistance must be positive.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  dp=port_a.p-port_b.p;
  massFlow=port_a.m_flow;
  port_b.m_flow=-port_a.m_flow;
  port_a.h_outflow=inStream(port_b.h_outflow);
  port_b.h_outflow=inStream(port_a.h_outflow);
  port_a.Xi_outflow=inStream(port_b.Xi_outflow);
  port_b.Xi_outflow=inStream(port_a.Xi_outflow);
  port_a.C_outflow=inStream(port_b.C_outflow);
  port_b.C_outflow=inStream(port_a.C_outflow);
  dp=effectLevel*R_flow*massFlow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-38,0}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Polygon(points={{-38,25},{-38,-25},{38,25},{38,-25},{-38,25}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{38,0},{100,0}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-14,-41},{21,43}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-50,-54},{50,-80}}, textString="R+", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The pressure drop is <code>port_a.p-port_b.p=effectLevel*R_flow*massFlow</code>, where positive mass flow runs from <code>port_a</code> to <code>port_b</code>. Zero effect gives zero pressure drop. Enthalpy, composition and trace substances pass through using stream semantics. The model has no storage and uses a linear flow relation; <code>R_flow</code> must be positive.</p><p>Insert port_a and port_b in series and redeclare Medium consistently with the connected network. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.FluidPathDisturbances\">FluidPathDisturbances</a> for connections.</p></html>"));
end AddedResistance;
