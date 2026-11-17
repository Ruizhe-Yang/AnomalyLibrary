within AnomalyLibrary.Examples;
model FluidPathDisturbances "Open a parallel fluid path between prescribed boundaries"
  extends Modelica.Icons.Example;
  replaceable package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Boolean reverse=false "Exchange the prescribed boundary pressures";
  inner Modelica.Fluid.System system "Fluid-system settings shared by the components" annotation(Placement(transformation(origin={-270,185},extent={{-12,-12},{12,12}},rotation=0)));
  Modelica.Fluid.Sources.Boundary_pT upstream(redeclare package Medium=Medium,p=if reverse then 100000 else 200000,T=293.15,nPorts=2) "First prescribed pressure and temperature boundary" annotation(Placement(transformation(origin={-220,0},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Fluid.Sources.Boundary_pT downstream(redeclare package Medium=Medium,p=if reverse then 200000 else 100000,T=293.15,nPorts=2) "Second prescribed pressure and temperature boundary" annotation(Placement(transformation(origin={230,0},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Fluid.Valves.ValveLinear mainPath(redeclare package Medium=Medium,dp_nominal=100000,m_flow_nominal=1) "Nominal linear valve path" annotation(Placement(transformation(origin={0,75},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Sources.Constant openValve(k=1) "Fully open valve command" annotation(Placement(transformation(origin={-123,145},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Fluid.Bypass extraPath(redeclare package Medium=Medium,R_flow=100000,enabled=true,startTime=1,endTime=3,transitionTime=0) "Parallel path active during the selected interval" annotation(Placement(transformation(origin={0,-85},extent={{-16,-16},{16,16}},rotation=0)));
equation
  connect(openValve.y,mainPath.opening) annotation(Line(points={{-109.8,145},{0,145},{0,87}},color={0,0,127}));
  connect(upstream.ports[1],mainPath.port_a) annotation(Line(points={{-205,0},{-110,0},{-110,75},{-15,75}},color={0,127,255}));
  connect(mainPath.port_b,downstream.ports[1]) annotation(Line(points={{15,75},{250,75},{250,0},{245,0}},color={0,127,255}));
  connect(upstream.ports[2],extraPath.port_a) annotation(Line(points={{-205,0},{-110.5,0},{-110.5,-85},{-16,-85}},color={0,127,255}));
  connect(extraPath.port_b,downstream.ports[2]) annotation(Line(points={{16,-85},{250,-85},{250,0},{245,0}},color={0,127,255}));
  annotation(experiment(StartTime=0,StopTime=5,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p>Connect a nominal valve and a switched bypass between two prescribed water boundaries. The nominal pressure difference is 100 kPa. The fully open valve carries 1 kg/s; the active bypass adds 1 kg/s during <code>[1,3)</code> s.</p><p>Plot <code>mainPath.port_a.m_flow</code> and <code>extraPath.massFlow</code>. Set <code>reverse=true</code> to exchange the boundary pressures and reverse the flow signs. All connected components use the same replaceable <code>Medium</code>.</p></html>"));
end FluidPathDisturbances;
