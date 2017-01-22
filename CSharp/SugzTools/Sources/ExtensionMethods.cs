using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Src
{
    public static class ExtensionMethods
    {

        /// <summary>
        /// Add ForEach method for ItemCollection
        /// </summary>
        /// <param name="items"></param>
        /// <param name="action"></param>
        public static void ForEach(this ItemCollection items, Action<object> action)
        {
            foreach (object item in items)
                action(item);
        }


    }
}
