using SugzTools.Controls;
using SugzTools.Icons;
using SugzTools.Src;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
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
            btn.Margin = new Thickness(1);
            btn.VerticalAlignment = VerticalAlignment.Stretch;
            btn.Height = Double.NaN;
            btn.Click += Btn_Click; ;

            dg.ModelFileName = @"d:\test.cs";

            dg.AddUsing("System.Windows.Media", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll");
            dg.AddUsing("", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll");

            DependencyProperty[] props = new DependencyProperty[1] { ContentProperty };
            string[] columnProps = new string[10] { "f10", "f14", "f20", "f28", "f40", "f56", "f80", "f11", "f16", "f22" };
            string[] columnHeaders = new string[10] { "f/1.0", "f/1.4", "f/2.0", "f/2.8", "f/4.0", "f/5.6", "f/8.0", "f/11", "f/16", "f/22" };
            for (int i = 0; i < columnHeaders.Length; i++)
                dg.AddColumn(btn, props, typeof(int), columnProps[i], columnHeaders[i], true);

            string[] rowHeaders = new string[10] { "1 sec", "1/2 sec", "1/4 sec", "1/8 sec", "1/15 sec", "1/30 sec", "1/60 sec", "1/125 sec", "1/250 sec", "1/500 sec" };
            dg.AddRow(rowHeaders[0], new object[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 });
            dg.AddRow(rowHeaders[1], new object[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 });
            dg.AddRow(rowHeaders[2], new object[] { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 });
            dg.AddRow(rowHeaders[3], new object[] { 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 });
            dg.AddRow(rowHeaders[4], new object[] { 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 });
            dg.AddRow(rowHeaders[5], new object[] { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 });
            dg.AddRow(rowHeaders[6], new object[] { 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 });
            dg.AddRow(rowHeaders[7], new object[] { 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 });
            dg.AddRow(rowHeaders[8], new object[] { 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 });
            dg.AddRow(rowHeaders[9], new object[] { 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 });

        }


        private void Btn_Click(object sender, RoutedEventArgs e)
        {
            //int row = dg.GetRowIndex(sender);
            //int col = dg.GetColumnIndex(sender);
            //Console.WriteLine($"Row: {row}, Column: {col}");

            //var test = dg.GetChildren(typeof(SgzButton));

            DataGridColumnHeadersPresenter headersPresenter = Helpers.GetVisualChildren<DataGridColumnHeadersPresenter>(dg).ToArray()[0];
            Console.WriteLine(headersPresenter.ActualHeight);
        }

        



        void LunchSecondWnd()
        {
            Window1 wnd = new Window1();
            wnd.Show();
        }


    }
}
