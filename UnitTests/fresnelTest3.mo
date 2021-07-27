within solarGreenhouseV2.UnitTests;
model fresnelTest3
  "testing the functions that compute fresnel transmission for direct light at arbitrary angles"
  parameter Real n_index = 1.5;


  Real panel_azimuth = Modelica.Units.Conversions.from_deg(180);
  Real panel_zenith = Modelica.Units.Conversions.from_deg(45);
  Real sun_azimuth = Modelica.Units.Conversions.from_deg(138);
  Real sun_zenith = Modelica.Units.Conversions.from_deg(79);

  Real angleBetween;
  Real rs;
  Real rp;
  Real Direct2;
  Real Direct4;
equation
  ///sun directly above a flat panel. should be 0.9230
  angleBetween =  solarGreenhouseV2.Functions.angleBetweenVecs(
      az1 = panel_azimuth,
      zen1= panel_zenith,
      az2 = sun_azimuth,
      zen2 = sun_zenith);

  rs = solarGreenhouseV2.Functions.Rs(ni = 1,  nt = 1.53,  thetai = angleBetween);
  rp = solarGreenhouseV2.Functions.Rp(ni = 1,  nt = 1.53,  thetai = angleBetween);

  Direct2 = solarGreenhouseV2.Functions.Direct_2interface(1.53, panel_azimuth, panel_zenith,  sun_azimuth, sun_zenith);
  Direct4 = solarGreenhouseV2.Functions.Direct_4interface(1.53, panel_azimuth, panel_zenith,  sun_azimuth, sun_zenith);

  assert( angleBetween > 0.8621 and angleBetween < 0.8623,  " angle error see jun 28 2021 notes");
  assert( rs > 0.1171 and rs < 0.1173,  " rs see jun 28 2021 notes");
  assert( rp > 0.00467 and rp < 0.00469,  " rp see jun 28 2021 notes");
  assert( Direct2 > 0.885 and Direct2 < 0.886,  " Direct2 see jun 28 2021 notes");
  assert( Direct4 > 0.793 and Direct4 < 0.795,  " Direct2 see jun 28 2021 notes");


end fresnelTest3;
