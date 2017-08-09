using System;
using System.Globalization;
using System.Windows.Data;

namespace SugzTools.Converters
{
    public class MultiplyPercentageConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (values != null)
            {
                if (values.Length > 1)
                    return (double)values[0] * ((double)values[1] / 100.0);
                else
                {
                    return (double)values[0] * (System.Convert.ToDouble(parameter) / 100);
                }
                    
            }

            return null;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }

    }
}
