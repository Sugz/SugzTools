﻿using CodeDoc.Src;
using SugzTools.Extensions;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Documents;

namespace CodeDoc.Model
{
    public class CDFunction : CDDataItem, IReadableItem
    {

        #region Fields

        //private StringCollection _Description;
        private int _LineIndex;

        #endregion Fields


        #region Properties

        /// <summary>
        /// 
        /// </summary>
        //public StringCollection Description => _Description ?? (_Description = GetDescription());
        public StringCollection Description { get; }

        public StringCollection Code { get; protected set; }

        #endregion Properties


        #region Constructor


        public CDFunction(object parent, string text, int lineIndex) : base(parent)
        {
            Type = CDDataItemType.Function;
            GetText(text);
            _LineIndex = lineIndex;
        }

        public CDFunction(object parent, StringCollection code) : base(parent)
        {
            Type = CDDataItemType.Struct;
            Code = code;
        }


        #endregion Constructor


        #region Methods

        /// <summary>
        /// Return the text inbetween "fn" or "function" and '='
        /// </summary>
        /// <param name="text"></param>
        private void GetText(string text)
        {
            if (Array.Find(CDConstants.FnDef, x => text.StartsWith(x)) is string fn)
            {
                int fnLength = fn.Length + 1;
                Text = text.Substring(fnLength, text.IndexOf('=') - fnLength).TrimEnd();
            }
        }


        private StringCollection GetDescription()
        {
            // Read the parent script until the function description
            StringCollection description = new StringCollection();
            StreamReader _StreamReader = new StreamReader(((CDScript)Parent).Path, Encoding.GetEncoding("iso-8859-1"));
            int lineCount = 0;
            while (lineCount != _LineIndex)
            {
                lineCount++;
                _StreamReader.ReadLine();
            }

            // Add the line before the function def as description (check if it's a comment first)
            string line = _StreamReader.ReadLine().Trim(CDConstants.FnDescriptionTrimChars);
            if (line != string.Empty)
                description.Add(line);

            // Read until the begining of the description then store it
            line = _StreamReader.ReadLine();
            while (!line.Contains(CDConstants.FnStart))
            {
                line = _StreamReader.ReadLine();

                //TODO: replace ")" by either another function declaration or end of stream
                if (line.Contains(")"))
                    return description;
            }
            line = _StreamReader.ReadLine();
            while (!line.Contains(CDConstants.FnEnd))
            {
                if (line.Contains(")"))
                    return description;

                //TODO: avoid empty strings
                description.Add(line.Trim(CDConstants.FnTrimChars));
                line = _StreamReader.ReadLine();
            }

            _StreamReader.Close();
            return description.Count > 0 ? description : null;
            
        }


        public void PrintFullFunction()
        {
            StreamReader _StreamReader = new StreamReader(((CDScript)Parent).Path, Encoding.GetEncoding("iso-8859-1"));
            int lineCount = 0;
            while (lineCount != _LineIndex)
            {
                lineCount++;
                _StreamReader.ReadLine();
            }

            int countOpen = 0;
            int countClose = 0;
            while (!_StreamReader.EndOfStream)
            {
                string line = _StreamReader.ReadLine();
                countOpen += line.Count(x => x == '(');
                countClose += line.Count(x => x == ')');
                Debug.WriteLine($"{line}");//\nOpen: {countOpen} ---------- Close: {countClose}");
                if (countOpen != 0 && countClose == countOpen)
                    break;
            }
            _StreamReader.Close();

        }


        #endregion Methods

    }
}
