# Terraform-VMsinAWS
A sample terraform module to deploy a virtual machine lab environment in AWS

1. [Get an AWS account](#get-an-aws-account)
2. [Get your AWS API keys and save it to a local file](#get-your-aws-api-keys-and-save-it-to-a-local-file)
3. [Generate your SSH keys](#generate-your-ssh-keys)
4. [Test!](#test)

# Get an AWS account

For the sake of this test, I signed up for AWS Free Tier with a personal email address.  
You can signup [here](https://aws.amazon.com/free).

# Get your AWS API keys and save it to a local file

Go to the AWS management console, click on your Profile name, and then click on "Security Credentials".  
Go to Access Keys and select "Create Access Key".  
If you get prompt to consent creating the key, accept and continue.  
Then copy your "Access Key" and "Secret Access key".  
You can quickly save it in the local path to an encryped XML file by running following PowerShell command:
```Powershell
Get-Credential | Export-CliXml -Path ".\accesskey.xml"
```
# Generate your SSH keys

Run the file `GenerateSSHKeys.ps1` in PowerShell on how to create your SSH files.

# Test!

At this point you can start testing your Terraform module.  
Make sure you have Terraform.exe in your machine.  
You can run the file `LoadCredentials.ps1` to load your API key credentials into environment variables.  
<br>
The module now should be ready to initialize and deploy.  
Feel free to change the `Variables.tf` file for domain name, machine names, of your preferences.  
<br>
Available variables to modify:
|Name|DefaultValue|Description|
|----|------------|-----------|
|domain_name|"domain.lab"|FQDN name for the Active Directory domain|
|netbios_domainname|"domain"|NETBIOS name for the Active Directory domain|
|dc_name|"DC"|Computer name to give to the Domain Controller server|
|admin_name|"LabAdmin"|Account name for the new Domain Admin in AD|
|admin_pass|"S3cr37P455"|Account password for the new Domain Admin in AD|
|pubkey_filename|"awskey_id_rsa.pub"|File name of the public key file|
|machines_name_list|"["srv1", "ex1", "AADCsvr", "ADFSsvr"]"|List of machine names to be deployed as member server|