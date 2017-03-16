using SugzTools.Src;
using SugzTools.Themes;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzComboBox : ComboBox
    {
        //TODO: Watermark

        #region Properties


        /// <summary>
        /// Define the CornerRadius property
        /// </summary>
        [Description("Define the CornerRadius property"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }



        /// <summary>
        /// Get or set the title of the control
        /// </summary>
        [Description("Get or set the title of the control"), Category("Common")]
        public object Title
        {
            get { return (object)GetValue(TitleProperty); }
            set { SetValue(TitleProperty, value); }
        }


        /// <summary>
        /// Get or set the position of the title
        /// </summary>
        [Description("Get or set the position of the title"), Category("Appearance")]
        public Dock TitleSide
        {
            get { return (Dock)GetValue(TitleSideProperty); }
            set { SetValue(TitleSideProperty, value); }
        }



        /// <summary>
        /// Set the height of the field when TitleSide is set on top or bottom
        /// </summary>
        [Description("Get or set the height of the field"), Category("Layout")]
        public double FieldHeight
        {
            get { return (double)GetValue(FieldHeightProperty); }
            set { SetValue(FieldHeightProperty, value); }
        }


        





        #endregion



        #region Dependency Properties


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzComboBox),
            new PropertyMetadata(0)
        );


        // DependencyProperty as the backing store for Content
        public static readonly DependencyProperty TitleProperty = DependencyProperty.Register(
            "Title",
            typeof(object),
            typeof(SgzComboBox)
        );


        // DependencyProperty as the backing store for TitleSide
        public static readonly DependencyProperty TitleSideProperty = DependencyProperty.Register(
            "TitleSide",
            typeof(Dock),
            typeof(SgzComboBox),
            new PropertyMetadata(Dock.Left)
        );


        // DependencyProperty as the backing store for FieldHeight
        public static readonly DependencyProperty FieldHeightProperty = DependencyProperty.Register(
            "FieldHeight",
            typeof(double),
            typeof(SgzComboBox)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzComboBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzComboBox), new FrameworkPropertyMetadata(typeof(SgzComboBox)));
            
        }
        public SgzComboBox()
        {
            
            Loaded += (s, e) =>
            {
                FocusVisualStyle = FocusVisualStyles.GetControlStyle(CornerRadius);
                //FieldHeight = Height;


            };
        }


        #endregion Constructors



        #region Methods


        /// <summary>
        /// Let the user set the number of item to be shown in the popup instead of the popup height
        /// </summary>
        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            MaxDropDownHeight *= 18;
            MaxDropDownHeight += 2;


            //if (TitleSide == Dock.Top && TitleSide == Dock.Bottom)
            //    Height = double.NaN;
        }


        public object GetItem(int index)
        {
            return Items[index];
        }


        public object[] GetItems()
        {
            return Helpers.ToArray(Items);
        }


        public void SetItems(object[] items)
        {
            Items.Clear();
            Add(items);
        }


        public void Add(object item)
        {
            Items.Add(item);
        }

        public void Add(object[] items)
        {
            foreach (object item in items)
                Items.Add(item);
        }

        public void Add(object item, bool selectItem)
        {
            Items.Add(item);
            if (selectItem)
                SelectedIndex = Items.Count - 1;
        }


        #endregion Methods


    }
}

