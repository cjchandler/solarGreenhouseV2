within solarGreenhouseV2.Examples;
model conventionalGreenhouse
  "typical commercial greenhouse with negligable wall area"
  solarGreenhouseV2.Components.lightAbsorption lightAbsorption(P = Params, panels_PAR_transmitted = {roof.transmitted_PAR,southRoof.
        transmitted_PAR},                                                                                                                              panels_NIR_transmitted = {roof.transmitted_NIR,southRoof.
        transmitted_NIR})                                                                                                                                                                                                         annotation (
    Placement(visible = true, transformation(extent = {{-124, 72}, {-104, 92}}, rotation = 0)));
  Components.panel roof(C = Consts, Dhi = weatherFromFile.weather.Dhi, Dni = weatherFromFile.weather.Dni, P = Params, blanket_fraction = climateController.blanket_fraction, sun_azimuth = weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {16, 34})));
  parameter greenhouseParameters Params(
    floor_area=2,
    soil_density=1600,
    soil_specific_heat=1000,
    soil_thermal_conductivity=0.7,
    soil_albedo_PAR=0.9,
    soil_albedo_NIR=0.1,
    Rsi_subsoil_insulation=1/5.67,
    wall_area=0.0001,
    wall_density=1000,
    wall_specific_heat=1000,
    wall_thermal_conductivity=1,
    Rsi_wall_insulation=1/5.67,
    wall_emissivity=1,
    n_index=1.53,
    n_panels=2,
    panel_areas={1.06,1.06},
    panel_azimuths={0,3.1415926535898},
    panel_zeniths={0.34906585039887,0.34906585039887},
    panel_sky_fractions={0.888,0.888},
    panel_single_glazed_diffuse_transmissions={0.83,0.83},
    panel_double_glazed_diffuse_transmissions={0.72,0.72},
    panel_structural_fractions={0.03,0.03},
    panel_double_glazed_fractions={0.99999,0.99999},
    panel_canopy_absorptions={0.95,0.95},
    panel_soil_absorptions={0.05,0.05},
    panel_wall_absorptions={0.00001,0.00001},
    single_glazed_Rsi=0.1,
    double_glazed_Rsi=2/5.67,
    blanket_Rsi=1/5.67,
    glazing_heat_capacitance_per_m2=1,
    glazing_FIR_transmission=0.03,
    glazing_emissivity=0.9,
    ceiling_height=2.15,
    air_volume=4.363,
    inflitration_ACH=0.03,
    max_temp=303.15,
    min_temp=288.15,
    heater_max_power=2000,                                                                                                                                                                                         max_ACH = 2000,
    outside_albedo_NIR=0.01,
    outside_albedo_PAR=0.2,                                                                                                                                                                                                        soil_depth = 1,
    soil_emissivity=0.95,                                                                                                                                                                                                        wall_thickness = 0.0001) annotation (
    Placement(transformation(extent = {{-124, 48}, {-104, 68}})));
  parameter physicalConstants Consts annotation (
    Placement(transformation(extent = {{-124, 20}, {-104, 40}})));
  Components.panel southRoof(C = Consts, Dhi = weatherFromFile.weather.Dhi, Dni = weatherFromFile.weather.Dni, P = Params, blanket_fraction = climateController.blanket_fraction, i = 2, sun_azimuth = weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation=0,    origin={-60,30})));
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
  Flows.FreeConvectionCondensation convecRoof(P = Params, C = Consts, A = Params.panel_areas[1], L = Params.ceiling_height,
    phi=20,                                                                                                                          air_is_above_surface = false) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {10, 12})));
  Flows.FreeConvectionCondensation convecSouthRoof(P = Params, C = Consts, A = Params.panel_areas[2], L = Params.ceiling_height,
    phi=20,
    air_is_above_surface=false)                                                                                                            annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-38, -26})));
  Flows.FreeConvection freeConvection(P = Params, C = Consts, A = Params.wall_area, L = Params.ceiling_height, phi = 90) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {50, -58})));
  Flows.FreeConvection freeConvection1(P = Params, C = Consts, A = Params.floor_area, L = 2, phi = 0) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {-12, -70})));
  Components.FIRmodel fIRmodel(blanket_fraction = climateController.blanket_fraction, P = Params, C = Consts) annotation (
    Placement(transformation(extent = {{-100, -10}, {-80, 10}})));
  Components.climateController climateController(Consts = Consts, Params = Params, sun_zenith = weatherFromFile.weather.zenith) annotation (
    Placement(visible = true, transformation(origin = {52, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.CanopyTranspiring canopyTranspiring(C = Consts, NIR_absorbed = lightAbsorption.NIR_absorbed_canopy, P = Params, PAR_absorbed = lightAbsorption.PAR_absorbed_canopy) annotation (
    Placement(visible = true, transformation(origin = {-4, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flows.transpirationConvection transpirationConvection(C = Consts, LAI = canopyTranspiring.LAI, P = Params, Radiation_absorbed = canopyTranspiring.PARNIR_flux_absorbed, Radiation_thermal = fIRmodel.Radiation_thermal_canopy) annotation (
    Placement(visible = true, transformation(origin = {12, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Units.SI.HeatFlowRate totalHeatLost "heat lost through glazing, insulated wall, subsoil. negative is heat lost from structure";
  Modelica.Units.SI.HeatFlowRate totalHeatGain "heat gain is from sun and heater negative is heat lost from structure";
  Modelica.Units.SI.HeatFlowRate netHeat "heat gain - heat lost";
  Flows.greyBlackRadiation Rad_roof_sky(epsilon_a=Params.glazing_emissivity,
      A_a=Params.panel_areas[1]) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={36,54})));
  Flows.greyBlackRadiation Rad_canopy_sky(epsilon_a=Params.canopy_emissivity,
      A_a=sum(Params.panel_areas)*Params.glazing_FIR_transmission*
        (1 - climateController.blanket_fraction)) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,58})));
  Flows.greyBlackRadiation Rad_southWall_sky(epsilon_a=Params.glazing_emissivity,
      A_a=Params.panel_areas[2]) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-112,-28})));
equation
  totalHeatLost = soil.port_b.Q_flow + massiveWall.port_b.Q_flow + roof.Q_flow +southRoof.Q_flow  + climateController.port_b.Q_flow;
//
//totalSolarHeatAbsorbed
  totalHeatGain = lightAbsorption.totalSolarHeatAbsorbed + climateController.heater_power + roof.absorbed_NIR + roof.absorbed_PAR +southRoof.
    absorbed_NIR                                                                                                                                           +southRoof.
    absorbed_PAR;
  netHeat = totalHeatGain + totalHeatLost;
  connect(fixedTemperature.port, soil.port_b) annotation (
    Line(points = {{6, -104}, {10, -104}, {10, -86.8}, {7.8, -86.8}}, color = {191, 0, 0}));
  connect(perscribedWetAir.heatPort_a, massiveWall.port_b) annotation (
    Line(points = {{85.6, -19.2}, {85.6, -52.6}, {70.6, -52.6}}, color = {191, 0, 0}));
  connect(roof.port_a, weatherFromFile.port_air_temp) annotation (
    Line(points = {{8.6, 35.2}, {8.6, 85.2}, {-81.4, 85.2}}, color = {191, 0, 0}));
  connect(southRoof.port_a, weatherFromFile.port_air_temp) annotation (
    Line(points={{-67.4,31.2},{-67.4,86},{-70,86},{-70,85.2},{
          -81.4,85.2}},                                                                 color = {191, 0, 0}));
  connect(convecRoof.waterMassPort_a, roof.waterMassPort_a) annotation (
    Line(points = {{7.8, 20.8}, {14, 20.8}, {14, 30.6}, {12, 30.6}}, color = {0, 0, 255}));
  connect(roof.port_b, convecRoof.heatPort_a) annotation (
    Line(points = {{8.6, 30.6}, {8, 30.6}, {8, 24}, {10, 24}, {10, 21}}, color = {191, 0, 0}));
  connect(convecRoof.waterMassPort_b, air.waterMassPort_a) annotation (
    Line(points = {{7.8, 3}, {7.8, -12.5}, {26.4, -12.5}, {26.4, -29.2}}, color = {0, 0, 255}, thickness = 1));
  connect(air.heatPort_a, convecRoof.heatPort_b) annotation (
    Line(points = {{21.6, -29.2}, {21.6, -13.6}, {10.2, -13.6}, {10.2, 3}}, color = {191, 0, 0}));
  connect(southRoof.port_b,convecSouthRoof. heatPort_a) annotation (
    Line(points={{-67.4,26.6},{-67.4,-36},{-52,-36},{-52,-26},{-47,
          -26}},                                                                      color = {191, 0, 0}));
  connect(convecSouthRoof.waterMassPort_a,southRoof. waterMassPort_a) annotation (
    Line(points={{-46.8,-28.2},{-54,-28.2},{-54,16},{-46,16},{-46,
          26.6},{-64,26.6}},                                                  color = {0, 0, 255}));
  connect(convecSouthRoof.waterMassPort_b, air.waterMassPort_a) annotation (
    Line(points = {{-29, -28.2}, {10, -28.2}, {10, -12}, {26.4, -12}, {26.4, -29.2}}, color = {0, 0, 255}, thickness = 1));
  connect(air.heatPort_a,convecSouthRoof. heatPort_b) annotation (
    Line(points = {{21.6, -29.2}, {-3.2, -29.2}, {-3.2, -25.8}, {-29, -25.8}}, color = {191, 0, 0}));
  connect(freeConvection.heatPort_b, air.heatPort_a) annotation (
    Line(points = {{41, -58.2}, {41, -44.1}, {21.6, -44.1}, {21.6, -29.2}}, color = {191, 0, 0}));
  connect(freeConvection1.heatPort_a, soil.port_a) annotation (
    Line(points = {{-3, -70}, {8, -70}, {8, -72}, {7.6, -72}, {7.6, -73}}, color = {191, 0, 0}));
  connect(freeConvection1.heatPort_b, air.heatPort_a) annotation (
    Line(points = {{-21, -70.2}, {-26, -70.2}, {-26, -42}, {-16, -42}, {-16, -32}, {10, -32}, {10, -30}, {18, -30}, {18, -29.2}, {21.6, -29.2}}, color = {191, 0, 0}));
  connect(massiveWall.port_a, freeConvection.heatPort_a) annotation (
    Line(points = {{63, -58.4}, {59, -58}}, color = {191, 0, 0}));
  connect(fIRmodel.port_wall, massiveWall.port_a) annotation (
    Line(points = {{-85.8, -3.8}, {62, -3.8}, {62, -58.4}, {63, -58.4}}, color = {191, 0, 0}));
  connect(fIRmodel.port_soil, soil.port_a) annotation (
    Line(points = {{-85.6, -7.6}, {-84, -7.6}, {-84, -84}, {2, -84}, {2, -73}, {7.6, -73}}, color = {191, 0, 0}));
  connect(climateController.waterMassPort_a, air.waterMassPort_a) annotation (
    Line(points = {{43.4, -19.6}, {26.4, -19.6}, {26.4, -29.2}}, color = {0, 0, 255}));
  connect(climateController.port_a, air.heatPort_a) annotation (
    Line(points = {{43.4, -23.8}, {21.6, -23.8}, {21.6, -29.2}}, color = {191, 0, 0}));
  connect(climateController.port_b, perscribedWetAir.heatPort_a) annotation (
    Line(points = {{60.8, -24}, {85.6, -24}, {85.6, -19.2}}, color = {191, 0, 0}));
  connect(perscribedWetAir.waterMassPort_a, climateController.waterMassPort_b) annotation (
    Line(points = {{90.4, -19.2}, {76.4, -19.2}, {76.4, -20}, {60.4, -20}}, color = {0, 0, 255}));
  connect(canopyTranspiring.port_a, transpirationConvection.HeatPort_a) annotation (
    Line(points = {{-2, -50}, {2, -50}, {2, -48}}, color = {191, 0, 0}));
  connect(canopyTranspiring.waterMassPort, transpirationConvection.MassPort_a) annotation (
    Line(points = {{-2, -54.2}, {2, -54.2}, {2, -52}}, color = {0, 0, 255}));
  connect(transpirationConvection.HeatPort_b, air.heatPort_a) annotation (
    Line(points = {{22, -48}, {22, -38}, {22, -29.2}, {21.6, -29.2}}, color = {191, 0, 0}));
  connect(transpirationConvection.MassPort_b, air.waterMassPort_a) annotation (
    Line(points = {{22, -52}, {26.4, -52}, {26.4, -29.2}}, color = {0, 0, 255}));
  connect(fIRmodel.port_canopy, canopyTranspiring.port_a) annotation (
    Line(points = {{-83, -0.4}, {-2, -0.4}, {-2, -50}}, color = {191, 0, 0}));
  connect(fIRmodel.port_panel1, roof.port_b) annotation (
    Line(points = {{-85.8, 5}, {-38.9, 5}, {-38.9, 30.6}, {8.6, 30.6}}, color = {191, 0, 0}));
  connect(southRoof.port_b, fIRmodel.port_panel2) annotation (
    Line(points={{-67.4,26.6},{-67.4,2.6},{-85.8,2.6}},                                 color = {191, 0, 0}));
  connect(Rad_roof_sky.port_a, roof.port_a) annotation (Line(
        points={{36,44},{8.6,44},{8.6,35.2}}, color={191,0,0}));
  connect(Rad_roof_sky.port_b, weatherFromFile.port_sky_temp)
    annotation (Line(points={{36,64},{36,90.2},{-81.2,90.2}},
        color={191,0,0}));
  connect(Rad_canopy_sky.port_a, canopyTranspiring.port_a)
    annotation (Line(points={{-2,48},{-2,26},{-4,26},{-4,0},{-2,0},
          {-2,-50}}, color={191,0,0}));
  connect(Rad_canopy_sky.port_b, weatherFromFile.port_sky_temp)
    annotation (Line(points={{-2,68},{0,68},{0,90.2},{-81.2,90.2}},
        color={191,0,0}));
  connect(Rad_southWall_sky.port_a, southRoof.port_a) annotation (
      Line(points={{-102,-28},{-94,-28},{-94,-14},{-104,-14},{-104,
          16},{-76,16},{-76,44},{-60,44},{-60,26},{-67.4,26},{
          -67.4,31.2}}, color={191,0,0}));
  connect(Rad_southWall_sky.port_b, weatherFromFile.port_sky_temp)
    annotation (Line(points={{-122,-28},{-134,-28},{-134,90.2},{-81.2,
          90.2}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    experiment(StartTime = 0, StopTime = 1e+06, Tolerance = 1e-06, Interval = 60.0024));
end conventionalGreenhouse;
