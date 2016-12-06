using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace CodeDoc.Src
{
    public static class CDConstant
    {
        /*
        public static List<string> ScriptKeyWords = new List<string>()
        {
            "Script Infos",
            "Required Components",
            "Sources",
            "To Do",
            "History"
        };


        public static List<string> FunctionKeyWords = new List<string>()
        {
            "Description:",
            "Arguments:",
            "Return:",
            "Further Infos:"
        };
        */

        public static Dictionary<string, string> Types = new Dictionary<string, string>()
        {
            { "Array", "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_A5B54C67_BFDD_45C0_9D6B_E6869817282A_htm" },
            { "String", "http://help.autodesk.com/view/3DSMAX/2016/ENU//?guid=__files_GUID_A6A60FC7_6206_4FFC_80E2_0EF8544BE2C4_htm" },
            { "Name", "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_19058A42_F710_48A4_8F8B_A52597748EAA_htm" },
            { "Bool", "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_BCAFBD54_CE0D_40D0_8424_99E1FE1518CC_htm" },
            { "Stringstream", "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_DB8A8E34_179F_4264_86E3_D0CD9AB836A6_htm" },
            { "Filestream", "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_BB041082_3EEF_4576_9D69_5B258A59065E_htm" },
            { "Node", "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_AB920CA1_5DC2_44F5_9B3C_2B6D5047AC8A_htm" }

        };


        public static List<string> Numbers = new List<string>()
        {
            "Integer",
            "Float",
            "Double",
            "Integer64",
            "Integerptr"
        };


        public static Regex LinkParser = new Regex(@"http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?", RegexOptions.Compiled | RegexOptions.IgnoreCase);


    }
}
