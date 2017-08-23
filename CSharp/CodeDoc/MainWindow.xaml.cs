using System.Windows;
using CodeDoc.ViewModel;
using CodeDoc.Properties;

namespace CodeDoc
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        /// <summary>
        /// Initializes a new instance of the MainWindow class.
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();
            Closing += (s, e) => ViewModelLocator.Cleanup();

            if (Settings.Default.UpgradeRequired)
            {
                Settings.Default.Upgrade();
                //Settings.Default.UpgradeRequired = false;
                Settings.Default.Save();
            }
        }
    }
}