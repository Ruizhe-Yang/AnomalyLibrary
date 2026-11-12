within AnomalyLibrary.Examples;
model FluidPathDisturbances "Open a parallel path between two explicit fluid boundaries"
  extends Modelica.Icons.Example;
  replaceable package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Boolean reverse=false;
  inner Modelica.Fluid.System system annotation(Placement(transformation(origin={-270,185},extent={{-12,-12},{12,12}},rotation=0)));
  Modelica.Fluid.Sources.Boundary_pT upstream(redeclare package Medium=Medium,p=if reverse then 100000 else 200000,T=293.15,nPorts=2) annotation(Placement(transformation(origin={-220,0},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Fluid.Sources.Boundary_pT downstream(redeclare package Medium=Medium,p=if reverse then 200000 else 100000,T=293.15,nPorts=2) annotation(Placement(transformation(origin={230,0},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Fluid.Valves.ValveLinear mainPath(redeclare package Medium=Medium,dp_nominal=100000,m_flow_nominal=1) annotation(Placement(transformation(origin={0,75},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Sources.Constant openValve(k=1) annotation(Placement(transformation(origin={-123,145},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Fluid.Bypass extraPath(redeclare package Medium=Medium,R_flow=100000,enabled=true,startTime=1,endTime=3,transitionTime=0) annotation(Placement(transformation(origin={0,-85},extent={{-16,-16},{16,16}},rotation=0)));
equation
  connect(openValve.y,mainPath.opening) annotation(Line(points={{-109.8,145},{0,145},{0,87}},color={0,0,127}));
  connect(upstream.ports[1],mainPath.port_a) annotation(Line(points={{-205,0},{-110,0},{-110,75},{-15,75}},color={0,127,255}));
  connect(mainPath.port_b,downstream.ports[1]) annotation(Line(points={{15,75},{250,75},{250,0},{245,0}},color={0,127,255}));
  connect(upstream.ports[2],extraPath.port_a) annotation(Line(points={{-205,0},{-110.5,0},{-110.5,-85},{-16,-85}},color={0,127,255}));
  connect(extraPath.port_b,downstream.ports[2]) annotation(Line(points={{16,-85},{250,-85},{250,0},{245,0}},color={0,127,255}));
  annotation(experiment(StartTime=0,StopTime=5,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Open a parallel path between two explicit fluid boundaries</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> The main path carries 1 kg/s and the active extra path adds 1 kg/s. reverse reverses both flow signs.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> mainPath.port_a.m_flow, extraPath.massFlow and each stream enthalpy.</p></html>"));
end FluidPathDisturbances;
