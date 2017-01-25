using SugzTools.Src;
using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Collections.Generic;
using System.ComponentModel;
using System.Windows.Controls.Primitives;
using System.Linq;
using System.Collections.ObjectModel;

namespace SugzTools.Controls
{
    
    public class SgzExpanderItem : ListBoxItem
    {

        #region Properties


        /// <summary>
        /// Get or set the content for the Header
        /// </summary>
        [Description(""), Category("Common")]
        public object Header
        {
            get { return GetValue(HeaderProperty); }
            set { SetValue(HeaderProperty, value); }
        }


        /// <summary>
        /// Get or set the HeaderBrush property
        /// </summary>
        [Description("Get or set the color of the header"), Category("Brush")]
        public Brush HeaderBrush
        {
            get { return (Brush)GetValue(HeaderBrushProperty); }
            set { SetValue(HeaderBrushProperty, value); }
        }


        /// <summary>
        /// Get or set the height of the header
        /// </summary>
        [Description("Get or set the height of the header"), Category("Appearance")]
        public int HeaderHeight
        {
            get { return (int)GetValue(HeaderHeightProperty); }
            set { SetValue(HeaderHeightProperty, value); }
        }


        /// <summary>
        /// Get or set the CornerRadius property
        /// </summary>
        [Description("Get or set the CornerRadius"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }


        /// <summary>
        /// Get or set the expand state
        /// </summary>
        [Description("Get or set the expand state"), Category("Appearance")]
        public bool IsExpanded
        {
            get { return (bool)GetValue(IsExpandedProperty); }
            set { SetValue(IsExpandedProperty, value); }
        }


        /// <summary>
        /// Get or set wheter the control shows its content on a popup when it's not expanded
        /// </summary>
        [Description("Get or set wheter the control shows its content on a popup when it's not expanded"), Category("Common")]
        public bool HasPopup
        {
            get { return (bool)GetValue(HasPopupProperty); }
            set { SetValue(HasPopupProperty, value); }
        }


        /// <summary>
        /// Get or set a content backup to exchange it between Content and the Popup.
        /// </summary>
        [Browsable(false)]
        public object OldContent
        {
            get { return (object)GetValue(OldContentProperty); }
            set { SetValue(OldContentProperty, value); }
        }


        /// <summary>
        /// Get or set the placement for the  Popup. Default to Right.
        /// </summary>
        [Description("Get or set the height of the header"), Category("Common")]
        public PlacementMode PopUpPlacementMode
        {
            get { return (PlacementMode)GetValue(PopUpPlacementModeProperty); }
            set { SetValue(PopUpPlacementModeProperty, value); }
        }


        /// <summary>
        /// Get or set the popup width
        /// </summary>
        [Description("Get or set the popup width"), Category("Layout")]
        public int PopupWidth
        {
            get { return (int)GetValue(PopupWidthProperty); }
            set { SetValue(PopupWidthProperty, value); }
        }


        /// <summary>
        /// Show the top indicator
        /// </summary>
        [Browsable(false)]
        public bool TopIndicator
        {
            get { return (bool)GetValue(TopIndicatorProperty); }
            set { SetValue(TopIndicatorProperty, value); }
        }

        
        /// <summary>
        /// Show the bottom indicator
        /// </summary>
        [Browsable(false)]
        public bool BottomIndicator
        {
            get { return (bool)GetValue(BottomIndicatorProperty); }
            set { SetValue(BottomIndicatorProperty, value); }
        }



        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for Header
        public static readonly DependencyProperty HeaderProperty = DependencyProperty.Register(
            "Header",
            typeof(object),
            typeof(SgzExpanderItem)
        );


        // DependencyProperty as the backing store for HeaderBrush
        public static readonly DependencyProperty HeaderBrushProperty = DependencyProperty.Register(
            "HeaderBrush",
            typeof(Brush),
            typeof(SgzExpanderItem),
            new PropertyMetadata(null)
        );


        // DependencyProperty as the backing store for HeaderHeight
        public static readonly DependencyProperty HeaderHeightProperty = DependencyProperty.Register(
            "HeaderHeight",
            typeof(int),
            typeof(SgzExpanderItem),
            new PropertyMetadata(18)
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzExpanderItem),
            new PropertyMetadata(2)
        );


