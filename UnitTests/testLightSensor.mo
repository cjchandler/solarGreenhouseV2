within solarGreenhouseV2.UnitTests;
model testLightSensor
  Components.lightSensor lightSensor(
    sensor_azimuth=3.1415926535898,
    sensor_zenith=1.0471975511966,
    sun_azimuth=3.1415926535898,
    sun_zenith=1.0471975511966,
    Dni=300,
    Dhi=50,
    sky_fraction=0.66666,
    albedo=0.8)
              annotation (Placement(transformation(extent={{-18,
            -18},{2,2}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end testLightSensor;
