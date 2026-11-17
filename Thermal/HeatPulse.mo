within AnomalyLibrary.Thermal;
model HeatPulse "Rectangular heat-flow pulse with a specified energy"
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

  parameter Modelica.Units.SI.Energy energy=10 "Specified thermal pulse energy";
  parameter Modelica.Units.SI.Time duration(min=0)=1 "Duration of each rectangular pulse";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port "Thermal connection to the affected body" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.HeatFlowRate heatFlow "Heat flow supplied to the connected system";
  Modelica.Units.SI.Energy injectedEnergy(start=0,fixed=true) "Cumulative signed heat supplied to the connected system";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  discrete Modelica.Units.SI.Time began(start=0,fixed=true) "Start time of the most recent pulse";
  discrete Boolean seen(start=false,fixed=true) "An activation has started a pulse";
initial equation
  assert(duration>0,"Heat pulse needs a positive duration.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  when {initial(),active} then
    began=time;
    seen=active;
  end when;
  heatFlow=if seen and time<began+duration then energy/duration else 0;
  port.Q_flow=-heatFlow;
  der(injectedEnergy)=heatFlow;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-48,-48},{48,48}}, lineColor={191,0,0}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{48,0},{100,0}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-35,-17},{-19,-17},{-19,21},{18,21},{18,-17},{35,-17}}, color={191,0,0}, thickness=1.1, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Each activation starts a heat-flow pulse of magnitude <code>energy/duration</code>. The pulse lasts <code>duration</code>, even if an external trigger ends earlier; another activation restarts the timer. <code>severity</code> is restricted to zero or one. Positive energy heats the connected system. <code>injectedEnergy</code> accumulates the actual signed heat transfer, including any retriggering.</p><p>Connect port to a thermal node and set energy and a positive duration. Set enabled=true and choose startTime or an external trigger.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ThermalPulseAndEnvironment\">ThermalPulseAndEnvironment</a> for connections.</p></html>"));
end HeatPulse;
