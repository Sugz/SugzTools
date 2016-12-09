using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace SugzTools.Converters
{
    public class CornerRadiusMultiplierConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value != null && value is CornerRadius && parameter != null)
            {
                double topLeft = ((CornerRadius)value).TopLeft * System.Convert.ToDouble(parameter);
                double topRight = ((CornerRadius)value).TopRight * System.Convert.ToDouble(parameter);
                double bottomLeft = ((CornerRadius)value).BottomLeft * System.Convert.ToDouble(parameter);
                double bottomRight = ((CornerRadius)value).BottomRight * System.Convert.ToDouble(parameter);
                return new CornerRadius(topLeft, topRight, bottomRight, bottomLeft);
            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
