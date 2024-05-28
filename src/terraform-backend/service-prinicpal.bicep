

resource servicePrincipal 'Microsoft.Graph/applications' = {
  displayName: 'eap-terraform-prod-westeu-001'
  appRoles: [
    {
      allowedMemberTypes: [
        'User'
      ]
      description: 'Read all users\' full profiles'
      displayName: 'Read all users\' full profiles'
      id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d'
      isEnabled: true
      value: 'User.Read.All'
    }
  ]
}

