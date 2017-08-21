using CodeDoc.Src;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.IO;
using System.Text;

namespace CodeDoc.Model
{
    public class CDScript : CDFileItem, IReadableItem
    {

        #region Fields

        private StringCollection _Description;                          // The script description

        #endregion Fields

        #region Properties

        /// <summary>
        /// Get the script description
        /// </summary>
        public StringCollection Description => _Description ?? (_Description = GetDescription());


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


        protected override bool GetIsValidPath()
        {
            return File.Exists(Path);
        }

        protected override string GetText()
        {
            return System.IO.Path.GetFileNameWithoutExtension(Path);
        }

        protected override ObservableCollection<CDDataItem> GetChildren()
        {
            //TODO: correct implementation
            return new ObservableCollection<CDDataItem>();
        }


        private StringCollection GetDescription()
        {
            // Make sure the path is valid
            if (!IsValidPath)
                return null;

            // Open the file as stream, skip empty and first description line then collect all description until the "use / modify" warning
            StreamReader streamReader = new StreamReader(Path, Encoding.GetEncoding("iso-8859-1"));
            string str = streamReader.ReadLine();
            StringCollection description = new StringCollection();
            while (str != CDConstants.UseModifyScript)
            {
                str = str.Trim(CDConstants.DescriptionTrimChars);
                if (str != string.Empty && str != "/*")
                    description.Add(str);

                if (streamReader.EndOfStream)
                {
                    description = null;
                    break;
                }

                str = streamReader.ReadLine();
            }

            streamReader.Close();
            return description;
        } 


        #endregion Methods

    }
}
