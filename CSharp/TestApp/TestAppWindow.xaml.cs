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
        //IList<SgzExpanderItem> _items;
        //SgzTextBox txt;

        public MainWindow()
        {
            InitializeComponent();

            //Main()
        }


        /*void Main()
        {
            
            sgzexpanderitem item1 = new sgzexpanderitem();
            item1.header = "expander 01";
            item1.isexpanded = true;
            stackpanel panel1 = new stackpanel();
            panel1.margin = new thickness(5);
            sgzbutton btn1 = new sgzbutton();
            btn1.click += btn1_click;
            panel1.children.add(btn1);

            txt = new sgztextbox();
            txt.watermark = "test";

            panel1.children.add(txt);

            item1.content = panel1;

            sgzexpanderitem item2 = new sgzexpanderitem();
            item2.header = "expander 02";
            item2.isexpanded = true;
            stackpanel panel2 = new stackpanel();
            panel2.margin = new thickness(5);
            sgzbutton btn2 = new sgzbutton();
            panel2.children.add(btn2);
            item2.content = panel2;

            sgzexpanderitem item3 = new sgzexpanderitem();
            item3.header = "expander 03";
            item3.isexpanded = true;
            stackpanel panel3 = new stackpanel();
            panel3.margin = new thickness(5);
            sgzbutton btn3 = new sgzbutton();
            panel3.children.add(btn3);
            item3.content = panel3;


            _items = new observablecollection<sgzexpanderitem>()
            {
                item1,
                item2,
                item3
            };

            listbox.datacontext = _items;
            
        }*/



        /*private void Btn1_Click(object sender, RoutedEventArgs e)
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

        }*/


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
