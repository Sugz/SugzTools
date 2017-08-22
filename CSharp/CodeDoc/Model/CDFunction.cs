using CodeDoc.Src;
using SugzTools.Extensions;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
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

        private StringCollection _Description;
        private int _LineIndex;

        #endregion Fields


        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public StringCollection Description => _Description ?? (_Description = GetDescription());

        #endregion Properties


        #region Constructor


        public CDFunction(object parent, string text, int lineIndex) : base(parent)
        {
            Type = CDDataItemType.Function;
            GetText(text);
            _LineIndex = lineIndex;
        }


        #endregion Constructor


        #region Methods


        private void GetText(string text)
        {
            if (Array.FindIndex(CDConstants.FnDef, x => text.StartsWith(x)) is int fnIndex && fnIndex != -1)
            {
                string fn = CDConstants.FnDef[fnIndex];
                Text = text.Remove(text.IndexOf(fn), fn.Length + 1).TrimEnd("= ".ToCharArray());
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

            // Add the function text in the begining of the description
            description.Add(Text);

            // Add the line before the function def as description
            string line = _StreamReader.ReadLine().Trim(CDConstants.FnDescriptionTrimChars);
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

            return description;
        }


        #endregion Methods

    }
}
