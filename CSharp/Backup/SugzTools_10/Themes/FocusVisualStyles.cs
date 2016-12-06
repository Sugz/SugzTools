using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Markup;
using System.Windows.Media;

namespace SugzTools.Themes
{
    public static class FocusVisualStyles
    {

        public static Style GetControlStyle(int cornerRadius)
        {
            return GetControlStyle(cornerRadius, 2);
        }

        public static Style GetControlStyle(int cornerRadius, int margin)
        {
            string styleStr = "<Style xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'>" +
                "<Setter Property = \"Control.Template\"> " +
                    "<Setter.Value> " +
                        "<ControlTemplate> " +
                            "<Rectangle Margin = \"" + margin + "\" " +
                                        "Stroke = \"" + Resource<SolidColorBrush>.GetColor("MaxFocusBorder") + "\" " +
                                        "StrokeThickness = \"1\" " +
                                        "StrokeDashArray = \"1 2\" " +
                                        "RadiusX = \"" + cornerRadius + "\" " +
                                        "RadiusY = \"" + cornerRadius + "\" " +
                                        "SnapsToDevicePixels = \"True\" " +
                                        "UseLayoutRounding = \"True\" /> " +
                        "</ControlTemplate> " +
                   " </Setter.Value> " +
                "</Setter> " +
            "</Style>";

            return (Style)XamlReader.Parse(styleStr);
        }

    }
}
