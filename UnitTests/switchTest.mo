within solarGreenhouseV2.UnitTests;
model switchTest "test the smoothed switch functions, example shoing how the scaleFactor works"
  Real val;
  Real val_slow;
  Real x;
  Real x_slow;
equation
  val = solarGreenhouseV2.Functions.onBeforeSwitchVal( x=time,  switchval = 0.5,  scaleFactor = 1000);
  val_slow = solarGreenhouseV2.Functions.onBeforeSwitchVal( x=time,  switchval = 0.5,  scaleFactor = 1);

  x = solarGreenhouseV2.Functions.onAfterSwitchVal( x=time,  switchval = 0.5,  scaleFactor = 1000);
  x_slow = solarGreenhouseV2.Functions.onAfterSwitchVal( x=time,  switchval = 0.5,  scaleFactor = 1);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end switchTest;
