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



            ObservableCollection<TempModel> models = new ObservableCollection<TempModel>()
            {
                new TempModel(1, "First", true),
                new TempModel(2, "Second", false)
            };





            //listBox.ItemsSource = models;
            listBox.HorizontalContentAlignment = HorizontalAlignment.Stretch;
            listBox.AddColumn(PropertyUI.Checkbox, "Valid");
            listBox.AddColumn(PropertyUI.Checkbutton, "Use", width:20);
            listBox.AddRow(new object[] { false, false });
            listBox.AddRow(new object[] { true, false });
            listBox.AddRow(new object[] { false, true });
            listBox.AddRow(new object[] { true, true });
        }
    }
}
