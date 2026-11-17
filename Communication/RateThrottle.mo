within AnomalyLibrary.Communication;
block RateThrottle "Accept a deterministic subset of transmitted frames"
parameter Boolean enabled=false "Enable the anomaly";
  parameter Boolean useExternalTrigger=false "Use trigger instead of the internal activation window";
  parameter Real severity(min=0,max=1)=1 "Requested severity between zero and one";
  parameter Modelica.Units.SI.Time startTime=1 "Inclusive start of the internal activation window";
  parameter Modelica.Units.SI.Time endTime=2 "Exclusive end of the internal activation window";
  final parameter Modelica.Units.SI.Time transitionTime=0 "Duration of a full rise or fall in the activation level";
  Modelica.Blocks.Interfaces.BooleanInput trigger if useExternalTrigger "External activation request" annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  output Boolean active "Anomaly activation is currently requested";
  output Real effectLevel "Severity-scaled activation and recovery level";
  output Integer activationCount "Number of activation onsets";

  parameter Integer nPayload(min=1)=1 "Number of real-valued payload channels";
  parameter Integer maxFrames(min=1)=128 "Maximum number of frames held by the service queue";
  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive service interval";
  parameter Integer acceptEveryN(min=1)=2 "Spacing between accepted transmission counts, starting with count one";
  Modelica.Blocks.Interfaces.RealInput u[nPayload] "Payload of the current candidate frame" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput txCount "Transmission counter; advance by exactly one per candidate frame" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput sequence "Source identity carried by the candidate frame" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput sourceTime(unit="s") "Source timestamp carried by the candidate frame" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput validIn "Validity flag carried by the candidate frame" annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[nPayload] "Held payload of the most recently delivered frame" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput rxCount "Number of frames delivered to the output" annotation(Placement(transformation(origin={100,57.27273},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,57.27273},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput receivedSequence "Source identity of the most recently delivered frame" annotation(Placement(transformation(origin={100,44.54545},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,44.54545},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit="s") "Source timestamp of the most recently delivered frame" annotation(Placement(transformation(origin={100,31.81818},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,31.81818},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "A received frame is present and not masked by an outage" annotation(Placement(transformation(origin={100,19.09091},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,19.09091},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput validOut "Received-frame validity qualified by output availability" annotation(Placement(transformation(origin={100,6.36364},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,6.36364},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput droppedCount "Number of discarded arrivals and queued frames" annotation(Placement(transformation(origin={100,-6.36364},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-6.36364},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow "A queue-capacity overrun has occurred" annotation(Placement(transformation(origin={100,-19.09091},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-19.09091},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput queueLength "Number of queued frames, including a frame awaiting its partner" annotation(Placement(transformation(origin={100,-31.81818},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-31.81818},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput inputSequenceError "A transmission-counter change other than an increment of one occurred" annotation(Placement(transformation(origin={100,-44.54545},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-44.54545},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput serviceDelay(unit="s") "Delivery lateness beyond the scheduled due time" annotation(Placement(transformation(origin={100,-57.27273},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-57.27273},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput noCachedFrame "Replay is active without a cached valid inactive frame" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  AnomalyLibrary.Utilities.Internal.Activation gate(enabled=enabled,permanent=false,severity=severity,startTime=startTime,endTime=endTime,
    transitionTime=transitionTime,useExternalTrigger=useExternalTrigger) "Activation and recovery envelope";
  AnomalyLibrary.Utilities.Internal.FrameQueue core(nPayload=nPayload,maxFrames=maxFrames,samplePeriod=samplePeriod,mode=AnomalyLibrary.Utilities.Types.FrameMode.Throttle,acceptEveryN=acceptEveryN) "Finite frame queue and delivery policy";
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
        Line(points={{-63,39},{63,39}}, color={160,160,164}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-63,-26},{63,-26}}, color={160,160,164}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-54,30},{-54,52}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-27,30},{-27,52}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{0,30},{0,52}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{27,30},{27,52}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{54,30},{54,52}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-54,-34},{-54,-13}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{0,-34},{0,-13}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{54,-34},{54,-13}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Text(extent={{-24,-1},{30,26}}, textString="/N", textColor={0,0,255}, fontSize=0),
        Text(extent={{-67,-74},{67,-49}}, textString="update", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>During activation, a frame is accepted when <code>mod(txCount-1,acceptEveryN)=0</code>; the others are discarded. Thus the selected counts are <code>1, 1+acceptEveryN, ...</code>, without resetting the rule at activation. Accepted frames still use the service queue, so the parameter specifies a count ratio rather than an independent output frequency.</p><p>Connect the payload <code>u</code>, transmission counter <code>txCount</code>, source identity <code>sequence</code>, <code>sourceTime</code> and <code>validIn</code>. Advance <code>txCount</code> by exactly one per candidate frame; other changes latch <code>inputSequenceError</code>. The most recent output is held, while <code>rxCount</code> identifies deliveries.</p><p>Inactive arrivals are delivered immediately. Active delivery uses a finite queue and emits at most one frame per <code>samplePeriod</code> service tick. Deactivation discards queued frames; <code>overflow</code> latches a capacity overrun. Configure binary severity and read <code>available</code> and <code>validOut</code> before interpreting held output.</p></html>"));
end RateThrottle;
