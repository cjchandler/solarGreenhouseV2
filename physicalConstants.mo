within solarGreenhouseV2;
class physicalConstants
  "assumptions about specific heat, dynamics viscosity etc, any physical parameter"

      parameter Modelica.Units.SI.ThermalConductivity air_thermal_conductivity = 0.02685 "air thermal conductivity";
      parameter Modelica.Units.SI.KinematicViscosity air_kinematic_viscosity = 14e-6 "dry air at 18c, not super sensitive to temperature change";
      parameter Modelica.Units.SI.DynamicViscosity air_dynamic_viscosity = 18e-6 "dry air at 18c, not super sensitive to temperature change";
      parameter Modelica.Units.SI.SpecificHeatCapacity air_specific_heat_capacity = 1000 "j/kg";
      parameter Real air_thermal_expansion_coef = 0.0034 "dry air thermal expansion coefficent, beta";
      parameter Real air_thermal_diffusivity = 20e-6 "air thermal diffusivity for 15c ";
      parameter Real air_emissivity = 0.74 "air thermal radiation emissivity ";
      parameter Modelica.Units.SI.Pressure atm = 1e5 "1 bar, about 1 atm";
      parameter Modelica.Units.SI.SpecificHeatCapacity water_specific_heat_capacity= 4184 "water j/(kg K)";
      parameter Modelica.Units.SI.SpecificHeatCapacity water_vapour_specific_heat_capacity= 1996 "water j/(kg K)";
      parameter Real A =  2.16679e-3 "ideal gas constant for AH in kg/m3 vaisala 2013";

      parameter Real lambda = 2540e6 "latent heat of vaporization at 20c , Jolliet 1992";
      parameter Real psychrometric_constant = 66 "psychrometric Constant, Jolliet1992";

      parameter Modelica.Units.SI.Density air_density = 1.225 "air density kg/m3";
    parameter Real air_prandtl = 0.71 "air prandtl number for near 20c";
    parameter Real PAR_fraction_insolation = 0.45 "this partitions the insolation into just PAR and NIR";
    parameter Real NIR_fraction_insolation = 0.55 "this partitions the insolation into just PAR and NIR";
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
              extent={{-88,90},{84,-86}},
              lineColor={238,46,47},
              fillColor={217,67,180},
              fillPattern=FillPattern.Solid), Text(
              extent={{-80,50},{74,-54}},
              textColor={0,0,0},
          textString="%name")}),                                     Diagram(
            coordinateSystem(preserveAspectRatio=false)));

end physicalConstants;
