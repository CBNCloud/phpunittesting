# How to create Azure Virtual Machine (VM) by PowerShell

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
# $StorageAccountName = "mystorageaccount5"
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

- **# Create a storage container to store the virtual machine image**
```ps1
# $containerName = "osdisk$(Get-Random)"
$container = New-AzureStorageContainer `
  -Name $containerName `
  -Permission Blob `
  -Verbose
```
