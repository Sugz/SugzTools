using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace HeadersControl
{
    public class SgzHeaderItem : ListBoxItem
    {

        public object Header
        {
            get { return (object)GetValue(HeaderProperty); }
            set { SetValue(HeaderProperty, value); }
        }

        // DependencyProperty as the backing store for Header
        public static readonly DependencyProperty HeaderProperty = DependencyProperty.Register(
            "Header",
            typeof(object),
            typeof(SgzHeaderItem)
        );



        public bool IsExpanded
        {
            get { return (bool)GetValue(IsExpandedProperty); }
            set { SetValue(IsExpandedProperty, value); }
        }

        // DependencyProperty as the backing store for IsExpanded
        public static readonly DependencyProperty IsExpandedProperty = DependencyProperty.Register(
            "IsExpanded",
            typeof(bool),
            typeof(SgzHeaderItem),
            new PropertyMetadata(true)
        );





        static SgzHeaderItem()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzHeaderItem), new FrameworkPropertyMetadata(typeof(SgzHeaderItem)));
        }

    }


    public class SgzDropIndicator : Control
    {
        static SgzDropIndicator()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDropIndicator), new FrameworkPropertyMetadata(typeof(SgzDropIndicator)));
        }
    }

}
