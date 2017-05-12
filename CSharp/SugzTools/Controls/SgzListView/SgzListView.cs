using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzListView : ListView
    {

        #region Fields


        private GridView gridView;
        private object Model;
        private ClassGenerator classGen = new ClassGenerator();
        private ObservableCollection<object> _Rows = new ObservableCollection<object>();


        #endregion Fields



        #region Properties


        /// <summary>
        /// Get the collection of the generated model
        /// </summary>
        [Browsable(false)]
        public ObservableCollection<object> Rows { get { return _Rows; } } 


        #endregion Properties



        #region Constructors


        public SgzListView()
        {
            View = (gridView = new GridView());
            ItemsSource = _Rows;
            Style = Resource<Style>.GetStyle("SgzListView");
        }


        #endregion Constructors



        #region Methods


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
                    //classGen.AddProperty(PropertyType.String, name, true);
                    classGen.AddProperty(typeof(string), name, readOnly);
                    factory.Type = typeof(TextBlock);
                    factory.SetValue(TextBlock.ForegroundProperty, Resource<SolidColorBrush>.GetColor("MaxText"));
                    factory.SetValue(TextBlock.FontFamilyProperty, new FontFamily("Tahoma"));
                    factory.SetValue(TextBlock.FontSizeProperty, 11d);
                    factory.SetValue(HorizontalAlignmentProperty, HorizontalAlignment.Left);
                    factory.SetBinding(TextBlock.TextProperty, new Binding(name));
                    break;
                case PropertyUI.Textbox:
                    break;
                case PropertyUI.ComboBox:
                    break;
                default:
                    break;
            }

            gridView.Columns.Add(new GridViewColumn()
            {
                Header = name,
                Width = width != 0 ? width : double.NaN,
                CellTemplate = new DataTemplate() { VisualTree = factory }
            });

        }


        public void AddRow(object[] args)
        {
            if (Model == null)
                Model = classGen.GetClass();

            object row = Activator.CreateInstance(Model.GetType(), args);
            _Rows.Add(row);
        } 


        #endregion Methods

    }
}
