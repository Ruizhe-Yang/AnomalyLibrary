within AnomalyLibrary.Examples;
model UnsafeCommandPatterns "Apply independent omission, spurious, timing and duration operations"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.BooleanExpression command(y=time>=1 and time<2) annotation(Placement(transformation(origin={-165,0},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Signals.CommandOmission omitted(enabled=true,startTime=1,endTime=1.25) annotation(Placement(transformation(origin={-14,110},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput omittedValue annotation(Placement(transformation(origin={155,110},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.CommandSpurious spurious(enabled=true,startTime=0,endTime=4,extraTimes={0.5},pulseWidth=0.25) annotation(Placement(transformation(origin={-14,39},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput spuriousValue annotation(Placement(transformation(origin={155,39},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.CommandTiming timed(enabled=true,startTime=0,endTime=4,delayTime=0.2) annotation(Placement(transformation(origin={-14,-35},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput timedValue annotation(Placement(transformation(origin={155,-35},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.CommandDuration duration(enabled=true,startTime=0,endTime=4,nominalDuration=1,durationFactor=1.3) annotation(Placement(transformation(origin={-14,-109},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput durationValue annotation(Placement(transformation(origin={155,-109},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(command.y,omitted.u) annotation(Line(points={{-151.8,0},{-89.9,0},{-89.9,110},{-28,110}},color={255,0,255}));
  connect(omitted.y,omittedValue) annotation(Line(points={{0,110},{155,110}},color={255,0,255}));
  connect(command.y,spurious.u) annotation(Line(points={{-151.8,0},{-89.9,0},{-89.9,39},{-28,39}},color={255,0,255}));
  connect(spurious.y,spuriousValue) annotation(Line(points={{0,39},{155,39}},color={255,0,255}));
  connect(command.y,timed.u) annotation(Line(points={{-151.8,0},{-89.9,0},{-89.9,-35},{-28,-35}},color={255,0,255}));
  connect(timed.y,timedValue) annotation(Line(points={{0,-35},{155,-35}},color={255,0,255}));
  connect(command.y,duration.u) annotation(Line(points={{-151.8,0},{-89.9,0},{-89.9,-109},{-28,-109}},color={255,0,255}));
  connect(duration.y,durationValue) annotation(Line(points={{0,-109},{155,-109}},color={255,0,255}));
  annotation(experiment(StartTime=0,StopTime=4,Interval=0.008,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Apply independent omission, spurious, timing and duration operations</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> The nominal command spans [1,2). Omission removes it completely. The spurious output is additionally true at [0.5,0.75).</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> The four output edges and pulse lengths. Inspect effectActive after the triggering window closes.</p></html>"));
end UnsafeCommandPatterns;
