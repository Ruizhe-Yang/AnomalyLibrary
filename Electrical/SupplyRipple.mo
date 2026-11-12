within AnomalyLibrary.Electrical;
model SupplyRipple "Insert a sinusoidal series voltage disturbance"
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

  Modelica.Electrical.Analog.Interfaces.PositivePin p annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

  Modelica.Units.SI.Voltage v;
  Modelica.Units.SI.Current i;
  Modelica.Units.SI.Power lossPower;

  parameter Modelica.Units.SI.Voltage amplitude(min=0)=1;
  parameter Modelica.Units.SI.Frequency frequency(min=0)=10;
  parameter Modelica.Units.SI.Angle phase=0;
  Modelica.Units.SI.Power externalPower;
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

initial equation
  assert(frequency>=0 and amplitude>=0,"Invalid ripple parameters.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  v=p.v-n.v;
  i=p.i;
  n.i=-i;
  v=effectLevel*amplitude*sin(2*Modelica.Constants.pi*frequency*(time-startTime)+phase);
  lossPower=0;
  externalPower=-v*i;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-42,0}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Ellipse(extent={{-42,-42},{42,42}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{42,0},{100,0}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-30,0},{-28.5,2.82},{-27,5.56},{-25.5,8.17},{-24,10.58},{-22.5,12.73},{-21,14.56},{-19.5,16.04},{-18,17.12},{-16.5,17.78},{-15,18},{-13.5,17.78},{-12,17.12},{-10.5,16.04},{-9,14.56},{-7.5,12.73},{-6,10.58},{-4.5,8.17},{-3,5.56},{-1.5,2.82},{0,0},{1.5,-2.82},{3,-5.56},{4.5,-8.17},{6,-10.58},{7.5,-12.73},{9,-14.56},{10.5,-16.04},{12,-17.12},{13.5,-17.78},{15,-18},{16.5,-17.78},{18,-17.12},{19.5,-16.04},{21,-14.56},{22.5,-12.73},{24,-10.58},{25.5,-8.17},{27,-5.56},{28.5,-2.82},{30,0}}, color={0,0,255}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="~ V", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Insert a sinusoidal series voltage disturbance.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Electrical.Analog.Interfaces.PositivePin p; Modelica.Electrical.Analog.Interfaces.NegativePin n</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Modelica.Units.SI.Voltage amplitude(min=0)=1; parameter Modelica.Units.SI.Frequency frequency(min=0)=10; parameter Modelica.Units.SI.Angle phase=0</p><p><b>Behavior</b> Insert a sinusoidal series voltage disturbance</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. The carrier is sinusoidal. A finite or partial-cycle envelope may have a nonzero average.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">AnomalyLibrary.Examples.ElectricalDisturbances</a></p></html>"));
end SupplyRipple;
