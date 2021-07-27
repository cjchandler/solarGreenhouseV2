within solarGreenhouseV2.UnitTests;
model waterHeatStorageTest
  Components.waterHeatStorage waterHeatStorage annotation (
      Placement(transformation(extent={{26,-26},{46,-6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature annotation (Placement(transformation(
          extent={{-44,-28},{-24,-8}})));
  greenhouseParameters greenhouseParameters1(
    floor_area=2,
    water_Rsi_max=20/5.67,
    water_Rsi_min=1/5.67,
    water_recharge_temp=298.15,
    water_discharge_temp=289.15) annotation (Placement(
        transformation(extent={{-54,12},{-34,32}})));
equation
  prescribedTemperature.T = (273 + time)*1;
  connect(prescribedTemperature.port, waterHeatStorage.port_a)
    annotation (Line(points={{-24,-18},{20,-18},{20,-15},{29.2,-15}},
        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end waterHeatStorageTest;
