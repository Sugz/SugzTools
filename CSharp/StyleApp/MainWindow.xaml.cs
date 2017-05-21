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
        double leftPanelWidth;
        double rightPanelWidth;
        public ObservableCollection<People> Peoples { get; set; }

        public MainWindow()
        {
            InitializeComponent();

            Peoples = new ObservableCollection<People>()
            {
                new People() { Name = "The first one", Age=21 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },
                new People() { Name = "The second one", Age=16 },

            };

            DataContext = this;

            rightPanelWidth = rightPanel.ActualWidth;
            //dg.SelectionChanged += (s, e) => ((DataGrid)s).UnselectAllCells();
        }



        private void Button_Click(object sender, RoutedEventArgs e)
        {

        }

        private void sgzCheckButton_Click(object sender, RoutedEventArgs e)
        {
            if ((bool)sgzCheckButton.IsChecked)
            {
                mainGrid.ColumnDefinitions[0].Width = new GridLength(mainGrid.ActualWidth);
                Grid.SetColumnSpan(leftPanel, 1);
                rightPanel.Visibility = gridSplitter.Visibility = Visibility.Visible;
                Width += rightPanelWidth + 5;
            }
            else
            {
                rightPanelWidth = rightPanel.ActualWidth;
                rightPanel.Visibility = gridSplitter.Visibility = Visibility.Collapsed;
                Width -= rightPanelWidth + 5;
                Grid.SetColumnSpan(leftPanel, 3);
            }
        }
    }
}
