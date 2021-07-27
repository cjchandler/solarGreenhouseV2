within solarGreenhouseV2;
class greenhouseParametersForTesting
  "A central location for all the building parameters, referenced by other components used in unit tests"

      //enviroment
      parameter Modelica.Units.SI.Temperature deep_soil_temperature = Modelica.Units.Conversions.from_degC(6)  "soil temperature deep below greenhouse. year round constant";
      parameter Real outside_albedo_PAR = 0.8 "this is PAR albedo of the field around the greenhouse";
      parameter Real outside_albedo_NIR = 0.01 "this is NIR albedo of the field around the greenhouse";

      //structure
      //floor
      parameter Modelica.Units.SI.Area floor_area = 2 "floor area of greenhouse inside";
      parameter Modelica.Units.SI.Length soil_depth = 1 "soil depth";
      parameter Modelica.Units.SI.Emissivity soil_emissivity = 0.8 "soil surface emisivity for FIR (long wavelength radiation)";
      parameter Modelica.Units.SI.Density soil_density= 1600 "soil density kg/m3";
      parameter Modelica.Units.SI.SpecificHeatCapacity soil_specific_heat = 1000 "soil specific heat";
      parameter Modelica.Units.SI.ThermalConductivity soil_thermal_conductivity = 0.7 "soil thermal conductivity W/m K";
      parameter Real soil_albedo_PAR = 0.9;
      parameter Real soil_albedo_NIR = 0.01;
      parameter Real Rsi_subsoil_insulation = 20/5.67 "insulation between the top soil and undisturbed subsoil";

      //wall
      parameter Modelica.Units.SI.Area wall_area = 2 "area of walls that are not glazing";
      parameter Modelica.Units.SI.Length wall_thickness = 2 "wall thickness of thermal mass";
      parameter Modelica.Units.SI.Density wall_density= 1600 "wall density kg/m3";
      parameter Modelica.Units.SI.SpecificHeatCapacity wall_specific_heat = 1000 "wall specific heat";
      parameter Modelica.Units.SI.ThermalConductivity wall_thermal_conductivity = 0.7 "wall thermal conductivity W/m K";
      parameter Real Rsi_wall_insulation = 20/5.67 "insulation on the outside of massive wall";
      parameter Real wall_emissivity = 1 "wall thermal emmisivity";


    //glazing, Panel initialization
      parameter Real n_index = 1.53 "index of refraction for glazing";
      parameter Integer n_panels = 2 "number of flat panels";
      parameter Modelica.Units.SI.Area panel_areas[:] = { 2,  2} "panel areas";
      parameter Modelica.Units.SI.Angle panel_azimuths[:] = {  Modelica.Units.Conversions.from_deg(180),   Modelica.Units.Conversions.from_deg(180)}
      "list of panel azimuths in radians, as measured from panel normal vector, 
      Negative to the East. Positive to the West. 0 at due North.";
      parameter  Modelica.Units.SI.Angle panel_zeniths[ :] = {   0, Modelica.Units.Conversions.from_deg(90)}
       "list of panel zeniths in radians, as measured from panel normal vector,
        The angle between a line perpendicular to the earth's surface and the panel normal.
         (0 deg = vertical wall ; 90 deg = flat horizontal panel)";
     parameter Real panel_sky_fractions[:] = { 1,  0.5}   "how much of the sky is visible from panel, 0-1";
     parameter Real panel_single_glazed_diffuse_transmissions[:] = {0.83,0.83}
          "panel diffuse transmission, 0-1";
     parameter Real panel_double_glazed_diffuse_transmissions[:] = { 0.72,0.72};
     parameter Real panel_structural_fractions[:] = {0.03,  0.03} "faction of panel that is opaque for strucutral elements. Light absorbed here is considered to be heating the inside of the panel";
     parameter Real panel_double_glazed_fractions[:] = { 0.9999, 0.9999}  "0:1 how much of each panel is double glazed, avoid 0 and 1 so no divide by zero problems. This could be done dynamically also, ignoring this part";
     parameter Real panel_canopy_absorptions[:] = { 0.8,  0.8}  "fraction of light absorbed by canopy from each panel. This is just a guess, really this should be determined dynamically in the canopy component from LAI, panel geometry, weather via ray tracing";
     parameter Real panel_soil_absorptions[:] = { 0.1,  0.1}  "fraction of light absorbed by soil from each panel. This is just a guess, really this should be determined dynamically in the canopy component from LAI, panel geometry, weather via ray tracing";
     parameter Real panel_wall_absorptions[:] = { 0.05,  0.05}  "fraction of light absorbed by inside wall from each panel. This is just a guess, really this should be determined dynamically in the canopy component from LAI, panel geometry, weather via ray tracing";

     parameter Real single_glazed_Rsi = 0.0001 "r value in SI for single glazing. very very low since air curtain effect is delt with in convection model";
     parameter Real double_glazed_Rsi = 0.352 "this is about r-2 imperial for poly film because radaiton transfer is treated elsewhere";
     parameter Real blanket_Rsi = 20/5.67 "r-20 imperial seems max reasonable";
     parameter Real glazing_heat_capacitance_per_m2 = 1 "specific heat of the poly, very low";
     parameter Modelica.Units.SI.Emissivity glazing_emissivity = 0.4 "glazing emisivity for FIR (long wavelength radiation)";
     parameter Real glazing_FIR_transmission = 0.6 "This is thermal radiation transmission,
      0 for glass, can be high for some plastic. In general some FIR is reflected back
      (emissivity), some is absorbed, and some is transmitted. This value can be used to 
      see home much radiation leaves directly to sky";

     //volume and venting
     parameter Modelica.Units.SI.Length ceiling_height = 2;
     parameter Modelica.Units.SI.Volume air_volume = 2 "volume of greenhouse in m3";
     parameter Real inflitration_ACH = 0.03 "air changed per hour from air leaks";
     parameter Real max_ACH = 200 "max air changed per hour with vents and fans all on";
     parameter Modelica.Units.SI.Temperature max_temp = Modelica.Units.Conversions.from_degC(30) "set point for opening vents";
     parameter Modelica.Units.SI.Temperature min_temp = Modelica.Units.Conversions.from_degC(15) "set point for heating";
     parameter Modelica.Units.SI.Velocity wind_speed_indoors = 0.1 "used in canopy convection heat transfer, stanghellini1987";
     parameter Modelica.Units.SI.HeatFlowRate heater_max_power = 2000 "max watts for heater";

     //plants
     parameter Modelica.Units.SI.Emissivity canopy_emissivity = 0.95 "FIR emissivity of canopy";
     //parameter Real canopy_transparency = 0.2 "fraction of light that makes it though canopy. This is a guess, really it depends on weather, panel, LAI perhaps more";
     parameter Modelica.Units.SI.Length leaf_length = 0.05 "leaf size for convection, stanghellini1987";

//equation
      // assert( glazing_FIR_transmission + glazing_emissivity <= 1,  "check that FIR transmission and reflection are self consistent");
    
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
              extent={{-78,80},{78,-72}},
              lineColor={238,46,47},
              fillColor={217,67,180},
              fillPattern=FillPattern.Solid), Text(
              extent={{-68,60},{68,-56}},
              textColor={0,0,0},
          textString="%name")}),     Diagram(coordinateSystem(preserveAspectRatio=false)));
end greenhouseParametersForTesting;
