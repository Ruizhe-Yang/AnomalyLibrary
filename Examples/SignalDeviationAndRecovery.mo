within AnomalyLibrary.Examples;
model SignalDeviationAndRecovery "Compare offset, capture and gain on the same ramp"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression ramp(y=time) annotation(Placement(transformation(origin={-171,0},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Signals.Bias bias(enabled=true,startTime=1,endTime=2,bias=2,transitionTime=0) annotation(Placement(transformation(origin={-25,72},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput biasValue annotation(Placement(transformation(origin={147,72},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.Freeze freeze(enabled=true,startTime=1,endTime=2) annotation(Placement(transformation(origin={-25,0},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput freezeValue annotation(Placement(transformation(origin={147,0},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.GainError gain(enabled=true,startTime=1,endTime=2,gainError=1,transitionTime=0) annotation(Placement(transformation(origin={-25,-72},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput gainValue annotation(Placement(transformation(origin={147,-72},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(ramp.y,bias.u) annotation(Line(points={{-157.8,0},{-98.9,0},{-98.9,72},{-40,72}},color={0,0,127}));
  connect(bias.y,biasValue) annotation(Line(points={{-10,72},{147,72}},color={0,0,127}));
  connect(ramp.y,freeze.u) annotation(Line(points={{-157.8,0},{-40,0}},color={0,0,127}));
  connect(freeze.y,freezeValue) annotation(Line(points={{-10,0},{147,0}},color={0,0,127}));
  connect(ramp.y,gain.u) annotation(Line(points={{-157.8,0},{-98.9,0},{-98.9,-72},{-40,-72}},color={0,0,127}));
  connect(gain.y,gainValue) annotation(Line(points={{-10,-72},{147,-72}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=4,Interval=0.008,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Compare offset, capture and gain on the same ramp</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> At 1.5 s the three outputs are 3.5, 1 and 3. At 0.5 and 2.5 s all outputs follow the ramp.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> biasValue, freezeValue, gainValue, each active and effectLevel.</p></html>"));
end SignalDeviationAndRecovery;
