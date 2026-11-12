within AnomalyLibrary.Utilities.Internal;
block Activation "Reversible ramp and optional permanent activation latch"
parameter Boolean enabled=true;
  parameter Boolean permanent=false;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time startTime=1;
  parameter Modelica.Units.SI.Time endTime=3;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05;
  parameter Boolean useExternalTrigger=false;
  Modelica.Blocks.Interfaces.BooleanInput externalTrigger annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  output Boolean active;
  output Real effectLevel(min=0,max=1);
  output Integer activationCount(start=0,fixed=true);
protected
  Boolean request;
  discrete Boolean latched(start=false,fixed=true);
  discrete Real fromLevel(start=0,fixed=true);
  discrete Modelica.Units.SI.Time edgeTime(start=0,fixed=true);
  Real level;
initial equation
  assert(severity>=0 and severity<=1,"Severity outside [0,1].");
  assert(endTime>=startTime,"End time precedes start time.");
  assert(transitionTime>=0,"Negative transition duration.");
equation
  request=enabled and severity>0 and (if useExternalTrigger then externalTrigger else time>=startTime and time<endTime);
  when {initial(),request} then
    latched=(if initial() then false else pre(latched)) or (permanent and request);
  end when;
  active=request or latched;
  when {initial(),change(active)} then
    fromLevel=if initial() or transitionTime<=0 then 0 else
      min(1,max(0,pre(fromLevel)+(if pre(active) then 1 else -1)*(time-pre(edgeTime))/transitionTime));
    edgeTime=time;
    activationCount=(if initial() then 0 else pre(activationCount))+(if active then 1 else 0);
  end when;
  level=if transitionTime<=0 then (if active then 1 else 0) else
    min(1,max(0,fromLevel+(if active then 1 else -1)*(time-edgeTime)/transitionTime));
  effectLevel=severity*level;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-59,-28},{-37,-28},{-16,36},{20,36},{40,-28},{61,-28}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{20,36},{62,36}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Reversible ramp and optional permanent activation latch.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput externalTrigger; output Boolean active; output Real effectLevel(min=0,max=1); output Integer activationCount(start=0,fixed=true)</p><p><b>Parameters</b> parameter Boolean enabled=true; parameter Boolean permanent=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=3; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Boolean useExternalTrigger=false</p><p><b>Behavior</b> The target is the current trigger state. A ramp reversal continues from the current level. Permanent mode latches the first active request.</p><p><b>Initialization</b> An initial true trigger counts as the first activation. Positive-duration ramps begin at zero.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Zero-width internal windows are empty. An external trigger replaces the internal window.</p><p><b>Observables</b> active, effectLevel, activationCount</p></html>"));
end Activation;
