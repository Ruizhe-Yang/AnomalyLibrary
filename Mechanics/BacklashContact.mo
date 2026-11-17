within AnomalyLibrary.Mechanics;
model BacklashContact "Symmetric compliant contact with a displacement gap"
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

  parameter Modelica.Units.SI.Position gap(min=0)=0.01 "Half-width of the unloaded relative-displacement interval";
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

  penetration=max(0,abs(displacement)-gap);
  reaction=effectLevel*(k*penetration+d*penetration/(smoothingLength+penetration)*max(0,sign(displacement)*relativeSpeed));
  effort=sign(displacement)*reaction;
  lossPower=effectLevel*d*penetration/(smoothingLength+penetration)*max(0,sign(displacement)*relativeSpeed)^2;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-100,-10},{-37,10}}, lineColor={64,64,64}, fillColor={215,215,215}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Rectangle(extent={{37,-10},{100,10}}, lineColor={64,64,64}, fillColor={215,215,215}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Line(points={{-37,-33},{-37,33},{-9,33},{-9,20}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{37,33},{37,-33},{9,-33},{9,-20}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-9,3},{9,3}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-9,-4},{-9,10}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{9,-4},{9,10}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-42,45},{42,75}}, textString="gap", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The relative displacement is <code>flange_b.s-flange_a.s</code>. Contact starts when its magnitude exceeds <code>gap</code>; penetration produces an elastic force, with damping only while penetration increases. <code>smoothingLength</code> regularises the damping near contact. The added force is zero at zero effect. Large stiffness and impact speed require suitable integration resolution.</p><p>Connect the two translational flanges and set the half-gap, contact stiffness and damping. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">MechanicalImpulseAndContact</a> for connections.</p></html>"));
end BacklashContact;
