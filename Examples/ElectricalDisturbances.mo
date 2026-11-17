within AnomalyLibrary.Examples;
model ElectricalDisturbances "Compare a parallel conductance with a series voltage ripple"
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Sources.ConstantVoltage dcSource(V=12) "Supply for the parallel-conductance circuit" annotation(Placement(transformation(origin={-220,115},extent={{-14,-14},{14,14}},rotation=270)));
  Modelica.Electrical.Analog.Basic.Ground dcGround "Reference for the parallel-conductance circuit" annotation(Placement(transformation(origin={-220,73},extent={{-10,-10},{10,10}},rotation=0)));
  Modelica.Electrical.Analog.Basic.Resistor referenceLoad(R=10) "Nominal load in the shunt circuit" annotation(Placement(transformation(origin={30,155},extent={{-14,-14},{14,14}},rotation=0)));
  AnomalyLibrary.Electrical.ShuntConductance extraPath(G_fault=0.1,enabled=true,startTime=1,endTime=2,transitionTime=0) "Switched parallel conductance" annotation(Placement(transformation(origin={30,78},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage rippleSource(V=12) "Independent supply for the ripple circuit" annotation(Placement(transformation(origin={-220,-75},extent={{-14,-14},{14,14}},rotation=270)));
  Modelica.Electrical.Analog.Basic.Ground rippleGround "Reference for the ripple circuit" annotation(Placement(transformation(origin={-220,-117},extent={{-10,-10},{10,10}},rotation=0)));
  AnomalyLibrary.Electrical.SupplyRipple seriesRipple(enabled=true,startTime=1,endTime=2,transitionTime=0,amplitude=1,frequency=10) "Voltage ripple inserted in series" annotation(Placement(transformation(origin={-65,-54},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Electrical.Analog.Basic.Resistor rippleLoad(R=10) "Load receiving the series voltage disturbance" annotation(Placement(transformation(origin={115,-54},extent={{-14,-14},{14,14}},rotation=0)));
equation
  connect(dcSource.n,dcGround.p) annotation(Line(points={{-220,101},{-220,83}},color={0,0,255}));
  connect(dcSource.p,referenceLoad.p) annotation(Line(points={{-220,129},{-220,155},{16,155}},color={0,0,255}));
  connect(referenceLoad.n,dcGround.p) annotation(Line(points={{44,155},{49,155},{49,98},{-220,98},{-220,83}},color={0,0,255}));
  connect(dcSource.p,extraPath.p) annotation(Line(points={{-220,129},{-220,134},{10,134},{10,78},{15,78}},color={0,0,255}));
  connect(extraPath.n,dcGround.p) annotation(Line(points={{45,78},{50,78},{50,88},{-220,88},{-220,83}},color={0,0,255}));
  connect(rippleSource.n,rippleGround.p) annotation(Line(points={{-220,-89},{-220,-107}},color={0,0,255}));
  connect(rippleSource.p,seriesRipple.p) annotation(Line(points={{-220,-61},{-220,-54},{-80,-54}},color={0,0,255}));
  connect(seriesRipple.n,rippleLoad.p) annotation(Line(points={{-50,-54},{101,-54}},color={0,0,255}));
  connect(rippleLoad.n,rippleGround.p) annotation(Line(points={{129,-54},{134,-54},{134,-102},{-220,-102},{-220,-107}},color={0,0,255}));
  annotation(experiment(StartTime=0,StopTime=4,Interval=0.008,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true),graphics={Text(extent={{-242.5,219},{72.5,205}},textString="Parallel conductance and reference load",textColor={34,61,73}),Text(extent={{-207.5,3},{37.5,-11}},textString="Separate series ripple loop",textColor={34,61,73})}),
    Documentation(info="<html><p>Use two independent 12 V circuits to demonstrate a switched parallel conductance and a series voltage ripple. During <code>[1,2)</code> s, the 0.1 S shunt draws 1.2 A and dissipates 14.4 W; outside that interval its current is zero.</p><p>Plot <code>extraPath.i</code>, <code>extraPath.lossPower</code>, <code>seriesRipple.v</code> and <code>rippleLoad.i</code>. The ripple circuit uses a separate source so that its imposed voltage is not connected directly across an ideal voltage source.</p></html>"));
end ElectricalDisturbances;
