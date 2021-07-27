within solarGreenhouseV2.UnitTests;
model wetAirTest "basic test of wet air"
  Components.wetAir wetAir(
    P=Params,
    C=Consts,
    V=1) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  physicalConstants Consts annotation (Placement(transformation(
          extent={{-130,42},{-110,62}})));
  parameter greenhouseParameters Params annotation (Placement(transformation(
          extent={{-130,14},{-110,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow
    fixedHeatFlow1(Q_flow=5) annotation (Placement(transformation(
          extent={{-30,26},{-10,46}})));
  Interfaces.fixedWaterVapourFlow fixedWaterVapourFlow(M_flow=0)
    annotation (Placement(transformation(extent={{36,-8},{56,12}})));
equation
  connect(fixedHeatFlow1.port, wetAir.heatPort_a) annotation (Line(
        points={{-10,36},{-4,36},{-4,14},{-16,14},{-16,-1.2},{-4.4,-1.2}},
        color={191,0,0}));
  connect(fixedWaterVapourFlow.waterMassPort_a, wetAir.waterMassPort_a)
    annotation (Line(points={{46.2,2.2},{12,2.2},{12,-1.2},{0.4,-1.2}},
        color={0,0,255}));
  when time >= 4174 and time <= 4175 then
    assert( wetAir.RH <= 0.128,  "error RH");
    assert( wetAir.RH >= 0.127, "error RH");
  end when;


  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5000, __Dymola_Algorithm="Dassl"));
end wetAirTest;
