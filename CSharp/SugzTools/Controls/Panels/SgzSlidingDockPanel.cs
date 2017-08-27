using SugzTools.Icons;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;

namespace SugzTools.Controls
{
    public enum AnimationType
    {
        Width,
        Height
    }

    public class SgzSlidingDockPanel : DockPanel
    {

        #region Fields


        private RotateTransform _RotateTransform = new RotateTransform();

        #endregion Fields


        #region Properties

        [Description("Get or set the visibility of the button to play the animation"), Category("Appearance")]
        public bool ShowButton { get; set; } = true;


        [Description("Get or set the time in millisecond of the animation"), Category("Appearance")]
        public int AnimationDuration { get; set; } = 200;


        public SgzIcon OpenCloseBtn { get; set; }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Appearance")]
        public bool IsOpen
        {
            get { return (bool)GetValue(IsOpenProperty); }
            set { SetValue(IsOpenProperty, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Layout")]
        public double CloseSize
        {
            get { return (double)GetValue(CloseSizeProperty); }
            set { SetValue(CloseSizeProperty, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Layout")]
        public double OpenSize
        {
            get { return (double)GetValue(OpenSizeProperty); }
            set { SetValue(OpenSizeProperty, value); }
        }


        //TODO: use the horizontal / vertical alignment ?
        [Description(""), Category("Appearance")]
        public AnimationType AnimationType { get; set; } = AnimationType.Width;



        #endregion Properties


        #region Dependency Properties


        // DependencyProperty as the backing store for IsOpen
        public static readonly DependencyProperty IsOpenProperty = DependencyProperty.Register(
            "IsOpen",
            typeof(bool),
            typeof(SgzSlidingDockPanel),
            new PropertyMetadata(false, (d, e) => ((SgzSlidingDockPanel)d).PlayAnimation())
        );

        // DependencyProperty as the backing store for CloseSize
        public static readonly DependencyProperty CloseSizeProperty = DependencyProperty.Register(
            "CloseSize",
            typeof(double),
            typeof(SgzSlidingDockPanel),
            new PropertyMetadata(0d)
        );

        // DependencyProperty as the backing store for OpenSize
        public static readonly DependencyProperty OpenSizeProperty = DependencyProperty.Register(
            "OpenSize",
            typeof(double),
            typeof(SgzSlidingDockPanel),
            new PropertyMetadata(500d)
        );

        #endregion Dependency Properties


        #region Constructors


        public SgzSlidingDockPanel()
        {
            Loaded += SgzSlidingDockPanel_Loaded;
        }




        #endregion Constructors


        #region Methods


        private void SgzSlidingDockPanel_Loaded(object sender, RoutedEventArgs e)
        {
            //TODO: use minwidth maxwidth to define the two sizes ?

            if (ShowButton)
            {
                OpenCloseBtn = new SgzIcon();
                OpenCloseBtn.Icon = Geo.MdiArrowRight;
                OpenCloseBtn.Width = 30;
                OpenCloseBtn.Height = 30;
                OpenCloseBtn.Margin = new Thickness(0, 0, 10, 0);
                OpenCloseBtn.Padding = new Thickness(8);
                OpenCloseBtn.Foreground = new SolidColorBrush(Color.FromRgb(150, 150, 150));
                OpenCloseBtn.HoverBrush = new SolidColorBrush(Colors.White);
                OpenCloseBtn.PressedBrush = new SolidColorBrush(Colors.White);
                OpenCloseBtn.HorizontalAlignment = HorizontalAlignment.Right;
                OpenCloseBtn.VerticalAlignment = VerticalAlignment.Bottom;

                OpenCloseBtn.RenderTransform = _RotateTransform;
                OpenCloseBtn.RenderTransformOrigin = new Point(.5, .5);

                Children.Insert(0, OpenCloseBtn);
                SetDock(OpenCloseBtn, Dock.Bottom);

                OpenCloseBtn.Click += (s, ev) => IsOpen = !IsOpen;

            }

        }

        private void PlayAnimation()
        {
            DoubleAnimation sizeAnimation = new DoubleAnimation(IsOpen ? OpenSize : CloseSize, TimeSpan.FromMilliseconds(AnimationDuration));
            sizeAnimation.EasingFunction = new CircleEase() { EasingMode = EasingMode.EaseOut };
            BeginAnimation(AnimationType == AnimationType.Width ? WidthProperty : HeightProperty, sizeAnimation);

            if (AnimationType == AnimationType.Height)
                _RotateTransform.Angle = -90;

            DoubleAnimation rotateAnimation;
            if (IsOpen)
                rotateAnimation = new DoubleAnimation(0, -180, TimeSpan.FromMilliseconds(AnimationDuration));
            else
                rotateAnimation = new DoubleAnimation(-180, 0, TimeSpan.FromMilliseconds(AnimationDuration));

            _RotateTransform.BeginAnimation(RotateTransform.AngleProperty, rotateAnimation);
        }


        #endregion Methods

    }
}
