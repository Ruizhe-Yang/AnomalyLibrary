within AnomalyLibrary.Electrical;
model SwitchedCapacitiveLoad "Capacitive load connected through a finite resistance"
  parameter Boolean enabled = true "Enable the configured disturbance";
  parameter Modelica.Units.SI.Time eventStartTime = 2 "Inclusive start of the event interval";
  parameter Modelica.Units.SI.Time eventEndTime = 4 "Exclusive end of the event interval";
  Modelica.Blocks.Interfaces.BooleanOutput active "The scheduled capacitor connection is active" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin p "Positive electrical pin" annotation(Placement(transformation(extent={{-107,-7},{-93,7}}), iconTransformation(extent={{-107,-7},{-93,7}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative electrical pin" annotation(Placement(transformation(extent={{93,-7},{107,7}}), iconTransformation(extent={{93,-7},{107,7}})));
  Modelica.Units.SI.Voltage v "Voltage from p to n";
  Modelica.Units.SI.Current i "Current entering pin p";
  parameter Modelica.Units.SI.Capacitance C(min=Modelica.Constants.small) = 0.01 "Capacitance of the switched load";
  parameter Modelica.Units.SI.Resistance R(min=Modelica.Constants.small) = 0.5 "Closed-contact current-limiting resistance";
  parameter Modelica.Units.SI.Voltage initialVoltage = 0 "Initial capacitor voltage";
protected
  Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch contact(Ron=R,Goff=0) "Switch with finite closed resistance and zero open conductance";
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=C,v(start=initialVoltage,fixed=true)) "Capacitor retaining its voltage when disconnected";
  AnomalyLibrary.Utilities.Internal.EventActivation eventWindow(enabled=enabled,eventStartTime=eventStartTime,eventEndTime=eventEndTime) "Scheduled event interval";
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
    Documentation(info="<html><p>A capacitor with fixed initial voltage is connected through an opening switch whose closed resistance is <code>R</code> and whose open conductance is zero. During <code>[eventStartTime,eventEndTime)</code>, <code>enabled=true</code> closes the contact. Outside that interval the external branch current is zero and the capacitor retains its voltage. Inrush depends on the initial voltage and connected network; small <code>R*C</code> can introduce a fast transient.</p><p>Connect p and n across a bus; set C, R, initialVoltage and the event interval.</p><p>See <a href=\"modelica://AnomalyLibrary.Examples.ElectricalDisturbances\">ElectricalDisturbances</a> for connections.</p></html>"));
end SwitchedCapacitiveLoad;
