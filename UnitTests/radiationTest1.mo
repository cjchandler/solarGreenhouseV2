within solarGreenhouseV2.UnitTests;
model radiationTest1 "simple thermal FIR radiation test"
  parameter physicalConstants Consts
    annotation (Placement(transformation(extent={{-100,58},{-80,78}})));

   parameter Real surface_emissivity = 1.0;
   parameter Real surface_area = 1;
   parameter Real air_emissivity = 0.7;
   //parameter Real objectEmissvity = 0.9;
   //parameter Real objectArea = 1;
   //parameter Real Transmission = 0.4;
   Real Qtest;

  Flows.greyBodyRadiation greyBodyRadiation5(
    epsilon_a=air_emissivity,
    epsilon_b=surface_emissivity,
    A_a=1,
    A_b=1,
    AF=1)
    annotation (Placement(transformation(extent={{-8,44},{12,64}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cold(T=283.15)
    annotation (Placement(transformation(extent={{-54,44},{-34,64}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature hot(T=293.15)
    annotation (Placement(transformation(extent={{42,38},{62,58}})));
equation
  Qtest = Modelica.Constants.sigma*surface_area*air_emissivity*surface_emissivity*(-(283.15^4) +(293.15^4));
  //this test works for one black body, one grey body. for two grey bodies it's close but not quite right
  //Qtest should equal Q_flow in valid region.


  connect(cold.port, greyBodyRadiation5.port_a)
    annotation (Line(points={{-34,54},{-8,54}}, color={191,0,0}));
  connect(greyBodyRadiation5.port_b, hot.port) annotation (Line(
        points={{12,54},{40,54},{40,68},{68,68},{68,48},{62,48}},
        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end radiationTest1;
