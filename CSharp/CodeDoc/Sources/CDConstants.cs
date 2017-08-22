using System;
using System.Text.RegularExpressions;

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
        public static string InvalidPath = "The path is not valid.";
        public static string Path = "Path";
        public static string Text = "Text";
        public static string Folder = "Folder";
        public static string Script = "Script";
        public static Regex LinkParser = new Regex(@"http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        public static string NoDescription = "seems to contain no description, add one with the EDIT button";

        public static string ScriptNoDescription = $"This script {NoDescription}";
        public static string UseModifyScript = "*Use / Modify this script at your own risk !*";
        public static string ScriptDescriptionStart = "/*##############################################################################";
        public static string ScriptDescriptionEnd = "###############################################################################*/";

        public static string FnNoDescription = $"This function {NoDescription}";
        public static string[] FnDef = { "fn", "function" };
        public static char[] FnTrimChars = "\t ".ToCharArray();
        public static char[] FnDescriptionTrimChars = "\t#/*- ".ToCharArray();
        public static string FnStart = "/*<Function>";
        public static string FnEnd = "</Function>*/";

        public static string[] Comments = { "/*", "--" };
        public static char[] DescriptionTrimChars = "\t# ".ToCharArray();
        public static char[] VersionTrimChars = "- ".ToCharArray();
        public static char[] Delimiters = "<>, ".ToCharArray();

        public static string[] ScriptIntro =
        {
            "Title",
            "Version",
            "Author",
            "Contact",
        };
        public static string[] ScriptDescription =
        {
            "Description",
            "Required Components",
            "Sources",
            "ToDo",
            "History"
        };

        public static string[] FnDescription =
        {
            "Arguments",
            "Return",
            "Infos",
        };
    }
}
