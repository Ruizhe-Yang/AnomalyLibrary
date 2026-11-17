within AnomalyLibrary.Signals;
block CommandDuration "Replace accepted commands with pulses of a specified duration"
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

  parameter Modelica.Units.SI.Time nominalDuration(min=0)=1 "Reference command duration";
  parameter Real durationFactor(min=0)=1.3 "Multiplier applied to the reference command duration";
  output Boolean effectActive "An accepted command modification is currently in effect";

  Modelica.Blocks.Interfaces.BooleanInput u "Nominal Boolean command" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y "Resulting Boolean command" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  discrete Boolean replaces(start=false,fixed=true) "The current command was accepted for replacement";
  discrete Modelica.Units.SI.Time pulseStop(start=0,fixed=true) "Scheduled end of the accepted replacement pulse";
initial equation
  assert(nominalDuration>0 and durationFactor>=0,"Invalid command duration.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  when {initial(),u} then
    replaces=u and active;
    pulseStop=if u and active then max(if initial() then time else pre(pulseStop),time+durationFactor*nominalDuration)
      else if initial() then time else pre(pulseStop);
  end when;
  effectActive=time<pulseStop;
  y=effectActive or (u and not replaces);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-63,34},{-33,34},{-33,59},{10,59},{10,34},{64,34}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-63,-25},{-33,-25},{-33,0},{43,0},{43,-25},{64,-25}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{10,-42},{43,-42}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{1,-49},{50,-72}}, textString="T", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>An input rising edge accepted while <code>active</code> replaces that command with a pulse lasting <code>durationFactor*nominalDuration</code>. An initially true input is also considered at initialisation. The original command remains suppressed even if it stays true after the replacement pulse ends.</p><p>Accepted pulses can outlast the activation window; overlapping pulses extend the output to the latest scheduled end. <code>effectActive</code> indicates a replacement pulse currently in progress. A zero duration factor omits the accepted command.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end CommandDuration;
