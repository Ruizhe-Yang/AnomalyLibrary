within AnomalyLibrary.Examples;
model CombinedAnomalies "Route the same ramp through serial and direct paths"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression ramp(y=time) annotation(Placement(transformation(origin={-182,15},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Signals.Bias offset(enabled=true,bias=1,startTime=1,endTime=2,transitionTime=0.05) annotation(Placement(transformation(origin={-95,15},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Signals.Delay delay(enabled=true,delayTime=0.2,startTime=2.2,endTime=3.4) annotation(Placement(transformation(origin={0,15},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Signals.Freeze hold(enabled=true,startTime=3.7,endTime=4.5) annotation(Placement(transformation(origin={96,15},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput modified annotation(Placement(transformation(origin={188,15},extent={{-7,-7},{7,7}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput nominal annotation(Placement(transformation(origin={188,-92},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(ramp.y,offset.u) annotation(Line(points={{-168.8,15},{-110,15}},color={0,0,127}));
  connect(offset.y,delay.u) annotation(Line(points={{-80,15},{-15,15}},color={0,0,127}));
  connect(delay.y,hold.u) annotation(Line(points={{15,15},{81,15}},color={0,0,127}));
  connect(hold.y,modified) annotation(Line(points={{111,15},{188,15}},color={0,0,127}));
  connect(ramp.y,nominal) annotation(Line(points={{-168.8,15},{-162.8,15},{-162.8,-92},{188,-92}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=6,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true),graphics={Text(extent={{-90,100},{130,86}},textString="Serial anomaly path",textColor={34,61,73}),Text(extent={{-75,-119},{115,-133}},textString="Direct reference",textColor={34,61,73})}),
    Documentation(info="<html><p><b>Purpose</b> Route the same ramp through serial and direct paths</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Three distinct windows permit attribution. When all effects are disabled, the series path is equivalent to the direct reference.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> modified, nominal and the three active signals.</p></html>"));
end CombinedAnomalies;
