using System.Diagnostics;
using System.Windows.Forms;
using UAI.AI.ONNX.FaceParser;
using SharpREST;

namespace GUI
{
    public partial class Form1 : Form
    {
        public static FaceParserRuntime runtime;
        public static string[] args = new string[] { };
        public static FaceParserArgumentsOptions argumentsOptions { get { return FaceParserRuntime.args; } set { FaceParserRuntime.args = value; } }
        public Form1()
        {
            InitializeComponent();
            args = new string[] { "-m", "./model/model_quantized.onnx" };
            runtime = new FaceParserRuntime(args);
            argumentsOptions = new FaceParserArgumentsOptions();
            argumentsOptions.modelPath = $"{AppContext.BaseDirectory}/model/model_quantized.onnx";

        }

        private void buttonImport_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                // Set filter options and title for the file dialog
                openFileDialog.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif";
                openFileDialog.Title = "Select an Image";

                // Show the dialog and check if the user selected a file
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    // Load the selected image into the PictureBox
                    inputImage.Image = Image.FromFile(openFileDialog.FileName);
                    inputImage.SizeMode = PictureBoxSizeMode.AutoSize; // Optional, to fit the image in PictureBox
                }
            }
        }

        private async void Form1_Load(object sender, EventArgs e)
        {
            RestServer.routes.Add(new RestRouteBase(RestRequestType.GET, "/test", (request) =>
            {
                Console.WriteLine("GET request received");
                RestServer.ProcessResult(request, "Hey this is the response!", 200);
            }));

            await Task.Run(() => RestServer.Instance.StartServer(8088));

            //RestServer.Instance.StartServer(8088);

        }

        private async void buttonRunProcess_Click(object sender, EventArgs e)
        {
            string id = Guid.NewGuid().ToString();
            string tempDirectory = Path.GetFullPath($"{Path.GetTempPath()}UAI/Temp/{id}");
            Directory.CreateDirectory(tempDirectory);
            string inputPath = $"{tempDirectory}/input.jpg";

            inputImage.Image.Save(inputPath, System.Drawing.Imaging.ImageFormat.Jpeg);
            argumentsOptions.inputPath = inputPath;
            argumentsOptions.outputPath = tempDirectory;
            argumentsOptions.saveJson = true;
            argumentsOptions.saveMasks = true;

            await runtime.StartApp();
            runtime.LoadModel(FaceParserRuntime.args.modelPath);
            FaceParserRuntime.faceParsing.LoadImage(FaceParserRuntime.args.inputPath);
            await FaceParserRuntime.faceParsing.RunOnnxInference();

            Console.WriteLine(@tempDirectory);
            // open the output directory
            Process.Start("explorer.exe", @tempDirectory);


        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            RestServer.Instance.StopServer();

        }
    }
}
