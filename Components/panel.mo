within solarGreenhouseV2.Components;
model panel
  "port_a (filled) to outside, port_b (unfilled) to inside.
  
  inputs: sun_azimuth sun_zenith Dni Dhi blanket_fraction
  
  A flat transparent surface with angles and area glazed panel that can transmit light, condense water, option for insulation controlled by input"
      //parameters
  //label    class name          class instance name
  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter solarGreenhouseV2.physicalConstants C;

  parameter Integer i=1 "this tells you which parameters in P to use fo rpanel vectors. 
  Everything you need to build the greenhouse is in P";

  input Modelica.Units.SI.Angle sun_azimuth  annotation (Dialog);
  input Modelica.Units.SI.Angle sun_zenith  annotation (Dialog);
  input Modelica.Units.SI.HeatFlux Dni  annotation (Dialog);
  input Modelica.Units.SI.HeatFlux Dhi  annotation (Dialog);

  Modelica.Units.SI.HeatFlowRate transmitted_PAR "power of PAR that gets through panel and is incident greenhouse inside";
  Modelica.Units.SI.HeatFlowRate transmitted_NIR "power of NIR that gets through panel and is incident greenhouse inside";

  Modelica.Units.SI.HeatFlowRate absorbed_PAR "power Absorbed by structural elements";
  Modelica.Units.SI.HeatFlowRate absorbed_NIR "power Absorbed by structural elements";

  Modelica.Units.SI.Temperature outer_surface_temp;
  Modelica.Units.SI.Temperature inner_surface_temp;

  Modelica.Units.SI.HeatFlowRate Q_flow;

  input Real blanket_fraction "0-1 how much of the panel is currently covered by insulation blanket"  annotation (Dialog);
  parameter Real double_glazed_fraction = P.panel_double_glazed_fractions[i] "0-1 how much of the panel is currently cuvvered by double glazing";

  Modelica.Units.SI.PartialPressure vP_sat "saturated vapour pressure at inner surface temperature";
//= solarGreenhouseV2.Functions.saturatedVapourPressure(solidTemp);
  //temp variables
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-84,2},{-64,22}}),
        iconTransformation(extent={{-84,2},{-64,22}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{-84,-44},{-64,
            -24}}), iconTransformation(extent={{-84,-44},{-64,-24}})));
  solarGreenhouseV2.Interfaces.WaterMassPort_a waterMassPort_a annotation (Placement(
        visible = true,transformation(extent = {{-18, -80}, {2, -60}}, rotation = 0),
        iconTransformation(extent = {{-50, -44}, {-30, -24}}, rotation = 0)));

  parameter Modelica.Units.SI.ThermalResistance R_single_glazing = P.single_glazed_Rsi/P.panel_areas[i] "glazing thermal resistance";

  parameter Modelica.Units.SI.ThermalResistance R_double_glazing = P.double_glazed_Rsi/P.panel_areas[i] "glazing thermal resistance";

  parameter Modelica.Units.SI.ThermalResistance R_blanket = P.blanket_Rsi/P.panel_areas[i] "blanket thermal resistance";
protected
  Modelica.Units.SI.ThermalResistance R_glazing "total effective glazing thermal R taking into account various areas of single or double glazing";
  Modelica.Units.SI.ThermalResistance R_tot "total effective panel thermal R with blanketfraction and glazing";

