#!/bin/bash
#
# Maintainer: Omer Barel (jungo@jungopro.com)

######################################################################################################################################################################
# Examples:
#
#
# Run with minimum values (Note that the defaults should pre-exist in your shell environment: TFM_STORAGE_NAME, TFM_STORAGE_CONTAINER, TFM_STORAGE_ACCESS_KEY)
#  ./TerraformInitAzureBackend.sh -f "terraform.tfstate"
#
# Run with all values
#  ./TerraformInitAzureBackend.sh -s "MYSTORAGEACCOUNT" -c "MYCONTAINER" -a "MYSTORAGEACCOUNTACCESSKEY" -f "terraform.tfstate"
#
######################################################################################################################################################################

function show_help() {
    cat <<EOF
Usage: ${0##*/} [-a access_key] [-c container_name] [-f state_file] [-s storage_account_name]
Initialize Terraform with Azure backend configuration
         -a access_key              (Optional) Access key to access the storage account. defaults to $TFM_STORAGE_ACCESS_KEY
         -c container_name          (Optional)) Name of the contianer in the storage account in Azure that holds the state files. defaults to $TFM_STORAGE_CONTAINER
         -f state_file              (Required) Name of the state file that holds the state
         -s storage_account_name    (Optional) Name of the storage account in Azure that holds the state files. defaults to $TFM_STORAGE_NAME
         -h                         display this help and exit
Examples:

- Run with minimum values (Note that the defaults should pre-exist in your shell environment: TFM_STORAGE_NAME, TFM_STORAGE_CONTAINER, TFM_STORAGE_ACCESS_KEY)
   ./TerraformInitAzureBackend.sh -f "terraform.tfstate"

- Run with all values
   ./TerraformInitAzureBackend.sh -s "MYSTORAGEACCOUNT" -c "MYCONTAINER" -a "MYSTORAGEACCOUNTACCESSKEY" -f "terraform.tfstate"
EOF
}

# Initialize variables

if ! [[ -z "${TFM_STORAGE_NAME}" ]]; then
    STORAGE_ACCOUNT=$TFM_STORAGE_NAME
fi

if ! [[ -z "${TFM_STORAGE_CONTAINER}" ]]; then
    CONTAINER=$TFM_STORAGE_CONTAINER
fi

if ! [[ -z "${TFM_STORAGE_ACCESS_KEY}" ]]; then
    STORAGE_ACCOUNT_KEY=$TFM_STORAGE_ACCESS_KEY
fi

# Parse Arguments
while getopts :a:c:f:hs: opt; do
    case $opt in
        a) STORAGE_ACCOUNT_KEY=$OPTARG
        ;;
        c) CONTAINER=$OPTARG
        ;;
        f) STATE_FILE=$OPTARG
        ;;
        h) show_help
            exit 0
        ;;
        s) STORAGE_ACCOUNT=$OPTARG
        ;;
        \?) echo "Unknown option: -$OPTARG" >&2
            exit 1
        ;;
        *)
            show_help >&2
            exit 1
        ;;
    esac
done

if ! [[ -z "${STORAGE_ACCOUNT_KEY}" ]] && ! [[ -z "${CONTAINER}" ]] && ! [[ -z "${STATE_FILE}" ]] && ! [[ -z "${STORAGE_ACCOUNT}" ]]
then
    terraform init \
    -backend-config="storage_account_name=$STORAGE_ACCOUNT" \
    -backend-config="container_name=$CONTAINER" \
    -backend-config="access_key=$STORAGE_ACCOUNT_KEY" \
    -backend-config="key=$STATE_FILE"
else
    printf "required arguments are missing!\n"
    show_help
fi