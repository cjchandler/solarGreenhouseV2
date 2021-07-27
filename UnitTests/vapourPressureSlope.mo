within solarGreenhouseV2.UnitTests;
model vapourPressureSlope
  parameter Real T = Modelica.Units.Conversions.from_degC(15);
  Modelica.Units.SI.PartialPressure vP;
  Real slope;
  Real slope2;
equation
  vP = solarGreenhouseV2.Functions.saturatedVapourPressure(T);
  slope =
    solarGreenhouseV2.Functions.slopeOfSaturatedVapourPressure(T);
  slope2 =
    solarGreenhouseV2.Functions.slopeOfSaturatedVapourPressure2(T);

  assert( abs(slope-slope2) < 1e-3,  "slope error");

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end vapourPressureSlope;
