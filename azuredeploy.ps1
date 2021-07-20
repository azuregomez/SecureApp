# .\azuredeploy.ps1 -Location "East US" -Parameterfile azuredeploy.parameters.local.json    
Param(
    [string] [parameter(Mandatory=$true)] $Location,     
    [string] $ParameterFile = 'azuredeploy.parameters.json'
)
$templateFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, 'azuredeploy.json'))
$templateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $ParameterFile))
$params = get-content $templateParametersFile | ConvertFrom-Json
$prefix = $params.parameters.resourcenameprefix.value
$rgname = $prefix + "-rg"
# Create the resource group only when it doesn't already exist
if ($null -eq (Get-AzResourceGroup -Name $rgname -Location $Location -Verbose -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $rgname -Location $Location -Verbose -Force -ErrorAction Stop
}
$ErrorActionPreference = 'Stop'
New-AzResourceGroupDeployment -ResourceGroupName $rgname -TemplateFile $templateFile -TemplateParameterFile $templateParametersFile 
write-host "ARM Deployment Complete"
