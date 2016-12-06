using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using SugzControls;

namespace PhotoGuideLines.Model
{
    public class RuleOfThird
    {
        // Fields
        #region Fields





        #endregion // End Fields



        // Properties
        #region Properties


        public Grid Grid
        {
            get
            {
                ResourceDictionary resource = new ResourceDictionary();
                resource.Source = new Uri(("/PhotoGuideLines;component/Styles/RuleOfThird.xaml"), UriKind.RelativeOrAbsolute);
                return resource["RuleOfThird"] as Grid;
            }
        }

        


        #endregion // End Properties



        // Constructors
        #region Constructors


        public RuleOfThird()
        {

        }


        #endregion // End Constructors



        // Methods
        #region Methods


        


        #endregion // End Methods

    }
}
