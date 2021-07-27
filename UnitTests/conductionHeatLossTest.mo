within solarGreenhouseV2.UnitTests;
model conductionHeatLossTest
  "test of conductive heat loss through panels, wall, soil. 4 m2 of panel, 2m2 of floor , 2m2 of wall. blanket, soil, wall are R-40 imperial. glazing is R-2 imperial if no blanket"
  solarGreenhouseV2.Components.lightAbsorption lightAbsorption(P = Params, panels_PAR_transmitted = {roof.transmitted_PAR, southWall.transmitted_PAR}, panels_NIR_transmitted = {roof.transmitted_NIR, southWall.transmitted_NIR}) annotation (
    Placement(visible = true, transformation(extent = {{-124, 72}, {-104, 92}}, rotation = 0)));
  Components.panel roof(C = Consts, Dhi = weatherFromFile.weather.Dhi, Dni = weatherFromFile.weather.Dni, P = Params, blanket_fraction = climateController.blanket_fraction, sun_azimuth = weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {16, 34})));
  parameter greenhouseParameters Params(
    soil_albedo_PAR=1,
    soil_albedo_NIR=1,                   Rsi_subsoil_insulation = 40 / 5.67, Rsi_wall_insulation = 40 / 5.67,
    n_index=4000000,
    n_panels=2,
    panel_single_glazed_diffuse_transmissions={1e-9,1e-9},
    panel_double_glazed_diffuse_transmissions={1e-9,1e-9},
    panel_structural_fractions={1e-9,1e-9},
    single_glazed_Rsi=2/5.67,
    double_glazed_Rsi=2/5.67,                                                                                 blanket_Rsi = 40 / 5.67,
    glazing_FIR_transmission=0.00000003,
    glazing_emissivity=0.9,
    air_volume=1,
    inflitration_ACH=0.0000001,
    max_temp=303.15001,
    min_temp=303.15,
    heater_max_power=10000,
    max_ACH=2000000,
    outside_albedo_NIR=0,
    outside_albedo_PAR=0,
    soil_depth=0.0000001,                                                                                                                                                                                                        soil_emissivity = 1,
    wall_thickness=0.0000001)                                                                                                                                                                                                         annotation (
    Placement(transformation(extent = {{-124, 48}, {-104, 68}})));
  parameter physicalConstants Consts annotation (
    Placement(transformation(extent = {{-124, 20}, {-104, 40}})));
  Components.panel southWall(C = Consts, Dhi = weatherFromFile.weather.Dhi, Dni = weatherFromFile.weather.Dni, P = Params, blanket_fraction = climateController.blanket_fraction, i = 2, sun_azimuth = weatherFromFile.weather.azimuth, sun_zenith = weatherFromFile.weather.zenith) annotation (
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
  Flows.greyBlackRadiation greyBlackRadiation(epsilon_a=Params.glazing_emissivity,
      A_a=Params.panel_areas[2]) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-112,-28})));
Real Q_floor;
Real Q_wall;
Real Q_glazing_roof;
Real Q_glazing_wall;
Real Q_glazing;
Real Q_blanket;
Real Q_analytical;
//Real delta_T;
equation
  when time > 1000 then
   assert( abs(totalHeatLost - Q_analytical)< 1,  "r value error more than 1 watt");
  end when;

  totalHeatLost = soil.port_b.Q_flow + massiveWall.port_b.Q_flow + roof.Q_flow + southWall.Q_flow;// + climateController.port_b.Q_flow;
  //calculated heat loss, 30 c inside:
  -Q_wall=( (massiveWall.port_a.T - massiveWall.port_b.T) * 2)  /(40/5.67);
  -Q_floor=( (soil.port_a.T - soil.port_b.T) * 2)  /(40/5.67);
  Q_glazing_roof =( (roof.port_a.T - roof.port_b.T) * 2)  / (2/5.67);
  Q_glazing_wall =( (southWall.port_a.T - southWall.port_b.T) * 2)  / (2/5.67);
  Q_glazing = Q_glazing_roof + Q_glazing_wall;

  Q_blanket = ( (roof.port_a.T - roof.port_b.T) * 4)  /(40/5.67);
  //delta_T = air.T - perscribedWetAir.air_temp;
  Q_analytical = Q_floor + Q_wall + Q_glazing*( 1-climateController.blanket_fraction) + Q_blanket*( climateController.blanket_fraction);
//
//totalSolarHeatAbsorbed
  totalHeatGain = lightAbsorption.totalSolarHeatAbsorbed + climateController.heater_power + roof.absorbed_NIR + roof.absorbed_PAR + southWall.absorbed_NIR + southWall.absorbed_PAR;
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
  connect(southWall.port_b, fIRmodel.port_panel2) annotation (
    Line(points = {{-62.6, -29.4}, {-62.6, -36}, {-52, -36}, {-52, 2.6}, {-85.8, 2.6}}, color = {191, 0, 0}));
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
  connect(greyBlackRadiation.port_a, southWall.port_a) annotation (
     Line(points={{-102,-28},{-84,-28},{-84,-29.4},{-67.2,-29.4}},
        color={191,0,0}));
  connect(greyBlackRadiation.port_b, weatherFromFile.port_sky_temp)
    annotation (Line(points={{-122,-28},{-134,-28},{-134,90.2},{
          -81.2,90.2}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    experiment(StartTime = 0, StopTime = 1e+06, Tolerance = 1e-06, Interval = 60.0024));
end conductionHeatLossTest;
