using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace StyleApp
{
    public class MyListView : ListView
    {

        GridView gridView = new GridView();

        static MyListView()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(MyListView), new FrameworkPropertyMetadata(typeof(MyListView)));
        }
        public MyListView()
        {
            View = gridView;
            gridView.Columns.Add(SetColumns("Name"));
            gridView.Columns.Add(SetColumns("Age"));
            gridView.Columns.Add(SetColumns("Mail"));

            List<User> items = new List<User>
            {
                new User() { Name = "John Doe", Age = 42, Mail = "john@doe-family.com" },
                new User() { Name = "Jane Doe", Age = 39, Mail = "jane@doe-family.com" },
                new User() { Name = "Sammy Doe", Age = 7, Mail = "sammy.doe@gmail.com" }
            };
            ItemsSource = items;
        }

        private GridViewColumn SetColumns(string name)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory(typeof(TextBlock));
            factory.SetBinding(TextBlock.TextProperty, new Binding(name));
            return new GridViewColumn()
            {
                Header = name,
                CellTemplate = new DataTemplate() { VisualTree = factory }
            };
        }


    }
}
