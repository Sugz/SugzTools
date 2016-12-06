using System;
using System.Windows.Input;

namespace SugzMVVM
{

    /// RelayCommand is a very easy-to-use implementation of ICommand. You can use a RelayCommand to expose viewmodel functionality as a command, and
    /// supply the condition that determines the command's availability. A control in the view bound to a command can execute an available command will
    /// update its enabled state in response to the availability of the command.
    public sealed class RelayCommand : ICommand
    {
        // Fields
        #region Fields

        readonly Predicate<object> canExecute;
        readonly Action<object> execute;

        #endregion // End Fields



        // Constructors
        #region Constructors

        public RelayCommand(Action<object> execute) : this(execute, null) { }

        public RelayCommand(Action<object> execute, Predicate<object> canExecute)
        {
            this.execute = execute;
            this.canExecute = canExecute;
        }

        #endregion // End Constructors



        // Methods
        #region Methods

        public void RaiseCanExecuteChanged()
        {
            CanExecuteChanged?.Invoke(this, EventArgs.Empty);
        }

        #endregion // End Methods



        // ICommand Events
        #region ICommand Events

        public event EventHandler CanExecuteChanged;

        #endregion // End ICommand Events



        // ICommand Methods
        #region ICommand Methods

        public bool CanExecute(object parameter)
        {
            return canExecute != null ? canExecute(parameter) : true;
        }

        public void Execute(object parameter)
        {
            execute?.Invoke(parameter);
        }

        #endregion // End ICommand Methods

    }
}
