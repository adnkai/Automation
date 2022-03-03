// Parameters

@minLength(3)
@maxLength(24)
@description('Provide a name for the storage account. Use only lower case letters and numbers. The name must be unique across Azure.')
param storageName string

@allowed([
  'germanywestcentral'
  'northeurope'
  'westeurope'
])
@description('Provide a location.')
param location string = 'germanywestcentral'

param storagecount int = 5

param storageNames array = [
  'contosokr'
  'fabrikamkr'
  'fabrikamkr2'
  'fabrikamkr3'
]

param storageDetails array = [
  {
    name: 'firststorkr'
    sku: 'Standard_LRS'
    location: 'germanywestcentral'
    kind: 'StorageV2'
  }
  {
    name: 'secondstorkr'
    sku: 'Standard_LRS'
    location: 'northeurope'
    kind: 'BlobStorage'
  }
]

// vnet - why not?
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'examplevnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// storage account single instance
resource examplestorage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: '${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// storage account loop
resource examplestorageloop 'Microsoft.Storage/storageAccounts@2021-06-01' = [for i in range(0, storagecount): {
  name: '${i}${storageName}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}]

// storage account loop with array
resource examplestoragelooparray 'Microsoft.Storage/storageAccounts@2021-06-01' = [for name in storageNames: {
  name: '${name}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}]

// storage account loop with array
resource examplestoragelooparraynames 'Microsoft.Storage/storageAccounts@2021-06-01' = [for storage in storageDetails: {
  name: '${storage.name}'
  location: '${storage.location}'
  sku: {
    name: '${storage.sku}' // Ignore warnings. Bicep expects SKUType. String works too.
  }
  kind: 'StorageV2'
}]
