within AnomalyLibrary.Fluid;
model MassInjection "Inject a declared fluid state or withdraw the host stream"
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
  replaceable package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  parameter Modelica.Units.SI.MassFlowRate injection=0.1;
  parameter Modelica.Units.SI.AbsolutePressure injectionPressure(min=0)=101325;
  parameter Modelica.Units.SI.Temperature injectionTemperature(min=0)=293.15;
  parameter Medium.MassFraction X[Medium.nX]=Medium.X_default;
  Modelica.Fluid.Interfaces.FluidPort_b port(redeclare package Medium=Medium) annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.MassFlowRate massAdded;
  Modelica.Units.SI.Power enthalpyAdded;
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

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
    Documentation(info="<html><p><b>Purpose</b> Inject a declared fluid state or withdraw the host stream.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Fluid.Interfaces.FluidPort_b port(redeclare package Medium=Medium)</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; replaceable package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium; parameter Modelica.Units.SI.MassFlowRate injection=0.1; parameter Modelica.Units.SI.AbsolutePressure injectionPressure(min=0)=101325; parameter Modelica.Units.SI.Temperature injectionTemperature(min=0)=293.15; parameter Medium.MassFraction X[Medium.nX]=Medium.X_default</p><p><b>Behavior</b> Inject a declared fluid state or withdraw the host stream</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The configured gate follows the half-open time window or an external trigger. A disabled intervention leaves its documented reference relation.</p><p><b>Limitations</b> Zero-effect class: Exact. Positive flow adds the declared state. Negative flow withdraws the receiving network stream. Use a Medium that supports the declared state.</p><p><b>Observables</b> active, effectLevel, activationCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.FluidPathDisturbances\">AnomalyLibrary.Examples.FluidPathDisturbances</a></p></html>"));
end MassInjection;
