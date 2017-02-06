using SugzTools.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzExpander : Expander
    {

        #region Properties


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
        /// Get or set wheter the control shows its content on a popup when it's not expanded
        /// </summary>
        [Description("Get or set wheter the control shows its content on a popup when it's not expanded"), Category("Common")]
        public bool HasPopup
        {
            get { return (bool)GetValue(HasPopupProperty); }
            set { SetValue(HasPopupProperty, value); }
        }


        /// <summary>
        /// Get or set the placement for the  Popup. Default to Right.
        /// </summary>
        [Description("Get or set the height of the header"), Category("Common")]
        public Side PopupSide
        {
            get { return (Side)GetValue(PopupSideProperty); }
            set { SetValue(PopupSideProperty, value); }
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
        /// Get or set if the control is supposed to be used as a groupbox, which remove the popup, the dradrop button and set the header font to regular
        /// </summary>
        [Description("Get or set if the control is supposed to be used as a groupbox.\nTrue remove the popup, the dradrop button and set the header font to regular"), Category("Common")]
        public bool IsGroupBox
        {
            get { return (bool)GetValue(IsGroupBoxProperty); }
            set { SetValue(IsGroupBoxProperty, value); }
        }


        /// <summary>
        /// Get or set the visibility of the drag drag thumb. 
        /// False by default, automaticaly switch to true if the parent is a SgzExpandersControl
        /// </summary>
        [Browsable(false)]
        public bool CanDragDrop
        {
            get { return (bool)GetValue(CanDragDropProperty); }
            set { SetValue(CanDragDropProperty, value); }
        }


        #endregion



        #region Dependency Properties


        // DependencyProperty as the backing store for OldContent
        public static readonly DependencyProperty OldContentProperty = DependencyProperty.Register(
            "OldContent", 
            typeof(object), 
            typeof(SgzExpander)
        );


        // DependencyProperty as the backing store for HeaderBrush
        public static readonly DependencyProperty HeaderBrushProperty = DependencyProperty.Register(
            "HeaderBrush", 
            typeof(Brush), 
            typeof(SgzExpander), 
            new PropertyMetadata(null)
        );

        
        // DependencyProperty as the backing store for HeaderHeight
        public static readonly DependencyProperty HeaderHeightProperty = DependencyProperty.Register(
            "HeaderHeight", 
            typeof(int), 
            typeof(SgzExpander), 
            new PropertyMetadata(18)
        );

        
        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius", 
            typeof(int), 
            typeof(SgzExpander), 
            new PropertyMetadata(2)
        );


        // DependencyProperty as the backing store for HasPopup
        public static readonly DependencyProperty HasPopupProperty = DependencyProperty.Register(
            "HasPopup",
            typeof(bool),
            typeof(SgzExpander),
            new PropertyMetadata(true)
        );


        // DependencyProperty as the backing store for PopupSide
        public static readonly DependencyProperty PopupSideProperty = DependencyProperty.Register(
            "PopupSide",
            typeof(Side),
            typeof(SgzExpander),
            new PropertyMetadata(Side.Right)
        );


        // DependencyProperty as the backing store for PopupWidth
        public static readonly DependencyProperty PopupWidthProperty = DependencyProperty.Register(
            "PopupWidth",
            typeof(int),
            typeof(SgzExpander),
            new PropertyMetadata(200)
        );


        // DependencyProperty as the backing store for IsGroupBox
        public static readonly DependencyProperty IsGroupBoxProperty = DependencyProperty.Register(
            "IsGroupBox",
            typeof(bool),
            typeof(SgzExpander),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for CanDragDrop
        public static readonly DependencyProperty CanDragDropProperty = DependencyProperty.Register(
            "CanDragDrop",
            typeof(bool),
            typeof(SgzExpander),
            new PropertyMetadata(false)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzExpander()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpander), new FrameworkPropertyMetadata(typeof(SgzExpander)));
            IsExpandedProperty.OverrideMetadata(typeof(SgzExpander), new FrameworkPropertyMetadata(true));
        }
        public SgzExpander()
        {
            // Enable the drag drop icon if it's a children of a SgzExpandersControl
            Loaded += (s, e) => CanDragDrop = Parent is SgzExpandersControl;
        }


        #endregion Constructors



        #region Overridden methods


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            if (!IsGroupBox)
            {
                OldContent = Content;
                Content = null;
            }
        }


        #endregion Overridden Methods

    }
}
