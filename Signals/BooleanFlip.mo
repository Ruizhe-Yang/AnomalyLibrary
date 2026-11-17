within AnomalyLibrary.Signals;
block BooleanFlip "Invert a Boolean signal during activation"
parameter Boolean enabled=false "Enable the anomaly";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the internal activation window";
  parameter Real severity(min=0,max=1)=1 "Requested severity between zero and one";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the internal activation window";
  parameter Modelica.Units.SI.Time endTime=2 "Exclusive end of the internal activation window";
  final parameter Modelica.Units.SI.Time transitionTime=0 "Duration of a full rise or fall in the activation level";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Anomaly activation is currently requested";
  output Real effectLevel "Severity-scaled activation and recovery level";
  output Integer activationCount "Number of activation onsets";

  Modelica.Blocks.Interfaces.BooleanInput u "Nominal Boolean command" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y "Resulting Boolean command" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation

  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  y=if active then not u else u;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-68,0},{-47,0}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Polygon(points={{-47,-39},{-47,39},{31,0},{-47,-39}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Ellipse(extent={{31,-8},{47,8}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{47,0},{68,0}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-58,-73},{58,-47}}, textString="0  1", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The output is <code>not u</code> while <code>active</code> and <code>u</code> otherwise. Both activation and recovery are instantaneous.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end BooleanFlip;
