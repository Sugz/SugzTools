using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Temp
{
    public class Node : Base
    {

        private ObservableCollection<Node> _Children;
        public ObservableCollection<Node> Children
        {
            get { return _Children; }
            set
            {
                _Children = value;
                OnPropertyChanged();
            }
        }


    }
}
