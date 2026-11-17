within AnomalyLibrary.Examples;
model UnsafeCommandPatterns "Compare omitted, spurious, delayed and duration-modified commands"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.BooleanExpression command(y=time>=1 and time<2) "Nominal Boolean command" annotation(Placement(transformation(origin={-165,0},extent={{-12,-12},{12,12}},rotation=0)));
  AnomalyLibrary.Signals.CommandOmission omitted(enabled=true,startTime=1,endTime=1.25) "Omission of a captured command" annotation(Placement(transformation(origin={-14,110},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput omittedValue "Command after omission" annotation(Placement(transformation(origin={155,110},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.CommandSpurious spurious(enabled=true,startTime=0,endTime=4,extraTimes={0.5},pulseWidth=0.25) "Additional scheduled command pulse" annotation(Placement(transformation(origin={-14,39},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput spuriousValue "Command with the additional pulse" annotation(Placement(transformation(origin={155,39},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.CommandTiming timed(enabled=true,startTime=0,endTime=4,delayTime=0.2) "Delayed command path" annotation(Placement(transformation(origin={-14,-35},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput timedValue "Command after time delay" annotation(Placement(transformation(origin={155,-35},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Signals.CommandDuration duration(enabled=true,startTime=0,endTime=4,nominalDuration=1,durationFactor=1.3) "Replacement pulse with modified duration" annotation(Placement(transformation(origin={-14,-109},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput durationValue "Command after pulse-duration modification" annotation(Placement(transformation(origin={155,-109},extent={{-7,-7},{7,7}},rotation=0)));
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
    Documentation(info="<html><p>Apply four independent operations to a Boolean command that is true during <code>[1,2)</code> s. Omission captures the rising edge and suppresses the whole command, even after its activation interval closes. The spurious command adds a pulse during <code>[0.5,0.75)</code> s.</p><p>The delayed command is true during <code>[1.2,2.2)</code> s and the duration-modified command during <code>[1,2.3)</code> s. Plot the four output connectors and inspect <code>effectActive</code> on the omission and duration components to distinguish a continuing command effect from the activation interval.</p></html>"));
end UnsafeCommandPatterns;
