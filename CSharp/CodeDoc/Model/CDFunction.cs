using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Documents;

namespace CodeDoc.Model
{
    public class CDFunction : CDDataItem, IDescriptiveItem
    {

        #region Properties

        public bool IsMissingDescription { get; set; }

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


        #endregion Methods

    }
}
