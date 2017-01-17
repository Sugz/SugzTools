using System;
using System.Windows;

namespace SugzTools.Src
{
    public static class Resource<T>
    {

        public enum ResourceType
        {
            Color,
            Style,
            Icon,
        }



        public static T GetIcon(string key)
        {
            return GetResource(ResourceType.Icon, key, key);
        }


        /// <summary>
        /// Get a style with selected key contain in a file with same name as the key
        /// </summary>
        /// <param name="key">The key of the resource and the file name</param>
        /// <returns></returns>
        public static T GetStyle(string key)
        {
            return GetResource(ResourceType.Style, key, key);
        }


        /// <summary>
        /// Get a style contain in a file with selected key
        /// </summary>
        /// <param name="file">The file where to look for the resource</param>
        /// <param name="key">The key of the resource</param>
        /// <returns></returns>
        public static T GetStyle(string file, string key)
        {
            return GetResource(ResourceType.Style, file, key);
        }


        /// <summary>
        /// Get a color from a key
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static T GetColor(string key)
        {
            return GetResource(ResourceType.Color, key, key);
        }


        /// <summary>
        /// Get a specific resource 
        /// </summary>
        /// <param name="type"></param>
        /// <param name="file"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public static T GetResource(ResourceType type, string file, string key)
        {
            ResourceDictionary resource = new ResourceDictionary();

            switch (type)
            {
                case ResourceType.Color:
                    resource.Source = new Uri(("/SugzTools;component/Resources/Colors.xaml"), UriKind.RelativeOrAbsolute);
                    break;
                case ResourceType.Style:
                    resource.Source = new Uri(("/SugzTools;component/Controls/" + file + "/" + file + ".xaml"), UriKind.RelativeOrAbsolute);
                    break;
                case ResourceType.Icon:
                    resource.Source = new Uri(("/SugzTools;component/Resources/ExternalIcons.xaml"), UriKind.RelativeOrAbsolute);
                    break;
                default:
                    break;
            }

            return (T)resource[key];
        }

    }
}
