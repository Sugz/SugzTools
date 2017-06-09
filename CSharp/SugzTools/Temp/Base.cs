using System;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using SugzTools.Controls;

namespace SugzTools.Temp
{
    public class Base : SgzTreeViewItem
    {
        private string _Name;
        public string Name
        {
            get { return _Name; }
            set
            {
                _Name = value;
                OnPropertyChanged();
            }
        }
    }

    public class Node : Base { }

    public class Layer : Base { }
}
