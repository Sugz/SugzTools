using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace SugzTools.Converters
{
    public class CornerRadiusLessThicknessConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (values != null)
                return new CornerRadius(((CornerRadius)values[0]).TopLeft - ((Thickness)values[1]).Left);

            return null;
        }

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value != null && parameter != null)
                return new CornerRadius((double)value - System.Convert.ToDouble(parameter));

            return null;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
