within solarGreenhouseV2.UnitTests;
model structureTest4Unfinished
  "a full greenhouse model with the flows worked by hand for verification"
  Components.lightAbsorption lightAbsorption(P = Params, panels_PAR_transmitted = {roof.transmitted_PAR, southWall.transmitted_PAR}, panels_NIR_transmitted = {roof.transmitted_NIR, southWall.transmitted_NIR}) annotation (
    Placement(transformation(extent = {{-124, 78}, {-104, 98}})));
  Components.panel roof( C = Consts, Dhi = weatherFromFile.weather.Dhi, Dni = weatherFromFile.weather.Dni,P = Params, blanket_fraction = climateController.blanket_fraction, sun_azimuth = weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {16, 34})));
  parameter greenhouseParameters Params(outside_albedo_PAR = 0.9, outside_albedo_NIR = 0.9, soil_emissivity = 1, glazing_emissivity = 0.4, glazing_FIR_transmission = 0, max_ACH = 2000) annotation (
    Placement(transformation(extent = {{-124, 48}, {-104, 68}})));
  parameter physicalConstants Consts annotation (
    Placement(transformation(extent = {{-124, 20}, {-104, 40}})));
  Components.panel southWall( C = Consts, Dhi = weatherFromFile.weather.Dhi, Dni = weatherFromFile.weather.Dni,P = Params, blanket_fraction = climateController.blanket_fraction, i = 2, sun_azimuth = weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-66, -22})));
  Components.Soil soil(P = Params, C = Consts, PAR_absorbed = lightAbsorption.PAR_absorbed_soil, NIR_absorbed = lightAbsorption.NIR_absorbed_soil) annotation (
    Placement(transformation(extent = {{4, -88}, {24, -68}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = Params.deep_soil_temperature) annotation (
    Placement(transformation(extent = {{-14, -114}, {6, -94}})));
  Components.WeatherFromFile weatherFromFile annotation (
    Placement(transformation(extent = {{-96, 76}, {-76, 96}})));
  Components.perscribedWetAir perscribedWetAir(P = Params, C = Consts, V = 1e6, relative_humidity_percent = weatherFromFile.weather.relative_humidity_percent, air_temp = weatherFromFile.weather.air_temp) annotation (
    Placement(transformation(extent = {{78, -28}, {98, -8}})));
  Components.wetAir air(P = Params, C = Consts, T(fixed = true, start = 293.15)) annotation (
    Placement(transformation(extent = {{14, -38}, {34, -18}})));
  Components.MassiveWall massiveWall(P = Params, C = Consts, PAR_absorbed = lightAbsorption.PAR_absorbed_wall, NIR_absorbed = lightAbsorption.NIR_absorbed_wall) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {68, -52})));
  Flows.FreeConvectionCondensation convecRoof(P = Params, C = Consts, A = Params.panel_areas[1], L = Params.ceiling_height, phi = 0, air_is_above_surface = false) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {10, 12})));
  Flows.FreeConvectionCondensation convecSouthWall(P = Params, C = Consts, A = Params.panel_areas[2], L = Params.ceiling_height, phi = 90) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-38, -26})));
  Flows.FreeConvection freeConvection(P = Params, C = Consts, A = Params.wall_area, L = Params.ceiling_height, phi = 90) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {50, -58})));
  Flows.FreeConvection freeConvection1(P = Params, C = Consts, A = Params.floor_area, L = 2, phi = 0) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {-12, -70})));
  Components.FIRmodel fIRmodel(
    blanket_fraction=climateController.blanket_fraction,
                               P = Params, C = Consts) annotation (
    Placement(transformation(extent = {{-100, -10}, {-80, 10}})));
  Components.climateController climateController(Consts = Consts, Params = Params, sun_zenith = weatherFromFile.weather.zenith)  annotation (
    Placement(visible = true, transformation(origin = {52, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.CanopyTranspiring canopyTranspiring(C = Consts, NIR_absorbed = lightAbsorption.NIR_absorbed_canopy, P = Params, PAR_absorbed = lightAbsorption.PAR_absorbed_canopy)  annotation (
    Placement(visible = true, transformation(origin = {-4, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flows.transpirationConvection transpirationConvection(C = Consts, LAI = canopyTranspiring.LAI, P = Params, Radiation_absorbed = canopyTranspiring.PARNIR_flux_absorbed, Radiation_thermal = fIRmodel.Radiation_thermal_canopy)  annotation (
    Placement(visible = true, transformation(origin = {12, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Units.SI.HeatFlowRate totalHeatLost "heat lost through glazing, insulated wall, subsoil. negative is heat lost from structure";
  Modelica.Units.SI.HeatFlowRate totalHeatGain "heat gain is from sun and heater negative is heat lost from structure";
  Modelica.Units.SI.HeatFlowRate netHeat "heat gain - heat lost";

equation
  totalHeatLost = soil.port_b.Q_flow + massiveWall.port_b.Q_flow + roof.port_a.Q_flow + southWall.port_a.Q_flow + climateController.port_b.Q_flow - fIRmodel.FIR_panel1_sky.Q_flow - fIRmodel.FIR_panel2_sky.Q_flow;
  //totalSolarHeatAbsorbed
  totalHeatGain = lightAbsorption.totalSolarHeatAbsorbed + climateController.heater_power;
  netHeat = totalHeatGain + totalHeatLost;
  connect(fixedTemperature.port, soil.port_b) annotation (
    Line(points = {{6, -104}, {10, -104}, {10, -86.8}, {7.8, -86.8}}, color = {191, 0, 0}));
  connect(perscribedWetAir.heatPort_a, massiveWall.port_b) annotation (
    Line(points = {{85.6, -19.2}, {85.6, -52.6}, {70.6, -52.6}}, color = {191, 0, 0}));
  connect(roof.port_a, weatherFromFile.port_air_temp) annotation (
    Line(points = {{8.6, 35.2}, {8.6, 85.2}, {-81.4, 85.2}}, color = {191, 0, 0}));
  connect(southWall.port_a, weatherFromFile.port_air_temp) annotation (
    Line(points = {{-67.2, -29.4}, {-67.2, 86}, {-70, 86}, {-70, 85.2}, {-81.4, 85.2}}, color = {191, 0, 0}));
  connect(convecRoof.waterMassPort_a, roof.waterMassPort_a) annotation (
    Line(points = {{7.8, 20.8}, {14, 20.8}, {14, 30.6}, {12, 30.6}}, color = {0, 0, 255}));
  connect(roof.port_b, convecRoof.heatPort_a) annotation (
    Line(points = {{8.6, 30.6}, {8, 30.6}, {8, 24}, {10, 24}, {10, 21}}, color = {191, 0, 0}));
  connect(convecRoof.waterMassPort_b, air.waterMassPort_a) annotation (
    Line(points = {{7.8, 3}, {7.8, -12.5}, {26.4, -12.5}, {26.4, -29.2}}, color = {0, 0, 255}, thickness = 1));
  connect(air.heatPort_a, convecRoof.heatPort_b) annotation (
    Line(points = {{21.6, -29.2}, {21.6, -13.6}, {10.2, -13.6}, {10.2, 3}}, color = {191, 0, 0}));
  connect(southWall.port_b, convecSouthWall.heatPort_a) annotation (
    Line(points = {{-62.6, -29.4}, {-62.6, -36}, {-52, -36}, {-52, -26}, {-47, -26}}, color = {191, 0, 0}));
  connect(convecSouthWall.waterMassPort_a, southWall.waterMassPort_a) annotation (
    Line(points = {{-46.8, -28.2}, {-46.8, -40}, {-62.6, -40}, {-62.6, -26}}, color = {0, 0, 255}));
  connect(convecSouthWall.waterMassPort_b, air.waterMassPort_a) annotation (
    Line(points = {{-29, -28.2}, {10, -28.2}, {10, -12}, {26.4, -12}, {26.4, -29.2}}, color = {0, 0, 255}, thickness = 1));
  connect(air.heatPort_a, convecSouthWall.heatPort_b) annotation (
    Line(points = {{21.6, -29.2}, {-3.2, -29.2}, {-3.2, -25.8}, {-29, -25.8}}, color = {191, 0, 0}));
  connect(freeConvection.heatPort_b, air.heatPort_a) annotation (
    Line(points = {{41, -58.2}, {41, -44.1}, {21.6, -44.1}, {21.6, -29.2}}, color = {191, 0, 0}));
  connect(freeConvection1.heatPort_a, soil.port_a) annotation (
    Line(points = {{-3, -70}, {8, -70}, {8, -72}, {7.6, -72}, {7.6, -73}}, color = {191, 0, 0}));
  connect(freeConvection1.heatPort_b, air.heatPort_a) annotation (
    Line(points = {{-21, -70.2}, {-26, -70.2}, {-26, -42}, {-16, -42}, {-16, -32}, {10, -32}, {10, -30}, {18, -30}, {18, -29.2}, {21.6, -29.2}}, color = {191, 0, 0}));
  connect(massiveWall.port_a, freeConvection.heatPort_a) annotation (
    Line(points = {{63, -58.4}, {59, -58}}, color = {191, 0, 0}));
  connect(fIRmodel.port_sky, weatherFromFile.port_sky_temp) annotation (
    Line(points = {{-83, 8.4}, {-83, 72}, {-100, 72}, {-100, 100}, {-72, 100}, {-72, 90.2}, {-81.2, 90.2}}, color = {191, 0, 0}));
  connect(fIRmodel.port_wall, massiveWall.port_a) annotation (
    Line(points = {{-85.8, -3.8}, {62, -3.8}, {62, -58.4}, {63, -58.4}}, color = {191, 0, 0}));
  connect(fIRmodel.port_soil, soil.port_a) annotation (
    Line(points = {{-85.6, -7.6}, {-84, -7.6}, {-84, -84}, {2, -84}, {2, -73}, {7.6, -73}}, color = {191, 0, 0}));
  connect(climateController.waterMassPort_a, air.waterMassPort_a) annotation (
    Line(points={{43.4,-19.6},{26.4,-19.6},{26.4,-29.2}},
                                                     color = {0, 0, 255}));
  connect(climateController.port_a, air.heatPort_a) annotation (
    Line(points={{43.4,-23.8},{21.6,-23.8},{21.6,-29.2}},
                                                     color = {191, 0, 0}));
  connect(climateController.port_b, perscribedWetAir.heatPort_a) annotation (
    Line(points={{60.8,-24},{85.6,-24},{85.6,-19.2}},color = {191, 0, 0}));
  connect(perscribedWetAir.waterMassPort_a, climateController.waterMassPort_b) annotation (
    Line(points={{90.4,-19.2},{76.4,-19.2},{76.4,-20},{60.4,-20}},
                                          color = {0, 0, 255}));
  connect(canopyTranspiring.port_a, transpirationConvection.HeatPort_a) annotation (
    Line(points = {{-2, -50}, {2, -50}, {2, -48}}, color = {191, 0, 0}));
  connect(canopyTranspiring.waterMassPort, transpirationConvection.MassPort_a) annotation (
    Line(points={{-2,-54.2},{2,-54.2},{2,-52}},    color = {0, 0, 255}));
  connect(transpirationConvection.HeatPort_b, air.heatPort_a) annotation (
    Line(points={{22,-48},{22,-38},{22,-29.2},{21.6,-29.2}},
                                          color = {191, 0, 0}));
  connect(transpirationConvection.MassPort_b, air.waterMassPort_a) annotation (
    Line(points={{22,-52},{26.4,-52},{26.4,-29.2}},  color = {0, 0, 255}));
  connect(fIRmodel.port_canopy, canopyTranspiring.port_a) annotation (
    Line(points={{-83,-0.4},{-2,-0.4},{-2,-50}},  color = {191, 0, 0}));
  connect(roof.port_a, fIRmodel.port_panel1) annotation (Line(
        points={{8.6,35.2},{-38.7,35.2},{-38.7,5},{-85.8,5}},
        color={191,0,0}));
  connect(southWall.port_a, fIRmodel.port_panel2) annotation (Line(
        points={{-67.2,-29.4},{-67.2,2.3},{-85.8,2.3},{-85.8,2.6}},
        color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    experiment(StartTime = 0, StopTime = 1e+06, Tolerance = 1e-06, Interval = 60.0024));
end structureTest4Unfinished;
