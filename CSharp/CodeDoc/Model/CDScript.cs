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
    public class CDScript : CDCodeItem, IPathItem //CDFileItem, IDescriptionItem
    {

        #region Fields

        //StreamReader _StreamReader;
        //private StringCollection _Description;                          // The script description
        //private int _LineCount = 0;                                     // The line index for the description end

        private bool _IsValidPath;
        private string _RelativePath;
        private string _Path;

        #endregion Fields


        #region Properties

        /// <summary>
        /// Get the script description
        /// </summary>
        //public StringCollection Description => _Description ?? (_Description = GetDescription());

        /// <summary>
        /// Get if the path is valid. 
        /// Load Children if it is
        /// </summary>
        public bool IsValidPath
        {
            get { return _IsValidPath; }
            protected set
            {
                Set(ref _IsValidPath, value);

                // Reload children when path become valid
                if (value && _Children is null)
                    Children = GetChildren();
            }
        }

        /// <summary>
        /// Get a formated path to get 3ds max appdata and install folder
        /// </summary>
        public string RelativePath => _RelativePath ?? (_RelativePath = CDMaxPath.GetRelativePath(Path));

        /// <summary>
        /// Get or set the full path
        /// </summary>
        public string Path
        {
            get { return _Path; }
            set
            {
                Set(ref _Path, value);
                IsValidPath = File.Exists(Path);
            }
        }


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


        //protected override bool GetIsValidPath() => File.Exists(Path);

        private string GetText() => System.IO.Path.GetFileNameWithoutExtension(Path);


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


        #endregion Methods

    }
}
