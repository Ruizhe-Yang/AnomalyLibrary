within AnomalyLibrary.Utilities.Internal;
block FrameQueue "Finite deterministic frame queue with independent reception count"
parameter Integer nPayload(min=1)=1;
  parameter Integer maxFrames(min=1)=128;
  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;

  parameter Integer dropEveryN(min=1)=3;
  parameter Integer dropSequences[:]=fill(0,0);
  parameter Modelica.Units.SI.Time delayTime(min=0)=0.2;
  parameter Modelica.Units.SI.Time pairTimeout(min=0)=0.3;
  parameter Integer duplicateEveryN(min=1)=2;
  parameter Integer acceptEveryN(min=1)=2;
  parameter Modelica.Units.SI.Time timeOffset=0.1;
  parameter Integer payloadIndex(min=1)=1;
  parameter Real offset=0.1;
  parameter Real gain=1;

  parameter AnomalyLibrary.Utilities.Types.FrameMode mode=AnomalyLibrary.Utilities.Types.FrameMode.Delay;
    Modelica.Blocks.Interfaces.RealInput u[nPayload] annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput txCount annotation(Placement(transformation(origin={-100,35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput sequence annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput sourceTime(unit="s") annotation(Placement(transformation(origin={-100,-35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput validIn annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
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
  Modelica.Blocks.Interfaces.BooleanInput active annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
protected
  discrete Real payload[maxFrames,nPayload](each start=0,each fixed=true);
  discrete Integer ids[maxFrames](each start=0,each fixed=true);
  discrete Modelica.Units.SI.Time sourceTimes[maxFrames](each start=0,each fixed=true);
  discrete Modelica.Units.SI.Time due[maxFrames](each start=0,each fixed=true);
  discrete Boolean qualified[maxFrames](each start=false,each fixed=true);
  discrete Real latest[nPayload](each start=0,each fixed=true);
  discrete Integer received(start=0,fixed=true);
  discrete Integer latestId(start=0,fixed=true);
  discrete Modelica.Units.SI.Time latestTime(start=0,fixed=true);
  discrete Boolean latestValid(start=false,fixed=true);
  discrete Boolean haveFrame(start=false,fixed=true);
  discrete Integer nQueued(start=0,fixed=true);
  discrete Integer dropped(start=0,fixed=true);
  discrete Boolean overrun(start=false,fixed=true);
  discrete Boolean badSequence(start=false,fixed=true);
  discrete Modelica.Units.SI.Time serviceLag(start=0,fixed=true);
  discrete Boolean waiting(start=false,fixed=true);
  discrete Real pending[nPayload](each start=0,each fixed=true);
  discrete Integer pendingId(start=0,fixed=true);
  discrete Modelica.Units.SI.Time pendingTime(start=0,fixed=true);
  discrete Modelica.Units.SI.Time pendingUntil(start=0,fixed=true);
  discrete Boolean cached(start=false,fixed=true);
  discrete Real cache[nPayload](each start=0,each fixed=true);
  discrete Integer cachedId(start=0,fixed=true);
  discrete Modelica.Units.SI.Time cachedTime(start=0,fixed=true);
  discrete Integer copies(start=0,fixed=true);
  Boolean arrives;
  Boolean recovered;
  Boolean tick;
  discrete Modelica.Units.SI.Time nextService(start=0,fixed=true);
initial equation
  assert(maxFrames>=1 and nPayload>=1 and samplePeriod>0,"Invalid frame interface dimensions or period.");
  assert(dropEveryN>=1 and duplicateEveryN>=1 and acceptEveryN>=1,"Frame periods must be positive.");
  assert(delayTime>=0 and pairTimeout>=0 and payloadIndex>=1 and payloadIndex<=nPayload,"Invalid frame policy.");
  assert(mode<>AnomalyLibrary.Utilities.Types.FrameMode.Reorder or maxFrames>=2,"Reordering needs room for a pair.");
equation
  arrives=txCount<>pre(txCount);
  recovered=not active and pre(active);
  tick=time>=pre(nextService);
  y=latest;
  rxCount=received;
  receivedSequence=latestId;
  receivedSourceTime=if haveFrame then latestTime else 0;
  available=haveFrame and not (active and mode==AnomalyLibrary.Utilities.Types.FrameMode.Outage);
  validOut=available and latestValid;
  droppedCount=dropped;
  overflow=overrun;
  queueLength=nQueued+(if waiting then 1 else 0);
  inputSequenceError=badSequence;
  serviceDelay=if haveFrame then serviceLag else 0;
  noCachedFrame=active and mode==AnomalyLibrary.Utilities.Types.FrameMode.Replay and not cached;
algorithm
  when {initial(),arrives,tick,recovered} then
    if initial() then
      payload:=fill(0,maxFrames,nPayload);
      ids:=fill(0,maxFrames);
      sourceTimes:=fill(0,maxFrames);
      due:=fill(0,maxFrames);
      qualified:=fill(false,maxFrames);
      latest:=fill(0,nPayload);
      received:=0; latestId:=0; latestTime:=0;
      latestValid:=false; haveFrame:=false; nQueued:=0;
      dropped:=0; overrun:=false; badSequence:=false; serviceLag:=0;
      waiting:=false; pending:=fill(0,nPayload); pendingId:=0;
      pendingTime:=0; pendingUntil:=0;
      cached:=false; cache:=fill(0,nPayload); cachedId:=0; cachedTime:=0; copies:=0;
      nextService:=time+samplePeriod;
    else
      if tick then nextService:=pre(nextService)+samplePeriod; end if;
      if recovered then
        dropped:=dropped+nQueued+(if waiting then 1 else 0);
        nQueued:=0;
        waiting:=false;
      end if;
      if arrives then
        if txCount<>pre(txCount)+1 then
          badSequence:=true;
        elseif not active then
          latest:=u;
          latestId:=sequence;
          latestTime:=sourceTime;
          latestValid:=validIn;
          haveFrame:=true;
          received:=received+1;
          serviceLag:=0;
          if validIn then
            cached:=true; cache:=u; cachedId:=sequence; cachedTime:=sourceTime;
          end if;
        elseif mode==AnomalyLibrary.Utilities.Types.FrameMode.Outage or mode==AnomalyLibrary.Utilities.Types.FrameMode.Replay
          or (mode==AnomalyLibrary.Utilities.Types.FrameMode.Drop and (if size(dropSequences,1)>0 then
            sum(if sequence==id then 1 else 0 for id in dropSequences)>0 else mod(txCount,dropEveryN)==0))
          or (mode==AnomalyLibrary.Utilities.Types.FrameMode.Throttle and mod(txCount-1,acceptEveryN)<>0) then
          dropped:=dropped+1;
        elseif mode==AnomalyLibrary.Utilities.Types.FrameMode.Reorder and validIn then
          if waiting then
            if nQueued+2>maxFrames then
              overrun:=true; dropped:=dropped+1;
            else
              nQueued:=nQueued+1;
              for j in 1:nPayload loop payload[nQueued,j]:=u[j]; end for; ids[nQueued]:=sequence; sourceTimes[nQueued]:=sourceTime;
              due[nQueued]:=time; qualified[nQueued]:=true;
              nQueued:=nQueued+1;
              for j in 1:nPayload loop payload[nQueued,j]:=pending[j]; end for; ids[nQueued]:=pendingId; sourceTimes[nQueued]:=pendingTime;
              due[nQueued]:=time; qualified[nQueued]:=true;
              waiting:=false;
            end if;
          elseif nQueued>=maxFrames then
            overrun:=true; dropped:=dropped+1;
          else
            waiting:=true; pending:=u; pendingId:=sequence; pendingTime:=sourceTime; pendingUntil:=time+pairTimeout;
          end if;
        else
          copies:=if mode==AnomalyLibrary.Utilities.Types.FrameMode.Duplicate and mod(txCount,duplicateEveryN)==0 then 2 else 1;
          if nQueued+copies+(if waiting then 1 else 0)>maxFrames then
            overrun:=true; dropped:=dropped+1;
          else
            for k in 1:copies loop
              nQueued:=nQueued+1;
              for j in 1:nPayload loop payload[nQueued,j]:=u[j]; end for;
              if mode==AnomalyLibrary.Utilities.Types.FrameMode.Corrupt then payload[nQueued,payloadIndex]:=gain*u[payloadIndex]+offset; end if;
              ids[nQueued]:=sequence;
              sourceTimes[nQueued]:=sourceTime+(if mode==AnomalyLibrary.Utilities.Types.FrameMode.Timestamp then timeOffset else 0);
              due[nQueued]:=time+(if mode==AnomalyLibrary.Utilities.Types.FrameMode.Delay then delayTime else 0);
              qualified[nQueued]:=validIn;
            end for;
          end if;
        end if;
      end if;
      if tick and active then
        if waiting and time+1e-10>=pendingUntil and nQueued<maxFrames then
          nQueued:=nQueued+1;
          for j in 1:nPayload loop payload[nQueued,j]:=pending[j]; end for; ids[nQueued]:=pendingId; sourceTimes[nQueued]:=pendingTime;
          due[nQueued]:=pendingUntil; qualified[nQueued]:=true;
          waiting:=false;
        end if;
        if mode==AnomalyLibrary.Utilities.Types.FrameMode.Replay and cached then
          latest:=cache; latestId:=cachedId; latestTime:=cachedTime;
          latestValid:=true; haveFrame:=true; received:=received+1; serviceLag:=0;
        elseif nQueued>0 and time+1e-10>=due[1] then
          for j in 1:nPayload loop latest[j]:=payload[1,j]; end for; latestId:=ids[1]; latestTime:=sourceTimes[1];
          latestValid:=qualified[1]; haveFrame:=true; received:=received+1;
          serviceLag:=max(0,time-due[1]);
          for k in 1:nQueued-1 loop
            for j in 1:nPayload loop payload[k,j]:=payload[k+1,j]; end for; ids[k]:=ids[k+1];
            sourceTimes[k]:=sourceTimes[k+1]; due[k]:=due[k+1]; qualified[k]:=qualified[k+1];
          end for;
          nQueued:=nQueued-1;
        end if;
      end if;
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-67,-23},{67,40}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-24,-23},{-24,40}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{22,-23},{22,40}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Rectangle(extent={{-62,-8},{-28,26}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,16},{-28,16}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-59,13},{-31,-5}}, textString="1", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{-17,-8},{17,26}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-17,16},{17,16}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-14,13},{14,-5}}, textString="2", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{28,-8},{62,26}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{28,16},{62,16}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{31,13},{59,-5}}, textString="3", textColor={64,64,64}, fontSize=0),
        Line(points={{-57,-44},{58,-44}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-49,51},{49,78}}, textString="buffer", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Finite deterministic frame queue with independent reception count.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u[nPayload]; Modelica.Blocks.Interfaces.IntegerInput txCount; Modelica.Blocks.Interfaces.IntegerInput sequence; Modelica.Blocks.Interfaces.RealInput sourceTime(unit=\"s\"); Modelica.Blocks.Interfaces.BooleanInput validIn; Modelica.Blocks.Interfaces.RealOutput y[nPayload]; Modelica.Blocks.Interfaces.IntegerOutput rxCount; Modelica.Blocks.Interfaces.IntegerOutput receivedSequence; Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit=\"s\"); Modelica.Blocks.Interfaces.BooleanOutput available; Modelica.Blocks.Interfaces.BooleanOutput validOut; Modelica.Blocks.Interfaces.IntegerOutput droppedCount; Modelica.Blocks.Interfaces.BooleanOutput overflow; Modelica.Blocks.Interfaces.IntegerOutput queueLength; Modelica.Blocks.Interfaces.BooleanOutput inputSequenceError; Modelica.Blocks.Interfaces.RealOutput serviceDelay(unit=\"s\"); Modelica.Blocks.Interfaces.BooleanOutput noCachedFrame; Modelica.Blocks.Interfaces.BooleanInput active</p><p><b>Parameters</b> parameter Integer nPayload(min=1)=1; parameter Integer maxFrames(min=1)=128; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Integer dropEveryN(min=1)=3; parameter Integer dropSequences[:]=fill(0,0); parameter Modelica.Units.SI.Time delayTime(min=0)=0.2; parameter Modelica.Units.SI.Time pairTimeout(min=0)=0.3; parameter Integer duplicateEveryN(min=1)=2; parameter Integer acceptEveryN(min=1)=2; parameter Modelica.Units.SI.Time timeOffset=0.1; parameter Integer payloadIndex(min=1)=1; parameter Real offset=0.1; parameter Real gain=1; parameter AnomalyLibrary.Utilities.Types.FrameMode mode=AnomalyLibrary.Utilities.Types.FrameMode.Delay</p><p><b>Behavior</b> The active service clock sends at most one frame at each tick. The disabled branch transfers a new frame directly.</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Overflow rejects the new frame and retains queued data. A count jump does not fabricate absent payloads.</p><p><b>Observables</b> y, rxCount, receivedSequence, receivedSourceTime, available, validOut, droppedCount, overflow, queueLength, inputSequenceError</p></html>"));
end FrameQueue;
