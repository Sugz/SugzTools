using SugzTools.Max;
using SugzTools.Src;
using System;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
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
        //TODO: DisplayedValue => InternalValue
        //TODO: check if Value, defaultValue, etc are valid (not like 25.2.6...)


        #region Fields


        protected TextBox PART_Textbox;                                                         // The Textbox part
        private Grid PART_UpDown;                                                               // The grid UpDown Part
        private Border PART_Increase;                                                           // The border Increase part
        private Border PART_Decrease;                                                           // The border Decrease part
        private DispatcherTimer _Timer;                                                         // The timer for the repeat buttons
        private Point _LastMousePos;                                                            // The mouse screen position
        private System.Drawing.Rectangle _Screen;                                               // The current screen bounds
        private int _ScaleDecimals;                                                             // The number of decimals for the scale

        protected bool _IsMouseMoving = false;                                                  // Register the mouse as moving 
        protected bool _Add = true;                                                             // Define wheter to increment or decrement
        protected int _Delay = 500;                                                             // The initial delay for the repeat buttons timer
        protected int _Interval = 33;                                                           // The interval for the for the repeat buttons timer
        protected T _DefaultValue;                                                              // The control default value
        protected float _DisplayedValueMultiplier = 1f;                                         // Get / Set the multiplier used to show the value in the input field
        protected T _Scale;                                                                     // The control Scale value use to increment or decrement the value
        protected T _DefaultScale;                                                              // The control Scale value set when the control is created
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
        protected bool _ScaleAccelerator = true;                                                // Get / Set if the Scale is increasing or decreasing considering the current value


        #endregion Fields



        #region Properties


        /// <summary>
        /// The initial delay for the repeat buttons timer
        /// </summary>
        [Description("The initial delay for the repeat buttons timer"), Category("Timer"), DefaultValue(500)]
        public int Delay
        {
            get { return _Delay; }
            set { _Delay = value; }
        }



        /// <summary>
        /// The interval for the for the repeat buttons timer
        /// </summary>
        [Description("The interval for the for the repeat buttons timer"), Category("Timer"), DefaultValue(33)]
        public int Interval
        {
            get { return _Interval; }
            set { _Interval = value; }
        }



        /// <summary>
        /// The control value
        /// </summary>
        [Description("The control value"), Category("Value")]
        public virtual T Value
        {
            get { return TMath.Divide(DisplayedValue, DisplayedValueMultiplier); }
            set { DisplayedValue = TMath.Multiply(value, DisplayedValueMultiplier); }
        }


       
        /// <summary>
        /// The control displayed value, used for all internal calculation
        /// </summary>
        [Browsable(false)]
        public T DisplayedValue
        {
            get { return (T)GetValue(DisplayedValueProperty); }
            set { SetValue(DisplayedValueProperty, value); }
        }



        /// <summary>
        /// The control default value
        /// </summary>
        [Description("The control default value"), Category("Value")]
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
        [Description("The multiplier used to show the value in the input field"), Category("Value")]
        public float DisplayedValueMultiplier
        {
            get { return _DisplayedValueMultiplier; }
            set { _DisplayedValueMultiplier = value; }
        }



        /// <summary>
        /// The control Scale value use to increment or decrement the value
        /// </summary>
        [Description("The control Scale value use to increment or decrement the value"), Category("Value")]
        public T Scale
        {
            get { return _Scale; }
            set { _Scale = value; }
        }



        /// <summary>
        /// The control minimum value
        /// </summary>
        [Description("The control minimum value"), Category("Value")]
        public T MinValue
        {
            get { return _MinValue; }
            set
            {
                _MinValue = value;

                if (MinValue.CompareTo(MaxValue) > 0)
                    MaxValue = MinValue;

                CoerceValueToBounds(DisplayedValue);
            }
        }



        /// <summary>
        /// The control maximum value
        /// </summary>
        [Description("The control maximum value"), Category("Value")]
        public T MaxValue
        {
            get { return _MaxValue; }
            set
            {
                _MaxValue = value;

                if (MaxValue.CompareTo(MinValue) < 0)
                    MinValue = MaxValue;

                CoerceValueToBounds(DisplayedValue);
            }
        }



        /// <summary>
        /// The control number of decimal
        /// </summary>
        [Description("The control number of decimal"), Category("Decimals")]
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
        [Description("The control minimum number of decimal"), Category("Decimals")]
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



        /// <summary>
        /// The control numeric format specifier
        /// </summary>
        [Description("The control numeric format specifier"), Category("Value")]
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
        [Description("The unit to be display"), Category("Value")]
        public string Unit
        {
            get { return _Unit; }
            set { _Unit = value; }
        }



        /// <summary>
        /// Force the control to display the default value is the value is null;
        /// </summary>
        [Description("Force the control to display the default value is the value is null;"), Category("Value")]
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
        /// Get / Set if the Scale is increasing or decreasing considering the current value
        /// </summary>
        [Description("Get / Set if the Scale is increasing or decreasing considering the current value"), Category("Value")]
        public bool ScaleAccelerator
        {
            get { return _ScaleAccelerator; }
            set { _ScaleAccelerator = value; }
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



        /// <summary>
        /// Get or set the textbox selection brush
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


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for DisplayedValue
        public static readonly DependencyProperty DisplayedValueProperty = DependencyProperty.Register(
            "DisplayedValue",
            typeof(T),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(default(T), OnDisplayedValueChanged, CoerceDisplayedValue)
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


        // DependencyProperty as the backing store for SelectionBrush
        public static readonly DependencyProperty SelectionBrushProperty = DependencyProperty.Register(
            "SelectionBrush",
            typeof(Brush),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzNumericUpDown<T>),
            new PropertyMetadata(0)
        );


        #endregion Dependency Properties



        #region Published Events


        public event EventHandler<NumericUpDownEventArgs<T>> ValueChanged;


        #endregion Published Events



        #region Constructor


        public SgzNumericUpDown()
        {
            Loaded += OnLoaded;
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


        /// <summary>
        /// Restrict the given value to be insde MinValue and MaxValue
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        private T CoerceValueToBounds(T value)
        {
            if (value.CompareTo(MinValue) < 0)
                value = MinValue;
            else if (value.CompareTo(MaxValue) > 0)
                value = MaxValue;

            return value;
        }


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

            ApplyKeyboardMumtiplier();
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

            ApplyKeyboardMumtiplier();
        }


        /// <summary>
        /// Set the scale to be a percentage of the DisplayedValue
        /// </summary>
        private void SetScale()
        {
            T PercentValue = TMath.Divide(TMath.Abs(DisplayedValue), 100);
            T scale = TMath.Add<T>(PercentValue, _DefaultScale);
            Scale = TMath.RoundDown(scale, _ScaleDecimals);

            //Console.WriteLine(Scale);
        }


        /// <summary>
        /// Call IncrementDecrement using the keyboard to change the multiplier
        /// </summary>
        private void ApplyKeyboardMumtiplier()
        {
            if (Keyboard.IsKeyDown(Key.LeftCtrl))
                IncrementDecrement(10);
            else if (Keyboard.IsKeyDown(Key.LeftAlt))
                IncrementDecrement(0.1);
            else IncrementDecrement();

        }


        /// <summary>
        /// Increment or Decrement DisplayedValue
        /// </summary>
        /// <param name="multiplier"></param>
        private void IncrementDecrement(double multiplier = 1)
        {
            T increment = Scale;
            try { increment = checked(TMath.Multiply(Scale, multiplier)); }
            catch (OverflowException) { }
            if (_Add)
            {
                try { DisplayedValue = checked(TMath.Add<T>(DisplayedValue, increment)); }
                catch (OverflowException) { DisplayedValue = MaxValue; }
            }
            else
            {
                try { DisplayedValue = checked(TMath.Substract<T>(DisplayedValue, increment)); }
                catch (OverflowException) { DisplayedValue = MinValue; }
            }
        }


        /// <summary>
        /// Raised the ValueChanged event
        /// </summary>
        /// <param name="e"></param>
        private void OnValueChangedRaised(NumericUpDownEventArgs<T> e)
        {
            ValueChanged?.Invoke(this, new NumericUpDownEventArgs<T>(
                TMath.Divide(e.OldValue, DisplayedValueMultiplier),
                TMath.Divide(e.NewValue, DisplayedValueMultiplier)
            ));
        }



        #region DisplayedValue


        private static void OnDisplayedValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            SgzNumericUpDown<T> control = d as SgzNumericUpDown<T>;
            control.SetTextboxText();

            control.CanRaiseValueChanged((T)e.OldValue, (T)e.NewValue);

        }


        private static object CoerceDisplayedValue(DependencyObject d, object baseValue)
        {
            SgzNumericUpDown<T> control = d as SgzNumericUpDown<T>;
            T value = control.CoerceValueToBounds((T)baseValue);
            return TMath.Round(value, control.Decimals + 1);
        }


        #endregion DisplayedValue



        #endregion Private



        #region Protected


        /// <summary>
        /// Set the Textbox text, _DefaultScale, _ScaleDecimals and set the scale
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected virtual void OnLoaded(object sender, RoutedEventArgs e)
        {
            if (AlwaysShowValue)
                SetTextboxText();

            if (ScaleAccelerator)
            {
                _DefaultScale = Scale;
                _ScaleDecimals = GetDecimalsCount(Scale);
                SetScale();
            }
        }


        /// <summary>
        /// Get the number of decimal for a given number send as string
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        protected int GetDecimalsCount(T value)
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
                // Get the good amount of decimals
                int decimals = GetDecimalsCount(DisplayedValue);
                decimals = decimals > MinDecimals ? decimals : MinDecimals;
                decimals = decimals < Decimals ? decimals : Decimals;

                // Format the DisplayedValue ine the textbox with the correct amount of decimals
                PART_Textbox.Text = DisplayedValue.ToString(NumericFormatSpecifier.ToString() + decimals.ToString(), CultureInfo.CurrentCulture) + Unit;
            }
        }


        /// <summary>
        /// Floor DisplayedValue 
        /// </summary>
        protected virtual void FloorDisplayedValue() { }


        /// <summary>
        /// Check and call if the ValueChanged event can be raise
        /// </summary>
        /// <param name="oldValue"></param>
        /// <param name="newValue"></param>
        protected virtual void CanRaiseValueChanged(T oldValue, T newValue)
        {
            OnValueChangedRaised(new NumericUpDownEventArgs<T>(oldValue, newValue));
        }

        /// <summary>
        /// Forbid to add the Decimal Char if it's already there
        /// </summary>
        protected virtual void SetAllowedChars() { }


        #endregion Protected



        #region Events Handlers



        #region Textbox


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
            }
        }


        private void PART_Textbox_LostFocus(object sender, RoutedEventArgs e)
        {
            // Convert the Textbox Text back to T DisplayedValue
            if (PART_Textbox.Text != string.Empty)
            {
                try
                {
                    // Force the textbox to update if the value hasn't changed
                    T value = (T)Convert.ChangeType(PART_Textbox.Text.TrimEnd(Unit.ToCharArray()), typeof(T));
                    if (DisplayedValue.Equals(value))
                        SetTextboxText();
                    else
                        DisplayedValue = value;
                }
                catch
                {
                    DisplayedValue = DefaultValue;
                };
                
            }
            else if (AlwaysShowValue)
            {
                // Force the textbox to update if the value hasn't changed
                if (DisplayedValue.Equals(DefaultValue))
                    SetTextboxText();
                else
                    DisplayedValue = DefaultValue;
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
                DisplayedValue = DefaultValue;
        }


        private void PART_UpDown_MouseUp(object sender, MouseButtonEventArgs e)
        {
            // Release the mouse capture and revert all changed bakground
            Cursor = Cursors.Arrow;
            _IsMouseMoving = false;
            FloorDisplayedValue();
            PART_UpDown.ReleaseMouseCapture();
            PART_UpDown.Background = Background;
            PART_Increase.Background = new SolidColorBrush(Colors.Transparent);
            PART_Decrease.Background = new SolidColorBrush(Colors.Transparent);
            StopTimer();

            // Set the Scale accelerator
            if (ScaleAccelerator)
                SetScale();
        }


        private void PART_UpDown_MouseMove(object sender, MouseEventArgs e)
        {
            // Store the last mouse position just before it leaves the grid
            if (Helpers.IsMouseOver(PART_UpDown, e) && !_IsMouseMoving)
                _LastMousePos = Mouse.GetPosition(this);

            // Change the value accordingly to the mouse screen position, and allow the cursor to wrap the screen Y axis
            if (_IsMouseMoving || (Mouse.Captured == PART_UpDown && !Helpers.IsMouseOver(PART_UpDown, e)))
            {
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

                // Get the keyboard multiplier
                if (Keyboard.IsKeyDown(Key.LeftCtrl))
                    delta *= 10;
                else if (Keyboard.IsKeyDown(Key.LeftAlt))
                    delta *= 0.1;

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






    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //     IMPLEMENTATIONS     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



    #region Standard Implementation


    public class SgzIntUpDown : SgzNumericUpDown<int>
    {
        static SgzIntUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzIntUpDown), new FrameworkPropertyMetadata(typeof(SgzIntUpDown)));
        }
        public SgzIntUpDown()
        {
            Scale = 1;
            MinValue = int.MinValue + 1;
            MaxValue = int.MaxValue - 1;
        }
    }

    public class SgzLongUpDown : SgzNumericUpDown<long>
    {
        static SgzLongUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzLongUpDown), new FrameworkPropertyMetadata(typeof(SgzLongUpDown)));
        }
        public SgzLongUpDown()
        {
            Scale = 1;
            MinValue = long.MinValue + 1;
            MaxValue = long.MaxValue - 1;
        }
    }

    public class SgzFloatUpDown : SgzNumericUpDown<float>
    {
        static SgzFloatUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzFloatUpDown), new FrameworkPropertyMetadata(typeof(SgzFloatUpDown)));
        }
        public SgzFloatUpDown()
        {
            _AllowedChars = new Regex("[^0-9" + _DecimalSeparator + "-]+");
            _MaxDecimals = 7;

            Scale = 0.1f;
            MinValue = float.MinValue + 1;
            MaxValue = float.MaxValue + 1;
        }
    }

    public class SgzDoubleUpDown : SgzNumericUpDown<double>
    {
        static SgzDoubleUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDoubleUpDown), new FrameworkPropertyMetadata(typeof(SgzDoubleUpDown)));
        }
        public SgzDoubleUpDown()
        {
            _AllowedChars = new Regex("[^0-9" + _DecimalSeparator + "-]+");
            _MaxDecimals = 15;

            Scale = 0.1d;
            MinValue = double.MinValue + 1;
            MaxValue = double.MaxValue - 1;

        }
    }


    #endregion Standard Implementation



    public class SgzMaxNumericUpDown : SgzNumericUpDown<float>
    {
        [Description("Get / set the type of the control"), Category("Value")]
        public SpinnerType Type { get; set; }

        public override float Value
        {
            get
            {
                switch (Type)
                {
                    case SpinnerType.Integer:
                        return (int)Math.Floor(base.Value);
                    default:
                        return base.Value;
                }
            }
            set { base.Value = value; }
        }

        static SgzMaxNumericUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzMaxNumericUpDown), new FrameworkPropertyMetadata(typeof(SgzMaxNumericUpDown)));
        }
        public SgzMaxNumericUpDown()
        {
            _AllowedChars = new Regex("[^0-9" + _DecimalSeparator + "-]+");
            _MaxDecimals = 7;

            Type = SpinnerType.Float;
            AlwaysShowValue = true;
            MinValue = float.MinValue + 1;
            MaxValue = float.MaxValue + 1;
            Scale = 0.1f;
            MinDecimals = 1;
            Decimals = 3;
        }


        protected override void OnLoaded(object sender, RoutedEventArgs e)
        {
            if (Type == SpinnerType.Integer)
            {
                _AllowedChars = new Regex("[^0-9-]+");
                MinDecimals = 0;
                Decimals = 0;
                if (Scale < 1)
                    Scale = 1f;
            }

            base.OnLoaded(sender, e);
        }


        protected override void SetTextboxText()
        {
            if (Type == SpinnerType.Integer && PART_Textbox != null)
            {
                // Get the good amount of decimals
                int decimals = GetDecimalsCount(DisplayedValue);
                decimals = decimals > MinDecimals ? decimals : MinDecimals;
                decimals = decimals < Decimals ? decimals : Decimals;

                // Format the DisplayedValue ine the textbox with the correct amount of decimals
                PART_Textbox.Text = Math.Floor(DisplayedValue).ToString(NumericFormatSpecifier.ToString() + decimals.ToString(), CultureInfo.CurrentCulture) + Unit;
            }

            else
                base.SetTextboxText();
        }


        protected override void FloorDisplayedValue()
        {
            if (Type == SpinnerType.Integer)
                DisplayedValue = (float)Math.Floor(DisplayedValue);
        }


        protected override void CanRaiseValueChanged(float oldValue, float newValue)
        {
            if (Type == SpinnerType.Integer)
            {
                float FlooredOldValue = (float)Math.Floor(oldValue);
                float FlooredNewValue = (float)Math.Floor(newValue);

                if (FlooredOldValue != FlooredNewValue)
                    base.CanRaiseValueChanged(FlooredOldValue, FlooredNewValue);
            }
            else
                base.CanRaiseValueChanged(oldValue, newValue);
        }


        protected override void SetAllowedChars()
        {
            if (!(Type == SpinnerType.Integer))
            {
                if (PART_Textbox.Text.Contains(_DecimalSeparator))
                    _AllowedChars = _AllowedChars = new Regex("[^0-9-]+");
                else
                    _AllowedChars = new Regex("[^0-9" + _DecimalSeparator + "-]+");
            }
        }


        //public void PrintUnit()
        //{
        //    Kernel.Global.FormatUniverseValue(Value);
        //    Kernel.Global.DecodeUniverseValue();
        //    Kernel.Global.SpinnerPrecision_
        //}
    }

}

