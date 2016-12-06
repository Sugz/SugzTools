using SgzControls.Src;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SgzControls.Controls
{

    public enum SgzRadioButtonTypes
    {
        Standard,
        CheckButton,
    }


    public class SgzRadioButton : RadioButton
    {

        // Fields
        #region Fields


        private SgzRadioButtonTypes _Type = SgzRadioButtonTypes.Standard;


        #endregion // End Fields



        // Properties
        #region Properties

        /// <summary>
        /// Get / Set the type of the radiobutton (radiobutton or checkbutton)
        /// </summary>
        [Description("Get / Set the type of the radiobutton (radiobutton or checkbutton)"), Category("Appearance")]
        public SgzRadioButtonTypes Type
        {
            get { return _Type; }
            set
            {
                _Type = value;
                SwitchType();
            }
        }


        #endregion // End Properties



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
            DependencyProperty.Register("LabelPlacement", typeof(LabelPlacement), typeof(SgzRadioButton), new PropertyMetadata(LabelPlacement.Left));


        /// <summary>
        /// Get / set the CornerRadius property
        /// </summary>
        [Description("Get / set the CornerRadius"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }
        public static readonly DependencyProperty CornerRadiusProperty =
            DependencyProperty.Register("CornerRadius", typeof(int), typeof(SgzRadioButton), new PropertyMetadata(3));


        #endregion // End Dependency Properties



        // Constructors
        #region Constructors


        public SgzRadioButton() : this(SgzRadioButtonTypes.Standard) { }

        public SgzRadioButton(SgzRadioButtonTypes type)
        {
            _Type = type;
            SwitchType();
        }


        #endregion // End Constructors


        // Methods
        #region Methods


        private void SwitchType()
        {
            switch (_Type)
            {
                case SgzRadioButtonTypes.CheckButton:
                    Style = Resource<Style>.GetStyle("SgzRadioButtonStyle", "SgzRadioButtonCheckButtonStyle");
                    break;
                case SgzRadioButtonTypes.Standard:
                default:
                    Style = Resource<Style>.GetStyle("SgzRadioButtonStyle", "SgzRadioButtonStandardStyle");
                    break;
            }
        }


        #endregion // End Methods

    }
}
