within AnomalyLibrary.Signals;
block CommandSpurious "Add scheduled unintended Boolean pulses"
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

  parameter Integer nTimes(min=1)=1 "Number of configured switching or pulse instants";
  parameter Modelica.Units.SI.Time extraTimes[nTimes]={0.5*i for i in 1:nTimes} "Absolute start times of the additional pulses";
  parameter Modelica.Units.SI.Time pulseWidth(min=0)=0.25 "Duration of each accepted additional pulse";
  output Boolean effectActive "An accepted command modification is currently in effect";

  Modelica.Blocks.Interfaces.BooleanInput u "Nominal Boolean command" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y "Resulting Boolean command" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  discrete Boolean accepted[nTimes](each start=false,each fixed=true) "Whether each scheduled pulse was accepted";
initial equation
  assert(pulseWidth>0 and nTimes>=1,"Invalid spurious pulse settings.");
  for i in 2:nTimes loop assert(extraTimes[i]>extraTimes[i-1],"Pulse times must increase."); end for;
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  for i in 1:nTimes loop
    when {initial(),time>=extraTimes[i]} then
      accepted[i]=active and time>=extraTimes[i] and time<extraTimes[i]+pulseWidth;
    end when;
  end for;
  effectActive=sum(if accepted[i] and time<extraTimes[i]+pulseWidth then 1 else 0 for i in 1:nTimes)>0;
  y=u or effectActive;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-60,41},{60,41}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-53,-23},{-23,-23},{-23,9},{22,9},{22,-23},{53,-23}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-2,50},{-2,66}}, color={191,0,0}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-10,58},{6,58}}, color={191,0,0}, thickness=0.9, pattern=LinePattern.Solid),
        Text(extent={{-48,-46},{48,-71}}, textString="extra", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Each absolute time in <code>extraTimes</code> starts a pulse of width <code>pulseWidth</code> if the anomaly is active at that scheduled instant. At initialisation, a scheduled pulse is accepted only if its interval currently contains the simulation time. The output is the logical OR of <code>u</code> and the accepted pulses.</p><p>Accepted pulses run to their scheduled ends after deactivation, and overlaps merge through the OR operation. Configure increasing <code>extraTimes</code> within an active window; the default first pulse time precedes the default activation window.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end CommandSpurious;
