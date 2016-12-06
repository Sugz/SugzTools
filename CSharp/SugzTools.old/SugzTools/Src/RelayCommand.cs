using System;
using System.Windows.Input;

namespace SugzTools.Src
{
    public class RelayCommand : ICommand
    {

        // Fields
        #region Fields

        private Action<object> _action;
        private Predicate<object> _canExecute;


        #endregion // End Fields



        // Constructors
        #region Constructors


        public RelayCommand(Action<object> execute) : this(execute, null) { }


        public RelayCommand(Action<object> action, Predicate<object> canExecute)
        {
            //if (action == null) throw new ArgumentNullException("execute");
            _action = action;
            _canExecute = canExecute;
        }


        #endregion // End Constructors



        // Methods
        #region Methods


        public bool CanExecute(object parameter)
        {
            return _canExecute == null ? true : _canExecute(parameter);
        }

        public void Execute(object parameter)
        {
            _action(parameter);
        }


        #endregion // End Methods



        // Events
        #region Events


        public event EventHandler CanExecuteChanged;


        #endregion // End Events
    }
}
