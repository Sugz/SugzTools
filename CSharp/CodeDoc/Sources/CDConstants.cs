using System;

namespace CodeDoc.Src
{
    public static class CDConstants
    {
        public static string AppDataFolder = Environment.GetEnvironmentVariable("LocalAppData") + @"\CodeDoc";
        public static string MaxAppData = Environment.GetEnvironmentVariable("LocalAppData") + @"\Autodesk\3dsMax";
        public static string DataFile = @"\CodeDoc_Datas.xml";
        public static string DataNotFind = "Data file cannot be find. If it already exist, set the appropriate path in the Options Panel";
        public static string LoadingData = "Loading the config...";
        public static string DataLoaded = "The config has been loaded.";
        public static string SavingData = "Saving the config...";
        public static string DataSaved = "The config has been saved.";
        public static string Path = "Path";
        public static string Text = "Text";
        public static string Folder = "Folder";
        public static string Script = "Script";

    }
}
