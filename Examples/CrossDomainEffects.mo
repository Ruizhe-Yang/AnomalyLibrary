within AnomalyLibrary.Examples;
model CrossDomainEffects "Transfer electrical dissipation to heat and pressure to force"
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceSource(V=10) "Electrical supply for the heating path" annotation(Placement(transformation(origin={-218,108},extent={{-14,-14},{14,14}},rotation=270)));
  Modelica.Electrical.Analog.Basic.Ground sourceGround "Electrical potential reference" annotation(Placement(transformation(origin={-218,66},extent={{-10,-10},{10,10}},rotation=0)));
  AnomalyLibrary.CrossDomain.ElectricalHeating heater(R=10,enabled=true,startTime=0,endTime=6,transitionTime=0) "Electrical dissipation transferred to a heat port" annotation(Placement(transformation(origin={-7,122},extent={{-18,-18},{18,18}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor body(C=100,T(start=300,fixed=true)) "Thermal capacity receiving the electrical dissipation" annotation(Placement(transformation(origin={164,45},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.Constant pressure(k=100000) "Prescribed pressure-difference signal" annotation(Placement(transformation(origin={-207,-121},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.CrossDomain.PressureForce force(A=1e-4,enabled=true,startTime=0,endTime=6,transitionTime=0) "Force generated from the pressure signal" annotation(Placement(transformation(origin={-16,-121},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Mechanics.Translational.Components.Fixed reference "Fixed mechanical boundary" annotation(Placement(transformation(origin={168,-121},extent={{-14,-14},{14,14}},rotation=0)));
equation
  connect(sourceSource.n,sourceGround.p) annotation(Line(points={{-218,94},{-218,76}},color={0,0,255}));
  connect(sourceSource.p,heater.p) annotation(Line(points={{-218,122},{-218,127},{-218,122},{-25,122}},color={0,0,255}));
  connect(heater.n,sourceGround.p) annotation(Line(points={{11,122},{16,122},{16,81},{-218,81},{-218,76}},color={0,0,255}));
  connect(heater.heatPort,body.port) annotation(Line(points={{-7,104},{-7,26},{164,26},{164,31}},color={191,0,0}));
  connect(pressure.y,force.dp) annotation(Line(points={{-193.8,-121},{-33,-121}},color={0,0,127}));
  connect(force.flange,reference.flange) annotation(Line(points={{1,-121},{168,-121}},color={0,127,0}));
  annotation(experiment(StartTime=0,StopTime=5,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p>Connect a 10 V source across a 10 ohm electrical heating path and deliver its dissipation to a 100 J/K thermal capacity. With the stated activation, the expected power is 10 W and the temperature rises at 0.1 K/s.</p><p>A separate 100 kPa pressure-difference signal produces a prescribed 10 N force at a fixed mechanical boundary. Plot <code>heater.lossPower</code>, <code>body.T</code> and <code>force.applied</code>. The pressure input is a signal, not a fluid power port.</p></html>"));
end CrossDomainEffects;
