# Terraform-VMsinAWS
A sample terraform module to deploy a virtual machine lab environment in AWS

1. Get an AWS account.
2. Get your AWS API keys and save it to a local file.
3. Generate your SSH keys.
4. Test!

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