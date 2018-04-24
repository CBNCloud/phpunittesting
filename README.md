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

- **Create Principal must azurecloud [https://portal.azure.com](https://portal.azure.com)**
```ps1
# Create an CBNCloud Deploy Application in Active Directory
Write-Output "Creating AAD application..."
$password = '$password&*';
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$azureAdApplication = New-AzureRmADApplication -DisplayName "Cbncloud Deploy" -HomePage "https://www.cbncloud.co.id" -IdentifierUris "https://www.cbncloud.co.id" -Password $securePassword
$azureAdApplication | Format-Table
 
# Create the Service Principal
Write-Output "Creating AAD service principal..."
$servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId
$servicePrincipal | Format-Table
 
# Sleep, to Ensure the Service Principal is Actually Created
Write-Output "Sleeping for 10s to give the service principal a chance to finish creating..."
Start-Sleep -s 10
 
# Assign the Service Principal the Contributor Role to the Subscription.
# Roles can be Granted at the Resource Group Level if Desired.
Write-Output "Assigning the Contributor role to the service principal..."
New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $azureAdApplication.ApplicationId
 
# The Application ID (aka Client ID) will be Required When Creating the Account in CBNCloud Deploy
Write-Output "Client ID: $($azureAdApplication.ApplicationId)"
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


