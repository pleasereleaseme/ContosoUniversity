[CmdletBinding()]

param(
	[Parameter(Position=1)]
	[string]$domainUserForIntegratedSecurityLogin ,
    [Parameter(Position=2)]
	[string]$domainUserForIntegratedSecurityPassword,
    [Parameter(Position=3)]
	[string]$sqlServerName,
    [Parameter(Position=4)]
	[string]$InstrumentationKey
)

# Password parameters included intentionally to check for environment cloning errors where failure to explicitly set the password
# in a cloned environment causes an off-by-one error which these outputs can help track down
Write-Verbose "The value of parameter `$domainUserForIntegratedSecurityLogin is $domainUserForIntegratedSecurityLogin" -Verbose
Write-Verbose "The value of parameter `$domainUserForIntegratedSecurityPassword is $domainUserForIntegratedSecurityPassword" -Verbose
Write-Verbose "The value of parameter `$sqlServerName is $sqlServerName" -Verbose
Write-Verbose "The value of parameter `$InstrumentationKey is $InstrumentationKey" -Verbose

$domainUserForIntegratedSecurityCredential = New-Object System.Management.Automation.PSCredential ($domainUserForIntegratedSecurityLogin, (ConvertTo-SecureString -String $domainUserForIntegratedSecurityPassword -AsPlainText -Force))

$configurationData = 
@{
    AllNodes = 
    @(
        @{
            NodeName = $env:COMPUTERNAME
            DomainUserForIntegratedSecurityLogin = $domainUserForIntegratedSecurityLogin 
            DomainUserForIntegratedSecurityCredential = $domainUserForIntegratedSecurityCredential
            SqlServerName = $sqlServerName
            PSDscAllowDomainUser = $true
            PSDscAllowPlainTextPassword = $true
            InstrumentationKey = $InstrumentationKey
        }		
    )
}
Configuration Web
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource –ModuleName @{ModuleName="cWebAdministration";ModuleVersion="2.0.1"}
    Import-DscResource -ModuleName @{ModuleName="xWebAdministration";ModuleVersion="1.10.0.0"}
    Import-DscResource -ModuleName @{ModuleName="xReleaseManagement";ModuleVersion="1.0.0.0"}

    Node $AllNodes.NodeName
    {
        # Configure for web server role
        WindowsFeature DotNet45Core
        {
            Ensure = 'Present'
            Name = 'NET-Framework-45-Core'
        }
        WindowsFeature IIS
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
         WindowsFeature AspNet45
        {
            Ensure = "Present"
            Name = "Web-Asp-Net45"
        }

        # Only turn off whilst sorting out the web files - needs to be on for rest of script to work
        Script StopIIS
        {
            DependsOn = "[WindowsFeature]IIS"
            SetScript = 
            { 
                Stop-Service W3SVC
            }
            TestScript = { $false }
            GetScript = { @{ Result = "" } }
        }

        # Make sure the web folder has the latest website files
        xTokenize ReplaceWebConfigTokens
        {
            Recurse = $false
            Tokens = @{DATA_SOURCE = $Node.SqlServerName; INITIAL_CATALOG = "ContosoUniversity"; IKEY = $Node.InstrumentationKey}         
            UseTokenFiles = $false
            Path = "C:\temp\website"
            SearchPattern = "web.config"
        }
        Script DeleteExisitngWebsiteFilesSoAbsolutelyCertainAllFilesComeFromTheBuild
        {
            DependsOn = "[xTokenize]ReplaceWebConfigTokens"
            SetScript = 
            { 
               Remove-Item "C:\inetpub\ContosoUniversity" -Force -Recurse -ErrorAction SilentlyContinue
            }
            TestScript = { $false }
            GetScript = { @{ Result = "" } }
        }
        File CopyWebsiteFiles
        {
            DependsOn = "[Script]DeleteExisitngWebsiteFilesSoAbsolutelyCertainAllFilesComeFromTheBuild"
            Ensure = "Present"
            Force = $true
            Recurse = $true
            Type = "Directory"
            SourcePath = "C:\temp\website"
            DestinationPath = "C:\inetpub\ContosoUniversity"
        }
        File RemoveDeployFolder
        {
            DependsOn = "[File]CopyWebsiteFiles"
            Ensure = "Absent"
            Force = $true
            Type = "Directory"
            DestinationPath = "C:\inetpub\ContosoUniversity\Deploy"
        }

        Script StartIIS
        {
            DependsOn = "[File]RemoveDeployFolder"
            SetScript = 
            { 
                Start-Service W3SVC
            }
            TestScript = { $false }
            GetScript = { @{ Result = "" } }
        }

        # Configure custom app pool
        xWebAppPool ContosoUniversity
        {
            DependsOn = "[WindowsFeature]IIS"
            Ensure = "Present"
            Name = "ContosoUniversity"
            State = "Started"
        }
        cAppPool ContosoUniversity
        {
            DependsOn = "[xWebAppPool]ContosoUniversity"
            Name = "ContosoUniversity"
            IdentityType = "SpecificUser"
            UserName = $Node.DomainUserForIntegratedSecurityLogin
            Password = $Node.DomainUserForIntegratedSecurityCredential
        }

        # Advanced configuration
        xWebsite ContosoUniversity
        {
            DependsOn = "[cAppPool]ContosoUniversity"
            Ensure = "Present"
            Name = "ContosoUniversity"
            State = "Started"
            PhysicalPath = "C:\inetpub\ContosoUniversity"
            BindingInfo = MSFT_xWebBindingInformation
            {
                Protocol = 'http'
                Port = '80'
                HostName = $Node.NodeName
                IPAddress = '*'
            }
            ApplicationPool = "ContosoUniversity"
        }
        
        # Clean up the uneeded website and application pools
        xWebsite Default
        {
            Ensure = "Absent"
            Name = "Default Web Site"
        }
        xWebAppPool NETv45
        {
            Ensure = "Absent"
            Name = ".NET v4.5"
        }
        xWebAppPool NETv45Classic
        {
            Ensure = "Absent"
            Name = ".NET v4.5 Classic"
        }
        xWebAppPool Default
        {
            Ensure = "Absent"
            Name = "DefaultAppPool"
        }
        File wwwroot
        {
            Ensure = "Absent"
            Type = "Directory"
            DestinationPath = "C:\inetpub\wwwroot"
            Force = $True
        }

        # Configure for debugging / development mode only
        #WindowsFeature IISTools
        #{
        #    Ensure = "Present"
        #    Name = "Web-Mgmt-Tools"
        #}
    }
}
Web -ConfigurationData $configurationData