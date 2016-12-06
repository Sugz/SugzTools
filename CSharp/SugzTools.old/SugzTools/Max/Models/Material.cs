using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;

namespace SugzTools.Max.Models
{
    /// <summary>
    /// Wrapps the IMtl interface
    /// </summary>
    public class Material
    {
        // Properties
        #region Properties

        /// <summary>
        /// The wrapped IMtl
        /// </summary>
        public IMtl _Mtl { get; private set; }


        /// <summary>
        /// Get and set material's name
        /// </summary>
        public String Name
        {
            get { return _Mtl.Name; }
            set { _Mtl.Name = value; }
        }


        #endregion // End Properties



        // Constructor
        #region Constructor


        public Material(IMtl mtl)
        {
            _Mtl = mtl;
        }


        #endregion // End Constructor


    }
}
