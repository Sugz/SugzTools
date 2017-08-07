using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Src
{
    internal static class CDConstants
    {
        internal static string Folder = Environment.GetEnvironmentVariable("LocalAppData") + @"\CodeDoc\";
        internal static string Data = Environment.GetEnvironmentVariable("LocalAppData") + @"\CodeDoc\Data.xml";
        internal static string DataNotFind = "Data.xml cannot be find. If it already exist, set the appropriate path in the Options Panel";
        internal static string LoadingData = "Loading the config...";
        internal static string DataLoaded = "The config has been loaded.";
        internal static string SavingData = "Saving the config...";
        internal static string DataSaved = "The config has been saved.";
        internal static string Path = "Path";
        internal static string Text = "Text";

    }
}
