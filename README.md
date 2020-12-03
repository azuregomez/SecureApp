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


