within solarGreenhouseV2.UnitTests;
model climateControllerTest
  "test the venting, heating, blanket controller. The heat turns off at time = 15, vents open at time = 30 , blanket opens at time = 500ish. No asserts here, just look to see that it's working, all the transitions are smooth and not quite exact"
  Components.climateController climateController(Params=Params,
      Consts=Consts, sun_zenith = sun_zenith) annotation (Placement(transformation(extent={{
            12,-26},{32,-6}})));
  Components.perscribedWetAir inside(P=Params, C=Consts, air_temp= inside_temp,  relative_humidity_percent = 50)
    annotation (Placement(transformation(extent={{-28,-24},{-8,-4}})));
  Components.perscribedWetAir outside(P=Params, C=Consts, air_temp= 273,  relative_humidity_percent = 50)
    annotation (Placement(transformation(extent={{54,-42},{74,-22}})));
  parameter greenhouseParametersForTesting Params(
    max_ACH=200,
    max_temp=303.15,
    min_temp=288.15,
    heater_max_power=200)                         annotation (Placement(
        transformation(extent={{-96,68},{-76,88}})));
  parameter physicalConstants Consts annotation (Placement(transformation(
          extent={{-96,42},{-76,62}})));

  Modelica.Units.SI.Angle sun_zenith;
  Modelica.Units.SI.Temperature inside_temp;
  parameter Real one=1;

equation
  sun_zenith = Modelica.Units.Conversions.from_deg( -0.01*time + 90);
  inside_temp = Modelica.Units.Conversions.from_degC(time*one);
  connect(inside.heatPort_a, climateController.port_a) annotation (
     Line(points={{-20.4,-15.2},{-5.2,-15.2},{-5.2,-17.8},{13.4,-17.8}},
        color={191,0,0}));
  connect(inside.waterMassPort_a, climateController.waterMassPort_a)
    annotation (Line(points={{-15.6,-15.2},{-2.8,-15.2},{-2.8,-13.6},
          {13.4,-13.6}}, color={0,0,255}));
  connect(outside.heatPort_a, climateController.port_b)
    annotation (Line(points={{61.6,-33.2},{60,-33.2},{60,-18},{30.8,
          -18}}, color={191,0,0}));
  connect(outside.waterMassPort_a, climateController.waterMassPort_b)
    annotation (Line(points={{66.4,-33.2},{78,-33.2},{78,-14},{30.4,
          -14}}, color={0,0,255}));
  annotation(experiment(StartTime=0, StopTime=800,Interval = 0.01, Tolerance=1e-6),
              Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end climateControllerTest;
