param applicationName

resource application 'Microsoft.Graph/applications@beta' = {
  displayName: applicationName
}

resource servicePrincipal 'Microsoft.Graph/servicePrincipals@beta' = {
  appId: application.appId
}
