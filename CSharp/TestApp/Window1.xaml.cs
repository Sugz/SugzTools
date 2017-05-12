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
        public Window1()
        {
            InitializeComponent();

            //listBox.HorizontalContentAlignment = HorizontalAlignment.Stretch;

            listBox.AddColumn(PropertyUI.Checkbox, "Valid");
            listBox.AddColumn(PropertyUI.Checkbutton, "Use", width: 20);
            listBox.AddColumn(PropertyUI.Textblock, "Text");
            listBox.AddRow(new object[] { false, false, "Test 01" });
            listBox.AddRow(new object[] { true, false, "Test 02" });
            listBox.AddRow(new object[] { false, true, "Test 03" });
            listBox.AddRow(new object[] { true, true, "Test 04" });
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            bool val = Convert.ToBoolean(listBox.GetProperty(0, "Valid"));
            listBox.SetProperty(0, "Valid", !val);
            listBox.SetProperty(0, "Text", "Working");

            Console.WriteLine();
        }
    }
}
