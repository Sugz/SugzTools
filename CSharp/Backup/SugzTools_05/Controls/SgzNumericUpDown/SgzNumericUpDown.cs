using SugzTools.Src;
using System;
using System.ComponentModel;
using System.Globalization;
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

        #region Fields


        private TextBox PART_Textbox;                   // The Textbox part
        private Grid PART_UpDown;                       // The grid UpDown Part
        private Border PART_Increase;                   // The border Increase part
        private Border PART_Decrease;                   // The border Decrease part
        private DispatcherTimer _Timer;                 // The timer for the repeat buttons
        private Point _LastMousePos;                    // The mouse screen position
        private System.Drawing.Rectangle _Screen;       // The current screen bounds
        private bool mouseIsMoving = false;             // Register the mouse as moving 

        protected bool _Add = true;                     // Define wheter to increment or decrement
        protected int _Delay = 500;                     // The initial delay for the repeat buttons timer
        protected int _Interval = 33;                   // The interval for the for the repeat buttons timer
        protected T _DefaultValue;                      // The control default value
        protected T _Step;                              // The control step value use to increment or decrement the value
        protected T _MinValue;                          // The control minimum value
        protected T _MaxValue;                          // The control maximum value
        protected int _Decimals = 0;                    // The control number of decimal
        protected int _MaxDecimals = 0;                 // The control maximum number of decimal
        protected string _Unit = "";                    // The unit to be display
        protected bool _AlwaysShowValue = false;        // Force the control to display the default value is the value is null;
        protected readonly CultureInfo _Culture;        // The control culture


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
        [Description("The control number of decimal"), Category("")]
        public int Decimals
        {
            get { return _Decimals; }
            set
            {
                _Decimals = value;
                _Culture.NumberFormat.NumberDecimalDigits = Decimals;
            }
            //{
            //    if (value < 0)
            //        _Decimals = 0;

            //    else if (value > MaxDecimals)
            //        _Decimals = MaxDecimals;

            //    else _Decimals = value;

            //    _Culture.NumberFormat.NumberDecimalDigits = _Decimals;
            //}
        }



        /// <summary>
        /// The control maximum number of decimal
        /// </summary>
        [Description("The control maximum number of decimal"), Category("Common")]
        public int MaxDecimals
        {
            get { return _MaxDecimals; }
            set { _MaxDecimals = value; }
            //{
            //    if (value < 0)
            //        MaxDecimals = 0;

            //    else _MaxDecimals = value;

            //    if (Decimals > MaxDecimals)
            //        Decimals = MaxDecimals;
            //}

        }



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
        /// Force the control to display the default value is the value is null;
        /// </summary>
        [Description("Force the control to display the default value is the value is null;"), Category("Common")]
        public bool AlwaysShowValue
        {
            get { return _AlwaysShowValue; }
            set { _AlwaysShowValue = value; }
        }


        #endregion Properties



        #region Published Events


        public event EventHandler<NumericUpDownEventArgs<T>> ValueChanged; 


        #endregion Published Events



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



        #region Replace by CLR


        //public T MinValue
        //{
        //    get { return (T)GetValue(MinValueProperty); }
        //    set { SetValue(MinValueProperty, value); }
        //}

        //// DependencyProperty as the backing store for MinValue
        //public static readonly DependencyProperty MinValueProperty = DependencyProperty.Register(
        //    "MinValue",
        //    typeof(T),
        //    typeof(SgzNumericUpDown<T>),
        //    new PropertyMetadata(default(T), OnMinValueChanged)
        //);

        //private static void OnMinValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        //{
        //    var control = (SgzNumericUpDown<T>)d;
        //    T minValue = (T)e.NewValue;

        //    if (minValue.CompareTo(control.MaxValue) > 0)
        //        control.MaxValue = minValue;
        //}



        //public T MaxValue
        //{
        //    get { return (T)GetValue(MaxValueProperty); }
        //    set { SetValue(MaxValueProperty, value); }
        //}

        //// DependencyProperty as the backing store for MaxValue
        //public static readonly DependencyProperty MaxValueProperty = DependencyProperty.Register(
        //    "MaxValue",
        //    typeof(T),
        //    typeof(SgzNumericUpDown<T>),
        //    new PropertyMetadata(default(T), OnMaxValueChanged)
        //);

        //private static void OnMaxValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        //{
        //    var control = (SgzNumericUpDown<T>)d;
        //    T maxValue = (T)e.NewValue;

        //    if (maxValue.CompareTo(control.MinValue) < 0)
        //        control.MinValue = maxValue;
        //}


        #endregion Replace by CLR



        #endregion Dependency Properties



        #region Constructor


        public SgzNumericUpDown()
        {
            _Culture = (CultureInfo)CultureInfo.CurrentCulture.Clone();
            _Culture.NumberFormat.NumberDecimalDigits = Decimals;

            //Loaded += (s, e) => PART_Textbox.Text = AlwaysShowValue ? (Value.ToString() + Unit) : "";
            //Loaded += (s, e) => PART_Textbox.Text = AlwaysShowValue ? (Value.ToString("F", _Culture) + Unit) : "";
            Loaded += (s, e) => { if (AlwaysShowValue) SetTextboxText(Value); };
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


        private void SetTextboxText(T value)
        {
            if (PART_Textbox != null)
                PART_Textbox.Text = (value.ToString("F", _Culture) + Unit);
        }



        #region Value


        private static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            ((SgzNumericUpDown<T>)d).OnRaiseValueChangedEvent(new NumericUpDownEventArgs<T>((T)e.OldValue, (T)e.NewValue));

        }


        protected virtual void OnRaiseValueChangedEvent(NumericUpDownEventArgs<T> e)
        {
            EventHandler<NumericUpDownEventArgs<T>> handler = ValueChanged;
            handler?.Invoke(this, e);
        }


        private static object CoerceValue(DependencyObject d, object baseValue)
        {
            SgzNumericUpDown<T> control = d as SgzNumericUpDown<T>;
            T value = control.CoerceValueToBounds((T)baseValue);

            //if (control.PART_Textbox != null)
            //    control.PART_Textbox.Text = (value.ToString("F", control._Culture) + control.Unit);
            control.SetTextboxText(value);

            return value;
        } 


        #endregion Value



        #endregion Private



        #region Public


        public virtual bool IsTextAllowed(string text)
        {
            Regex regex = new Regex("[^0-9.-]+"); //regex that matches disallowed text
            return !regex.IsMatch(text);
        }


        public abstract void IncrementDecrement(double multiplier = 1);


        #endregion Public



        #region Events Handlers



        #region Textbox


        private void PART_TextBox_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            // Only allow to type number value
            e.Handled = !IsTextAllowed(e.Text);

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
            if (PART_Textbox.Text != string.Empty)
                Value = (T)Convert.ChangeType(PART_Textbox.Text, typeof(T));
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
                    delta *= 10;
                else if (Keyboard.IsKeyDown(Key.LeftAlt))
                    delta *= 0.1;

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



        #endregion Events Handlers



        #endregion Methods
    }



    public class SgzIntUpDown : SgzNumericUpDown<int>
    {

        #region Constructors


        static SgzIntUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzIntUpDown), new FrameworkPropertyMetadata(typeof(SgzIntUpDown)));
            ValueProperty.OverrideMetadata(typeof(SgzIntUpDown), new PropertyMetadata(0));
        }
        public SgzIntUpDown()
        {
            Step = 1;
            MinValue = int.MinValue;
            MaxValue = int.MaxValue;
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

    public class SgzLongUpDown : SgzNumericUpDown<long>
    {

        #region Constructors


        static SgzLongUpDown()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzLongUpDown), new FrameworkPropertyMetadata(typeof(SgzLongUpDown)));
            ValueProperty.OverrideMetadata(typeof(SgzLongUpDown), new PropertyMetadata(0L));
        }
        public SgzLongUpDown()
        {
            Step = 1;
            MinValue = long.MinValue;
            MaxValue = long.MaxValue;
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
        public SgzFloatUpDown()
        {
            Step = 0.1f;
            MinValue = float.MinValue;
            MaxValue = float.MaxValue;
            Decimals = 7;
            MaxDecimals = 7;
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
            ValueProperty.OverrideMetadata(typeof(SgzDoubleUpDown), new PropertyMetadata(0d));
        }
        public SgzDoubleUpDown()
        {
            Step = 0.1d;
            MinValue = double.MinValue;
            MaxValue = double.MaxValue;
            Decimals = 15;
            MaxDecimals = 15;
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

