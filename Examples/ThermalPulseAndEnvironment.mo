within AnomalyLibrary.Examples;
model ThermalPulseAndEnvironment "Compare a heat pulse with conductive and radiative environments"
  extends Modelica.Icons.Example;
  AnomalyLibrary.Thermal.HeatPulse pulse(enabled=true,startTime=1,duration=1,energy=10) "Finite thermal-energy pulse" annotation(Placement(transformation(origin={-144,148},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor pulseBody(C=10,T(start=300,fixed=true)) "Isolated thermal capacity receiving the pulse" annotation(Placement(transformation(origin={95,161},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Thermal.AmbientShift ambient(enabled=true,startTime=1,endTime=3,referenceTemperature=300,deltaT=15,G=0.5,transitionTime=0) "Conductive exchange with a shifted environment" annotation(Placement(transformation(origin={-144,15},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor ambientBody(C=10,T(start=300,fixed=true)) "Thermal capacity coupled to the conductive environment" annotation(Placement(transformation(origin={95,28},extent={{-15,-15},{15,15}},rotation=0)));
  AnomalyLibrary.Thermal.RadiativeExchange radiation(enabled=true,startTime=0,endTime=6,environment=330,area=0.1,emissivity=0.8,transitionTime=0) "Radiative exchange with a prescribed environment" annotation(Placement(transformation(origin={-144,-120},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor radiationBody(C=10,T(start=300,fixed=true)) "Thermal capacity coupled to the radiative environment" annotation(Placement(transformation(origin={95,-107},extent={{-15,-15},{15,15}},rotation=0)));
equation
  connect(pulse.port,pulseBody.port) annotation(Line(points={{-127,148},{95,148},{95,141},{95,146}},color={191,0,0}));
  connect(ambient.port,ambientBody.port) annotation(Line(points={{-127,15},{95,15},{95,8},{95,13}},color={191,0,0}));
  connect(radiation.port,radiationBody.port) annotation(Line(points={{-127,-120},{95,-120},{95,-127},{95,-122}},color={191,0,0}));
  annotation(experiment(StartTime=0,StopTime=5,Interval=0.01,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p>Three independent thermal capacities illustrate a finite energy pulse, a shifted conductive environment and radiative heat exchange. The 10 J pulse is delivered to an isolated 10 J/K body, giving an expected final temperature of 301 K from 300 K.</p><p>Plot <code>pulse.injectedEnergy</code>, <code>pulseBody.T</code>, <code>ambient.heatFlow</code> and <code>radiation.heatFlow</code>. The environmental cases exchange heat through finite conductance or radiation and do not impose the body temperature directly.</p></html>"));
end ThermalPulseAndEnvironment;
