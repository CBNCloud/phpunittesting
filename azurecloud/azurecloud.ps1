#application id should be noted as shown in above screen whot while setting up the ad application
#domain name is to be obtainmed as highlighted in avove screen shot

## if you already service principal, you can this code ##
$userId = "contosoaja@contoso.onmicrosoft.com"
$password = ("contosoaja56" | ConvertTo-SecureString -AsPlainText -Force)
$tenant_id = "hyut6690-gt67-hu78-3234-ddf6790pi82";
#Set the powershell credential object
$cred = New-Object -TypeName System.Management.Automation.PSCredential($userId ,$password)
 
#log On To Azure Account
Login-AzureRmAccount -Credential $cred -TenantId $tenant_id

############################ service principal #############################

## if you don't service principal, you can this code
Login-AzureRmAccount

## creating ResourceGroup
$rgName = "cbncloudRG"
$rgLoc = "southeastasia"
New-AzureRmResourceGroup -Name $rgName -Location $rgLoc

# Deploy VM Linux
$vmName = "myVm"
$vmVnet = "myVnet"
$vmSubnet = "mySubnet"
$vmSg = "mySg"
$vmIp = "myIp"
$vmNic = "myNic"

## creating username dan password
$securePassword = ConvertTo-SecureString 'Ubuntu123456&' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("cbncloud", $securePassword)

## creating subnet
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $vmSubnet -AddressPrefix 192.168.1.0/24
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $rgName -Location $rgLoc `
  -Name $vmVnet -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $rgName -Location $rgLoc `
  -Name $vmIp -AllocationMethod Static -IdleTimeoutInMinutes 4

## creating ssh rule
$nsgRuleSSH = New-AzureRmNetworkSecurityRuleConfig -Name allowssh -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 22 -Access Allow

## creating network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $rgLoc `
  -Name $vmSg -SecurityRules $nsgRuleSSH
$nic = New-AzureRmNetworkInterface -Name $vmNic -ResourceGroupName $rgName -Location $rgLoc `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

## creating config flavour
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize Standard_D1 | `
Set-AzureRmVMOperatingSystem -Linux -ComputerName $vmName -Credential $cred | `
Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 16.04-LTS -Version latest | `
Add-AzureRmVMNetworkInterface -Id $nic.Id

## creating vm
New-AzureRmVM -ResourceGroupName $rgName -Location $rgLoc -VM $vmConfig
