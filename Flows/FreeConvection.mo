within solarGreenhouseV2.Flows;
model FreeConvection
  "convestion from a surface to air, no wind or fans, filled port is a solid plane, unfilled port connects to air"
   //label    class name          class instance name
   parameter greenhouseParameters P;
   parameter physicalConstants C;
  parameter Real minh = 1e-9 "smallest h is allowed to go to avoid zero problems";

  input Modelica.Units.SI.Area A "surface area of the plane"  annotation (Dialog);
  parameter Modelica.Units.SI.Length L "charactaristic legth for convection";
  Modelica.Units.SI.Temperature air_temp;
  Modelica.Units.SI.Temperature solid_temp;

  parameter Modelica.Units.NonSI.Angle_deg phi "angle of physical plane with respect to horizon. deg. 0 is horizontal";
  parameter Boolean air_is_above_surface = true "assumes air is above surface, ex hot floor. adjust to false as needed";

  Modelica.Units.SI.HeatFlowRate Q_flow
    "Heat flow rate from port_a -> port_b";
  Modelica.Units.SI.TemperatureDifference dT "port_a.T - port_b.T, or solid_temp - air_temp";

  Modelica.Units.SI.CoefficientOfHeatTransfer h "coefficent of convection";
  Real Ra "Raleigh number, parameter dependent";
  Real Nu "Nusselt number parameter dependent";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a annotation (
      Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort_b annotation (
      Placement(transformation(extent={{80,-8},{100,12}}), iconTransformation(
          extent={{80,-8},{100,12}})));

protected
  parameter Modelica.Units.SI.ThermalConductivity k = C.air_thermal_conductivity "air thermal conductivity";
  parameter Modelica.Units.SI.KinematicViscosity nu= C.air_kinematic_viscosity "Kinematic Viscosity dry air at 18c, not super sensitive to temperature change";
  parameter Modelica.Units.SI.DynamicViscosity mu=C.air_dynamic_viscosity "Dynamic Viscosity dry air at 18c, not super sensitive to temperature change";
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp=C.air_specific_heat_capacity "specific heat of dry air j/kg";
  parameter Real Beta= C.air_thermal_expansion_coef "air Thermal ExpansionCoef";
  parameter Real a= C.air_thermal_diffusivity "air thermal diffusivity ";
  parameter Real Pr = C.air_prandtl  "air Prandtl number  ";


  ///variables for calculating the convection coefficent



  parameter Real s = 11;

  Real h1;
  Real h2;
  Real s1;
  Real s2;
  Real G;

equation
  air_temp = heatPort_b.T;
  solid_temp = heatPort_a.T;

  //plane is vertical (walls)
  if
    ( phi >= (85) and phi <= (95)) then
      G = (9.81*Beta*L*L*L/(a*nu));
      // switchdT = 1e9/G

      h1 = 0.59*(k/L)*(abs(dT)^0.25)*G^0.25; //for low Ra < 1e9
      h2 = 0.1*(k/L)*(abs(dT)^0.3333)*G^0.3333; //for low Ra > 1e9
      s1 = solarGreenhouseV2.Functions.onBeforeSwitchVal(x=abs(dT),switchval=1e9/G,scaleFactor=1);
      s2 = solarGreenhouseV2.Functions.onAfterSwitchVal(x=abs(dT), switchval=1e9/G,scaleFactor=1);
      h = h1*s1  + h2*s2;

      Ra = 10;
      Nu = 10;

  //if plane is at an angle (sloped or flat roof)
  elseif
        (  phi <= (60)) then

      G = (9.81*cos(phi)*Beta*L*L*L/(a*nu));
      if
        ( air_is_above_surface == true) then
      s1 = solarGreenhouseV2.Functions.onAfterSwitchVal( x=dT, switchval=0, scaleFactor=1);//dT above 0
      s2 = solarGreenhouseV2.Functions.onBeforeSwitchVal( x=dT,switchval=0, scaleFactor=1);//dT below 0
      h1 = 0.54*(k/L)*(abs(dT)^0.25)*(G^0.25)* solarGreenhouseV2.Functions.onBeforeSwitchVal(x=dT,switchval=1e7/G,scaleFactor=1)
         + 0.15*(k/L)*(abs(dT)^0.3333)*(G^0.3333)*solarGreenhouseV2.Functions.onAfterSwitchVal(x=dT,switchval=1e7/G,scaleFactor=1);

      h2 = 0.27*(k/L)*(abs(dT)^0.25)*(G^0.25)*solarGreenhouseV2.Functions.onBeforeSwitchVal( x=dT,switchval=1e7/G,scaleFactor=1);
      else // air above suface == false
      s2 = solarGreenhouseV2.Functions.onAfterSwitchVal(x=dT,switchval=0,scaleFactor=1); //dT above 0
      s1 = solarGreenhouseV2.Functions.onBeforeSwitchVal(x=dT,switchval=0,scaleFactor=1);//dT below 0
      h1 = 0.54*(k/L)*(abs(dT)^0.25)*(G^0.25)*solarGreenhouseV2.Functions.onBeforeSwitchVal( x=dT,switchval=1e7/G,scaleFactor=1)
         + 0.15*(k/L)*(abs(dT)^0.3333)*(G^0.3333)*solarGreenhouseV2.Functions.onAfterSwitchVal(x=dT,switchval=1e7/G,scaleFactor=1);
      h2 = 0.27*(k/L)*(abs(dT)^0.25)*G^0.25;
      end if;

      //do Ra smoothing all here?
      Ra = 10;
      Nu = 10;
      h = h1*s1  + h2*s2;

  /// if the angle is greater than 60 but less than 85
  else//else there in final version
      assert( 1==0, "failed to find a model for convection for that angle of plane");
      Nu = 0;
      h=0.1;
      Ra = -1.0;
      h1 = 0;
      h2 = 0;
      s1 = 0;
      s2=0;
      G=0;
  end if;

  Q_flow = A*h*dT;
  heatPort_a.Q_flow = Q_flow;
  heatPort_b.Q_flow = -Q_flow;
  dT = solid_temp - air_temp;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-84,-22},{86,-38}},
          lineColor={238,46,47},
          fillPattern=FillPattern.Solid,
          fillColor={238,46,47}),
        Line(points={{-56,34},{-56,-12}}, color={238,46,47}),
        Line(points={{-34,34},{-34,-14}}, color={238,46,47}),
        Line(points={{-12,36},{-12,-12}}, color={238,46,47}),
        Line(points={{10,36},{10,-12}}, color={238,46,47}),
        Line(points={{24,34},{26,-12}}, color={238,46,47}),
        Line(points={{40,34},{38,-14}}, color={238,46,47}),
        Line(points={{62,34},{62,-16}}, color={238,46,47}),
        Text(
          extent={{-238,-56},{226,-82}},
          textColor={28,108,200},
          textString="%name")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
              Icon(graphics={Ellipse(
          extent={{-82,18},{82,-16}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,12},{56,-10}},
          textColor={0,0,0},
          textString="convec")}));
end FreeConvection;
