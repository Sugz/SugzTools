using SugzTools.Max;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
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
    public class SgzNumericUpDown : UserControl
    {
        //TODO: POINT3 value and range property

        #region Fields

        // Template Parts
        protected TextBox PART_Textbox;
        private Grid PART_UpDown;
        private Border PART_Increase;
        private Border PART_Decrease;

        // Mouse moving 
        private System.Drawing.Rectangle _Screen;                           // The current screen bounds
        protected bool _IsMouseMoving = false;                              // Register the mouse as moving 
        private Point _LastMousePos;                                        // The mouse screen position

        // Repeat buttons timer
        private DispatcherTimer _Timer;                                     // The timer for the repeat buttons
        private int _Delay = 500;                                           // The initial delay for the repeat buttons timer
        private int _Interval = 33;                                         // The interval for the for the repeat buttons timer

        // Value
        //private Point3 _Range;
        private bool _Increase;                                             // Define whether to increment or decrement value
        private double _DefaultScale;                                       // The control Scale value set when the control is created
        private NumericUpDownLimits _Limits = NumericUpDownLimits.Float;    // Get or set the control's manimum and maximum values based on the type
        private double _MinValue = float.MinValue;                          // The control's minimum value
        private double _MaxValue = float.MaxValue;                          // The control's maximum value
        private double _Scale;

        // Decimals
        private int _Decimals = 2;                                          //The control's decimals number
        private int _MinDecimals = 1;                                       //The control minimum number of decimal
        private const int _MaxDecimals = 15;                                //The control maximum number of decimal

        // Value Formating
        private bool _Indeterminate = false;
        private Regex _AllowedChars = new Regex($"[^0-9-]+");               // Regex that matches allowed text
        private NumericFormatSpecifier _NumericFormatSpecifier;             // The control numeric format specifier
        private string _DecimalSeparator;                                   // The current system decimal separator


        #endregion Fields



        #region Properties


        #region Value Properties


        /// <summary>
        /// Get or set the control's type (Integer, Float or WorldUnits), default to Float
        /// </summary>
        [Description("Get or set the control's type (Integer, Float or WorldUnits), default to Float"), Category("Value")]
        public NumericUpDownType Type { get; set; }


        /// <summary>
        /// Get or set the control's value
        /// </summary>
        [Description("Get or set the control's value"), Category("Value")]
        public object Value
        {
            get { return GetTypedValue(InternalValue); }
            set
            {
                InternalValue = CoerceValueToBounds(Convert.ToDouble(value));
                Indeterminate = false;
            }
        }


        /// <summary>
        /// Get the internal value which is the value used for internal calculs
        /// </summary>
        public double InternalValue
        {
            get { return (double)GetValue(InternalValueProperty); }
            protected set { SetValue(InternalValueProperty, value); }
        }


        /// <summary>
        /// Get or set he control's default value
        /// </summary>
        [Description("Get or set he control's default value"), Category("Value")]
        public double DefaultValue { get; set; }


        /// <summary>
        /// Get or set the control's manimum and maximum values based on the type
        /// </summary>
        [Description("Get or set the control's manimum and maximum values based on the type"), Category("Value")]
        public NumericUpDownLimits Limits
        {
            get { return _Limits; }
            set
            {
                _Limits = value;
                switch (value)
                {
                    case NumericUpDownLimits.Int:
                        MinValue = int.MinValue;
                        MaxValue = int.MaxValue;
                        break;
                    case NumericUpDownLimits.Long:
                        MinValue = long.MinValue;
                        MaxValue = long.MaxValue;
                        break;
                    case NumericUpDownLimits.Double:
                        MinValue = double.MinValue;
                        MaxValue = double.MaxValue;
                        break;
                    case NumericUpDownLimits.Float:
                    default:
                        MinValue = float.MinValue;
                        MaxValue = float.MaxValue;
                        break;
                }
            }
        }


        /// <summary>
        /// Get or set the control's minimum value
        /// </summary>
        [Description("Get or set the control's minimum value"), Category("Value")]
        public double MinValue
        {
            get { return _MinValue; }
            set
            {
                _MinValue = value;

                if (value > MaxValue)
                    MaxValue = value;

                CoerceValueToBounds(InternalValue);
            }
        }


        /// <summary>
        /// Get or set the control's maximum value
        /// </summary>
        [Description("Get or set the control's maximum value"), Category("Value")]
        public double MaxValue
        {
            get { return _MaxValue; }
            set
            {
                _MaxValue = value;

                if (value < MinValue)
                    MinValue = value;

                CoerceValueToBounds(InternalValue);
            }
        }


        #endregion Value Properties


        #region Scale Properties


        /// <summary>
        /// Get or set the control's value used to increment or decrement
        /// </summary>
        [Description("Get or set the control's value used to increment or decrement"), Category("Scale")]
        public double Scale
        {
            get { return _Scale; }
            set
            {
                _Scale = value;
                _DefaultScale = _Scale;
            }
        }



        /// <summary>
        /// Get or set if the Scale is increasing or decreasing considering the current value
        /// </summary>
        [Description("Get or set if the Scale is increasing or decreasing considering the current value"), Category("Scale")]
        public bool ScaleAccelerator { get; set; }


        #endregion Scale Properties


        #region Decimals Properties


        /// <summary>
        /// Get or set the control's decimals number
        /// </summary>
        [Description("Get or set the control's decimals number"), Category("Decimals")]
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
        /// Get or set the control's minimum decimals number
        /// </summary>
        [Description("Get or set the control's minimum decimals number"), Category("Decimals")]
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
        /// Get the control's maximum decimals number
        /// </summary>
        public int MaxDecimals { get { return _MaxDecimals; } }


        #endregion Decimals Properties


        #region Value Formating Properties


        /// <summary>
        /// Force the control to always display the value, except when indetermiante is true
        /// </summary>
        [Description("Force the control to always display the value, except when indetermiante is true"), Category("Value Formating")]
        public bool AlwaysShowValue { get; set; }


        /// <summary>
        /// Get or set the inderterminate state.
        /// True set the edit field to be blank, false set the value back.
        /// The control's value is unchanged and remains accessible.
        /// Setting a value sets indeterminate to false
        /// </summary>
        [Description("Get or set the inderterminate state.\nTrue set the edit field to be blank, false set the value back.\nThe control's value is unchanged and remains accessible.\nSetting a value sets indeterminate to false"), Category("Value Formating")]
        public bool Indeterminate
        {
            get { return _Indeterminate; }
            set
            {
                _Indeterminate = value;
                if (value)
                    PART_Textbox.Text = "";
                else
                    SetTextboxText();
            }
        }


        /// <summary>
        /// Get or set he control's numeric format specifier
        /// </summary>
        [Description("The control numeric format specifier"), Category("Value Formating")]
        public NumericFormatSpecifier NumericFormatSpecifier
        {
            get { return _NumericFormatSpecifier; }
            set { _NumericFormatSpecifier = value; }
        }


        #endregion Value Formating Properties


        #region Timer Properties


        /// <summary>
        ///  Get or set the initial delay for the repeat buttons timer
        /// </summary>
        [Description("Get or set the initial delay for the repeat buttons' timer"), Category("Repeat Buttons Timer")]
        public int Delay
        {
            get { return _Delay; }
            set { _Delay = value; }
        }


        /// <summary>
        /// Get or set the interval for the for the repeat buttons' timer
        /// </summary>
        [Description("Get or set the interval for the for the repeat buttons' timer"), Category("Repeat Buttons Timer")]
        public int Interval
        {
            get { return _Interval; }
            set { _Interval = value; }
        }


        #endregion Timer Properties


        #region Appearance Properties


        /// <summary>
        /// Get or set the visibility or the repeat buttons when the mouse isn't over the control
        /// </summary>
        [Description("Get or set the visibility or the repeat buttons when the mouse isn't over the control"), Category("Appearance")]
        public bool HideButtons
        {
            get { return (bool)GetValue(HideButtonsProperty); }
            set { SetValue(HideButtonsProperty, value); }
        }


        /// <summary>
        /// Get or set the control's caret brush
        /// </summary>
        [Description("Get or set the control's caret brush"), Category("Brush")]
        public Brush CaretBrush
        {
            get { return (Brush)GetValue(CaretBrushProperty); }
            set { SetValue(CaretBrushProperty, value); }
        }


        /// <summary>
        /// Get or set the textbox's selection brush
        /// </summary>
        [Description("Get or set the textbox selection brush"), Category("Brush")]
        public Brush SelectionBrush
        {
            get { return (Brush)GetValue(SelectionBrushProperty); }
            set { SetValue(SelectionBrushProperty, value); }
        }


        /// <summary>
        /// Get or set the radius of the control's corner
        /// </summary>
        [Description("Get or set the radius of the control's corner"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }


        /// <summary>
        /// Get or set thethe width of the input field
        /// </summary>
        [Description("Get or set thethe width of the input field"), Category("Layout")]
        public int FieldWidth
        {
            get { return (int)GetValue(FieldWidthProperty); }
            set { SetValue(FieldWidthProperty, value); }
        }


        #endregion Appearance Properties


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for InternalValue
        public static readonly DependencyProperty InternalValueProperty = DependencyProperty.Register(
            "InternalValue",
            typeof(double),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(0d, InternalValueChanged, CoerceInternalValue)
        );


        // DependencyProperty as the backing store for HideButtons
        public static readonly DependencyProperty HideButtonsProperty = DependencyProperty.Register(
            "HideButtons",
            typeof(bool),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for CaretBrush
        public static readonly DependencyProperty CaretBrushProperty = DependencyProperty.Register(
            "CaretBrush",
            typeof(Brush),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxCaretBrush"))
        );


        // DependencyProperty as the backing store for SelectionBrush
        public static readonly DependencyProperty SelectionBrushProperty = DependencyProperty.Register(
            "SelectionBrush",
            typeof(Brush),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(0)
        );


        // DependencyProperty as the backing store for FieldWidth
        public static readonly DependencyProperty FieldWidthProperty = DependencyProperty.Register(
            "FieldWidth",
            typeof(int),
            typeof(SgzNumericUpDown),
            new PropertyMetadata(100)
        );



        #endregion Dependency Properties



        #region Published Events


        public event EventHandler<SgzNumericUpDownEventArgs> ValueChanged;
        public event EventHandler<SgzNumericUpDownEventArgs> Validate;


        #endregion Published Events



        #region Constructor


        static SgzNumericUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzNumericUpDown), new FrameworkPropertyMetadata(typeof(SgzNumericUpDown)));
        }
        public SgzNumericUpDown()
        {
            Value = 0;
            Scale = 0.1;
            ScaleAccelerator = true;
            DefaultValue = InternalValue;
            AlwaysShowValue = true;
            _NumericFormatSpecifier = NumericFormatSpecifier.F;
            _DecimalSeparator = CultureInfo.CurrentCulture.NumberFormat.NumberDecimalSeparator;

            Loaded += (s, e) =>
            {
                // Make the required changes if the spinner if integer type
                if (Type == NumericUpDownType.Integer)
                {
                    Value = Math.Round(Convert.ToDouble(Value), 0);
                    DefaultValue = Math.Round(Convert.ToDouble(DefaultValue), 0);
                    Scale = Scale < 1 ? 1 : Math.Round(Convert.ToDouble(Scale), 0);
                    MinDecimals = 0;
                    Decimals = 0;
                }

                if (AlwaysShowValue && !Indeterminate)
                    SetTextboxText();

            };
        }


        #endregion Constructor



        #region Methods


        #region Attachment

        // Attach the control parts
        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();
            AttachToVisualTree();
        }


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


        #region Return Value Convertion


        private ValueType GetTypedValue(double value)
        {
            int _int;
            long _long;
            float _float;
            if (TryConvertToInt(value, out _int))
                return _int;
            if (TryConvertToLong(value, out _long))
                return _long;
            if (TryConvertToFloat(value, out _float))
                return _float;

            return InternalValue;
        }

        private bool TryConvertToInt(double value, out int result)
        {
            const double Min = int.MinValue - 0.5;
            const double Max = int.MaxValue + 0.5;

            // Notes:
            // 1. double.IsNaN is needed for exclusion purposes because NaN compares
            //    false for <, >=, etc. for every value (including itself).
            // 2. value < Min is correct because -2147483648.5 rounds to int.MinValue.
            // 3. value >= Max is correct because 2147483648.5 rounds to int.MaxValue + 1.
            if (Type != NumericUpDownType.Integer || double.IsNaN(value) || value < Min || value >= Max)
            {
                result = 0;
                return false;
            }

            //result = (int)Math.Floor(Math.Round(value, 1));
            result = (int)Math.Floor(value);
            return true;
        }

        private bool TryConvertToLong(double value, out long result)
        {
            const double Min = long.MinValue - 0.5;
            const double Max = long.MaxValue + 0.5;

            if (Type != NumericUpDownType.Integer || double.IsNaN(value) || value < Min || value >= Max)
            {
                result = 0;
                return false;
            }

            //result = (long)Math.Floor(Math.Round(value, 1));
            result = (long)Math.Floor(value);
            return true;
        }

        private bool TryConvertToFloat(double value, out float result)
        {
            const double Min = float.MinValue - 0.5;
            const double Max = float.MaxValue + 0.5;

            if (double.IsNaN(value) || value < Min || value >= Max)
            {
                result = 0;
                return false;
            }

            result = Convert.ToSingle(value);
            return true;
        }


        #endregion Return Value Convertion


        #region InternalValue


        /// <summary>
        /// Restrict the given value to be inside MinValue and MaxValue
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        private double CoerceValueToBounds(double value)
        {
            if (value < MinValue)
                value = MinValue;
            else if (value > MaxValue)
                value = MaxValue;

            return value;
        }


        /// <summary>
        /// Set the scale to be a percentage of the DisplayedValue
        /// </summary>
        private double GetScaleAccelerator()
        {
            if (Scale == _DefaultScale)
            {
                double scale = (Math.Abs(InternalValue) / 500) + Scale;
                return (Type == NumericUpDownType.Integer ? Math.Floor(scale) : Math.Round(Scale, GetDecimalsCount(_DefaultScale)));
            }
            return Scale;
        }


        /// <summary>
        /// Increment or Decrement DisplayedValue
        /// </summary>
        /// <param name="multiplier"></param>
        private void IncrementDecrement(double multiplier = 1)
        {
            // Keyboard multiplier
            if (Keyboard.IsKeyDown(Key.LeftCtrl))
                multiplier *= 10;
            else if (Keyboard.IsKeyDown(Key.LeftAlt))
                multiplier *= 0.1;

            double increment = Math.Round(Scale, GetDecimalsCount(_DefaultScale)) * multiplier;
            InternalValue = _Increase ? (InternalValue + increment) : (InternalValue - increment);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="d"></param>
        /// <param name="baseValue"></param>
        /// <returns></returns>
        private static object CoerceInternalValue(DependencyObject d, object baseValue)
        {
            SgzNumericUpDown control = d as SgzNumericUpDown;
            double value = control.CoerceValueToBounds((double)baseValue);

            return value;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="d"></param>
        /// <param name="e"></param>
        private static void InternalValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            SgzNumericUpDown control = d as SgzNumericUpDown;

            // If type is integer, only invoke the event if both floored oldvalue and newvalue are different
            if (control.Type == NumericUpDownType.Integer && Math.Floor((double)e.OldValue) == Math.Floor((double)e.NewValue))
                return;

            control.ValueChanged?.Invoke(control, new SgzNumericUpDownEventArgs(control.GetTypedValue((double)e.OldValue), control.GetTypedValue((double)e.NewValue)));

            //Set indeterminate to false which will set the textbox text
            control.Indeterminate = false;

            // Set the textbox text
            //control.SetTextboxText();
        }


        #endregion InternalValue


        #region Timer


        /// <summary>
        /// Initialize the repeat buttons timer and set the initial delay 
        /// </summary>
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

            //ApplyKeyboardMumtiplier();
            IncrementDecrement();
        }


        /// <summary>
        /// Stop the repeat buttons timer
        /// </summary>
        private void StopTimer()
        {
            if (_Timer != null)
                _Timer.Stop();
        }


        /// <summary>
        /// Set the repeat buttons timer to use the interval and
        /// change the DisplayedValue on each tick
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void OnTimerTick(object sender, EventArgs e)
        {
            TimeSpan timeSpan = TimeSpan.FromMilliseconds(Interval);
            if (_Timer.Interval != timeSpan)
                _Timer.Interval = timeSpan;

            //ApplyKeyboardMumtiplier();
            IncrementDecrement();
        }


        #endregion Timer


        #region Value Formating

        /// <summary>
        /// Set the allowed chars
        /// </summary>
        private void SetAllowedChars()
        {
            if (!(Type == NumericUpDownType.Integer))
            {
                if (PART_Textbox.Text.Contains(_DecimalSeparator))
                    _AllowedChars = new Regex("[^0-9-]+");
                else
                    _AllowedChars = new Regex($"[^0-9-{_DecimalSeparator}]+");
            }
        }


        /// <summary>
        /// Get the number of decimal for a given number
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        protected int GetDecimalsCount(double value)
        {
            return value.ToString().SkipWhile(c => c != Convert.ToChar(_DecimalSeparator)).Skip(1).Count();
        }


        /// <summary>
        /// Set the Textbox text a formated string of DisplayValue 
        /// </summary>
        protected virtual void SetTextboxText()
        {
            if (PART_Textbox != null)
            {
                int decimals;
                if (Type == NumericUpDownType.Integer)
                    decimals = 0;
                else
                {
                    // Get the good amount of decimals
                    decimals = GetDecimalsCount(InternalValue);
                    decimals = (decimals > MinDecimals) ? decimals : MinDecimals;
                    decimals = (decimals < Decimals) ? decimals : Decimals;
                }

                // Format the InternalValue in the textbox with the correct amount of decimals
                PART_Textbox.Text = InternalValue.ToString(NumericFormatSpecifier.ToString() + decimals.ToString(), CultureInfo.CurrentCulture);
            }
        }


        #endregion Value Formating


        #endregion Private



        #region Events Handlers


        #region TextBox


        private void PART_TextBox_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SetAllowedChars();
            e.Handled = _AllowedChars.IsMatch(e.Text);
        }


        private void PART_TextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Return && e.Key == Key.Enter)
            {
                // Stop editing and set the focus to the parent
                Keyboard.ClearFocus();
                Helpers.RemoveFocus(this);

                //TODO: Validate event
            }
        }


        protected virtual void PART_Textbox_LostFocus(object sender, RoutedEventArgs e)
        {
            // Convert the Textbox Text back to internal value
            if (PART_Textbox.Text != string.Empty)
            {
                // Force the textbox to update if the value hasn't changed
                double value = Math.Round(double.Parse(PART_Textbox.Text), Decimals);
                if (InternalValue == value)
                    SetTextboxText();
                else
                    InternalValue = value;
            }
            else if (AlwaysShowValue)
            {
                // Force the textbox to update if the value hasn't changed
                if (InternalValue == DefaultValue)
                    SetTextboxText();
                else
                    InternalValue = DefaultValue;
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
                _Screen = Helpers.CurrentScreenBounds(this);

            // Reset the value on right click
            if (e.RightButton == MouseButtonState.Pressed)
                InternalValue = DefaultValue;
        }


        private void PART_UpDown_MouseUp(object sender, MouseButtonEventArgs e)
        {
            // Release the mouse capture and revert all changed bakground
            Cursor = Cursors.Arrow;
            _IsMouseMoving = false;
            Scale = _DefaultScale;
            PART_UpDown.ReleaseMouseCapture();
            PART_UpDown.Background = Background;
            PART_Increase.Background = new SolidColorBrush(Colors.Transparent);
            PART_Decrease.Background = new SolidColorBrush(Colors.Transparent);
            StopTimer();
        }


        private void PART_UpDown_MouseMove(object sender, MouseEventArgs e)
        {
            // Store the last mouse position just before it leaves the grid
            if (Helpers.IsMouseOver(PART_UpDown, e) && !_IsMouseMoving)
                _LastMousePos = Mouse.GetPosition(this);

            // Change the value accordingly to the mouse screen position, and allow the cursor to wrap the screen Y axis
            if (_IsMouseMoving || (Mouse.Captured == PART_UpDown && !Helpers.IsMouseOver(PART_UpDown, e)))
            {
                // Set the scale accelererator before the value change with the mouse moving
                if (ScaleAccelerator && !_IsMouseMoving)
                    Scale = GetScaleAccelerator();

                // Set the mouse move properties
                Cursor = Cursors.SizeNS;
                _IsMouseMoving = true;
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

                // Avoid the screen wrapping
                if (delta > 250 || delta < -250)
                    delta = 1;

                // Set the new value and store the last mouse position
                _Increase = delta >= 0 ? true : false;
                IncrementDecrement(Math.Abs(delta));
                _LastMousePos = pointToControl;
            }
        }


        private void IncreaseDecrease_MouseDown(Border border, MouseButtonEventArgs e, bool increase)
        {
            Focus();
            border.Background = Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver");
            _LastMousePos = Mouse.GetPosition(this);
            if (e.LeftButton == MouseButtonState.Pressed)
            {
                _Increase = increase;
                StartTimer();
            }
        }


        #endregion UpDown


        #endregion Events Handlers


        #endregion Methods

    }



    //     EVENTARGS     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public class SgzNumericUpDownEventArgs : EventArgs
    {
        public ValueType OldValue { get; set; }
        public ValueType NewValue { get; set; }

        public SgzNumericUpDownEventArgs(ValueType oldValue, ValueType newValue)
        {
            OldValue = oldValue;
            NewValue = newValue;
        }
    }



    //     3DS MAX IMPLEMENTATION     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public class SgzMaxNumericUpDown : SgzNumericUpDown
    {
        //TODO: get a callback when user change the unit to refresj the textbox text


        [Browsable(false)]
        public object Range
        {
            get
            {
                float[] range = new float[] { (float)MinValue, (float)MaxValue, (float)Value };
                Kernel.ToMxsArray(range);
                return null;
            }
            set
            {
                Console.WriteLine(value.ToString());

            }
        }



        public SgzMaxNumericUpDown()
        {
            Decimals = Kernel.Global.SpinnerPrecision_;
            GotFocus += (s, e) => ManagedServices.AppSDK.DisableAccelerators();
            LostFocus += (s, e) => ManagedServices.AppSDK.EnableAccelerators();
        }


        protected override void SetTextboxText()
        {
            if (PART_Textbox != null && Type == NumericUpDownType.WorldUnits)
            {
                // Format the InternalValue in the textbox with the correct amount of decimals
                PART_Textbox.Text = Kernel.Global.FormatUniverseValue((float)InternalValue);
            }
            else
                base.SetTextboxText();
        }


        protected override void PART_Textbox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (PART_Textbox.Text != string.Empty && Type == NumericUpDownType.WorldUnits)
            {
                // Force the textbox to update if the value hasn't changed
                IntPtr valid = new IntPtr();
                double value = (double)Kernel.Global.DecodeUniverseValue(PART_Textbox.Text, valid);
                if (InternalValue == value)
                    SetTextboxText();
                else
                    InternalValue = value;
            }
            else
                base.PART_Textbox_LostFocus(sender, e);
        }

    }
}
