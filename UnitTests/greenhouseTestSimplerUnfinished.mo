within solarGreenhouseV2.UnitTests;
model greenhouseTestSimplerUnfinished
  "a full greenhouse model with the flows worked by hand for verification"

  Components.lightAbsorption lightAbsorption(P=Params,
    panels_PAR_transmitted={roof.transmitted_PAR,southWall.transmitted_PAR},
    panels_NIR_transmitted={roof.transmitted_NIR,southWall.transmitted_NIR})
                                                       annotation (
     Placement(transformation(extent={{-124,78},{-104,98}})));

  Components.panel roof( C=Consts,  Dhi = weatherFromFile.weather.Dhi,
   Dni = weatherFromFile.weather.Dni,P=Params,  blanket_fraction = 0,
   sun_azimuth =  weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith)   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={16,34})));
  parameter greenhouseParameters Params(
    outside_albedo_PAR=0.9,
    outside_albedo_NIR=0.9,
    soil_emissivity=1,
    glazing_emissivity=0.4,
    glazing_FIR_transmission=0,
    max_ACH=2000) annotation (Placement(transformation(extent={{-124,
            48},{-104,68}})));
  parameter physicalConstants Consts annotation (Placement(transformation(
          extent={{-124,20},{-104,40}})));
  Components.panel southWall(  C=Consts,  Dhi = weatherFromFile.weather.Dhi,
   Dni = weatherFromFile.weather.Dni,P=Params,  blanket_fraction = 0,
    i=2,
   sun_azimuth =  weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,-22})));
  Components.Soil soil(P=Params, C=Consts,
    PAR_absorbed=lightAbsorption.PAR_absorbed_soil,
    NIR_absorbed=lightAbsorption.NIR_absorbed_soil)
                                           annotation (Placement(
        transformation(extent={{4,-88},{24,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    fixedTemperature(T=Params.deep_soil_temperature) annotation (
      Placement(transformation(extent={{-14,-114},{6,-94}})));
  Components.WeatherFromFile weatherFromFile annotation (Placement(
        transformation(extent={{-96,76},{-76,96}})));
  Flows.FreeConvectionCondensation convecRoof(
    P=Params,
    C=Consts,
    A=Params.panel_areas[1],
    L=Params.ceiling_height,
    phi=0,
    air_is_above_surface=false) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,12})));
  Flows.FreeConvectionCondensation convecSouthWall(
    P=Params,
    C=Consts,
    A=Params.panel_areas[2],
    L=Params.ceiling_height,
    phi=90) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-38,-26})));
  Flows.FreeConvection freeConvection1(
    P=Params,
    C=Consts,
    A=Params.floor_area,
    L=2,
    phi=0)                             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-12,-70})));
  Components.wetAir air(C = Consts, P = Params, T(fixed = true, start = 293.15)) annotation (
    Placement(visible = true, transformation(extent = {{14, -38}, {34, -18}}, rotation = 0)));
equation
  connect(fixedTemperature.port, soil.port_b) annotation (
    Line(points = {{6, -104}, {10, -104}, {10, -86.8}, {7.8, -86.8}}, color = {191, 0, 0}));
  connect(roof.port_a, weatherFromFile.port_air_temp) annotation (
    Line(points = {{8.6, 35.2}, {8.6, 85.2}, {-81.4, 85.2}}, color = {191, 0, 0}));
  connect(southWall.port_a, weatherFromFile.port_air_temp) annotation (
    Line(points = {{-67.2, -29.4}, {-67.2, 86}, {-70, 86}, {-70, 85.2}, {-81.4, 85.2}}, color = {191, 0, 0}));
  connect(convecRoof.waterMassPort_a, roof.waterMassPort_a) annotation (
    Line(points = {{7.8, 20.8}, {14, 20.8}, {14, 30.6}, {12, 30.6}}, color = {0, 0, 255}));
  connect(roof.port_b, convecRoof.heatPort_a) annotation (
    Line(points = {{8.6, 30.6}, {8, 30.6}, {8, 24}, {10, 24}, {10, 21}}, color = {191, 0, 0}));
  connect(southWall.port_b, convecSouthWall.heatPort_a) annotation (
    Line(points = {{-62.6, -29.4}, {-62.6, -36}, {-52, -36}, {-52, -26}, {-47, -26}}, color = {191, 0, 0}));
  connect(convecSouthWall.waterMassPort_a, southWall.waterMassPort_a) annotation (
    Line(points = {{-46.8, -28.2}, {-46.8, -40}, {-62.6, -40}, {-62.6, -26}}, color = {0, 0, 255}));
  connect(freeConvection1.heatPort_a, soil.port_a) annotation (
    Line(points = {{-3, -70}, {8, -70}, {8, -72}, {7.6, -72}, {7.6, -73}}, color = {191, 0, 0}));
  connect(freeConvection1.heatPort_b, air.heatPort_a) annotation (
    Line(points = {{-21, -70.2}, {-26, -70.2}, {-26, -42}, {-16, -42}, {-16, -32}, {10, -32}, {10, -30}, {18, -30}, {18, -29.2}, {21.6, -29.2}}, color = {191, 0, 0}));
  connect(air.heatPort_a, convecSouthWall.heatPort_b) annotation (
    Line(points = {{21.6, -29.2}, {-3.2, -29.2}, {-3.2, -25.8}, {-29, -25.8}}, color = {191, 0, 0}));
  connect(convecSouthWall.waterMassPort_b, air.waterMassPort_a) annotation (
    Line(points = {{-29, -28.2}, {10, -28.2}, {10, -12}, {26.4, -12}, {26.4, -29.2}}, color = {0, 0, 255}, thickness = 1));
  connect(air.heatPort_a, convecRoof.heatPort_b) annotation (
    Line(points = {{21.6, -29.2}, {21.6, -13.6}, {10.2, -13.6}, {10.2, 3}}, color = {191, 0, 0}));
  connect(convecRoof.waterMassPort_b, air.waterMassPort_a) annotation (
    Line(points = {{7.8, 3}, {7.8, -12.5}, {26.4, -12.5}, {26.4, -29.2}}, color = {0, 0, 255}, thickness = 1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end greenhouseTestSimplerUnfinished;
