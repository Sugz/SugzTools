namespace SugzTools
{
    using System;

    public class Test
    {
        public event EventHandler ValueChanged;
        private double _Value;
        public double Value
        {
            get { return _Value; }
            set
            {
                _Value = value;
                ValueChanged?.Invoke(this, new EventArgs());
            }
        }


        private string _Name;
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }


    }
}
