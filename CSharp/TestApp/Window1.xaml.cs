using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
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
        public ObservableCollection<Country> Countries { get; set; }

        public Window1()
        {
            InitializeComponent();

            Countries = new ObservableCollection<Country>()
            {
                new Country() {Name = "Sweden", Continent= "Europe"},
                new Country() {Name = "England", Continent= "Europe"},
                new Country() {Name = "USA", Continent= "America"},
            };

            DataContext = this;

            //SetRowHeaderTemplate();
        }

        //private void SetRowHeaderTemplate()
        //{
        //    Binding binding = new Binding("DataContext.Continent")
        //    {
        //        RelativeSource = new RelativeSource(RelativeSourceMode.FindAncestor, typeof(DataGridRow), 1)
        //    };

        //    FrameworkElementFactory factory = new FrameworkElementFactory();
        //    factory.Type = typeof(TextBlock);
        //    factory.SetValue(TextBlock.ForegroundProperty, Resource<SolidColorBrush>.GetColor("MaxText"));
        //    factory.SetValue(TextBlock.FontFamilyProperty, new FontFamily("Tahoma"));
        //    factory.SetValue(TextBlock.FontSizeProperty, 11d);
        //    factory.SetValue(HorizontalAlignmentProperty, HorizontalAlignment.Left);
        //    factory.SetValue(VerticalAlignmentProperty, VerticalAlignment.Center);
        //    factory.SetBinding(TextBlock.TextProperty, binding);

        //    dg.RowHeaderTemplate = new DataTemplate() { VisualTree = factory };
        //}


        public class Country
        {
            public string Name { get; set; }
            public string Continent { get; set; }
        }
    }
}
