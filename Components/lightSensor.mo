within solarGreenhouseV2.Components;
model lightSensor
  parameter Modelica.Units.SI.Angle sensor_azimuth;
  parameter Modelica.Units.SI.Angle sensor_zenith;
  input Modelica.Units.SI.Angle sun_azimuth  annotation (Dialog);
  input Modelica.Units.SI.Angle sun_zenith  annotation (Dialog);
  input Modelica.Units.SI.HeatFlux Dni  annotation (Dialog);
  input Modelica.Units.SI.HeatFlux Dhi  annotation (Dialog);
  input Real sky_fraction annotation (Dialog);
  input Real albedo annotation (Dialog);

  Modelica.Units.SI.Angle theta_betweeen "angle between sun vector and sensor normal";
  Modelica.Units.SI.HeatFlux direct_flux;
  Modelica.Units.SI.HeatFlux diffuse_flux;
  Real horizon_angle;

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(tableOnFile=false,
      table=[-1.56820354472236,0.054545454545455; -1.47770425634906,
        0.070454545454546; -1.40319429499254,0.097727272727273; -1.34199011608064,
        0.120454545454545; -1.27814172301307,0.156818181818182; -1.22493825844286,
        0.189772727272727; -1.15044493687794,0.229545454545454; -1.09192127712155,
        0.265909090909091; -1.04404405857084,0.3; -0.974895135525334,
        0.354545454545454; -0.921714361580032,0.404545454545454; -0.879170952590453,
        0.445454545454545; -0.825993204061805,0.497727272727273; -0.780805580916565,
        0.552272727272727; -0.732951052990759,0.603409090909091; -0.698393231259606,
        0.643181818181818; -0.631915751119652,0.704545454545454; -0.581394318413281,
        0.752272727272727; -0.522885785740156,0.8; -0.467033568889307,
        0.843181818181818; -0.413840693277389,0.884090909090909; -0.352657692282063,
        0.922727272727273; -0.291453513370159,0.945454545454545; -0.208953426630232,
        0.970454545454545; -0.073209032195268,0.997727272727273; -0.003996575400031,
        1; 0.075886525934123,0.995454545454545; 0.161094360579445,0.986363636363636;
        0.22501385093838,0.969318181818182; 0.296926492097377,0.947727272727273;
        0.344882371481094,0.922727272727273; 0.419483095337236,0.881818181818182;
        0.478109619259869,0.840909090909091; 0.520752866999034,0.806818181818182;
        0.579391492588284,0.756818181818182; 0.635367751521949,0.706818181818182;
        0.699346237505638,0.645454545454546; 0.742007637744727,0.597727272727273;
        0.787337455472709,0.545454545454545; 0.829998855711798,0.497727272727273;
        0.869994863878648,0.452272727272727; 0.923305730740075,0.404545454545454;
        0.976616597601502,0.356818181818182; 1.04857613271864,0.3;
        1.09654108835232,0.268181818181818; 1.15782695351388,0.229545454545454;
        1.22177215991438,0.193181818181818; 1.28305499965929,0.156818181818182;
        1.35232645207928,0.119318181818182; 1.40560252664918,0.097727272727273;
        1.49083456462774,0.070454545454546; 1.56540503431734,0.052272727272728])
    "from hobo mx2202 manual plot, extracted with web plot digitizer"
    annotation (Placement(transformation(extent={{-82,54},{-62,74}})));
  //parameter Modelica.Units.SI.Angle theta_between = 0.0 "angle between sun vector and sensor normal";


 Modelica.Blocks.Sources.RealExpression realExpressionRadians(y=0)    annotation (Placement(transformation(extent={{-120,56},{-100,76}})));


 Real normalized_acceptance;
 Modelica.Units.SI.HeatFlux ground_flux_incident;
/*
 parameter Integer n= 10000;
 Integer albedo_steps;
 parameter Real step_width = Modelica.Constants.pi/n;
 Real albedo_integral;


*/

equation
  ground_flux_incident = solarGreenhouseV2.Functions.panelIllumination(Dni, Dhi, 1.0, 0, 0, sun_azimuth, sun_zenith);
  theta_betweeen = solarGreenhouseV2.Functions.angleBetweenVecs( sensor_azimuth,sensor_zenith,  sun_azimuth,sun_zenith);
  direct_flux = Dni*cos( theta_betweeen) " assuming perfect cos sensor";
  diffuse_flux = Dhi*0.5 + albedo*ground_flux_incident*0.5 - Dhi*0.5*sin(horizon_angle) + albedo*ground_flux_incident*0.5*sin(horizon_angle) "JULY 13 2021 NOTES,perfect cos sensor";
  horizon_angle = 0.5*Modelica.Constants.pi -   Modelica.Constants.pi*sky_fraction;



  normalized_acceptance =combiTable1Ds.y[1];  // = Modelica.Blocks.Tables.Internal.getTable1DValue(combiTable1Ds, 1, theta_between);

  connect(realExpressionRadians.y, combiTable1Ds.u) annotation (
      Line(points={{-99,66},{-90,66},{-90,64},{-84,64}}, color={0,0,
          127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-46,18},{54,-74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-46,12},{54,22}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end lightSensor;
