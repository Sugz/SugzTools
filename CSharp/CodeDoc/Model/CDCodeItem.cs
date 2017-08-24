using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public abstract class CDCodeItem : CDDataItem, IDescriptionItem
    {
        #region Fields

        protected StringCollection _Code;                                 // The class full code
        //protected StringCollection _Description;                          // The class description
        protected int _LineIndex;                                         // The firt line of the class in the script file
        protected StreamReader _StreamReader;

        #endregion Fields


        #region Properties


        /// <summary>
        /// Get the relevant code
        /// </summary>
        public StringCollection Code => _Code ?? (_Code = GetCode());

        /// <summary>
        /// Get the code description
        /// </summary>
        public StringCollection Description { get; }
        //public StringCollection Description => _Description ?? (_Description = GetDescription());


        #endregion Properties


        #region Constructor

        public CDCodeItem(object parent, int lineIndex) : base(parent)
        {
            _LineIndex = lineIndex;
        }

        #endregion Constructor


        #region Methods

        //protected abstract StringCollection GetDescription();

        public StringCollection GetCode()
        {
            // Read until the begining of the class code
            _StreamReader = new StreamReader(((CDScript)Parent).Path, Encoding.GetEncoding("iso-8859-1"));
            int lineCount = 0;
            while (lineCount != _LineIndex)
            {
                lineCount++;
                _StreamReader.ReadLine();
            }

            // Read and store all the class code
            StringCollection code = new StringCollection();
            int countOpen = 0, countClose = 0;
            while (!_StreamReader.EndOfStream)
            {
                string line = _StreamReader.ReadLine();
                code.Add(line);

                // Count open and close parenthesis to get the end of the class code
                countOpen += line.Count(x => x == '(');
                countClose += line.Count(x => x == ')');
                if (countOpen != 0 && countClose == countOpen)
                    break;
            }

            _StreamReader.Close();
            return code.Count > 0 ? code : null;
        }

        #endregion Methods
    }
}
