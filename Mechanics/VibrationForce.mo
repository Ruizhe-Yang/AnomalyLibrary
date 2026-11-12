within AnomalyLibrary.Mechanics;
model VibrationForce "施加给定频率的外部振动载荷"
  parameter Boolean enabled = true "为 false 时整个运行处于名义状态";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "开始时刻，包含";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "结束时刻，不包含";
  Modelica.Blocks.Interfaces.BooleanOutput active "事件窗有效" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Modelica.Units.SI.Force amplitude = 10 "力幅值，N";
  parameter Modelica.Units.SI.Frequency frequency(min=0) = 10 "频率，Hz";
  Modelica.Mechanics.Translational.Interfaces.Flange_b flange "受外力的平动节点" annotation(Placement(transformation(extent={{-7,-107},{7,-93}}), iconTransformation(extent={{-7,-107},{7,-93}})));
  Modelica.Blocks.Interfaces.RealOutput appliedForce(unit="N") "沿坐标正向施加为正" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
protected
  Modelica.Mechanics.Translational.Sources.Force source;
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime);
initial equation
  assert(frequency >= 0, "Frequency must be nonnegative.");
equation
  active = eventWindow.active;
  appliedForce = if active then amplitude*sin(2*Modelica.Constants.pi*frequency*(time-eventStartTime)) else 0;
  source.f = appliedForce;
  connect(source.flange, flange);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-37,-36},{37,25}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Line(points={{0,-36},{0,-100}}, color={64,64,64}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-48,-47},{48,-47}}, color={160,160,164}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-62,57},{-58.9,61.94},{-55.8,66.4},{-52.7,69.94},{-49.6,72.22},{-46.5,73},{-43.4,72.22},{-40.3,69.94},{-37.2,66.4},{-34.1,61.94},{-31,57},{-27.9,52.06},{-24.8,47.6},{-21.7,44.06},{-18.6,41.78},{-15.5,41},{-12.4,41.78},{-9.3,44.06},{-6.2,47.6},{-3.1,52.06},{0,57},{3.1,61.94},{6.2,66.4},{9.3,69.94},{12.4,72.22},{15.5,73},{18.6,72.22},{21.7,69.94},{24.8,66.4},{27.9,61.94},{31,57},{34.1,52.06},{37.2,47.6},{40.3,44.06},{43.4,41.78},{46.5,41},{49.6,41.78},{52.7,44.06},{55.8,47.6},{58.9,52.06},{62,57}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-29,-17},{29,15}}, textString="F(t)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="VibrationForce")}),
    Documentation(info="<html><p><b>Purpose</b> 施加给定频率的外部振动载荷</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"; Modelica.Mechanics.Translational.Interfaces.Flange_b flange \"受外力的平动节点\"; Modelica.Blocks.Interfaces.RealOutput appliedForce(unit=\"N\") \"沿坐标正向施加为正\"</p><p><b>Parameters</b> parameter Boolean enabled = true \"为 false 时整个运行处于名义状态\"; parameter Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"; parameter Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"; parameter Modelica.Units.SI.Force amplitude = 10 \"力幅值，N\"; parameter Modelica.Units.SI.Frequency frequency(min=0) = 10 \"频率，Hz\"</p><p><b>Behavior</b> 施加给定频率的外部振动载荷</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Use the declared activation inputs and timing.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.MechanicalImpulseAndContact\">AnomalyLibrary.Examples.MechanicalImpulseAndContact</a></p>
<p>施加给定频率的外部振动载荷</p>
<p>专业分类为 MechanicalEvents.ExternalLoads。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"</code></li>
<li><code>Modelica.Mechanics.Translational.Interfaces.Flange_b flange \"受外力的平动节点\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput appliedForce(unit=\"N\") \"沿坐标正向施加为正\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Boolean enabled = true \"为 false 时整个运行处于名义状态\"</code></li>
<li><code>Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"</code></li>
<li><code>Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"</code></li>
<li><code>Modelica.Units.SI.Force amplitude = 10 \"力幅值，N\"</code></li>
<li><code>Modelica.Units.SI.Frequency frequency(min=0) = 10 \"频率，Hz\"</code></li>
</ul>
<p><b>时序与基准行为</b> 从事件开始计相位，退出后卸载。</p>
<p><b>最小用法</b> 把 flange 接质量块，施力由外界供给。 <a href=\"modelica://AnomalyLibrary.Examples.CombinedAnomalies\">MechanicalImpactEvent</a> 展示同域接线。</p>
<p><b>适用边界</b> 频率非负。窗口终点若不在零交点，可产生瞬时卸载。</p>
</html>"));
end VibrationForce;
