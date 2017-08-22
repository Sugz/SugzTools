using SugzTools.Src;
using SugzTools.Extensions;
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
        /// Transfer each properties and events handlers from the model to the FrameworkElementFactory
        /// </summary>
        /// <param name="control"></param>
        /// <param name="factory"></param>
        public static void TransferPropertiesAndEventHandlers(UIElement model, FrameworkElementFactory factory)
        {
            // Transfer properties of the control to the factory
            IEnumerable<DependencyProperty> dep = Helpers.GetDependencyProperties(model).Concat(Helpers.GetAttachedProperties(model));
            dep.ForEach(x => factory.SetValue(x, model.GetValue(x)));


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

        /// <summary>
        /// Set bindings to the FrameworkElementFactory
        /// </summary>
        /// <param name="factory"></param>
        /// <param name="bindings"></param>
        public static void SetFactoryBinding(FrameworkElementFactory factory, Dictionary<DependencyProperty, string> bindings)
        {
            foreach(KeyValuePair<DependencyProperty, string> binding in bindings)
            {
                Binding b = new Binding(binding.Value) { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged };
                factory.SetBinding(binding.Key, b);
            }
        }



        /// <summary>
        /// Create a FrameworkElementFactory from a control and get all of its properties and event handlers.
        /// </summary>
        /// <param name="control"></param>
        /// <returns></returns>
        public static FrameworkElementFactory GetFrameworkElementFactory(UIElement control)
        {
            return GetFrameworkElementFactory(control, null);
        }

        /// <summary>
        /// Create a FrameworkElementFactory from a control and get all of its properties and event handlers.
        /// Assign binding to the FrameworkElementFactory.
        /// </summary>
        /// <param name="control"></param>
        /// <param name="bindings"></param>
        /// <returns></returns>
        public static FrameworkElementFactory GetFrameworkElementFactory(UIElement control, Dictionary<DependencyProperty, string> bindings)
        {
            FrameworkElementFactory factory = new FrameworkElementFactory() { Type = control.GetType() };
            TransferPropertiesAndEventHandlers(control, factory);
            if (bindings != null)
                SetFactoryBinding(factory, bindings);

            return factory;
        }



        /// <summary>
        /// Get a FrameworkElementFactory from a container that will contain the provided FrameworkElementFactorys.
        /// </summary>
        /// <param name="container"></param>
        /// <param name="factories"></param>
        /// <returns></returns>
        public static FrameworkElementFactory AddFactoriestoContainer(UIElement container, FrameworkElementFactory[] factories)
        {
            FrameworkElementFactory containerFactory = new FrameworkElementFactory(container.GetType());
            for (int i = 0; i < factories.Length; i++)
                containerFactory.AppendChild(factories[i]);

            return containerFactory;
        }



        /// <summary>
        /// Get a DataTemplate from a FrameworkElementFactory.
        /// </summary>
        /// <param name="container"></param>
        /// <param name="factories"></param>
        /// <returns></returns>
        public static DataTemplate GetTemplate(FrameworkElementFactory factory)
        {
            return new DataTemplate() { VisualTree = factory };
        }

        /// <summary>
        /// Get a DataTemplate composed of a container that contain the provided FrameworkElementFactorys.
        /// </summary>
        /// <param name="container"></param>
        /// <param name="factories"></param>
        /// <returns></returns>
        public static DataTemplate GetTemplate(UIElement container, FrameworkElementFactory[] factories)
        {
            return new DataTemplate() { VisualTree = AddFactoriestoContainer(container, factories) };
        }



        /// <summary>
        /// Get a HierarchicalDataTemplate from a FrameworkElementFactory.
        /// Use The property Children for the hierarchical binding.
        /// </summary>
        /// <param name="container"></param>
        /// <param name="factories"></param>
        /// <returns></returns>
        public static HierarchicalDataTemplate GetHierarchicalTemplate(FrameworkElementFactory factory)
        {
            return new HierarchicalDataTemplate()
            {
                VisualTree = factory,
                ItemsSource = new Binding("Children") { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged }
            };
        }

        /// <summary>
        /// Get a HierarchicalDataTemplate composed of a container that contain the provided FrameworkElementFactorys.
        /// Use The property Children for the hierarchical binding.
        /// </summary>
        /// <param name="container"></param>
        /// <param name="factories"></param>
        /// <returns></returns>
        public static HierarchicalDataTemplate GetHierarchicalTemplate(UIElement container, FrameworkElementFactory[] factories)
        {
            return new HierarchicalDataTemplate()
            {
                VisualTree = AddFactoriestoContainer(container, factories),
                ItemsSource = new Binding("Children") { UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged }
            };
        }
    }
}
