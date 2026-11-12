within AnomalyLibrary.Communication;
block FrameReorder "Swap adjacent qualified frames and time out an incomplete pair"
parameter Boolean enabled=false;
  parameter Boolean useExternalTrigger=false;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time startTime=1;
  parameter Modelica.Units.SI.Time endTime=2;
  final parameter Modelica.Units.SI.Time transitionTime=0;
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  output Boolean active;
  output Real effectLevel;
  output Integer activationCount;

  parameter Integer nPayload(min=1)=1;
  parameter Integer maxFrames(min=1)=128;
  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time pairTimeout(min=0)=0.3;
  Modelica.Blocks.Interfaces.RealInput u[nPayload] annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput txCount annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput sequence annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput sourceTime(unit="s") annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput validIn annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[nPayload] annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput rxCount annotation(Placement(transformation(origin={100,57.27273},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,57.27273},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput receivedSequence annotation(Placement(transformation(origin={100,44.54545},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,44.54545},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit="s") annotation(Placement(transformation(origin={100,31.81818},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,31.81818},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,19.09091},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,19.09091},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput validOut annotation(Placement(transformation(origin={100,6.36364},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,6.36364},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput droppedCount annotation(Placement(transformation(origin={100,-6.36364},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-6.36364},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow annotation(Placement(transformation(origin={100,-19.09091},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-19.09091},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput queueLength annotation(Placement(transformation(origin={100,-31.81818},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-31.81818},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput inputSequenceError annotation(Placement(transformation(origin={100,-44.54545},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-44.54545},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput serviceDelay(unit="s") annotation(Placement(transformation(origin={100,-57.27273},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-57.27273},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput noCachedFrame annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger);
  AnomalyLibrary.Utilities.Internal.FrameQueue core(nPayload=nPayload,maxFrames=maxFrames,samplePeriod=samplePeriod,mode=AnomalyLibrary.Utilities.Types.FrameMode.Reorder,pairTimeout=pairTimeout);
initial equation

  assert(severity<=0 or severity>=1,"A discrete anomaly has deterministic severity zero or one.");
equation
  connect(trigger,gate.externalTrigger);
  if not useExternalTrigger then gate.externalTrigger=false; end if;
  active=gate.active;
  effectLevel=gate.effectLevel;
  activationCount=gate.activationCount;
  core.active=active;
  connect(u,core.u);
  connect(txCount,core.txCount);
  connect(sequence,core.sequence);
  connect(sourceTime,core.sourceTime);
  connect(validIn,core.validIn);
  connect(core.y,y);
  connect(core.rxCount,rxCount);
  connect(core.receivedSequence,receivedSequence);
  connect(core.receivedSourceTime,receivedSourceTime);
  connect(core.available,available);
  connect(core.validOut,validOut);
  connect(core.droppedCount,droppedCount);
  connect(core.overflow,overflow);
  connect(core.queueLength,queueLength);
  connect(core.inputSequenceError,inputSequenceError);
  connect(core.serviceDelay,serviceDelay);
  connect(core.noCachedFrame,noCachedFrame);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-56,20},{-24,52}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8, radius=0),
        Line(points={{-56,42},{-24,42}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-53,23},{-27,40}}, textString="1", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{24,20},{56,52}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8, radius=0),
        Line(points={{24,42},{56,42}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{27,23},{53,40}}, textString="2", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{-56,-59},{-24,-27}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8, radius=0),
        Line(points={{-56,-37},{-24,-37}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-53,-56},{-27,-39}}, textString="2", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{24,-59},{56,-27}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8, radius=0),
        Line(points={{24,-37},{56,-37}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{27,-56},{53,-39}}, textString="1", textColor={64,64,64}, fontSize=0),
        Line(points={{-40,20},{40,-27}}, color={0,0,255}, thickness=1.1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{40,20},{-40,-27}}, color={64,64,64}, thickness=1.1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Swap adjacent qualified frames and time out an incomplete pair.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger; output Boolean active; output Real effectLevel; output Integer activationCount; Modelica.Blocks.Interfaces.RealInput u[nPayload]; Modelica.Blocks.Interfaces.IntegerInput txCount; Modelica.Blocks.Interfaces.IntegerInput sequence; Modelica.Blocks.Interfaces.RealInput sourceTime(unit=\"s\"); Modelica.Blocks.Interfaces.BooleanInput validIn; Modelica.Blocks.Interfaces.RealOutput y[nPayload]; Modelica.Blocks.Interfaces.IntegerOutput rxCount; Modelica.Blocks.Interfaces.IntegerOutput receivedSequence; Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit=\"s\"); Modelica.Blocks.Interfaces.BooleanOutput available; Modelica.Blocks.Interfaces.BooleanOutput validOut; Modelica.Blocks.Interfaces.IntegerOutput droppedCount; Modelica.Blocks.Interfaces.BooleanOutput overflow; Modelica.Blocks.Interfaces.IntegerOutput queueLength; Modelica.Blocks.Interfaces.BooleanOutput inputSequenceError; Modelica.Blocks.Interfaces.RealOutput serviceDelay(unit=\"s\"); Modelica.Blocks.Interfaces.BooleanOutput noCachedFrame</p><p><b>Parameters</b> parameter Boolean enabled=false; parameter Boolean useExternalTrigger=false; parameter Real severity(min=0,max=1)=1; parameter Modelica.Units.SI.Time startTime=1; parameter Modelica.Units.SI.Time endTime=2; final parameter Modelica.Units.SI.Time transitionTime=0; parameter Integer nPayload(min=1)=1; parameter Integer maxFrames(min=1)=128; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time pairTimeout(min=0)=0.3</p><p><b>Behavior</b> Swap adjacent qualified frames and time out an incomplete pair</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Each increment of txCount admits one candidate frame. Active behavior uses a finite service queue. On exit active leftovers are discarded.</p><p><b>Limitations</b> An empty channel has available=false. Source identity and the independent receiving count have distinct meanings.</p><p><b>Observables</b> active, effectLevel, activationCount, y, rxCount, receivedSequence, receivedSourceTime, available, validOut, droppedCount</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.DeterministicCommunication\">AnomalyLibrary.Examples.DeterministicCommunication</a></p></html>"));
end FrameReorder;
