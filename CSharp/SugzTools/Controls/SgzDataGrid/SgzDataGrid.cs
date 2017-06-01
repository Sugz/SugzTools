using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Media;
using BF = System.Reflection.BindingFlags;

namespace SugzTools.Controls
{
    //[TemplatePart(Name = "DG_ScrollViewer", Type = typeof(ScrollViewer))]
    //[TemplatePart(Name = "PART_ColumnHeadersPresenter", Type = typeof(ScrollContentPresenter))]
    public class SgzDataGrid : DataGrid
    {

        #region Fields

        //private ScrollViewer DG_ScrollViewer;
        //private ScrollContentPresenter PART_ColumnHeadersPresenter;
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
        /// 
        /// </summary>
        [Description(""), Category("Brush")]
        public Brush HeaderHoverBrush
        {
            get { return (Brush)GetValue(HeaderHoverBrushProperty); }
            set { SetValue(HeaderHoverBrushProperty, value); }
        }

        // DependencyProperty as the backing store for HeaderHoverBrush
        public static readonly DependencyProperty HeaderHoverBrushProperty = DependencyProperty.Register(
            "HeaderHoverBrush",
            typeof(Brush),
            typeof(SgzDataGrid),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver"))
        );


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("")]
        // [Browsable(false)]
        public Brush HeaderPressedBrush
        {
            get { return (Brush)GetValue(HeaderPressedBrushProperty); }
            set { SetValue(HeaderPressedBrushProperty, value); }
        }

        // DependencyProperty as the backing store for HeaderPressedBrush
        public static readonly DependencyProperty HeaderPressedBrushProperty = DependencyProperty.Register(
            "HeaderPressedBrush",
            typeof(Brush),
            typeof(SgzDataGrid),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlueMouseOver"))
        );






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
            ItemsSource = Rows;

