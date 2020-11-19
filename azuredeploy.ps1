# template file and params copied to local
$localpath = "{yourLocalPath}"
$templatefile = $localpath + "azuredeploy.json"
$templateparamfile = $localpath + "azuredeploy.parameters.json"
$params = get-content $templateparamfile | ConvertFrom-Json
$prefix = $params.parameters.resourcenameprefix.value
$rgname = $prefix + "-rg"
$location = "East US"
$rg = get-azresourcegroup -location $location -name $rgname
if ($null -eq $rg)
{
    new-azresourcegroup -location $location -name $rgname
}
New-AzResourceGroupDeployment -ResourceGroupName $rgname -TemplateFile $templateFile -TemplateParameterFile $templateparamfile 
write-host "ARM Deployment Complete"