within solarGreenhouseV2.UnitTests;
model moistAirEnthalpyTest
  "get enthalpy of air for use in heat loss via venting: example was The enthalpy of humid air at 25oC with specific moisture content  0.01 kg/m3 , can be calculated as:

h = 1.2*(1.006 kJ/kgoC) (25oC) + (0.01 kg/m3) [(1.86 kJ/kgoC) (25oC) + (2501 kJ/kg)]

h =  30180 + 465 + 250100  "
  parameter Real T = Modelica.Units.Conversions.from_degC(25);
  Real x = 0.0;
  Real AH = 0.01;
  Real h;

equation
  h = solarGreenhouseV2.Functions.enthalpyOfHumidAir(T, AH,  1);
  assert(  30180 + 465 + 25010 + 1 >  h,  "h test by hand");
  assert(  30180 + 465 + 25010 - 1 <  h,  "h test by hand");

end moistAirEnthalpyTest;
