within AnomalyLibrary.Communication;
block PayloadCorruption "Alter one payload channel using an affine transformation"
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
  parameter Integer payloadIndex(min=1)=1 "Index of the payload channel to modify";
  parameter Real offset=0.1 "Additive offset in the selected payload channel unit";
  parameter Real gain=1 "Dimensionless gain applied to the selected payload channel";
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
  AnomalyLibrary.Utilities.Internal.FrameQueue core(nPayload=nPayload,maxFrames=maxFrames,samplePeriod=samplePeriod,mode=AnomalyLibrary.Utilities.Types.FrameMode.Corrupt,payloadIndex=payloadIndex,offset=offset,gain=gain) "Finite frame queue and delivery policy";
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
        Rectangle(extent={{-61,-7},{-27,27}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-61,17},{-27,17}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-58,14},{-30,-4}}, textString="u", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{27,-7},{61,27}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{27,17},{61,17}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{30,14},{58,-4}}, textString="y", textColor={64,64,64}, fontSize=0),
        Line(points={{-26,10},{24,10}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-59,-30},{59,-62}}, textString="a u + b", textColor={64,64,64}, fontSize=0),
        Line(points={{35,43},{53,61}}, color={191,0,0}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>During activation, channel <code>payloadIndex</code> is replaced by <code>gain*u[payloadIndex] + offset</code> before the frame is enqueued. Other channels and source metadata are retained. The input validity flag is also retained; corruption does not automatically mark the delivered frame invalid.</p><p>Connect the payload <code>u</code>, transmission counter <code>txCount</code>, source identity <code>sequence</code>, <code>sourceTime</code> and <code>validIn</code>. Advance <code>txCount</code> by exactly one per candidate frame; other changes latch <code>inputSequenceError</code>. The most recent output is held, while <code>rxCount</code> identifies deliveries.</p><p>Inactive arrivals are delivered immediately. Active delivery uses a finite queue and emits at most one frame per <code>samplePeriod</code> service tick. Deactivation discards queued frames; <code>overflow</code> latches a capacity overrun. Configure binary severity and read <code>available</code> and <code>validOut</code> before interpreting held output.</p></html>"));
end PayloadCorruption;
