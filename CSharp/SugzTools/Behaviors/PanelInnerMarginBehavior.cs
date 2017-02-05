using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace SugzTools.Behaviors
{
    public class PanelInnerMarginBehavior : Behavior<Panel>
    {

        public Thickness Value { get; set; } = new Thickness(0);

        protected override void OnAttached()
        {
            AssociatedObject.Loaded += SetChildrenMargin;
            base.OnAttached();
        }


        protected override void OnDetaching()
        {
            AssociatedObject.Loaded -= SetChildrenMargin;
            base.OnDetaching();
        }


        private void SetChildrenMargin(object sender, RoutedEventArgs e)
        {
            Panel panel = sender as Panel;
            foreach (FrameworkElement child in panel.Children)
            {
                if (child == null)
                    continue;

                child.Margin = new Thickness
                (
                    child.Margin.Left + Value.Left,
                    child.Margin.Top + Value.Top,
                    child.Margin.Right + Value.Right,
                    child.Margin.Bottom + Value.Bottom
                );
            }

            panel.Loaded -= SetChildrenMargin;
        }

    }
}
