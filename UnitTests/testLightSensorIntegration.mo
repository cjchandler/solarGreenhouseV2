within solarGreenhouseV2.UnitTests;
model testLightSensorIntegration

 Real D;
equation
  D = solarGreenhouseV2.Functions.Diffuse_2interface( 1.53);
end testLightSensorIntegration;
