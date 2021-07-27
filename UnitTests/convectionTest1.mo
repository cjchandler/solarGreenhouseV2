within solarGreenhouseV2.UnitTests;
model convectionTest1 "simple free convection test"
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature
    fixedTemperatureSurface(T=20)
    annotation (Placement(transformation(extent={{-66,-6},{-46,14}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperatureAir(T=10)
    annotation (Placement(transformation(extent={{38,18},{58,38}})));
  parameter greenhouseParametersForTesting Params;
  parameter physicalConstants Consts;
  Flows.FreeConvection convec_hot_floor(
    P=Params,
    C=Consts,
    L=1,
    A = 1,
    phi=0) annotation (Placement(transformation(extent={{-18,-4},{2,
            16}})));
  Flows.FreeConvection convec_hot_ceiling(
    P=Params,
    C=Consts,
    L=1,
    A=1,
    phi=0,
    air_is_above_surface=false) annotation (Placement(
        transformation(extent={{-16,-38},{4,-18}})));
  Flows.FreeConvection convec_hot_wall(
    P=Params,
    C=Consts,
    L=1,
    A=1,
    phi=90,
    air_is_above_surface=true) annotation (Placement(
        transformation(extent={{-14,-66},{6,-46}})));
equation

  when time > 1 then

    assert(convec_hot_wall.h < 2.91739406059666, "unittest val");
    assert(convec_hot_wall.h > 2.7750821552017, "unittest val");
    assert(convec_hot_floor.h < 4.376091090895, "unittest val");
    assert(convec_hot_floor.h > 4.16262323280256, "unittest val");
    assert(convec_hot_ceiling.h < 1.38047769155416, "unittest val");
    assert(convec_hot_ceiling.h > 1.31313731635639, "unittest val");

  end when;

  connect(fixedTemperatureSurface.port, convec_hot_floor.heatPort_a)
    annotation (Line(points={{-46,4},{-22,4},{-22,6},{-17,6}},
        color={191,0,0}));
  connect(fixedTemperatureSurface.port, convec_hot_ceiling.heatPort_a)
    annotation (Line(points={{-46,4},{-22,4},{-22,-28},{-15,-28}},
        color={191,0,0}));
  connect(fixedTemperatureSurface.port, convec_hot_wall.heatPort_a)
    annotation (Line(points={{-46,4},{-22,4},{-22,-56},{-13,-56}},
        color={191,0,0}));
  connect(convec_hot_floor.heatPort_b, fixedTemperatureAir.port)
    annotation (Line(points={{1,6.2},{64,6.2},{64,28},{58,28}},
        color={191,0,0}));
  connect(convec_hot_ceiling.heatPort_b, fixedTemperatureAir.port)
    annotation (Line(points={{3,-27.8},{64,-27.8},{64,28},{58,28}},
        color={191,0,0}));
  connect(convec_hot_wall.heatPort_b, fixedTemperatureAir.port)
    annotation (Line(points={{5,-55.8},{58,-55.8},{58,6},{64,6},{64,
          28},{58,28}}, color={191,0,0}));
    annotation (Placement(transformation(extent={{-96,48},{-76,68}})),
                Placement(transformation(extent={{-96,72},{-76,92}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end convectionTest1;
