# Secure PaaS Application
## Why migrate your application to App Service and Azure SQL DB?
* Get out of the business of managing infrastructure. Just manage code and ship new features faster.
* Get built-in Cloud Native features: Monitoring, Autoscaling, Hight Availability, Disaster Recovery.
* App Service is the only managed app hosting platform for .net. With 2 decades of investment and 25+ years of SQL innovation.
* Proven success: hosting 2M apps and 41B daily requests with 99.95% SLA.
* Free App Service and Database Migration Assistants
* Leverage full network security and integration, with internet traffic blocked, firewalls protecting your deployment and supporting hybrid applications that integrate securely with other services in your network.

 ## Solution Overview
 This solution deploys a fully automated secure baseline Azure ARM Template + Powershell to provision a PaaS environment fully configured for high security.  
 Azure Resources deployed:
 * Hub and Spoke VNets with VNet peering.
 * App Gateway with WAF and Azure Firewall in the Hub VNet.
 * Azure Key Vault with SQL CnString as Secret.
 * Premium App Service Plan with Regional VNet Integration.
 * App Service with Manage Identity and Private Link.
 * SQL Database with Private Link.
 * Private DNS Zones for Private Endpoints.
 * Optional Route Table to send traffic from the application destined to SQL to the Azure Firewall.
 * Configurations to block internet traffic to App Service and SQL Database.

## Architecture
<img src="https://storagegomez.blob.core.windows.net/public/images/SecureApp_POC.png"/>
