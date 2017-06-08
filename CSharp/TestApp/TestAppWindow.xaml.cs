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

            //SetUpDataGrid();

            SetUpTV();

            DockPanel panel = new DockPanel();
            SgzIcon icon = new SgzIcon();
            DockPanel.SetDock(icon, Dock.Left);
            SgzButton btn = new SgzButton();
            DockPanel.SetDock(btn, Dock.Right);
            TextBlock txt = new TextBlock();
            DockPanel.SetDock(txt, Dock.Left);

            panel.Children.Add(icon);
            panel.Children.Add(btn);
            panel.Children.Add(txt);

            GetTemplate(panel);
        }

        private void SetUpTV()
        {

            #region Templates


            //Binding nameBinding = new Binding("Name") { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };
            //Binding childrenBinding = new Binding("Children") { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };



            Dictionary<DependencyProperty, string> dict = new Dictionary<DependencyProperty, string> { { TextBlock.TextProperty, "Name" } };

            DockPanel layerPanel = new DockPanel();
            SgzIcon layerIcon = new SgzIcon() { Icon = Geo.MdiViewSequential, Width = 12, Height = 12, VerticalAlignment = VerticalAlignment.Center };
            layerIcon.Click += (s, e) => Console.WriteLine("************\nPressed from Layer !!\n************");
            TextBlock layerTxt = new TextBlock() { Foreground = new SolidColorBrush(Colors.Red), VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(5,0,0,0) };
            FrameworkElementFactory[] layerFactories = new FrameworkElementFactory[]
            {
                TemplateGenerator.GetFrameworkElementFactory(layerIcon),
                TemplateGenerator.GetFrameworkElementFactory(layerTxt, dict)
            };


            DockPanel nodePanel = new DockPanel();
            SgzIcon nodeIcon = new SgzIcon() { Icon = Geo.MdiWebpack, Width = 12, Height = 12, VerticalAlignment = VerticalAlignment.Center };
            nodeIcon.Click += (s, e) => Console.WriteLine("************\nPressed from Node !!\n************");
            TextBlock nodeTxt = new TextBlock() { Foreground = new SolidColorBrush(Colors.Blue), VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(5, 0, 0, 0) };
            FrameworkElementFactory[] nodeFactories = new FrameworkElementFactory[]
            {
                TemplateGenerator.GetFrameworkElementFactory(nodeIcon),
                TemplateGenerator.GetFrameworkElementFactory(nodeTxt, dict)
            };


            tv.AddTemplate(typeof(Layer), TemplateGenerator.GetTemplate(layerPanel, layerFactories, true));
            tv.AddTemplate(typeof(Node), TemplateGenerator.GetTemplate(nodePanel, nodeFactories));

            #endregion Templates


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


        private void GetTemplate(DependencyObject obj)
        {
            List<DependencyObject> objects = new List<DependencyObject>();
            Helpers.GetLogicalChildren(obj, objects);
            //objects.ForEach(x => Console.WriteLine(x.GetType()));
            foreach (DependencyObject o in objects)
            {

            }
        }



        /*
        private void SetUpDataGrid()
        {
            //SgzButton btn = new SgzButton();
            //btn.Margin = new Thickness(1);
            //btn.VerticalAlignment = VerticalAlignment.Stretch;
            //btn.Height = Double.NaN;
            //btn.Click += Btn_Click; ;

            dg.ModelFileName = @"d:\test.cs";


            dg.AddUsing("System.Windows.Media", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll");
            dg.AddUsing("", @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll");
            dg.AddUsing("SugzTools", @"D:\Travail\GitHub\SugzTools\CSharp\SugzTools\bin\Debug\SugzTools.dll");

            //DependencyProperty[] props = new DependencyProperty[1] { ContentProperty };
            //string[] columnProps = new string[10] { "f10", "f14", "f20", "f28", "f40", "f56", "f80", "f11", "f16", "f22" };
            //string[] columnHeaders = new string[10] { "f/1.0", "f/1.4", "f/2.0", "f/2.8", "f/4.0", "f/5.6", "f/8.0", "f/11", "f/16", "f/22" };
            //for (int i = 0; i < columnHeaders.Length; i++)
            //    dg.AddColumn(btn, props, typeof(int), columnProps[i], columnHeaders[i], true);

            //string[] rowHeaders = new string[10] { "1 sec", "1/2 sec", "1/4 sec", "1/8 sec", "1/15 sec", "1/30 sec", "1/60 sec", "1/125 sec", "1/250 sec", "1/500 sec" };
            //dg.AddRow(rowHeaders[0], new object[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 });
            //dg.AddRow(rowHeaders[1], new object[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 });
            //dg.AddRow(rowHeaders[2], new object[] { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 });
            //dg.AddRow(rowHeaders[3], new object[] { 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 });
            //dg.AddRow(rowHeaders[4], new object[] { 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 });
            //dg.AddRow(rowHeaders[5], new object[] { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 });
            //dg.AddRow(rowHeaders[6], new object[] { 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 });
            //dg.AddRow(rowHeaders[7], new object[] { 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 });
            //dg.AddRow(rowHeaders[8], new object[] { 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 });
            //dg.AddRow(rowHeaders[9], new object[] { 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 });

            //DependencyProperty[] props = new DependencyProperty[1] { ContentProperty };
            //dg.AddColumn(btn, props, typeof(int), "col1", "f/1.0", true);
            //dg.AddColumn(btn, props, typeof(int), "col2", "f/1.4", true);

            //DependencyProperty[] bgProps = new DependencyProperty[1] { BackgroundProperty };
            //dg.AddProperty(bgProps, typeof(SolidColorBrush), "col1Background", false, 0);
            //dg.AddProperty(bgProps, typeof(SolidColorBrush), "col2Background", false, 1);

            //DependencyProperty[] fgProps = new DependencyProperty[1] { ForegroundProperty };
            //dg.AddProperty(fgProps, typeof(SolidColorBrush), "Foreground", false);

            //string[] rowHeaders = new string[] { "1 sec", "1/2 sec", "1/4 sec" };
            //SolidColorBrush[] colors = new SolidColorBrush[] { new SolidColorBrush(Colors.Blue), new SolidColorBrush(Colors.Green), new SolidColorBrush(Colors.Red) };
            //dg.AddRow(rowHeaders[0], new object[] { 0, 1, colors[0], colors[1], colors[2] });
            //dg.AddRow(rowHeaders[1], new object[] { 1, 2, colors[0], colors[1], colors[2] });
            //dg.AddRow(rowHeaders[2], new object[] { 2, 3, colors[0], colors[1], colors[2] });





            TextBlock txt = new TextBlock();

            dg.AddColumn(txt, "Name");
            dg.AddProperty(typeof(Temp), "Node", false);

            DependencyProperty[] props = new DependencyProperty[] { TextBlock.TextProperty };
            dg.AddBindings(props, "Node.Name", 0);

            Temp node1 = new Temp() { Name = "Object 01" };
            Temp node2 = new Temp() { Name = "Object 02" };
            Temp node3 = new Temp() { Name = "Object 03" };
            dg.AddRow(new object[] { node1 });
            dg.AddRow(new object[] { node2 });
            dg.AddRow(new object[] { node3 });

        }
        */

        private void Btn_Click(object sender, RoutedEventArgs e)
        {
            //int row = dg.GetRowIndex(sender);
            //int col = dg.GetColumnIndex(sender);
            //Console.WriteLine($"Row: {row}, Column: {col}");

            //var test = dg.GetChildren(typeof(SgzButton));

            //DataGridColumnHeadersPresenter headersPresenter = Helpers.GetVisualChildren<DataGridColumnHeadersPresenter>(dg).ToArray()[0];

            //Console.WriteLine(headersPresenter.ActualHeight);


        }

        



        void LunchSecondWnd()
        {
            Window1 wnd = new Window1();
            wnd.Show();
        }


    }
}
