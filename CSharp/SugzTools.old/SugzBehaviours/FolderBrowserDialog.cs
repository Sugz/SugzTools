using System.Windows;
using System.Windows.Forms;
using System.Windows.Interactivity;
using Button = System.Windows.Controls.Button;

namespace SugzBehaviours
{
    /// <summary>
    /// Behaviour to open 
    /// </summary>
    public class FolderBrowserDialog : Behavior<Button>
    {
        #region Attached Behavior wiring
        protected override void OnAttached()
        {
            base.OnAttached();
            AssociatedObject.Click += OnClick;
        }

        protected override void OnDetaching()
        {
            AssociatedObject.Click -= OnClick;
            base.OnDetaching();
        }
        #endregion

        #region FolderName Dependency Property
        public static readonly DependencyProperty FolderName =
                DependencyProperty.RegisterAttached("FolderName", typeof(string), typeof(FolderBrowserDialog));


        public static string GetFolderName(DependencyObject obj)
        {
            return (string)obj.GetValue(FolderName);
        }

        public static void SetFolderName(DependencyObject obj, string value)
        {
            obj.SetValue(FolderName, value);
        }
        #endregion

        private void OnClick(object sender, RoutedEventArgs e)
        {
            var dialog = new System.Windows.Forms.FolderBrowserDialog();
            var currentPath = GetValue(FolderName) as string;
            dialog.SelectedPath = currentPath;
            var result = dialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                SetValue(FolderName, dialog.SelectedPath);
            }
        }
    }
}
