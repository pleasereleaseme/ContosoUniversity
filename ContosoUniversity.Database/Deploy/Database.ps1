[CmdletBinding()]

param(
    [Parameter(Position=1)]
    [string]$domainSqlServerSetupLogin,
    [Parameter(Position=2)]
    [string]$domainSqlServerSetupPassword,
    [Parameter(Position=3)]
    [string]$sqlServerSaPassword,
    [Parameter(Position=4)]
    [string]$domainUserForIntegratedSecurityLogin 
)

# Password parameters included intentionally to check for environment cloning errors where failure to explicitly set the password
# in a cloned environment causes an off-by-one error which these outputs can help track down
Write-Verbose "The value of parameter `$domainSqlServerSetupLogin is $domainSqlServerSetupLogin" -Verbose
Write-Verbose "The value of parameter `$domainSqlServerSetupPassword is $domainSqlServerSetupPassword" -Verbose
Write-Verbose "The value of parameter `$sqlServerSaPassword is $sqlServerSaPassword" -Verbose
Write-Verbose "The value of parameter `$domainUserForIntegratedSecurityLogin is $domainUserForIntegratedSecurityLogin" -Verbose

$domainSqlServerSetupCredential = New-Object System.Management.Automation.PSCredential ($domainSqlServerSetupLogin, (ConvertTo-SecureString -String $domainSqlServerSetupPassword -AsPlainText -Force))
$sqlServerSaCredential = New-Object System.Management.Automation.PSCredential ("sa", (ConvertTo-SecureString -String $sqlServerSaPassword -AsPlainText -Force))

$configurationData = 
@{
    AllNodes = 
    @(
        @{
            NodeName = $env:COMPUTERNAME
            PSDscAllowDomainUser = $true
            PSDscAllowPlainTextPassword = $true
            DomainSqlServerSetupCredential = $domainSqlServerSetupCredential
            SqlServerSaCredential = $sqlServerSaCredential
            DomainUserForIntegratedSecurityLogin = $domainUserForIntegratedSecurityLogin 
        }		
    )
}

Configuration Database
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName  @{ModuleName="xSQLServer";ModuleVersion="1.5.0.0"}
    Import-DscResource -ModuleName  @{ModuleName="xDatabase";ModuleVersion="1.4.0.0"}
    Import-DscResource -ModuleName @{ModuleName="xReleaseManagement";ModuleVersion="1.0.0.0"}


    Node $AllNodes.NodeName
    {
        WindowsFeature "NETFrameworkCore"
        {
            Ensure = "Present"
            Name = "NET-Framework-Core"
        }
        xSqlServerSetup "SQLServerEngine"
        {
            DependsOn = "[WindowsFeature]NETFrameworkCore"
            SourcePath = "\\prm-core-dc\DscInstallationMedia"
            SourceFolder = "SqlServer2014"
            SetupCredential = $Node.DomainSqlServerSetupCredential
            InstanceName = "MSSQLSERVER"
            Features = "SQLENGINE"
            SecurityMode = "SQL"
            SAPwd = $Node.SqlServerSaCredential
        }

        xDatabase DeployDac
        {
            DependsOn = "[xSqlServerSetup]SQLServerEngine"
            Ensure = "Present"
            SqlServer = $Node.Nodename
            SqlServerVersion = "2014"
            DatabaseName = "ContosoUniversity"
            Credentials = $Node.SqlServerSaCredential
            DacPacPath =  "C:\temp\Database\ContosoUniversity.Database.dacpac"
            DacPacApplicationName = "ContosoUniversity.Database"
        }

        xTokenize ReplacePermissionsScriptConfigTokens
        {
            DependsOn = "[xDatabase]DeployDac"
            recurse = $false
            tokens = @{LOGIN_OR_USER = $Node.DomainUserForIntegratedSecurityLogin; DB_NAME = "ContosoUniversity"}         
            useTokenFiles = $false
            path = "C:\temp\Database\Deploy"
            searchPattern = "*.sql"
        }

        Script ApplyPermissions
        {
            DependsOn = "[xTokenize]ReplacePermissionsScriptConfigTokens"
            SetScript = 
            { 
                $cmd= "& 'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\110\Tools\Binn\sqlcmd.exe' -S localhost -i 'C:\temp\Database\Deploy\Create login and database user.sql' "
                Invoke-Expression $cmd
            }
            TestScript = { $false }
            GetScript = { @{ Result = "" } }
        }

        # Configure for debugging / development mode only
        #xSqlServerSetup "SQLServerManagementTools"
        #{
        #    DependsOn = "[WindowsFeature]NETFrameworkCore"
        #    SourcePath = "\\prm-core-dc\DscInstallationMedia"
        #    SourceFolder = "SqlServer2014"
        #    SetupCredential = $Node.DomainSqlServerSetupCredential
        #    InstanceName = "NULL"
        #    Features = "SSMS,ADV_SSMS"
        #}
    }
}
Database -ConfigurationData $configurationData