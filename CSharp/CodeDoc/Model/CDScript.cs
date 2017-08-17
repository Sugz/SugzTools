using CodeDoc.Src;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Media;

namespace CodeDoc.Model
{
    public class CDScript : CDFileItem, IDescriptiveItem
    {

        #region Properties

        public bool IsMissingDescription { get; set; }

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



        public StringCollection GetDescription()
        {
            // Make sure the path is valid
            if (!IsValidPath)
                return null;

            // Open the file as stream
            StreamReader streamReader = new StreamReader(Path, Encoding.GetEncoding("iso-8859-1"));
            if (!CDParser.ScriptContainDescription(ref streamReader))
            {
                IsMissingDescription = true;
                return null;
            }

            string str = streamReader.ReadLine();

            // Collect all description until the "use / modify" warning
            StringCollection description = new StringCollection();
            while (str != CDConstants.UseModifyScript)
            {
                str = str.Trim(CDConstants.DescriptionTrimChars);
                if (str != string.Empty)
                    description.Add(str);

                str = streamReader.ReadLine();
            }

            streamReader.Close();
            return description;
        } 


        #endregion Methods

    }
}
