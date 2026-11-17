within AnomalyLibrary.Mechanics;
model ForceImpulse "Rectangular force pulse with a specified impulse"
parameter Boolean enabled=false "Enable the configured disturbance";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the scheduled time window";
  parameter Real severity(min=0,max=1)=1 "Discrete activation selector, restricted to zero or one";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the scheduled activation window";
  final parameter Modelica.Units.SI.Time endTime=startTime+duration "Exclusive end of the scheduled activation window";
  final parameter Modelica.Units.SI.Time transitionTime=0 "Duration of a full-scale activation or recovery ramp";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Activation request state";
  output Real effectLevel "Severity scaled activation envelope";
  output Integer activationCount "Number of activation starts";

  parameter Boolean useSupport=false "Expose the reaction support";
  Modelica.Mechanics.Translational.Interfaces.Flange_b flange "Driven translational flange" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Translational.Interfaces.Support support if useSupport "Reaction support; a fixed reference is used when omitted" annotation(Placement(transformation(origin={0,-100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,-100},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Force applied "Force applied to the connected body";
  Modelica.Units.SI.Power externalPower "Signed power supplied to the connected system";
  parameter Real impulse(unit="N.s")=1 "Specified force impulse";
  parameter Modelica.Units.SI.Time duration(min=0)=0.1 "Duration of each rectangular pulse";


protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  Modelica.Units.SI.Position reference "Support position or fixed-world reference";
  discrete Modelica.Units.SI.Time began(start=0,fixed=true) "Start time of the most recent pulse";
  discrete Boolean seen(start=false,fixed=true) "An activation has started a pulse";
initial equation
  assert(duration>0,"Force impulse needs a positive duration.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  when {initial(),active} then began=time; seen=active; end when;

  applied=(if seen and time<began+duration then impulse/duration else 0);
  flange.f=-applied;
  if useSupport then
    support.f=applied;
    reference=support.s;
  else
    reference=0;
  end if;
  externalPower=applied*der(flange.s-reference);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-54,-37},{42,37}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{42,0},{100,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-7,-37},{-7,-61},{0,-61},{0,-100}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-36,0},{25,0}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-52,51},{-28,51},{-28,75},{11,75},{11,51},{44,51}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Each activation starts a pulse of magnitude <code>impulse/duration</code> in the positive flange direction. The pulse lasts <code>duration</code>, even if an external trigger ends earlier; another activation restarts the timer. <code>severity</code> is restricted to zero or one. The optional support carries the equal reaction; an omitted support uses a fixed reference. <code>externalPower</code> reports the supplied mechanical power.</p><p>Connect flange to the driven body, set impulse and duration, and expose support when needed. Set enabled=true and choose startTime or an external trigger.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">MechanicalImpulseAndContact</a> for connections.</p></html>"));
end ForceImpulse;
