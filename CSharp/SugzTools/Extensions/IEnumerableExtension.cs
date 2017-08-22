using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Extensions
{
    public static class IEnumerableExtension
    {
        /// <summary>
        /// ForEach method for IEnumerable
        /// </summary>
        /// <param name="items"></param>
        /// <param name="action"></param>
        public static void ForEach(this IEnumerable items, Action<object> action)
        {
            foreach (object item in items)
                action(item);
        }

        /// <summary>
        /// ForEach<T> method for IEnumerable
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="items"></param>
        /// <param name="action"></param>
        public static void ForEach<T>(this IEnumerable<T> items, Action<T> action)
        {
            foreach (T item in items)
                action(item);
        }
    }
}
