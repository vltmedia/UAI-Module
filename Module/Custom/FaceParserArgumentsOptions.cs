using CommandLine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UAI.ConsoleApp;

namespace UAI.AI.ONNX.FaceParser
{
    public class FaceParserArgumentsOptions: ArgumentsOptions
    {
        [Option('b', "blur", Required = false, HelpText = "How much to blur ")]
        public int blurRadius  { get; set; }
    }
}
