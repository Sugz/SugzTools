using CodeDoc.Src;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Src
{
    public static class CDMaxPath
    {

        #region Fields

        private static IList<string> _Enus;
        private static IList<string> _Maxs;

        #endregion Fields


        #region Properties

        /// <summary>
        /// Get a list of ENU folders
        /// </summary>
        public static IList<string> Enus
        {
            get
            {
                if (_Enus is null)
                    GetAllMaxs();
                return _Enus;
            }
        }


        /// <summary>
        /// Get a list of Max folders
        /// </summary>
        public static IList<string> Maxs
        {
            get
            {
                if (_Maxs is null)
                    GetAllMaxs();
                return _Maxs;
            }
        } 

        #endregion Properties


        #region Private Methods


        /// <summary>
        /// Set Enus and Maxs lists from 3ds max environment variables
        /// </summary>
        private static void GetAllMaxs()
        {
            _Enus = new List<string>();
            _Maxs = new List<string>();
            foreach (DictionaryEntry environmentVariable in Environment.GetEnvironmentVariables())
            {
                string key = environmentVariable.Key as string;
                if (key.StartsWith("ADSK_3DSMAX_x64_"))
                {
                    _Enus.Add(CDConstants.MaxAppData + $@"\{key.Substring(key.Length - 4)} - 64bit\ENU\");
                    _Maxs.Add((string)environmentVariable.Value);
                }
            }
        }


        /// <summary>
        /// Return a relative path from a from a ENU path
        /// </summary>
        /// <param name="path"></param>
        /// <param name="enu"></param>
        /// <returns></returns>
        private static string GetRelativeEnu(string path, string enu)
        {
            string[] enuSplit = enu.Split("\\".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            string version = enuSplit[enuSplit.Length - 2].Substring(0, 4);
            return path.Replace(enu, $@"%Enu_{version}%\");
        }


        /// <summary>
        /// Return a path from a relative ENU path
        /// </summary>
        /// <param name="relativePath"></param>
        /// <returns></returns>
        private static string GetEnu(string relativePath)
        {
            string replacement = CDConstants.MaxAppData + $@"\{relativePath.Substring(5, 4)} - 64bit\ENU";
            return replacement + relativePath.Remove(0, 10);
        }


        /// <summary>
        /// Return a relative path from a from a Max path
        /// </summary>
        /// <param name="path"></param>
        /// <param name="max"></param>
        /// <returns></returns>
        private static string GetRelativeMax(string path, string max)
        {
            string[] maxSplit = max.Split("\\".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            string maxVersion = maxSplit[maxSplit.Length - 1];
            string version = maxVersion.Substring(maxVersion.Length - 4, 4);
            return path.Replace(max, $@"%Max_{version}%\");
        }


        /// <summary>
        /// Return a path from a relative Max path
        /// </summary>
        /// <param name="relativePath"></param>
        /// <returns></returns>
        private static string GetMax(string relativePath)
        {
            string replacement = Maxs.First(x => x.Contains(relativePath.Substring(5, 4)));
            return replacement + relativePath.Remove(0, 11);
        }


        #endregion Private Methods


        #region Public Methods


        /// <summary>
        /// Return a relative path from a path
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string GetRelativePath(string path)
        {
            if (Enus.FirstOrDefault(x => path.StartsWith(x)) is string _enu)
                return GetRelativeEnu(path, _enu);

            if (Maxs.FirstOrDefault(x => path.StartsWith(x)) is string _max)
                return GetRelativeMax(path, _max);

            return null;
        }


        /// <summary>
        /// Return a path from a relative path
        /// </summary>
        /// <param name="relativePath"></param>
        /// <returns></returns>
        public static string GetPath(string relativePath)
        {
            if (relativePath.StartsWith("%Enu_"))
                return GetEnu(relativePath);

            if (relativePath.StartsWith("%Max_"))
                return GetMax(relativePath);

            return null;
        } 


        #endregion Public Methods

    }
}
