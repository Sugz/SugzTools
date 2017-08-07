using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public enum CDItemType
    {
        Folder,
        Script,
        Function
    }

    public interface ICDItem
    {
        CDItemType Type { get; set; }
    }
}
