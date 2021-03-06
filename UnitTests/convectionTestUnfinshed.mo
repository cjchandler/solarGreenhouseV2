within solarGreenhouseV2.UnitTests;
model convectionTestUnfinshed
  "simple free convection test with dT going to zero"
  Flows.FreeConvection freeConvectionHotFloor(
    P=Params,
    C=Consts,
    A=1,
    L=1,
    phi=0,
    k=Consts.airThermalconductivity,
    nu=Consts.airKinematicViscosity,
    mu=Consts.airDynamicViscosity,
    Cp=Consts.airSpecificHeatCapacity,
    Beta=Consts.airThermalExpansionCoef,
    a=Consts.airThermalDiffusivity,
    Pr=Consts.airPrandtl)
             annotation (Placement(transformation(extent={{-18,-6},{2,14}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperatureAir(T=10)
    annotation (Placement(transformation(extent={{40,-6},{60,14}})));
  Flows.FreeConvection freeConvectionHotCeiling(
    P=Params,
    C=Consts,
    A=1,
    L=1,
    phi=0,
    airIsAboveSurface=false,
    k=Consts.airThermalconductivity,
    nu=Consts.airKinematicViscosity,
    mu=Consts.airDynamicViscosity,
    Cp=Consts.airSpecificHeatCapacity,
    Beta=Consts.airThermalExpansionCoef,
    a=Consts.airThermalDiffusivity,
    Pr=Consts.airPrandtl)
             annotation (Placement(transformation(extent={{-18,-46},{2,-26}})));
  Flows.FreeConvection freeConvectionHotWall(
    P=Params,
    C=Consts,
    A=1,
    L=1,
    phi=90,
    airIsAboveSurface=true,
    k=Consts.airThermalconductivity,
    nu=Consts.airKinematicViscosity,
    mu=Consts.airDynamicViscosity,
    Cp=Consts.airSpecificHeatCapacity,
    Beta=Consts.airThermalExpansionCoef,
    a=Consts.airThermalDiffusivity,
    Pr=Consts.airPrandtl)
             annotation (Placement(transformation(extent={{-20,-76},{0,-56}})));
  parameter greenhouseParameters Params;
  parameter physicalConstants Consts;
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-66,-6},{-46,14}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=30,
    duration=100,
    startTime=0)
    annotation (Placement(transformation(extent={{-108,-4},{-88,16}})));
equation

  connect(freeConvectionHotFloor.heatPort_b, fixedTemperatureAir.port)
    annotation (Line(points={{1,4.2},{36,4.2},{36,18},{64,18},{64,4},{60,4}},
        color={191,0,0}));
  connect(freeConvectionHotCeiling.heatPort_b, fixedTemperatureAir.port)
    annotation (Line(points={{1,-35.8},{28,-35.8},{28,4},{36,4},{36,18},{64,18},
          {64,4},{60,4}}, color={191,0,0}));
  connect(freeConvectionHotWall.heatPort_b, fixedTemperatureAir.port)
    annotation (Line(points={{-1,-65.8},{28,-65.8},{28,4},{36,4},{36,18},{64,18},
          {64,4},{60,4}}, color={191,0,0}));

  when time > 1 then

   /* assert(freeConvectionHotWall.h < 2.91739406059666, "unittest val");
    assert(freeConvectionHotWall.h > 2.7750821552017, "unittest val");
    assert(freeConvectionHotFloor.h < 4.376091090895, "unittest val");
    assert(freeConvectionHotFloor.h > 4.16262323280256, "unittest val");
    assert(freeConvectionHotCeiling.h < 1.38047769155416, "unittest val");
    assert(freeConvectionHotCeiling.h > 1.31313731635639, "unittest val");
*/
  end when;

  connect(ramp.y, prescribedTemperature.T)
    annotation (Line(points={{-87,6},{-74,6},{-74,4},{-68,4}}, color={0,0,127}));
  connect(prescribedTemperature.port, freeConvectionHotFloor.heatPort_a)
    annotation (Line(points={{-46,4},{-17,4}}, color={191,0,0}));
  connect(prescribedTemperature.port, freeConvectionHotCeiling.heatPort_a)
    annotation (Line(points={{-46,4},{-28,4},{-28,-36},{-17,-36}}, color={191,0,0}));
  connect(prescribedTemperature.port, freeConvectionHotWall.heatPort_a)
    annotation (Line(points={{-46,4},{-28,4},{-28,-66},{-19,-66}}, color={191,0,0}));
    annotation (Placement(transformation(extent={{-96,48},{-76,68}})),
                Placement(transformation(extent={{-96,72},{-76,92}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=140,
      __Dymola_NumberOfIntervals=50000,
      __Dymola_Algorithm="Dassl"));
end convectionTestUnfinshed;
