using System;

namespace SugzTools.Src
{
    internal static class TMath
    {
        // Add
        internal static T Add<T>(T left, T right)
        {
            return Add<T, T, T>(left, right);
        }
        internal static T1 Add<T1, T2>(T1 left, T2 right)
        {
            return Add<T1, T2, T1>(left, right);
        }
        internal static T3 Add<T1, T2, T3>(T1 left, T2 right)
        {
            dynamic d1 = left;
            dynamic d2 = right;
            return (T3)(d1 + d2);
        }


        // Sub
        internal static T Substract<T>(T left, T right)
        {
            return Substract<T, T, T>(left, right);

        }
        internal static T1 Substract<T1, T2>(T1 left, T2 right)
        {
            return Substract<T1, T2, T1>(left, right);
        }
        internal static T3 Substract<T1, T2, T3>(T1 left, T2 right)
        {
            dynamic dLeft = left;
            dynamic dRight = right;
            return (T3)(dLeft - dRight);
        }


        // Multiply
        internal static T Multiply<T>(T left, T right)
        {
            return Multiply<T, T, T>(left, right);
        }
        internal static T1 Multiply<T1, T2>(T1 left, T2 right)
        {
            return Multiply<T1, T2, T1>(left, right);
        }
        internal static T3 Multiply<T1, T2, T3>(T1 left, T2 right)
        {
            dynamic dLeft = left;
            dynamic dRight = right;
            return (T3)(dLeft * dRight);
        }


        // Divide
        internal static T Divide<T>(T left, T right)
        {
            return Divide<T, T, T>(left, right);
        }
        internal static T1 Divide<T1, T2>(T1 left, T2 right)
        {
            return Divide<T1, T2, T1>(left, right);
        }
        internal static T3 Divide<T1, T2, T3>(T1 left, T2 right)
        {
            dynamic dLeft = left;
            dynamic dRight = right;
            return (T3)(dLeft / dRight);
        }


        // Negate
        internal static T Negate<T>(T value)
        {
            dynamic dValue = value;
            return (T)(-dValue);
        }


        // Abs
        internal static T Abs<T>(T value)
        {
            dynamic dValue = value;
            return (T)(Math.Abs(dValue));
        }


        // Round
        internal static T Round<T>(T value, int decimals)
        {
            dynamic dValue = value;
            if (typeof(T) == typeof(float) || typeof(T) == typeof(double))
                return (T)(Math.Round(Convert.ToDouble(dValue), decimals));
            else if (typeof(T) == typeof(decimal))
                return (T)(Math.Round(Convert.ToDecimal(dValue), decimals));
            return value;
        }


        // RoundDown
        internal static T RoundDown<T>(T value, int decimals)
        {
            dynamic dValue = value;
            double power = Math.Pow(10, decimals);
            return (T)TMath.Divide<double, double, T>(Math.Floor(TMath.Multiply(dValue, power)), power);
        }



    }

}
