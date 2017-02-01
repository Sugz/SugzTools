using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;

namespace HeadersControl
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


        #endregion Dependency Properties




        static SgzExpanderItem()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpanderItem), new FrameworkPropertyMetadata(typeof(SgzExpanderItem)));
        }


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            OldContent = Content;
            Content = null;
        }

    }


    public class SgzDropIndicator : ListBoxItem
    {
        static SgzDropIndicator()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDropIndicator), new FrameworkPropertyMetadata(typeof(SgzDropIndicator)));
        }
    }

}
