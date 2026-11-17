within AnomalyLibrary.CrossDomain;
model PressureForce "External force from a prescribed pressure difference"
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
  Modelica.Mechanics.Translational.Interfaces.Flange_b flange "Driven translational flange" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Translational.Interfaces.Support support if useSupport "Reaction support; a fixed reference is used when omitted" annotation(Placement(transformation(origin={0,-100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,-100},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Force applied "Force applied to the connected body";
  Modelica.Units.SI.Power externalPower "Signed power supplied to the connected system";
  parameter Modelica.Units.SI.Area A(min=0)=1e-4 "Effective area loaded by the prescribed pressure difference";
  Modelica.Blocks.Interfaces.RealInput dp(unit="Pa") "Prescribed pressure difference acting on area A" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  Modelica.Units.SI.Position reference "Support position or fixed-world reference";

initial equation
  assert(A>=0,"Negative piston area.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  applied=(A*dp)*effectLevel;
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
        Rectangle(extent={{-41,-33},{27,33}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{8,-28},{8,28}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{8,0},{100,0}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-72,65},{-15,40}}, textString="dp", textColor={64,64,64}, fontSize=0),
        Line(points={{-23,13},{-3,13}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-23,-13},{-3,-13}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-22,-34},{-22,-61},{0,-61},{0,-100}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-67,-49},{-30,-73}}, textString="A", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The force applied along the positive flange coordinate is <code>A*dp*effectLevel</code>. An exposed support carries the equal reaction; otherwise a fixed reference is used. Pressure is an input signal: this model contains no fluid volume or fluid-side energy balance. <code>externalPower</code> reports the signed mechanical power supplied by the prescribed load.</p><p>Supply dp, set the effective area A and connect the translational flange and optional support. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.CrossDomainEffects\">CrossDomainEffects</a> for connections.</p></html>"));
end PressureForce;
