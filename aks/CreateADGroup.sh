readonly ad_group_name="$1"
readonly subscription="$2"
groupExists=$(az ad group list --subscription "${subscription}" | grep "${ad_group_name}" | wc -w)

if [ "${groupExists}" -eq 0 ]
then
    az ad group create --display-name "${ad_group_name}" --mail-nickname "${ad_group_name}" --subscription "${subscription}" -o json
else
    echo "Group Exists. Existing"
    exit
fi