import os
import uuid
import os
import shutil
import sys
import platform
import json

# Dictionary to store unique IDs for each directory to ensure consistency
unique_ids = {}

def get_unique_id(name):
    """Generates a unique ID based on a name, ensuring no duplicates."""
    if name in unique_ids:
        return unique_ids[name]
    unique_id = f"{name}_{str(uuid.uuid4()).split('-')[0]}"
    unique_ids[name] = unique_id
    return unique_id

# Function to generate the Component entry with the Directory attribute
def generate_entry(file_path, directory_id, absPath):
    file_name = os.path.basename(file_path).replace(" ", "_").replace("-", "_")
    isolatedName = file_path.replace(absPath, '')

    # Remove the first '/' or '\' if it exists
    if isolatedName[0] == '/' or isolatedName[0] == '\\':
        isolatedName = isolatedName[1:]
    
    shortcutData = ""
    unique_suffix = str(uuid.uuid4()).split('-')[0]  # Generate a short unique suffix
    
    # Check if the file name contains any of the shortcut mappings
    indx = 0
    for shortcut in shortcutMapping:
        if shortcut['source'] in file_name:
            shortcutData = f'''
            <Shortcut Id="{shortcut['productName'].replace(' ', '_').replace('-', '')}_Shortcut_{unique_suffix}" 
                    Name="{shortcut['label']}" 
                    Directory="ProgramMenuDir"
                    Target="{shortcut['destination']}" 
                    WorkingDirectory="{shortcut['workingDirectory']}" 
                    Icon="{shortcut['icon']}" />
                    
            <RemoveFolder Id="ProgramMenuDir{indx}_{unique_suffix}" Directory="ProgramMenuDir" On="uninstall" />
            <RegistryValue Root="HKCU" Key="{shortcut['registryPath']}" Name="Installed" Type="integer" Value="1" KeyPath="yes" />
            '''
        indx += 1
    
    entry = f'''<Component Id="GUI.{file_name}_{unique_suffix}" Guid="{str(uuid.uuid4())}" Directory="{directory_id}" Win64="yes">
    <File Id="GUI.{file_name}_{unique_suffix}" Name="{file_name}" Source="$(var.GUI_TargetDir){isolatedName}" />
    {shortcutData}
</Component>'''
    return entry

# Function to recursively generate unique <Directory> structure and <ComponentGroup> for files
def generate_directory_and_components(current_path, abs_root_path):
    # Generate a unique ID for the directory based on its path to ensure it’s consistent
    directory_name = os.path.basename(current_path).replace(" ", "_").replace("-", "_")
    if current_path == abs_root_path:
        directory_id = "UAIMODULE"
    else:
        directory_id = get_unique_id(directory_name)

    # Create <Directory> tag for the current directory
    dir_tag = f'<Directory Id="{directory_id}" Name="{os.path.basename(current_path)}">'
    
    # Generate components for files in this directory
    component_entries = []
    for file_name in os.listdir(current_path):
        file_path = os.path.join(current_path, file_name)
        if os.path.isfile(file_path):
            component_entry = generate_entry(file_path, directory_id, abs_root_path)
            component_entries.append(component_entry)
    
    # Generate <ComponentGroup> only if there are files
    component_group = ""
    componentref = f"<ComponentGroupRef Id=\"{directory_id}\"/>"
    if component_entries:
        component_group_id = f"Components_{directory_id}"
        component_group = f'<ComponentGroup Id="{component_group_id}">\n' + "\n".join(component_entries) + '\n</ComponentGroup>'

    # Recursively process subdirectories
    subdirectory_elements = []
    for entry in os.listdir(current_path):
        entry_path = os.path.join(current_path, entry)
        if os.path.isdir(entry_path):
            sub_dir_structure, _, componentref = generate_directory_and_components(entry_path, abs_root_path)
            subdirectory_elements.append(sub_dir_structure)
    
    # Closing Directory tag
    dir_elements = [dir_tag] + subdirectory_elements + ['</Directory>']
    directory_structure = "\n".join(dir_elements)
    
    return directory_structure, component_group, componentref

# Main function to create directory and component structure for the root directory
def createStructure(rootDirectory):
    absPath = os.path.abspath(rootDirectory)
    directory_structure, component_groups, componentref = generate_directory_and_components(absPath, absPath)

    # Collect all component groups from subdirectories
    all_component_groups = []
    all_componentrefs = [componentref]
    for dirpath, _, filenames in os.walk(rootDirectory):
        dir_structure, comp_group, componentref = generate_directory_and_components(dirpath, absPath)
        if comp_group:
            all_component_groups.append(comp_group)
            if not componentref in all_componentrefs:
                all_componentrefs.append(componentref)

    return directory_structure, "\n".join(all_component_groups), "\n".join(all_componentrefs)

