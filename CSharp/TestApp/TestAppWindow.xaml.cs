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
            btn.Click += Btn_Click; ;

            dg.ModelFileName = @"d:\test.cs";

            dg.AddUsing("System.Windows.Media", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll");
            dg.AddUsing("", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll");

            string[] columnHeaders = new string[10] { "f/1.0", "f/1.4", "f/2.0", "f/2.8", "f/4.0", "f/5.6", "f/8.0", "f/11", "f/16", "f/22" };
            string[] rowHeaders = new string[10] { "1 sec", "1/2 sec", "1/4 sec", "1/8 sec", "1/15 sec", "1/30 sec", "1/60 sec", "1/125 sec", "1/250 sec", "1/500 sec" };

            for (int i = 0; i < columnHeaders.Length; i++)
                dg.AddColumn(btn, columnHeaders[i]);

            for (int i = 0; i < rowHeaders.Length; i++)
                dg.AddRow(rowHeaders[i]);
        }


        private void Btn_Click(object sender, RoutedEventArgs e)
        {
            //int row = dg.GetRowIndex(sender);
            //int col = dg.GetColumnIndex(sender);
            //Console.WriteLine($"Row: {row}, Column: {col}");

            var test = dg.GetChildren(typeof(SgzButton));
        }

        



        void LunchSecondWnd()
        {
            Window1 wnd = new Window1();
            wnd.Show();
        }


    }
}