        // DependencyProperty as the backing store for IsExpanded
        public static readonly DependencyProperty IsExpandedProperty = DependencyProperty.Register(
            "IsExpanded",
            typeof(bool),
            typeof(SgzExpanderItem),
            new PropertyMetadata(true)
        );


        // DependencyProperty as the backing store for HasPopup
        public static readonly DependencyProperty HasPopupProperty = DependencyProperty.Register(
            "HasPopup",
            typeof(bool),
            typeof(SgzExpanderItem),
            new PropertyMetadata(true)
        );


        // DependencyProperty as the backing store for OldContent
        public static readonly DependencyProperty OldContentProperty = DependencyProperty.Register(
            "OldContent",
            typeof(object),
            typeof(SgzExpanderItem)
        );


        // DependencyProperty as the backing store for PopUpPlacementMode
        public static readonly DependencyProperty PopUpPlacementModeProperty = DependencyProperty.Register(
            "PopUpPlacementMode",
            typeof(PlacementMode),
            typeof(SgzExpanderItem),
            new PropertyMetadata(PlacementMode.Right)
        );


        // DependencyProperty as the backing store for PopupWidth
        public static readonly DependencyProperty PopupWidthProperty = DependencyProperty.Register(
            "PopupWidth",
            typeof(int),
            typeof(SgzExpanderItem),
            new PropertyMetadata(200)
        );


