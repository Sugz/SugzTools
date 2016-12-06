using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;
using SugzTools.Max.Helpers;

namespace SugzTools.Max.Models
{
    /// <summary>
    /// Lists all the ActionTables and use to retrieve a specific ActionTable / ActionItem
    /// </summary>
    public static class ActionManager
    {

        // Properties
        #region Properties

        public static IEnumerable<ActionTable> ActionTables
        {
            get
            {
                for (int i = 0; i < MaxUtils.Interface.ActionManager.NumActionTables; ++i)
                    yield return new ActionTable(MaxUtils.Interface.ActionManager.GetTable(i));
            }
        }


        #endregion // End Properties


        // Methods
        #region Methods


        /// <summary>
        /// Return an ActionTable from it's ID
        /// </summary>
        /// <param name="tableId">The ActionTable's ID</param>
        /// <returns></returns>
        public static ActionTable GetActionTable(uint tableId)
        {
            var _actionTable =
                (from actionTable in ActionTables
                 where actionTable.Id == tableId
                 select actionTable).ToList();

            return _actionTable[0];
        }


        /// <summary>
        /// Return an ActionTable from it's Name
        /// </summary>
        /// <param name="name">The ActionTable's Name</param>
        /// <returns></returns>
        public static ActionTable GetActionTable(string name)
        {
            var _actionTable =
                (from actionTable in ActionTables
                 where actionTable.Name == name
                 select actionTable).ToList();

            return _actionTable[0];
        }


        /// <summary>
        /// Get an ActionItem from its ID and its ActionTable's ID
        /// </summary>
        /// <param name="tableId">The ActionTable's ID</param>
        /// <param name="itemId">The ActionItem's ID</param>
        /// <returns></returns>
        public static ActionItem GetActionItem(uint tableId, int itemId)
        {
            var _actionItem =
                (from actionItem in GetActionTable(tableId).ActionItems
                 where actionItem.Id == itemId
                 select actionItem).ToList();

            return _actionItem[0];
        }


        /// <summary>
        /// Get an ActionItem from its ID and its ActionTable's Name
        /// </summary>
        /// <param name="tableName">The ActionTable's Name</param>
        /// <param name="itemId">The ActionItem's ID</param>
        /// <returns></returns>
        public static ActionItem GetActionItem(string tableName, int itemId)
        {
            var _actionItem =
                (from actionItem in GetActionTable(tableName).ActionItems
                 where actionItem.Id == itemId
                 select actionItem).ToList();

            return _actionItem[0];
        }



        #endregion // End Methods

    }


    /// <summary>
    /// Wraps the IActionTable
    /// </summary>
    public class ActionTable
    {

        // Properties
        #region Properties

        public IActionTable _ActionTable { get; private set; }

        public uint Id { get { return _ActionTable.Id_; } }
        public string Name { get { return _ActionTable.Name; } }

        public IEnumerable<ActionItem> ActionItems
        {
            get
            {
                for (int i = 0; i < _ActionTable.Count; ++i)
                    yield return new ActionItem(_ActionTable[i]);
            }
        }


        #endregion // End Properties



        // Constructor
        #region Constructor


        public ActionTable(IActionTable actionTable)
        {
            _ActionTable = actionTable;
        }


        #endregion // End Constructor

    }


    /// <summary>
    /// Wraps the IActionItem
    /// </summary>
    public class ActionItem
    {

        // Properties
        #region Properties


        public IActionItem _ActionItem { get; private set; }

        public int Id { get { return _ActionItem.Id_; } }
        public bool IsChecked { get { return _ActionItem.IsChecked_; } }
        public bool IsEnabled { get { return _ActionItem.IsEnabled_; } }
        public bool IsItemVisible { get { return _ActionItem.IsItemVisible; } }



        #endregion // End Properties



        // Constructor
        #region Constructor


        public ActionItem(IActionItem actionItem)
        {
            _ActionItem = actionItem;
        }


        #endregion // End Constructor



        // Methods
        #region Methods


        public bool Execute() { return _ActionItem.Execute(); }


        #endregion // End Methods
    }
}
