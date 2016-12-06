using SugzTools.Src;
using System;
using System.ComponentModel;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;

namespace SugzTools.Controls
{
    [TemplatePart(Name = "PART_Textbox", Type = typeof(TextBox))]
    [TemplatePart(Name = "PART_UpDown", Type = typeof(Grid))]
    [TemplatePart(Name = "PART_Increase", Type = typeof(Border))]
    [TemplatePart(Name = "PART_Decrease", Type = typeof(Border))]
    public class SgzNumericUpDown : Control
    {

        #region Fields


        private DispatcherTimer _Timer;
        private int _Delay = 500;
        private int _Interval = 33;
        private Point _LastMousePos;
        private bool _Add = true;
        private decimal _Step = 1m;
        private decimal _DefaultValue = 0m;
        private int _ScreenTop;
        private int _ScreenBottom;
        private TextBox PART_Textbox;
        private Grid PART_UpDown;
        private Border PART_Increase;
        private Border PART_Decrease;


        #endregion Fields



        #region Properties


        /// <summary>
        /// The initial delay to start the repeat button timer
        /// </summary>
        [Description("The initial delay to start the repeatbuttons timer"), Category("Common"), DefaultValue(500)]
        public int Delay
        {
            get { return _Delay; }
            set { _Delay = value; }
        }


        /// <summary>
        /// The interval for the repeat button
        /// </summary>
        [Description("The interval for the repeatbuttons"), Category("Common"), DefaultValue(33)]
        public int Interval
        {
            get { return _Interval; }
            set { _Interval = value; }
        }


        /// <summary>
        /// The amount to increment the spinner value
        /// </summary>
        [Description("The amount to increment the spinner value"), Category("Common"), DefaultValue(1)]
        public decimal Step
        {
            get { return _Step; }
            set { _Step = value; }
        }


        /// <summary>
        /// The spinner value
        /// </summary>
        [Description("The spinner value"), Category("Common"), DefaultValue(0)]
        public decimal Value
        {
            get { return (decimal)GetValue(ValueProperty); }
            set { SetValue(ValueProperty, value); }
        }


        /// <summary>
        /// The spinner default value
        /// </summary>
        [Description("The spinner default value"), Category("Common"), DefaultValue(0)]
        public decimal DefaultValue
        {
            get { return _DefaultValue; }
            set { _DefaultValue = value; }
        }


        /// <summary>
        /// The textbox caret brush
        /// </summary>
        [Description("The textbox caret brush"), Category("Brush"), DefaultValue("MaxCaretBrush")]
        public Brush CaretBrush
        {
            get { return (Brush)GetValue(CaretBrushProperty); }
            set { SetValue(CaretBrushProperty, value); }
        }


        /// <summary>
        /// Hide the buttons when the mouse is not over the control
        /// </summary>
        [Description("Hide the buttons when the mouse is not over the control"), Category("Appearance"), DefaultValue("MaxCaretBrush")]
        public bool HideButtons
        {
            get { return (bool)GetValue(HideButtonsProperty); }
            set { SetValue(HideButtonsProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for CaretBrush
        public static readonly DependencyProperty CaretBrushProperty = DependencyProperty.Register(
            "CaretBrush",
            typeof(Brush),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxCaretBrush"))
        );


        // DependencyProperty as the backing store for HideButtons
        public static readonly DependencyProperty HideButtonsProperty = DependencyProperty.Register(
            "HideButtons",
            typeof(bool),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(false)
        );



        #region Value


        // DependencyProperty as the backing store for Value
        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register(
            "Value",
            typeof(decimal),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(0m, OnValueChanged, CoerceValue)
        );


        private static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {

        }

        private static object CoerceValue(DependencyObject d, object baseValue)
        {
            decimal value = (decimal)baseValue;
            return value;
        }


        #endregion Value



        #endregion Dependency Properties



        #region Constructors


        static SgzNumericUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzNumericUpDown), new FrameworkPropertyMetadata(typeof(SgzNumericUpDown)));
        }
        public SgzNumericUpDown()
        {

        }


        #endregion Constructors



        #region Methods



        #region Privates


        private static bool IsTextAllowed(string text)
        {
            Regex regex = new Regex("[^0-9.-]+"); //regex that matches disallowed text
            return !regex.IsMatch(text);
        }


        private void StartTimer()
        {
            if (_Timer == null)
            {
                _Timer = new DispatcherTimer();
                _Timer.Tick += OnTimerTick;
            }

            else if (_Timer.IsEnabled)
                return;

            _Timer.Interval = TimeSpan.FromMilliseconds(Delay);
            _Timer.Start();

            IncrementDecrement();
        }


        private void StopTimer()
        {
            if (_Timer != null)
                _Timer.Stop();
        }


        private void OnTimerTick(object sender, EventArgs e)
        {
            //int interval = Interval;
            TimeSpan timeSpan;
            if (Keyboard.IsKeyDown(Key.LeftCtrl))
                timeSpan = TimeSpan.FromMilliseconds(Interval / 2);
            else if (Keyboard.IsKeyDown(Key.LeftAlt))
                timeSpan = TimeSpan.FromMilliseconds(Interval * 2);
            else
                timeSpan = TimeSpan.FromMilliseconds(Interval);

            if (_Timer.Interval != timeSpan)
                _Timer.Interval = timeSpan;

            IncrementDecrement();
        }



        #endregion Privates



        #region Public


