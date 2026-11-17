within AnomalyLibrary.Signals;
block Quantization "Quantise a real signal with half steps rounded away from zero"
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
  parameter Real q(min=0)=0.1 "Strictly positive quantisation step in the input signal unit";
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(q>0,"Quantization step must be positive.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  y=if active then sign(u)*q*floor(abs(u)/q+0.5) else u;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,0},{68,0}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{0,-55},{0,58}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-59,-40},{-40,-40},{-40,-22},{-20,-22},{-20,0},{0,0},{0,20},{20,20},{20,40},{52,40}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="q", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>During activation, the output is <code>sign(u)*q*floor(abs(u)/q + 0.5)</code>. Thus values are rounded to the nearest zero-centred grid point, with ties away from zero. The inactive output follows <code>u</code> directly.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end Quantization;
