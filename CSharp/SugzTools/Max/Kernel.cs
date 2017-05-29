using Autodesk.Max;

namespace SugzTools.Max
{
    public class Kernel
    {

        #region Fields


        public static IInterface16 Interface;
        public static IGlobal Global;

        #endregion



        #region Constructor 


        static Kernel()
        {
            // If this is ever NULL, it is probably because 3ds Max has not yet loaded 
            // Autodesk.Max.Wrappers.dll
            Global = GlobalInterface.Instance;
            Interface = Global.COREInterface16;
        }




        #endregion 



        #region Methods 


        #region Public 

        /// <summary>
        /// Execute some maxscript
        /// </summary>
        /// <param name="mxsCommand">the code to execute</param>
        public static void RunMxs(string mxsCommand)
        {
            Global.ExecuteMAXScriptScript(mxsCommand, false, null);
        }


        /// <summary>
        /// Print text in the listener
        /// </summary>
        /// <param name="text"></param>
        public static void Print(string text)
        {
            Global.TheListener.EditStream.Wputs(text);
            Global.TheListener.EditStream.Flush();
        }


        


        #endregion


        #endregion



    }
}
