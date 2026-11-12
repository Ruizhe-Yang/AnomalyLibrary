within AnomalyLibrary.Examples;
model DeterministicCommunication "Compare four independent frame policies on a shared service grid"
  extends Modelica.Icons.Example;
  AnomalyLibrary.Utilities.Internal.FrameSource transmitter(samplePeriod=0.1) annotation(Placement(transformation(origin={-246,0},extent={{-28,-28},{28,28}},rotation=0)));
  AnomalyLibrary.Communication.FrameDropout drop(enabled=true,startTime=0,endTime=5,samplePeriod=0.1,maxFrames=16,dropEveryN=3) annotation(Placement(transformation(origin={13,150},extent={{-26,-26},{26,26}},rotation=0)));
  Modelica.Blocks.Interfaces.IntegerOutput dropId annotation(Placement(transformation(origin={239,150},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Communication.FrameDelay delay(enabled=true,startTime=0,endTime=5,samplePeriod=0.1,maxFrames=16,delayTime=0.2) annotation(Placement(transformation(origin={13,52},extent={{-26,-26},{26,26}},rotation=0)));
  Modelica.Blocks.Interfaces.IntegerOutput delayId annotation(Placement(transformation(origin={239,52},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Communication.FrameReorder reorder(enabled=true,startTime=0,endTime=5,samplePeriod=0.1,maxFrames=16,pairTimeout=0.25) annotation(Placement(transformation(origin={13,-47},extent={{-26,-26},{26,26}},rotation=0)));
  Modelica.Blocks.Interfaces.IntegerOutput reorderId annotation(Placement(transformation(origin={239,-47},extent={{-7,-7},{7,7}},rotation=0)));
  AnomalyLibrary.Communication.FrameDuplicate duplicate(enabled=true,startTime=0,endTime=5,samplePeriod=0.1,maxFrames=16,duplicateEveryN=3) annotation(Placement(transformation(origin={13,-145},extent={{-26,-26},{26,26}},rotation=0)));
  Modelica.Blocks.Interfaces.IntegerOutput duplicateId annotation(Placement(transformation(origin={239,-145},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(transmitter.u,drop.u) annotation(Line(points={{-218,19.6},{-115.5,19.6},{-115.5,168.2},{-13,168.2}},color={0,0,127}));
  connect(transmitter.txCount,drop.txCount) annotation(Line(points={{-218,6.53332},{-213,6.53332},{-213,156.06666},{-13,156.06666}},color={255,127,0}));
  connect(transmitter.sequence,drop.sequence) annotation(Line(points={{-218,-6.53332},{-213,-6.53332},{-213,143.93334},{-13,143.93334}},color={255,127,0}));
  connect(transmitter.sourceTime,drop.sourceTime) annotation(Line(points={{-218,-19.6},{-115.5,-19.6},{-115.5,131.8},{-13,131.8}},color={0,0,127}));
  connect(transmitter.validIn,drop.validIn) annotation(Line(points={{-246,28},{-246,181},{-5.2,181},{-5.2,176}},color={255,0,255}));
  connect(drop.receivedSequence,dropId) annotation(Line(points={{39,161.58183},{239,161.58183},{239,150}},color={255,127,0}));
  connect(transmitter.u,delay.u) annotation(Line(points={{-218,19.6},{-115.5,19.6},{-115.5,70.2},{-13,70.2}},color={0,0,127}));
  connect(transmitter.txCount,delay.txCount) annotation(Line(points={{-218,6.53332},{-213,6.53332},{-213,58.06666},{-13,58.06666}},color={255,127,0}));
  connect(transmitter.sequence,delay.sequence) annotation(Line(points={{-218,-6.53332},{-213,-6.53332},{-213,45.93334},{-13,45.93334}},color={255,127,0}));
  connect(transmitter.sourceTime,delay.sourceTime) annotation(Line(points={{-218,-19.6},{-115.5,-19.6},{-115.5,33.8},{-13,33.8}},color={0,0,127}));
  connect(transmitter.validIn,delay.validIn) annotation(Line(points={{-246,28},{-246,83},{-5.2,83},{-5.2,78}},color={255,0,255}));
  connect(delay.receivedSequence,delayId) annotation(Line(points={{39,63.58183},{239,63.58183},{239,52}},color={255,127,0}));
  connect(transmitter.u,reorder.u) annotation(Line(points={{-218,19.6},{-115.5,19.6},{-115.5,-28.8},{-13,-28.8}},color={0,0,127}));
  connect(transmitter.txCount,reorder.txCount) annotation(Line(points={{-218,6.53332},{-213,6.53332},{-213,-40.93334},{-13,-40.93334}},color={255,127,0}));
  connect(transmitter.sequence,reorder.sequence) annotation(Line(points={{-218,-6.53332},{-213,-6.53332},{-213,-53.06666},{-13,-53.06666}},color={255,127,0}));
  connect(transmitter.sourceTime,reorder.sourceTime) annotation(Line(points={{-218,-19.6},{-115.5,-19.6},{-115.5,-65.2},{-13,-65.2}},color={0,0,127}));
  connect(transmitter.validIn,reorder.validIn) annotation(Line(points={{-246,28},{-246,33},{-246,-16},{-5.2,-16},{-5.2,-21}},color={255,0,255}));
  connect(reorder.receivedSequence,reorderId) annotation(Line(points={{39,-35.41817},{239,-35.41817},{239,-47}},color={255,127,0}));
  connect(transmitter.u,duplicate.u) annotation(Line(points={{-218,19.6},{-115.5,19.6},{-115.5,-126.8},{-13,-126.8}},color={0,0,127}));
  connect(transmitter.txCount,duplicate.txCount) annotation(Line(points={{-218,6.53332},{-213,6.53332},{-213,-138.93334},{-13,-138.93334}},color={255,127,0}));
  connect(transmitter.sequence,duplicate.sequence) annotation(Line(points={{-218,-6.53332},{-213,-6.53332},{-213,-151.06666},{-13,-151.06666}},color={255,127,0}));
  connect(transmitter.sourceTime,duplicate.sourceTime) annotation(Line(points={{-218,-19.6},{-115.5,-19.6},{-115.5,-163.2},{-13,-163.2}},color={0,0,127}));
  connect(transmitter.validIn,duplicate.validIn) annotation(Line(points={{-246,28},{-246,33},{-246,-114},{-5.2,-114},{-5.2,-119}},color={255,0,255}));
  connect(duplicate.receivedSequence,duplicateId) annotation(Line(points={{39,-133.41817},{239,-133.41817},{239,-145}},color={255,127,0}));
  annotation(experiment(StartTime=0,StopTime=4,Interval=0.008,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Compare four independent frame policies on a shared service grid</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> The transmitter emits sequence k and time 0.1 k. The drop branch removes each third frame. Delay, reorder and duplicate retain the source identity.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> Each rxCount, receivedSequence, receivedSourceTime, droppedCount and overflow.</p></html>"));
end DeterministicCommunication;
