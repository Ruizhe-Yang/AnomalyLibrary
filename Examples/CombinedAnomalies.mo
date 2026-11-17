within AnomalyLibrary.Examples;
model CombinedAnomalies "Compare a serial anomaly path with the unmodified signal"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression ramp(y=time) "Common ramp input" annotation(Placement(transformation(origin={-182,15},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Signals.Bias offset(enabled=true,bias=1,startTime=1,endTime=2,transitionTime=0.05) "First stage: additive bias" annotation(Placement(transformation(origin={-95,15},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Signals.Delay delay(enabled=true,delayTime=0.2,startTime=2.2,endTime=3.4) "Second stage: signal delay" annotation(Placement(transformation(origin={0,15},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Signals.Freeze hold(enabled=true,startTime=3.7,endTime=4.5) "Third stage: captured-value hold" annotation(Placement(transformation(origin={96,15},extent={{-15,-15},{15,15}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput modified "Output of the serial anomaly path" annotation(Placement(transformation(origin={188,15},extent={{-7,-7},{7,7}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput nominal "Unmodified ramp output" annotation(Placement(transformation(origin={188,-92},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(ramp.y,offset.u) annotation(Line(points={{-168.8,15},{-110,15}},color={0,0,127}));
  connect(offset.y,delay.u) annotation(Line(points={{-80,15},{-15,15}},color={0,0,127}));
  connect(delay.y,hold.u) annotation(Line(points={{15,15},{81,15}},color={0,0,127}));
  connect(hold.y,modified) annotation(Line(points={{111,15},{188,15}},color={0,0,127}));
  connect(ramp.y,nominal) annotation(Line(points={{-168.8,15},{-162.8,15},{-162.8,-92},{188,-92}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=6,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true),graphics={Text(extent={{-90,100},{130,86}},textString="Serial anomaly path",textColor={34,61,73}),Text(extent={{-75,-119},{115,-133}},textString="Direct reference",textColor={34,61,73})}),
    Documentation(info="<html><p>Apply bias, delay and capture in sequence to a shared ramp, while exposing the unmodified ramp through <code>nominal</code>. The activation intervals are separated so that the effect of each operation can be inspected.</p><p>Run the stored experiment and compare <code>modified</code> with <code>nominal</code>. Inspect each component's activation and effect level at the interval boundaries; a transition ramp can extend beyond its request interval.</p></html>"));
end CombinedAnomalies;
