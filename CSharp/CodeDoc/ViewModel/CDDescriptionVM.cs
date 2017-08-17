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
        private Visibility _MissingDescriptionVisibility = Visibility.Collapsed;                            // The visibility of the missing description panel in the status panel
        private bool _DescriptionPanelIsOpen = false;                                                       // The opening state of the description panel
        private Visibility _EditButtonVisibility = Visibility.Collapsed;                                    // The edit button visibility
        private ObservableCollection<string> _ScriptDescription = new ObservableCollection<string>();       // The collection use to fill and save script description

        private RelayCommand _SetDescriptionPanelCommand;
        private RelayCommand _DontSetDescriptionCommand;
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

                if (DescriptionPanelIsOpen)
                    DescriptionPanelIsOpen = false;
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
        /// Set the visibility of the missing description panel in the status panel
        /// </summary>
        public Visibility MissingDescriptionVisibility
        {
            get { return _MissingDescriptionVisibility; }
            set { Set(ref _MissingDescriptionVisibility, value); }
        }

        /// <summary>
        /// Set the open / close state of the description panel
        /// </summary>
        public bool DescriptionPanelIsOpen
        {
            get { return _DescriptionPanelIsOpen; }
            set
            {
                Set(ref _DescriptionPanelIsOpen, value);
                MessengerInstance.Send(new CDStatusMessage(false));
            }
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
        public RelayCommand DontSetDescriptionCommand
        {
            get { return _DontSetDescriptionCommand ?? (_DontSetDescriptionCommand = new RelayCommand(() => MessengerInstance.Send(new CDStatusMessage(false)))); }
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
            MessengerInstance.Register<CDSelectedItemMessage>(this, x => SelectedItem = x.Sender);
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

            // Get selected item descriprion
            CDParser.FormatDataItemDescription(SelectedItem, ref _Document);

            // Show the edit button when the selected item isn't a folder
            if (SelectedItem is CDFolder folder)
                EditButtonVisibility = Visibility.Collapsed;
            else if (SelectedItem is IDescriptiveItem item)
            {
                EditButtonVisibility = Visibility.Visible;

                // Check if there is a description
                if (item.IsMissingDescription)
                {
                    MissingDescriptionVisibility = Visibility.Visible;
                    MessengerInstance.Send(new CDStatusMessage(string.Empty, false, false));
                }
            }
        }


        /// <summary>
        /// Fill the script description panel
        /// </summary>
        private void SetDescriptionPanel()
        {
            DescriptionPanelIsOpen = !DescriptionPanelIsOpen;
            ScriptDescription.Clear();

            // Check if there is a description
            if (SelectedItem is IDescriptiveItem item && !item.IsMissingDescription)
            {
                if (item is CDScript script)
                {
                    Dictionary<string, object> parseScriptDescription = CDParser.ParseScriptDescription(script.GetDescription());
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
        }


        /// <summary>
        /// Save the description to selected item and close the description panel
        /// </summary>
        private void SaveDescription()
        {
            //TODO: the saving stuff
            DescriptionPanelIsOpen = false;

            // Check if there is a description
            if (SelectedItem is IDescriptiveItem item)
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
