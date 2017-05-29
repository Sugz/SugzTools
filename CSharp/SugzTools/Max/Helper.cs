using Autodesk.Max;
using SugzTools.Src;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Max
{
    public static class Helper
    {
        /// <summary>
        /// Check if an object has a method
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="method"></param>
        /// <returns></returns>
        public static bool HasMethod(object obj, string method)
        {
            try { return obj.GetType().GetMethod(method) != null; }
            catch (AmbiguousMatchException) { return true; }
        }



        public static object[] AsArray(IEnumerable items)
        {
            return Helpers.ToArray(items);
        }



        public static IINode GetNodeByHandle(uint handle)
        {
            return Kernel.Interface.GetINodeByHandle(handle);
        }

        public static IEnumerable<IINode> GetNodesByHandle(uint[] handles)
        {
            foreach (uint handle in handles)
                yield return GetNodeByHandle(handle);
        }


        public static Type GetNodeClass()
        {
            return typeof(IINode);
        }

        
        
    }
}
