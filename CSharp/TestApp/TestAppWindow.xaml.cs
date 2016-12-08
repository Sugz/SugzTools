using SugzTools.Controls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace TestApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {



        public MainWindow()
        {
            InitializeComponent();
            intTxt2.Text = string.Format("Value: {0}, Type: {1}", intSpinner.Value, intSpinner.Value.GetType());
            intTxt3.Text = string.Format("Scale: {0}", intSpinner.Scale);
            floatTxt2.Text = string.Format("Value: {0}, Type: {1}", floatSpinner.Value, floatSpinner.Value.GetType());
            floatTxt3.Text = string.Format("Scale: {0}", floatSpinner.Scale);

            intSpinner.ValueChanged += (s, e) =>
            {
                intTxt.Text = string.Format("Old: {0}, Type:{1}, New: {2}, Type:{3}", e.OldValue, e.OldValue.GetType(), e.NewValue, e.NewValue.GetType());
                intTxt2.Text = string.Format("Value: {0}, Type: {1}", ((SgzNumericUpDown)s).Value, ((SgzNumericUpDown)s).Value.GetType());
                intTxt3.Text = string.Format("Scale: {0}", ((SgzNumericUpDown)s).Scale);
            };
            floatSpinner.ValueChanged += (s, e) =>
            {
                floatTxt.Text = string.Format("Old: {0}, Type:{1}, New: {2}, Type:{3}", e.OldValue, e.OldValue.GetType(), e.NewValue, e.NewValue.GetType());
                floatTxt2.Text = string.Format("Value: {0}, Type: {1}", ((SgzNumericUpDown)s).Value, ((SgzNumericUpDown)s).Value.GetType());
                floatTxt3.Text = string.Format("Scale: {0}", ((SgzNumericUpDown)s).Scale);
            };

            txt.Validate += (s, e) => Console.WriteLine(e.Text);
            
        }


        private void SgzButton_Click(object sender, RoutedEventArgs e)
        {

        }





    }
}
