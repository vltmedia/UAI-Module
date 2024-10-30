using Microsoft.ML.OnnxRuntime;
using System.Drawing;
using UAI.Common.AI;
namespace UAI.AI.ONNX.FaceParser
{
public class FaceParsing : OnnxImageProcessor
{
    public override string[] labels { get { return labels_; } set { labels_ = value; } }

    public string[] labels_ = new string[] { "Background", "Skin", "Nose", "Glasses", "Left Eye", "Right Eye", "Left Brow", "Right Brow",   "Left Ear", "Right Ear",
          "Mouth", "Upper Lip", "Lower Lip","Hair" , "Hat", "Earring", "Necklace", "Clothing" };

        public FaceParsing(string modelPath) : base(modelPath)
        {
          

        }

        public override void Start()
	{
		base.Start();

            SetInputName("input","pixel_values");
            SetInputDimensions("pixel_values", new List<int>() { 1, 3, 512, 512 });
            SetOutputName("output","logits");
            SetOutputDimensions("logits", new List<int>() { 1, 18, 512, 512 });
	}

  
	public override async Task RunOnnxInference()
        {

            await base.RunOnnxInference();

            // Setup Ouptuts based on inputImage
            config.onnxMetaData.Inputs[0].dimensions = new List<int>() { 1, 3, inputImageSize.x, inputImageSize.y };
            config.onnxMetaData.Outputs[0].dimensions = new List<int>() { 1, 18, inputImageSize.x, inputImageSize.y };
            var outputPath = FaceParserRuntime.args.outputPath;

            // PreProcess Data
            var inputData = CreateOnnxInput(MatToTensor(Texture2DToMat(inputTexture, inputImageSize)));

            // Process Image
            IDisposableReadOnlyCollection<DisposableNamedOnnxValue> results = _session.Run(inputData, CreateOnnxOutput());
            
            // Process the Output Data
            var rest = GetResultTensors(results);
            List<Bitmap> bitmaps = ConvertTensorsToBitmaps(inputImageSize, rest);


            // Save the Masks and JSON if the options are set
            ProcessSaveMasks(bitmaps, outputPath, FaceParserRuntime.args.saveMasks);
            ProcessJSONOutput(bitmaps, outputPath +"/" + Path.GetFileNameWithoutExtension(FaceParserRuntime.args.inputPath) + "_masks.json", FaceParserRuntime.args.saveJson);

            // Send Inference Finished Signal
            await SendInferenceFinished();
        }

       
        public virtual async Task SendInferenceFinished()
        {
           Console.WriteLine("Inference Finished");
        }

        // Called every frame. 'delta' is the elapsed time since the previous frame.
        public override void Update(float delta)
	{
	}
}
}
