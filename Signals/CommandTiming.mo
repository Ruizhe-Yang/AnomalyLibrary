within AnomalyLibrary.Signals;
block CommandTiming "Delay an online command or shift a declared switching plan"
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

  parameter Boolean useTimeTable=false "Generate an active switching plan instead of delaying u";
  parameter Modelica.Units.SI.Time delayTime(min=0)=0.2 "Non-negative delay applied while active";
  parameter Modelica.Units.SI.Time signedShift=0 "Signed time shift applied to the known switching plan";
  parameter Integer nTimes(min=1)=2 "Number of configured switching or pulse instants";
  parameter Modelica.Units.SI.Time timeTable[nTimes]={i for i in 1:nTimes} "Increasing absolute switching times of the known plan";

  Modelica.Blocks.Interfaces.BooleanInput u "Nominal Boolean command" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y "Resulting Boolean command" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(delayTime>=0,"Online delay cannot be negative.");
  for i in 2:nTimes loop assert(timeTable[i]>timeTable[i-1],"Known plan times must increase."); end for;
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  y=if not active then u elseif useTimeTable then mod(sum(if time>=timeTable[i]+signedShift then 1 else 0 for i in 1:nTimes),2)==1
    elseif delayTime>0 then delay(if u then 1.0 else 0.0,delayTime,delayTime)>0.5 else u;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-63,32},{-39,32},{-39,56},{9,56},{9,32},{62,32}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-63,-25},{-8,-25},{-8,-1},{40,-1},{40,-25},{62,-25}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-39,12},{-8,12}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-51,-46},{51,-72}}, textString="dt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>With <code>useTimeTable=false</code>, activation selects the input history delayed by the non-negative <code>delayTime</code>. With <code>useTimeTable=true</code>, the output alternates false/true at the absolute instants <code>timeTable + signedShift</code>; <code>u</code> is not used to generate that active plan.</p><p>A negative <code>signedShift</code> advances a known plan, not an unknown live input. Outside activation, <code>y</code> follows the current <code>u</code>, so changing modes may cause an immediate Boolean transition.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end CommandTiming;
