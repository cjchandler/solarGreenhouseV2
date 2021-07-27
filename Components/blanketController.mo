within solarGreenhouseV2.Components;
model blanketController
  "control blanket_fraction based on sun angle
  
  input zenith"

  input Modelica.Units.SI.Angle zenith "sun angle in rad"  annotation (Dialog);

  Real blanket_fraction;

equation
  //blanket_fraction = max( 0.0001,  min( 0.9999, solarGreenhouseV1.Functions.onAfterSwitchVal( x=zenith, switchval = Modelica.Units.Conversions.from_deg(85),   scaleFactor = 500)));

  //never exactly 1 or 0 to avoid divide by 0 problems
  blanket_fraction = 0.00005 + 0.9999*
    solarGreenhouseV2.Functions.onAfterSwitchVal(
    x=zenith,
    switchval=Modelica.Units.Conversions.from_deg(85),
    scaleFactor=500) annotation (Icon(coordinateSystem(
          preserveAspectRatio=false), graphics={Rectangle(
          extent={{-72,72},{74,-64}},
          lineColor={175,175,175},
          lineThickness=1),Ellipse(
          extent={{-60,56},{-8,6}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.Solid),Text(
          extent={{-142,0},{154,-60}},
          textColor={175,175,175},
          textString="%name")}), Diagram(coordinateSystem(
          preserveAspectRatio=false), graphics={Rectangle(
          extent={{-74,70},{72,-66}},
          lineColor={175,175,175},
          lineThickness=1),Ellipse(
          extent={{-62,54},{-10,4}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.Solid),Text(
          extent={{-148,-4},{148,-64}},
          textColor={175,175,175},
          textString="%name")}));
end blanketController;
