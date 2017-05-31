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
using System.Windows.Threading;

namespace StyleApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        class People
        {
            public string Name { get; set; }
            public int Age { get; set; }
        }


        ObservableCollection<People> Peoples;

        public MainWindow()
        {
            InitializeComponent();

            Peoples = new ObservableCollection<People>()
            {
                new People() { Name = "Test 01", Age = 21 },
                new People() { Name = "Test 02", Age = 18 },
            };


            dg.ItemsSource = Peoples;
        }

    }
}
