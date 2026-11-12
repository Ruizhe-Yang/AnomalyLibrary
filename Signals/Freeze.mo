within AnomalyLibrary.Signals;
block Freeze "Hold the value captured on the current activation edge"
parameter Boolean enabled=false;
  parameter Boolean useExternalTrigger=false;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time startTime=1;
  parameter Modelica.Units.SI.Time endTime=2;
  final parameter Modelica.Units.SI.Time transitionTime=0;
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  output Boolean active;
  output Real effectLevel;
  output Integer activationCount;
  output Real held(start=0,fixed=true);
  Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

initial equation

  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  when {initial(),active} then held=u; end when;
  y=if active then held else u;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-57,-31},{-22,13},{61,13}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{-22,13},{60,43}}, color={160,160,164}, thickness=0.7, pattern=LinePattern.Dash),
        Ellipse(extent={{-27,8},{-17,18}}, lineColor={0,0,255}, fillColor={0,0,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{40,4},{40,22}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{49,4},{49,22}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="hold", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Hold the value captured on the current activation edge.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; output Real held(start=0,fixed=true); Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.RealOutput y</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; final parameter Modelica.Units.SI.Time transitionTime=0</p><p><b>Behavior</b> Hold the value captured on the current activation edge</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> The optional trigger replaces the internal half-open window. A new activation updates the declared capture or command state.</p><p><b>Limitations</b> Input and output use the same units. The operation is deterministic.</p><p><b>Observables</b> active, effectLevel, activationCount, held, y</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">AnomalyLibrary.Examples.SignalDeviationAndRecovery</a></p></html>"));
end Freeze;
