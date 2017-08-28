using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Shapes;

namespace SugzTools.Converters
{
    public class DockToAlignmentConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (values[0] is Dock dock && values[1] is Rectangle rectangle)
            {
                switch (dock)
                {
                    case Dock.Left:
                        rectangle.HorizontalAlignment = HorizontalAlignment.Left;
                        rectangle.VerticalAlignment = VerticalAlignment.Stretch;
                        rectangle.Width = 2;
                        break;
                    case Dock.Top:
                        rectangle.HorizontalAlignment = HorizontalAlignment.Stretch;
                        rectangle.VerticalAlignment = VerticalAlignment.Top;
                        rectangle.Height = 2;
                        break;
                    case Dock.Right:
                        rectangle.HorizontalAlignment = HorizontalAlignment.Right;
                        rectangle.VerticalAlignment = VerticalAlignment.Stretch;
                        rectangle.Width = 2;
                        break;
                    case Dock.Bottom:
                        rectangle.HorizontalAlignment = HorizontalAlignment.Stretch;
                        rectangle.VerticalAlignment = VerticalAlignment.Bottom;
                        rectangle.Height = 2;
                        break;
                    default:
                        break;
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
