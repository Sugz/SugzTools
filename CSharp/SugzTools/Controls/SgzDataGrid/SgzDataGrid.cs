using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzDataGrid : DataGrid
    {

        #region Fields





        #endregion Fields


        #region Properties





        #endregion Properties


        #region Dependency Properties





        #endregion Dependency Properties


        #region Constructors


        static SgzDataGrid()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDataGrid), new FrameworkPropertyMetadata(typeof(SgzDataGrid)));
        }
        public SgzDataGrid()
        {

        }


        #endregion Constructors


        #region Methods





        #endregion Methods

    }
}