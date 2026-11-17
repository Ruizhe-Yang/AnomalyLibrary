within AnomalyLibrary.Utilities.Internal;
block FrameQueue "Apply a deterministic policy to a finite frame queue"
parameter Integer nPayload(min=1)=1 "Number of real-valued payload fields";
  parameter Integer maxFrames(min=1)=128 "Maximum number of queued and waiting frames";
  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive interval between service opportunities";

  parameter Integer dropEveryN(min=1)=3 "Transmission-count period for dropping when no explicit list is supplied";
  parameter Integer dropSequences[:]=fill(0,0) "Sequence identifiers to drop; an empty list selects periodic dropping";
  parameter Modelica.Units.SI.Time delayTime(min=0)=0.2 "Scheduled delay added in Delay mode";
  parameter Modelica.Units.SI.Time pairTimeout(min=0)=0.3 "Maximum waiting interval for a reordering partner";
  parameter Integer duplicateEveryN(min=1)=2 "Transmission-count period for duplication";
  parameter Integer acceptEveryN(min=1)=2 "Retain one frame in this many transmissions in Throttle mode";
  parameter Modelica.Units.SI.Time timeOffset=0.1 "Offset added to source timestamps in Timestamp mode";
  parameter Integer payloadIndex(min=1)=1 "Payload field modified in Corrupt mode";
  parameter Real offset=0.1 "Offset applied to the selected payload field";
  parameter Real gain=1 "Gain applied to the selected payload field";

  parameter AnomalyLibrary.Utilities.Types.FrameMode mode=AnomalyLibrary.Utilities.Types.FrameMode.Delay "Active frame-processing policy";
    Modelica.Blocks.Interfaces.RealInput u[nPayload] "Payload of the arriving frame" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput txCount "Transmission count; each new frame must increment this by one" annotation(Placement(transformation(origin={-100,35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerInput sequence "Sequence identifier carried by the arriving frame" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput sourceTime(unit="s") "Source timestamp carried by the arriving frame" annotation(Placement(transformation(origin={-100,-35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput validIn "Validity of the arriving frame" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[nPayload] "Held payload of the most recently delivered frame" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput rxCount "Number of delivered frames, including duplicates and replays" annotation(Placement(transformation(origin={100,57.27273},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,57.27273},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput receivedSequence "Sequence identifier of the most recently delivered frame" annotation(Placement(transformation(origin={100,44.54545},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,44.54545},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput receivedSourceTime(unit="s") "Source timestamp of the most recently delivered frame" annotation(Placement(transformation(origin={100,31.81818},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,31.81818},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "A frame has been delivered and is not masked by an active outage" annotation(Placement(transformation(origin={100,19.09091},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,19.09091},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput validOut "The available delivered frame is valid" annotation(Placement(transformation(origin={100,6.36364},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,6.36364},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput droppedCount "Frames rejected by policy, overflow or recovery flushing" annotation(Placement(transformation(origin={100,-6.36364},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-6.36364},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow "Latched indication that a queue insertion exceeded capacity" annotation(Placement(transformation(origin={100,-19.09091},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-19.09091},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput queueLength "Queued frames including any frame waiting for reordering" annotation(Placement(transformation(origin={100,-31.81818},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-31.81818},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput inputSequenceError "Latched indication of a non-unit transmission-count change" annotation(Placement(transformation(origin={100,-44.54545},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-44.54545},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput serviceDelay(unit="s") "Lateness of delivery relative to its scheduled release" annotation(Placement(transformation(origin={100,-57.27273},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-57.27273},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput noCachedFrame "Replay is active without a cached valid frame" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput active "Apply the selected frame policy" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
protected
  discrete Real payload[maxFrames,nPayload](each start=0,each fixed=true) "Queued frame payloads";
  discrete Integer ids[maxFrames](each start=0,each fixed=true) "Queued sequence identifiers";
  discrete Modelica.Units.SI.Time sourceTimes[maxFrames](each start=0,each fixed=true) "Queued source timestamps";
  discrete Modelica.Units.SI.Time due[maxFrames](each start=0,each fixed=true) "Scheduled release times of queued frames";
  discrete Boolean qualified[maxFrames](each start=false,each fixed=true) "Validity flags of queued frames";
  discrete Real latest[nPayload](each start=0,each fixed=true) "Payload of the most recently delivered frame";
  discrete Integer received(start=0,fixed=true) "Delivery counter";
  discrete Integer latestId(start=0,fixed=true) "Most recently delivered sequence identifier";
  discrete Modelica.Units.SI.Time latestTime(start=0,fixed=true) "Most recently delivered source timestamp";
  discrete Boolean latestValid(start=false,fixed=true) "Validity of the most recently delivered frame";
  discrete Boolean haveFrame(start=false,fixed=true) "At least one frame has been delivered";
  discrete Integer nQueued(start=0,fixed=true) "Number of frames in the service queue";
  discrete Integer dropped(start=0,fixed=true) "Accumulated number of dropped frames";
  discrete Boolean overrun(start=false,fixed=true) "Latched queue-overflow state";
  discrete Boolean badSequence(start=false,fixed=true) "Latched transmission-count error";
  discrete Modelica.Units.SI.Time serviceLag(start=0,fixed=true) "Lateness of the most recent delivery";
  discrete Boolean waiting(start=false,fixed=true) "A frame is waiting for a reordering partner";
  discrete Real pending[nPayload](each start=0,each fixed=true) "Payload waiting for a reordering partner";
  discrete Integer pendingId(start=0,fixed=true) "Sequence identifier of the waiting frame";
  discrete Modelica.Units.SI.Time pendingTime(start=0,fixed=true) "Source timestamp of the waiting frame";
  discrete Modelica.Units.SI.Time pendingUntil(start=0,fixed=true) "Timeout of the waiting reordering frame";
  discrete Boolean cached(start=false,fixed=true) "A valid inactive-operation frame is cached";
  discrete Real cache[nPayload](each start=0,each fixed=true) "Payload cached for replay";
  discrete Integer cachedId(start=0,fixed=true) "Sequence identifier cached for replay";
  discrete Modelica.Units.SI.Time cachedTime(start=0,fixed=true) "Source timestamp cached for replay";
  discrete Integer copies(start=0,fixed=true) "Number of copies to enqueue for the current arrival";
  Boolean arrives "The transmission count has changed";
  Boolean recovered "Activation has just ended";
  Boolean tick "A queue service instant has been reached";
  discrete Modelica.Units.SI.Time nextService(start=0,fixed=true) "Next queue service instant";
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
    Documentation(info="<html><p>Process payloads when <code>txCount</code> increases by exactly one. <code>sequence</code> and <code>sourceTime</code> are frame metadata. A different count change latches <code>inputSequenceError</code> and does not process that payload. Initialisation clears all stored frames; inactive operation forwards each accepted arrival immediately and caches valid frames for replay.</p><p>During activation, the selected <code>FrameMode</code> determines dropping, delay, pair reordering, duplication, timestamp offset, throttling, payload modification, outage or replay. The service clock releases at most one frame per tick. Replay repeats the most recently cached valid inactive frame and discards incoming frames. Outage suppresses availability while retaining the stored payload. <code>rxCount</code> counts deliveries independently of the delivered sequence number.</p><p>The queue is bounded by <code>maxFrames</code>; overflow rejects new data and latches <code>overflow</code>. Reordering holds a frame until a partner or timeout is serviced. Deactivation flushes queued and waiting frames and adds them to <code>droppedCount</code>. Outputs retain the last delivered frame; inspect <code>available</code> and <code>validOut</code> before using it. <code>serviceDelay</code> is lateness relative to the scheduled release, not total frame age.</p></html>"));
end FrameQueue;
