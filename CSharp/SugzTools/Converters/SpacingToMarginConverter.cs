﻿using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;

namespace SugzTools.Converters
{
    public class SpacingToMarginConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value != null && parameter != null)
            {
                if ((Side)parameter == Side.Right)
                    return new Thickness(System.Convert.ToDouble(value), 0, 0, 0);
                return new Thickness(0, 0, System.Convert.ToDouble(value), 0);
            }

            return new Thickness(0);
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
