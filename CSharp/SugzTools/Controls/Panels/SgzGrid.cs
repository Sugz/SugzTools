using SugzTools.Src;
using SugzTools.Behaviors;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzGrid : Grid
    {

        #region Properties


        public Thickness InnerMargin { get; set; } = new Thickness(0);


        #endregion Properties



        #region Constructors


        public SgzGrid()
        {
            Loaded += SetChildrenMargin;
        }


        #endregion Constructors



        #region Methods


        #region Private


        /// <summary>
        /// Modify the Margin for the panel's children
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SetChildrenMargin(object sender, RoutedEventArgs e)
        {
            Helpers.SetChildrenMargin(this, InnerMargin);
            Loaded -= SetChildrenMargin;
        }


        #endregion Private


        #region Public


        /// <summary>
        /// Add a column to the grid using GridUnitType.Auto
        /// </summary>
        public void AddColumn()
        {
            AddColumn(double.NaN, GridUnitType.Auto);
        }
        /// <summary>
        /// Add a column to the grid using GridUnitType.Pixel
        /// </summary>
        /// <param name="width">The width of the column</param>
        public void AddColumn(double width)
        {
            AddColumn(width, GridUnitType.Pixel);
        }
        /// <summary>
        /// Add a column to the grid given the GridUnitType using a width of 1
        /// </summary>
        /// <param name="gridUnitType"></param>
        public void AddColumn(GridUnitType gridUnitType)
        {
            AddColumn(1, gridUnitType);
        }
        /// <summary>
        /// Add a column to the grid
        /// </summary>
        /// <param name="width">The width of the column</param>
        /// <param name="type">The GridUnitType of the column</param>
        public void AddColumn(double width, GridUnitType gridUnitType)
        {
            ColumnDefinition column = new ColumnDefinition();
            column.Width = (gridUnitType == GridUnitType.Auto) ? GridLength.Auto : new GridLength(width, gridUnitType);
            ColumnDefinitions.Add(column);
        }


        /// <summary>
        /// Add a row to the grid using GridUnitType.Auto
        /// </summary>
        public void AddRow()
        {
            AddRow(double.NaN, GridUnitType.Auto);
        }
        /// <summary>
        /// Add a row to the grid using GridUnitType.Pixel
        /// </summary>
        /// <param name="height">The height of the column</param>
        public void AddRow(double height)
        {
            AddRow(height, GridUnitType.Pixel);
        }
        /// <summary>
        /// Add a row to the grid given the GridUnitType using a height of 1
        /// </summary>
        /// <param name="gridUnitType"></param>
        public void AddRow(GridUnitType gridUnitType)
        {
            AddRow(1, gridUnitType);
        }
        /// <summary>
        /// Add a row to the grid
        /// </summary>
        /// <param name="height">The height of the column</param>
        /// <param name="type">The GridUnitType of the column</param>
        public void AddRow(double height, GridUnitType gridUnitType)
        {
            RowDefinition row = new RowDefinition();
            row.Height = (gridUnitType == GridUnitType.Auto) ? GridLength.Auto : new GridLength(height, gridUnitType);
            RowDefinitions.Add(row);
        }


        /// <summary>
        /// Add a children
        /// </summary>
        /// <param name="child"></param>
        public void Add(FrameworkElement child)
        {
            Children.Add(child);
        }
        /// <summary>
        /// Add a children in specified column and row
        /// </summary>
        /// <param name="child"></param>
        /// <param name="column"></param>
        /// <param name="row"></param>
        public void Add(FrameworkElement child, int column, int row)
        {
            Add(child, column, 1, row, 1);
        }
        /// <summary>
        /// Add a children in specified column and row with specified column span and row span
        /// </summary>
        /// <param name="child"></param>
        /// <param name="column"></param>
        /// <param name="columnSpan"></param>
        /// <param name="row"></param>
        /// <param name="rowSpan"></param>
        public void Add(FrameworkElement child, int column, int columnSpan, int row, int rowSpan)
        {
            //Add column and row if needed
            while (column > 0 && ColumnDefinitions.Count < column + 1)
                AddColumn(1, GridUnitType.Star);
            while (row > 0 && RowDefinitions.Count < row + 1)
                AddRow(1, GridUnitType.Star);

            // if the columnSpan or rowSpan is more than one, set height or width to double.Nan
            if (columnSpan > 1)
                child.Width = double.NaN;
            if (rowSpan > 1)
                child.Height = double.NaN;

            // Add the child 
            Children.Add(child);
            SetColumn(child, column);
            SetColumnSpan(child, columnSpan);
            SetRow(child, row);
            SetRowSpan(child, rowSpan);

            

        }


        #endregion Public


        #endregion Methods

    }
}
