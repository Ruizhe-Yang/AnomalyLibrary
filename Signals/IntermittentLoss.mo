within AnomalyLibrary.Signals;
block IntermittentLoss "对连续信号施加周期性中断区段"
  parameter Boolean enabled = true "为 false 时整个运行处于名义状态";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "开始时刻，包含";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "结束时刻，不包含";
  Modelica.Blocks.Interfaces.BooleanOutput active "事件窗有效" annotation(Placement(transformation(extent={{94,42},{106,54}}), iconTransformation(extent={{94,42},{106,54}})));
  Modelica.Blocks.Interfaces.RealInput u "事件前的名义信号" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealOutput y "事件后的接收信号" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  parameter Modelica.Units.SI.Time period(min=Modelica.Constants.small) = 0.5 "重复周期，s";
  parameter Real lossFraction(min=0,max=1) = 0.2 "每周期前段的中断比例";
  parameter Real fallback = 0 "中断期输出";
  Modelica.Blocks.Interfaces.BooleanOutput valid "输出来自当前输入" annotation(Placement(transformation(extent={{94,-54},{106,-42}}), iconTransformation(extent={{94,-54},{106,-42}})));
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime);
initial equation
  assert(period > 0 and lossFraction >= 0 and lossFraction <= 1, "Invalid loss cycle.");
equation
  active = eventWindow.active;
  valid = not (active and mod(time-eventStartTime, period) < period*lossFraction);
  y = if valid then u else fallback;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-58,24},{-43,24},{-43,-30},{-24,-30},{-24,24},{-4,24},{-4,-30},{15,-30},{15,24},{35,24},{35,-30},{53,-30},{53,24},{63,24}}, color={0,0,255}, thickness=1.4, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="on / off", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="IntermittentLoss")}),
    Documentation(info="<html><p><b>Purpose</b> 对连续信号施加周期性中断区段</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"; Modelica.Blocks.Interfaces.RealInput u \"事件前的名义信号\"; Modelica.Blocks.Interfaces.RealOutput y \"事件后的接收信号\"; Modelica.Blocks.Interfaces.BooleanOutput valid \"输出来自当前输入\"</p><p><b>Parameters</b> parameter Boolean enabled = true \"为 false 时整个运行处于名义状态\"; parameter Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"; parameter Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"; parameter Modelica.Units.SI.Time period(min=Modelica.Constants.small) = 0.5 \"重复周期，s\"; parameter Real lossFraction(min=0,max=1) = 0.2 \"每周期前段的中断比例\"; parameter Real fallback = 0 \"中断期输出\"</p><p><b>Behavior</b> 对连续信号施加周期性中断区段</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Use the declared activation inputs and timing.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">AnomalyLibrary.Examples.SignalDeviationAndRecovery</a></p>
<p>对连续信号施加周期性中断区段</p>
<p>专业分类为 SignalEvents.SignalInterruption。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"事件前的名义信号\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput y \"事件后的接收信号\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput valid \"输出来自当前输入\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Boolean enabled = true \"为 false 时整个运行处于名义状态\"</code></li>
<li><code>Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"</code></li>
<li><code>Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"</code></li>
<li><code>Modelica.Units.SI.Time period(min=Modelica.Constants.small) = 0.5 \"重复周期，s\"</code></li>
<li><code>Real lossFraction(min=0,max=1) = 0.2 \"每周期前段的中断比例\"</code></li>
<li><code>Real fallback = 0 \"中断期输出\"</code></li>
</ul>
<p><b>时序与基准行为</b> 从事件起点计周期，中断区间左闭右开。退出后立即直通。</p>
<p><b>最小用法</b> 用于重复遮挡或链路间歇掉线。 <a href=\"modelica://AnomalyLibrary.Examples.DeterministicCommunication\">SignalCommunicationEvent</a> 展示同域接线。</p>
<p><b>适用边界</b> 缩短周期会增加事件数。</p>
</html>"));
end IntermittentLoss;
