using SugzTools.Max;
using SugzTools.Src;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Shapes;
using UiViewModels.Actions;

namespace SugzTools.Controls
{
    [TemplatePart(Name = "PART_LeftResizer", Type = typeof(Thumb))]
    [TemplatePart(Name = "PART_RightResizer", Type = typeof(Thumb))]
    [TemplatePart(Name = "PART_ResizeIndicator", Type = typeof(Rectangle))]
    public class SgzToolBar : UserControl
    {

        #region Fields


        Thumb PART_LeftResizer;
        Thumb PART_RightResizer;
        Rectangle PART_ResizeIndicator;

        #endregion Fields



        #region Constructors


        static SgzToolBar()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzToolBar), new FrameworkPropertyMetadata(typeof(SgzToolBar)));
        }
        public SgzToolBar()
        {
            //Style = Resource<Style>.GetStyle("SgzToolBar");
        }


        #endregion Constructors



        #region Methods


        #region Privates


        private void Resizer_DragDelta(object sender, DragDeltaEventArgs e)
        {
            // Set the new width depending on which thumb trigger the resize and make sure to limit the resize to the MinWidth
            double xAdjust = ((Thumb)sender) == PART_RightResizer ? Width + e.HorizontalChange : Width - e.HorizontalChange;
            Width = (ActualWidth + xAdjust) > MinWidth ? xAdjust : MinWidth;

        }


        #endregion Privates


        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            Thumb left = GetTemplateChild("PART_LeftResizer") as Thumb;
            if (left != null)
            {
                PART_LeftResizer = left;
                PART_LeftResizer.DragDelta += Resizer_DragDelta;
                //PART_LeftResizer.MouseDown += (s,e) => Kernel.RunMxs("disableSceneRedraw()");
                //PART_LeftResizer.MouseUp += (s, e) => Kernel.RunMxs("enableSceneRedraw()");
                PART_LeftResizer.MouseUp += (s, e) => Width = PART_ResizeIndicator.ActualWidth;
            }

            Thumb right = GetTemplateChild("PART_RightResizer") as Thumb;
            if (right != null)
            {
                PART_RightResizer = right;
                PART_RightResizer.DragDelta += Resizer_DragDelta;
                PART_RightResizer.MouseUp += (s, e) => Width = PART_ResizeIndicator.ActualWidth;
            }

            Rectangle rect = GetTemplateChild("PART_ResizeIndicator") as Rectangle;
            if (rect != null)
            {
                PART_ResizeIndicator = rect;
            }
        }


        #endregion Overrides


        #region Publics


        public void SetResizers(DockStates.Dock dockMode)
        {
            switch (dockMode)
            {
                case DockStates.Dock.Floating:
                    PART_LeftResizer.Visibility = Visibility.Collapsed;
                    PART_RightResizer.Visibility = Visibility.Collapsed;
                    break;
                case DockStates.Dock.Left:
                    PART_LeftResizer.Visibility = Visibility.Collapsed;
                    PART_RightResizer.Visibility = Visibility.Visible;
                    break;
                case DockStates.Dock.Right:
                    PART_LeftResizer.Visibility = Visibility.Visible;
                    PART_RightResizer.Visibility = Visibility.Collapsed;
                    break;
            }
        }


        #endregion Publics


        #endregion Methods



    }

}
