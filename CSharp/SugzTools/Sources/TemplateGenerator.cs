using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;
using BF = System.Reflection.BindingFlags;

namespace SugzTools.Src
{
    public static class TemplateGenerator
    {

        /// <summary>
        /// Transfer each properties and events handlers from the model to the factory
        /// </summary>
        /// <param name="control"></param>
        /// <param name="factory"></param>
        private static void SetFactory(UIElement model, FrameworkElementFactory factory)
        {
            // Transfer properties of the control to the factory
            IEnumerable<DependencyProperty> dep = Helpers.GetDependencyProperties(model).Concat(Helpers.GetAttachedProperties(model));
            dep.ForEach(x => factory.SetValue((DependencyProperty)x, model.GetValue((DependencyProperty)x)));

            // Transfer event handlers of the control to the factory
            FieldInfo[] fields = model.GetType().GetFields(BF.Static | BF.NonPublic | BF.Instance | BF.Public | BF.FlattenHierarchy);
            foreach (FieldInfo field in fields.Where(x => x.FieldType == typeof(RoutedEvent)))
            {
                RoutedEventHandlerInfo[] routedEventHandlerInfos = Helpers.GetRoutedEventHandlers(model, (RoutedEvent)field.GetValue(model));
                if (routedEventHandlerInfos != null)
                {
                    foreach (RoutedEventHandlerInfo routedEventHandlerInfo in routedEventHandlerInfos)
                        factory.AddHandler((RoutedEvent)field.GetValue(model), routedEventHandlerInfo.Handler);
                }
            }
        }


        private static void SetFactoryBinding(FrameworkElementFactory factory, Dictionary<DependencyProperty, string> bindings)
        {
            foreach(var binding in bindings)
            {
                Binding b = new Binding(binding.Value) { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };
                factory.SetBinding(binding.Key, b);
            }
        }


        public static FrameworkElementFactory GetFrameworkElementFactory(UIElement control)
        {
            return GetFrameworkElementFactory(control, null);
        }
        public static FrameworkElementFactory GetFrameworkElementFactory(UIElement control, Dictionary<DependencyProperty, string> bindings)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory() { Type = control.GetType() };
            SetFactory(control, factory);
            if (bindings != null)
                SetFactoryBinding(factory, bindings);

            return factory;
        }



        public static DataTemplate GetTemplate(UIElement control, Dictionary<DependencyProperty, string> bindings, bool isHierarchical = false)
        {
            if (isHierarchical)
            {
                return new HierarchicalDataTemplate()
                {
                    VisualTree = GetFrameworkElementFactory(control, bindings),
                    ItemsSource = new Binding("Children") { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged }
                };
            }


            return new DataTemplate() { VisualTree = GetFrameworkElementFactory(control, bindings) };
        }


        public static DataTemplate GetTemplate(UIElement container, FrameworkElementFactory[] factories, bool isHierarchical = false)
        {
            //List<DependencyObject> objects = new List<DependencyObject>();
            //Helpers.GetLogicalChildren(container, objects);

            FrameworkElementFactory containerFactory = new FrameworkElementFactory(container.GetType());
            for (int i = 0; i < factories.Length; i++)
            {
                containerFactory.AppendChild(factories[i]);
            }
                

            if (isHierarchical)
            {
                return new HierarchicalDataTemplate()
                {
                    VisualTree = containerFactory,
                    ItemsSource = new Binding("Children") { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged }
                };
            }
                

            return new DataTemplate() { VisualTree = containerFactory };
        }



        //public static DataTemplate GetTemplate(DependencyObject obj, Type templateType, Dictionary<DependencyProperty, string> bindings)
        //{



        //    List<DependencyObject> objects = new List<DependencyObject>();
        //    Helpers.GetLogicalChildren(obj, objects);


        //    foreach(DependencyObject o in objects)
        //    {
        //        FrameworkElementFactory factory = new FrameworkElementFactory() { Type = o.GetType() };
        //        SetFactory(o, factory);
        //    }

        //    return null;
        //}

    }
}
