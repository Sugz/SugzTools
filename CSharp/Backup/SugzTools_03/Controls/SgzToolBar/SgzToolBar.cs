using SugzTools.Max;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using UiViewModels.Actions;

namespace SugzTools.Controls
{
    [TemplatePart(Name = "PART_LeftResizer", Type = typeof(Thumb))]
    [TemplatePart(Name = "PART_RightResizer", Type = typeof(Thumb))]
    public class SgzToolBar : Control
    {

        #region Fields


        Thumb PART_LeftResizer;
        Thumb PART_RightResizer;


        #endregion Fields



        #region Constructors


        static SgzToolBar()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzToolBar), new FrameworkPropertyMetadata(typeof(SgzToolBar)));
        }
        public SgzToolBar()
        {

        }


        #endregion Constructors



        #region Methods


        #region Privates


        private void Resizer_DragDelta(object sender, DragDeltaEventArgs e)
        {
            Kernel.RunMxs("disableSceneRedraw()");

            // Set the new width depending on which thumb trigger the resize and make sure to limit the resize to the MinWidth
            double xAdjust = ((Thumb)sender) == PART_RightResizer ? Width + e.HorizontalChange : Width - e.HorizontalChange;
            Width = (ActualWidth + xAdjust) > MinWidth ? xAdjust : MinWidth;

            Kernel.RunMxs("enableSceneRedraw()");
        }


        #endregion Privates


        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            Thumb left = GetTemplateChild("PART_LeftResizer") as Thumb;
            Thumb right = GetTemplateChild("PART_RightResizer") as Thumb;
            if (left != null && right != null)
            {
                PART_LeftResizer = left;
                PART_RightResizer = right;

                PART_LeftResizer.DragDelta += Resizer_DragDelta;
                PART_RightResizer.DragDelta += Resizer_DragDelta;
            }
        }



        #endregion Overrides


        #region Publics


        public void ShowResizers(DockStates.Dock dockMode)
        {
            if (dockMode == DockStates.Dock.Floating)
            {
                PART_LeftResizer.Visibility = Visibility.Collapsed;
                PART_RightResizer.Visibility = Visibility.Collapsed;
            }
            else
            {
                PART_LeftResizer.Visibility = Visibility.Visible;
                PART_RightResizer.Visibility = Visibility.Visible;

                if (dockMode == DockStates.Dock.Left)
                {
                    PART_LeftResizer.IsEnabled = false;
                    PART_RightResizer.IsEnabled = true;
                }
                    
                if (dockMode == DockStates.Dock.Right)
                {
                    PART_LeftResizer.IsEnabled = true;
                    PART_RightResizer.IsEnabled = false;
                } 
            }
        }


        #endregion Publics


        #endregion Methods



    }

}
