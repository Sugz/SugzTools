using SugzTools.Controls;
using SugzTools.Icons;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
        IList<SgzExpanderItem> _items;
        SgzTextBox txt;

        public MainWindow()
        {
            InitializeComponent();

            SgzExpanderItem item1 = new SgzExpanderItem();
            item1.Header = "Expander 01";
            item1.IsExpanded = true;
            StackPanel panel1 = new StackPanel();
            panel1.Margin = new Thickness(5);
            SgzButton btn1 = new SgzButton();
            btn1.Click += Btn1_Click;
            panel1.Children.Add(btn1);

            txt = new SgzTextBox();
            txt.Watermark = "test";
            
            panel1.Children.Add(txt);

            item1.Content = panel1;

            SgzExpanderItem item2 = new SgzExpanderItem();
            item2.Header = "Expander 02";
            item2.IsExpanded = true;
            StackPanel panel2 = new StackPanel();
            panel2.Margin = new Thickness(5);
            SgzButton btn2 = new SgzButton();
            panel2.Children.Add(btn2);
            item2.Content = panel2;

            SgzExpanderItem item3 = new SgzExpanderItem();
            item3.Header = "Expander 03";
            item3.IsExpanded = true;
            StackPanel panel3 = new StackPanel();
            panel3.Margin = new Thickness(5);
            SgzButton btn3 = new SgzButton();
            panel3.Children.Add(btn3);
            item3.Content = panel3;


            _items = new ObservableCollection<SgzExpanderItem>()
            {
                item1,
                item2,
                item3
            };

            Listbox.DataContext = _items;
        }



        private void Btn1_Click(object sender, RoutedEventArgs e)
        {
            SgzIcon icon1 = new SgzIcon();
            icon1.Cursor = Cursors.Arrow;
            icon1.Icon = Geo.MdiAccessPoint;
            icon1.Width = 23;
            icon1.Padding = new Thickness(4, 2, 4, 2);
            txt.AddControl(icon1, 0);


            SgzIcon icon2 = new SgzIcon();
            icon2.Cursor = Cursors.Arrow;
            icon2.Icon = Geo.MdiClose;
            icon2.Width = 19;
            icon2.Padding = new Thickness(4);
            txt.AddControl(icon2, 3);


            SgzIcon icon3 = new SgzIcon();
            icon3.Cursor = Cursors.Arrow;
            icon3.Icon = Geo.MdiCodeString;
            icon3.Width = 19;
            icon3.Padding = new Thickness(4);
            txt.AddControl(icon3, 2);

        }


        //public MainWindow()
        //{
        //    InitializeComponent();
        //    intTxt2.Text = string.Format("Value: {0}, Type: {1}", intSpinner.Value, intSpinner.Value.GetType());
        //    intTxt3.Text = string.Format("Scale: {0}", intSpinner.Scale);
        //    floatTxt2.Text = string.Format("Value: {0}, Type: {1}", floatSpinner.Value, floatSpinner.Value.GetType());
        //    floatTxt3.Text = string.Format("Scale: {0}", floatSpinner.Scale);

        //    intSpinner.ValueChanged += (s, e) =>
        //    {
        //        intTxt.Text = string.Format("Old: {0}, Type:{1}, New: {2}, Type:{3}", e.OldValue, e.OldValue.GetType(), e.NewValue, e.NewValue.GetType());
        //        intTxt2.Text = string.Format("Value: {0}, Type: {1}", ((SgzNumericUpDown)s).Value, ((SgzNumericUpDown)s).Value.GetType());
        //        intTxt3.Text = string.Format("Scale: {0}", ((SgzNumericUpDown)s).Scale);
        //    };
        //    floatSpinner.ValueChanged += (s, e) =>
        //    {
        //        floatTxt.Text = string.Format("Old: {0}, Type:{1}, New: {2}, Type:{3}", e.OldValue, e.OldValue.GetType(), e.NewValue, e.NewValue.GetType());
        //        floatTxt2.Text = string.Format("Value: {0}, Type: {1}", ((SgzNumericUpDown)s).Value, ((SgzNumericUpDown)s).Value.GetType());
        //        floatTxt3.Text = string.Format("Scale: {0}", ((SgzNumericUpDown)s).Scale);
        //    };

        //    txt.Validate += (s, e) => Console.WriteLine(e.Text);

        //}


        //private void SgzButton_Click(object sender, RoutedEventArgs e)
        //{
        //    progressbar.IndeterminateAutoReverse = !progressbar.IndeterminateAutoReverse; //NO
        //    //progressbar.IsCylon = !progressbar.IsCylon;
        //}

    }
}
