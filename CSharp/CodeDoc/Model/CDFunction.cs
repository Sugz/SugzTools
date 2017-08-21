using System;
using System.Collections.Generic;
using System.Collections.Specialized;
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

        #endregion Fields

        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public StringCollection Description => _Description ?? (_Description = GetDescription());


        #endregion Properties



        #region Constructor


        public CDFunction(object parent) : base(parent)
        {
            Type = CDDataItemType.Function;
        }


        #endregion Constructor


        #region Methods


        protected override string GetText()
        {
            //TODO: implement method
            return null;
        }


        private StringCollection GetDescription()
        {
            //TODO: implement method
            return null;
        }


        #endregion Methods

    }
}
