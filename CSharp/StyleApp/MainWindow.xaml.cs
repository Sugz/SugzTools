﻿using System;
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

namespace StyleApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
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
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
