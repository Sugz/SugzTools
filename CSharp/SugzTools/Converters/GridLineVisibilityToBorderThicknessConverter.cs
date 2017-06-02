using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace SugzTools.Converters
{
    public class GridLineVisibilityToBorderThicknessConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value != null && value is DataGridGridLinesVisibility)
            {
                switch((DataGridGridLinesVisibility)value)
                {
                    case DataGridGridLinesVisibility.All:
                        return new Thickness(0, 0, 1, 1);
                    case DataGridGridLinesVisibility.Horizontal:
                        return new Thickness(0, 0, 0, 1);
                    case DataGridGridLinesVisibility.Vertical:
                        return new Thickness(0, 0, 1, 0);
                    case DataGridGridLinesVisibility.None:
                        return new Thickness(0, 0, 0, 0);
                }
            }
            return new Thickness(0, 0, 1, 1);
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
