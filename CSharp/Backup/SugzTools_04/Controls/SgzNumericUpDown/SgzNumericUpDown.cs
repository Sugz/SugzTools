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
    public abstract class SgzNumericUpDown<T> : Control where T : struct, IComparable
    {

        #region Fields


        private TextBox PART_Textbox;                   // The Textbox part
        private Grid PART_UpDown;                       // The grid UpDown Part
        private Border PART_Increase;                   // The border Increase part
        private Border PART_Decrease;                   // The border Decrease part
        private DispatcherTimer _Timer;                 // The timer for the repeat buttons
        private Point _LastMousePos;                    // The mouse screen position
        private System.Drawing.Rectangle _Screen;       // The current screen bounds

        protected bool _Add = true;                     // Define wheter to increment or decrement
        protected int _Delay = 500;                     // The initial delay for the repeat buttons timer
        protected int _Interval = 33;                   // The interval for the for the repeat buttons timer
        protected T _DefaultValue;                      // The control default value
        protected T _Step;                              // The control step value use to increment or decrement the value
        protected T _MinValue;                          // The control minimum value
        protected T _MaxValue;                          // The control maximum value

        
        


        #endregion Fields



        #region Properties


        /// <summary>
        /// The initial delay for the repeat buttons timer
        /// </summary>
        [Description("The initial delay for the repeat buttons timer"), Category("Common"), DefaultValue(500)]
        public int Delay
        {
            get { return _Delay; }
            set { _Delay = value; }
        }



        /// <summary>
        /// The interval for the for the repeat buttons timer
        /// </summary>
        [Description("The interval for the for the repeat buttons timer"), Category("Common"), DefaultValue(33)]
        public int Interval
        {
            get { return _Interval; }
            set { _Interval = value; }
        }



        /// <summary>
        /// The control value
        /// </summary>
        [Description("The control value"), Category("Common")]
        public T Value
        {
            get { return (T)GetValue(ValueProperty); }
            set { SetValue(ValueProperty, value); }
        }



        /// <summary>
        /// The control default value
        /// </summary>
        [Description("The control default value"), Category("Common")]
        public T DefaultValue
        {
            get { return _DefaultValue; }
            set
            {
                _DefaultValue = value;
            }
        }



        /// <summary>
        /// The control step value use to increment or decrement the value
        /// </summary>
        [Description("The control step value use to increment or decrement the value"), Category("Common")]
        public T Step
        {
            get { return _Step; }
            set
            {
                _Step = value;
            }
        }



        /// <summary>
        /// The control minimum value
        /// </summary>
        [Description("The control minimum value"), Category("Common")]
        public T MinValue
        {
            get { return _MinValue; }
            set
            {
                _MinValue = value;

                if (value.CompareTo(MaxValue) < 0)
                    MaxValue = value;
            }
        }




        /// <summary>
        /// The control maximum value
        /// </summary>
        [Description("The control maximum value"), Category("Common")]
        public T MaxValue
        {
            get { return _MaxValue; }
            set
            {
                _MaxValue = value;

                if (value.CompareTo(MinValue) > 0)
                    MinValue = value;
            }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for Value
        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register(
            "Value",
            typeof(T),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(default(T), null, CoerceValue)
        );



        #endregion Dependency Properties



        #region Methods



        #region Override


        // Attach the control parts
        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            AttachToVisualTree();
        }


        #endregion Override



        #region Attachment


        private void AttachToVisualTree()
        {
            AttachTextBox();
            AttachUpDown();
            AttachIncrease();
            AttachDecrease();
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


        private void AttachIncrease()
        {
            Border increase = GetTemplateChild("PART_Increase") as Border;
            if (increase != null)
            {
                PART_Increase = increase;
                PART_Increase.MouseDown += (s, e) => IncreaseDecrease_MouseDown((Border)s, e, true);
            }
        }


        private void AttachDecrease()
        {
            Border decrease = GetTemplateChild("PART_Decrease") as Border;
            if (decrease != null)
            {
                PART_Decrease = decrease;
                PART_Decrease.MouseDown += (s, e) => IncreaseDecrease_MouseDown((Border)s, e, false);
            }
        }


        #endregion Attachment



        #region Coerce


        private static object CoerceValue(DependencyObject d, object baseValue)
        {
            T value = (T)baseValue;
            ((SgzNumericUpDown<T>)d).CoerceValueToBounds(ref value);

            return value;
        }


        #endregion Coerce Properties



        #region Private


        private void CoerceValueToBounds(ref T value)
        {
            if (value.CompareTo(MinValue) < 0)
                value = MinValue;
            else if (value.CompareTo(MaxValue) > 0)
                value = MaxValue;
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


        #endregion Private



        #region Public


        public virtual bool IsTextAllowed(string text)
        {
            Regex regex = new Regex("[^0-9.-]+"); //regex that matches disallowed text
            return !regex.IsMatch(text);
        }


        public abstract void IncrementDecrement(double multiplier = 1);


        #endregion Public



        #region Events



        #region Textbox


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


        #endregion Textbox



        #region UpDown


        private void PART_UpDown_MouseDown(object sender, MouseButtonEventArgs e)
        {
            // Switch the mouse capture to the grid
            PART_UpDown.CaptureMouse();

            // Get the current screen bounds
            if (e.LeftButton == MouseButtonState.Pressed)
                _Screen = Helpers.CurrentScreenBounds(this);

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
                if (yPos == _Screen.Top)
                    Helpers.SetMousePosition(xPos, _Screen.Bottom - 2);

                if (yPos == _Screen.Bottom - 1)
                    Helpers.SetMousePosition(xPos, _Screen.Top + 1);

                // Get the delta between the sored mouse position and the actual one, 
                double delta = PointToScreen(_LastMousePos).Y - yPos;
                if (Keyboard.IsKeyDown(Key.LeftCtrl))
                    delta *= 2;
                else if (Keyboard.IsKeyDown(Key.LeftAlt))
                    delta /= 2;

                // Avoid the screen wrapping
                if (delta > 250 || delta < -250)
                    delta = 1;

                // Set the new value and store the last mouse position
                IncrementDecrement(delta);
                _LastMousePos = pointToControl;
            }
        }


        private void IncreaseDecrease_MouseDown(Border border, MouseButtonEventArgs e, bool add)
        {
            Focus();
            border.Background = Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver");
            _LastMousePos = Mouse.GetPosition(this);
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



    public class SgzIntegerUpDown : SgzNumericUpDown<int>
    {

        #region Constructors


        static SgzIntegerUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzIntegerUpDown), new FrameworkPropertyMetadata(typeof(SgzIntegerUpDown)));
            ValueProperty.OverrideMetadata(typeof(SgzIntegerUpDown), new PropertyMetadata(0));
        }


        #endregion Constructors



        #region Overrides


        public override bool IsTextAllowed(string text)
        {
            Regex regex = new Regex("[^0-9-]+"); //regex that matches disallowed text
            return !regex.IsMatch(text);
        }


        public override void IncrementDecrement(double multiplier = 1)
        {
            if (_Add)
                Value += Step * (int)multiplier;
            else
                Value -= Step * (int)multiplier;
        }


        #endregion Overrides

    }

    public class SgzFloatUpDown : SgzNumericUpDown<float>
    {

        #region Constructors


        static SgzFloatUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzFloatUpDown), new FrameworkPropertyMetadata(typeof(SgzFloatUpDown)));
            ValueProperty.OverrideMetadata(typeof(SgzFloatUpDown), new PropertyMetadata(0f));
        }


        #endregion Constructors



        #region Overrides

        public override void IncrementDecrement(double multiplier = 1)
        {
            if (_Add)
                Value += Step * (float)multiplier;
            else
                Value -= Step * (float)multiplier;
        }


        #endregion Overrides

    }

    public class SgzDoubleUpDown : SgzNumericUpDown<double>
    {

        #region Constructors


        static SgzDoubleUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDoubleUpDown), new FrameworkPropertyMetadata(typeof(SgzDoubleUpDown)));
            ValueProperty.OverrideMetadata(typeof(SgzDoubleUpDown), new PropertyMetadata(0.0));
        }


        #endregion Constructors



        #region Overrides


        public override void IncrementDecrement(double multiplier = 1)
        {
            if (_Add)
                Value += Step * (float)multiplier;
            else
                Value -= Step * (float)multiplier;
        }


        #endregion Overrides

    }

}