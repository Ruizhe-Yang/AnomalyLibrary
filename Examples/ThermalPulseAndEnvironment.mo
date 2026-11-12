within AnomalyLibrary.Examples;
model ThermalPulseAndEnvironment "Compare a prescribed heat pulse with distinct finite environmental boundaries"
  extends Modelica.Icons.Example;
  AnomalyLibrary.Thermal.HeatPulse pulse(enabled=true,startTime=1,duration=1,energy=10) annotation(Placement(transformation(origin={-144,148},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor pulseBody(C=10,T(start=300,fixed=true)) annotation(Placement(transformation(origin={95,161},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Thermal.AmbientShift ambient(enabled=true,startTime=1,endTime=3,referenceTemperature=300,deltaT=15,G=0.5,transitionTime=0) annotation(Placement(transformation(origin={-144,15},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor ambientBody(C=10,T(start=300,fixed=true)) annotation(Placement(transformation(origin={95,28},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Thermal.RadiativeExchange radiation(enabled=true,startTime=0,endTime=6,environment=330,area=0.1,emissivity=0.8,transitionTime=0) annotation(Placement(transformation(origin={-144,-120},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor radiationBody(C=10,T(start=300,fixed=true)) annotation(Placement(transformation(origin={95,-107},extent={{-15,-15},{15,15}},rotation=0)));
equation
  connect(pulse.port,pulseBody.port) annotation(Line(points={{-127,148},{95,148},{95,141},{95,146}},color={191,0,0}));
  connect(ambient.port,ambientBody.port) annotation(Line(points={{-127,15},{95,15},{95,8},{95,13}},color={191,0,0}));
  connect(radiation.port,radiationBody.port) annotation(Line(points={{-127,-120},{95,-120},{95,-127},{95,-122}},color={191,0,0}));
  annotation(experiment(StartTime=0,StopTime=5,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Compare a prescribed heat pulse with distinct finite environmental boundaries</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Only the 10 J pulse heats its isolated 10 J/K body. Its final temperature is 301 K.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> pulse.injectedEnergy, pulseBody.T, ambient.heatFlow and radiation.heatFlow.</p></html>"));
end ThermalPulseAndEnvironment;
