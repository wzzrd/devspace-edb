#!/bin/bash
# Script to add users to an OpenShift group
role_binding_group="cluster-admin-edb"
cluster_role="cluster-admin"

# Check if the 'oc' command-line tool is installed
if ! command -v oc &> /dev/null
then
    echo "Error: The 'oc' command-line tool is not installed or not in PATH."
    echo "Please install the OpenShift CLI (oc) and ensure it is in your system's PATH."
    exit 1
fi

# Check if the user is logged in to an OpenShift cluster
if ! oc whoami &> /dev/null
then
    echo "Error: You are not currently logged in to an OpenShift cluster."
    echo "Please log in using 'oc login' before running this script."
    exit 1
fi

# Prompt the user for the group name
read -p "Enter the name of the OpenShift group to add users to: " group_name

# Validate the group name
if [[ -z "$group_name" ]]; then
    echo "Error: Group name cannot be empty."
    exit 1
fi

# Check if the group exists.  Important for safety.
if ! oc get group "$group_name" &> /dev/null; then
  echo "The group '$group_name' does not exist."
  echo "Creating the group '$group_name'."
  oc adm groups new $group_name
fi

# Check if the group is part of admin-cluster role.
if ! oc get clusterrolebinding "$role_binding_group" &> /dev/null; then
  echo "The group '$role_binding_group' does not exist."
  echo "Creating the group '$role_binding_group'."
  oc create clusterrolebinding $role_binding_group --clusterrole=$cluster_role --group=$group_name
fi



# Loop through users 1 to 30 and add them to the group
for user_id in $(seq 1 30)
do
    username="user${user_id}"
    # Check if the user exists before attempting to add it to the group.
    if ! oc get user "$username" &> /dev/null; then
        echo "Warning: User '$username' does not exist. Skipping."
        continue # Skip to the next iteration of the loop
    fi

    echo "Adding user '$username' to group '$group_name'..."
    oc adm groups add-users "$group_name" "$username"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to add user '$username' to group '$group_name'."
        #  Consider 'exit 1' here if you want the script to stop on any error.
    fi
done

echo "Finished adding users 1 to 30 to group '$group_name'."
exit 0

