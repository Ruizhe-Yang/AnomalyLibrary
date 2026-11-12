within AnomalyLibrary.Utilities.Internal;
block EventActivation "半开事件窗的布尔激活"
  parameter Boolean enabled = true;
  parameter Modelica.Units.SI.Time eventStartTime = 2;
  parameter Modelica.Units.SI.Time eventEndTime = 4;
  output Boolean active;
initial equation
  assert(eventStartTime < eventEndTime, "Event start must precede event end.");
equation
  active = enabled and time >= eventStartTime and time < eventEndTime;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,55},{-65,-48},{68,-48}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-57,-29},{-29,-29},{-29,31},{33,31},{33,-29},{59,-29}}, color={0,0,255}, thickness=1.3, pattern=LinePattern.Solid),
        Ellipse(extent={{-34,26},{-24,36}}, lineColor={0,0,255}, fillColor={0,0,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Ellipse(extent={{28,26},{38,36}}, lineColor={0,0,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=1),
        Text(extent={{-67,-74},{67,-49}}, textString="[t0, t1)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>半开事件窗的布尔激活</p>
<p><b>行为</b> 半开事件窗的布尔激活。</p>
<p><b>最小用法</b> 由本库组件按源码中的参数和接口装配。</p>
<p><b>适用边界</b> 实现细节随本库版本演进。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Boolean enabled = true</code></li>
<li><code>Modelica.Units.SI.Time eventStartTime = 2</code></li>
<li><code>Modelica.Units.SI.Time eventEndTime = 4</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>output Boolean active</code></li>
</ul>
</html>"));
end EventActivation;
