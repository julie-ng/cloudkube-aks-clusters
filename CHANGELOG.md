# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [0.6.0](https://github.com/julie-ng/cloudkube-aks-clusters/compare/v0.5.0...v0.6.0) (2024-04-25)


### Features

* add workload identity ([4dff3fb](https://github.com/julie-ng/cloudkube-aks-clusters/commit/4dff3fbcdf234bc897b1e293c92c8c5791a34910))
* **charts:** update kv csi and nginx ingress versions ([29e16b5](https://github.com/julie-ng/cloudkube-aks-clusters/commit/29e16b58bcb66a98d53e1b135542d2c3b85a6a0f))
* **defaults:** newer k8s version ([1b38c9a](https://github.com/julie-ng/cloudkube-aks-clusters/commit/1b38c9a2ee2192b0b0d2b5abf725b37d4723e31e))
* **hello-world:** use v0.4.0 ([18bd7cb](https://github.com/julie-ng/cloudkube-aks-clusters/commit/18bd7cb0e8313fc1c06d8d72f86303710678fede))
* **ingress:** update node pool name ([c73290f](https://github.com/julie-ng/cloudkube-aks-clusters/commit/c73290f9798fdcdf6e28e7adc160b807b6fc88e7))
* **nodepools:** use AzureLinux. Fix 'system' and 'user' mixup 🤦‍♀️ ([ae132cd](https://github.com/julie-ng/cloudkube-aks-clusters/commit/ae132cd6f492705b3cc0e67b2a51b9ffdc3c0bcb))
* remove unused architecture-review namespace ([fae74b4](https://github.com/julie-ng/cloudkube-aks-clusters/commit/fae74b4ac63f5a6a14b20ce7e4e57c35219e01c5))

## [0.5.0](https://github.com/julie-ng/cloudkube-aks-clusters/compare/v0.4.0...v0.5.0) (2024-01-29)


### Features

* **costs:** remove unused container registry ([a6eac51](https://github.com/julie-ng/cloudkube-aks-clusters/commit/a6eac51a8c16ab5cf562ba596e82ea732a3db5e2))


### Bug Fixes

* **iac:** managed rg always forcing replacement [#8](https://github.com/julie-ng/cloudkube-aks-clusters/issues/8) ([f75871a](https://github.com/julie-ng/cloudkube-aks-clusters/commit/f75871a0a1bd7b22b9a07c9336a1e840b374192b))
* **ingress:** new Azure annotations, update deps ([5d82d01](https://github.com/julie-ng/cloudkube-aks-clusters/commit/5d82d0138fd92779760b7f779fb78be80e357330))
* **rbac:** stable role assignments via IaC, closes [#7](https://github.com/julie-ng/cloudkube-aks-clusters/issues/7) ([0ee3c11](https://github.com/julie-ng/cloudkube-aks-clusters/commit/0ee3c113c5fc2add7bf6573808c44eec05a5073e))
* remove web-app-routing, does not work for this use case. ([1aa12c4](https://github.com/julie-ng/cloudkube-aks-clusters/commit/1aa12c4fba09307dd6809df91e682f0abedc50b2))
* **staging:** lifecycle for manual cluster name ([4863999](https://github.com/julie-ng/cloudkube-aks-clusters/commit/4863999c65d43ff46c8a7240a925c0c5a29e9caf))
* use local vars to prevent re-creating assignments ([f33be0b](https://github.com/julie-ng/cloudkube-aks-clusters/commit/f33be0bdc1c4a7352076e4c568e3132cb0ca5d38))
* yaml 🤦‍♀️ ([94c2b2e](https://github.com/julie-ng/cloudkube-aks-clusters/commit/94c2b2eb63614299310921188c30381c40871ff7))

## [0.4.0](https://github.com/julie-ng/cloudkube-aks-clusters/compare/v0.3.0...v0.4.0) (2022-04-02)


### Features

* **aks:** swap pool defs. to use aks sys or user 'mode'  [#6](https://github.com/julie-ng/cloudkube-aks-clusters/issues/6) ([5a51f7c](https://github.com/julie-ng/cloudkube-aks-clusters/commit/5a51f7c37228361ae42861000d3d98f5caa7c260))
* **cluster:** remove pod-identity ns and managed identity resource [#4](https://github.com/julie-ng/cloudkube-aks-clusters/issues/4) ([158d431](https://github.com/julie-ng/cloudkube-aks-clusters/commit/158d431d4d962d4ab9a0fdac28f9b2274633a775))
* **cluster:** remove to be replaced pod-identity [#4](https://github.com/julie-ng/cloudkube-aks-clusters/issues/4) ([4a14b98](https://github.com/julie-ng/cloudkube-aks-clusters/commit/4a14b985449bb55616f91d6ebed813647f396388))
* **hello-world:** add request limits ([6c0ea40](https://github.com/julie-ng/cloudkube-aks-clusters/commit/6c0ea40e4605331c6906ababd2cd014a0f14a838))
* **hello-world:** move out of ingress ns. needs root cert in its namespace ([63a7c53](https://github.com/julie-ng/cloudkube-aks-clusters/commit/63a7c533e205a123cd8b20f473a5b4dc5f3c5ddb))
* **ingress:** give controller 1 min to come up before creating resoruces ([36be9f2](https://github.com/julie-ng/cloudkube-aks-clusters/commit/36be9f245dc914fc9f5f890f51dfeec6ec640477))
* **naming:** make suffix length a variable ([6402e01](https://github.com/julie-ng/cloudkube-aks-clusters/commit/6402e0189637f507cdad33f1e4436773d815767b))
* **ops:** add update node surges, use automatic upgrade channels ([61a1d3a](https://github.com/julie-ng/cloudkube-aks-clusters/commit/61a1d3a0e55dcb7aa0c8e26fd1ddc0ffb19e5988))
* **resource-mgmt:** spread pods evenly across nodes ([b708c5c](https://github.com/julie-ng/cloudkube-aks-clusters/commit/b708c5c60eab1cca17bd984039dab388739680c5))
* **staging:** upgrade kubernetes to v1.20.9 ([a3d6263](https://github.com/julie-ng/cloudkube-aks-clusters/commit/a3d62634e03fe4d1673154f88a8d5f093a49c845))
* **terraform:** restart nodes on k8s upgrade [#5](https://github.com/julie-ng/cloudkube-aks-clusters/issues/5) ([cc4e503](https://github.com/julie-ng/cloudkube-aks-clusters/commit/cc4e5037afd824e26622fc58b346ca6b68910c01))
* **terraform:** update azure provider, deprecated syntax ([f0a1515](https://github.com/julie-ng/cloudkube-aks-clusters/commit/f0a1515b4e675d540a1fff0a711d3bad42782c68))


### Bug Fixes

* **kv-csi:** install in kube-system namespace per docs ([de2e5b7](https://github.com/julie-ng/cloudkube-aks-clusters/commit/de2e5b7b697a32815188d46109eb9cef42f30547))
* **makefile:** need to update helm repo if updating chart version ([c65c87d](https://github.com/julie-ng/cloudkube-aks-clusters/commit/c65c87d2d672b3f3b197a5b3e20ab0652951bfe6))
* **user-nodes:** ensure tf state matches actual cluster state ([ac467df](https://github.com/julie-ng/cloudkube-aks-clusters/commit/ac467df4547514a1469262ada0cadc9bc7960e95))

## 0.3.0 (2021-12-06)


### Features

* **aks:** split user and system node pools ([38199d9](https://github.com/julie-ng/cloudkube-aks-clusters/commit/38199d9bd83da01f91b9c5c385a92a609eb9e5a8))
* **monitoring:** add azure oms agent ([b4a0484](https://github.com/julie-ng/cloudkube-aks-clusters/commit/b4a04840ea90c702e9e1bab71fd96ad128c70766))
* **namespace:** rename file, add aks-architect ([8eafc9a](https://github.com/julie-ng/cloudkube-aks-clusters/commit/8eafc9a1cce2d55b3d7a937bc4ef479f441669f8))
* **rbac:** move managed identity out of managed rg, closes [#1](https://github.com/julie-ng/cloudkube-aks-clusters/issues/1) ([5a2ada1](https://github.com/julie-ng/cloudkube-aks-clusters/commit/5a2ada123f6e34e79a35e104c15c471c444bfcf5))
* **rbac:** update diagram for moved managed identities, [#1](https://github.com/julie-ng/cloudkube-aks-clusters/issues/1) ([1f415c8](https://github.com/julie-ng/cloudkube-aks-clusters/commit/1f415c81d99213ae6c12871c9e2c6b23e18e22d6))

## 0.2.0 (2021-09-17)


### Features

* **aks:** disable local accounts, preview feature ([63110a5](https://github.com/julie-ng/cloudkube-aks-clusters/commit/63110a57590cfd29a97ee1be726fc5a710e5d332))
* **dev:** upgraded k8s version from 1.19.7 to 1.20.9 ([b5bc9e5](https://github.com/julie-ng/cloudkube-aks-clusters/commit/b5bc9e52d53ad9bf073b81e9113c396e3ea3a016))
* **dev:** use Azure RBAC enabled k8s cluster ([deaade6](https://github.com/julie-ng/cloudkube-aks-clusters/commit/deaade6e06f8d00dc38baeb519169e6d0fa3681f))

## 0.1.0 (2021-09-14)

### Features

* **terraform:** re-structure, add required features block ([4d8dfaf](https://github.com/julie-ng/cloudkube-aks-clusters/commit/4d8dfaf13a01dd4458b8f7b915f802abd56c15f3))
