using SugzTools.Temp;
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

        public MainWindow()
        {
            Node node1 = new Node() { Name = "Node 01" };
            Node node2 = new Node() { Name = "Node 02" };

            Layer layer01 = new Layer()
            {
                Name = "Layer 01",
                Nodes = new ObservableCollection<Node>() { node1, node2 }
            };

            Layer layer02 = new Layer()
            {
                Name = "Layer 02",
                Nodes = new ObservableCollection<Node>() { node1, node2 },
                Layers = new ObservableCollection<Layer>() { layer01 }
            };

            ObservableCollection<Layer> Layers = new ObservableCollection<Layer>() { layer01, layer02 };

            tv.ItemsSource = Layers;
        }

    }
}
