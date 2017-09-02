using SugzTools.Src;
using SugzTools.Max;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;
using CodeDoc.Src;
using System.Diagnostics;
using System.IO;
using System.Text.RegularExpressions;
using SugzTools.Extensions;
using System.Xml.Linq;
using MaxscriptManager.Src;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            string s = "activeGrid ambientColor ambientColorController animationRange animButtonEnabled animButtonState backgroundColor backgroundColorController backgroundImageFileName currentMaterialLibrary currentTime displayGamma fileInGamma fileOutGamma displaySafeFrames editorFont editorFontSize editorShowPath editorTabWidth escapeEnable environmentMap flyOffTime frameRate globalTracks hardwareLockID heapFree heapSize hotspotAngleSeparation inputTextColor lightLevel lightLevelController lightTintColor lightTintColorController listener localTime macroRecorder manipulateMode maxFileName maxFilePath messageTextColor numEffects numAtmospherics numSubObjectLevels outputTextColor playActiveOnly realTimePlayback renderer renderDisplacements renderEffects renderHeight renderPixelAspect renderWidth rendOutputFilename rendSimplifyAreaLights rootNode rootScene sceneMaterials scriptsPath showEndResult skipRenderedFrames sliderTime stackLimit subObjectLevel ticksPerFrame timeDisplayMode trackViewNodes useEnvironmentMap videoPostTracks";
            string[] strs = s.Split(' ');
            strs.ForEach(x => Debug.WriteLine($"<Word>{x}</Word>"));
            //List<string> strings = new List<string>();
            //foreach(string s in MConstants.ParserColors["DarkGreenText"])
            //{
            //    int dotIndex = s.IndexOf(".");
            //    if (dotIndex != -1)
            //    {
            //        string title = s.Substring(0, dotIndex);
            //        if (!strings.Contains(title))
            //            strings.Add(title);
            //    }
                
            //}

            //strings.ForEach(x => Debug.WriteLine(x));
        }


    }
}
