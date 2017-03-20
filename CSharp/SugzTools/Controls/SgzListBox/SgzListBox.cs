using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls.SgzListBox
{
    public enum PropertyType
    {
        Bool,
        Int,
        Float,
        String,
        List,
    }

    public enum PropertyUI
    {
        Checkbox,
        Checkbutton,
        Spinner,
        Textblock,
        Textbox,
        ComboBox,
    }

    public class SgzListBox : ListBox
    {

        


        public void AddProperty(PropertyType type, PropertyUI ui)
        {
            // Check if the ui is compatible with the type
            if (type == PropertyType.Bool && (ui != PropertyUI.Checkbox || ui != PropertyUI.Checkbutton))
                return;
            if ((type == PropertyType.Int || type == PropertyType.Float) && ui != PropertyUI.Spinner)
                return;
            if (type == PropertyType.String && (ui != PropertyUI.Textblock || ui != PropertyUI.Textbox))
                return;
            if (type == PropertyType.List && ui != PropertyUI.ComboBox)
                return;





            DataTemplate template = ItemTemplate;

        }

    }
}
