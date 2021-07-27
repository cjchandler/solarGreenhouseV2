within solarGreenhouseV2.Components;
model MassiveWall "thick wall of high thermal mass
  
  input PAR_absorbed , NIR_absorbed"

  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter solarGreenhouseV2.physicalConstants C;

  input Modelica.Units.SI.HeatFlowRate PAR_absorbed "PAR absorbed by soil is calcualted in lightAbsorbtion model"  annotation (Dialog);
  input Modelica.Units.SI.HeatFlowRate NIR_absorbed "NIR absorbed by soil is calcualted in lightAbsorbtion model" annotation (Dialog);

  Modelica.Units.SI.Temperature surface_temp;
      //intermediate parameters
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "connect to air inside greenhouse via convection"        annotation (
          Placement(transformation(extent={{-136,26},{-116,46}}),
                                                                iconTransformation(
              extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-64,50})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    "connect to outside air temp"                            annotation (
          Placement(transformation(extent={{80,-12},{100,8}}),
            iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-6,-26})));

protected
      parameter Modelica.Units.SI.Mass weight = P.wall_area*P.wall_thickness*P.wall_density "soil weight in kg";
      parameter Modelica.Units.SI.HeatCapacity C_full = P.wall_specific_heat*weight "soil heat capacity cp*m";
      parameter Modelica.Units.SI.ThermalResistance R_wall = P.wall_thickness/(P.wall_thermal_conductivity*P.wall_area) "thermal resistance of soil";
      parameter Modelica.Units.SI.ThermalResistance R_layer =  R_wall/n_layers "thermal resistance of soil layer";
      parameter Modelica.Units.SI.HeatCapacity C_layer = C_full/n_layers;

      parameter Integer n_layers = 5;

      //soilHeatCapacity.C = C*A*h*rho;
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor1(C=C_layer)
                   annotation (Placement(transformation(extent={{-104,62},
            {-84,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor2(C=C_layer)
                   annotation (Placement(transformation(extent={{-76,62},
            {-56,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor3(C=C_layer)
                   annotation (Placement(transformation(extent={{-48,62},
            {-28,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor4(C=C_layer)
                   annotation (Placement(transformation(extent={{-16,62},
            {4,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor5(C=C_layer)
                   annotation (Placement(transformation(extent={{32,62},
            {52,82}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor(R=R_layer)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-96,36})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor1(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-66,36})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor2(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-36,36})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor3(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,36})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor4(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={28,36})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlowNIR annotation (Placement(transformation(extent={{-154,78},
            {-134,98}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlowPAR annotation (Placement(transformation(
          extent={{-154,56},{-134,76}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor5(R= P.Rsi_wall_insulation/P.wall_area)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={62,36})));
equation
  surface_temp = port_a.T;
  prescribedHeatFlowPAR.Q_flow = PAR_absorbed;
  prescribedHeatFlowNIR.Q_flow = NIR_absorbed;

  connect(port_b, port_b) annotation (Line(points={{90,-2},{90,-2}},
        color={191,0,0}));
  connect(prescribedHeatFlowNIR.port, port_a) annotation (Line(points={{-134,88},
          {-120,88},{-120,36},{-126,36}},
        color={191,0,0}));
  connect(prescribedHeatFlowPAR.port, port_a) annotation (Line(
        points={{-134,66},{-120,66},{-120,36},{-126,36}},
        color={191,0,0}));
  connect(port_a, port_a) annotation (Line(points={{-126,36},{-126,
          36}}, color={191,0,0}));
  connect(thermalResistor.port_b, port_a) annotation (Line(points={
          {-106,36},{-126,36}}, color={191,0,0}));
  connect(thermalResistor.port_a, thermalResistor1.port_b)
    annotation (Line(points={{-86,36},{-76,36}}, color={191,0,0}));
  connect(thermalResistor1.port_a, thermalResistor2.port_b)
    annotation (Line(points={{-56,36},{-46,36}}, color={191,0,0}));
  connect(thermalResistor2.port_a, thermalResistor3.port_b)
    annotation (Line(points={{-26,36},{-12,36}}, color={191,0,0}));
  connect(thermalResistor3.port_a, thermalResistor4.port_b)
    annotation (Line(points={{8,36},{18,36}}, color={191,0,0}));
  connect(thermalResistor4.port_a, thermalResistor5.port_b)
    annotation (Line(points={{38,36},{52,36}}, color={191,0,0}));
  connect(port_b, thermalResistor5.port_a) annotation (Line(points=
         {{90,-2},{90,36},{72,36}}, color={191,0,0}));
  connect(heatCapacitor1.port, thermalResistor.port_a) annotation (
     Line(points={{-94,62},{-94,50},{-82,50},{-82,36},{-86,36}},
        color={191,0,0}));
  connect(heatCapacitor2.port, thermalResistor1.port_a)
    annotation (Line(points={{-66,62},{-66,50},{-52,50},{-52,36},{-56,
          36}}, color={191,0,0}));
  connect(heatCapacitor3.port, thermalResistor2.port_a)
    annotation (Line(points={{-38,62},{-38,50},{-18,50},{-18,36},{-26,
          36}}, color={191,0,0}));
  connect(heatCapacitor4.port, thermalResistor3.port_a)
    annotation (Line(points={{-6,62},{-6,50},{12,50},{12,36},{8,36}},
        color={191,0,0}));
  connect(heatCapacitor5.port, thermalResistor4.port_a)
    annotation (Line(points={{42,62},{42,36},{38,36}}, color={191,0,
          0}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
              extent={{-84,40},{90,-16}},
              lineColor={28,108,200},
              fillColor={147,81,6},
              fillPattern=FillPattern.Solid), Text(
              extent={{-68,26},{72,-36}},
              textColor={28,108,200},
          textString="Wall
")}),     Diagram(coordinateSystem(preserveAspectRatio=false)));
end MassiveWall;
