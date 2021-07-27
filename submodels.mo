within solarGreenhouseV2;
package submodels "connection groups of flows for easy testing and visualization"

  model ThermalRadiation
    "all thermal radiation between the main components of soil,canopy,panels,air,outside"
    Real G = 1 "Gr radiation factor, varying input"
      annotation (Dialog(group="Varying inputs"));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_air
      "heat flow to/from air"
      annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_soil
      annotation (Placement(transformation(extent={{70,-10},{90,10}})));
    Flows.greyBodyRadiation greyBodyRadiation(
      epsilon_a=1,
      epsilon_b=1,
      A_a=1,
      A_b=1,
      AF=G) annotation (Placement(transformation(extent={{-4,-6},{16,14}})));
  equation
    connect(port_air, greyBodyRadiation.port_a) annotation (Line(points={{-90,0},
            {-10,0},{-10,4},{-4,4}}, color={191,0,0}));
    connect(greyBodyRadiation.port_b, port_soil)
      annotation (Line(points={{16,4},{64,4},{64,0},{80,0}}, color={191,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ThermalRadiation;

end submodels;