# Function to generate the final XML with directory structure and component groups
def generate_final_xml(rootDirectory, template_file="template.wxs"):
    # Generate the directory and component group structures
    directory_structure, component_groups, comprefs = createStructure(rootDirectory)
    
    # Load the template file
    with open(template_file, "r") as f:
        template_data = f.read()
    
    # Replace <EXTRA/> with the generated component groups and <DIRECTORY_STRUCTURE/> with the directory structure
    final_data = template_data.replace("<COMPGROUPREFS/>", comprefs)
    final_data = final_data.replace("<EXTRA/>", component_groups)
    final_data = final_data.replace("<DIRECTORY_STRUCTURE/>", directory_structure)
    
    return final_data


def generate_component_entries(file_paths):
    entries = []
    for file_path in file_paths:
        # Extract the file name from the path
        
        # Generate a new GUID
        
        
        # Format the component entry
        entry = generate_entry(file_path)
        # if "quantized" in file_path:
        #     print(file_path)
        #     print(entry)
        entries.append(entry)
    
    return entries


    return entry
def contains_file(currentFiles, file):
    for currentFile in currentFiles:
        if file == os.path.basename( currentFile):
            return True
    return False
def get_all_files(source_directory):
    all_files = []
    exclude = []
    # Walk through the directory tree
    for root, dirs, files in os.walk(os.path.abspath( source_directory)):
        for file in files:
            # Construct full file path and add to the list
            
            baseName = os.path.basename(file)
            shouldContinue = True
            for ext in exclude:
                if ext in baseName:
                    shouldContinue = False
                    break
            if shouldContinue:
                if not contains_file(all_files, baseName):
                    file_path = os.path.join(root, file)
                    all_files.append(file_path)
    return all_files








def get_target_runtime():
    # Determine the OS platform
    os_platform = "win" if platform.system().lower() == "windows" else None
    if os_platform is None:
        print("Unsupported OS")
        sys.exit(1)

    # Determine architecture
    arch_map = {
        "AMD64": "x64",
        "x86": "x86",
        "ARM64": "arm64",
        "ARM": "arm"
    }
    os_architecture = arch_map.get(platform.machine(), None)
    if os_architecture is None:
        print("Unsupported Architecture")
        sys.exit(1)
    
    target_runtime = f"{os_platform}-{os_architecture}"
    print(f"OS Architecture: {os_architecture}")
    print(f"Target runtime: {target_runtime}")
    return target_runtime

def delete_non_matching_runtimes(runtimes_path, target_runtime):
    if not os.path.exists(runtimes_path):
        print(f"The runtimes directory does not exist at path: {runtimes_path}")
        return

    for folder_name in os.listdir(runtimes_path):
        folder_path = os.path.join(runtimes_path, folder_name)
        if os.path.isdir(folder_path) and folder_name.lower() != target_runtime.lower():
            print(f"Deleting non-matching runtime folder: {folder_name}")
            shutil.rmtree(folder_path)
            



baseDir = os.path.dirname(os.path.abspath(__file__))  
baseCWD = os.getcwd()
os.chdir(baseDir)  
sourcePath = "../GUI/bin/x64/Release/net8.0-windows"
templateWix = f"{baseDir}/ProductTemplate.xs"
configJson = f"{baseDir}/config.json"
configData = json.load(open(configJson, "r"))
shortcutMapping = configData["shortcutMapping"]
inputPath = os.path.relpath(sourcePath, baseDir)
absPath = os.path.abspath(inputPath)
templateWixData = open(templateWix, "r").read()
target_runtime = get_target_runtime()

# files = get_all_files(absPath)
# toDelete = []
# for file in files:
#     if "runtimes" in file:
#         if not target_runtime in file:
#             toDelete.append(file)
# for file in toDelete:
#     files.remove(file)


# component_entries = generate_component_entries(files)
# xml_file_path = templateWix  # Path to your existing WiX XML file

# outputData = templateWixData.replace("<EXTRA/>", "\n".join(component_entries))

# if(os.path.exists(f"{baseDir}/Product.wxs")):
#     os.remove(f"{baseDir}/Product.wxs")
# open(f"{baseDir}/Product.wxs", "w").write(outputData)
open(f"{baseDir}/Product.wxs", "w").write(generate_final_xml(absPath, templateWix))
print(f"Saving to {baseDir}/Product.wxs")
os.chdir(baseCWD)  
