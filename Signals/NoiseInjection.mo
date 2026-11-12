within AnomalyLibrary.Signals;
block NoiseInjection "将外部可复现噪声叠加到接收信号"
  parameter Boolean enabled = true "为 false 时整个运行处于名义状态";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "开始时刻，包含";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "结束时刻，不包含";
  Modelica.Blocks.Interfaces.BooleanOutput active "事件窗有效" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput u "事件前的名义信号" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.RealOutput y "事件后的接收信号" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  parameter Real gain = 1 "无量纲噪声权重";
  Modelica.Blocks.Interfaces.RealInput noise "同单位的外部扰动序列" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime);
equation
  active = eventWindow.active;
  y = u + (if active then gain*noise else 0);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{14,-28},{62,20}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{25,-4},{51,-4}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{38,-17},{38,9}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-64,-4},{14,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-61,39},{-53,50},{-44,27},{-36,44},{-27,22},{-18,40},{-7,34},{0,52},{9,37},{38,37},{38,20}}, color={0,0,255}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{62,-4},{74,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="u + noise", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="NoiseInjection")}),
    Documentation(info="<html><p><b>Purpose</b> 将外部可复现噪声叠加到接收信号</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"; Modelica.Blocks.Interfaces.RealInput u \"事件前的名义信号\"; Modelica.Blocks.Interfaces.RealOutput y \"事件后的接收信号\"; Modelica.Blocks.Interfaces.RealInput noise \"同单位的外部扰动序列\"</p><p><b>Parameters</b> parameter Boolean enabled = true \"为 false 时整个运行处于名义状态\"; parameter Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"; parameter Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"; parameter Real gain = 1 \"无量纲噪声权重\"</p><p><b>Behavior</b> 将外部可复现噪声叠加到接收信号</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Use the declared activation inputs and timing.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">AnomalyLibrary.Examples.SignalDeviationAndRecovery</a></p>
<p>将外部可复现噪声叠加到接收信号</p>
<p>专业分类为 SignalEvents.SignalDistortion。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"事件前的名义信号\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput y \"事件后的接收信号\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput noise \"同单位的外部扰动序列\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Boolean enabled = true \"为 false 时整个运行处于名义状态\"</code></li>
<li><code>Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"</code></li>
<li><code>Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"</code></li>
<li><code>Real gain = 1 \"无量纲噪声权重\"</code></li>
</ul>
<p><b>时序与基准行为</b> 每次连续求值，结束后直通。</p>
<p><b>最小用法</b> 把记录回放或带固定种子的 MSL 源接到 noise。 <a href=\"modelica://AnomalyLibrary.Examples.DeterministicCommunication\">SignalCommunicationEvent</a> 展示同域接线。</p>
<p><b>适用边界</b> 统计性质由噪声源定义。</p>
</html>"));
end NoiseInjection;
