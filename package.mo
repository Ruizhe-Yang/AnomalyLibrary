within;
package AnomalyLibrary "Deterministic disturbances in signals, communication frames and physical networks"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-59.8,50.6},{-59.8,-44.16},{62.56,-44.16}}, color={160,160,164}, thickness=0.5, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-53.36,-19.32},{-16.56,-19.32},{0,44.16},{16.56,-19.32},{56.12,-19.32}}, color={191,0,0}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-61.64,-68.08},{61.64,-45.08}}, textString="pulse", textColor={64,64,64}, fontSize=0)
      }),
    uses(Modelica(version="4.0.0")), version="1.0.0", Documentation(info="<html><p><b>AnomalyLibrary</b> provides deterministic disturbances for signals, communication frames and physical networks. The library includes signal transformations, frame delivery policies, electrical and mechanical disturbances, heat inputs, fluid paths and selected cross-domain effects.</p><p>The library requires Modelica Standard Library 4.0.0. Begin with <a href=\"modelica://AnomalyLibrary.UsersGuide.GettingStarted\">GettingStarted</a> and <a href=\"modelica://AnomalyLibrary.Examples.SignalDeviationAndRecovery\">SignalDeviationAndRecovery</a>. Configure the activation and connections described by each model; the inactive relation, transition behaviour and recovery depend on the selected component.</p><p>The full manual is provided in <code>docs/UserGuide.md</code>, with a Chinese edition in <code>docs/UserGuide.zh-CN.md</code>.</p></html>"));
end AnomalyLibrary;
