using SugzControls.Controls;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Data;

namespace SugzControls.Src
{
    public class ButtonTypeToOrientationConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            switch ((ButtonType)value)
            {
                case ButtonType.Icon: return Orientation.Horizontal;
                case ButtonType.Text: return Orientation.Vertical;
                case ButtonType.IconAndText: return Orientation.Vertical;
            }

            return Orientation.Vertical;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
