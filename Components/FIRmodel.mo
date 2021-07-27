within solarGreenhouseV2.Components;
model FIRmodel
  "thermal radiation transfer between greenhouse components, put in a sperate model so that the main greenhouse model is less cluttered. 
  
  input blanket_fraction"

  Modelica.Units.SI.HeatFlowRate Radiation_thermal_canopy "net flow of thermal radiation to/from canopy. ";

  input Real blanket_fraction "cover glazing. If this is on, then no radiation from inside to outside" annotation(Dialog);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_soil
    annotation (Placement(transformation(extent={{34,-86},{54,-66}}),
        iconTransformation(extent={{34,-86},{54,-66}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    annotation (Placement(transformation(extent={{32,-48},{52,-28}}),
        iconTransformation(extent={{32,-48},{52,-28}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_panel2
    annotation (Placement(transformation(extent={{32,16},{52,36}}),
        iconTransformation(extent={{32,16},{52,36}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_panel1
    annotation (Placement(transformation(extent={{32,40},{52,60}}),
        iconTransformation(extent={{32,40},{52,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_canopy
    annotation (Placement(transformation(extent={{60,-14},{80,6}}),
        iconTransformation(extent={{60,-14},{80,6}})));
  parameter greenhouseParameters P annotation (Placement(transformation(
          extent={{-124,46},{-104,66}})));
  parameter physicalConstants C annotation (Placement(transformation(extent={
            {-124,68},{-104,88}})));
  Flows.greyBlackRadiation FIR_canopy_soil(epsilon_a=P.soil_emissivity,
      A_a=P.floor_area) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-54})));
  Flows.greyBlackRadiation FIR_wall_canopy(epsilon_a=P.wall_emissivity,
      A_a=P.wall_area) annotation (Placement(transformation(extent=
           {{68,-44},{88,-24}})));
  Flows.greyBlackRadiation FIR_panel2_canopy(epsilon_a=P.glazing_emissivity,
      A_a=P.panel_areas[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={78,24})));
  Flows.greyBlackRadiation FIR_panel1_canopy(epsilon_a=P.glazing_emissivity,
      A_a=P.panel_areas[1]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-4,24})));
equation
  port_canopy.Q_flow = Radiation_thermal_canopy;
  connect(FIR_wall_canopy.port_a, port_wall) annotation (Line(
        points={{68,-34},{56,-34},{56,-38},{42,-38}}, color={191,0,
          0}));
  connect(FIR_wall_canopy.port_b, port_canopy) annotation (Line(
        points={{88,-34},{92,-34},{92,-20},{70,-20},{70,-4}},
        color={191,0,0}));
  connect(FIR_panel2_canopy.port_a, port_panel2) annotation (Line(
        points={{78,34},{78,38},{56,38},{56,26},{42,26}}, color={
          191,0,0}));
  connect(FIR_panel2_canopy.port_b, port_canopy) annotation (Line(
        points={{78,14},{92,14},{92,-20},{70,-20},{70,-4}}, color=
          {191,0,0}));
  connect(FIR_panel1_canopy.port_a, port_panel1) annotation (Line(
        points={{-4,34},{-2,34},{-2,50},{42,50}}, color={191,0,0}));
  connect(FIR_panel1_canopy.port_b, port_canopy) annotation (Line(
        points={{-4,14},{-4,-4},{70,-4}}, color={191,0,0}));
  connect(FIR_canopy_soil.port_a, port_soil) annotation (Line(
        points={{10,-54},{44,-54},{44,-76}}, color={191,0,0}));
  connect(FIR_canopy_soil.port_b, port_canopy) annotation (Line(
        points={{-10,-54},{-14,-54},{-14,-2},{56,-2},{56,-4},{70,
          -4}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Ellipse(lineColor = {238, 46, 47}, fillColor = {238, 46, 47},
            fillPattern =                                                                     FillPattern.Sphere, extent = {{-76, 88}, {22, -90}}, endAngle = 360), Text(lineColor = {28, 108, 200}, extent = {{-76, 30}, {20, -34}}, textString = "FIR")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end FIRmodel;
