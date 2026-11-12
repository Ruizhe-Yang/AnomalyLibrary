within AnomalyLibrary.CrossDomain;
block ImpactMeasurementBias "Filter an explicit shock signal into an additive measurement bias"
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

  parameter Modelica.Units.SI.Time T(min=0)=0.1;
  parameter Real kShock=1;
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput shock annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Real bias(start=0,fixed=true);
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

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
    Documentation(info="<html><p><b>Purpose</b> Filter an explicit shock signal into an additive measurement bias.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.RealInput shock; Modelica.Blocks.Interfaces.RealOutput y</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Modelica.Units.SI.Time T(min=0)=0.1; parameter Real kShock=1</p><p><b>Behavior</b> Filter an explicit shock signal into an additive measurement bias</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. The shock is a signal input. kShock converts its units to the measurement units.</p><p><b>Observables</b> active, effectLevel, activationCount, y</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.CrossDomainEffects\">AnomalyLibrary.Examples.CrossDomainEffects</a></p></html>"));
end ImpactMeasurementBias;
