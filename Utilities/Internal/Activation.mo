within AnomalyLibrary.Utilities.Internal;
block Activation "Generate a reversible activation level with optional latching"
parameter Boolean enabled=true "Enable activation requests";
  parameter Boolean permanent=false "Latch the first activation request";
  parameter Real severity(min=0,max=1)=1 "Maximum effect level";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive internal activation start";
  parameter Modelica.Units.SI.Time endTime=3 "Exclusive internal activation end";
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05 "Time for a full unit-level transition";
  parameter Boolean useExternalTrigger=false "Use the external trigger instead of the internal interval";
  Modelica.Blocks.Interfaces.BooleanInput externalTrigger "External activation request" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  output Boolean active "Activation state before transition shaping";
  output Real effectLevel(min=0,max=1) "Severity-scaled activation level";
  output Integer activationCount(start=0,fixed=true) "Number of activation starts, including initial activation";
protected
  Boolean request "Enabled request before permanent latching";
  discrete Boolean latched(start=false,fixed=true) "Permanent activation state";
  discrete Real fromLevel(start=0,fixed=true) "Unit level at the most recent state change";
  discrete Modelica.Units.SI.Time edgeTime(start=0,fixed=true) "Time of the most recent activation state change";
  Real level "Unit activation level before severity scaling";
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
    Documentation(info="<html><p>Generate <code>active</code>, a severity-scaled <code>effectLevel</code> and an activation count. The internal request uses the half-open interval <code>[startTime,endTime)</code>. With <code>useExternalTrigger=true</code>, <code>externalTrigger</code> replaces that interval. An enabled request also requires positive severity.</p><p>A positive <code>transitionTime</code> gives a linear rise or fall at unit level per transition time; a reversal continues from the current level. Initial ramps start at zero. With zero transition time, the level changes immediately. <code>permanent=true</code> latches the first request. An initially active request counts as one activation; an empty internal interval produces no request.</p></html>"));
end Activation;
