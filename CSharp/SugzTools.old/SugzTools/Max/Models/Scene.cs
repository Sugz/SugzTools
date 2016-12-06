using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SugzTools.Max.Helpers;

namespace SugzTools.Max.Models
{
    /// <summary>
    /// Access to the scene
    /// </summary>
    public static class Scene
    {

        // Properties
        #region Properties


        /// <summary>
        /// Get the Root node
        /// </summary>
        public static Node Root
        {
            get { return new Node(MaxUtils.Interface.RootNode); }

        }

        /// <summary>
        /// Get the nodes without parent
        /// </summary>
        public static IEnumerable<Node> FirstNodes
        {
            get { return Root.Children; }

        }

        /// <summary>
        /// Get all the nodes
        /// </summary>
        public static IEnumerable<Node> AllNodes
        {
            get { return Root.ChildrenTree; }
        }


        #endregion // End Properties


    }
}
