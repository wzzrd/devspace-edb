# EDB Workshop

## EDB Workshop Install Instructions on Openshift using Dev Spaces

1. Install DevSpaces & EDB operator as global
2. Login with oc cli as cluster-admin
3. Execute ```./loopusers.sh``` to make sure users are created after the first login 
4. Login with oc cli as cluster-admin AGAIN
5. Deploy users, using the script ```./userscript.sh```
6. Create CheCluster instance ```oc apply -f CheCluster.yaml -n openshift-operators```
7. Execute ```./add-edb-to-samples-in-devspaces.sh```
8. Get the URL for DevSpaces ```oc get route devspaces -n openshift-operators```
9. Create namespace for minio ```oc new-project minio```
10. Deploy mino as cluster-admin ```oc apply -f minio.yaml -n minio```
11. Get the URL for minio-ui with ```oc get route minio-ui -n minio```

## Getting Started with EDB Workshop
Each user can create its own DevSpaces instance (login to URL for DevSpaces) by using *Create Workspace* and choose 
- the pre-configured sample: **Postgres on OpenShift Workshop**
- or create from git repo: ```https://github.com/maschind/devspace-edb.git```

Once you launch your DevSpaces instance, you should have the workshop repository available along with the exercise in the **README.md**. 

### Troubleshooting 
In case you run the workshop with more than 20 users, it is recommended to extend the cluster beyond the 6 default worker nodes (each 64GB Memory). Simply increase the corresponding machineSet to 7 nodes (or more) to increase capacity: ```oc get MachineSet -A```

Hint: for 30 workshop users 8 nodes are working well. 




