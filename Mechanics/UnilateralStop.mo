within AnomalyLibrary.Mechanics;
model UnilateralStop "Compliant stop at a one-sided displacement limit"
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

  Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a "First translational flange" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Translational.Interfaces.Flange_b flange_b "Second translational flange" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Real displacement(unit="m") "Position of flange_b relative to flange_a";
  Real relativeSpeed(unit="m/s") "Relative translational velocity";
  Real effort(unit="N") "Force entering flange_b";
  Modelica.Units.SI.Power lossPower "Power dissipated by damping";

  parameter Modelica.Units.SI.Position gap(min=0)=0.01 "Positive relative-displacement limit at which contact starts";
  parameter Real k(min=0,unit="N/m")=1000 "Contact stiffness";
  parameter Real d(min=0,unit="N.s/m")=10 "Viscous damping coefficient";
  parameter Modelica.Units.SI.Length smoothingLength(min=0)=0.001 "Penetration scale used to regularise contact damping";
  Real penetration(unit="m") "Nonnegative penetration beyond the contact boundary";
  Real reaction(unit="N") "Nonnegative contact-force magnitude";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(gap>=0 and k>=0 and d>=0 and smoothingLength>0,"Invalid contact coefficients.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  displacement=flange_b.s-flange_a.s;
  relativeSpeed=der(displacement);
  flange_b.f=effort;
  flange_a.f=-effort;

  penetration=max(0,displacement-gap);
  reaction=effectLevel*(k*penetration+d*penetration/(smoothingLength+penetration)*max(0,relativeSpeed));
  effort=reaction;
  lossPower=effectLevel*d*penetration/(smoothingLength+penetration)*max(0,relativeSpeed)^2;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-42,0}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Rectangle(extent={{-42,-30},{-8,30}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Line(points={{28,-48},{28,48}}, color={64,64,64}, thickness=2, pattern=LinePattern.Solid),
        Line(points={{28,0},{100,0}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{28,-43},{46,-29}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{28,-22},{46,-8}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{28,-1},{46,13}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{28,20},{46,34}}, color={160,160,164}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-6,56},{26,56}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-8,57},{28,80}}, textString="s", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Contact occurs when <code>flange_b.s-flange_a.s</code> exceeds <code>gap</code>. Penetration produces an elastic reaction; damping acts only while penetration increases and is regularised by <code>smoothingLength</code>. The added force is zero at zero effect. This is a finite-stiffness contact, not an ideal position constraint.</p><p>Connect the two translational flanges and set the positive relative-displacement limit gap. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">MechanicalImpulseAndContact</a> for connections.</p></html>"));
end UnilateralStop;
