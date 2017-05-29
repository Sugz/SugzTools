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

        public MainWindow()
        {
            InitializeComponent();


            rightPanelWidth = rightPanel.ActualWidth;
            //dg.SelectionChanged += (s, e) => ((DataGrid)s).UnselectAllCells();
        }

        private void Grid_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            Console.WriteLine(grid.ActualWidth);
            //Console.WriteLine(txt.ActualWidth);
        }
    }
}