//light
  Modelica.Units.SI.HeatFlux ground_flux_incident;
  Modelica.Units.SI.HeatFlux diffuse_flux_incident_PAR;
  Modelica.Units.SI.HeatFlux diffuse_flux_incident_NIR;
  Real diffuse_transmission "0-1 how much diffuse light gets though glazing, not including structural element absoption";
  Modelica.Units.SI.HeatFlowRate diffuse_power_transmitted_PAR "power through panel, not including structural element absoption ";
  Modelica.Units.SI.HeatFlowRate diffuse_power_transmitted_NIR "power through panel, not including structural element absoption ";
  Real direct_transmission "0-1 how much diffuse light gets though glazing, not including structural element absoption";
  Modelica.Units.SI.HeatFlowRate direct_power_transmitted_PAR "power through panel, not including structural element absoption ";
  Modelica.Units.SI.HeatFlowRate direct_power_transmitted_NIR "power through panel, not including structural element absoption ";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor( C = P.panel_areas[i]*P.glazing_heat_capacitance_per_m2)    "heat capacity of the glazing"
    annotation (Placement(transformation(extent={{18,14},{38,34}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlowOutside
    annotation (Placement(transformation(extent={{-112,74},{-92,94}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlowInside
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));
  Modelica.Units.SI.HeatFlowRate latentHeatAbsorbed;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedLatentHeatFlow
    annotation (Placement(transformation(extent={{-60,-98},{-40,-78}})));

  variableThermalResistor variableThermalResistor1( R = 0.5*R_tot) annotation (
      Placement(transformation(extent={{-28,46},{-8,66}})));
  variableThermalResistor variableThermalResistor2( R = 0.5*R_tot) annotation (
      Placement(transformation(extent={{-26,-22},{-6,-2}})));

equation
  Q_flow = variableThermalResistor1.Q_flow;
  1/R_glazing = double_glazed_fraction/R_double_glazing + (1-double_glazed_fraction)/R_single_glazing;
  1/R_tot = blanket_fraction/(R_blanket) + (1-blanket_fraction)/R_glazing;

  port_a.T = outer_surface_temp;
  port_b.T = inner_surface_temp;

  waterMassPort_a.VP =
    solarGreenhouseV2.Functions.saturatedVapourPressure(port_b.T);
  waterMassPort_a.VP = vP_sat;
  latentHeatAbsorbed = waterMassPort_a.MV_flow*C.lambda;
  prescribedLatentHeatFlow.Q_flow = latentHeatAbsorbed;
//determine panel light transmission
  ground_flux_incident = solarGreenhouseV2.Functions.panelIllumination(Dni, Dhi, 1.0, 0, 0, sun_azimuth, sun_zenith);
  diffuse_flux_incident_PAR = (P.panel_sky_fractions[i]*Dhi*C.PAR_fraction_insolation + (1-P.panel_sky_fractions[i])*ground_flux_incident*C.PAR_fraction_insolation*P.outside_albedo_PAR);
  diffuse_flux_incident_NIR =(P.panel_sky_fractions[i]*Dhi*C.NIR_fraction_insolation + (1-P.panel_sky_fractions[i])*ground_flux_incident*C.NIR_fraction_insolation*P.outside_albedo_NIR);

  diffuse_transmission = P.panel_double_glazed_fractions[i]*P.panel_double_glazed_diffuse_transmissions[i]
       + ( 1- P.panel_double_glazed_fractions[i])*P.panel_single_glazed_diffuse_transmissions[i];

  diffuse_power_transmitted_PAR = P.panel_areas[i]*diffuse_flux_incident_PAR*diffuse_transmission;
  diffuse_power_transmitted_NIR = P.panel_areas[i]*diffuse_flux_incident_NIR*diffuse_transmission;

  direct_transmission =
    + solarGreenhouseV2.Functions.Direct_4interface(P.n_index, P.panel_azimuths[i],  P.panel_zeniths[i], sun_azimuth, sun_zenith)*double_glazed_fraction
    +solarGreenhouseV2.Functions.Direct_2interface( P.n_index, P.panel_azimuths[i],  P.panel_zeniths[i], sun_azimuth, sun_zenith)*( 1 - double_glazed_fraction);

  direct_power_transmitted_PAR = P.panel_areas[i]*Dni*C.PAR_fraction_insolation*direct_transmission;
  direct_power_transmitted_NIR = P.panel_areas[i]*Dni*C.NIR_fraction_insolation*direct_transmission;

  transmitted_PAR = (1-blanket_fraction)*(direct_power_transmitted_PAR + diffuse_power_transmitted_PAR)*(1 - P.panel_structural_fractions[i]);
  absorbed_PAR = (1-blanket_fraction)*(direct_power_transmitted_PAR + diffuse_power_transmitted_PAR)*P.panel_structural_fractions[i];

  transmitted_NIR = (1-blanket_fraction)*(direct_power_transmitted_NIR + diffuse_power_transmitted_NIR)*(1 - P.panel_structural_fractions[i]);
  absorbed_NIR = (1-blanket_fraction)*(direct_power_transmitted_NIR + diffuse_power_transmitted_NIR)*P.panel_structural_fractions[i];
//determine panel light absorbtion
  prescribedHeatFlowOutside.Q_flow = 0;
  prescribedHeatFlowInside.Q_flow = absorbed_NIR + absorbed_PAR;

  connect(variableThermalResistor1.port_b, heatCapacitor.port)
    annotation (Line(points={{-8,56},{12,56},{12,6},{28,6},{28,14}},
        color={191,0,0}));
  connect(variableThermalResistor2.port_b, heatCapacitor.port)
    annotation (Line(points={{-6,-12},{32,-12},{32,8},{28,8},{28,14}},
        color={191,0,0}));
  connect(prescribedLatentHeatFlow.port, variableThermalResistor2.port_a)
    annotation (Line(points={{-40,-88},{-40,-12},{-26,-12}}, color={
          191,0,0}));
  connect(port_a, variableThermalResistor1.port_a) annotation (
      Line(points={{-74,12},{-50,12},{-50,56},{-28,56}}, color={
          191,0,0}));
  connect(port_a, prescribedHeatFlowOutside.port) annotation (Line(
        points={{-74,12},{-74,84},{-92,84}}, color={191,0,0}));
  connect(prescribedHeatFlowInside.port, port_b) annotation (Line(
        points={{-70,-12},{-72,-12},{-72,-34},{-74,-34}}, color={
          191,0,0}));
  connect(variableThermalResistor2.port_a, port_b) annotation (
      Line(points={{-26,-12},{-50,-12},{-50,-34},{-74,-34}}, color=
         {191,0,0}));
  annotation (Icon(graphics={Rectangle(lineColor = {28, 108, 200}, fillColor = {85, 170, 255},
            fillPattern =                                                                                    FillPattern.Solid, extent = {{-92, 2}, {94, -24}}), Text(lineColor = {28, 108, 200}, extent = {{-70, -46}, {78, -88}}, textString = "%name")}));
end panel;
