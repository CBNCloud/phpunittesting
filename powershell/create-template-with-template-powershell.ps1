# Set Deployment Variables
$myNum = "002" #Modify this per deployment
$RGName = "testingbro"
$myLocation = "jkt"

# Create Resource Group for Template Deployment
$New=New-AzureRmResourceGroup -Name $RGName -Location $myLocation
 
# Deploy Template
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $RGName `
    -TemplateFile E:\template.json `
    -TemplateParameterFile E:\parameter.json
