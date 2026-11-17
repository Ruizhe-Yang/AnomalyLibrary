within AnomalyLibrary.Fluid;
model MassInjection "Prescribed fluid injection or withdrawal"
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
  replaceable package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  parameter Modelica.Units.SI.MassFlowRate injection=0.1 "Mass flow supplied to the connected system at full effect";
  parameter Modelica.Units.SI.AbsolutePressure injectionPressure(min=0)=101325 "Pressure used to define the injected thermodynamic state";
  parameter Modelica.Units.SI.Temperature injectionTemperature(min=0)=293.15 "Temperature of the injected fluid";
  parameter Medium.MassFraction X[Medium.nX]=Medium.X_default "Mass fractions of the injected fluid";
  Modelica.Fluid.Interfaces.FluidPort_b port(redeclare package Medium=Medium) "Connection to the affected fluid network" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.MassFlowRate massAdded "Signed mass flow supplied to the connected system";
  Modelica.Units.SI.Power enthalpyAdded "Signed enthalpy flow supplied to the connected system";
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";

initial equation
  assert(injectionPressure>0 and injectionTemperature>0,"Invalid injection state.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  massAdded=effectLevel*injection;
  port.m_flow=-massAdded;
  port.h_outflow=Medium.specificEnthalpy(Medium.setState_pTX(injectionPressure,injectionTemperature,X));
  port.Xi_outflow=X[1:Medium.nXi];
  port.C_outflow=fill(0,Medium.nC);
  enthalpyAdded=massAdded*actualStream(port.h_outflow);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-48,-48},{48,48}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{48,0},{100,0}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-27,0},{27,0}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-30,21},{30,43}}, textString="m", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Positive <code>injection*effectLevel</code> adds mass with the declared pressure, temperature and mass fractions; negative flow withdraws the connected stream. <code>injectionPressure</code> defines the supplied enthalpy and does not impose the port pressure. Injected trace-substance concentrations are zero. <code>massAdded</code> and <code>enthalpyAdded</code> report signed mass and enthalpy flow rates.</p><p>Connect port to the fluid network, match Medium and specify injection and the injected state. Set <code>enabled=true</code> and configure the scheduled window or external trigger. <code>effectLevel</code> scales the disturbance and can remain nonzero during recovery after <code>active</code> becomes false.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.FluidPathDisturbances\">FluidPathDisturbances</a> for connections.</p></html>"));
end MassInjection;
