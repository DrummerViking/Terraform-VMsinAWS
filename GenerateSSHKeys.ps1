$message = @"
Open PowerShell.
Run:
ssh-keygen -t rsa -b 2048

Press Enter again when you see a prompt to "Enter file in which to save the key".
When prompted, type a secure passphrase (or leave empty), and press Enter.
When prompted, type the secure passphrase again to confirm (or leave empty), and press Enter.

Then we need to convert the private key, to PEM format with the following command:
ssh-keygen -p -f ~/.ssh/id_rsa -m PEM

When prompted, type a secure passphrase (or leave empty), and press Enter.
When prompted, type the secure passphrase again to confirm (or leave empty), and press Enter.

Now you can copy both files PEM and PUB to your local folder .\ssh\
"@
Write-host $message -ForegroundColor Yellow