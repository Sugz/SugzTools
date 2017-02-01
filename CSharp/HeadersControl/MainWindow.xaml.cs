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

namespace HeadersControl
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Random random = new Random();

            for (int i = 0; i < 20; i++)
            {
                StackPanel panel = new StackPanel();
                panel.Margin = new Thickness(5);
                
                panel.Height = random.Next(50, 100);

                SgzExpanderItem expander = new SgzExpanderItem();
                expander.Header = $"Expander {i}";
                expander.Content = panel;

                //ExpandersControl.Items.Add(expander);
            }
        }
    }
}
