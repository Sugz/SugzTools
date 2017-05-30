using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzDataGrid : DataGrid
    {

        #region Fields


        //HorizontalAlignment OldHorizontalAlignment;
        private Type Model;
        private ModelGenerator classGen = new ModelGenerator(Helpers.NameGenerator());
        private ObservableCollection<object> Rows = new ObservableCollection<object>();


        #endregion Fields


        #region Properties

        public string ModelFileName { get; set; } = null;


        /// <summary>
        /// Get or set if a row or a cell can be selected.
        /// </summary>
        [Description("Get or set if a row or a cell can be selected."), Category("Common")]
        public bool IsSelectable
        {
            get { return (bool)GetValue(IsSelectableProperty); }
            set { SetValue(IsSelectableProperty, value); }
        }


        /// <summary>
        /// Get or set the headers background color.
        /// </summary>
        [Description("Get or set the headers background color."), Category("Brush")]
        public Brush HeaderBackground
        {
            get { return (Brush)GetValue(HeaderBackgroundProperty); }
            set { SetValue(HeaderBackgroundProperty, value); }
        }


        /// <summary>
        /// Get or set the headers foreground color.
        /// </summary>
        [Description("Get or set the headers foreground color."), Category("Brush")]
        public Brush HeaderForeground
        {
            get { return (Brush)GetValue(HeaderForegroundProperty); }
            set { SetValue(HeaderForegroundProperty, value); }
        }


        /// <summary>
        /// Get or set the column header HorizontalAlignment.
        /// </summary>
        [Description("Get or set the column header HorizontalAlignment."), Category("Layout")]
        public HorizontalAlignment HeaderHorizontalAlignment
        {
            get { return (HorizontalAlignment)GetValue(HeaderHorizontalAlignmentProperty); }
            set { SetValue(HeaderHorizontalAlignmentProperty, value); }
        }


        #endregion Properties


        #region Dependency Properties


        // DependencyProperty as the backing store for IsSelectable
        public static readonly DependencyProperty IsSelectableProperty = DependencyProperty.Register(
            "IsSelectable",
            typeof(bool),
            typeof(SgzDataGrid),
            new PropertyMetadata(false)//, OnIsSelectableChanged)
        );


        // DependencyProperty as the backing store for HeaderBackground
        public static readonly DependencyProperty HeaderBackgroundProperty = DependencyProperty.Register(
            "HeaderBackground",
            typeof(Brush),
            typeof(SgzDataGrid),
            new PropertyMetadata(new SolidColorBrush(Colors.Transparent))
        );


        // DependencyProperty as the backing store for HeaderForeground
        public static readonly DependencyProperty HeaderForegroundProperty = DependencyProperty.Register(
            "HeaderForeground",
            typeof(Brush),
            typeof(SgzDataGrid),
            new PropertyMetadata(new SolidColorBrush(Colors.Black))
        );


        // DependencyProperty as the backing store for HeaderHorizontalAlignment
        public static readonly DependencyProperty HeaderHorizontalAlignmentProperty = DependencyProperty.Register(
            "HeaderHorizontalAlignment",
            typeof(HorizontalAlignment),
            typeof(SgzDataGrid),
            new PropertyMetadata(HorizontalAlignment.Left)
        );


        #endregion Dependency Properties


        #region Constructors


        static SgzDataGrid()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDataGrid), new FrameworkPropertyMetadata(typeof(SgzDataGrid)));
        }
        public SgzDataGrid()
        {
            
            //Loaded += SgzDataGrid_Loaded;
            ItemsSource = Rows;
        }


        #endregion Constructors


        #region Methods


        public void AddUsing(string name, string url = null)
        {
            classGen.AddUsing(name, url);
        }


        /// <summary>
        /// Add a column with the specified control type.
        /// </summary>
        /// <param name="control">The control type.</param>
        /// <param name="name">The Property and column header name.</param>
        /// <param name="readOnly">Define if the user can change by code the contain model.</param>
        /// <param name="dataGridLengthUnitType">The column length unit type.</param>
        /// <param name="width">The column width.</param>
        /// <param name="showHeader">Define if the column header has a name</param>
        public bool AddColumn(
            PropertyUI control, 
            string propertyName, 
            string headerName = null,
            bool readOnly = false, 
            DataGridLengthUnitType unitType = DataGridLengthUnitType.Auto,  
            double width = 0)
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
                    factory.SetValue(VerticalAlignmentProperty, VerticalAlignment.Center);
                    factory.SetBinding(TextBlock.TextProperty, binding);
                    break;
                case PropertyUI.Textbox:
                    break;
                case PropertyUI.ComboBox:
                    break;
                default:
                    break;
            }

            DataGridTemplateColumn column = new DataGridTemplateColumn();
            column.Header = headerName ?? propertyName;
            column.CellTemplate = new DataTemplate() { VisualTree = factory };
            column.MinWidth = 1;

            if (unitType == DataGridLengthUnitType.Star && width == 0)
                column.Width = new DataGridLength(1, unitType);
            else if (unitType == DataGridLengthUnitType.Auto && width != 0)
                column.Width = new DataGridLength(width, DataGridLengthUnitType.Pixel);
            else column.Width = new DataGridLength(width, unitType);

            Columns.Add(column);
            return true;
        }


        public bool AddColumn(
            FrameworkElement control,
            DependencyProperty property,
            Type propertyType,
            string propertyName,
            string headerName = null,
            bool readOnly = false,
            DataGridLengthUnitType unitType = DataGridLengthUnitType.Auto,
            double width = 0)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory();
            Binding binding = new Binding(propertyName) { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };

            if (!classGen.AddProperty(propertyType, propertyName, readOnly))
                return false;
            factory.Type = control.GetType();
            factory.SetBinding(property, binding);

            DataGridTemplateColumn column = new DataGridTemplateColumn();
            column.Header = headerName ?? propertyName;
            column.CellTemplate = new DataTemplate() { VisualTree = factory };
            column.MinWidth = 1;

            if (unitType == DataGridLengthUnitType.Star && width == 0)
                column.Width = new DataGridLength(1, unitType);
            else if (unitType == DataGridLengthUnitType.Auto && width != 0)
                column.Width = new DataGridLength(width, DataGridLengthUnitType.Pixel);
            else column.Width = new DataGridLength(width, unitType);

            Columns.Add(column);
            return true;
        }


        public bool AddColumn(
            FrameworkElement control,
            DependencyProperty[] properties,
            Type propertyType,
            string propertyName,
            string headerName = null,
            bool readOnly = false,
            DataGridLengthUnitType unitType = DataGridLengthUnitType.Auto,
            double width = 0)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory();
            Binding binding = new Binding(propertyName) { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };

            if (!classGen.AddProperty(propertyType, propertyName, readOnly))
                return false;
            factory.Type = control.GetType();
            properties.ForEach(property => factory.SetBinding((DependencyProperty)property, binding));

            IEnumerable<DependencyProperty> dep = Helpers.GetDependencyProperties(control).Concat(Helpers.GetAttachedProperties(control));
            dep.ForEach(x => factory.SetValue((DependencyProperty)x, control.GetValue((DependencyProperty)x)));

            //factory.AddHandler()

            DataGridTemplateColumn column = new DataGridTemplateColumn();
            column.Header = headerName ?? propertyName;
            column.CellTemplate = new DataTemplate() { VisualTree = factory };
            column.MinWidth = 1;

            if (unitType == DataGridLengthUnitType.Star && width == 0)
                column.Width = new DataGridLength(1, unitType);
            else if (unitType == DataGridLengthUnitType.Auto && width != 0)
                column.Width = new DataGridLength(width, DataGridLengthUnitType.Pixel);
            else column.Width = new DataGridLength(width, unitType);

            Columns.Add(column);
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


        public void ClearRows()
        {
            Rows.Clear();
        }



        /// <summary>
        /// Get the model property value from a row
        /// </summary>
        /// <param name="rowIndex">The row to get the property from.</param>
        /// <param name="propName">The property's name.</param>
        /// <returns></returns>
        public object GetProperty(int rowIndex, string propName)
        {
            PropertyInfo prop = Model.GetType().GetProperty(propName);
            return prop.GetValue(Rows[rowIndex]);
        }

        /// <summary>
        /// Get the model property value from a row
        /// </summary>
        /// <param name="rowIndex">The row to get the property from.</param>
        /// <param name="propIndex">The property's index.</param>
        /// <returns></returns>
        public object GetProperty(int rowIndex, int propIndex)
        {
            PropertyInfo[] props = Model.GetType().GetProperties();
            return props[propIndex].GetValue(Rows[rowIndex]);
        }


        /// <summary>
        /// Set the model property value from a row to update the datagrid
        /// </summary>
        /// <param name="rowIndex">The row to set the property</param>
        /// <param name="propName">The name of the property.</param>
        /// <param name="newValue">The property's new value.</param>
        public void SetProperty(int rowIndex, string propName, object newValue)
        {
            PropertyInfo prop = Model.GetType().GetProperty(propName);
            prop.SetValue(Rows[rowIndex], newValue);
        }

        /// <summary>
        /// Set the model property value from a row to update the datagrid
        /// </summary>
        /// <param name="rowIndex">The row to set the property</param>
        /// <param name="propIndex">The property's index</param>
        /// <param name="newValue">The property's new value.</param>
        public void SetProperty(int rowIndex, int propIndex, object newValue)
        {
            PropertyInfo[] props = Model.GetType().GetProperties();
            props[propIndex].SetValue(Rows[rowIndex], newValue);
        }


        #endregion Methods

    }
}


//TODO: SelectedRow background
//TODO: HeaderColumn  Style, prendre la vrai DataGridHeaderBorder