within AnomalyLibrary.Signals;
block CommandOmission "Suppress commands accepted during activation"
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
  output Boolean effectActive "An accepted command modification is currently in effect";
  Modelica.Blocks.Interfaces.BooleanInput u "Nominal Boolean command" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y "Resulting Boolean command" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  discrete Boolean omitted(start=false,fixed=true) "The current command was accepted for omission";
initial equation

  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  when {initial(),u} then omitted=u and active; end when;
  effectActive=u and omitted;
  y=u and not omitted;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-53,22},{-23,22},{-23,49},{22,49},{22,22},{53,22}}, color={128,128,128}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-58,-25},{58,-25}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-13,23},{13,49}}, color={191,0,0}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-13,49},{13,23}}, color={191,0,0}, thickness=1.1, pattern=LinePattern.Solid),
        Text(extent={{-48,-47},{48,-72}}, textString="omit", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>An input rising edge received while <code>active</code> suppresses the complete true interval of that command. An initially true input is also considered at initialisation. Starting activation during an already high input does not newly accept that command.</p><p>An accepted omission remains in force until the input becomes false, even if the activation window closes first. <code>effectActive</code> distinguishes an ongoing omission from the activation request.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end CommandOmission;
