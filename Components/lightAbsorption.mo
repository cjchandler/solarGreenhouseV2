within solarGreenhouseV2.Components;
model lightAbsorption
  "calculate the ammount of light from each panel that is absorbed by canopy and soil, ideally this uses some precomputed ray tracing
  
  inputs panels_PAR_transmitted[:] , panels_NIR_transmitted[:], there is also a constant n_panels=2 that cannot be adjusted except in lightAbsorption source code
  "
  constant Integer n_panels= 2;

  parameter solarGreenhouseV2.greenhouseParameters P;

  input Modelica.Units.SI.HeatFlowRate[n_panels] panels_PAR_transmitted  annotation (Dialog);
  input Modelica.Units.SI.HeatFlowRate[n_panels] panels_NIR_transmitted  annotation (Dialog);

  //need to calculate all of these:
  Modelica.Units.SI.HeatFlowRate NIR_absorbed_canopy;
  Modelica.Units.SI.HeatFlowRate PAR_absorbed_canopy;

  Modelica.Units.SI.HeatFlowRate NIR_absorbed_soil;
  Modelica.Units.SI.HeatFlowRate PAR_absorbed_soil;

  Modelica.Units.SI.HeatFlowRate NIR_absorbed_wall;
  Modelica.Units.SI.HeatFlowRate PAR_absorbed_wall;

   Modelica.Units.SI.HeatFlowRate totalSolarHeatAbsorbed "heat input from light absorbtion of canopy, soil, wall";

equation
  panels_PAR_transmitted*P.panel_canopy_absorptions = PAR_absorbed_canopy;
  panels_NIR_transmitted*P.panel_canopy_absorptions = NIR_absorbed_canopy;

  panels_PAR_transmitted*P.panel_soil_absorptions = PAR_absorbed_soil;
  panels_NIR_transmitted*P.panel_soil_absorptions = NIR_absorbed_soil;

  panels_PAR_transmitted*P.panel_wall_absorptions = PAR_absorbed_wall;
  panels_NIR_transmitted*P.panel_wall_absorptions = NIR_absorbed_wall;

  totalSolarHeatAbsorbed = PAR_absorbed_canopy + NIR_absorbed_canopy + PAR_absorbed_soil + NIR_absorbed_soil + PAR_absorbed_wall + NIR_absorbed_wall;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={
        Ellipse(
          extent={{-72,58},{4,-14}},
          lineColor={255,255,0},
          startAngle=0,
          endAngle=360,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,-28},{84,-58}},
          lineColor={255,255,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-190,-46},{184,-102}},
          textColor={28,108,200},
          textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end lightAbsorption;
