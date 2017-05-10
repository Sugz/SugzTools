using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    /*
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
    */

    public class SgzListView : ListView
    {
        #region Fields


        GridView gridView;
        ClassGenerator classGen = new ClassGenerator();


        #endregion Fields




        #region Constructors


        static SgzListView()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzListView), new FrameworkPropertyMetadata(typeof(SgzListView)));
        }
        public SgzListView()
        {
            Loaded += SgzListView_Loaded;
        }



        #endregion Constructors


        private void SgzListView_Loaded(object sender, RoutedEventArgs e)
        {
            View = gridView ?? (gridView = new GridView());
        }



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


            //classGen.AddProperties(typeof(double), "Value", true);
            //classGen.AddProperties(typeof(string), "Name", false);
            //var MyClass = classGen.GenerateCSharpCode();

        }



        private void SetModel()
        {

        }

    }
}
