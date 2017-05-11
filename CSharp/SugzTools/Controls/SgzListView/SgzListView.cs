using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace SugzTools.Controls
{
    public class SgzListView : ListView
    {
        #region Fields


        GridView gridView = new GridView();
        ClassGenerator classGen = new ClassGenerator();
        object Model;
        ObservableCollection<object> _ItemSource = new ObservableCollection<object>();


        #endregion Fields




        #region Constructors


        static SgzListView()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzListView), new FrameworkPropertyMetadata(typeof(SgzListView)));
        }
        public SgzListView()
        {
            Loaded += SgzListView_Loaded;
        }



        #endregion Constructors


        private void SgzListView_Loaded(object sender, RoutedEventArgs e)
        {
            View = gridView;
            ItemsSource = _ItemSource;

            //Style style = new Style() { TargetType = typeof(ListViewItem) };
            //style.Setters.Add(new Setter(HorizontalContentAlignmentProperty, HorizontalAlignment.Stretch));
            //ItemContainerStyle = style;
        }



        public void AddProperty(PropertyType type, PropertyUI ui)
        {
            // Check if the ui is compatible with the type
            if (type == PropertyType.Bool && (ui != PropertyUI.Checkbox || ui != PropertyUI.Checkbutton))
                return;
            if ((type == PropertyType.Int || type == PropertyType.Float) && ui != PropertyUI.Spinner)
                return;
            if (type == PropertyType.String && (ui != PropertyUI.Textblock || ui != PropertyUI.Textbox))
                return;
            if (type == PropertyType.List && ui != PropertyUI.ComboBox)
                return;


            //classGen.AddProperties(typeof(double), "Value", true);
            //classGen.AddProperties(typeof(string), "Name", false);
            //var MyClass = classGen.GenerateCSharpCode();

        }



        public void AddColumn(PropertyUI control, string name, bool readOnly = false, double width = 0)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory();
            switch (control)
            {
                case PropertyUI.Checkbox:
                    classGen.AddProperty(PropertyType.Bool, name, readOnly);
                    factory.Type = typeof(SgzCheckBox);
                    factory.SetBinding(SgzCheckBox.IsCheckedProperty, new Binding(name));
                    factory.SetValue(SgzCheckBox.HorizontalAlignmentProperty, HorizontalAlignment.Center);
                    break;
                case PropertyUI.Checkbutton:
                    classGen.AddProperty(PropertyType.Bool, name, readOnly);
                    factory.Type = typeof(SgzCheckButton);
                    factory.SetValue(HorizontalAlignmentProperty, HorizontalAlignment.Stretch);
                    factory.SetBinding(SgzCheckButton.IsCheckedProperty, new Binding(name));
                    break;
                case PropertyUI.Spinner:
                    break;
                case PropertyUI.Textblock:
                    break;
                case PropertyUI.Textbox:
                    break;
                case PropertyUI.ComboBox:
                    break;
                default:
                    break;
            }

            GridViewColumn column = new GridViewColumn()
            {
                Header = name,
                Width = width != 0 ? width : double.NaN,
                CellTemplate = new DataTemplate() { VisualTree = factory }
            };

            gridView.Columns.Add(column);
        }


        public void AddRow(object[] args)
        {
            if (Model == null)
                Model = classGen.GetClass();

            var row = Activator.CreateInstance(Model.GetType(), args);
            _ItemSource.Add(row);
        }
        


        //private void SetModel()
        //{

        //}

    }
}
