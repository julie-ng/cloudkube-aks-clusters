# Monorepo with Multiple Clusters

This repo is an example of keeping configuration e.g. `environments/*` as close as possible to IaC for easier debugging. In other words, I did not want a multi-repo setup.

#### Further Information

For more about pros and cons of this approach, please see my blog article [Infrastructure as Code and Monorepos - a Pragmatic Approach](https://julie.io/writing/infra-as-code-monorepo/).

### Use Path based Pipeline Triggers to Target Environments

Given the following tree structure (with example multi-region production scenario):

```
environments/
├── dev/
├── prod-northeurope/
├── prod-westeurope/
└── staging/
```

### How to Target Production?

Changes in the [`modules/`](../modules/) folder do not trigger production deployments because of how we separate pipelines (diff. YAML files) and configuration (folders) per deployment target.

To deploy to production, both conditions must be satisfied:
  - change must be on `production` branch
  - change must be to production config, e.g. `prod-westeurope` subfolders.

```yaml
# pipelines/production.yaml
trigger:
  branches:        
    - production
  paths:
    include:    
    - 'environemnts/prod-northeurope/*'
    - 'environemnts/prod-westeurope/*'    
```

