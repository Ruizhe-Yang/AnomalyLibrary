within AnomalyLibrary.Signals;
block Dropout "Replace an unavailable signal with an explicit fallback"
parameter Boolean enabled=false "Enable the anomaly";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the internal activation window";
  parameter Real severity(min=0,max=1)=1 "Requested severity between zero and one";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the internal activation window";
  parameter Modelica.Units.SI.Time endTime=2 "Exclusive end of the internal activation window";
  final parameter Modelica.Units.SI.Time transitionTime=0 "Duration of a full rise or fall in the activation level";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Anomaly activation is currently requested";
  output Real effectLevel "Severity-scaled activation and recovery level";
  output Integer activationCount "Number of activation onsets";
  parameter Real fallbackValue=0 "Value supplied during an imposed dropout";
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput valid "The current output is transmitted from u rather than a fallback" annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
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
  valid=not active;
  y=if valid then u else fallbackValue;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-57,14},{-23,14},{-23,-32},{25,-32},{25,30},{60,30}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{-23,14},{25,30}}, color={160,160,164}, thickness=0.7, pattern=LinePattern.Dash),
        Line(points={{-8,6},{10,24}}, color={191,0,0}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{-8,24},{10,6}}, color={191,0,0}, thickness=1.4, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="fallback", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>While active, <code>y=fallbackValue</code> and <code>valid=false</code>. Otherwise, <code>y=u</code> and <code>valid=true</code>. This flag identifies the imposed dropout; it does not assess the numerical quality of the original input.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end Dropout;
