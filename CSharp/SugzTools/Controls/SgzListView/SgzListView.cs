using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Reflection;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzListView : ListView
    {

        #region Fields


        private GridView gridView = new GridView();
        private Type Model;
        private ModelGenerator classGen = new ModelGenerator(Helpers.NameGenerator());
        private ObservableCollection<object> _Rows = new ObservableCollection<object>();


        #endregion Fields



        #region Properties


        public string ModelFileName { get; set; } = null;


        /// <summary>
        /// Get the collection of the generated model
        /// </summary>
        [Browsable(false)]
        public ObservableCollection<object> Rows { get { return _Rows; } }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Appearance")]
        public bool ShowHeaders
        {
            get { return (bool)GetValue(ShowHeadersProperty); }
            set { SetValue(ShowHeadersProperty, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Appearance")]
        public bool Resizable
        {
            get { return (bool)GetValue(ResizableProperty); }
            set { SetValue(ResizableProperty, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Brush")]
        public Brush HeaderBackground
        {
            get { return (Brush)GetValue(HeaderBackgroundProperty); }
            set { SetValue(HeaderBackgroundProperty, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Brush")]
        public Brush HeaderForeground
        {
            get { return (Brush)GetValue(HeaderForegroundProperty); }
            set { SetValue(HeaderForegroundProperty, value); }
        }

        
        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Brush")]
        public Brush RowHoverBrush
        {
            get { return (Brush)GetValue(RowHoverBrushProperty); }
            set { SetValue(RowHoverBrushProperty, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Brush")]
        public Brush RowSelectedBrush
        {
            get { return (Brush)GetValue(RowSelectedBrushProperty); }
            set { SetValue(RowSelectedBrushProperty, value); }
        } 


        #endregion Properties



        #region DependencyProperties


        // DependencyProperty as the backing store for ShowHeaders
        public static readonly DependencyProperty ShowHeadersProperty = DependencyProperty.Register(
            "ShowHeaders",
            typeof(bool),
            typeof(SgzListView),
            new PropertyMetadata(true)
        );


        // DependencyProperty as the backing store for Resizable
        public static readonly DependencyProperty ResizableProperty = DependencyProperty.Register(
            "Resizable",
            typeof(bool),
            typeof(SgzListView),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for HeaderBackground
        public static readonly DependencyProperty HeaderBackgroundProperty = DependencyProperty.Register(
            "HeaderBackground",
            typeof(Brush),
            typeof(SgzListView),
            new PropertyMetadata(new SolidColorBrush(Colors.Transparent))
        );


        // DependencyProperty as the backing store for HeaderForeground
        public static readonly DependencyProperty HeaderForegroundProperty = DependencyProperty.Register(
            "HeaderForeground",
            typeof(Brush),
            typeof(SgzListView),
            new PropertyMetadata(new SolidColorBrush(Colors.Black))
        );


        // DependencyProperty as the backing store for RowHoverBrush
        public static readonly DependencyProperty RowHoverBrushProperty = DependencyProperty.Register(
            "RowHoverBrush",
            typeof(Brush),
            typeof(SgzListView),
            new PropertyMetadata(new SolidColorBrush(Colors.Transparent))
        );


        // DependencyProperty as the backing store for RowSelectedBrush
        public static readonly DependencyProperty RowSelectedBrushProperty = DependencyProperty.Register(
            "RowSelectedBrush",
            typeof(Brush),
            typeof(SgzListView),
            new PropertyMetadata(new SolidColorBrush(Colors.Transparent))
        ); 


        #endregion DependencyProperties



        #region Constructors


        public SgzListView()
        {
            View = gridView;
            ItemsSource = _Rows;
            Style = Resource<Style>.GetStyle("SgzListView");
        }


        #endregion Constructors



        #region Methods

        /// <summary>
        /// Add a column with the specified control type.
        /// </summary>
        /// <param name="control">The control.</param>
        /// <param name="name">The Property and column header name.</param>
        /// <param name="readOnly">Define if the user can change by code the contain model.</param>
        /// <param name="width">The column width.</param>
        public bool AddColumn(PropertyUI control, string propertyName, string headerName = null, bool readOnly = false, double width = 0)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory();
            Binding binding = new Binding(propertyName) { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };
            switch (control)
            {
                case PropertyUI.Checkbox:
                    if (!classGen.AddProperty(typeof(bool), propertyName, readOnly))
                        return false;

                    factory.Type = typeof(SgzCheckBox);
                    factory.SetBinding(SgzCheckBox.IsCheckedProperty, binding);
                    factory.SetValue(SgzCheckBox.HorizontalAlignmentProperty, HorizontalAlignment.Center);
                    break;
                case PropertyUI.Checkbutton:
                    if (!classGen.AddProperty(typeof(bool), propertyName, readOnly))
                        return false;

                    factory.Type = typeof(SgzCheckButton);
                    factory.SetValue(HorizontalAlignmentProperty, HorizontalAlignment.Stretch);
                    factory.SetBinding(SgzCheckButton.IsCheckedProperty, binding);
                    break;
                case PropertyUI.Spinner:
                    break;
                case PropertyUI.Textblock:
                    if (!classGen.AddProperty(typeof(string), propertyName, readOnly))
                        return false;

                    factory.Type = typeof(TextBlock);
                    factory.SetValue(TextBlock.ForegroundProperty, Resource<SolidColorBrush>.GetColor("MaxText"));
                    factory.SetValue(TextBlock.FontFamilyProperty, new FontFamily("Tahoma"));
                    factory.SetValue(TextBlock.FontSizeProperty, 11d);
                    factory.SetValue(HorizontalAlignmentProperty, HorizontalAlignment.Left);
                    factory.SetBinding(TextBlock.TextProperty, binding);
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
                Header = headerName ?? propertyName,
                Width = width != 0 ? width : double.NaN,
                CellTemplate = new DataTemplate() { VisualTree = factory }
            });

            return true;
        }

        /// <summary>
        /// Add a row using the model created with the AddColumn method.
        /// </summary>
        /// <param name="args">The model properties values</param>
        public void AddRow(object[] args)
        {
            if (Model == null)
                Model = classGen.GetClassType(ModelFileName);

            if (Model != null)
            {
                // Check if the parameters count and types are ok
                ParameterInfo[] _params = Model.GetConstructors()[0].GetParameters();
                if (args.Length != _params.Length)
                    return;

                for (int i = 0; i < _params.Length; i++)
                {
                    if (args[i].GetType() != _params[i].ParameterType)
                        return;
                }

                // Instanciate the model and add it to the collection.
                object row = Activator.CreateInstance(Model, args);
                Rows.Add(row);
            }
        }

        /// <summary>
        /// Get the model property value from a row
        /// </summary>
        /// <param name="rowIndex">The row to get the property from.</param>
        /// <param name="propName">The name of the property.</param>
        /// <returns></returns>
        public object GetProperty(int rowIndex, string propName)
        {
            PropertyInfo prop = Rows[0].GetType().GetProperty(propName);
            return prop.GetValue(Rows[0]);
        }

        /// <summary>
        /// Set the model property value from a row to update the listview
        /// </summary>
        /// <param name="rowIndex">The row to set the property</param>
        /// <param name="propName">The name of the property.</param>
        /// <param name="newValue">The property new value.</param>
        public void SetProperty(int rowIndex, string propName, object newValue)
        {
            PropertyInfo prop = Rows[0].GetType().GetProperty(propName);
            prop.SetValue(Rows[0], newValue);
        }


        #endregion Methods

    }
}
