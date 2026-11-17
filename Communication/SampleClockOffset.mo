within AnomalyLibrary.Communication;
block SampleClockOffset "Switch between nominal and phase-shifted sampling grids"
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

  parameter Integer nPayload(min=1)=1 "Number of real-valued payload channels";
  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive sampling period of both grids";
  parameter Modelica.Units.SI.Time sampleStart=0.01 "Origin of the nominal sampling grid";
  parameter Modelica.Units.SI.Time offset=0.002 "Signed shift of the sampling-grid origin";
    Modelica.Blocks.Interfaces.RealInput u[nPayload] "Continuous input array to sample" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[nPayload](each start=0,each fixed=true) "Held samples of the input array" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput rxCount(start=0,fixed=true) "Number of selected sampling events" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit="s",start=0,fixed=true) "Actual instant of the most recent selected sample" annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available(start=false,fixed=true) "At least one selected sample has been acquired" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  Boolean nominalTick "Tick of the nominal sampling grid";
  Boolean shiftedTick "Tick of the offset sampling grid";
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
    Documentation(info="<html><p>The nominal grid starts at <code>sampleStart</code>; the active grid starts at <code>sampleStart+offset</code>. Both use <code>samplePeriod</code>. Each selected tick samples the complete input array, increments <code>rxCount</code> and stores the actual sampling instant in <code>receivedSourceTime</code>. The sampled output is held between ticks.</p><p><code>available</code> becomes true after the first selected sample. The offset changes grid phase, not clock frequency or reported timestamp arithmetic. Both grid origins must be non-negative. Even with the anomaly disabled, the block remains a sampler rather than a continuous pass-through.</p><p>Set <code>enabled=true</code> and <code>severity=1</code> to apply the effect, or <code>severity=0</code> to disable it. The internal window is <code>[startTime,endTime)</code>; <code>useExternalTrigger=true</code> selects <code>trigger</code> instead. Intermediate severities are not supported.</p></html>"));
end SampleClockOffset;
