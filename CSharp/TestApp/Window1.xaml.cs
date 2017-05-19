using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace TestApp
{
    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Window1 : Window
    {
        public ObservableCollection<People> Peoples { get; set; }

        public Window1()
        {
            InitializeComponent();

            listBox.HorizontalContentAlignment = HorizontalAlignment.Stretch;

            listBox.AddColumn(PropertyUI.Checkbox, "Valid");
            listBox.AddColumn(PropertyUI.Checkbutton, "Use", "", width: 20);
            listBox.AddColumn(PropertyUI.Textblock, "Text");
            listBox.AddRow(new object[] { false, false, "Test 01" });
            listBox.AddRow(new object[] { true, false, "Test 02" });
            listBox.AddRow(new object[] { false, true, "Test 03" });
            listBox.AddRow(new object[] { true, true, "Test 04" });
            listBox.AddRow(new object[] { true, true, "Test 05" });
            listBox.AddRow(new object[] { true, true, "Test 06" });
            listBox.AddRow(new object[] { true, true, "Test 07" });
            listBox.AddRow(new object[] { true, true, "Test 08" });
            listBox.AddRow(new object[] { true, true, "Test 09" });
            listBox.AddRow(new object[] { true, true, "Test 10" });
            listBox.AddRow(new object[] { true, true, "Test 11" });


            dg.RowBackground = new SolidColorBrush(Colors.Transparent);
            dg.ModelFileName = @"d:\SampleCode.cs";

            bool _on = dg.AddColumn(PropertyUI.Checkbox, "On");
            bool _use = dg.AddColumn(PropertyUI.Checkbutton, "Use","", width: 10);
            bool _new = dg.AddColumn(PropertyUI.Textblock, "New", unitType: DataGridLengthUnitType.Star);
            if (_on && _use && _new)
            {
                dg.AddRow(new object[] { false, false, "Test 01" });
                dg.AddRow(new object[] { true, false, "Test 02" });
                dg.AddRow(new object[] { false, true, "Test 03" });
                dg.AddRow(new object[] { true, true, "Test 04" });
                dg.AddRow(new object[] { true, true, "Test 05" });
                dg.AddRow(new object[] { true, true, "Test 06" });
                dg.AddRow(new object[] { true, true, "Test 07" });
                dg.AddRow(new object[] { true, true, "Test 08" });
                dg.AddRow(new object[] { true, true, "Test 09" });
                dg.AddRow(new object[] { true, true, "Test 10" });
                dg.AddRow(new object[] { true, true, "Test 11" });
            }

            
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            ChangeDataGrid();
        }


        private void ChangeListView()
        {
            bool val = Convert.ToBoolean(listBox.GetProperty(0, "Valid"));
            listBox.SetProperty(0, "Valid", !val);
            listBox.SetProperty(0, "Text", "Working");

            Console.WriteLine();
        }


        private void ChangeDataGrid()
        {
            //dg.IsSelectable = !dg.IsSelectable;

            //bool val = Convert.ToBoolean(dg.GetProperty(0, "Use"));
            //dg.SetProperty(0, "Use", !val);
            //dg.SetProperty(0, "Text", "Working");

            Console.WriteLine(dg.GetProperty(0, 0));
            Console.WriteLine(dg.GetProperty(0, "Use"));
        }
    }
}
