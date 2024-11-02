import os
import uuid
import os
import shutil
import sys
import platform
import json
# Dictionaries to track unique IDs
unique_ids = {}
component_group_ids = set()

def get_unique_id(name):
    """Generates a unique ID based on a name, ensuring no duplicates."""
    if name in unique_ids:
        return unique_ids[name]
    unique_id = f"{name}_{str(uuid.uuid4()).split('-')[0]}"
    unique_ids[name] = unique_id
    return unique_id
indx = 0

def generate_entry(file_path, directory_id, absPath):
    global indx
    file_name = os.path.basename(file_path).replace(" ", "_").replace("-", "_")
    isolatedName = file_path.replace(absPath, '')

    # Remove the first '/' or '\' if it exists
    if isolatedName[0] == '/' or isolatedName[0] == '\\':
        isolatedName = isolatedName[1:]
    
    unique_suffix = str(uuid.uuid4()).split('-')[0]  # Generate a short unique suffix
    shortcutData = ""
    
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

def generate_directory_and_components(current_path, abs_root_path):
    directory_name = os.path.basename(current_path).replace(" ", "_").replace("-", "_")
    prettyName = os.path.basename(current_path)
    if current_path == abs_root_path:
        directory_id = "UAIMODULE"
        prettyName = "$(var.APP_NAME)"
    else:
        directory_id = get_unique_id(directory_name)

    dir_tag = f'<Directory Id="{directory_id}" Name="{prettyName}">'

    component_entries = []
    for file_name in os.listdir(current_path):
        file_path = os.path.join(current_path, file_name)
        if os.path.isfile(file_path):
            component_entry = generate_entry(file_path, directory_id, abs_root_path)
            component_entries.append(component_entry)

    component_group = ""
    componentref = ""
    if component_entries:
        component_group_id = f"Components_{directory_id}"
        if component_group_id not in component_group_ids:
            component_group = f'<ComponentGroup Id="{component_group_id}">\n' + "\n".join(component_entries) + '\n</ComponentGroup>'
            component_group_ids.add(component_group_id)
            componentref = f"<ComponentGroupRef Id=\"{component_group_id}\"/>"

    subdirectory_elements = []
    for entry in os.listdir(current_path):
        entry_path = os.path.join(current_path, entry)
        if os.path.isdir(entry_path):
            sub_dir_structure, sub_comp_group, sub_componentref = generate_directory_and_components(entry_path, abs_root_path)
            subdirectory_elements.append(sub_dir_structure)
            if sub_comp_group:
                component_group += "\n" + sub_comp_group
            if sub_componentref and sub_componentref not in componentref:
                componentref += "\n" + sub_componentref

    dir_elements = [dir_tag] + subdirectory_elements + ['</Directory>']
    directory_structure = "\n".join(dir_elements)
    
    return directory_structure, component_group, componentref

def create_structure(rootDirectory):
    absPath = os.path.abspath(rootDirectory)
    directory_structure, component_groups, componentref = generate_directory_and_components(absPath, absPath)

    all_component_groups = [component_groups]
    all_componentrefs = {componentref}
    for dirpath, _, filenames in os.walk(rootDirectory):
        dir_structure, comp_group, comp_ref = generate_directory_and_components(dirpath, absPath)
        if comp_group:
            all_component_groups.append(comp_group)
            all_componentrefs.add(comp_ref)

    return directory_structure, "\n".join(all_component_groups), "\n".join(all_componentrefs)

def generate_final_xml(rootDirectory, template_file="template.wxs"):
    directory_structure, component_groups, comprefs = create_structure(rootDirectory)

    with open(template_file, "r") as f:
        template_data = f.read()

    final_data = template_data.replace("<COMPGROUPREFS/>", comprefs)
    final_data = final_data.replace("<EXTRA/>", component_groups)
    final_data = final_data.replace("<DIRECTORY_STRUCTURE/>", directory_structure)
    
    return final_data

def get_target_runtime():
    os_platform = "win" if platform.system().lower() == "windows" else None
    if os_platform is None:
        print("Unsupported OS")
        sys.exit(1)

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
