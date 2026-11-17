within AnomalyLibrary.Signals;
block Drift "Add a bounded drift that restarts on each activation"
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

  parameter Real driftRate=0.1 "Signed drift rate in input units per second";
  parameter Real maxAbsDrift(min=0)=1 "Maximum absolute drift in the input signal unit";
  Real drift "Current bounded drift before severity scaling";

  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

  discrete Modelica.Units.SI.Time began(start=0,fixed=true) "Start of the current activation";
  discrete Real atExit(start=0,fixed=true) "Drift captured at the latest deactivation";
initial equation
  assert(maxAbsDrift>=0,"Negative drift bound.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  when {initial(),change(active)} then
    began=if initial() or active then time else pre(began);
    atExit=if initial() or active then 0 else min(maxAbsDrift,max(-maxAbsDrift,driftRate*(time-pre(began))));
  end when;
  drift=if active then min(maxAbsDrift,max(-maxAbsDrift,driftRate*(time-began))) else atExit;
  y=u+effectLevel*drift;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58,-26},{-20,-26},{31,37},{60,37}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-58,37},{60,37}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Text(extent={{-58,72},{62,48}}, textString="bound", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The signed drift grows as <code>driftRate</code> times the elapsed time since activation and is limited to <code>±maxAbsDrift</code>. The output is <code>u + effectLevel*drift</code>. Each activation restarts the drift from zero; its value at deactivation is retained during the recovery ramp.</p><p>Set <code>enabled=true</code> to enable the effect. The internal activation window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. The severity-scaled <code>effectLevel</code> rises and falls over <code>transitionTime</code>, so the output may recover after <code>active</code> becomes false.</p></html>"));
end Drift;
