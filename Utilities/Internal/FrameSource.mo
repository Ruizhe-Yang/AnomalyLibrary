within AnomalyLibrary.Utilities.Internal;
block FrameSource "Clocked one-field frame source for the communication example"
parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.1;
    Modelica.Blocks.Interfaces.RealOutput u[1] annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput txCount(start=0,fixed=true) annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput sequence annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput sourceTime(unit="s",start=0,fixed=true) annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput validIn annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
equation
  when sample(samplePeriod,samplePeriod) then
    txCount=pre(txCount)+1;
  end when;
  sequence=txCount;
  sourceTime=samplePeriod*sequence;
  u[1]=txCount;
  validIn=txCount>0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{1,-7},{35,27}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{1,17},{35,17}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{4,14},{32,-4}}, textString="n", textColor={64,64,64}, fontSize=0),
        Ellipse(extent={{-62,-18},{-12,32}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-37,24},{-37,30}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-37,7},{-37,33},{-37,7}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-37,7},{-14,-6}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-10,7},{0,7}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-47,-40},{51,-67}}, textString="n+1", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Clocked one-field frame source for the communication example.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealOutput u[1]; Modelica.Blocks.Interfaces.IntegerOutput txCount(start=0,fixed=true); Modelica.Blocks.Interfaces.IntegerOutput sequence; Modelica.Blocks.Interfaces.RealOutput sourceTime(unit=\"s\",start=0,fixed=true); Modelica.Blocks.Interfaces.BooleanOutput validIn</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.1</p><p><b>Behavior</b> Clocked one-field frame source for the communication example</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> u, txCount, sequence, sourceTime, validIn</p><p><b>Example</b> <a href=\"modelica://AnomalyLibrary.Examples.DeterministicCommunication\">AnomalyLibrary.Examples.DeterministicCommunication</a></p></html>"));
end FrameSource;
