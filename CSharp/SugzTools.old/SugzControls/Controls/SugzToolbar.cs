using SugzControls.Src;
using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using UiViewModels.Actions;


namespace SugzControls.Controls
{

    public class SugzToolbar : UserControl
    {
        // Fields
        #region Fields


        private Grid leftBorder;
        private Grid rightBorder;
        private Thumb leftResizer;
        private Thumb rightResizer;


        #endregion // End Fields


        // Initialisation
        #region Initialisation


        public SugzToolbar()
        {
            //ResourceDictionary resource = new ResourceDictionary();
            //resource.Source = new Uri("/SugzControls;component/Styles/SugzToolbarStyle.xaml", UriKind.RelativeOrAbsolute);
            //Style = resource["SugzToolbarStyle"] as Style;

            //Style = Styler.GetStyle("SugzToolbarStyle");

            Style = Resource<Style>.GetStyle("SugzToolbarStyle");
        }


        


        #endregion // End Initialisation


        // Methods
        #region Methods

        // Private Methods
        #region Private


        private void Resizer_DragDelta(object sender, DragDeltaEventArgs e)
        {
            // Set the new width depending on which thumb trigger the resize and make sure to limit the resize to the MinWidth
            double xAdjust = ((Thumb)sender) == rightResizer ? Width + e.HorizontalChange : Width - e.HorizontalChange;
            Width = (ActualWidth + xAdjust) > MinWidth ? xAdjust : MinWidth;
        }


        #endregion // End Private Methods

        // Public Methods
        #region Public


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            leftBorder = (Grid)GetTemplateChild("LeftBorder");
            rightBorder = (Grid)GetTemplateChild("RightBorder");
            leftResizer = (Thumb)GetTemplateChild("LeftResizer");
            rightResizer = (Thumb)GetTemplateChild("RightResizer");

            leftResizer.DragDelta += Resizer_DragDelta;
            rightResizer.DragDelta += Resizer_DragDelta;
        }


        public void SetResizeBorders(DockStates.Dock dockMode)
        {
            switch (dockMode)
            {
                case DockStates.Dock.Floating:
                    leftBorder.Visibility = Visibility.Collapsed;
                    rightBorder.Visibility = Visibility.Collapsed;
                    break;
                case DockStates.Dock.Left:
                    leftBorder.Visibility = Visibility.Visible;
                    rightBorder.Visibility = Visibility.Visible;
                    leftResizer.Visibility = Visibility.Collapsed;
                    rightResizer.Visibility = Visibility.Visible;
                    break;
                case DockStates.Dock.Right:
                    leftBorder.Visibility = Visibility.Visible;
                    rightBorder.Visibility = Visibility.Visible;
                    leftResizer.Visibility = Visibility.Visible;
                    rightResizer.Visibility = Visibility.Collapsed;
                    break;
            }
        }


        #endregion // End Public Methods


        #endregion // End Methods
    }
}
