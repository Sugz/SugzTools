// Code from Nic Strong: https://stackoverflow.com/a/842554/3971575

using System.Collections.Generic;
using System.IO;

namespace SugzTools.Src
{
    public class PeekableStreamReaderAdapter
    {
        private StreamReader Underlying;
        private Queue<string> BufferedLines;

        public PeekableStreamReaderAdapter(StreamReader underlying)
        {
            Underlying = underlying;
            BufferedLines = new Queue<string>();
        }

        public string PeekLine()
        {
            string line = Underlying.ReadLine();
            if (line == null)
                return null;
            BufferedLines.Enqueue(line);
            return line;
        }


        public string ReadLine()
        {
            if (BufferedLines.Count > 0)
                return BufferedLines.Dequeue();
            return Underlying.ReadLine();
        }
    }
}
