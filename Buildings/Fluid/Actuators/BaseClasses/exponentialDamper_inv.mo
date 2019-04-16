within Buildings.Fluid.Actuators.BaseClasses;
function exponentialDamper_inv
  "Inverse function of damper opening characteristics for an exponential damper"
  extends Modelica.Icons.Function;
  input Real kThetaSqRt(min=0);
  input Real[:] kSupSpl "k values of support points";
  input Real[:] ySupSpl "y values of support points";
  input Real[:] invSplDer "Derivatives at support points";
  output Real y "Fractional opening";
protected
  parameter Integer sizeSupSpl = size(kSupSpl, 1);
  Integer i "Integer to select data interval";
  Real kBnd "Bounded flow resistance sqrt value";
algorithm
  kBnd := if kThetaSqRt < kSupSpl[1] then kSupSpl[1] elseif
    kThetaSqRt > kSupSpl[sizeSupSpl] then kSupSpl[sizeSupSpl] else kThetaSqRt;
  i := 1;
  for j in 2:sizeSupSpl loop
    if kBnd <= kSupSpl[j] then
      i := j;
      break;
    end if;
  end for;
  y := max(0, min(1, Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x=kBnd,
    x1=kSupSpl[i - 1],
    x2=kSupSpl[i],
    y1=ySupSpl[i - 1],
    y2=ySupSpl[i],
    y1d=invSplDer[i - 1],
    y2d=invSplDer[i]
  )));

annotation (
Documentation(info="<html>
<p>
This function computes the opening characteristics of an exponential damper.
</p><p>
The function is used by the model
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Buildings.Fluid.Actuators.Dampers.Exponential</a>.
</p><p>
For <code>yL &lt; y &lt; yU</code>, the damper characteristics is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k<sub>d</sub>(y) = exp(a+b (1-y)).
</p>
<p>
Outside this range, the damper characteristic is defined by a quadratic polynomial.
</p>
<p>
Note that this implementation returns <i>sqrt(k<sub>d</sub>(y))</i> instead of <i>k<sub>d</sub>(y)</i>.
This is done for numerical reason since otherwise <i>k<sub>d</sub>(y)</i> may be an iteration
variable, which may cause a lot of warnings and slower convergence if the solver
attempts <i>k<sub>d</sub>(y) &lt; 0</i> during the iterative solution procedure.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2014 by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
July 1, 2011 by Michael Wetter:<br/>
Added constraint to control input to avoid using a number outside
<code>0</code> and <code>1</code> in case that the control input
has a numerical integration error.
</li>
<li>
April 4, 2010 by Michael Wetter:<br/>
Reformulated implementation. The new implementation computes
<code>sqrt(kTheta)</code>. This avoid having <code>kTheta</code> in
the iteration variables, which caused warnings when the solver attempted
<code>kTheta &lt; 0</code>.
</li>
<li>
June 22, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),   smoothOrder=1);
end exponentialDamper_inv;
