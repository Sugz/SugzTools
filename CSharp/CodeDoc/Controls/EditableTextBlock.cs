using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace CodeDoc.Controls
{
    [TemplatePart(Type = typeof(Grid), Name = GRID_NAME)]
    [TemplatePart(Type = typeof(TextBlock), Name = TEXTBLOCK_DISPLAYTEXT_NAME)]
    [TemplatePart(Type = typeof(TextBox), Name = TEXTBOX_EDITTEXT_NAME)]
    public class EditableTextBlock : Control
    {

        #region Constants

        private const string GRID_NAME = "PART_GridContainer";
        private const string TEXTBLOCK_DISPLAYTEXT_NAME = "PART_TbDisplayText";
        private const string TEXTBOX_EDITTEXT_NAME = "PART_TbEditText";

        #endregion


        #region Member Fields

        private Grid m_GridContainer;
        private TextBlock m_TextBlockDisplayText;
        private TextBox m_TextBoxEditText;

        #endregion


        #region Dependency Properties

        public string Text
        {
            get { return (string)GetValue(TextProperty); }
            set { SetValue(TextProperty, value); }
        }
        public static readonly DependencyProperty TextProperty = DependencyProperty.Register(
            "Text", 
            typeof(string), 
            typeof(EditableTextBlock)
        );


        #endregion


        #region Constructor

        static EditableTextBlock()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(EditableTextBlock), new FrameworkPropertyMetadata(typeof(EditableTextBlock)));
        }

        #endregion


        #region Overrides Methods

        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();
            m_GridContainer = Template.FindName(GRID_NAME, this) as Grid;
            if (m_GridContainer != null)
            {
                m_TextBlockDisplayText = m_GridContainer.Children[0] as TextBlock;
                m_TextBoxEditText = m_GridContainer.Children[1] as TextBox;
                m_TextBoxEditText.LostFocus += OnTextBoxLostFocus;
            }
        }

        protected override void OnMouseDoubleClick(MouseButtonEventArgs e)
        {
            base.OnMouseDoubleClick(e);
            m_TextBlockDisplayText.Visibility = Visibility.Collapsed;
            m_TextBoxEditText.Visibility = Visibility.Visible;
        }

        #endregion



        #region Event Handlers

        private void OnTextBoxLostFocus(object sender, RoutedEventArgs e)
        {
            m_TextBlockDisplayText.Visibility = Visibility.Visible;
            m_TextBoxEditText.Visibility = Visibility.Collapsed;
        }

        #endregion

    }
}
