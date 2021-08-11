#Gather informaition and input into json files to deploy azure lighthouse
#Download and modify delegatedmanagementparameters.json and delegatedmanagementtemplate.json
#For Admin Tenant
import-module az
connect-azaccount
Get-AzTenant #get tenant id

#create or use an existinng builtin group to grant management permissions from client tenant.  Get the id
(Get-AzADGroup -DisplayName 'AdminAgents').id

#Set the role for the subscription to be applied to the resources in that subscriuption.  get roledefinitionid
(Get-AzRoleDefinition -Name 'Contributor').id

#For Customer Tenant

connect-azaccount

#check if you have the right subscription selected
get-azcontext

#, if not, select the right subscription first, lookup the current subscriptions in this tenant:
get-azsubscription

#now set the context 
Set-AzContext -Subscription <subscriptionId>

#modify json file accordingly
New-AzDeployment -Name LightHouse -Location locale -TemplateFile "%path to DelegatedManagementtemplate.json%" -TemplateParameterFile "%path to DelegatedManagementparameters.json%" -Verbose
