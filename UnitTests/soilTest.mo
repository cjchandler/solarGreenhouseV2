within solarGreenhouseV2.UnitTests;
model soilTest
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature airTemp20c(T= Modelica.Units.Conversions.from_degC( 20))
    annotation (Placement(transformation(extent={{-84,-6},{-64,14}})));
    //I put these parameters in explicitly so that even if I change params so an example it won't mess up this unit test
  parameter greenhouseParameters Params(
    floor_area=2,
    soil_depth=1,
    soil_specific_heat=1000,
    soil_thermal_conductivity=0.7,
    Rsi_subsoil_insulation=1,
    panel_soil_absorptions = {1,  1})
    annotation (Placement(transformation(extent={{-100,42},{-80,62}})));
  parameter physicalConstants Consts
    annotation (Placement(transformation(extent={{-100,66},{-80,86}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=Params.deep_soil_temperature)
    annotation (Placement(transformation(extent={{-84,-76},{-64,-56}})));
  Components.Soil soil(
    P=Params,
    C=Consts,
    PAR_absorbed = 20,
    NIR_absorbed = 20)  annotation (Placement(transformation(extent=
           {{-38,-44},{-18,-24}})));
  Real dummy;
equation
  dummy = abs(soil.port_a.Q_flow +  soil.port_b.Q_flow + 40);
  when time > 1e8 then
    assert( abs(soil.port_a.Q_flow +  soil.port_b.Q_flow + 40)  <= 1e-5, " check");
  end when;
  connect(soil.port_a, airTemp20c.port) annotation (Line(points={{-34.4,
          -29},{-34.4,4},{-64,4}}, color={191,0,0}));
  connect(soil.port_b, fixedTemperature.port) annotation (Line(
        points={{-34.2,-42.8},{-58,-42.8},{-58,-66},{-64,-66}},
        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end soilTest;
