# How to create Azure Stack Virtual Machine (VM) by PowerShell

## Introduction
This sample demonstrates cmdlet to create VM on Azure Stack.

## Table of contents

<!--ts-->
   * [Install](#install)
   * [Download Module Azurestack Tools](#download-module-azurestack-tools)
   * [Set Environment](#set-environment)
   * [Login](#login)
      * [Service Principal](#service-principal)
         * [Create Principal](#create-principal)
         * [Login With Principal](#login-with-principal)
      * [Login and Save Your Profile](#service-principal)
   * [Create Resource Group](#create-resource-group)
   * [Create Storage Account Name And The Storage Account SKU](#create-storage-account-name-and-the-storage-account-sku)
   * [Create a storage container to store the virtual machine image](#create-a-storage-container-to-store-the-virtual machine-image)
   
   
<!--te-->

## Install

```bash
# Install the AzureRM.Bootstrapper module. Select Yes when prompted to install NuGet 
Install-Module `
  -Name AzureRm.BootStrapper

# Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
Use-AzureRmProfile `
  -Profile 2017-03-09-profile -Force

Install-Module `
  -Name AzureStack `
  -RequiredVersion 1.2.11
```

## Set Environment

```bash
# For Azure Stack development kit, this value is set to https://management.local.azurestack.external. To get this value for Azure Stack integrated systems, contact your service provider.
$ArmEndpoint = "https://management.jkt.cbncloud.co.id"

# For Azure Stack development kit, this value is set to https://graph.windows.net/. To get this value for Azure Stack integrated systems, contact your service provider.
$GraphAudience = "https://graph.windows.net"

# Register an AzureRM environment that targets your Azure Stack instance
Add-AzureRMEnvironment `
  -Name "AzureStackUser" `
  -ArmEndpoint $ArmEndpoint

# Set the GraphEndpointResourceId value
Set-AzureRmEnvironment `
  -Name "AzureStackUser" `
  -GraphAudience $GraphAudience
```

## Download Module Azurestack Tools

```bash
# Change directory to the root directory. 
cd \

# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/master.zip `
  -OutFile master.zip

# Expand the downloaded files.
expand-archive master.zip `
  -DestinationPath . `
  -Force

# Change to the tools directory.
cd AzureStack-Tools-master
```
## Login

## Service Principal

if you don't have service principal, you must create a service pricinpal in azurecloud. this is simple code create principal with power shell.

## Create Principal
```bash
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

## Login With Principal
if you have service principal

```bash 
# login azurestack
$userId = "contoso@contoso.onmicrosoft.com"
$password = ("contosoadadeh12398!78*" | ConvertTo-SecureString -AsPlainText -Force)
$tenant_id = "988588549923-094028523-kiodfsgi-023423941";

#Set the powershell credential object
$cred = New-Object -TypeName System.Management.Automation.PSCredential($userId ,$password)
Login-AzureRmAccount -Environment "AzureStackUser" -Credential $cred -TenantId $tenant_id
```

```bash
# Install the AzureRM.Bootstrapper module. Select Yes when prompted to install NuGet 
Install-Module `
  -Name AzureRm.BootStrapper

# Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
Use-AzureRmProfile `
  -Profile 2017-03-09-profile -Force

Install-Module `
  -Name AzureStack `
  -RequiredVersion 1.2.11
```
## Login and Save Your Profile
```bash
# login azurestack
Login-AzureRmAccount -Environment "AzureStackUser"

# Now save your context locally (Force will overwrite if there)
$path = "E:\ProfileAzureStack.ctx"
Save-AzureRmContext -Path $path -Force
```

## Create Resource Group

```bash

# Create variables to store the location and resource group names.
$location = "jkt"
$ResourceGroupName = "myResourceGroup"
 
New-AzureRmResourceGroup `
  -Name $ResourceGroupName `
  -Location $location `
  -Verbose

```

## Create Storage Account Name And The Storage Account SKU

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

## Create a storage container to store the virtual machine image
```ps1
$containerName = "osdisk$(Get-Random)"
$container = New-AzureStorageContainer `
  -Name $containerName `
  -Permission Blob `
  -Verbose
```


## Prerequisite 

- Full Scripting Create vm no template azurestack [https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-no-template.ps1](https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-no-template.ps1)

- Full Scripting Create vm with template azurestack [https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-with-template-powershell.ps1](https://github.com/CBNCloud/template-azure-stack/blob/master/powershell/create-template-with-template-powershell.ps1)

- Full Scripting Installasi PowerShell template azurestack [https://github.com/CBNCloud/template-azure-stack/blob/master/installasi/power.ps1](https://github.com/CBNCloud/template-azure-stack/blob/master/installasi/power.ps1)

## Bonus
- Full Scripting Create vm no template Azurecloud [https://github.com/CBNCloud/template-azure-stack/blob/master/azurecloud/azurecloud.ps1](https://github.com/CBNCloud/template-azure-stack/blob/master/azurecloud/azurecloud.ps1)


