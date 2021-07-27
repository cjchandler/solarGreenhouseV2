within solarGreenhouseV2;
package Functions "calculations that go into model components"

  function panelTransmission
    "calculation of how much light is transmitted through a flat panel"
    input Real Dhi "Diffuse normal insolation";
    input Real Dni "Direct noraml insolation";
    input Real solarAltitude;
    input Real solarZenith;

    input Real glazing;

    output Real PAR_transmitted "in watts";
  algorithm
    PAR_transmitted := solarZenith;

  end panelTransmission;

  function canopyAbsorbtionPAR "\"how much PAR is absorbed by canopy\""

  end canopyAbsorbtionPAR;

  function mySplice
    "smoothly connects two functions, der is not nessisarily smooth"
    input Real xL;
    input Real xH;
    input Real fxH "joined function evaled at xH";
    input Real fxL "joined function evaled at xL";
    input Real x;
    output Real fx;

  protected
    Real interval = xH-xL "how far between xL and xH, xH-xL";
    Real halfInterval = interval/2;
    Real xMid = xL + halfInterval;
    Real stepHeight = fxH-fxL "how high of a jump, fxH-fxL";
    Real scaledX1;
    Real y;
    constant Real asin1 = Modelica.Math.asin(1);
  algorithm
      scaledX1 := (x - xMid)/halfInterval;///this runs between -1 and 1
      if scaledX1 <= -0.999999999 then
        fx := fxL;
      elseif scaledX1 >= 0.999999999 then
        fx := fxH;
      else
        y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX1*asin1)) + 1)/2;
        fx := fxH*y + (1 - y)*fxL;
      end if;

  end mySplice;

  function onAfterSwitchVal
    "f(x) that smoothly turns on to 1 after switchval, otherwise is zero"
    input Real x;
    input Real switchval;
    input Real scaleFactor = 1 "a bigger scalefactor makes it switch sharper, a smaller one more slowly";
    output Real val;

  algorithm
     val := 0.5*tanh( (x-switchval)*scaleFactor)  + 0.5;

  end onAfterSwitchVal;

  function onBeforeSwitchVal
    "f(x) that smoothly turns from 1 to 0 after switchval of x"
    input Real x;
    input Real switchval;
    input Real scaleFactor = 1 "a bigger scalefactor makes it switch sharper, a smaller one more slowly";
    output Real val;

  algorithm
     val := -0.5*tanh( (x-switchval)*scaleFactor)  + 0.5;

  end onBeforeSwitchVal;

  function sumPanelAreas "summs all the panel areas in the list in Params"
    input solarGreenhouseV2.greenhouseParameters P;
    output Real out;

  algorithm
    out := 0;
      for i in 1:P.nPanels loop
       out := out + P.panelAreas[i];
      end for;

  end sumPanelAreas;

  function Direct_2interface
    "transmission fraction of direct light through a panel"
    input Real n_index;
    input Modelica.Units.SI.Angle panelAzimuth;
    input Modelica.Units.SI.Angle panelZenith;
    input Modelica.Units.SI.Angle sunAzimuth;
    input Modelica.Units.SI.Angle sunZenith;

    output Real Ttotal;

  protected
    Real Rf;
    Real angleIncident;
    Real T_singleInterface;

  algorithm
    angleIncident := solarGreenhouseV2.Functions.angleBetweenVecs(
        panelAzimuth,
        panelZenith,
        sunAzimuth,
        sunZenith);
    Rf := 0.5*( Rs( 1.0,  n_index,  angleIncident)  + Rp(  1.0,  n_index,  angleIncident));
    T_singleInterface := 1 - Rf;

    //no multiple reflections correction...
    Ttotal := solarGreenhouseV2.Functions.Mr_2interfaces(
      T_singleInterface)*T_singleInterface*T_singleInterface;
    //Ttotal := T_singleInterface*T_singleInterface;

  end Direct_2interface;

  function Rs "\"fresnell s polarization\""
    input Real ni;
    input Real nt;
    input Real thetai;

    output Real rs;
  protected
    Real thetat;

  algorithm
    thetat := asin((ni*sin(thetai)/nt));
    rs := ( ni*cos(thetai) - nt*cos(thetat)) / (  ni*cos(thetai) + nt*cos(thetat));
    rs :=rs*rs;

  end Rs;

  function Rp "fresnel reflectance from p polarization"
    input Real ni;
    input Real nt;
    input Real thetai;

    output Real rp;
  protected
    Real thetat;

  algorithm
    thetat := asin((ni*sin(thetai)/nt));
    rp := ( ni*cos(thetat) - nt*cos(thetai)) / (  ni*cos(thetat) + nt*cos(thetai));
    rp :=rp*rp;

  end Rp;

  function angleBetweenVecs "calculate the angle between two vectors (sun and panel orrientation) of unit length"
    input Real az1 "azimuth  of vec 1 ";
    input Real zen1 "zenith of vec 1";
    input Real az2 "azimuth  of vec 2";
    input Real zen2 "zenith of vec 2";
    import Modelica.Utilities.Streams.print;

    output Real diffangle;
  protected
    Real x1;
    Real y1;
    Real z1;

    Real x2;
    Real y2;
    Real z2;

    Real dot;

  algorithm
    x1 := cos(az1)*sin(zen1);
    y1 := sin(az1)*sin(zen1);
    z1 := cos(zen1);

    x2 := cos(az2)*sin(zen2);
    y2 := sin(az2)*sin(zen2);
    z2 := cos(zen2);

    dot := x1*x2 + y1*y2 + z1*z2;

    diffangle := acos( dot);

    //this is to deal with the sun being on the wrong side of the panel, in that case nothing comes through, so set angle to grazing.
    if diffangle > Modelica.Units.Conversions.from_deg( 90) or  diffangle < Modelica.Units.Conversions.from_deg( -90) then
      diffangle := Modelica.Units.Conversions.from_deg( 90);
    end if;

  end angleBetweenVecs;

  function Mr_2interfaces
    "multiplicative factor taking into account multiple reflections"
    input Real T;
    output Real Mr2;
  protected
    Real T_2;
    Real R = 1-T;

  algorithm
    T_2 :=(T*T)/(1 - R*R);

    Mr2 := T_2/(T*T);
  end Mr_2interfaces;

  function Diffuse_2interface "panel transmission of diffuse light"
    input Real n_index;

    output Real T;

  algorithm
    T := Modelica.Math.Nonlinear.quadratureLobatto(
        function
        solarGreenhouseV2.Functions.diffuseHelperFunctions.integrand_2interface_daz(
        n_index=n_index),
        0,
        2*Modelica.Constants.pi);
    T := T/Modelica.Constants.pi;
  end Diffuse_2interface;

  package diffuseHelperFunctions
    "functions used to computer fresenlDiffuse"

    function integrand_2interface_dzen
      "itegrand for integration over zenith"
      input Real n_index;
      input Real zen;
      input Real az;
      output Real out;
    protected
      Real T2;
    algorithm
      //panel assumed flat, intrgrating over all possible sun directions
      T2 := solarGreenhouseV2.Functions.Direct_2interface(
            n_index,
            0,
            0,
            az,
            zen);
      out :=T2*cos(zen)*sin(zen);

    end integrand_2interface_dzen;

    function integrand_2interface_daz
      "integrand for integrating over all sun azimuths"
      input Real n_index;
      input Real az;
      output Real out;
    algorithm
      out := Modelica.Math.Nonlinear.quadratureLobatto(
            function
          solarGreenhouseV2.Functions.diffuseHelperFunctions.integrand_2interface_dzen(
          n_index=n_index, az=az),
            0,
            Modelica.Constants.pi*0.5);

    end integrand_2interface_daz;
  end diffuseHelperFunctions;

  function panelIllumination "intensity of light flux on a panel"
    input Modelica.Units.SI.HeatFlux Dni;
    input Modelica.Units.SI.HeatFlux Dhi;
    input Real skyFraction;

    input Modelica.Units.SI.Angle panelAzimuth;
    input Modelica.Units.SI.Angle panelZenith;
    input Modelica.Units.SI.Angle sunAzimuth;
    input Modelica.Units.SI.Angle sunZenith;

    output Real Itotal;

  protected
    Real angleIncident;

  algorithm
    angleIncident := solarGreenhouseV2.Functions.angleBetweenVecs(
        panelAzimuth,
        panelZenith,
        sunAzimuth,
        sunZenith);
    Itotal := cos(angleIncident)*Dni;
    Itotal := Itotal + skyFraction*Dhi;

  end panelIllumination;

  function absoluteHumidity
    "get ideal gas absolute humidity kg water/m3 from partial pressue, temperature"
    input Real A;
    input Real vP;
    input Real T;
    output Real AH;
  algorithm
    AH :=A*vP/T;

  end absoluteHumidity;

  function flowRateFromACH
    "flow rate in m3/s from air changes per hour and volume"
    input Real ACH;
    input Real Vol;
    output Real flowrate;
  algorithm

    flowrate :=ACH*Vol/(60*60);

  end flowRateFromACH;

  function enthalpyOfHumidAir
    "calculate energy (enthalpy) per volume of humid air from Temperature, and absolute humidity"
    input Real T;
    input Real AH;
    input Real V;
    output Real E;
  protected
    Real hw;
    Real ha;
    Real kg_air;// = V*1.2;
    Real kg_water_vapour;

  algorithm
    kg_air := V*1.2;
    kg_water_vapour := AH*V;

    hw :=(1860*Modelica.Units.Conversions.to_degC(T))*kg_water_vapour +  2501000*kg_water_vapour;
    ha := 1006*Modelica.Units.Conversions.to_degC(T)*kg_air;
    E:= hw+ha;
  end enthalpyOfHumidAir;

  function saturatedVapourPressure
    "saturated water pressure from temperature based on vaisalla paper"
    input Real T;
    output Real Psat;
  algorithm
    Psat := 610.94*exp( 17.625*Modelica.Units.Conversions.to_degC(T)/(  Modelica.Units.Conversions.to_degC(T) + 237.3));
  end saturatedVapourPressure;

  function slopeOfSaturatedVapourPressure
    "saturated water pressure from temperature based on vaisalla paper"
    input Real T;
    output Real dPsat;
  algorithm
    dPsat := ( 17.625/(  Modelica.Units.Conversions.to_degC(T) + 237.3)) +
     ( -17.625*Modelica.Units.Conversions.to_degC(T)/( (Modelica.Units.Conversions.to_degC(T) + 237.3)*(Modelica.Units.Conversions.to_degC(T) + 237.3)));
    dPsat := dPsat*
      solarGreenhouseV2.Functions.saturatedVapourPressure(T);

  end slopeOfSaturatedVapourPressure;

  function slopeOfSaturatedVapourPressure2 = der(
      solarGreenhouseV2.Functions.saturatedVapourPressure, T);
  function stanghelliniLE "get LE from re,ri,Rnet,VPD,T_air,LAI eq 3.4 in thesis"
    input Real re;
    input Real ri;
    input Real Rnet;
    input Real VPD;
    input Real T_air;
    input Real LAI;
    output Real LE;
  protected
    Real gamma = 66;
    Real rho_a= 1.225;
    Real cp = 1000;
    Real delta;
  algorithm
    delta :=
      solarGreenhouseV2.Functions.slopeOfSaturatedVapourPressure(
      T_air);
    LE:= (  ((delta/gamma)*Rnet) + 2*LAI*cp*rho_a*VPD/(gamma*re)) /( 1 +  delta/gamma + ri/re);

    /*"get LE from re,ri,Rnet,VPD,T_air eq 3.4 in thesis"
  input Real re;
  input Real ri;
  input Real Rnet;
  input Real VPD;
  input Real T_air;
  input Real rR;
  output Real LE;
  output Real dg;
  output Real LE_R;
protected 
  Real gamma = 66;
  Real rho_a= 1.225;
  Real cp = 1000;
  Real delta;
algorithm 
  delta :=
    solarGreenhouseV1.Functions.slopeOfSaturatedVapourPressure(
    T_air);
  LE:= (  ((delta/gamma)*Rnet) + cp*rho_a*VPD/(gamma*re)) /( 1 +  delta/gamma + ri/re);
  dg := delta/gamma;
  LE_R := ( ((delta/gamma)*Rnet) + (cp*rho_a*VPD/(gamma))*( 1/re + 1/rR)) /( 1 + dg + ri/re + (re+ri)/rR);
*/
  end stanghelliniLE;

  function leafStanghelliniLE
    "get LE from re,ri,Rnet,VPD,T_air... for single leaf surface"

    input Real re "external resistance, convection process, stanghellini 1987 notation";
    input Real ri "internal or stomal resistance, stanghellini 1987 notation";
    input Real Rnet "Net radiation on leaf surface, includes thermal radiation if rR = 0 ";
    input Real VPD "vapour pressure deficit";
    input Real T_air "Air temperature far from leaf";
    input Real rR "radiation resistance, a linearization of T^4 dependence, eq 2.65 stanghellini 1987";
    output Real LE "energy lost from leaf via transpiration";
    output Real dg "delta over gamma";
    output Real LE_with_rR "energy lost from leaf via transpiration when rR is specified";
    output Real Tcanopy "leaf temperature";
    output Real TcanopyrR "leaf temperature when rR is specified";
  protected
    Real gamma = 66;
    Real rho_a= 1.225;
    Real cp = 1000;
    Real delta;
  algorithm
    delta :=solarGreenhouseV2.Functions.slopeOfSaturatedVapourPressure(T_air);
    dg := delta/gamma;

    LE:= (  ((dg)*Rnet) + cp*rho_a*VPD/(gamma*re)) /( 1 +  dg + ri/re); //eq 2.55
    LE_with_rR := ( ((dg)*Rnet) + (cp*rho_a*VPD/(gamma))*( 1/re + 1/rR)) /( 1 + dg + ri/re + (re+ri)/rR); //eq 2.63;
    Tcanopy := T_air + ( ((ri+re)/(rho_a*cp))*Rnet - VPD/gamma)/( 1 +  dg + ri/re);//eq 2.56
    TcanopyrR := T_air + ( ((ri+re)/(rho_a*cp))*Rnet - VPD/gamma)/( 1 +  dg + ri/re + (re+re)/rR); //eq 2.64

  end leafStanghelliniLE;

  function Direct_4interface
    "transmission fraction through double glazing panel"
    input Real n_index;
    input Modelica.Units.SI.Angle panelAzimuth;
    input Modelica.Units.SI.Angle panelZenith;
    input Modelica.Units.SI.Angle sunAzimuth;
    input Modelica.Units.SI.Angle sunZenith;

    output Real Ttotal;
  protected
     Real T2 "transmission through 2 interfaces";
     Real R2 "reflection from 2 interfaces";
  algorithm
    T2 := solarGreenhouseV2.Functions.Direct_2interface(
        n_index,
        panelAzimuth,
        panelZenith,
        sunAzimuth,
        sunZenith);
    R2 := 1 - T2;
    Ttotal := T2*T2/( 1 - (R2^2));

  end Direct_4interface;
end Functions;
