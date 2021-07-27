within solarGreenhouseV2.UnitTests;
model panelTest1
  "testing panel light and heat transmission. Testing direct sun from straight up on a flat panel"
  Components.panel panel(
    Dhi = 0,
    Dni = 100,
    sun_azimuth = Modelica.Units.Conversions.from_deg(180),
    sun_zenith = Modelica.Units.Conversions.from_deg(0),
    blanket_fraction = 0.0001)
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
  greenhouseParametersForTesting Params(
    n_panels = 1,
    n_index = 1.53,
    panel_areas={2},
    panel_azimuths={3.1415926535898},
    panel_zeniths={0},
    panel_sky_fractions={1},
    panel_single_glazed_diffuse_transmissions={0.83},
    panel_double_glazed_diffuse_transmissions={0.72},
    panel_structural_fractions={0.03},
    panel_double_glazed_fractions={0.9999},
    panel_canopy_absorptions={0.8}) annotation (Placement(
        transformation(extent={{-130,4},{-110,24}})));
  physicalConstants Consts annotation (Placement(transformation(
          extent={{-132,32},{-112,52}})));

  Real power_incident = 100*2 "100 watts per m2 panel";
  Real power_transmitted_1_interface = 4*Params.n_index/((1 + Params.n_index)^2);
  Real power_reflected_1_interface = 1-power_transmitted_1_interface;
  Real power_transmitted_2_interfaces = (power_transmitted_1_interface^2)/( 1 - power_reflected_1_interface^2);
  Real power_reflected_2_interfaces = 1-power_transmitted_2_interfaces;

  Real power_transmitted_4_interfaces = (power_transmitted_2_interfaces^2)/( 1 - power_reflected_2_interfaces^2);

  Real power_transmitted = 0.55*power_incident*((1- Params.panel_structural_fractions[1])*power_transmitted_4_interfaces*Params.panel_double_glazed_fractions[1] + (1- Params.panel_structural_fractions[1])*power_transmitted_2_interfaces*(1-Params.panel_double_glazed_fractions[1]));

equation
  assert( abs( power_transmitted - panel.transmitted_NIR) < 0.1,  "fresnel transmission");
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
end panelTest1;
