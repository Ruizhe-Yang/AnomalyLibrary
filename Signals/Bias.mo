within AnomalyLibrary.Signals;
block Bias "Add a bounded signed offset to the input"
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
  parameter Real bias=0.2;
  Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));

protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);

equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  y=u+effectLevel*bias;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,0},{68,0}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{0,-55},{0,58}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-56,-37},{55,37}}, color={160,160,164}, thickness=0.7, pattern=LinePattern.Dash),
        Line(points={{-56,-12},{34,48}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{-35,-23},{-35,2}}, color={191,0,0}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-30,-9},{-7,15}}, textString="b", textColor={64,64,64}, fontSize=0),
        Text(extent={{-67,-74},{67,-49}}, textString="u + b", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Add a bounded signed offset to the input.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.RealOutput y</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; parameter Modelica.Units.SI.Time transitionTime(min=0)=0.05; parameter Real bias=0.2</p><p><b>Behavior</b> Add a bounded signed offset to the input</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> The optional trigger replaces the internal half-open window. A new activation updates the declared capture or command state.</p><p><b>Limitations</b> Input and output use the same units. The operation is deterministic.</p><p><b>Observables</b> active, effectLevel, activationCount, y</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">AnomalyLibrary.Examples.SignalDeviationAndRecovery</a></p></html>"));
end Bias;
