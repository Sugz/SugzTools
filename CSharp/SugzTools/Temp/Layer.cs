using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace SugzTools.Temp
{
    public class Layer : Base
    {
        private ObservableCollection<Layer> _Layers;
        public ObservableCollection<Layer> Layers
        {
            get { return _Layers; }
            set
            {
                _Layers = value;
                OnPropertyChanged();
            }
        }


        private ObservableCollection<Node> _Nodes;
        public ObservableCollection<Node> Nodes
        {
            get { return _Nodes; }
            set
            {
                _Nodes = value;
                OnPropertyChanged();
            }
        }


        public IList Children
        {
            get
            {
                return new CompositeCollection
                {
                    new CollectionContainer { Collection = Layers },
                    new CollectionContainer { Collection = Nodes }
                };
            }
        }


    }
}
