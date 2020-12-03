# Secure PaaS Application
## Why migrate your application to App Service and Azure SQL DB?
* Get out of the business of managing infrastructure. Just manage code and ship new features faster.
* Get built-in Cloud Native features: Monitoring, Autoscaling, Hight Availability, Disaster Recovery.
* App Service is the only managed app hosting platform for .net. With 2 decades of investment and 25+ years of SQL innovation.
* Proven success: hosting 2M apps and 41B daily requests with 99.95% SLA.
* Free App Service and Database Migration Assistants
* Leverage full network security and integration, with internet traffic blocked, firewalls protecting your deployment and supporting hybrid applications that integrate securely with other services in your network.
## Technical Requirements of the solution presented
Green field or .net application migration with a SQL Server back end the following Security features:
* No public endpoints available for Web Application or SQL Database.
* Secrets like database connection strings not available in code or application configuration.
* Web Application Firewall in front of Web Application to protect against the top 10 OWASP threats
* Outbound traffic from the Web App to SQL Database and other in-network resources (including on-premise) routed to a firewall for inspection.
## Architecture
<img src="https://storagegomez.blob.core.windows.net/public/images/SecureApp_POC.png"/>

## Solution Overview
<img src="https://storagegomez.blob.core.windows.net/public/images/SecureAppSteps.png"/>

This solution deploys a fully automated secure baseline Azure ARM Template + Powershell to provision a PaaS environment fully configured for high security.  
### Azure Resources deployed:
* Hub and Spoke VNets with VNet peering.
* App Gateway with WAF and Azure Firewall in the Hub VNet.
* Azure Key Vault with SQL CnString as Secret.
* Premium App Service Plan with Regional VNet Integration.
* App Service with Manage Identity and Private Link.
* SQL Database with Private Link.
* Private DNS Zones for Private Endpoints.
* Optional Route Table to send traffic from the application destined to SQL to the Azure Firewall.
* A sample application (Athlete Roster) deployed as a package leveraging the MSDEPLOY extension.
* A sample SQL DB schema with data that supports the sample application. Using a bacpac file.
* Configurations to block internet traffic to App Service and SQL Database.
### Deployment Steps
1. Clone or dowload the solution to your local machine
```
git clone https://github.com/azuregomez/SecureApp.git somefolder
```
1. Configure azuredeploy.parameters.json
Provide a resource group prefix.  This prefix will be used to create default names for Azure Resources.
* Provide additional parameters that may override defaults. Like application package and SQL Database bacpac.
* Provide optinal parameters for _artifactsLocation and _artifactsLocationSasToken.  By default, these paramataers point to linked templates in this github repository.  If you host the files in a different repositpry you will have to provide these parameters.
* Provide you Azure AD Object ID.  This is required so you are authorized to manage the the Key Vault that is created.
You can obtain this with Powershell cmdlets: 
```
Get-AzADUser or Get-AzADServicePrincipal.
```
