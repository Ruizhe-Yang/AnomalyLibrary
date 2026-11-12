within AnomalyLibrary.Examples;
model CrossDomainEffects "Route electrical loss to heat and a pressure signal to prescribed force"
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceSource(V=10) annotation(Placement(transformation(origin={-218,108},extent={{-14,-14},{14,14}},rotation=270)));
  Modelica.Electrical.Analog.Basic.Ground sourceGround annotation(Placement(transformation(origin={-218,66},extent={{-10,-10},{10,10}},rotation=0)));
  AnomalyLibrary.CrossDomain.ElectricalHeating heater(R=10,enabled=true,startTime=0,endTime=6,transitionTime=0) annotation(Placement(transformation(origin={-7,122},extent={{-18,-18},{18,18}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor body(C=100,T(start=300,fixed=true)) annotation(Placement(transformation(origin={164,45},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.Constant pressure(k=100000) annotation(Placement(transformation(origin={-207,-121},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.CrossDomain.PressureForce force(A=1e-4,enabled=true,startTime=0,endTime=6,transitionTime=0) annotation(Placement(transformation(origin={-16,-121},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Mechanics.Translational.Components.Fixed reference annotation(Placement(transformation(origin={168,-121},extent={{-14,-14},{14,14}},rotation=0)));
equation
  connect(sourceSource.n,sourceGround.p) annotation(Line(points={{-218,94},{-218,76}},color={0,0,255}));
  connect(sourceSource.p,heater.p) annotation(Line(points={{-218,122},{-218,127},{-218,122},{-25,122}},color={0,0,255}));
  connect(heater.n,sourceGround.p) annotation(Line(points={{11,122},{16,122},{16,81},{-218,81},{-218,76}},color={0,0,255}));
  connect(heater.heatPort,body.port) annotation(Line(points={{-7,104},{-7,26},{164,26},{164,31}},color={191,0,0}));
  connect(pressure.y,force.dp) annotation(Line(points={{-193.8,-121},{-33,-121}},color={0,0,127}));
  connect(force.flange,reference.flange) annotation(Line(points={{1,-121},{168,-121}},color={0,127,0}));
  annotation(experiment(StartTime=0,StopTime=5,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Route electrical loss to heat and a pressure signal to prescribed force</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Electrical dissipation is 10 W and raises the 100 J/K body at 0.1 K/s. The pressure input gives a 10 N prescribed force.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> heater.lossPower, body.T and force.applied.</p></html>"));
end CrossDomainEffects;
