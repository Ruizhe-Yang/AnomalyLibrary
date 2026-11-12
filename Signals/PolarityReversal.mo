within AnomalyLibrary.Signals;
block PolarityReversal "使通信值在事件窗内取反号"
  parameter Boolean enabled = true "为 false 时整个运行处于名义状态";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "开始时刻，包含";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "结束时刻，不包含";
  Modelica.Blocks.Interfaces.BooleanOutput active "事件窗有效" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput u "事件前的名义信号" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealOutput y "事件后的接收信号" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime);
equation
  active = eventWindow.active;
  y = if active then -u else u;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,0},{68,0}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{0,-55},{0,58}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-53,43},{53,-43}}, color={0,0,255}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{25,25},{65,56}}, textString="-1", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="PolarityReversal")}),
    Documentation(info="<html><p><b>Purpose</b> 使通信值在事件窗内取反号</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"; Modelica.Blocks.Interfaces.RealInput u \"事件前的名义信号\"; Modelica.Blocks.Interfaces.RealOutput y \"事件后的接收信号\"</p><p><b>Parameters</b> parameter Boolean enabled = true \"为 false 时整个运行处于名义状态\"; parameter Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"; parameter Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"</p><p><b>Behavior</b> 使通信值在事件窗内取反号</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Use the declared activation inputs and timing.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">AnomalyLibrary.Examples.SignalDeviationAndRecovery</a></p>
<p>使通信值在事件窗内取反号</p>
<p>专业分类为 SignalEvents.SignalDistortion。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"事件前的名义信号\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput y \"事件后的接收信号\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Boolean enabled = true \"为 false 时整个运行处于名义状态\"</code></li>
<li><code>Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"</code></li>
<li><code>Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"</code></li>
</ul>
<p><b>时序与基准行为</b> 切入和切出均即时。</p>
<p><b>最小用法</b> 接在双向归一化控制链路。 <a href=\"modelica://AnomalyLibrary.Examples.DeterministicCommunication\">SignalCommunicationEvent</a> 展示同域接线。</p>
<p><b>适用边界</b> 宿主须能解释负值。</p>
</html>"));
end PolarityReversal;
