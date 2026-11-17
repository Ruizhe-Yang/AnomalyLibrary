within AnomalyLibrary.Fluid;
model Bypass "Additional reversible linear bypass path"
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
  massFlow=effectLevel*dp/R_flow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-66,0},{-66,32},{-31,32}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Polygon(points={{-31,13},{-31,51},{31,13},{31,51},{-31,13}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{31,32},{66,32},{66,0},{100,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-66,0},{-66,-31},{-30,-31}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Line(points={{30,-31},{66,-31},{66,0}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Rectangle(extent={{-30,-44},{30,-18}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The branch mass flow is <code>effectLevel*(port_a.p-port_b.p)/R_flow</code>. It reverses with pressure difference and is zero at zero effect. Both ports must be connected; the component provides neither a pressure boundary nor a fluid volume. Stream quantities pass through without storage, and <code>R_flow</code> must be positive.</p><p>Connect port_a and port_b across the intended bypass endpoints using a common Medium. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.FluidPathDisturbances\">FluidPathDisturbances</a> for connections.</p></html>"));
end Bypass;
