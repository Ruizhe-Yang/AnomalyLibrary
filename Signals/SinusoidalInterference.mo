within AnomalyLibrary.Signals;
block SinusoidalInterference "叠加具有给定频率和相位的窄带干扰"
  parameter Boolean enabled = true "为 false 时整个运行处于名义状态";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "开始时刻，包含";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "结束时刻，不包含";
  Modelica.Blocks.Interfaces.BooleanOutput active "事件窗有效" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput u "事件前的名义信号" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealOutput y "事件后的接收信号" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  parameter Real amplitude = 0.1 "有符号幅值，信号单位";
  parameter Modelica.Units.SI.Frequency frequency(min=0) = 5 "频率，Hz";
  parameter Modelica.Units.SI.Angle phase = 0 "事件起点的相角，rad";
protected
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime);
initial equation
  assert(frequency >= 0, "Frequency must be nonnegative.");
equation
  active = eventWindow.active;
  y = u + (if active then amplitude*sin(2*Modelica.Constants.pi*frequency*(time-eventStartTime)+phase) else 0);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-66,28},{-64.25,32.2},{-62.5,36.17},{-60.75,39.69},{-59,42.56},{-57.25,44.63},{-55.5,45.78},{-53.75,45.94},{-52,45.12},{-50.25,43.35},{-48.5,40.73},{-46.75,37.4},{-45,33.56},{-43.25,29.41},{-41.5,25.18},{-39.75,21.11},{-38,17.42},{-36.25,14.31},{-34.5,11.96},{-32.75,10.5},{-31,10},{-29.25,10.5},{-27.5,11.96},{-25.75,14.31},{-24,17.42},{-22.25,21.11},{-20.5,25.18},{-18.75,29.41},{-17,33.56},{-15.25,37.4},{-13.5,40.73},{-11.75,43.35},{-10,45.12},{-8.25,45.94},{-6.5,45.78},{-4.75,44.63},{-3,42.56},{-1.25,39.69},{0.5,36.17},{2.25,32.2},{4,28}}, color={0,0,255}, thickness=1.2, pattern=LinePattern.Solid),
        Ellipse(extent={{17,-26},{61,18}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{28,-4},{50,-4}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{39,-15},{39,7}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{4,28},{39,28},{39,18}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-65,-4},{17,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{61,-4},{74,-4}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-67,-74},{67,-49}}, textString="u + sin", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="SinusoidalInterference")}),
    Documentation(info="<html><p><b>Purpose</b> 叠加具有给定频率和相位的窄带干扰</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"; Modelica.Blocks.Interfaces.RealInput u \"事件前的名义信号\"; Modelica.Blocks.Interfaces.RealOutput y \"事件后的接收信号\"</p><p><b>Parameters</b> parameter Boolean enabled = true \"为 false 时整个运行处于名义状态\"; parameter Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"; parameter Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"; parameter Real amplitude = 0.1 \"有符号幅值，信号单位\"; parameter Modelica.Units.SI.Frequency frequency(min=0) = 5 \"频率，Hz\"; parameter Modelica.Units.SI.Angle phase = 0 \"事件起点的相角，rad\"</p><p><b>Behavior</b> 叠加具有给定频率和相位的窄带干扰</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Use the declared activation inputs and timing.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">AnomalyLibrary.Examples.SignalDeviationAndRecovery</a></p>
<p>叠加具有给定频率和相位的窄带干扰</p>
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
<li><code>Real amplitude = 0.1 \"有符号幅值，信号单位\"</code></li>
<li><code>Modelica.Units.SI.Frequency frequency(min=0) = 5 \"频率，Hz\"</code></li>
<li><code>Modelica.Units.SI.Angle phase = 0 \"事件起点的相角，rad\"</code></li>
</ul>
<p><b>时序与基准行为</b> 相位由事件起点定义，退出后干扰为零。</p>
<p><b>最小用法</b> 接在电气测量链的因果信号侧。 <a href=\"modelica://AnomalyLibrary.Examples.DeterministicCommunication\">SignalCommunicationEvent</a> 展示同域接线。</p>
<p><b>适用边界</b> 开启和关闭时可有相位截断，仿真要能解析频率。</p>
</html>"));
end SinusoidalInterference;
