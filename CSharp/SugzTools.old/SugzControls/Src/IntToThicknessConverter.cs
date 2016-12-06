using System;
using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace SugzControls.Src
{
    public class IntToThicknessConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is int)
            {
                switch (parameter.ToString())
                {
                    case "NS": return new Thickness((int)value, 0, (int)value, 0);
                    case "WE": return new Thickness(0, (int)value, 0, (int)value);
                }
            }

            return new Thickness();
        }


        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return null;
        }
    }
}