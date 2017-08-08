using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Src
{
    public static class CDConstants
    {
        private static IList<string> _Enus;
        private static IList<string> _Maxs;

        public static string AppDataFolder = Environment.GetEnvironmentVariable("LocalAppData") + @"\CodeDoc";
        public static string MaxAppData = Environment.GetEnvironmentVariable("LocalAppData") + @"\Autodesk\3dsMax";
        public static string DataFile = @"\Data.xml";
        public static string DataNotFind = "Data.xml cannot be find. If it already exist, set the appropriate path in the Options Panel";
        public static string LoadingData = "Loading the config...";
        public static string DataLoaded = "The config has been loaded.";
        public static string SavingData = "Saving the config...";
        public static string DataSaved = "The config has been saved.";
        public static string Path = "Path";
        public static string Text = "Text";
        public static string Folder = "Folder";
        public static string Script = "Script";


        public static IList<string> Enus
        {
            get
            {
                if (_Enus is null)
                    GetAllMaxs();
                return _Enus;
            }
        }
        public static IList<string> Maxs
        {
            get
            {
                if (_Maxs is null)
                    GetAllMaxs();
                return _Maxs;
            }
        }


        private static void GetAllMaxs()
        {
            _Enus = new List<string>();
            _Maxs = new List<string>();
            foreach (DictionaryEntry environmentVariable in Environment.GetEnvironmentVariables())
            {
                string key = environmentVariable.Key as string;
                if (key.StartsWith("ADSK_3DSMAX_x64_"))
                {
                    _Enus.Add(MaxAppData + $@"\{key.Substring(key.Length - 4)} - 64bit\ENU\");
                    _Maxs.Add((string)environmentVariable.Value);
                }
            }
        }


        public static string GetRelativePath(string path)
        {
            if (Enus.FirstOrDefault(x => path.StartsWith(x)) is string _enu)
                return GetRelativeEnu(path, _enu);

            if (Maxs.FirstOrDefault(x => path.StartsWith(x)) is string _max)
                return GetRelativeMax(path, _max);

            return null;
        }


        public static string GetPath(string relativePath)
        {
            if (relativePath.StartsWith("%Enu_"))
                return GetEnu(relativePath);

            if (relativePath.StartsWith("%Max_"))
                return GetMax(relativePath);

            return null;
        }


        public static string GetRelativeEnu(string path, string enu)
        {
            string[] enuSplit = enu.Split("\\".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            string version = enuSplit[enuSplit.Length - 2].Substring(0, 4);
            return path.Replace(enu, $@"%Enu_{version}%\");
        }
        public static string GetEnu(string relativePath)
        {
            string replacement = MaxAppData + $@"\{relativePath.Substring(5, 4)} - 64bit\ENU";
            return replacement + relativePath.Remove(0, 10);
        }

        public static string GetRelativeMax(string path, string max)
        {
            string[] maxSplit = max.Split("\\".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            string maxVersion = maxSplit[maxSplit.Length - 1];
            string version = maxVersion.Substring(maxVersion.Length - 4, 4);
            return path.Replace(max, $@"%Max_{version}%\");
        }
        public static string GetMax(string relativePath)
        {
            string replacement = Maxs.First(x => x.Contains(relativePath.Substring(5, 4)));
            return replacement + relativePath.Remove(0, 11);
        }
    }
}
