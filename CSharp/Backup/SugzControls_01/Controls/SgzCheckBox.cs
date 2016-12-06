using SgzControls.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace SgzControls.Controls
{
    public class SgzCheckBox : CheckBox
    {

        // Dependency Properties
        #region // Dependency Properties


        /// <summary>
        /// Get / Set the placement of the label
        /// </summary>
        [Description("Get / Set the placement of the label"), Category("Appearance")]
        public LabelPlacement LabelPlacement
        {
            get { return (LabelPlacement)GetValue(StringPlacemementProperty); }
            set { SetValue(StringPlacemementProperty, value); }
        }
        public static readonly DependencyProperty StringPlacemementProperty =
            DependencyProperty.Register("LabelPlacement", typeof(LabelPlacement), typeof(SgzCheckBox), new PropertyMetadata(LabelPlacement.Left));


        #endregion // End Dependency Properties


        // Constructors
        #region Constructors


        public SgzCheckBox()
        {
            Style = Resource<Style>.GetStyle("SgzCheckBoxStyle");
        }



        #endregion // End Constructors


    }
}
