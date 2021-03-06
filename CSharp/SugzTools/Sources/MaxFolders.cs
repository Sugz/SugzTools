﻿using Microsoft.Win32;
using SugzTools.Extensions;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Src
{
    public static class MaxFolders
    {

        /// <summary>
        /// Return all 3ds max versions currently installed and their corresponding enu folders
        /// </summary>
        /// <returns></returns>
        public static Dictionary<string, string> Get()
        {
            Dictionary<string, string> folders = new Dictionary<string, string>();

            SortedList<int,string> x32Paths = GetFolders(RegistryView.Registry32);
            SortedList<int,string> x64Paths = GetFolders(RegistryView.Registry64);

            int i = 0, j = 0;
            while (folders.Count != x32Paths.Count + x64Paths.Count)
            {
                if (i > x32Paths.Count - 1)
                    AddToFolders(ref folders, ref j, x64Paths.Values[j], "64");
                else if (j > x64Paths.Count - 1)
                    AddToFolders(ref folders, ref i, x32Paths.Values[i], "32");
                else if (x64Paths.Keys[j] < x32Paths.Keys[i])
                    AddToFolders(ref folders, ref j, x64Paths.Values[j], "64");
                else if (x64Paths.Keys[j] > x32Paths.Keys[i])
                    AddToFolders(ref folders, ref i, x32Paths.Values[i], "32");
                else if (x64Paths.Keys[j] == x32Paths.Keys[i])
                {
                    AddToFolders(ref folders, ref i, x32Paths.Values[i], "32");
                    AddToFolders(ref folders, ref j, x64Paths.Values[j], "64");
                }
            }

            return folders;
        }


        /// <summary>
        /// Return all 3ds max 32bit versions currently installed and their corresponding enu folders
        /// </summary>
        /// <returns></returns>
        public static Dictionary<string, string> Get32()
        {
            Dictionary<string, string> folders = new Dictionary<string, string>();
            SortedList<int, string> paths = GetFolders(RegistryView.Registry32);
            int i = 0;
            foreach(string s in paths.Values)
                AddToFolders(ref folders, s, "32");

            return folders;
        }


        /// <summary>
        /// Return all 3ds max 64bit versions currently installed and their corresponding enu folders
        /// </summary>
        /// <returns></returns>
        public static Dictionary<string, string> Get64()
        {
            Dictionary<string, string> folders = new Dictionary<string, string>();
            SortedList<int, string> paths = GetFolders(RegistryView.Registry64);
            int i = 0;
            foreach (string s in paths.Values)
                AddToFolders(ref folders, s, "64");

            return folders;
        }


        /// <summary>
        /// Return all 3ds max versions currently installed, their corresponding enu folders and their bit version
        /// </summary>
        /// <returns></returns>
        public static List<string[]> GetByBit()
        {
            SortedList<int, string> x32Paths = GetFolders(RegistryView.Registry32);
            SortedList<int, string> x64Paths = GetFolders(RegistryView.Registry64);

            List<string[]> folders = new List<string[]>();
            int i = 0, j = 0;
            while (folders.Count != x32Paths.Count + x64Paths.Count)
            {
                if (i > x32Paths.Count - 1)
                    folders.Add(AddToFolders(ref j, x64Paths.Values[j], "64"));
                else if (j > x64Paths.Count - 1)
                    folders.Add(AddToFolders(ref i, x32Paths.Values[i], "32"));
                else if (x64Paths.Keys[j] < x32Paths.Keys[i])
                    folders.Add(AddToFolders(ref j, x64Paths.Values[j], "64"));
                else if (x64Paths.Keys[j] > x32Paths.Keys[i])
                    folders.Add(AddToFolders(ref i, x32Paths.Values[i], "32"));
                else if (x64Paths.Keys[j] == x32Paths.Keys[i])
                {
                    folders.Add(AddToFolders(ref i, x32Paths.Values[i], "32"));
                    folders.Add(AddToFolders(ref j, x64Paths.Values[j], "64"));
                }
            }

            return folders;
        }


        /// <summary>
        /// Get a sorted dictionary for 3ds max installs, either 32 or 64bits
        /// </summary>
        /// <param name="registryView"></param>
        /// <returns></returns>
        private static SortedList<int, string> GetFolders(RegistryView registryView)
        {
            SortedList<int, string> sortedList = new SortedList<int, string>();
            RegistryKey key = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, registryView).OpenSubKey(@"SOFTWARE\Autodesk\3dsMax");
            IEnumerable<string> versions = key.GetSubKeyNames().Where(x => (float.TryParse(x, out float f)) && (f == Math.Floor(f)));
            foreach (string s in versions)
            {
                int i = (int)float.Parse(s);
                RegistryKey version = key.OpenSubKey(s);
                if (version.GetValue("Installdir") is string installdir && File.Exists(installdir + "3dsmax.exe"))
                    sortedList.Add(i, installdir.TrimLast());
                else
                {
                    foreach (string sub in version.GetSubKeyNames())
                    {
                        version = version.OpenSubKey(sub);
                        if (version.GetValue("Installdir") is string _installdir && File.Exists(_installdir + "3dsmax.exe"))
                        {
                            sortedList.Add(i, _installdir.TrimLast());
                            break;
                        }
                    }
                }
            }
            return sortedList;
        }


        /// <summary>
        /// Add given path and corresponding ENU folder to the folders dictionary
        /// </summary>
        /// <param name="folders"></param>
        /// <param name="index"></param>
        /// <param name="path"></param>
        /// <param name="bit"></param>
        private static void AddToFolders(ref Dictionary<string, string> folders, ref int index, string path, string bit)
        {
            //string enu = Environment.GetEnvironmentVariable("LocalAppData") +
            //    $@"\Autodesk\3dsMax\{path.Substring(path.Length - 4)} - {bit}bit\ENU\";
            //folders.Add(path, Directory.Exists(enu) ? enu : null);
            AddToFolders(ref folders, path, bit);
            index++;
        }


        /// <summary>
        /// Add given path and corresponding ENU folder to the folders dictionary
        /// </summary>
        /// <param name="folders"></param>
        /// <param name="path"></param>
        /// <param name="bit"></param>
        private static void AddToFolders(ref Dictionary<string, string> folders, string path, string bit)
        {
            string enu = Environment.GetEnvironmentVariable("LocalAppData") +
                $@"\Autodesk\3dsMax\{path.Substring(path.Length - 4)} - {bit}bit\ENU\";
            folders.Add(path, Directory.Exists(enu) ? enu : null);
        }


        /// <summary>
        /// Add given path, corresponding ENU folder and bit version to the folders list
        /// </summary>
        /// <param name="index"></param>
        /// <param name="path"></param>
        /// <param name="bit"></param>
        /// <returns></returns>
        private static string[] AddToFolders(ref int index, string path, string bit)
        {
            string[] maxInstall = new string[3];
            string enu = Environment.GetEnvironmentVariable("LocalAppData") +
                $@"\Autodesk\3dsMax\{path.Substring(path.Length - 4)} - {bit}bit\ENU\";
            maxInstall[0] = path;
            maxInstall[1] = Directory.Exists(enu) ? enu : null;
            maxInstall[2] = bit;

            index++;

            return maxInstall;
        }

    }
}
