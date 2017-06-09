using SugzTools;
using SugzTools.Controls;
using SugzTools.Icons;
using SugzTools.Temp;
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

        //private ObservableCollection<SugzTools.Test> _Tests;
        //public ObservableCollection<SugzTools.Test> Tests
        //{
        //    get { return _Tests; }
        //    set { _Tests = value; }
        //}



        public MainWindow()
        {
            InitializeComponent();

            SetUpDataGrid();

            SetUpTV();

        }

        private void SetUpTV()
        {

            #region Templates

            Dictionary<DependencyProperty, string> dict = new Dictionary<DependencyProperty, string> { { TextBlock.TextProperty, "Name" } };

            SgzIcon layerIcon = new SgzIcon() { Icon = Geo.MdiViewSequential, Width = 12, Height = 12, VerticalAlignment = VerticalAlignment.Center };
            DockPanel.SetDock(layerIcon, Dock.Left);
            layerIcon.Click += (s, e) => Console.WriteLine("************\nPressed from Layer !!\n************");
            TextBlock layerTxt = new TextBlock() { Foreground = Resource<SolidColorBrush>.GetColor("MaxText"), VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(5,0,0,1) };
            FrameworkElementFactory[] layerFactories = new FrameworkElementFactory[]
            {
                TemplateGenerator.GetFrameworkElementFactory(layerIcon),
                TemplateGenerator.GetFrameworkElementFactory(layerTxt, dict)
            };


            SgzIcon nodeIcon = new SgzIcon() { Icon = Geo.MdiWebpack, Width = 12, Height = 12, VerticalAlignment = VerticalAlignment.Center };
            nodeIcon.Click += (s, e) => Console.WriteLine("************\nPressed from Node !!\n************");
            TextBlock nodeTxt = new TextBlock() { Foreground = Resource<SolidColorBrush>.GetColor("MaxText"), VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(5,0,0,1) };
            FrameworkElementFactory[] nodeFactories = new FrameworkElementFactory[]
            {
                TemplateGenerator.GetFrameworkElementFactory(nodeIcon),
                TemplateGenerator.GetFrameworkElementFactory(nodeTxt, dict)
            };


            tv.AddTemplate(typeof(Layer), TemplateGenerator.GetHierarchicalTemplate(new DockPanel(), layerFactories));
            tv.AddTemplate(typeof(Node), TemplateGenerator.GetTemplate(new DockPanel(), nodeFactories));


            #endregion Templates



            #region ItemsSource


            Node node1 = new Node() { Name = "Node 01" };
            Node node2 = new Node() { Name = "Node 02" };
            Node node3 = new Node() { Name = "Node 03" };
            Node node4 = new Node() { Name = "Node 04" };
            Node node5 = new Node() { Name = "Node 05" };
            Node node6 = new Node() { Name = "Node 06" };

            Layer layer01 = new Layer()
            {
                Name = "Layer 01",
                Children = new ObservableCollection<object>() { node1, node2 }
            };

            Layer layer03 = new Layer()
            {
                Name = "Layer 03",
                Children = new ObservableCollection<object>() { node5, node6 },
            };

            Layer layer02 = new Layer()
            {
                Name = "Layer 02",
                Children = new ObservableCollection<object>() { layer03, node3, node4 },
            };

            

            ObservableCollection<object> Layers = new ObservableCollection<object>() { layer01, layer02 };

            tv.ItemsSource = Layers; 


            #endregion ItemsSource

        }



        
        private void SetUpDataGrid()
        {
            dg.ModelFileName = @"d:\test.cs";

            dg.AddUsing("System.Windows.Media", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll");
            dg.AddUsing("", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll");
            dg.AddUsing("SugzTools.Temp", @"D:\Travail\GitHub\SugzTools\CSharp\SugzTools\bin\Debug\SugzTools.dll");


            TextBlock txt = new TextBlock() { VerticalAlignment = VerticalAlignment.Center, HorizontalAlignment = HorizontalAlignment.Center };

            dg.AddColumn(txt, "Name");
            dg.AddColumn(txt, "Name");
            dg.AddProperty(typeof(Node), "Node", false);

            DependencyProperty[] props = new DependencyProperty[] { TextBlock.TextProperty };
            dg.AddBindings(props, "Node.Name", 0);
            dg.AddBindings(props, "Node.Name", 1);

            Node node1 = new Node() { Name = "Object 01" };
            Node node2 = new Node() { Name = "Object 02" };
            Node node3 = new Node() { Name = "Object 03" };
            dg.AddRow(new object[] { node1 });
            dg.AddRow(new object[] { node2 });
            dg.AddRow(new object[] { node3 });

        }
        


        void LunchSecondWnd()
        {
            Window1 wnd = new Window1();
            wnd.Show();
        }


    }
}
