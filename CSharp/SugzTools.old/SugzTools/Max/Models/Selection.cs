using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using Autodesk.Max;
using SugzTools.Max.Commands;
using SugzTools.Max.Helpers;

namespace SugzTools.Max.Models
{
    /// <summary>
    /// Acces to current selection
    /// </summary>
    public class Selection : INotifyPropertyChanged
    {

        // Fields
        #region Fields

        // The SelectionSetChanged notification callback
        private GlobalDelegates.Delegate5 SelectionSetChanged;                                      


        #endregion // End Fields



        // Properties
        #region Properties


        public List<Node> Nodes { get; private set; }                       // Selection nodes
        public int Count { get { return Nodes.Count; } }                    // Selection count


        #endregion // End Properties



        // Constructor
        #region Constructor


        public Selection()
        {
            // Initialize Nodes list
            Nodes = new List<Node>();

            // Register the notification callbacks
            SelectionSetChanged = new GlobalDelegates.Delegate5(SelectionSetChangedCallback);
            MaxUtils.Global.RegisterNotification(SelectionSetChanged, null, SystemNotificationCode.SelectionsetChanged);

            // Get the active selection
            GetSelection();
        }



        #endregion // End Constructor



        // Methods
        #region Methods


        // Private
        #region Private

        /// <summary>
        /// Method call on the SelectionSetChanged Callback
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="info"></param>
        private void SelectionSetChangedCallback(IntPtr obj, IntPtr info)
        {
            // Get the selection
            GetSelection();
        }



        #endregion // End Private


        // Public
        #region Public


        /// <summary>
        /// Set the lists
        /// </summary>
        public void GetSelection()
        {
            // Reset the Nodes list and set it given the new selection
            Nodes.Clear();
            for (int i = 0; i < MaxUtils.Interface.SelNodeCount; i++)
            {
                Nodes.Add(new Node(MaxUtils.Interface.GetSelNode(i)));
            }

            // Fire the event
            OnPropertyChanged("Nodes");
        }



        #endregion // End Public


        #endregion // End Methods



        // Events
        #region Events


        public event PropertyChangedEventHandler PropertyChanged;
        private void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }


        #endregion // End Events

    }
}
