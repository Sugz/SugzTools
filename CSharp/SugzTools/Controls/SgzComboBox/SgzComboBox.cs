using SugzTools.Src;
using SugzTools.Themes;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzComboBox : ComboBox
    {

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
            
        }
        public SgzComboBox()
        {
            Loaded += (s, e) => FocusVisualStyle = FocusVisualStyles.GetControlStyle(CornerRadius);
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

        public void InsertAt(ItemCollection items, int index, bool selectItem)
        {

        }


        public void RemoveAt(int index, int itemCount)
        {

        }


        #endregion Methods


    }
}

