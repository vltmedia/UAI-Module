<?xml version="1.0" encoding="utf-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
	
	<?define APP_NAME="FaceParse"?>
	<?define GUI_TargetDir=$(var.GUI.TargetDir)?>

    <Product Id="*" Name="UAI - Face Parsing" Language="1033" Version="1.0.0.0" Manufacturer="UAI" UpgradeCode="da3f1537-3b94-4d06-be8c-28084fe97eb2">
		<Package InstallScope="perMachine" InstallerVersion="200" Compressed="yes" Platform="x64"  />
		<WixVariable Id="WixUILicenseRtf" Value="License.rtf" />
		<Icon Id="UAIBrainServer" SourceFile="UAIBrainServer.ico" />

		<MajorUpgrade DowngradeErrorMessage="A later version of [ProductName] is already installed. Setup will now exit." />

		<MediaTemplate EmbedCab="yes" />

		<?include InstallationStages.wxi?>


			<Feature Id="MainFeature" Title="UAI - Face Parser" Level="1">

				<COMPGROUPREFS/>

				<EXTRA/>
				
        </Feature>

		<Property Id="WIXUI_INSTALLDIR" Value="UAIMODULE" />

		<Property Id="POWERSHELLVERSION">
			<RegistrySearch Id="POWERSHELLVERSION" Type="raw" Root="HKLM" Key="SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine" Name="PowerShellVersion" />
		</Property>

		<Property Id="POWERSHELLEXE">
			<RegistrySearch Id="POWERSHELLEXE" Type="raw" Root="HKLM" Key="SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" Name="Path" />
		</Property>

		<Condition Message="You must have PowerShell 3.0 or higher.">
			<![CDATA[Installed OR (POWERSHELLEXE AND POWERSHELLVERSION >= "3.0")]]>
		</Condition>

		<Property Id="API_KEY" Value="xxxxxxxxxxxxxxxxxxxxx" Secure="yes">
			<RegistrySearch Id="RegSearch_API_KEY" Root="HKLM" Key="Software\[Manufacturer]\[ProductName]" Name="API Key" Type="raw" />
		</Property>

		<CustomAction Id="SaveCmdLineValue_API_KEY" Property="CMDLINE_API_KEY" Value="[API_KEY]" Execute="firstSequence" />
		<CustomAction Id="SetFromCmdLineValue_API_KEY" Property="API_KEY" Value="[CMDLINE_API_KEY]" Execute="firstSequence" />
		<InstallUISequence>
			<Custom Action="SaveCmdLineValue_API_KEY" Before="AppSearch" />
			<Custom Action="SetFromCmdLineValue_API_KEY" After="AppSearch">
				<![CDATA[CMDLINE_API_KEY AND (CMDLINE_API_KEY <> "default value")]]>
			</Custom>
		</InstallUISequence>
		<InstallExecuteSequence>
			<Custom Action="SaveCmdLineValue_API_KEY" Before="AppSearch" />
			<Custom Action="SetFromCmdLineValue_API_KEY" After="AppSearch">
				<![CDATA[CMDLINE_API_KEY AND (CMDLINE_API_KEY <> "default value")]]>
			</Custom>
		</InstallExecuteSequence>

		<Property Id="MY_INSTALL_LOCATION" Secure="yes">
			<RegistrySearch Id="RegSearch_MY_INSTALL_LOCATION" Root="HKLM" Key="Software\[Manufacturer]\[ProductName]" Name="My install location" Type="raw" />
		</Property>

		<CustomAction Id="SaveCmdLineValue_MY_INSTALL_LOCATION" Property="CMDLINE_MY_INSTALL_LOCATION" Value="[MY_INSTALL_LOCATION]" Execute="firstSequence" />
		<CustomAction Id="SetFromCmdLineValue_MY_INSTALL_LOCATION" Property="MY_INSTALL_LOCATION" Value="[CMDLINE_MY_INSTALL_LOCATION]" Execute="firstSequence" />
		<InstallUISequence>
			<Custom Action="SaveCmdLineValue_MY_INSTALL_LOCATION" Before="AppSearch" />
			<Custom Action="SetFromCmdLineValue_MY_INSTALL_LOCATION" After="AppSearch">
				CMDLINE_MY_INSTALL_LOCATION
			</Custom>
		</InstallUISequence>
		<InstallExecuteSequence>
			<Custom Action="SaveCmdLineValue_MY_INSTALL_LOCATION" Before="AppSearch" />
			<Custom Action="SetFromCmdLineValue_MY_INSTALL_LOCATION" After="AppSearch">
				CMDLINE_MY_INSTALL_LOCATION
			</Custom>
		</InstallExecuteSequence>

		<Directory Id="TARGETDIR" Name="SourceDir">
			<Directory Id="ProgramFiles64Folder">
				<Directory Id="MY_INSTALL_LOCATION" Name="UAI">

					<DIRECTORY_STRUCTURE/>

				</Directory>
			</Directory>

			<!-- Define Start Menu folder structure -->
            <Directory Id="ProgramMenuFolder">
                <Directory Id="ProgramMenuDir" Name="UAI" />
            </Directory>


		</Directory>


		<ComponentGroup Directory="UAIMODULE" Id="ProductComponentGroup">
			<Component Id="cmp_MyAppendScript_ps1" Win64="yes">
				<File KeyPath="yes" Source="MyAppendScript.ps1"></File>
			</Component>
			<Component Id="cmp_RegistryEntry_API_KEY" Guid="*" Win64="yes">
				<RegistryKey Root="HKLM" Key="Software\[Manufacturer]\[ProductName]">
					<RegistryValue KeyPath="yes" Type="string" Name="API Key" Value="[API_KEY]" />
				</RegistryKey>
			</Component>
			<Component Id="cmp_RegistryEntry_UAIMODULE" Guid="*" Win64="yes">
				<RegistryKey Root="HKLM" Key="Software\[Manufacturer]\[ProductName]">
					<RegistryValue KeyPath="yes" Type="string" Name="My install location" Value="[UAIMODULE]" />
				</RegistryKey>
			</Component>
				
			

		</ComponentGroup>

		<SetProperty Id="CA_AppendTextUsingPowerShell_FirstInstall" Before="CA_AppendTextUsingPowerShell_FirstInstall" Sequence="execute" Value="&quot;[POWERSHELLEXE]&quot; -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -File &quot;[UAIMODULE]MyAppendScript.ps1&quot; -installationStage FirstInstall -propertyValue &quot;[API_KEY]&quot; -version &quot;[ProductVersion]&quot; -installLocation &quot;[UAIMODULE] &quot;" />

		<SetProperty Id="CA_AppendTextUsingPowerShell_Upgrading" Before="CA_AppendTextUsingPowerShell_Upgrading" Sequence="execute" Value="&quot;[POWERSHELLEXE]&quot; -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -File &quot;[UAIMODULE]MyAppendScript.ps1&quot; -installationStage Upgrading -propertyValue &quot;[API_KEY]&quot; -version &quot;[ProductVersion]&quot; -installLocation &quot;[UAIMODULE] &quot;" />

		<SetProperty Id="CA_AppendTextUsingPowerShell_Uninstalling" Before="CA_AppendTextUsingPowerShell_Uninstalling" Sequence="execute" Value="&quot;[POWERSHELLEXE]&quot; -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -File &quot;[UAIMODULE]MyAppendScript.ps1&quot; -installationStage Uninstalling -propertyValue &quot;[API_KEY]&quot; -version &quot;[ProductVersion]&quot; -installLocation &quot;[UAIMODULE] &quot;" />

		<SetProperty Id="CA_AppendTextUsingPowerShell_Maintenance" Before="CA_AppendTextUsingPowerShell_Maintenance" Sequence="execute" Value="&quot;[POWERSHELLEXE]&quot; -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -File &quot;[UAIMODULE]MyAppendScript.ps1&quot; -installationStage Maintenance -propertyValue &quot;[API_KEY]&quot; -version &quot;[ProductVersion]&quot; -installLocation &quot;[UAIMODULE] &quot;" />

		<CustomAction Id="CA_AppendTextUsingPowerShell_FirstInstall" BinaryKey="WixCA" DllEntry="WixQuietExec" Execute="deferred" Return="check" Impersonate="no" />
		<CustomAction Id="CA_AppendTextUsingPowerShell_Upgrading" BinaryKey="WixCA" DllEntry="WixQuietExec" Execute="deferred" Return="check" Impersonate="no" />
		<CustomAction Id="CA_AppendTextUsingPowerShell_Uninstalling" BinaryKey="WixCA" DllEntry="WixQuietExec" Execute="deferred" Return="check" Impersonate="no" />
		<CustomAction Id="CA_AppendTextUsingPowerShell_Maintenance" BinaryKey="WixCA" DllEntry="WixQuietExec" Execute="deferred" Return="check" Impersonate="no" />

		<InstallExecuteSequence>
			<Custom Action="CA_AppendTextUsingPowerShell_FirstInstall" Before="InstallFinalize">FirstInstall</Custom>
			<Custom Action="CA_AppendTextUsingPowerShell_Upgrading" Before="InstallFinalize">Upgrading</Custom>
			<Custom Action="CA_AppendTextUsingPowerShell_Uninstalling" Before="RemoveFiles">Uninstalling</Custom>
			<Custom Action="CA_AppendTextUsingPowerShell_Maintenance" Before="InstallFinalize">Maintenance</Custom>
		</InstallExecuteSequence>

		<UI Id="MyWixUI_InstallDir">
			<UIRef Id="WixUI_InstallDir" />

			<DialogRef Id="MyCustomPropertiesDlg" />

			<Publish Dialog="InstallDirDlg" Control="Next" Event="NewDialog" Value="MyCustomPropertiesDlg" Order="4">WIXUI_DONTVALIDATEPATH OR WIXUI_INSTALLDIR_VALID="1"</Publish>
			<Publish Dialog="VerifyReadyDlg" Control="Back" Event="NewDialog" Value="MyCustomPropertiesDlg" Order="1">1</Publish>
		</UI>

		<Feature Id="HelloWorldFeature">
			<ComponentGroupRef Id="ProductComponentGroup" />
		</Feature>

	</Product>
</Wix>