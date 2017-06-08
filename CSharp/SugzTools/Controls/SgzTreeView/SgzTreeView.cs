using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzTreeView : TreeView
    {

        #region Fields


        private SgzDataTemplateSelector _TemplateSelector = new SgzDataTemplateSelector();


        #endregion Fields


        #region Properties





        #endregion Properties


        #region Dependency Properties





        #endregion Dependency Properties


        #region Constructors


        static SgzTreeView()
        {
            //DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzTreeView), new FrameworkPropertyMetadata(typeof(SgzTreeView)));
        }
        public SgzTreeView()
        {
            ItemTemplateSelector = _TemplateSelector;
        }


        #endregion Constructors


        #region Methods


        public void AddTemplate(Type type, DataTemplate template)
        {
            _TemplateSelector.Templates.Add(type, template);
        }


        #endregion Methods

    }
}