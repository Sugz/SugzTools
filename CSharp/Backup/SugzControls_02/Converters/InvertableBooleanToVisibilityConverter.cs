using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;

namespace SgzControls.Converters
{
    [ValueConversion(typeof(bool), typeof(Visibility))]
    public class InvertableBooleanToVisibilityConverter : IValueConverter
    {
        enum Parameter
        {
            Normal,
            Inverted
        }

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            Parameter direction = Parameter.Normal;
            if (parameter != null)
                direction = (Parameter)Enum.Parse(typeof(Parameter), (string)parameter);


            if (direction == Parameter.Inverted)
                return !(bool)value ? Visibility.Visible : Visibility.Collapsed;

            return (bool)value ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is Visibility)
                return ((Visibility)value) == Visibility.Visible;
            return false;
        }
    }
}