            EnableRowStretch();
            SizeChanged += (s, e) => EnableRowStretch();
        }

        /*
        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            if (GetTemplateChild("DG_ScrollViewer") is ScrollViewer scrollViewer)
            {
                ScrollContentPresenter scrollContentPresenter = scrollViewer.Template.FindName("PART_ColumnHeadersPresenter", scrollViewer) as ScrollContentPresenter;
                if (scrollContentPresenter != null)
                {
                    PART_ColumnHeadersPresenter = scrollContentPresenter;
                    EnableRowStretch();
                    SizeChanged += (s, e) => EnableRowStretch();
                }
            }
        }
        */

        #endregion Constructors


        #region Methods


        /// <summary>
        /// Set the row height to stretch
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void EnableRowStretch()
        {
            if (VerticalAlignment == VerticalAlignment.Stretch && VerticalContentAlignment == VerticalAlignment.Stretch)
                RowHeight = (ActualHeight - BorderThickness.Top - BorderThickness.Bottom - ColumnHeaderHeight - 5) / Rows.Count;
            //if (VerticalAlignment == VerticalAlignment.Stretch && VerticalContentAlignment == VerticalAlignment.Stretch)
            //    RowHeight = PART_ColumnHeadersPresenter.ActualHeight / Rows.Count;
        }

        /// <summary>
        /// Transfer each properties and events handlers from the model to the factory
        /// </summary>
        /// <param name="control"></param>
        /// <param name="factory"></param>
        private void SetFactory(FrameworkElement model, FrameworkElementFactory factory)
        {
            // Transfer properties of the control to the factory
            IEnumerable<DependencyProperty> dep = Helpers.GetDependencyProperties(model).Concat(Helpers.GetAttachedProperties(model));
            dep.ForEach(x => factory.SetValue((DependencyProperty)x, model.GetValue((DependencyProperty)x)));

            // Transfer event handlers of the control to the factory
            FieldInfo[] fields = model.GetType().GetFields(BF.Static | BF.NonPublic | BF.Instance | BF.Public | BF.FlattenHierarchy);
            foreach (FieldInfo field in fields.Where(x => x.FieldType == typeof(RoutedEvent)))
            {
                RoutedEventHandlerInfo[] routedEventHandlerInfos = Helpers.GetRoutedEventHandlers(model, (RoutedEvent)field.GetValue(model));
                if (routedEventHandlerInfos != null)
                {
                    foreach (RoutedEventHandlerInfo routedEventHandlerInfo in routedEventHandlerInfos)
                        factory.AddHandler((RoutedEvent)field.GetValue(model), routedEventHandlerInfo.Handler);
                }
            }
        }

        /// <summary>
        /// Create and populate the column
        /// </summary>
        /// <param name="factory"></param>
        /// <param name="unitType"></param>
        /// <param name="width"></param>
        /// <param name="propertyName"></param>
        /// <param name="headerName"></param>
        /// <returns></returns>
        private DataGridTemplateColumn CreateColumn(FrameworkElementFactory factory, DataGridLengthUnitType unitType, double width, string propertyName = null, string headerName = null, bool canSort = true)
        {
            DataGridTemplateColumn column = new DataGridTemplateColumn();
            column.Header = headerName ?? propertyName;
            column.CanUserSort = canSort;
            column.SortMemberPath = propertyName;
            column.CellTemplate = new DataTemplate() { VisualTree = factory };
            column.MinWidth = 1;


            if (unitType == DataGridLengthUnitType.Star && width == 0)
                column.Width = new DataGridLength(1, unitType);
            else if (unitType == DataGridLengthUnitType.Auto && width != 0)
                column.Width = new DataGridLength(width, DataGridLengthUnitType.Pixel);
            else column.Width = new DataGridLength(width, unitType);

            return column;
        }


        public void AddUsing(string name, string url = null)
        {
            classGen.AddUsing(name, url);
        }


        /*
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
            DataGridLengthUnitType unitType = DataGridLengthUnitType.Star,  
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
        */

        public bool AddColumn(FrameworkElement control, string headerName, DataGridLengthUnitType unitType = DataGridLengthUnitType.Star, double width = 0)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory() { Type = control.GetType() };
            SetFactory(control, factory);
            Columns.Add(CreateColumn(factory, unitType, width, headerName));
            return true;
        }

        public bool AddColumn(
            FrameworkElement model,
            DependencyProperty[] properties,
            object propertyType,
            string propertyName,
            string headerName,
            bool readOnly,
            DataGridLengthUnitType unitType = DataGridLengthUnitType.Star,
            double width = 0)
        {
            // Set the model property and the binding
            if (!(propertyType is Type))
                propertyType = propertyType.GetType();

            if (!classGen.AddProperty((Type)propertyType, propertyName, readOnly))
                return false;

            FrameworkElementFactory factory = new FrameworkElementFactory() { Type = model.GetType() };
            Binding binding = new Binding(propertyName) { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };
            properties.ForEach(property => factory.SetBinding((DependencyProperty)property, binding));


            SetFactory(model, factory);
            Columns.Add(CreateColumn(factory, unitType, width, propertyName, headerName));
            return true;
        }



        public void AddRow()
        {
            AddRow(null, new object[0]);
        }

        public void AddRow(string headerName)
        {
            AddRow(headerName, new object[0]);
        }

        /// <summary>
        /// Add a row using the model created with the AddColumn method.
        /// </summary>
        /// <param name="args">The model properties values</param>
        public void AddRow(object[] args)
        {
            AddRow(null, args);
        }

        public void AddRow(string headerName, object[] args)
        {
            // Set the header
            if (headerName != null)
            {
                classGen.AddProperty(typeof(string), "RowHeader", false);
                Array.Resize(ref args, args.Length + 1);
                args[args.Length - 1] = headerName;
            }

            // Create the model the first time
            if (Model == null)
                Model = classGen.GetClassType(ModelFileName);

            if (Model != null)
            {
                // Check if the parameters count and types are ok (add the header to the args count)
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


        public int GetRowIndex(object sender) { return Rows.IndexOf(SelectedCells[0].Item); }

        public int GetColumnIndex(object sender) { return CurrentCell.Column.DisplayIndex; }


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


        public object[] GetChildren(Type type)
        {
            IEnumerable<DependencyObject> children = Helpers.GetVisualChildren<DependencyObject>(this).ToArray();
            return children.Where(x => x.GetType() == type).ToArray();
        }


        #endregion Methods

    }
}


//TODO: SelectedRow background
//TODO: HeaderColumn  Style, prendre la vrai DataGridHeaderBorder