within AnomalyLibrary.Electrical;
model SwitchedCapacitiveLoad "将带限流电阻的外部电容并入总线"
  parameter Boolean enabled = true "为 false 时整个运行处于名义状态";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "开始时刻，包含";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "结束时刻，不包含";
  Modelica.Blocks.Interfaces.BooleanOutput active "事件窗有效" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin p "正参考端" annotation(Placement(transformation(extent={{-107,-7},{-93,7}}), iconTransformation(extent={{-107,-7},{-93,7}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "负参考端" annotation(Placement(transformation(extent={{93,-7},{107,7}}), iconTransformation(extent={{93,-7},{107,7}})));
  Modelica.Units.SI.Voltage v "p 相对 n 的电压";
  Modelica.Units.SI.Current i "流入 p 的电流";
  parameter Modelica.Units.SI.Capacitance C(min=Modelica.Constants.small) = 0.01 "并入电容，F";
  parameter Modelica.Units.SI.Resistance R(min=Modelica.Constants.small) = 0.5 "串联限流电阻，Ohm";
  parameter Modelica.Units.SI.Voltage initialVoltage = 0 "电容初始电压，V";
protected
  Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch contact(Ron=R,Goff=0);
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=C,v(start=initialVoltage,fixed=true));
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime);
initial equation
  assert(C > 0 and R > 0, "Capacitance and connection resistance must be positive.");
equation
  active = eventWindow.active;
  v = p.v - n.v;
  i = p.i;
  connect(p, contact.p);
  connect(contact.n, capacitor.p);
  connect(capacitor.n, n);
  contact.control = not active;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-100,0},{-62,0}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-62,0},{-32,23}}, color={64,64,64}, thickness=1.2, pattern=LinePattern.Solid),
        Ellipse(extent={{-65,-3},{-59,3}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Ellipse(extent={{-33,-3},{-27,3}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{-30,0},{-6,0}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-6,-31},{-6,31}}, color={64,64,64}, thickness=1.6, pattern=LinePattern.Solid),
        Line(points={{10,-31},{10,31}}, color={64,64,64}, thickness=1.6, pattern=LinePattern.Solid),
        Line(points={{10,0},{100,0}}, color={0,0,255}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{21,26},{55,55}}, textString="C", textColor={0,0,255}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={145,57,25}, textString="SwitchedCapacitiveLoad")}),
    Documentation(info="<html><p><b>Purpose</b> 将带限流电阻的外部电容并入总线</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"; Modelica.Electrical.Analog.Interfaces.PositivePin p \"正参考端\"; Modelica.Electrical.Analog.Interfaces.NegativePin n \"负参考端\"</p><p><b>Parameters</b> parameter Boolean enabled = true \"为 false 时整个运行处于名义状态\"; parameter Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"; parameter Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"; parameter Modelica.Units.SI.Capacitance C(min=Modelica.Constants.small) = 0.01 \"并入电容，F\"; parameter Modelica.Units.SI.Resistance R(min=Modelica.Constants.small) = 0.5 \"串联限流电阻，Ohm\"; parameter Modelica.Units.SI.Voltage initialVoltage = 0 \"电容初始电压，V\"</p><p><b>Behavior</b> 将带限流电阻的外部电容并入总线</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Use the declared activation inputs and timing.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">AnomalyLibrary.Examples.ElectricalDisturbances</a></p>
<p>将带限流电阻的外部电容并入总线</p>
<p>专业分类为 ElectricalEvents.AdditionalCircuit。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput active \"事件窗有效\"</code></li>
<li><code>Modelica.Electrical.Analog.Interfaces.PositivePin p \"正参考端\"</code></li>
<li><code>Modelica.Electrical.Analog.Interfaces.NegativePin n \"负参考端\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Boolean enabled = true \"为 false 时整个运行处于名义状态\"</code></li>
<li><code>Modelica.Units.SI.Time eventStartTime = 2 \"开始时刻，包含\"</code></li>
<li><code>Modelica.Units.SI.Time eventEndTime = 4 \"结束时刻，不包含\"</code></li>
<li><code>Modelica.Units.SI.Capacitance C(min=Modelica.Constants.small) = 0.01 \"并入电容，F\"</code></li>
<li><code>Modelica.Units.SI.Resistance R(min=Modelica.Constants.small) = 0.5 \"串联限流电阻，Ohm\"</code></li>
<li><code>Modelica.Units.SI.Voltage initialVoltage = 0 \"电容初始电压，V\"</code></li>
</ul>
<p><b>时序与基准行为</b> 激活后经有限电阻充放电。退出后零外部电流，电容保持其电压。</p>
<p><b>最小用法</b> 并到有有限馈电阻抗的直流母线。 <a href=\"modelica://AnomalyLibrary.Examples.CombinedAnomalies\">ElectricalExternalShunt</a> 展示同域接线。</p>
<p><b>适用边界</b> 状态与初始电压决定涌流。过小 RC 增加刚性。</p>
</html>"));
end SwitchedCapacitiveLoad;
