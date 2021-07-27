within solarGreenhouseV2.Components;
model Soil "block of topsoil, adjustable depth, subsoil insulation. 
  
  inputs: PAR_absorbed, NIR_absorbed "
      //parameters
      //label    class name          class instance name
  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter solarGreenhouseV2.physicalConstants C;

  input Modelica.Units.SI.HeatFlowRate PAR_absorbed "PAR absorbed by soil is calcualted in lightAbsorbtion model"  annotation (Dialog);
  input Modelica.Units.SI.HeatFlowRate NIR_absorbed "NIR absorbed by soil is calcualted in lightAbsorbtion model"  annotation (Dialog);

  Modelica.Units.SI.Temperature surface_temp;
      //intermediate parameters
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (
          Placement(transformation(extent={{-74,78},{-54,98}}), iconTransformation(
              extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-64,50})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation (
          Placement(transformation(extent={{-72,-118},{-52,-98}}),
            iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-62,-88})));



  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor1(C=C_layer)
                   annotation (Placement(transformation(extent={{-46,
            60},{-26,80}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor2(C=C_layer)
                   annotation (Placement(transformation(extent={{-46,
            28},{-26,48}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor3(C=C_layer)
                   annotation (Placement(transformation(extent={{-46,
            -4},{-26,16}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor4(C=C_layer)
                   annotation (Placement(transformation(extent={{-46,
            -36},{-26,-16}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
    heatCapacitor5(C=C_layer)
                   annotation (Placement(transformation(extent={{-46,
            -68},{-26,-48}})));


protected
      parameter Modelica.Units.SI.Mass weight = P.floor_area*P.soil_depth*P.soil_density "soil weight in kg";
      parameter Modelica.Units.SI.HeatCapacity C_full = P.soil_specific_heat*weight "soil heat capacity cp*m";
      parameter Modelica.Units.SI.ThermalResistance R_soil = P.soil_depth/(P.soil_thermal_conductivity*P.floor_area) "thermal resistance of soil";
      parameter Modelica.Units.SI.ThermalResistance R_layer =  R_soil/n_layers "thermal resistance of soil layer";
      parameter Modelica.Units.SI.HeatCapacity C_layer = C_full/n_layers;

      parameter Integer n_layers = 5;

      //soilHeatCapacity.C = C*A*h*rho;


 Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor(R=R_layer)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,68})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor1(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,36})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor2(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,8})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor3(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-24})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor4(R=R_layer)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-54})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlowNIR annotation (Placement(transformation(extent=
           {{-6,28},{14,48}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlowPAR annotation (Placement(transformation(
          extent={{-6,10},{14,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor
    thermalResistor5(R=P.Rsi_subsoil_insulation/P.floor_area)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-82})));
equation
  surface_temp = port_a.T;
  prescribedHeatFlowPAR.Q_flow = PAR_absorbed;
  prescribedHeatFlowNIR.Q_flow = NIR_absorbed;

  connect(port_b, port_b) annotation (Line(points={{-62,-108},{-62,
          -108}},
        color={191,0,0}));
  connect(port_a, thermalResistor.port_b) annotation (Line(points={
          {-64,88},{-64,78}}, color={191,0,0}));
  connect(thermalResistor.port_a, heatCapacitor1.port) annotation (
     Line(points={{-64,58},{-64,52},{-36,52},{-36,60}}, color={191,
          0,0}));
  connect(thermalResistor.port_a, thermalResistor1.port_b)
    annotation (Line(points={{-64,58},{-64,46}}, color={191,0,0}));
  connect(thermalResistor1.port_a, thermalResistor2.port_b)
    annotation (Line(points={{-64,26},{-64,18}}, color={191,0,0}));
  connect(thermalResistor2.port_a, thermalResistor3.port_b)
    annotation (Line(points={{-64,-2},{-64,-14}}, color={191,0,0}));
  connect(thermalResistor3.port_a, thermalResistor4.port_b)
    annotation (Line(points={{-64,-34},{-64,-44}}, color={191,0,0}));
  connect(heatCapacitor5.port, thermalResistor4.port_a)
    annotation (Line(points={{-36,-68},{-36,-72},{-64,-72},{-64,-64}},
        color={191,0,0}));
  connect(heatCapacitor4.port, thermalResistor3.port_a)
    annotation (Line(points={{-36,-36},{-36,-40},{-58,-40},{-58,-38},
          {-64,-38},{-64,-34}}, color={191,0,0}));
  connect(heatCapacitor3.port, thermalResistor2.port_a)
    annotation (Line(points={{-36,-4},{-36,-8},{-64,-8},{-64,-2}},
        color={191,0,0}));
  connect(heatCapacitor2.port, thermalResistor1.port_a)
    annotation (Line(points={{-36,28},{-36,22},{-64,22},{-64,26}},
        color={191,0,0}));
  connect(prescribedHeatFlowNIR.port, port_a) annotation (Line(points=
         {{14,38},{18,38},{18,86},{-50,86},{-50,88},{-64,88}},
        color={191,0,0}));
  connect(prescribedHeatFlowPAR.port, port_a) annotation (Line(
        points={{14,20},{18,20},{18,86},{-50,86},{-50,88},{-64,88}},
        color={191,0,0}));
  connect(heatCapacitor5.port, thermalResistor5.port_b)
    annotation (Line(points={{-36,-68},{-36,-72},{-64,-72}}, color=
         {191,0,0}));
  connect(thermalResistor5.port_a, port_b) annotation (Line(points=
         {{-64,-92},{-62,-92},{-62,-108}}, color={191,0,0}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
              extent={{-84,40},{90,-16}},
              lineColor={28,108,200},
              fillColor={147,81,6},
              fillPattern=FillPattern.Solid), Text(
              extent={{-68,26},{72,-36}},
              textColor={28,108,200},
              textString="Soil
")}),     Diagram(coordinateSystem(preserveAspectRatio=false)));
end Soil;