        // DependencyProperty as the backing store for TopIndicator
        public static readonly DependencyProperty TopIndicatorProperty = DependencyProperty.Register(
            "TopIndicator",
            typeof(bool),
            typeof(SgzExpanderItem),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for BottomIndicator
        public static readonly DependencyProperty BottomIndicatorProperty = DependencyProperty.Register(
            "BottomIndicator",
            typeof(bool),
            typeof(SgzExpanderItem),
            new PropertyMetadata(false)
        );



        #endregion Dependency Properties


        /// <summary>
        /// 
        /// </summary>
        [Browsable(false)]
        public bool IsIndicator
        {
            get { return (bool)GetValue(IsIndicatorProperty); }
            set { SetValue(IsIndicatorProperty, value); }
        }

        // DependencyProperty as the backing store for IsIndicator
        public static readonly DependencyProperty IsIndicatorProperty = DependencyProperty.Register(
            "IsIndicator",
            typeof(bool),
            typeof(SgzExpanderItem),
            new PropertyMetadata(false)
        );




        #region Constructors


        static SgzExpanderItem()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpanderItem), new FrameworkPropertyMetadata(typeof(SgzExpanderItem)));
        }
        public SgzExpanderItem()
        {
            
        }
        public SgzExpanderItem(bool isIndicator)
        {
            IsIndicator = isIndicator;
        }
        public SgzExpanderItem(string header, bool isExpanded, object content)
        {
            Header = header;
            Content = content;
            IsExpanded = isExpanded;
        }


        #endregion Constructors


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            OldContent = Content;
            Content = null;
        }



    }
    

    [StyleTypedProperty(Property = "ItemContainerStyle", StyleTargetType = typeof(SgzExpanderItem))]
    public class SgzExpanderListBox : ListBox
    {

        #region Fields


        private Point _DragStartPoint;
        private SgzExpanderItem _SourceItem;
        private Window _NewWindow;


        #endregion Fields



        #region Constructor

        static SgzExpanderListBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpanderListBox), new FrameworkPropertyMetadata(typeof(SgzExpanderListBox)));
        }
        public SgzExpanderListBox()
        {
            AddEventHandlers();
        }


        #endregion Constructor



        #region Methods



        #region Privates


        /// <summary>
        /// Helper method to get the first VisualParent of a given type
        /// </summary>
        /// <typeparam name="P"></typeparam>
        /// <param name="child"></param>
        /// <returns></returns>
        private T FindVisualParent<T>(DependencyObject child)
            where T : DependencyObject
        {
            do
            {
                if (child is T)
                    return (T)child;

                child = VisualTreeHelper.GetParent(child);
            }
            while (child != null);

            return null;
        }


        /// <summary>
        /// Add various Event Handlers to handle drag and drop
        /// </summary>
        private void AddEventHandlers()
        {
            PreviewMouseMove += List_PreviewMouseMove;
            PreviewMouseLeftButtonDown += List_PreviewMouseLeftButtonDown;
            Drop += List_Drop;

            //Loaded += (s, e) => Items.ForEach(x => ((SgzExpanderItem)x).DragOver += Item_DragOver);
            Loaded += (s, e) =>
            {
                foreach(SgzExpanderItem item in Items)
                {
                    item.DragOver += Item_DragOver;
                    //item.PreviewDragLeave += Item_PreviewDragLeave;
                }
            };

        }



        private void CreateNewWindow()
        {
            if (_NewWindow == null)
            {
                SgzExpanderListBox list = new SgzExpanderListBox();
                list.HorizontalAlignment = HorizontalAlignment.Stretch;
                list.VerticalAlignment = VerticalAlignment.Stretch;
                list.ItemsSource = new ObservableCollection<SgzExpanderItem>() { _SourceItem };


                _NewWindow = new Window();
                _NewWindow.Width = 300;
                _NewWindow.Height = 500;
                _NewWindow.Background = Resource<SolidColorBrush>.GetColor("MaxBackground");
                _NewWindow.Content = list;
                _NewWindow.Show();


            }
        }



        #endregion Privates



        #region Event Handlers


        /// <summary>
        /// Add the drop indicator depending on the mouse position over the DragOver item
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Item_DragOver(object sender, DragEventArgs e)
        {
            SgzExpanderItem item = FindVisualParent<SgzExpanderItem>(((DependencyObject)e.OriginalSource));
            if (item != null)
            {
                IList<SgzExpanderItem> items = DataContext as IList<SgzExpanderItem>;
                items.Remove(items.SingleOrDefault(x => x.IsIndicator));

                int targetIndex = items.IndexOf(item);
                items.Insert((e.GetPosition(item).Y >= (item.ActualHeight / 2) ? targetIndex + 1 : targetIndex), new SgzExpanderItem(true));
            }
        }


        /// <summary>
        /// Start the Drag and Drop process if _SourceItem exist
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void List_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Point point = e.GetPosition(null);
                Vector diff = _DragStartPoint - point;

                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(diff.X) > SystemParameters.MinimumHorizontalDragDistance || Math.Abs(diff.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    //QueryContinueDrag += List_QueryContinueDrag;
                    DragDrop.DoDragDrop(_SourceItem, _SourceItem.DataContext, DragDropEffects.Copy);
                    //DragDrop.DoDragDrop(_SourceItem, _SourceItem, DragDropEffects.Copy);
                }

            }
        }



        private void List_QueryContinueDrag(object sender, QueryContinueDragEventArgs e)
        {
            if (e.KeyStates == DragDropKeyStates.None)
            {
                QueryContinueDrag -= List_QueryContinueDrag;
                e.Handled = true;
                Console.WriteLine("I'm gonna drop here, bitch !!");

                
                
            }
        }


        /// <summary>
        /// Define _DragStartPoint and _SourceItem
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void List_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            _DragStartPoint = e.GetPosition(null);

            SgzIcon dragIcon = FindVisualParent<SgzIcon>(((DependencyObject)e.OriginalSource));
            if (dragIcon != null && dragIcon.Name == "PART_Drag")
            {
                SgzExpanderItem sgzExpanderItem = FindVisualParent<SgzExpanderItem>(((DependencyObject)e.OriginalSource));
                if (sgzExpanderItem != null)
                    _SourceItem = sgzExpanderItem;
            }
        }


        /// <summary>
        /// Move _SourceItem to the drop indiactor position
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void List_Drop(object sender, DragEventArgs e)
        {
            IList<SgzExpanderItem> items = DataContext as IList<SgzExpanderItem>;
            if (items != null && _SourceItem != null)
            {
                SgzExpanderItem indicator = items.SingleOrDefault(x => x.IsIndicator);
                items.RemoveAt(items.IndexOf(_SourceItem));
                items.Insert(items.IndexOf(indicator), _SourceItem);

                items.Remove(indicator);
                _SourceItem = null;
            }
        }


        #endregion Event Handlers



        #endregion Methods

    }
}




//TODO: delete indicator on aborted drag or when mouse leave the listbox
//TODO: OnApplyTemplate() => GetTemplateChild("") as ; to get stuff like SgzIcon