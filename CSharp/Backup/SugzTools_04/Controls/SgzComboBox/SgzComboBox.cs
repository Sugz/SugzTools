using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzComboBox : ComboBox
    {


        #region Properties


        //public new ItemCollection Items
        //{
        //    get
        //    {
        //        if()
        //    }
        //}


        /// <summary>
        /// Define the CornerRadius property
        /// </summary>
        [Description("Define the CornerRadius property"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
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


        #endregion Dependency Properties



        #region Constructors


        static SgzComboBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzComboBox), new FrameworkPropertyMetadata(typeof(SgzComboBox)));
            //MaxDropDownHeightProperty.OverrideMetadata(typeof(SgzComboBox), new FrameworkPropertyMetadata(5d));
        }
        public SgzComboBox()
        {

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
        }


        public void Add(object item)
        {
            Items.Add(item);
        }

        public void Add(object item, bool selectItem)
        {
            Items.Add(item);
            if (selectItem)
                SelectedIndex = Items.Count - 1;
        }

        public void InsertAt(ItemCollection items, int index, bool selectItem)
        {

        }


        public void RemoveAt(int index, int itemCount)
        {

        }


        #endregion Methods


    }
}

