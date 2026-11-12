within AnomalyLibrary.Signals;
block CommandDuration "Replace accepted commands with pulses of declared duration"
parameter Boolean enabled=false;
  parameter Boolean useExternalTrigger=false;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time startTime=1;
  parameter Modelica.Units.SI.Time endTime=2;
  final parameter Modelica.Units.SI.Time transitionTime=0;
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active;
  output Real effectLevel;
  output Integer activationCount;

  parameter Modelica.Units.SI.Time nominalDuration(min=0)=1;
  parameter Real durationFactor(min=0)=1.3;
  output Boolean effectActive;

  Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);
  discrete Boolean replaces(start=false,fixed=true);
  discrete Modelica.Units.SI.Time pulseStop(start=0,fixed=true);
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
    Documentation(info="<html><p><b>Purpose</b> Replace accepted commands with pulses of declared duration.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; output Boolean effectActive; Modelica.Blocks.Interfaces.BooleanInput u; Modelica.Blocks.Interfaces.BooleanOutput y</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; final parameter Modelica.Units.SI.Time transitionTime=0; parameter Modelica.Units.SI.Time nominalDuration(min=0)=1; parameter Real durationFactor(min=0)=1.3</p><p><b>Behavior</b> Replace accepted commands with pulses of declared duration</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The optional trigger replaces the internal half-open window. A new activation updates the declared capture or command state.</p><p><b>Limitations</b> Input and output use the same units. The operation is deterministic.</p><p><b>Observables</b> active, effectLevel, activationCount, effectActive, y</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.UnsafeCommandPatterns\">AnomalyLibrary.Examples.UnsafeCommandPatterns</a></p></html>"));
end CommandDuration;
