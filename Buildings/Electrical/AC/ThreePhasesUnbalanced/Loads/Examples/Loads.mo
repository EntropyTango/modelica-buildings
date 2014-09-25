within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Examples;
model Loads "This model tests the load models without neutral cable connection"
  extends Modelica.Icons.Example;
  Sources.FixedVoltage sou(definiteReference=true) "Voltage source"
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  Modelica.Blocks.Sources.Sine ph_1(
    amplitude=2000,
    freqHz=10,
    offset=-2500) "Power signal for loads on phase 1"
               annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Modelica.Blocks.Sources.Constant ph_23(k=0)
    "Power signal for loads on phase 2 and 3"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Resistive loaR(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input)
    "Resistive load"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Inductive loaRL(mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input)
    "Inductive load"
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
  Capacitive loaRC(mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input)
    "Capacitive load"
    annotation (Placement(transformation(extent={{-8,-80},{12,-60}})));
  Sensors.GeneralizedSensor sen "Power sensor"
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
  Sensors.GeneralizedSensor senSingleConn "Power sensor"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Capacitive loaRC1(
                   mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    plugPhase2=false,
    plugPhase3=false) "Capacitive load"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Inductive loaRL1(
                  mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    plugPhase2=false,
    plugPhase3=false) "Inductive load"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Resistive loaR1(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    plugPhase2=false,
    plugPhase3=false) "Resistive load"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
equation
  connect(ph_1.y, loaR.Pow1) annotation (Line(
      points={{59,40},{54,40},{54,6},{12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaR.Pow3) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-6},{12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaR.Pow2) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,6.66134e-16},{12,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_1.y, loaRL.Pow1) annotation (Line(
      points={{59,40},{54,40},{54,-24},{12,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_1.y, loaRC.Pow1) annotation (Line(
      points={{59,40},{54,40},{54,-64},{12,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRL.Pow2) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-30},{12,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRL.Pow3) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-36},{12,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRC.Pow2) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-70},{12,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_23.y, loaRC.Pow3) annotation (Line(
      points={{79,4.44089e-16},{68,4.44089e-16},{68,-76},{12,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, sen.terminal_n) annotation (Line(
      points={{-74,5.55112e-16},{-66,5.55112e-16},{-66,4.44089e-16},{-64,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(sen.terminal_p, loaR.terminal_p) annotation (Line(
      points={{-44,0},{-8,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen.terminal_p, loaRL.terminal_p) annotation (Line(
      points={{-44,0},{-26,0},{-26,-30},{-8,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen.terminal_p, loaRC.terminal_p) annotation (Line(
      points={{-44,0},{-26,0},{-26,-70},{-8,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senSingleConn.terminal_p, loaR1.terminal_p) annotation (Line(
      points={{-40,60},{-36,60},{-36,80},{-30,80}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senSingleConn.terminal_p, loaRL1.terminal_p) annotation (Line(
      points={{-40,60},{-10,60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senSingleConn.terminal_p, loaRC1.terminal_p) annotation (Line(
      points={{-40,60},{-16,60},{-16,40},{10,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ph_1.y, loaRC1.Pow1) annotation (Line(
      points={{59,40},{46,40},{46,46},{30,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_1.y, loaRL1.Pow1) annotation (Line(
      points={{59,40},{46,40},{46,66},{10,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ph_1.y, loaR1.Pow1) annotation (Line(
      points={{59,40},{46,40},{46,86},{-10,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, senSingleConn.terminal_n) annotation (Line(
      points={{-74,0},{-68,0},{-68,60},{-60,60}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics), Documentation(info="<html>
<p>
This example model shows how three phases unbalanced loads can be used.
</p>
<p>
This model contains two set of loads (one for each type: resistive, inductive and capacitive)
that consume power just on the first phase. The example shows how it's possible to model 
this situation in two different ways. It's possible to not connect the loads on the phases
setting the parameters <code>plugLoad*=false</code>.
The alternative is to impose the load on a specific phase equal to zero.
</p>
<p>
The power measured by the sensors on each phase show that the results are equal.
</p>
<h4>Note:</h4>
<p>
Whenever possible disabling the load on a specific phase using the parameter <code>plugLoad*</code>
should be preferred since the equations relative to the load are conditionally removed, reducing the size
of the resulting system of equations.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Created model from previus version and added documentation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau", StopTime=1.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Loads/Examples/Loads.mos"
        "Simulate and plot"),
    __Dymola_experimentSetupOutput);
end Loads;
