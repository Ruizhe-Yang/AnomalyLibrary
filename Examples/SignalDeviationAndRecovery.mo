within AnomalyLibrary.Examples;
model SignalDeviationAndRecovery "Compare bias, capture and gain on a shared ramp"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression ramp(y=time) "Common ramp signal" annotation(Placement(transformation(origin={-171,0},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Signals.Bias bias(enabled=true,startTime=1,endTime=2,bias=2,transitionTime=0) "Additive-bias path" annotation(Placement(transformation(origin={-25,72},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput biasValue "Ramp after additive bias" annotation(Placement(transformation(origin={147,72},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.Freeze freeze(enabled=true,startTime=1,endTime=2) "Captured-value path" annotation(Placement(transformation(origin={-25,0},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput freezeValue "Ramp after captured-value hold" annotation(Placement(transformation(origin={147,0},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.GainError gain(enabled=true,startTime=1,endTime=2,gainError=1,transitionTime=0) "Gain-error path" annotation(Placement(transformation(origin={-25,-72},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput gainValue "Ramp after gain error" annotation(Placement(transformation(origin={147,-72},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(ramp.y,bias.u) annotation(Line(points={{-157.8,0},{-98.9,0},{-98.9,72},{-40,72}},color={0,0,127}));
  connect(bias.y,biasValue) annotation(Line(points={{-10,72},{147,72}},color={0,0,127}));
  connect(ramp.y,freeze.u) annotation(Line(points={{-157.8,0},{-40,0}},color={0,0,127}));
  connect(freeze.y,freezeValue) annotation(Line(points={{-10,0},{147,0}},color={0,0,127}));
  connect(ramp.y,gain.u) annotation(Line(points={{-157.8,0},{-98.9,0},{-98.9,-72},{-40,-72}},color={0,0,127}));
  connect(gain.y,gainValue) annotation(Line(points={{-10,-72},{147,-72}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=4,Interval=0.008,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true)),
    Documentation(info="<html><p>Apply three independent operations to <code>u=time</code> during <code>[1,2)</code> s. The bias adds 2, the capture block holds the value at activation, and the gain error doubles the input. The declared transitions are immediate.</p><p>Run the stored experiment and plot <code>biasValue</code>, <code>freezeValue</code> and <code>gainValue</code>. At 1.5 s their expected values are 3.5, 1 and 3. Outside the activation interval, all three follow the ramp.</p></html>"));
end SignalDeviationAndRecovery;
