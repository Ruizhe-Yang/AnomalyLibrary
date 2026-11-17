within AnomalyLibrary.Examples;
model MechanicalImpulseAndContact "Compare finite impulses with a unilateral mechanical stop"
  extends Modelica.Icons.Example;
  AnomalyLibrary.Mechanics.ForceImpulse force(enabled=true,startTime=1,duration=0.1,impulse=1) "Finite force impulse applied to the free mass" annotation(Placement(transformation(origin={-120,150},extent={{-16,-16},{16,16}},rotation=0)));
  Modelica.Mechanics.Translational.Components.Mass forceBody(m=2,s(start=0,fixed=true),v(start=0,fixed=true)) "Free mass receiving the force impulse" annotation(Placement(transformation(origin={105,150},extent={{-16,-16},{16,16}},rotation=0)));
  AnomalyLibrary.Mechanics.TorqueImpulse torque(enabled=true,startTime=1,duration=0.1,angularImpulse=0.2) "Finite torque impulse applied to the free inertia" annotation(Placement(transformation(origin={-120,35},extent={{-16,-16},{16,16}},rotation=0)));
  Modelica.Mechanics.Rotational.Components.Inertia torqueBody(J=0.5,phi(start=0,fixed=true),w(start=0,fixed=true)) "Free rotational inertia receiving the torque impulse" annotation(Placement(transformation(origin={105,35},extent={{-16,-16},{16,16}},rotation=0)));
  AnomalyLibrary.Mechanics.TranslationalForce push(enabled=true,startTime=0,endTime=5,transitionTime=0,force=0.3) "Continuous force driving the contact demonstration" annotation(Placement(transformation(origin={-228,-125},extent={{-16,-16},{16,16}},rotation=0)));
  Modelica.Mechanics.Translational.Components.Mass contactBody(m=1,s(start=0,fixed=true),v(start=0,fixed=true)) "Mass approaching the unilateral stop" annotation(Placement(transformation(origin={-90,-125},extent={{-16,-16},{16,16}},rotation=0)));
  AnomalyLibrary.Mechanics.UnilateralStop contact(enabled=true,startTime=0,endTime=6,transitionTime=0,gap=0.05,k=100,d=2) "Compliant compressive stop" annotation(Placement(transformation(origin={104,-125},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Mechanics.Translational.Components.Fixed stopReference "Fixed position of the stop" annotation(Placement(transformation(origin={233,-125},extent={{-12,-12},{12,12}},rotation=0)));
equation
  connect(force.flange,forceBody.flange_a) annotation(Line(points={{-104,150},{89,150}},color={0,127,0}));
  connect(torque.flange,torqueBody.flange_a) annotation(Line(points={{-104,35},{89,35}},color={0,0,0}));
  connect(push.flange,contactBody.flange_a) annotation(Line(points={{-212,-125},{-106,-125}},color={0,127,0}));
  connect(contactBody.flange_b,contact.flange_b) annotation(Line(points={{-74,-125},{126,-125},{121,-125}},color={0,127,0}));
  connect(contact.flange_a,stopReference.flange) annotation(Line(points={{87,-125},{82,-125},{233,-125}},color={0,127,0}));
  annotation(experiment(StartTime=0,StopTime=5,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p>Apply a 1 N.s force impulse to a 2 kg free mass and a 0.2 N.m.s torque impulse to a 0.5 kg.m2 inertia. The expected velocity increments are 0.5 m/s and 0.4 rad/s.</p><p>A separate force-driven mass approaches a compliant unilateral stop. Run the stored experiment and plot <code>forceBody.v</code>, <code>torqueBody.w</code> and <code>contact.reaction</code>. The stop develops a compressive reaction; it does not pull the mass towards the boundary.</p></html>"));
end MechanicalImpulseAndContact;
