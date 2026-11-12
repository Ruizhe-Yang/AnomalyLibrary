within AnomalyLibrary.Signals;
block Drift "Accumulate and bound a fresh drift on each activation"
parameter Boolean enabled=false;
  parameter Boolean useExternalTrigger=false;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time startTime=1;
  parameter Modelica.Units.SI.Time endTime=2;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05;
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active;
  output Real effectLevel;
  output Integer activationCount;

  parameter Real driftRate=0.1 "Input units per second";
  parameter Real maxAbsDrift(min=0)=1;
  Real drift;

  Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

  discrete Modelica.Units.SI.Time began(start=0,fixed=true);
  discrete Real atExit(start=0,fixed=true);
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
    Documentation(info="<html><p><b>Purpose</b> Accumulate and bound a fresh drift on each activation.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.RealOutput y</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Real driftRate=0.1 \"Input units per second\"; parameter Real maxAbsDrift(min=0)=1</p><p><b>Behavior</b> Accumulate and bound a fresh drift on each activation</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The optional trigger replaces the internal half-open window. A new activation updates the declared capture or command state.</p><p><b>Limitations</b> Input and output use the same units. The operation is deterministic.</p><p><b>Observables</b> active, effectLevel, activationCount, y</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">AnomalyLibrary.Examples.SignalDeviationAndRecovery</a></p></html>"));
end Drift;
