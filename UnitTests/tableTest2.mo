within solarGreenhouseV2.UnitTests;
model tableTest2 "test of WeatherFromFile"
  parameter physicalConstants Consts
    annotation (Placement(transformation(extent={{-104,-96},{-84,-76}})));
  parameter greenhouseParametersForTesting Params
    annotation (Placement(transformation(extent={{-106,-76},{-86,-56}})));
  Components.WeatherFromFile weatherFromFile annotation (Placement(
        transformation(extent={{-82,54},{-62,74}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    fixedTemperature(T=293.15) annotation (Placement(
        transformation(extent={{-16,66},{4,86}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor(R=10) annotation (Placement(transformation(
          extent={{-56,44},{-36,64}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor1(R=100) annotation (Placement(transformation(
          extent={{-56,68},{-36,88}})));
equation

  connect(weatherFromFile.port_sky_temp, thermalResistor1.port_a)
    annotation (Line(points={{-67.2,68.2},{-66,68.2},{-66,78},{-56,
          78}}, color={191,0,0}));
  connect(weatherFromFile.port_air_temp, thermalResistor.port_a)
    annotation (Line(points={{-67.4,63.2},{-60.7,63.2},{-60.7,54},{
          -56,54}}, color={191,0,0}));
  connect(thermalResistor.port_b, fixedTemperature.port)
    annotation (Line(points={{-36,54},{10,54},{10,76},{4,76}},
        color={191,0,0}));
  connect(thermalResistor1.port_b, fixedTemperature.port)
    annotation (Line(points={{-36,78},{-30,78},{-30,54},{10,54},{10,
          76},{4,76}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end tableTest2;
