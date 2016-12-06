using System;
using System.Globalization;
using System.Windows.Data;

namespace SugzTools.Converters
{
    public class ValueMinusConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value != null && parameter != null)
                return (double)value - System.Convert.ToDouble(parameter);
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
