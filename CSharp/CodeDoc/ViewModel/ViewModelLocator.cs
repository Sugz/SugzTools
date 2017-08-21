using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Ioc;
using Microsoft.Practices.ServiceLocation;
using CodeDoc.Model;
using System.Diagnostics.CodeAnalysis;

namespace CodeDoc.ViewModel
{
    /// <summary>
    /// This class contains static references to all the view models in the
    /// application and provides an entry point for the bindings.
    /// <para>
    /// See http://www.mvvmlight.net
    /// </para>
    /// </summary>
    public class ViewModelLocator
    {
        static ViewModelLocator()
        {
            ServiceLocator.SetLocatorProvider(() => SimpleIoc.Default);
            SimpleIoc.Default.Register<CDMainVM>();
            SimpleIoc.Default.Register<CDDataVM>();
            SimpleIoc.Default.Register<CDDescriptionVM>();
        }

        /// <summary>
        /// Gets the Main property.
        /// </summary>
        [SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic",
            Justification = "This non-static member is needed for data binding purposes.")]
        public CDMainVM Main => ServiceLocator.Current.GetInstance<CDMainVM>();

        public CDDataVM Data => ServiceLocator.Current.GetInstance<CDDataVM>();

        public CDDescriptionVM Description => ServiceLocator.Current.GetInstance<CDDescriptionVM>();


        /// <summary>
        /// Cleans up all the resources.
        /// </summary>
        public static void Cleanup()
        {
        }
    }
}