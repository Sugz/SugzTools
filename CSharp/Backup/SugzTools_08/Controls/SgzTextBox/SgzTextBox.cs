using SugzTools.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace SugzTools.Controls
{
    public class SgzTextBox : TextBox
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
            typeof(SgzTextBox),
            new PropertyMetadata(0)
        );


        #endregion Dependency Properties



        #region Contructors


        static SgzTextBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzTextBox), new FrameworkPropertyMetadata(typeof(SgzTextBox)));
        }
        public SgzTextBox()
        {
            KeyDown += SgzTextBox_KeyDown;
        }


        #endregion Contructors



        #region Methods


        private void SgzTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Return && e.Key == Key.Enter)
            {
                // Stop editing and set the focus to the parent
                Keyboard.ClearFocus();
                Helpers.RemoveFocus(this);
            }
        }


        #endregion Methods


    }
}