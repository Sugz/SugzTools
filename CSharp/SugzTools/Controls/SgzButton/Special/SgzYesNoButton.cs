using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;

namespace SugzTools.Controls
{
    [TemplatePart(Name = "PART_No", Type = typeof(SgzIcon))]
    [TemplatePart(Name = "PART_Yes", Type = typeof(SgzIcon))]
    public class SgzYesNoButton : Button
    {
        SgzIcon PART_No;
        SgzIcon PART_Yes;


        static SgzYesNoButton()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzYesNoButton), new FrameworkPropertyMetadata(typeof(SgzYesNoButton)));
        }
        public SgzYesNoButton()
        {

        }


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();
            if (GetTemplateChild("PART_No") is SgzIcon noIcon && GetTemplateChild("PART_Yes") is SgzIcon yesIcon)
            {
                PART_No = noIcon;
                PART_Yes = yesIcon;

                IsEnabledChanged += SgzNoYesButton_IsEnabledChanged;
            }
        }

        private void SgzNoYesButton_IsEnabledChanged(object sender, DependencyPropertyChangedEventArgs e)
        {
            int time = 250;
            DoubleAnimation vanish = new DoubleAnimation(1, 0, TimeSpan.FromMilliseconds(time));
            vanish.EasingFunction = new BackEase() { EasingMode = EasingMode.EaseIn };

            DoubleAnimation show = new DoubleAnimation(0, 1, TimeSpan.FromMilliseconds(time));
            show.BeginTime = TimeSpan.FromMilliseconds(time);
            show.EasingFunction = new BackEase() { EasingMode = EasingMode.EaseOut };

            if (IsEnabled)
            {
                PART_No.RenderTransform.BeginAnimation(ScaleTransform.ScaleXProperty, vanish);
                PART_No.RenderTransform.BeginAnimation(ScaleTransform.ScaleYProperty, vanish);
                PART_Yes.RenderTransform.BeginAnimation(ScaleTransform.ScaleXProperty, show);
                PART_Yes.RenderTransform.BeginAnimation(ScaleTransform.ScaleYProperty, show);
            }
            else
            {
                PART_No.RenderTransform.BeginAnimation(ScaleTransform.ScaleXProperty, show);
                PART_No.RenderTransform.BeginAnimation(ScaleTransform.ScaleYProperty, show);
                PART_Yes.RenderTransform.BeginAnimation(ScaleTransform.ScaleXProperty, vanish);
                PART_Yes.RenderTransform.BeginAnimation(ScaleTransform.ScaleYProperty, vanish);
            }
        }
    }
}
