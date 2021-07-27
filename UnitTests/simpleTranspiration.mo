within solarGreenhouseV2.UnitTests;
model simpleTranspiration "test of canopy transpiration"
  Components.perscribedWetAir perscribedWetAir(
    P=Params,
    C=Consts,
    V=1e6,
    air_temp=Modelica.Units.Conversions.from_degC(20),
    relative_humidity_percent = 75)
    annotation (Placement(transformation(extent={{54,4},{74,24}})));
  parameter physicalConstants Consts annotation (Placement(transformation(
          extent={{-128,46},{-108,66}})));
  parameter greenhouseParameters Params(floor_area=1)           annotation (Placement(transformation(
          extent={{-128,18},{-108,38}})));
  Components.CanopyTranspiring canopyTranspiring(
    P=Params,
    C=Consts,
    PAR_absorbed=45,
    NIR_absorbed=55)
      annotation (
      Placement(transformation(extent={{-26,-4},{-6,16}})));

  Flows.transpirationConvection transpirationConvection(
    C=Consts,
    P=Params,
    floor_area=1,
    Radiation_absorbed=canopyTranspiring.PARNIR_flux_absorbed,
    LAI = canopyTranspiring.LAI,
    Radiation_thermal=-greyBodyRadiation.Q_flow)
    annotation (Placement(transformation(extent={{6,-6},{26,14}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    fixedTemperature(T=283.15) annotation (Placement(transformation(
          extent={{-44,64},{-24,84}})));
  Flows.greyBodyRadiation greyBodyRadiation(
    epsilon_a=0.73,
    epsilon_b=1,
    A_a=1,
    A_b=1,
    AF=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,52})));
equation
  connect(canopyTranspiring.port_a, transpirationConvection.HeatPort_a)
    annotation (Line(points={{-14,6},{6,6}}, color={191,0,0}));
  connect(canopyTranspiring.waterMassPort, transpirationConvection.MassPort_a)
    annotation (Line(points={{-14,1.8},{-14,-8},{0,-8},{0,2},{6,2}},
        color={0,0,255}));
  connect(transpirationConvection.HeatPort_b, perscribedWetAir.heatPort_a)
    annotation (Line(points={{26,6},{48,6},{48,12.8},{61.6,12.8}},
        color={191,0,0}));
  connect(transpirationConvection.MassPort_b, perscribedWetAir.waterMassPort_a)
    annotation (Line(
      points={{26,2},{50,2},{50,0},{66.4,0},{66.4,12.8}},
      color={0,0,255},
      thickness=1));
  connect(greyBodyRadiation.port_a, transpirationConvection.HeatPort_a)
    annotation (Line(points={{-2,42},{-2,6},{6,6}}, color={191,0,0}));
  connect(greyBodyRadiation.port_b, fixedTemperature.port)
    annotation (Line(points={{-2,62},{0,62},{0,74},{-24,74}}, color=
         {191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_Algorithm="Dassl"));
end simpleTranspiration;
