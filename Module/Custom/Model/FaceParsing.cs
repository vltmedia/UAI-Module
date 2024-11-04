using Microsoft.ML.OnnxRuntime;
using System.Drawing;
using UAI.Common;
using UAI.Common.AI;
namespace UAI.AI.ONNX.FaceParser
{
public class FaceParsing : OnnxImageProcessor
{
    public override string[] labels { get { return labels_; } set { labels_ = value; } }

    public string[] labels_ = new string[] { "Background", "Skin", "Nose", "Glasses", "Left Eye", "Right Eye", "Left Brow", "Right Brow",   "Left Ear", "Right Ear",
          "Mouth", "Upper Lip", "Lower Lip","Hair" , "Hat", "Earring", "Necklace", "Clothing", "Clothing2", "Face", "FaceComposite" };

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
            if (!Path.HasExtension(FaceParserRuntime.args.outputPath))
            {
                if(!Directory.Exists(FaceParserRuntime.args.outputPath))
                {
                    Directory.CreateDirectory(FaceParserRuntime.args.outputPath);
                }
                }
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
            List<Bitmap> targetMasks = new List<Bitmap>() { bitmaps[1],bitmaps[11],bitmaps[12], bitmaps[13],bitmaps[3], bitmaps[2], bitmaps[4], bitmaps[5], bitmaps[10], bitmaps[8], bitmaps[9],  bitmaps[7], bitmaps[6] };
            Bitmap compositeImage = CreateCompositeMask(targetMasks);
            compositeImage = SubtractMask(compositeImage, bitmaps[0]);
            compositeImage = SubtractMask(compositeImage, bitmaps[18]);
            compositeImage = SubtractMask(compositeImage, bitmaps[17]);
            compositeImage = ResizeAndSmooth(compositeImage, compositeImage.Width, compositeImage.Height);
            if (FaceParserRuntime.args.blurRadius > 0)
            {
                compositeImage = ImageProcessor.ApplyGaussianBlur(compositeImage, FaceParserRuntime.args.blurRadius);
            }
            var faceComposite = ApplyChannelAsAlpha(inputTexture, compositeImage, 2);
            bitmaps.Add(compositeImage);
            bitmaps.Add(faceComposite);
            // Save the Masks and JSON if the options are set
            ProcessSaveMasks(bitmaps, outputPath, FaceParserRuntime.args.saveMasks);
            ProcessJSONOutput(bitmaps, outputPath +"/" + Path.GetFileNameWithoutExtension(FaceParserRuntime.args.inputPath) + ".json", FaceParserRuntime.args.saveJson);

            // Send Inference Finished Signal
            await SendInferenceFinished();
        }
        public static Bitmap ResizeAndSmooth(Bitmap original, int width, int height)
        {
            Bitmap resized = new Bitmap(width, height);

            using (Graphics g = Graphics.FromImage(resized))
            {
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.DrawImage(original, new Rectangle(0, 0, width, height));
            }

            Bitmap result = new Bitmap(original.Width, original.Height);
            using (Graphics g = Graphics.FromImage(result))
            {
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.DrawImage(resized, new Rectangle(0, 0, original.Width, original.Height));
            }

            return result;
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
