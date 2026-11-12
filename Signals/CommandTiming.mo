within AnomalyLibrary.Signals;
block CommandTiming "Apply a nonnegative online delay or a signed shift to a known plan"
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

  parameter Boolean useTimeTable=false;
  parameter Modelica.Units.SI.Time delayTime(min=0)=0.2;
  parameter Modelica.Units.SI.Time signedShift=0;
  parameter Integer nTimes(min=1)=2;
  parameter Modelica.Units.SI.Time timeTable[nTimes]={i for i in 1:nTimes};

  Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

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
    Documentation(info="<html><p><b>Purpose</b> Apply a nonnegative online delay or a signed shift to a known plan.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Blocks.Interfaces.BooleanInput u; Modelica.Blocks.Interfaces.BooleanOutput y</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; final parameter Modelica.Units.SI.Time transitionTime=0; parameter Boolean useTimeTable=false; parameter Modelica.Units.SI.Time delayTime(min=0)=0.2; parameter Modelica.Units.SI.Time signedShift=0; parameter Integer nTimes(min=1)=2; parameter Modelica.Units.SI.Time timeTable[nTimes]={i for i in 1:nTimes}</p><p><b>Behavior</b> Apply a nonnegative online delay or a signed shift to a known plan</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The optional trigger replaces the internal half-open window. A new activation updates the declared capture or command state.</p><p><b>Limitations</b> Input and output use the same units. The operation is deterministic.</p><p><b>Observables</b> active, effectLevel, activationCount, y</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.UnsafeCommandPatterns\">AnomalyLibrary.Examples.UnsafeCommandPatterns</a></p></html>"));
end CommandTiming;
