using SugzTools.Src;
using Autodesk.Max;
using SugzTools.Behaviors;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzGrid : Grid
    {

        #region Constructors


        public SgzGrid()
        {
            
        }


        #endregion Constructors



        #region Methods


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
            AddColumn(width, GridUnitType.Pixel, 0, double.PositiveInfinity);
        }
        public void AddColumn(double width, double minWidth)
        {
            AddColumn(width, GridUnitType.Pixel, minWidth, double.PositiveInfinity);
        }
        public void AddColumn(double width, double minWidth, double maxWidth)
        {
            AddColumn(width, GridUnitType.Pixel, minWidth, maxWidth);
        }

        /// <summary>
        /// Add a column to the grid given the GridUnitType using a width of 1
        /// </summary>
        /// <param name="gridUnitType"></param>
        public void AddColumn(GridUnitType gridUnitType)
        {
            AddColumn(1, gridUnitType, 0, double.PositiveInfinity);
        }
        public void AddColumn(GridUnitType gridUnitType, double minWidth)
        {
            AddColumn(1, gridUnitType, minWidth, double.PositiveInfinity);
        }
        public void AddColumn(GridUnitType gridUnitType, double minWidth, double maxWidth)
        {
            AddColumn(1, gridUnitType, minWidth, maxWidth);
        }

        /// <summary>
        /// Add a column to the grid
        /// </summary>
        /// <param name="width">The width of the column</param>
        /// <param name="type">The GridUnitType of the column</param>
        public void AddColumn(double width, GridUnitType gridUnitType)
        {
            AddColumn(width, gridUnitType, 0, double.PositiveInfinity);
        }
        public void AddColumn(double width, GridUnitType gridUnitType, double minWidth)
        {
            AddColumn(width, gridUnitType, minWidth, double.PositiveInfinity);
        }
        public void AddColumn(double width, GridUnitType gridUnitType, double minWidth, double maxWidth)
        {
            ColumnDefinition column = new ColumnDefinition()
            {
                Width = (gridUnitType == GridUnitType.Auto) ? GridLength.Auto : new GridLength(width, gridUnitType),
                MinWidth = minWidth,
                MaxWidth = maxWidth
            };
            ColumnDefinitions.Add(column);
        }


        public void SetColumn(int columnIndex, double width)
        {
            SetColumn(columnIndex, width, GridUnitType.Pixel, 0, double.PositiveInfinity);
        }
        public void SetColumn(int columnIndex, double width, double minWidth)
        {
            SetColumn(columnIndex, width, GridUnitType.Pixel, minWidth, double.PositiveInfinity);
        }
        public void SetColumn(int columnIndex, double width, double minWidth, double maxWidth)
        {
            SetColumn(columnIndex, width, GridUnitType.Pixel, minWidth, maxWidth);
        }

        public void SetColumn(int columnIndex, GridUnitType gridUnitType)
        {
            SetColumn(columnIndex, 1, gridUnitType, 0, double.PositiveInfinity);
        }
        public void SetColumn(int columnIndex, GridUnitType gridUnitType, double minWidth)
        {
            SetColumn(columnIndex, 1, gridUnitType, minWidth, double.PositiveInfinity);
        }
        public void SetColumn(int columnIndex, GridUnitType gridUnitType, double minWidth, double maxWidth)
        {
            SetColumn(columnIndex, 1, gridUnitType, minWidth, maxWidth);
        }

        public void SetColumn(int columnIndex, double width, GridUnitType gridUnitType)
        {
            ColumnDefinitions[columnIndex].Width = new GridLength(width, gridUnitType);
        }
        public void SetColumn(int columnIndex, double width, GridUnitType gridUnitType, double minWidth)
        {
            ColumnDefinitions[columnIndex].Width = new GridLength(width, gridUnitType);
            ColumnDefinitions[columnIndex].MinWidth = minWidth;
        }
        public void SetColumn(int columnIndex, double width, GridUnitType gridUnitType, double minWidth, double maxWidth)
        {
            ColumnDefinitions[columnIndex].Width = new GridLength(width, gridUnitType);
            ColumnDefinitions[columnIndex].MinWidth = minWidth;
            ColumnDefinitions[columnIndex].MaxWidth = maxWidth;
        }

        public void SetColumnMin(int columnIndex, double width)
        {
            ColumnDefinitions[columnIndex].MinWidth = width;
        }
        public void SetColumnMax(int columnIndex, double width)
        {
            ColumnDefinitions[columnIndex].MaxWidth = width;
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

        public void SetRow(int rowIndex, double height)
        {
            SetRow(rowIndex, height, GridUnitType.Pixel);
        }
        public void SetRow(int rowIndex, GridUnitType gridUnitType)
        {
            SetRow(rowIndex, 1, gridUnitType);
        }
        public void SetRow(int rowIndex, double height, GridUnitType gridUnitType)
        {
            RowDefinitions[rowIndex].Height = new GridLength(height, gridUnitType);
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
                AddColumn(1, GridUnitType.Auto);
            while (row > 0 && RowDefinitions.Count < row + 1)
                AddRow(1, GridUnitType.Auto);

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

        public void AddInColumn(FrameworkElement child, int column, int columnSpan,  double width, GridUnitType widthUnit)
        {

        }


        public void Add(FrameworkElement child, int column, int row, double width)
        {

        }
        public void Add(FrameworkElement child, int column, int row, GridUnitType unit)
        {

        }
        public void Add(FrameworkElement child, int column, int row, double width, GridUnitType widthUnit, double height, GridUnitType heightUnit)
        {

        }
        public void Add(FrameworkElement child, int column, int columnSpan, int row, int rowSpan, double width)
        {

        }
        public void Add(FrameworkElement child, int column, int columnSpan, int row, int rowSpan, GridUnitType unit)
        {

        }
        public void Add(FrameworkElement child, int column, int columnSpan, int row, int rowSpan, double width, GridUnitType widthUnit, double height, GridUnitType heightUnit)
        {
            //Add column and row if needed

            //while (column > 0 && ColumnDefinitions.Count < column)
            //    AddColumn(width, widthUnit);
            //while (row > 0 && RowDefinitions.Count < row)
            //    AddRow(height, heightUnit);


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


        #endregion Methods

    }
}

//TODO: public void Add(FrameworkElement child, int column, int columnSpan, int row, int rowSpan, double width, GridUnitType unit)
//TODO: porter les methods columns pour les rows