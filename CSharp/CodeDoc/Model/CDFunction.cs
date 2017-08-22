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
        private long _Index;

        #endregion Fields


        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public StringCollection Description => _Description ?? (_Description = GetDescription());
        public override string Text { get; set; }

        #endregion Properties


        #region Constructor


        public CDFunction(object parent, string text, long index) : base(parent)
        {
            Type = CDDataItemType.Function;
            Text = text;
            _Index = index;
        }


        #endregion Constructor


        #region Methods


        private StringCollection GetDescription()
        {
            //TODO: implement method
            StringCollection description = new StringCollection();
            StreamReader _StreamReader = new StreamReader(((CDScript)Parent).Path, Encoding.GetEncoding("iso-8859-1"));
            _StreamReader.BaseStream.Position = _Index;
            description.Add(_StreamReader.ReadLine());
            description.Add(_Index.ToString());
            return description;
        }


        #endregion Methods

    }
}
