using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;

namespace CodeDoc.View
{
    public class BindableRTB : RichTextBox
    {

        // Dependency Properties
        #region Dependency Properties


        // Document property
        public static readonly DependencyProperty DocumentProperty = DependencyProperty.Register(
            "Document", 
            typeof(FlowDocument),
            typeof(BindableRTB), 
            new FrameworkPropertyMetadata(null, new PropertyChangedCallback(OnDocumentChanged)));


        #endregion // End Dependency Properties



        // Properties
        #region Properties


        /// <summary>
        /// The WPF FlowDocument contained in the control.
        /// </summary>
        public new FlowDocument Document
        {
            get { return (FlowDocument)GetValue(DocumentProperty); }
            set { SetValue(DocumentProperty, value); }
        }


        #endregion // End Properties



        // Constructors
        #region Constructors 


        public BindableRTB()
        {
            // Prevent user to change the text
            PreviewKeyDown += (s, e) => e.Handled = true;
        }


        #endregion // End Constructors



        // Methods
        #region Methods


        public static void OnDocumentChanged(DependencyObject obj, DependencyPropertyChangedEventArgs args)
        {
            RichTextBox rtb = (RichTextBox)obj;
            rtb.Document = (FlowDocument)args.NewValue;
        }


        #endregion // End Methods

    }
}
