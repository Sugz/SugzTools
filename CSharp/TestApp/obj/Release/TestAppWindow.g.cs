﻿#pragma checksum "..\..\TestAppWindow.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "E8F5BD7A320D60EBC5CFB8A94CA85A54"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using SugzTools.Controls;
using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Shell;
using TestApp;


namespace TestApp {
    
    
    /// <summary>
    /// MainWindow
    /// </summary>
    public partial class MainWindow : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 19 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal SugzTools.Controls.SgzExpander sgzExpander;
        
        #line default
        #line hidden
        
        
        #line 39 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal SugzTools.Controls.SgzTextBox txt;
        
        #line default
        #line hidden
        
        
        #line 86 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal SugzTools.Controls.SgzNumericUpDown intSpinner;
        
        #line default
        #line hidden
        
        
        #line 93 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBlock intTxt;
        
        #line default
        #line hidden
        
        
        #line 94 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBlock intTxt2;
        
        #line default
        #line hidden
        
        
        #line 95 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBlock intTxt3;
        
        #line default
        #line hidden
        
        
        #line 96 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal SugzTools.Controls.SgzNumericUpDown floatSpinner;
        
        #line default
        #line hidden
        
        
        #line 99 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBlock floatTxt;
        
        #line default
        #line hidden
        
        
        #line 100 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBlock floatTxt2;
        
        #line default
        #line hidden
        
        
        #line 101 "..\..\TestAppWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBlock floatTxt3;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/TestApp;component/testappwindow.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\TestAppWindow.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            this.sgzExpander = ((SugzTools.Controls.SgzExpander)(target));
            return;
            case 2:
            
            #line 32 "..\..\TestAppWindow.xaml"
            ((SugzTools.Controls.SgzButton)(target)).Click += new System.Windows.RoutedEventHandler(this.SgzButton_Click);
            
            #line default
            #line hidden
            return;
            case 3:
            this.txt = ((SugzTools.Controls.SgzTextBox)(target));
            return;
            case 4:
            this.intSpinner = ((SugzTools.Controls.SgzNumericUpDown)(target));
            return;
            case 5:
            this.intTxt = ((System.Windows.Controls.TextBlock)(target));
            return;
            case 6:
            this.intTxt2 = ((System.Windows.Controls.TextBlock)(target));
            return;
            case 7:
            this.intTxt3 = ((System.Windows.Controls.TextBlock)(target));
            return;
            case 8:
            this.floatSpinner = ((SugzTools.Controls.SgzNumericUpDown)(target));
            return;
            case 9:
            this.floatTxt = ((System.Windows.Controls.TextBlock)(target));
            return;
            case 10:
            this.floatTxt2 = ((System.Windows.Controls.TextBlock)(target));
            return;
            case 11:
            this.floatTxt3 = ((System.Windows.Controls.TextBlock)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}

