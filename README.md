# How to create Azure Stack Virtual Machine (VM) by PowerShell

## Introduction
This sample demonstrates cmdlet to create VM on Azure Stack.

## Script
- **Creating Resource Group**
```ps1
# Create variables to store the location and resource group names.
$location = "jkt"
$ResourceGroupName = "myResourceGroup"
 
New-AzureRmResourceGroup `
  -Name $ResourceGroupName `
  -Location $location `
  -Verbose
```

- **Create variables to store the storage account name and the storage account SKU information**
```ps1

$StorageAccountName = "mystorageaccount5"
$SkuName = "Standard_LRS"
 
# Create a new storage account
$StorageAccount = New-AzureRMStorageAccount `
  -Location $location `
  -ResourceGroupName $ResourceGroupName `
  -Type $SkuName `
  -Name $StorageAccountName `
  -Verbose
 
Set-AzureRmCurrentStorageAccount `
  -StorageAccountName $storageAccountName `
  -ResourceGroupName $resourceGroupName `
  -Verbose
```

- **Create a storage container to store the virtual machine image**
```ps1
$containerName = "osdisk$(Get-Random)"
$container = New-AzureStorageContainer `
  -Name $containerName `
  -Permission Blob `
  -Verbose
```

- **Login With Principal**
```ps1
# login azurestack
$userId = "contoso@contoso.onmicrosoft.com"
$password = ("contosoadadeh12398!78*" | ConvertTo-SecureString -AsPlainText -Force)
$tenant_id = "988588549923-094028523-kiodfsgi-023423941";

#Set the powershell credential object
$cred = New-Object -TypeName System.Management.Automation.PSCredential($userId ,$password)
Login-AzureRmAccount -Environment "AzureStackUser" -Credential $cred -TenantId $tenant_id
```


- **Login With load your file**
```ps1
## login environment azurestack
Login-AzureRmAccount -Environment "AzureStackUser"

# Now save your context locally (Force will overwrite if there)
$path = "E:\ProfileAzureCloud.ctx"
Save-AzureRmContext -Path $path -Force

# load your login 
$path = "E:\ProfileAzureCloud.ctx"
Import-AzureRmContext -Path $path
```

## Prerequisite 

- Full Scripting Create vm no template azurestack [https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-no-template.ps1](https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-no-template.ps1)

- Full Scripting Create vm with template azurestack [https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-with-template-powershell.ps1](https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-with-template-powershell.ps1)

- Full Scripting Installasi PowerShell template azurestack [https://github.com/CBNCloud/template-azure-stack/blob/master/installasi/power.ps1](https://github.com/CBNCloud/template-azure-stack/blob/master/installasi/power.ps1)


