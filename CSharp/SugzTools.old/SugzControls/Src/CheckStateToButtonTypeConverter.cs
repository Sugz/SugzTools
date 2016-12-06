using SugzControls.Controls;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace SugzControls.Src
{
    public class CheckStateToButtonTypeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            switch((ButtonType)value)
            {
                case ButtonType.Icon: return false;
                case ButtonType.Text : return true;
                case ButtonType.IconAndText : return null;
            }

            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            switch ((bool?)value)
            {
                case false: return ButtonType.Icon;
                case true: return ButtonType.Text;
                case null: return ButtonType.IconAndText;
            }

            return ButtonType.IconAndText;
        }
    }
}
