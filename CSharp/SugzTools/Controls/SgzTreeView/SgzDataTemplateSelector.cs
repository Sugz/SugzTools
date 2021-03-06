﻿using System;
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
            if (container is FrameworkElement element && item.GetType() is Type type)
            {
                // Check for current type and parent type
                while (!Templates.ContainsKey(type))
                {
                    // Look type interfaces
                    Type[] types = Templates.Keys.Intersect(type.GetInterfaces()).ToArray();
                    if (types.Length != 0)
                    {
                        type = types[0];
                        break;
                    }

                    if (type.BaseType == typeof(object))
                        return null;
                    type = type.BaseType;
                }
                return Templates[type];
            }

            return null;
        }

    }
}
