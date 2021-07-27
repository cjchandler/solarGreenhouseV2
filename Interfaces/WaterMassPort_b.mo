within solarGreenhouseV2.Interfaces;
connector WaterMassPort_b
  "water vapour transfer based  on vapour pressure potential"
  Modelica.Units.SI.Pressure VP "Port vapour pressure";
  flow Modelica.Units.SI.MassFlowRate MV_flow
    "Mass flow rate (positive if flowing from outside into the component)";
  annotation (Documentation(info="<html>

</html>"), Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}));
end WaterMassPort_b;
