using CodeDoc.Src;
using SugzTools.Src;
using System;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Text;

namespace CodeDoc.Model
{
    public class CDScript : CDFileItem, IReadableItem
    {

        #region Fields

        public string UseModifyScript = "*Use / Modify this script at your own risk !*";
        public string DescriptionStart = "/*##############################################################################";
        public string DescriptionEnd = "###############################################################################*/";

        //StreamReader _StreamReader;
        private StringCollection _Code;
        //private int _LineCount = 0;                                     // The line index for the description end


        #endregion Fields


        #region Properties


        public override bool IsValidPath
        {
            get { return _IsValidPath; }
            set
            {
                Set(ref _IsValidPath, value);

                // Reload children when path become valid
                if (value && _Code is null)
                    _Code = GetCode();
            }
        }

        /// <summary>
        /// Get the script description
        /// </summary>
        public StringCollection Description { get; protected set; }

        public StringCollection Code => _Code ?? (_Code = GetCode());



        #endregion Properties


        #region Constructors


        public CDScript(object parent, string path) : this(parent, path, null, null) { }
        public CDScript(object parent, string path, string text) : this(parent, path, text, null) { }
        public CDScript(object parent, string path, string text, ObservableCollection<CDDataItem> children) : base(parent, path, text, children)
        {
            Type = CDDataItemType.Script;
        }


        #endregion Constructors


        #region Methods


        protected override bool GetIsValidPath() => File.Exists(Path);

        protected override string GetText() => System.IO.Path.GetFileNameWithoutExtension(Path);


        //protected override ObservableCollection<CDDataItem> GetChildren()
        //{
        //    if (!IsValidPath)
        //        return null;

        //    if (_Description is null)
        //        _Description = GetDescription();

        //    ObservableCollection<CDDataItem> children = new ObservableCollection<CDDataItem>();
        //    PeekableStreamReaderAdapter peekStreamReader = new PeekableStreamReaderAdapter(_StreamReader);
        //    while (!_StreamReader.EndOfStream)
        //    {
        //        //TOTO: function detection more complex to avoid for exemple: ModelingLib - fn WorldBBoxMinMaxFn nodes = ( ...Further Infos: function by Denis Trofimov aka DenisT...)
        //        string peekLine = peekStreamReader.PeekLine().Trim(CDConstants.FnTrimChars);
        //        if (Array.Exists(CDConstants.FnDef, x => peekLine.StartsWith(x) && peekLine.Contains('=')))
        //            children.Add(new CDFunction(this, peekLine, _LineCount));

        //        _LineCount++;
        //        peekStreamReader.ReadLine();
        //    }

        //    _StreamReader.Close();
        //    return children.Count != 0 ? children : null;
        //}


        //private StringCollection GetDescription()
        //{
        //    // Make sure the path is valid
        //    if (!IsValidPath)
        //        return null;

        //    // Open the file as stream, skip empty and first description line then collect all description until the "use / modify" warning
        //    _StreamReader = new StreamReader(Path, Encoding.GetEncoding("iso-8859-1"));
        //    string str = _StreamReader.ReadLine();
        //    StringCollection description = new StringCollection();
        //    while (str != CDConstants.UseModifyScript)
        //    {
        //        str = str.Trim(CDConstants.DescriptionTrimChars);
        //        if (str != string.Empty && str != "/*")
        //            description.Add(str);

        //        if (_StreamReader.EndOfStream)
        //        {
        //            description = null;
        //            break;
        //        }
        //        _LineCount++;
        //        str = _StreamReader.ReadLine();
        //    }

        //    return description;
        //} 


        private StringCollection GetCode()
        {
            StreamReader streamReader = new StreamReader(Path, Encoding.GetEncoding("iso-8859-1"));
            PeekableStreamReaderAdapter peekStreamReader = new PeekableStreamReaderAdapter(streamReader);
            StringCollection code = new StringCollection();
            while (!streamReader.EndOfStream)
            {
                string line = peekStreamReader.PeekLine();

                // Get description
                if (line == DescriptionStart)
                {
                    Description = new StringCollection();
                    line = peekStreamReader.ReadLine();
                    while (line != DescriptionEnd)
                    {
                        line = line.Trim(CDConstants.DescriptionTrimChars);
                        if (line != string.Empty && line != "/*")
                            Description.Add(line);
                    }
                }


                // Get structs
                //if (line.ToLower().Contains("struct"))
                //{

                //}

                code.Add(line);
            }
                

            return code;
        }


        #endregion Methods

    }
}
