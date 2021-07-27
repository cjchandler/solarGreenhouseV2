within solarGreenhouseV2.UnitTests;
model mistCoolerTest
   Components.perscribedWetAir perscribedWetAir(
    P=Params,
    C=Consts,
    relative_humidity_percent=50,
    air_temp=+273.15 + time)
    annotation (Placement(transformation(extent={{36,-8},{
            56,12}})));
  Components.mistCooler mistCooler(C=Consts)
                                   annotation (Placement(
        transformation(extent={{-22,-4},{-2,16}})));
  parameter greenhouseParameters Params annotation (Placement(
        transformation(extent={{-92,68},{-72,88}})));
  parameter physicalConstants Consts annotation (Placement(
        transformation(extent={{-98,44},{-78,64}})));
equation
  connect(mistCooler.waterMassPort_a, perscribedWetAir.waterMassPort_a)
    annotation (Line(points={{-17.2,6.6},{-26,6.6},{-26,-12},
          {48.4,-12},{48.4,0.8}}, color={0,0,255}));
  connect(mistCooler.port_a, perscribedWetAir.heatPort_a)
    annotation (Line(points={{-17.2,2.8},{-16,2.8},{-16,-8},
          {30,-8},{30,0.8},{43.6,0.8}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end mistCoolerTest;
