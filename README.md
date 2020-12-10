# Secure PaaS Application
## Why migrate your application to App Service and Azure SQL DB?
* Get out of the business of managing infrastructure. Just manage code and ship new features faster.
* Get built-in Cloud Native features: Monitoring, Autoscaling, High Availability, Disaster Recovery.
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
This architecture leverages the following Azure Security features:

Feature | Purpose | Reference
------- | ------- | -----
Key Vault | Store secrets like SQL connection string securely. | https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts
Managed Identity |  App Service identity to securely access Key Vault secrets. | https://docs.microsoft.com/en-us/azure/app-service/overview-managed-identity
Private Endpoint for Web App | Eliminate exposure from the public internet. | https://docs.microsoft.com/en-us/azure/app-service/networking/private-endpoint
VNet Integration |  Enables apps to access resources in or through a VNet |  https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet
Private Endpoint for SQL DB |  Connect to SQL DB through a private IP | https://docs.microsoft.com/en-us/azure/azure-sql/database/private-endpoint-overview
SQL DB Firewall rules | Eliminate exposure from the public internet | https://docs.microsoft.com/en-us/azure/azure-sql/database/firewall-configure
Route Table | Direct application traffic destined to the SQl DB to Azure Firewall | https://docs.microsoft.com/en-us/azure/virtual-network/manage-route-table
App Gateway | Web Application Firewall  |   https://docs.microsoft.com/en-us/azure/architecture/example-scenario/gateway/firewall-application-gateway
Azure Firewall | App outbound traffic control and inspection | https://docs.microsoft.com/en-us/azure/firewall/overview

## Solution Overview
<img src="https://storagegomez.blob.core.windows.net/public/images/SecureAppSteps2.png"/>

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
2. Configure azuredeploy.parameters.json
Provide a resource group prefix.  This prefix will be used to create default names for Azure Resources.
* Provide additional parameters that may override defaults. Like application package and SQL Database bacpac.
* Provide optinal parameters for _artifactsLocation and _artifactsLocationSasToken.  By default, these paramataers point to linked templates in this github repository.  If you host the files in a different repositpry you will have to provide these parameters.
* Provide you Azure AD Object ID.  This is required so you are authorized to manage the the Key Vault that is created.
You can obtain this with Powershell cmdlets: 
```
Get-AzADUser or Get-AzADServicePrincipal.
```
3. Run azudereploy.json
4. Run enablefirewallroute.json (only if you want to send traffic from the app with destination SQL DB to the Azure Firewall)
## Release Notes
* Pre requisites: Azure Subscription with Contributor role, Powershell 5.1, Azure Cmdlets
* App Gateway is deployed with a Public IP. This means the App Service is accessible from the internet through App Gateway.
* The template as well as the powershell script follow an easy convention where all resources have the same prefix. The prefix is specified in the template parameters and all other parameters have a default derived from resourceprefix. The powershell script assumes this convention is followed.
* For the most restrictive security, Azure Key Vault could have a Private Endpoint and VNet restrictions enabled. And allow only requests from the Private Endpoint. However, Key Vault References do not work yet with Regional VNet Integration - the Key Vault would get the request from one of the default Outbound public IPs of App Service. The temporary solution is to use Managed Service Identity as the security mechanism.
* For the Kudu console, or Kudu REST API (deployment with Azure DevOps self-hosted agents for example), you must create two records in your Azure DNS private zone or your custom DNS server. 
* To secure and inspect the traffic to Private Endpoints there are 2 caveats:
     * NSGs at the Private Endpoint subnets are NOT supported.
     * Creating Private Link Endpoints injects /32 routes into your Azure subnets. Therefore you want to create User-Defined Routes for your endpoint using specific /32 prefixes too (otherwise, the most specific prefix will win).  This is exactly what enablefirewallroute.ps1 does.
https://blog.cloudtrooper.net/2020/05/23/filtering-traffic-to-private-endpoints-with-azure-firewall/
* This architecture virtually injects an App Service into a VNet by allowing inbound trafffic exclusively from App Gateway and using a delegated subnet for Outbound access to SQL Azure DB, Storage and potentially to on-prem locations. For true VNet injection you must use an App Service Environment.
### What if I want the application to be ONLY available from my corporate Network?
1. App Gateway needs to be deployed with an internal IP, not external.  If App Gateway is not desired and internal access is appropriate without a WAF, this can be accomplished through the private endpoint but if traffic comes from on-premise there has to be DNS forwarding or on-prem pinpoint DNS to resolve the private endpoint of the web application.
2. For Hybrid connectivity: VPN or VNet Gateway (ExpressRoute).