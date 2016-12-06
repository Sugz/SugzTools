using SugzTools.Src;
using System;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;

namespace SugzTools.Controls
{

    public class NumericUpDownEventArgs<T> : EventArgs
    {
        public T OldValue { get; set; }
        public T NewValue { get; set; }

        public NumericUpDownEventArgs(T oldValue, T newValue)
        {
            OldValue = oldValue;
            NewValue = newValue;
        }
    }



    [TemplatePart(Name = "PART_Textbox", Type = typeof(TextBox))]
    [TemplatePart(Name = "PART_UpDown", Type = typeof(Grid))]
    [TemplatePart(Name = "PART_Increase", Type = typeof(Border))]
    [TemplatePart(Name = "PART_Decrease", Type = typeof(Border))]
    public abstract class SgzNumericUpDown<T> : UserControl where T : struct, IComparable, IFormattable
    {

        //TODO: truncate / round the value to get what the control is displaying (as an option)
        //TODO: change the step accordingly to the control value


        #region Fields


        private TextBox PART_Textbox;                                                           // The Textbox part
        private Grid PART_UpDown;                                                               // The grid UpDown Part
        private Border PART_Increase;                                                           // The border Increase part
        private Border PART_Decrease;                                                           // The border Decrease part
        private DispatcherTimer _Timer;                                                         // The timer for the repeat buttons
        private Point _LastMousePos;                                                            // The mouse screen position
        private System.Drawing.Rectangle _Screen;                                               // The current screen bounds
        private bool mouseIsMoving = false;                                                     // Register the mouse as moving 

