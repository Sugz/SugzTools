using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Collections.Generic;
using System.ComponentModel;
using SugzTools.Src;
using System.Windows.Controls.Primitives;

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





        #region Constructors


        static SgzExpanderItem()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpanderItem), new FrameworkPropertyMetadata(typeof(SgzExpanderItem)));
        }
        public SgzExpanderItem()
        {
            
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
        protected SgzExpanderItem _SourceItem;
        protected SgzExpanderItem _TargetItem;


        #endregion Fields


        #region Constructor

        static SgzExpanderListBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpanderListBox), new FrameworkPropertyMetadata(typeof(SgzExpanderListBox)));
        }
        public SgzExpanderListBox()
        {
            AddEventHandlers();

            Loaded += (s, e) =>
            {
                foreach (SgzExpanderItem item in Items)
                    item.DragEnter += ListBoxItem_DragEnter;
            };
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
        }



        #endregion Privates



        #region Event Handlers


        private void ListBoxItem_DragEnter(object sender, DragEventArgs e)
        {
            SgzExpanderItem sgzExpanderItem = FindVisualParent<SgzExpanderItem>(((DependencyObject)e.OriginalSource));
            if (sgzExpanderItem != null && sgzExpanderItem != _SourceItem)
            {
                _TargetItem = sgzExpanderItem;

                //IList<SgzExpanderItem> items = DataContext as IList<SgzExpanderItem>;
                //if (items != null && _SourceItem != null)
                //{
                //    if (Items.IndexOf(_SourceItem) < Items.IndexOf(_TargetItem))
                //        _TargetItem.BottomIndicator = true;
                //    else
                //        _TargetItem.TopIndicator = true;

                //}
            }

        }



        private void List_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Point point = e.GetPosition(null);
                Vector diff = _DragStartPoint - point;

                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(diff.X) > SystemParameters.MinimumHorizontalDragDistance ||
                        Math.Abs(diff.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    SgzExpanderItem sgzExpanderItem = FindVisualParent<SgzExpanderItem>(((DependencyObject)e.OriginalSource));
                    if (sgzExpanderItem != null)
                        DragDrop.DoDragDrop(sgzExpanderItem, sgzExpanderItem.DataContext, DragDropEffects.Move);

                }
            }
        }



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



        private void List_Drop(object sender, DragEventArgs e)
        {
            IList<SgzExpanderItem> items = DataContext as IList<SgzExpanderItem>;
            if (items != null && _SourceItem != null)
            {
                int sourceIndex = Items.IndexOf(_SourceItem);
                int targetIndex = Items.IndexOf(_TargetItem);

                if (sourceIndex < targetIndex)
                {
                    items.Insert(targetIndex + 1, _SourceItem);
                    items.RemoveAt(sourceIndex);
                }
                else
                {
                    int removeIndex = sourceIndex + 1;
                    if (items.Count + 1 > removeIndex)
                    {
                        items.Insert(targetIndex, _SourceItem);
                        items.RemoveAt(removeIndex);
                    }
                }

                _SourceItem = null;
            }
        }


        #endregion Event Handlers



        #endregion Methods

    }
}
