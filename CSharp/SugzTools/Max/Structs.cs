using Autodesk.Max;
using System;

namespace SugzTools.Max
{
    /// <summary>
    /// Represents 3-dimensional control points with double values. 
    /// </summary>
    [Serializable]
    public class Point3
    {
        public float X;
        public float Y;
        public float Z;

        public Point3() : this(0, 0, 0) { }
        public Point3(IPoint3 pt) : this(pt.X, pt.Y, pt.Z) { }
        public Point3(float x, float y, float z) { X = x; Y = y; Z = z; }

        public IPoint3 IPoint3 { get { return Kernel.Global.Point3.Create(X, Y, Z); } }

        // Allow array-like access to this class
        public float this[int i]
        {
            get
            {
                switch (i)
                {
                    case 0: return X;
                    case 1: return Y;
                    case 2: return Z;
                    default:
                        throw new IndexOutOfRangeException();
                }
            }
            set
            {
                switch (i)
                {
                    case 0: X = value; break;
                    case 1: Y = value; break;
                    case 2: Z = value; break;
                    default:
                        throw new IndexOutOfRangeException();
                }
            }
        }
    }
}
