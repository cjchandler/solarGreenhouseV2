within solarGreenhouseV2.UnitTests;
model panelTest2
  "testing panel light transmission. see june 28 2021 notes for hand calculation"
  Components.panel panel(
    C=Consts,
    i = 1,
    Dhi = 79,
    Dni = 218,
    sun_azimuth=Modelica.Units.Conversions.from_deg(138),
    sun_zenith=Modelica.Units.Conversions.from_deg(79),
    blanket_fraction = 0.000000001,
    P= Params)
    annotation (Placement(transformation(
          extent={{-44,-4},{-24,16}})));

  Interfaces.fixedWaterVapourFlow fixedWaterVapourFlow(M_flow=0)
    annotation (Placement(transformation(extent={{-40,-44},{-20,-24}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow
    fixedHeatFlow(Q_flow=0) annotation (Placement(transformation(
          extent={{-88,-28},{-68,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow
    fixedHeatFlow1(Q_flow=0) annotation (Placement(transformation(
          extent={{-88,34},{-68,54}})));
  greenhouseParameters Params(
    outside_albedo_PAR=0.8,
    outside_albedo_NIR=0.8,
    floor_area=1,
    n_panels = 1,
    n_index = 1.53,
    panel_areas={1},
    panel_azimuths={3.1415926535898},
    panel_zeniths={Modelica.Units.Conversions.from_deg(45)},
    panel_sky_fractions={0.75},
    panel_single_glazed_diffuse_transmissions={0.83},
    panel_double_glazed_diffuse_transmissions={0.72},
    panel_structural_fractions={0.03},
    panel_double_glazed_fractions={0.999999999},
    panel_canopy_absorptions={0.8}) annotation (Placement(
        transformation(extent={{-130,4},{-110,24}})));
  physicalConstants Consts(PAR_fraction_insolation=0.45,
      NIR_fraction_insolation=0.55)
                           annotation (Placement(transformation(
          extent={{-132,32},{-112,52}})));



  Real transmitted_PAR = 0.7701*218*0.45 + (0.75*79 + Isf*Params.outside_albedo_PAR*0.25)*0.45*0.72*0.97;
  Real transmitted_NIR = 0.7701*218*0.55 + (0.75*79 + Isf*Params.outside_albedo_NIR*0.25)*0.55*0.72*0.97;

  Real absorbed_PAR = 0.794*218*0.45*0.03 + (0.75*79 + Isf*Params.outside_albedo_PAR*0.25)*0.45*0.72*0.03;
  Real absorbed_NIR = 0.794*218*0.55*0.03 + (0.75*79 + Isf*Params.outside_albedo_NIR*0.25)*0.55*0.72*0.03;


  Real Isf = 79 + 218*0.1908;
  //Real diffuse_incident_PAR = (0.75*79 + Isf*Params.outside_albedo_PAR*0.25)*0.45;
  //Real diffuse_power_transmitted_PAR = Params.panel_areas[1]*diffuse_incident_PAR*0.72; // + Dni_Transmitted_PAR;


equation
  assert( abs( absorbed_NIR - panel.absorbed_NIR) < 0.01,  "fresnel transmission");
  assert( abs( absorbed_PAR - panel.absorbed_PAR) < 0.01,  "fresnel transmission");
  assert( abs( transmitted_NIR - panel.transmitted_NIR) < 0.01,  "fresnel transmission");
  assert( abs( transmitted_PAR - panel.transmitted_PAR) < 0.01,  "fresnel transmission");
  connect(fixedWaterVapourFlow.waterMassPort_a, panel.waterMassPort_a)
    annotation (Line(points={{-29.8,-33.8},{-29.8,-14.9},{-38,-14.9},
          {-38,2.6}}, color={0,0,255}));
  connect(fixedHeatFlow.port, panel.port_b) annotation (Line(
        points={{-68,-18},{-50,-18},{-50,2.6},{-41.4,2.6}}, color={
          191,0,0}));
  connect(fixedHeatFlow1.port, panel.port_a) annotation (Line(
        points={{-68,44},{-50,44},{-50,7.2},{-41.4,7.2}}, color={191,
          0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end panelTest2;
