# Install the AzureRM.Bootstrapper module. Select Yes when prompted to install NuGet
Install-Module `
  -Name AzureRm.BootStrapper
 
# Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
Install-AzureRMProfile -Profile 2017-03-09-profile
 
# Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
Use-AzureRmProfile `
  -Profile 2017-03-09-profile -Force
 
Install-Module `
  -Name AzureStack `
  -RequiredVersion 1.2.11
 
 
# Navigate to the downloaded folder and import the **Connect** PowerShell module
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
Import-Module .\Connect\AzureStack.Connect.psm1
 
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
 
# Get the Active Directory tenantId that is used to deploy Azure Stack
$TenantID = Get-AzsDirectoryTenantId `
  -AADTenantName "cbncloud2.onmicrosoft.com" `
  -EnvironmentName "AzureStackUser"
