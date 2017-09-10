using SugzTools.Extensions;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Src
{
    public static class MaxFolders
    {

        public static Dictionary<string, string> Get()
        {
            Dictionary<string, string> folders = new Dictionary<string, string>();
            foreach (DictionaryEntry environmentVariable in Environment.GetEnvironmentVariables())
            {
                string key = environmentVariable.Key as string;
                if (key.StartsWith("ADSK_3DSMAX_x64_"))
                {
                    folders.Add(Environment.GetEnvironmentVariable(
                        "LocalAppData") + $@"\Autodesk\3dsMax\{key.Substring(key.Length - 4)} - 64bit\ENU\",
                        ((string)environmentVariable.Value).TrimLast());
                    //yield return Environment.GetEnvironmentVariable("LocalAppData") + $@"\Autodesk\3dsMax\{key.Substring(key.Length - 4)} - 64bit\ENU\";
                    //yield return (string)environmentVariable.Value;
                }
            }
            return folders;
        }
    }
}