        protected bool _Add = true;                                                             // Define wheter to increment or decrement
        protected int _Delay = 500;                                                             // The initial delay for the repeat buttons timer
        protected int _Interval = 33;                                                           // The interval for the for the repeat buttons timer
        protected T _DefaultValue;                                                              // The control default value
        protected int _DisplayedValueMultiplier = 1;                                            // Get / Set the multiplier used to show the value in the input field
        protected T _Step;                                                                      // The control step value use to increment or decrement the value
        protected T _DefaultStep;                                                               // The control step value set when the control is created
        protected T _MinValue;                                                                  // The control minimum value
        protected T _MaxValue;                                                                  // The control maximum value
        protected int _Decimals = 0;                                                            // The value number of decimal
        protected int _MinDecimals = 0;                                                         // The control minimum number of decimal
        protected int _MaxDecimals = 0;                                                         // The control maximum number of decimal
        protected NumericFormatSpecifier _NumericFormatSpecifier = NumericFormatSpecifier.F;    // The control numeric format specifier
        protected Regex _AllowedChars = new Regex("[^0-9-]+");                                  // Regex that matches allowed text
        protected string _DecimalSeparator = 
            CultureInfo.CurrentCulture.NumberFormat.NumberDecimalSeparator;                     // The current system decimal separator
        protected string _Unit = "";                                                            // The unit to be display
        protected bool _AlwaysShowValue = false;                                                // Force the control to display the default value is the value is null;
        protected bool _StepAccelerator = true;                                                   // Get / Set if the step is increasing or decreasing considering the current value

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
                CoerceValueToBounds(_DefaultValue);
            }
        }



        /// <summary>
        /// Get / Set the multiplier used to show the value in the input field
        /// </summary>
        [Description("The multiplier used to show the value in the input field"), Category("Common")]
        public int DisplayedValueMultiplier
        {
            get { return _DisplayedValueMultiplier; }
            set { _DisplayedValueMultiplier = value; }
        }



        /// <summary>
        /// The control step value use to increment or decrement the value
        /// </summary>
        [Description("The control step value use to increment or decrement the value"), Category("Common")]
        public T Step
        {
            get { return _Step; }
            set { _Step = value; }
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

                if (MinValue.CompareTo(MaxValue) > 0)
                    MaxValue = MinValue;

                CoerceValueToBounds(Value);
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

                if (MaxValue.CompareTo(MinValue) < 0)
                    MinValue = MaxValue;

                CoerceValueToBounds(Value);
            }
        }



        /// <summary>
        /// The control number of decimal
        /// </summary>
        [Description("The control number of decimal"), Category("Common")]
        public int Decimals
        {
            get { return _Decimals; }
            set
            {
                if (value < MinDecimals)
                    _Decimals = MinDecimals;

                else if (value > MaxDecimals)
                    _Decimals = MaxDecimals;

                else _Decimals = value;
            }
        }



        /// <summary>
        /// The control minimum number of decimal
        /// </summary>
        [Description("The control minimum number of decimal"), Category("Common")]
        public int MinDecimals
        {
            get { return _MinDecimals; }
            set
            {
                if (value > MaxDecimals)
                    _MinDecimals = MaxDecimals;

                else if (value < 0)
                    _MinDecimals = 0;

                else _MinDecimals = value;

                if (Decimals < MinDecimals)
                    Decimals = MinDecimals;

            }
        }



        /// <summary>
        /// The control maximum number of decimal
        /// </summary>
        [Browsable(false)]
        public int MaxDecimals { get { return _MaxDecimals; } }
        //{
        //    get { return _MaxDecimals; }
        //    set
        //    {
        //        if (value < MinDecimals)
        //            _MaxDecimals = MinDecimals;

        //        else _MaxDecimals = value;

        //        if (Decimals > MaxDecimals)
        //            Decimals = MaxDecimals;
        //    }
        //}



        /// <summary>
        /// The control numeric format specifier
        /// </summary>
        [Description("The control numeric format specifier"), Category("Common")]
        public NumericFormatSpecifier NumericFormatSpecifier
        {
            get { return _NumericFormatSpecifier; }
            set { _NumericFormatSpecifier = value; }
        }



        /// <summary>
        /// Regex that define allowed characters in the textbox
        /// </summary>
        [Browsable(false)]
        public Regex AllowedChars { get { return _AllowedChars; } }



        /// <summary>
        /// Array that define MiValue, MaxValue and Value
        /// </summary>
        [Browsable(false)]
        public T[] Range
        {
            get
            {
                T[] arr = { MinValue, MaxValue, Value };
                return arr;
            }
            set
            {
                MinValue = value[0];
                MaxValue = value[1];
                Value = value[2];
            }
        }



        /// <summary>
        /// The unit to be display
        /// </summary>
        [Description("The unit to be display"), Category("Common")]
        public string Unit
        {
            get { return _Unit; }
            set { _Unit = value; }
        }



        /// <summary>
        /// Force the control to display the default value is the value is null;
        /// </summary>
        [Description("Force the control to display the default value is the value is null;"), Category("Common")]
        public bool AlwaysShowValue
        {
            get { return _AlwaysShowValue; }
            set { _AlwaysShowValue = value; }
        }



        /// <summary>
        /// Define the width of the InputField
        /// </summary>
        [Description("Define the width of the InputField"), Category("Layout")]
        public int FieldWidth
        {
            get { return (int)GetValue(FieldWidthProperty); }
            set { SetValue(FieldWidthProperty, value); }
        }



        /// <summary>
        /// Define if the repeat buttons should be hidden when the mouse isn't over
        /// </summary>
        [Description("Define if the repeat buttons should be hidden when the mouse isn't over"), Category("Appearance")]
        public bool HideButtons
        {
            get { return (bool)GetValue(HideButtonsProperty); }
            set { SetValue(HideButtonsProperty, value); }
        }



        /// <summary>
        /// Get / Set if the step is increasing or decreasing considering the current value
        /// </summary>
        [Description("Get / Set if the step is increasing or decreasing considering the current value"), Category("Common")]
        public bool StepAccelerator
        {
            get { return _StepAccelerator; }
            set { _StepAccelerator = value; }
        }



        /// <summary>
        /// The control caret brush
        /// </summary>
        [Description("The control caret brush"), Category("Brush")]
        public Brush CaretBrush
        {
            get { return (Brush)GetValue(CaretBrushProperty); }
            set { SetValue(CaretBrushProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for Value
        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register(
            "Value",
            typeof(T),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(default(T), OnValueChanged, CoerceValue)
        );


        // DependencyProperty as the backing store for FieldWidth
        public static readonly DependencyProperty FieldWidthProperty = DependencyProperty.Register(
            "FieldWidth",
            typeof(int),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(65)
        );


        // DependencyProperty as the backing store for HideButtons
        public static readonly DependencyProperty HideButtonsProperty = DependencyProperty.Register(
            "HideButtons",
            typeof(bool),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for CaretBrush
        public static readonly DependencyProperty CaretBrushProperty = DependencyProperty.Register(
            "CaretBrush",
            typeof(Brush),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxCaretBrush"))
        );


        #endregion Dependency Properties



        #region Published Events


        public event EventHandler<NumericUpDownEventArgs<T>> ValueChanged;


        #endregion Published Events



        #region Constructor


        public SgzNumericUpDown()
        {
            Loaded += (s, e) => 
            {
                if (AlwaysShowValue)
                    //SetTextboxText(Value);
                    SetTextboxText();

                if (StepAccelerator)
                {
                    _DefaultStep = Step;
                    SetStep();
                }
            };
        }


        #endregion Constructor



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
                PART_Textbox.PreviewTextInput += PART_TextBox_PreviewTextInput;
                PART_Textbox.KeyDown += PART_TextBox_KeyDown;
                PART_Textbox.LostFocus += PART_Textbox_LostFocus;
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



        #region Private


        private T CoerceValueToBounds(T value)
        {
            if (value.CompareTo(MinValue) < 0)
                value = MinValue;
            else if (value.CompareTo(MaxValue) > 0)
                value = MaxValue;

            return value;
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
                timeSpan = TimeSpan.FromMilliseconds(Interval * 0.1);
            else if (Keyboard.IsKeyDown(Key.LeftAlt))
                timeSpan = TimeSpan.FromMilliseconds(Interval * 10);
            else
                timeSpan = TimeSpan.FromMilliseconds(Interval);

            if (_Timer.Interval != timeSpan)
                _Timer.Interval = timeSpan;

            IncrementDecrement();
        }


        private void SetTextboxText()
        {
            if (PART_Textbox != null)
            {
                // Get the good amount of decimals
                int decimals = GetDecimalsCount((Value).ToString());
                decimals = decimals > MinDecimals ? decimals : MinDecimals;
                decimals = decimals < Decimals ? decimals : Decimals;

                PART_Textbox.Text = Value.ToString(NumericFormatSpecifier.ToString() + decimals.ToString(), CultureInfo.CurrentCulture) + Unit;
            }
        }


        private int GetDecimalsCount(string str)
        {
            return str.SkipWhile(c => c != Convert.ToChar(_DecimalSeparator)).Skip(1).Count();
        }


        private void SetStep()
        {
            Step = TMath.Add<T>(TMath.Divide<T, int, T>(TMath.Abs(Value), 100), _DefaultStep);
        }



        #region Value


        private static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            SgzNumericUpDown<T> control = d as SgzNumericUpDown<T>;
            control.SetTextboxText();
            control.ValueChanged?.Invoke(control, new NumericUpDownEventArgs<T>((T)e.OldValue, (T)e.NewValue));
        }


        private static object CoerceValue(DependencyObject d, object baseValue)
        {
            SgzNumericUpDown<T> control = d as SgzNumericUpDown<T>;
            T value = control.CoerceValueToBounds((T)baseValue);
            return control.RoundValue(value);
        }


        #endregion Value



        #endregion Private



        #region Protected

        protected abstract void IncrementDecrement(double multiplier = 1);
        protected abstract T ToDisplayedValue();
        protected abstract T FromDisplayedValue();

        //private void IncrementDecrement(double multiplier = 1)
        //{
        //    T increment = TMath.Multiply(Step, (T)Convert.ChangeType(multiplier, typeof(T)));
        //    double value = (double)Convert.ChangeType(Value, typeof(double));
        //    if (_Add)
        //        Value = (TMath.Add<double, T>(value, increment)) > MaxValue) ? MaxValue : TMath.Add<T>(Value, increment);
        //    else
        //        Value = (value - increment < MinValue) ? MinValue : TMath.Add(Value, increment);
        //}
        
        //private T ToDisplayedValue()
        //{

        //}
        //private T FromDisplayedValue()
        //{

        //}

        protected virtual T RoundValue(T value)
        {
            return value;
        }

        


        #endregion Protected



        #region Events Handlers



        #region Textbox


        private void PART_TextBox_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = _AllowedChars.IsMatch(e.Text);
        }


        private void PART_TextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Return && e.Key == Key.Enter)
            {
                // Stop editing and set the focus to the parent
                Keyboard.ClearFocus();
                Helpers.RemoveFocus(this);
            }
        }


        private void PART_Textbox_LostFocus(object sender, RoutedEventArgs e)
        {
            // Convert the Textbox Text back to T Value
            if (PART_Textbox.Text != string.Empty)
                Value = (T)Convert.ChangeType(PART_Textbox.Text.TrimEnd(Unit.ToCharArray()), typeof(T));
            else if (AlwaysShowValue)
                Value = DefaultValue;
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
            Cursor = Cursors.Arrow;
            mouseIsMoving = false;
            PART_UpDown.ReleaseMouseCapture();
            PART_UpDown.Background = Background;
            PART_Increase.Background = new SolidColorBrush(Colors.Transparent);
            PART_Decrease.Background = new SolidColorBrush(Colors.Transparent);
            StopTimer();

            // Set the step accelerator
            if (StepAccelerator)
                SetStep();
        }


        private void PART_UpDown_MouseMove(object sender, MouseEventArgs e)
        {
            // Store the last mouse position just before it leaves the grid
            if (Helpers.IsMouseOver(PART_UpDown, e) && !mouseIsMoving)
                _LastMousePos = Mouse.GetPosition(this);

            // Change the value accordingly to the mouse screen position, and allow the cursor to wrap the screen Y axis
            if (mouseIsMoving || (Mouse.Captured == PART_UpDown && !Helpers.IsMouseOver(PART_UpDown, e)))
            {
                Cursor = Cursors.SizeNS;
                mouseIsMoving = true;
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
                    delta *= 10;
                else if (Keyboard.IsKeyDown(Key.LeftAlt))
                    delta *= 0.1;

                // Avoid the screen wrapping
                if (delta > 250 || delta < -250)
                    delta = 1;

                // Set the new value and store the last mouse position
                _Add = delta >= 0 ? true : false; 
                IncrementDecrement(Math.Abs(delta));
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



        #endregion Events Handlers



        #endregion Methods
    }





    public class SgzIntUpDown : SgzNumericUpDown<int>
    {

        #region Constructors


        static SgzIntUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzIntUpDown), new FrameworkPropertyMetadata(typeof(SgzIntUpDown)));
        }
        public SgzIntUpDown()
        {
            Step = 1;
            MinValue = int.MinValue + 1;
            MaxValue = int.MaxValue - 1;
        }

        

        #endregion Constructors


        #region Overrides


        protected override void IncrementDecrement(double multiplier = 1)
        {
            int increment = Step * (int)multiplier;
            if (_Add)
                Value = ((double)Value + increment > MaxValue) ? MaxValue : Value + increment;
            else
                Value = ((double)Value - increment < MinValue) ? MinValue : Value - increment;

        }

        //protected override void SetStep()
        //{
        //    Step = (Math.Abs(Value) / 100) + _DefaultStep;
        //}

        //protected override int ToDisplayedValue()
        //{
        //    return Value * DisplayedValueMultiplier;
        //}

        //protected override int FromDisplayedValue()
        {
            return Value / DisplayedValueMultiplier;
        }

        #endregion Overrides

    }

    public class SgzLongUpDown : SgzNumericUpDown<long>
    {

        #region Constructors


        static SgzLongUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzLongUpDown), new FrameworkPropertyMetadata(typeof(SgzLongUpDown)));
        }
        public SgzLongUpDown()
        {
            Step = 1;
            MinValue = long.MinValue + 1;
            MaxValue = long.MaxValue - 1;
        }


        #endregion Constructors


        #region Overrides


        protected override void IncrementDecrement(double multiplier = 1)
        {
            long increment = Step * (long)multiplier;
            if (_Add)
                Value = ((double)Value + increment > MaxValue) ? MaxValue : Value + increment;
            else
                Value = ((double)Value - increment < MinValue) ? MinValue : Value - increment;
        }

        //protected override void SetStep()
        //{
        //    Step = (Math.Abs(Value) / 100) + _DefaultStep;
        //}

        //protected override long ToDisplayedValue()
        //{
        //    return Value * DisplayedValueMultiplier;
        //}

        //protected override long FromDisplayedValue()
        {
            return Value / DisplayedValueMultiplier;
        }


        #endregion Overrides

    }

    public class SgzFloatUpDown : SgzNumericUpDown<float>
    {

        #region Constructors


        static SgzFloatUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzFloatUpDown), new FrameworkPropertyMetadata(typeof(SgzFloatUpDown)));
        }
        public SgzFloatUpDown()
        {
            _AllowedChars = new Regex("[^0-9" + _DecimalSeparator + "-]+");
            _MaxDecimals = 7;

            Step = 0.1f;
            MinValue = float.MinValue + 1;
            MaxValue = float.MaxValue + 1;
        }


        #endregion Constructors


        #region Overrides


        protected override void IncrementDecrement(double multiplier = 1)
        {
            Value += _Add ? Step * (float)multiplier : -(Step * (float)multiplier);
        }

        //protected override void SetStep()
        //{
        //    Step = (Math.Abs(Value) / 100) + _DefaultStep;
        //}

        protected override float RoundValue(float value)
        {
            return (float)Math.Round(value, Decimals);
        }

        //protected override float ToDisplayedValue()
        //{
        //    return Value * DisplayedValueMultiplier;
        //}

        //protected override float FromDisplayedValue()
        {
            return Value / DisplayedValueMultiplier;
        }


        #endregion Overrides

    }

    public class SgzDoubleUpDown : SgzNumericUpDown<double>
    {

        #region Constructors


        static SgzDoubleUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDoubleUpDown), new FrameworkPropertyMetadata(typeof(SgzDoubleUpDown)));
        }
        public SgzDoubleUpDown()
        {
            _AllowedChars = new Regex("[^0-9" + _DecimalSeparator + "-]+");
            _MaxDecimals = 15;

            Step = 0.1d;
            MinValue = double.MinValue + 1;
            MaxValue = double.MaxValue - 1;
            
        }


        #endregion Constructors


        #region Overrides


        protected override void IncrementDecrement(double multiplier = 1)
        {
            Value += _Add ? Step * (float)multiplier : -(Step * (float)multiplier);
        }

        //protected override void SetStep()
        //{
        //    Step = (Math.Abs(Value) / 100) + _DefaultStep;
        //}

        protected override double RoundValue(double value)
        {
            return Math.Round(value, Decimals);
        }

        protected override double ToDisplayedValue()
        {
            return Value * DisplayedValueMultiplier;
        }

        protected override double FromDisplayedValue()
        {
            return Value / DisplayedValueMultiplier;
        }


        #endregion Overrides

    }

}

