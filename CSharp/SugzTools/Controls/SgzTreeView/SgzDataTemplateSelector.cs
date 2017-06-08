using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzDataTemplateSelector : DataTemplateSelector
    {
        public Dictionary<Type, DataTemplate> Templates { get; set; } = new Dictionary<Type, DataTemplate>();

        public override DataTemplate SelectTemplate(object item, DependencyObject container)
        {
            if (container is FrameworkElement element && item != null)
                return Templates[item.GetType()];

            return null;
        }

    }
}
