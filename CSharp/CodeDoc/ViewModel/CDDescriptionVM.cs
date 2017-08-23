using CodeDoc.Messaging;
using CodeDoc.Model;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Media;

namespace CodeDoc.ViewModel
{
    public class CDDescriptionVM : ViewModelBase
    {

        #region Fields

        private CDDataItem _SelectedItem;                                                                   // Treeview selected item
        private FlowDocument _Document;                                                                     // The flowdocument
        private Visibility _EditButtonVisibility = Visibility.Collapsed;                                    // The edit button visibility
        private ObservableCollection<string> _ScriptDescription = new ObservableCollection<string>();       // The collection use to fill and save script description

        private RelayCommand _SetDescriptionPanelCommand;
        private RelayCommand _SaveDescriptionCommand;

        #endregion Fields


        #region Properties


        /// <summary>
        /// Treeview selected item. Set the flowdocument when updated
        /// </summary>
        public CDDataItem SelectedItem
        {
            get { return _SelectedItem; }
            set
            {
                _SelectedItem = value;
                GetDocument();
                SelectedItem.PropertyChanged += (s, e) =>
                {
                    if (e.PropertyName == "IsValidPath")
                        GetDocument();
                };
            }
        }

        /// <summary>
        /// The flowdocument used to binding  
        /// </summary>
        public FlowDocument Document
        {
            get { return _Document; }
            set { Set(ref _Document, value); }
        }


        /// <summary>
        /// The edit button visibility
        /// </summary>
        public Visibility EditButtonVisibility
        {
            get { return _EditButtonVisibility; }
            set { Set(ref _EditButtonVisibility, value); }
        }

        /// <summary>
        /// The collection use to fill and save script description
        /// </summary>
        public ObservableCollection<string> ScriptDescription
        {
            get { return _ScriptDescription; }
            set { Set(ref _ScriptDescription, value); }
        }




        /// <summary>
        /// Open or close the Description panel
        /// </summary>
        public RelayCommand SetDescriptionPanelCommand
        {
            get { return _SetDescriptionPanelCommand ?? (_SetDescriptionPanelCommand = new RelayCommand(SetDescriptionPanel)); }
        }

        /// <summary>
        /// Close the Status panel
        /// </summary>
        public RelayCommand SaveDescriptionCommand
        {
            get { return _SaveDescriptionCommand ?? (_SaveDescriptionCommand = new RelayCommand(SaveDescription)); }
        }

        

        #endregion Properties


        #region Constructor


        public CDDescriptionVM()
        {
            // Get selected treeview item
            MessengerInstance.Register<CDSelectedItemMessage>(this, x => SelectedItem = x.NewItem);
        }


        #endregion Constructor


        #region Methods


        /// <summary>
        /// Create the flowdocument and apply the styles
        /// </summary>
        private void InitializeDocument()
        {
            Document = new FlowDocument();
            Document.Resources.Add(typeof(FlowDocument), (Style)Application.Current.Resources["FlowDocumentStyle"]);
            Document.Resources.Add(typeof(Paragraph), (Style)Application.Current.Resources["ParagraphStyle"]);
            Document.Resources.Add(typeof(List), (Style)Application.Current.Resources["ListStyle"]);
        }


        /// <summary>
        /// Set the flowdocument from selected item
        /// </summary>
        private void GetDocument()
        {
            // Initialize the flowdocument
            if (Document is null)
                InitializeDocument();
            Document.Blocks.Clear();

            // Get selected item description and set the edit button visibility
            CDParser.FormatDataItemDescription(SelectedItem, ref _Document);

            // SelectedItem can't be a folder and it's path must be valid
            if (SelectedItem is CDFolder folderItem || (SelectedItem is CDScript scriptItem && !scriptItem.IsValidPath))
                EditButtonVisibility = Visibility.Collapsed;
            else
                EditButtonVisibility = Visibility.Visible;
        }


        /// <summary>
        /// Fill the script description panel
        /// </summary>
        private void SetDescriptionPanel()
        {
            //DescriptionPanelIsOpen = !DescriptionPanelIsOpen;
            ScriptDescription.Clear();

            // Check if there is a description
            if (SelectedItem is CDScript script && script.Description != null)
            {
                //Dictionary<string, object> parseScriptDescription = CDParser.ParseScriptDescription(script.Description);

                //TODO : use Dictionary<string, object> parseScriptDescription
                //Dictionary<string, StringCollection> parseScriptDescription = CDParser.ParseScriptDescription(script.GetDescription());
                //foreach(string key in parseScriptDescription.Keys)
                //{
                //    string value = string.Empty;
                //    foreach(string str in parseScriptDescription[key])
                //        value += str + "\n";
                //    ScriptDescription.Add(value);
                //}
            }
        }


        /// <summary>
        /// Save the description to selected item and close the description panel
        /// </summary>
        private void SaveDescription()
        {
            //TODO: the saving stuff
            //DescriptionPanelIsOpen = false;

            // Check if there is a description
            if (SelectedItem is IReadableItem item)
            {
                Dictionary<string, string> description = new Dictionary<string, string>();
                string[] scriptInfos = CDConstants.ScriptIntro.Concat(CDConstants.ScriptDescription).ToArray();
                for (int i = 0; i < scriptInfos.Length; i++)
                    description.Add(scriptInfos[i], ScriptDescription[i]);

                CDParser.SaveDataItemDescription(item, description);
            }
        }


        #endregion Methods

    }
}
