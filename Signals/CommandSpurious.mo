within AnomalyLibrary.Signals;
block CommandSpurious "Schedule complete unintended pulses at configured times"
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

  parameter Integer nTimes(min=1)=1;
  parameter Modelica.Units.SI.Time extraTimes[nTimes]={0.5*i for i in 1:nTimes};
  parameter Modelica.Units.SI.Time pulseWidth(min=0)=0.25;
  output Boolean effectActive;

  Modelica.Blocks.Interfaces.BooleanInput u annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);
  discrete Boolean accepted[nTimes](each start=false,each fixed=true);
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
    Documentation(info="<html><p><b>Purpose</b> Schedule complete unintended pulses at configured times.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; output Boolean effectActive; Modelica.Blocks.Interfaces.BooleanInput u; Modelica.Blocks.Interfaces.BooleanOutput y</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; final parameter Modelica.Units.SI.Time transitionTime=0; parameter Integer nTimes(min=1)=1; parameter Modelica.Units.SI.Time extraTimes[nTimes]={0.5*i for i in 1:nTimes}; parameter Modelica.Units.SI.Time pulseWidth(min=0)=0.25</p><p><b>Behavior</b> Schedule complete unintended pulses at configured times</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The optional trigger replaces the internal half-open window. A new activation updates the declared capture or command state.</p><p><b>Limitations</b> Input and output use the same units. The operation is deterministic.</p><p><b>Observables</b> active, effectLevel, activationCount, effectActive, y</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.UnsafeCommandPatterns\">AnomalyLibrary.Examples.UnsafeCommandPatterns</a></p></html>"));
end CommandSpurious;
