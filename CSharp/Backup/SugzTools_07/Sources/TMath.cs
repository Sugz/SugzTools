using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Src
{
    internal static class TMath
    {
        // Add
        internal static T Add<T>(T left, T right)
        {
            return Add<T, T, T>(left, right);
        }
        internal static T2 Add<T1, T2>(T1 left, T2 right)
        {
            return Add<T1, T2, T2>(left, right);
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
        internal static T2 Substract<T1, T2>(T1 left, T2 right)
        {
            return Substract<T1, T2, T2>(left, right);
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
        internal static T2 Multiply<T1, T2>(T1 left, T2 right)
        {
            return Multiply<T1, T2, T2>(left, right);
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
        internal static T2 Divide<T1, T2>(T1 left, T2 right)
        {
            return Divide<T1, T2, T2>(left, right);
        }
        internal static T3 Divide<T1, T2, T3>(T1 left, T2 right)
        {
            dynamic dLeft = left;
            dynamic dRight = right;
            return (T3)(dLeft / dRight);
        }


        // Abs
        internal static T Abs<T>(T value)
        {
            dynamic dValue = value;
            return (T)(Math.Abs(dValue));
        }


    }
}
