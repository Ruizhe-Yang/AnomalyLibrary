within AnomalyLibrary.Signals;
block RateLimit "Limit the output slope during activation"
parameter Boolean enabled=false "Enable the anomaly";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the internal activation window";
  parameter Real severity(min=0,max=1)=1 "Requested severity between zero and one";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the internal activation window";
  parameter Modelica.Units.SI.Time endTime=2 "Exclusive end of the internal activation window";
  final parameter Modelica.Units.SI.Time transitionTime=0 "Duration of a full rise or fall in the activation level";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Anomaly activation is currently requested";
  output Real effectLevel "Severity-scaled activation and recovery level";
  output Integer activationCount "Number of activation onsets";

  parameter Real riseRate(min=0)=1 "Maximum rising slope in input units per second";
  parameter Real fallRate(min=0)=1 "Magnitude of the maximum falling slope in input units per second";
  parameter Modelica.Units.SI.Time trackingTime(min=0)=0.01 "Positive time constant of the rate-limited tracking state";

  Modelica.Blocks.Interfaces.RealInput u "Nominal input signal" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output signal after the selected modification" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  Real limited "Internal rate-limited tracking state";
initial equation
  assert(riseRate>=0 and fallRate>=0 and trackingTime>0,"Invalid slope limiter settings.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  when {initial(),active} then reinit(limited,u); end when;
  der(limited)=if active then min(riseRate,max(-fallRate,(u-limited)/trackingTime)) else 0;
  y=if active then limited else u;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-58,-31},{-31,-31},{-31,38},{58,38}}, color={160,160,164}, thickness=0.7, pattern=LinePattern.Dash),
        Line(points={{-58,-31},{-31,-31},{35,38},{58,38}}, color={0,0,255}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="du/dt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>At initialisation and each activation onset, the internal state is synchronised to <code>u</code>. While active, its derivative is <code>(u-limited)/trackingTime</code> limited to <code>[-fallRate,riseRate]</code>. This is a rate-limited first-order tracking state.</p><p>Outside activation, <code>y=u</code> and the internal state is held. Deactivation therefore restores the current input immediately and can produce an output jump; the slope bounds apply only to the active state.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end RateLimit;
