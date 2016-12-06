using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;
using SugzTools.Max.Helpers;
using SugzTools.Max.Models;


namespace SugzTools.Max.Commands
{

    /// <summary>
    /// Define the action the SelectCommand have to perform
    /// </summary>
    public enum SelectType
    {
        Select,
        Add,
        Deselect,
    }


    /// <summary>
    /// Select nodes with the undo / redo
    /// </summary>
    public class SelectCommand : RestoreCommand
    {

        // Fields
        #region Fields
        
        private IEnumerable<Node> _nodes;
        private SelectType _selectType;
        private List<Node> _oldNodes = new List<Node>();


        #endregion // End Fields



        // Properties
        #region Properties


        private string _description;
        public override string Description { get { return _description; } }


        #endregion // End Properties



        // Constructor
        #region Constructor
        

        public SelectCommand(IEnumerable<Node> nodes, SelectType selectType)
        {
            _nodes = nodes;
            _selectType = selectType;

            switch (_selectType)
            {
                case SelectType.Select:
                    _description = "Select Command";
                    break;
                case SelectType.Add:
                    _description = "Add to Selection Command";
                    break;
                case SelectType.Deselect:
                    _description = "Deselect Command";
                    break;
            }

            Selection sel = new Selection();
            foreach (Node node in sel.Nodes)
                _oldNodes.Add(node);

            Execute();
        }


        #endregion // End Constructor



        // Methods
        #region Methods
        

        /// <summary>
        /// Do the action corresponding to the SelectType
        /// </summary>
        public override void Redo()
        {
            switch (_selectType)
            {
                case SelectType.Select:
                    MaxUtils.Interface.ClearNodeSelection(false);
                    goto case SelectType.Add;
                case SelectType.Add:
                    foreach (Node node in _nodes)
                        node.IsSelected = true;
                    break;
                case SelectType.Deselect:
                    foreach (Node node in _nodes)
                        if (node != null && node.IsSelected) node.IsSelected = false;
                    break;
            }
        }

        /// <summary>
        /// Undo
        /// </summary>
        /// <param name="isUndo"></param>
        public override void Restore(bool isUndo)
        {
            MaxUtils.Interface.ClearNodeSelection(false);
            foreach (Node node in _oldNodes)
                node.IsSelected = true;
        }


        #endregion // End Methods

    }
}
