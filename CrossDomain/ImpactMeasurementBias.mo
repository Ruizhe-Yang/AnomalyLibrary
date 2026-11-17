within AnomalyLibrary.CrossDomain;
block ImpactMeasurementBias "Filtered shock contribution to a measurement bias"
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

  parameter Modelica.Units.SI.Time T(min=0)=0.1 "Time constant of the shock-to-bias filter";
  parameter Real kShock=1 "Gain from the shock signal to the asymptotic bias";
    Modelica.Blocks.Interfaces.RealInput u "Unmodified measurement input" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput shock "Prescribed shock signal" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Measurement with the activated filtered bias" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Real bias(start=0,fixed=true) "Filtered bias state";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(T>0,"Shock filter time must be positive.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  T*der(bias)=kShock*shock-bias;
  y=u+effectLevel*bias;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-66,41},{-50,41},{-39,70},{-26,41},{-10,41}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Rectangle(extent={{-3,26},{30,57}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{1,52},{26,31}}, textString="T", textColor={64,64,64}, fontSize=0),
        Line(points={{-10,41},{-3,41}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{28,-29},{69,12}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{38,-8},{59,-8}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{49,-18},{49,3}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-63,-8},{28,-8}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{14,26},{14,19},{49,19},{49,12}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>The internal state follows <code>T*der(bias)=kShock*shock-bias</code> from an initial value of zero. The output is <code>y=u+effectLevel*bias</code>. Filtering continues while the disturbance is inactive, so a later activation can expose an existing bias state. <code>T</code> must be positive; <code>kShock</code> supplies the scaling between the shock signal and measurement unit.</p><p>Connect the original measurement to u and the shock signal to shock; take the disturbed measurement from y. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.CrossDomainEffects\">CrossDomainEffects</a> for connections.</p></html>"));
end ImpactMeasurementBias;
