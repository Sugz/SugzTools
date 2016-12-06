using System;
using System.Globalization;
using System.Windows.Data;

namespace SgzControls.Converters
{
    public class LabelWidthConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value != null && parameter != null)
                return (double)value - System.Convert.ToInt32(parameter);
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
