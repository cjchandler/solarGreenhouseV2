within solarGreenhouseV2.Flows;
model greyBodyRadiation "thermal radiation, Q flow positive for (filled) port_a.T > port_b.T (unfilled)"
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;

  /*********************** Varying inputs ***********************/

  input Real epsilon_a "emissivity coefficient of surface A (filled port)"     annotation (Dialog(group="Varying inputs"));

  input Real epsilon_b "emissivity coefficient of surface B (unfilled port)"     annotation (Dialog(group="Varying inputs"));

  input Modelica.Units.SI.Area A_a "area A"    annotation (Dialog(group="Varying inputs"));

  input Modelica.Units.SI.Area A_b "area B"    annotation (Dialog(group="Varying inputs"));

  input Real AF  "A_a*View factor of elementA to B WHICH IS EQUAL TO A_b*View factor of elementB to A"
    annotation (Dialog(group="Varying inputs"));

protected
  Real R1;
  Real R2;
  Real R3;

equation
  R1 = (1 - epsilon_a)/(A_a*epsilon_a);
  R3 = (1 - epsilon_b)/(A_b*epsilon_b);
  R2 = 1/AF;

  Q_flow = (1.0/(R1+R2+R3))*Modelica.Constants.sigma*(  (port_a.T^4) - (port_b.T^4));

    annotation (Dialog(group="Varying inputs"), Icon(graphics={Line(
          points={{-78,0},{-54,12},{-38,-10},{-22,8},{-10,-6},{6,6},{28,-8},{38,8},
              {62,-6},{80,10},{86,-4}},
          color={255,0,0},
          smooth=Smooth.Bezier,
          thickness=1), Text(
          extent={{-198,-4},{204,-32}},
          textColor={28,108,200},
          textString="%name")}));
end greyBodyRadiation;
