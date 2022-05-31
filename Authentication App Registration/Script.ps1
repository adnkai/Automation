# Connect against Powershell Graph API to create app registaion
#Connect-MgGraph -Scopes Application.ReadWrite.All

$hashmap = @{
    DisplayName = "PermissionsTestSecret"
    Web = @{
        RedirectUriSettings = @(
                @{Uri = "http://localhost"}
            )
    }
    RequiredResourceAccess = @(
        @{
            ResourceAppId = "00000003-0000-0000-c000-000000000000"
            ResourceAccess = @(
                @{
                    Id = "204e0828-b5ca-4ad8-b9f3-f32a958e7cc4"
                    Type = "Scope"
                }
            )
        }
    )
}

$passHashmap = @{
    PasswordCredential = @{
        DisplayName = "MySecret"
        KeyId = "62a83f7f-b610-4394-a8bc-9dc657425321"
    }
}

#New-MgApplication -Bodyparameter $hashmap

# ApplicationId == ObjectID...
Add-MgApplicationPassword -ApplicationId "fe4ffbcd-bfec-4c4d-970c-238db373a66b" -Bodyparameter $passHashmap 