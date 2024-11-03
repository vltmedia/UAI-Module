namespace GUI
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            listBox1 = new ListBox();
            inputImage = new PictureBox();
            resultImage = new PictureBox();
            buttonImport = new Button();
            buttonRunProcess = new Button();
            label1 = new Label();
            buttonSaveMasks = new Button();
            buttonSaveImage = new Button();
            openFileDialog1 = new OpenFileDialog();
            saveFileDialog1 = new SaveFileDialog();
            ((System.ComponentModel.ISupportInitialize)inputImage).BeginInit();
            ((System.ComponentModel.ISupportInitialize)resultImage).BeginInit();
            SuspendLayout();
            // 
            // listBox1
            // 
            listBox1.FormattingEnabled = true;
            listBox1.ItemHeight = 15;
            listBox1.Location = new Point(431, 255);
            listBox1.Name = "listBox1";
            listBox1.Size = new Size(291, 109);
            listBox1.TabIndex = 0;
            // 
            // inputImage
            // 
            inputImage.Location = new Point(73, 33);
            inputImage.Name = "inputImage";
            inputImage.Size = new Size(317, 179);
            inputImage.TabIndex = 1;
            inputImage.TabStop = false;
            // 
            // resultImage
            // 
            resultImage.Location = new Point(431, 33);
            resultImage.Name = "resultImage";
            resultImage.Size = new Size(291, 179);
            resultImage.TabIndex = 2;
            resultImage.TabStop = false;
            // 
            // buttonImport
            // 
            buttonImport.Location = new Point(73, 227);
            buttonImport.Name = "buttonImport";
            buttonImport.Size = new Size(75, 23);
            buttonImport.TabIndex = 3;
            buttonImport.Text = "Import";
            buttonImport.UseVisualStyleBackColor = true;
            buttonImport.Click += buttonImport_Click;
            // 
            // buttonRunProcess
            // 
            buttonRunProcess.Location = new Point(291, 227);
            buttonRunProcess.Name = "buttonRunProcess";
            buttonRunProcess.Size = new Size(99, 23);
            buttonRunProcess.TabIndex = 4;
            buttonRunProcess.Text = "Run Process";
            buttonRunProcess.UseVisualStyleBackColor = true;
            buttonRunProcess.Click += buttonRunProcess_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.ForeColor = Color.LightGray;
            label1.Location = new Point(432, 231);
            label1.Name = "label1";
            label1.Size = new Size(40, 15);
            label1.TabIndex = 5;
            label1.Text = "Masks";
            // 
            // buttonSaveMasks
            // 
            buttonSaveMasks.Location = new Point(432, 379);
            buttonSaveMasks.Name = "buttonSaveMasks";
            buttonSaveMasks.Size = new Size(75, 23);
            buttonSaveMasks.TabIndex = 6;
            buttonSaveMasks.Text = "Save Masks";
            buttonSaveMasks.UseVisualStyleBackColor = true;
            // 
            // buttonSaveImage
            // 
            buttonSaveImage.Location = new Point(647, 227);
            buttonSaveImage.Name = "buttonSaveImage";
            buttonSaveImage.Size = new Size(75, 23);
            buttonSaveImage.TabIndex = 7;
            buttonSaveImage.Text = "Save Image";
            buttonSaveImage.UseVisualStyleBackColor = true;
            // 
            // openFileDialog1
            // 
            openFileDialog1.FileName = "openFileDialog1";
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.FromArgb(10, 10, 10);
            ClientSize = new Size(800, 450);
            Controls.Add(buttonSaveImage);
            Controls.Add(buttonSaveMasks);
            Controls.Add(label1);
            Controls.Add(buttonRunProcess);
            Controls.Add(buttonImport);
            Controls.Add(resultImage);
            Controls.Add(inputImage);
            Controls.Add(listBox1);
            Icon = (Icon)resources.GetObject("$this.Icon");
            Name = "Form1";
            Text = "UAI : Face Parsing";
            FormClosing += Form1_FormClosing;
            Load += Form1_Load;
            ((System.ComponentModel.ISupportInitialize)inputImage).EndInit();
            ((System.ComponentModel.ISupportInitialize)resultImage).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private ListBox listBox1;
        private PictureBox inputImage;
        private PictureBox resultImage;
        private Button buttonImport;
        private Button buttonRunProcess;
        private Label label1;
        private Button buttonSaveMasks;
        private Button buttonSaveImage;
        private OpenFileDialog openFileDialog1;
        private SaveFileDialog saveFileDialog1;
    }
}
