using SgzControls.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;

namespace SgzControls.Controls
{
    public class SgzExpander : Expander
    {

        // Dependency Properties
        #region // Dependency Properties



        /// <summary>
        /// Get / set a content backup to exchange it between Content and the Popup.
        /// </summary>
        public object OldContent
        {
            get { return (object)GetValue(OldContentProperty); }
            set { SetValue(OldContentProperty, value); }
        }
        public static readonly DependencyProperty OldContentProperty =
            DependencyProperty.Register("OldContent", typeof(object), typeof(SgzExpander));



        /// <summary>
        /// Get / set the placement for the  Popup. Default to Right.
        /// </summary>
        [Description("Get / set the height of the header"), Category("Common")]
        public PlacementMode PopUpPlacementMode
        {
            get { return (PlacementMode)GetValue(PopUpPlacementModeProperty); }
            set { SetValue(PopUpPlacementModeProperty, value); }
        }
        public static readonly DependencyProperty PopUpPlacementModeProperty =
            DependencyProperty.Register("PopUpPlacementMode", typeof(PlacementMode), typeof(SgzExpander), new PropertyMetadata(PlacementMode.Right));



        /// <summary>
        /// Get / set the HeaderBrush property
        /// </summary>
        [Description("Get / set the color of the header"), Category("Brush")]
        public Brush HeaderBrush
        {
            get { return (Brush)GetValue(HeaderBrushProperty); }
            set { SetValue(HeaderBrushProperty, value); }
        }
        public static readonly DependencyProperty HeaderBrushProperty =
            DependencyProperty.Register("HeaderBrush", typeof(Brush), typeof(SgzExpander), new PropertyMetadata(null));//(Resource<SolidColorBrush>.GetColor("MaxRollout")));



        /// <summary>
        /// Get / set the height of the header
        /// </summary>
        [Description("Get / set the height of the header"), Category("Appearance")]
        public int HeaderHeight
        {
            get { return (int)GetValue(HeaderHeightProperty); }
            set { SetValue(HeaderHeightProperty, value); }
        }
        public static readonly DependencyProperty HeaderHeightProperty =
            DependencyProperty.Register("HeaderHeight", typeof(int), typeof(SgzExpander), new PropertyMetadata(18));



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
            DependencyProperty.Register("CornerRadius", typeof(int), typeof(SgzExpander), new PropertyMetadata(2));



        #endregion // End Dependency Properties



        // Constructors
        #region Constructors


        public SgzExpander()
        {
            Style = Resource<Style>.GetStyle("SgzExpanderStyle");
        }



        #endregion // End Constructors



        // Overridden Methods
        #region // Overridden methods


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            OldContent = Content;
            Content = null;
        }



        #endregion // End Overridden Methods

    }
}
