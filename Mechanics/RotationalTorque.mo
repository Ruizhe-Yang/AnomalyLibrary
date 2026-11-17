within AnomalyLibrary.Mechanics;
model RotationalTorque "Prescribed external torque disturbance"
parameter Boolean enabled=false "Enable the configured disturbance";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the scheduled time window";
  parameter Real severity(min=0,max=1)=1 "Multiplier applied to the activation envelope";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the scheduled activation window";
  parameter Modelica.Units.SI.Time endTime=2 "Exclusive end of the scheduled activation window";
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05 "Duration of a full-scale activation or recovery ramp";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Activation request state";
  output Real effectLevel "Severity scaled activation envelope";
  output Integer activationCount "Number of activation starts";

  parameter Boolean useSupport=false "Expose the reaction support";
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Driven rotational flange" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Support support if useSupport "Reaction support; a fixed reference is used when omitted" annotation(Placement(transformation(origin={0,-100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,-100},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Torque applied "Torque applied to the connected shaft";
  Modelica.Units.SI.Power externalPower "Signed power supplied to the connected system";
  parameter Modelica.Units.SI.Torque torque=1 "Torque applied at full effect";


protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  Modelica.Units.SI.Angle reference "Support angle or fixed-world reference";

equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  applied=torque*effectLevel;
  flange.tau=-applied;
  if useSupport then
    support.tau=applied;
    reference=support.phi;
  else
    reference=0;
  end if;
  externalPower=applied*der(flange.phi-reference);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-54,-37},{42,37}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{42,0},{100,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-7,-37},{-7,-61},{0,-61},{0,-100}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-23,5},{-20,22},{1,29},{22,17},{25,-4},{9,-21},{-11,-20}}, color={64,64,64}, thickness=1.1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-43,76},{37,48}}, textString="tau", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The applied torque is <code>torque*effectLevel</code>; positive torque acts in the positive flange coordinate. The source flange carries the opposite connector torque. An exposed support carries the equal reaction; otherwise the reference angle is fixed at zero. <code>externalPower</code> reports signed power relative to that reference.</p><p>Connect flange to the driven shaft and enable useSupport when its reaction must be modelled. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">MechanicalImpulseAndContact</a> for connections.</p></html>"));
end RotationalTorque;
