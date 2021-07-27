within solarGreenhouseV2.UnitTests;
model simplerTranspiration2 "test of transpirationconvection, using case example on pg 42 stanghellini 1987. 
  Note that r_i is not calculated to be 200 but something like 114. This doesn't 
  really matter when checking the leaf temperature. LAI = 0.5 so that it is the 
  same as a single leaf surface"
  Components.perscribedWetAir perscribedWetAir(
    P=Params,
    C=Consts,
    V=1e6,
    air_temp=Modelica.Units.Conversions.from_degC(20),
    relative_humidity_percent = 75)
    annotation (Placement(transformation(extent={{54,4},{74,24}})));
  parameter physicalConstants Consts annotation (Placement(transformation(
          extent={{-128,46},{-108,66}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow
    fixedRabsorbed(Q_flow=500) annotation (Placement(transformation(
          extent={{-74,42},{-54,62}})));
  parameter greenhouseParametersForTesting Params(floor_area=1)           annotation (Placement(transformation(
          extent={{-128,18},{-108,38}})));
  Flows.transpirationConvection transpirationConvection(
    C=Consts,
    P=Params,
    Radiation_absorbed=fixedRabsorbed.Q_flow/transpirationConvection.floor_area,
    floor_area=1,
    Radiation_thermal=greyBodyRadiation.Q_flow,
    LAI = 3)                                                                        annotation (
     Placement(transformation(extent={{12,-2},{32,18}})));

                                                   //-greyBodyRadiation.Q_flow/Params.floorArea + canopyTranspiring.PARNIR_incident,
                                                   //-greyBodyRadiation.Q_flow/Params.floorArea + canopyTranspiring.PARNIR_absorbed,
  Interfaces.perscribedWaterVapourPressure
    perscribedWaterVapourFlow(VP=
        solarGreenhouseV2.Functions.saturatedVapourPressure(
        transpirationConvection.HeatPort_a.T)) annotation (
      Placement(transformation(extent={{-46,-10},{-26,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor(C=0.001, T(fixed=true, start=292.15)) annotation (
     Placement(transformation(extent={{-48,16},{-28,36}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    fixedTemperature(T=293.15) annotation (Placement(transformation(
          extent={{-64,72},{-44,92}})));
  Flows.greyBodyRadiation greyBodyRadiation(
    epsilon_a=1,
    epsilon_b=1,
    A_a=1,
    A_b=1,
    AF=1) annotation (Placement(transformation(extent={{-30,72},{
            -10,92}})));
equation
  connect(transpirationConvection.HeatPort_b, perscribedWetAir.heatPort_a)
    annotation (Line(points={{32,10},{50,10},{50,12.8},{61.6,12.8}},
        color={191,0,0}));
  connect(transpirationConvection.MassPort_b, perscribedWetAir.waterMassPort_a)
    annotation (Line(
      points={{32,6},{50,6},{50,0},{66.4,0},{66.4,12.8}},
      color={0,0,255},
      thickness=1));
  connect(perscribedWaterVapourFlow.waterMassPort_a,
    transpirationConvection.MassPort_a) annotation (Line(points={{-35.8,
          0.2},{6,0.2},{6,6},{12,6}}, color={0,0,255}));
  connect(fixedRabsorbed.port, heatCapacitor.port) annotation (Line(
        points={{-54,52},{-22,52},{-22,16},{-38,16}}, color={191,0,0}));
  connect(heatCapacitor.port, transpirationConvection.HeatPort_a)
    annotation (Line(points={{-38,16},{6,16},{6,10},{12,10}}, color=
         {191,0,0}));
  connect(fixedTemperature.port, greyBodyRadiation.port_a)
    annotation (Line(points={{-44,82},{-30,82}}, color={191,0,0}));
  connect(greyBodyRadiation.port_b, heatCapacitor.port) annotation (
     Line(points={{-10,82},{-4,82},{-4,16},{-38,16}}, color={191,0,
          0}));
  if time > 0.5 then
    assert( transpirationConvection.canopy_temp > Modelica.Units.Conversions.from_degC(23) and transpirationConvection.canopy_temp < Modelica.Units.Conversions.from_degC(25),  "temperature of canopy out of range");
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, __Dymola_Algorithm="Dassl"));
end simplerTranspiration2;
