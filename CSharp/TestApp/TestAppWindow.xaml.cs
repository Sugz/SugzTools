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

            SetUpDataGrid();
        }

        private void SetUpDataGrid()
        {
            SgzButton btn = new SgzButton();
            btn.Margin = new Thickness(5);
            btn.Click += Btn_Click;

            DependencyProperty[] props = new DependencyProperty[] { BackgroundProperty, SgzButton.HoverBrushProperty };
            Type type = typeof(SolidColorBrush);

            dg.AddUsing("System.Windows.Media", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll");
            dg.AddUsing("", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll");



            dg.AddColumn(btn, props, type, "f10", "f/1.0", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f14", "f/1.4", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f20", "f/2.0", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f28", "f/2.8", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f40", "f/4.0", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f56", "f/5.6", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f80", "f/8.0", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f11", "f/11", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f16", "f/16", true, DataGridLengthUnitType.Star);
            dg.AddColumn(btn, props, type, "f22", "f/22", true, DataGridLengthUnitType.Star);

            SolidColorBrush c0 = new SolidColorBrush(Color.FromRgb(255, 255, 205));
            SolidColorBrush c1 = new SolidColorBrush(Color.FromRgb(254, 255, 153));
            SolidColorBrush c2 = new SolidColorBrush(Color.FromRgb(254, 255, 0));
            SolidColorBrush c3 = new SolidColorBrush(Color.FromRgb(204, 255, 0));
            SolidColorBrush c4 = new SolidColorBrush(Color.FromRgb(153, 254, 0));
            SolidColorBrush c5 = new SolidColorBrush(Color.FromRgb(1, 255, 205));
            SolidColorBrush c6 = new SolidColorBrush(Color.FromRgb(101, 153, 255));
            SolidColorBrush c7 = new SolidColorBrush(Color.FromRgb(154, 204, 255));
            SolidColorBrush c8 = new SolidColorBrush(Color.FromRgb(203, 153, 204));
            SolidColorBrush c9 = new SolidColorBrush(Color.FromRgb(255, 153, 255));
            SolidColorBrush c10 = new SolidColorBrush(Color.FromRgb(254, 204, 205));
            SolidColorBrush c11 = new SolidColorBrush(Color.FromRgb(255, 203, 153));
            SolidColorBrush c12 = new SolidColorBrush(Color.FromRgb(255, 204, 0));
            SolidColorBrush c13 = new SolidColorBrush(Color.FromRgb(255, 153, 0));
            SolidColorBrush c14 = new SolidColorBrush(Color.FromRgb(255, 0, 0));
            SolidColorBrush c15 = new SolidColorBrush(Color.FromRgb(203, 51, 152));
            SolidColorBrush c16 = new SolidColorBrush(Color.FromRgb(204, 0, 255));
            SolidColorBrush c17 = new SolidColorBrush(Color.FromRgb(103, 51, 255));
            SolidColorBrush c18 = new SolidColorBrush(Color.FromRgb(153, 50, 103));

            dg.AddRow(new object[] { c0, c1, c2, c3, c4, c5, c6, c7, c8, c9 } );
            dg.AddRow(new object[] { c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 });
            dg.AddRow(new object[] { c2, c3, c4, c5, c6, c7, c8, c9, c10, c11 });
            dg.AddRow(new object[] { c3, c4, c5, c6, c7, c8, c9, c10, c11, c12 });
            dg.AddRow(new object[] { c4, c5, c6, c7, c8, c9, c10, c11, c12, c13 });
            dg.AddRow(new object[] { c5, c6, c7, c8, c9, c10, c11, c12, c13, c14 });
            dg.AddRow(new object[] { c6, c7, c8, c9, c10, c11, c12, c13, c14, c15 });
            dg.AddRow(new object[] { c7, c8, c9, c10, c11, c12, c13, c14, c15, c16 });
            dg.AddRow(new object[] { c8, c9, c10, c11, c12, c13, c14, c15, c16, c17 });
            dg.AddRow(new object[] { c9, c10, c11, c12, c13, c14, c15, c16, c17, c18 });
        }

        public void Btn_Click(object sender, RoutedEventArgs e)
        {
            Console.WriteLine("Test");
        }

        void LunchSecondWnd()
        {
            Window1 wnd = new Window1();
            wnd.Show();
        }


    }
}
