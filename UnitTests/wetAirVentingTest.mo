within solarGreenhouseV2.UnitTests;
model wetAirVentingTest "wet air venting"
  Components.wetAir inside(
    P=Params,
    C=Consts,
    V=1,
    T(fixed=true, start=293.15),
    AH(
      start=6e-6,
      fixed=true,
      displayUnit="kg/m3"))
         annotation (Placement(transformation(extent={{-8,22},{12,42}})));
  parameter physicalConstants Consts annotation (Placement(transformation(
          extent={{-130,42},{-110,62}})));
  parameter greenhouseParameters Params(air_volume=1)
                              annotation (Placement(transformation(
          extent={{-130,14},{-110,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow
    fixedHeatFlow1(Q_flow=0) annotation (Placement(transformation(
          extent={{-48,20},{-28,40}})));
  Components.wetAir outside(
    P=Params,
    C=Consts,
    V=1,
    T(fixed=true, start=283.15),
    AH(
      fixed=true,
      start=2e-6,
      displayUnit="kg/m3"))
         annotation (Placement(transformation(extent={{50,22},{70,42}})));
  Components.venting venting(
    P=Params,
    C=Consts,
    flow_rate = ventingSignal.k)                                          annotation (Placement(transformation(
          extent={{16,-4},{36,16}})));
  Modelica.Blocks.Sources.Constant ventingSignal(k=0.00027777)
    "air changes per hour" annotation (Placement(transformation(
          extent={{4,-40},{24,-20}})));
  Real totalEnthalpy;
equation
  connect(fixedHeatFlow1.port,inside. heatPort_a) annotation (Line(
        points={{-28,30},{-0.4,30.8}},
        color={191,0,0}));
  when time >= 1 and time <= 1 then
    assert(venting.waterMassPort_a.MV_flow  >= 1.1e-9,  "error RH");
    assert(venting.waterMassPort_a.MV_flow  <= 1.2e-9,  "error RH");

    //assert(totalEnthalpy   >= 724701, "error RH");
    //assert(totalEnthalpy   <= 724703, "error RH");

  end when;

  totalEnthalpy = solarGreenhouseV2.Functions.enthalpyOfHumidAir(
    inside.T,
    inside.AH,
    inside.V) + solarGreenhouseV2.Functions.enthalpyOfHumidAir(
    outside.T,
    outside.AH,
    outside.V);
  connect(venting.port_b, outside.heatPort_a) annotation (Line(
        points={{32.6,5.2},{44,5.2},{44,30.8},{57.6,30.8}}, color={191,
          0,0}));
  connect(venting.waterMassPort_b, outside.waterMassPort_a)
    annotation (Line(
      points={{32.6,8.8},{48,8.8},{48,8},{62,8},{62,18},{62.4,18},{62.4,
          30.8}},
      color={0,0,255},
      thickness=1));
  connect(venting.waterMassPort_a, inside.waterMassPort_a)
    annotation (Line(points={{19.8,8.6},{16,8.6},{16,30.8},{4.4,30.8}},
        color={0,0,255}));
  connect(venting.port_a, inside.heatPort_a) annotation (Line(
        points={{19.8,5.2},{19.8,5.6},{-0.4,5.6},{-0.4,30.8}},
        color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=800000, __Dymola_Algorithm="Dassl"));
end wetAirVentingTest;