        public void IncrementDecrement(decimal multiplier = 1m)
        {
            if (_Add)
                Value += Step * multiplier;
            else Value -= Step * multiplier;
        }


        #endregion



        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            AttachToVisualTree();
        }


        #endregion Overrides



        #region Attachment


        private void AttachToVisualTree()
        {
            AttachTextBox();
            AttachUpDown();
            AttachIncreaseButton();
            AttachDecreaseButton();
        }


        private void AttachTextBox()
        {
            TextBox textBox = GetTemplateChild("PART_Textbox") as TextBox;
            if (textBox != null)
            {
                PART_Textbox = textBox;
                PART_Textbox.PreviewTextInput += _TextBox_PreviewTextInput;
                PART_Textbox.KeyDown += _TextBox_KeyDown;
            }
        }


        private void AttachUpDown()
        {
            Grid upDown = GetTemplateChild("PART_UpDown") as Grid;
            if (upDown != null)
            {
                PART_UpDown = upDown;
                PART_UpDown.MouseDown += PART_UpDown_MouseDown;
                PART_UpDown.MouseUp += PART_UpDown_MouseUp;
                PART_UpDown.MouseMove += PART_UpDown_MouseMove;
            }

        }


        private void AttachIncreaseButton()
        {
            Border increase = GetTemplateChild("PART_Increase") as Border;
            if (increase != null)
            {
                PART_Increase = increase;
                PART_Increase.MouseDown += (s, e) => IncreaseDecrease_MouseDown((Border)s, e, true);
            }
        }


        private void AttachDecreaseButton()
        {
            Border decrease = GetTemplateChild("PART_Decrease") as Border;
            if (decrease != null)
            {
                PART_Decrease = decrease;
                PART_Decrease.MouseDown += (s, e) => IncreaseDecrease_MouseDown((Border)s, e, false);
            }
        }



        #endregion Attachment



        #region Events


        #region TextBox


        private void _TextBox_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            // Only allow to type number value
            e.Handled = !IsTextAllowed(e.Text);

        }


        private void _TextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Return && e.Key == Key.Enter)
            {
                // Stop editing and set the focus to the parent
                Keyboard.ClearFocus();
                Helpers.RemoveFocus(this);
            }
        }


        #endregion TextBox



        #region UpDown


        private void PART_UpDown_MouseDown(object sender, MouseButtonEventArgs e)
        {
            // Switch the mouse capture to the grid
            PART_UpDown.CaptureMouse();

            // Get the current screen bounds
            if (e.LeftButton == MouseButtonState.Pressed)
            {
                _ScreenTop = Helpers.CurrentScreenBounds(this).Top;
                _ScreenBottom = Helpers.CurrentScreenBounds(this).Bottom;
            }

            // Reset the value on right click
            if (e.RightButton == MouseButtonState.Pressed)
                Value = DefaultValue;
        }


        private void PART_UpDown_MouseUp(object sender, MouseButtonEventArgs e)
        {
            // Release the mouse capture and revert all changed bakground
            PART_UpDown.ReleaseMouseCapture();
            PART_UpDown.Background = Background;
            PART_Increase.Background = new SolidColorBrush(Colors.Transparent);
            PART_Decrease.Background = new SolidColorBrush(Colors.Transparent);
            StopTimer();
        }


        private void PART_UpDown_MouseMove(object sender, MouseEventArgs e)
        {
            // Store the last mouse position just before it leaves the grid
            if (Helpers.IsMouseOver(PART_UpDown, e))
                _LastMousePos = Mouse.GetPosition(this);

            // Change the value accordingly to the mouse screen position, and allow the cursor to wrap the screen Y axis
            if (Mouse.Captured == PART_UpDown && !Helpers.IsMouseOver(PART_UpDown, e))
            {
                // Set add to true as the delta can be negative
                _Add = true;
                StopTimer();

                // Set the grid background
                PART_UpDown.Background = Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver");

                // Get the screen mouse position and the current screen bounds
                Point pointToControl = Mouse.GetPosition(this);
                int xPos = (int)PointToScreen(pointToControl).X;
                int yPos = (int)PointToScreen(pointToControl).Y;

                // Wrap the mouse around the screen Y axis and change delta accordingly
                if (yPos == _ScreenTop)
                    Helpers.SetMousePosition(xPos, _ScreenBottom - 2);

                if (yPos == _ScreenBottom - 1)
                    Helpers.SetMousePosition(xPos, _ScreenTop + 1);

                // Get the delta between the sored mouse position and the actual one, 
                decimal delta = (decimal)PointToScreen(_LastMousePos).Y - yPos;
                if (Keyboard.IsKeyDown(Key.LeftCtrl))
                    delta *= 2;
                else if (Keyboard.IsKeyDown(Key.LeftAlt))
                    delta /= 2;

                // Avoid the screen wrapping
                if (delta > 250m || delta < -250m)
                    delta = 1m;

                // Set the new value and store the last mouse position
                IncrementDecrement(delta);
                _LastMousePos = pointToControl;
            }
        }


        private void IncreaseDecrease_MouseDown(Border s, MouseButtonEventArgs e, bool add)
        {
            Focus();
            _LastMousePos = Mouse.GetPosition(this);
            s.Background = Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver");
            if (e.LeftButton == MouseButtonState.Pressed)
            {
                _Add = add;
                StartTimer();
            }
        }



        #endregion UpDown



        #endregion Events



        #endregion Methods


    }

}
