within AnomalyLibrary.Signals;
block Delay "Select a fixed history delay for a real signal"
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

  parameter Modelica.Units.SI.Time delayTime(min=0)=0.2 "Non-negative delay applied while active";

  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(delayTime>=0,"Negative signal delay.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  y=if active and delayTime>0 then delay(u,delayTime,delayTime) else u;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-57,-30},{-32,-30},{-32,34},{59,34}}, color={160,160,164}, thickness=0.7, pattern=LinePattern.Dash),
        Line(points={{-57,-30},{12,-30},{12,34},{59,34}}, color={0,0,255}, thickness=1.5, pattern=LinePattern.Solid),
        Line(points={{-32,-4},{12,-4}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-26,-27},{4,-7}}, textString="T", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>While active, the output uses the Modelica <code>delay</code> operator with the fixed <code>delayTime</code>. A zero delay or inactive anomaly gives <code>y=u</code>. The delay uses input history and does not capture a constant value on activation.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end Delay;
