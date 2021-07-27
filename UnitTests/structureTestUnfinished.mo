within solarGreenhouseV2.UnitTests;
model structureTestUnfinished
  "a full greenhouse model with the flows worked by hand for verification"

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

  Components.MassiveWall massiveWall(
    P=Params,
    C=Consts,                        PAR_absorbed=lightAbsorption.PAR_absorbed_wall,
      NIR_absorbed=lightAbsorption.NIR_absorbed_wall)
                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={68,-52})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow
    fixedHeatFlow(Q_flow=0) annotation (Placement(transformation(
          extent={{34,80},{54,100}})));
  Components.lightAbsorption lightAbsorption(
    P=Params,
    panels_PAR_transmitted=weatherFromFile.weather.Dhi*0.45,
    panels_NIR_transmitted=weatherFromFile.weather.Dhi*0.55)
    annotation (Placement(transformation(extent={{-130,76},{-110,
            96}})));
equation
  connect(fixedTemperature.port, soil.port_b) annotation (Line(
        points={{6,-104},{10,-104},{10,-86.8},{7.8,-86.8}}, color={
          191,0,0}));

  connect(fixedHeatFlow.port, weatherFromFile.port_sky_temp)
    annotation (Line(points={{54,90},{58,90},{58,104},{-72,104},{
          -72,90.2},{-81.2,90.2}}, color={191,0,0}));
  connect(soil.port_a, massiveWall.port_a) annotation (Line(points=
         {{7.6,-73},{0,-73},{0,-58.4},{63,-58.4}}, color={191,0,0}));
  connect(soil.port_a, weatherFromFile.port_air_temp) annotation (
      Line(points={{7.6,-73},{7.6,5.5},{-81.4,5.5},{-81.4,85.2}},
        color={191,0,0}));
  connect(massiveWall.port_b, weatherFromFile.port_air_temp)
    annotation (Line(points={{70.6,-52.6},{-5.7,-52.6},{-5.7,85.2},
          {-81.4,85.2}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
  experiment(StartTime = 0, StopTime = 1e6, Tolerance = 1e-6, Interval = 60));
end structureTestUnfinished;
