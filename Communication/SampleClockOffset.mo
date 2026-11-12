within AnomalyLibrary.Communication;
block SampleClockOffset "Select the nominal or offset sample grid and publish sample timestamps"
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

  parameter Integer nPayload(min=1)=1;
  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time sampleStart=0.01;
  parameter Modelica.Units.SI.Time offset=0.002;
    Modelica.Blocks.Interfaces.RealInput u[nPayload] annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[nPayload](each start=0,each fixed=true) annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput rxCount(start=0,fixed=true) annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit="s",start=0,fixed=true) annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available(start=false,fixed=true) annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);
  Boolean nominalTick;
  Boolean shiftedTick;
initial equation
  assert(samplePeriod>0 and sampleStart>=0 and sampleStart+offset>=0,"Invalid sampling grids.");
  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;

  nominalTick=sample(sampleStart,samplePeriod);
  shiftedTick=sample(sampleStart+offset,samplePeriod);
  when (if active then shiftedTick else nominalTick) then
    y=u;
    rxCount=pre(rxCount)+1;
    receivedSourceTime=time;
    available=true;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,32},{-48,32},{-48,53},{-48,32},{-14,32},{-14,53},{-14,32},{20,32},{20,53},{20,32},{54,32}}, color={160,160,164}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-62,-24},{-29,-24},{-29,-3},{-29,-24},{5,-24},{5,-3},{5,-24},{39,-24},{39,-3},{39,-24},{62,-24}}, color={0,0,255}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-48,8},{-29,8}}, color={191,0,0}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-67,-74},{67,-49}}, textString="phase", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Select the nominal or offset sample grid and publish sample timestamps.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Blocks.Interfaces.RealInput u[nPayload]; Modelica.Blocks.Interfaces.RealOutput y[nPayload](each start=0,each fixed=true); Modelica.Blocks.Interfaces.IntegerOutput rxCount(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit=\"s\",start=0,fixed=true); Modelica.Blocks.Interfaces.BooleanOutput available(start=false,fixed=true)</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; final parameter Modelica.Units.SI.Time transitionTime=0; parameter Integer nPayload(min=1)=1; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0.01; parameter Modelica.Units.SI.Time offset=0.002</p><p><b>Behavior</b> Select the nominal or offset sample grid and publish sample timestamps</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> The disabled reference is the nominal sample grid. The phase offset changes grid origin, not clock frequency.</p><p><b>Observables</b> active, effectLevel, activationCount, y, rxCount, receivedSourceTime, available</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.DeterministicCommunication\">AnomalyLibrary.Examples.DeterministicCommunication</a></p></html>"));
end SampleClockOffset;
