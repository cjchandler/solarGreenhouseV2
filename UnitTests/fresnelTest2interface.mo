within solarGreenhouseV2.UnitTests;
model fresnelTest2interface
  "testing the functions that compute fresnel transmission"
  parameter Real n_index = 1.5;

  Real tt1;
  Real tt2;
equation
  ///sun directly above a flat panel. should be 0.9230
  tt1 = solarGreenhouseV2.Functions.Direct_2interface(
    1.5,
    0,
    0,
    0,
    0);

  tt2 = solarGreenhouseV2.Functions.Diffuse_2interface(1.5)
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));

  assert( abs(tt1 -0.9230)< 1e-2,  "Transmission");
end fresnelTest2interface;
