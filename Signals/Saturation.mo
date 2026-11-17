within AnomalyLibrary.Signals;
block Saturation "Blend a real signal towards configured saturation limits"
parameter Boolean enabled=false "Enable the anomaly";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the internal activation window";
  parameter Real severity(min=0,max=1)=1 "Requested severity between zero and one";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the internal activation window";
  parameter Modelica.Units.SI.Time endTime=2 "Exclusive end of the internal activation window";
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05 "Duration of a full rise or fall in the activation level";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Anomaly activation is currently requested";
  output Real effectLevel "Severity-scaled activation and recovery level";
  output Integer activationCount "Number of activation onsets";
  parameter Real lower=-1 "Lower saturation limit in the input signal unit";
  parameter Real upper=1 "Upper saturation limit in the input signal unit";
  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(lower<=upper,"Reversed saturation limits.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  y=u+effectLevel*(min(upper,max(lower,u))-u);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,0},{68,0}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{0,-55},{0,58}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-61,-35},{-33,-35},{33,35},{61,35}}, color={0,0,255}, thickness=1.5, pattern=LinePattern.Solid),
        Line(points={{-58,35},{61,35}}, color={160,160,164}, thickness=0.6, pattern=LinePattern.Dash),
        Line(points={{-61,-35},{58,-35}}, color={160,160,164}, thickness=0.6, pattern=LinePattern.Dash),
        Text(extent={{-67,-74},{67,-49}}, textString="limit", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The saturation target is <code>min(upper,max(lower,u))</code>. The actual output interpolates between <code>u</code> and that target according to <code>effectLevel</code>. Intermediate severity or a transition can leave the output outside the target limits.</p><p>Set <code>enabled=true</code> to enable the effect. The internal activation window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. The severity-scaled <code>effectLevel</code> rises and falls over <code>transitionTime</code>, so the output may recover after <code>active</code> becomes false.</p></html>"));
end Saturation;
