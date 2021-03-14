#!/bin/bash

# http://download.qnap.com/dev/QNAP_QTS_File_Station_API_v4.1.pdf

# Parse arguments
usage() {
    echo "Usage: $0 [-f FILE] [-p PATH] [-f FILE]"
    echo "  -h  Help. Display this message and quit."
    echo "  -f  Specify file to upload FILE."
    echo "  -p  Specify remote path PATH."
    exit
}

optspec="hp:f:"
while getopts "$optspec" optchar
do
    case "${optchar}" in
        h)
            usage
            ;;
        f)
            file="${OPTARG}"
            ;;
        p)
            path="${OPTARG}"
            ;;
        *)
            usage
            ;;
    esac
done

dflt_path='/'

# check mandatory arguments
[ -z "$file" ] && echo "Error: no file provided." && echo "Sample usage: $0 -f somefile.txt -p /public/dir" && exit 1
[ -z "$path" ] && echo "Warning: No remote path provided default to $dflt_path." && path=$dflt_path

# get password and user name
read -p  "username: " user
read -sp "password: " pw
echo

ip=<url-where-your-qnap-share-is-hosted>
base64_encoded_password=$(echo -n "$pw" | base64)

# login and retreive sid
ret=$(curl "https://$ip/cgi-bin/filemanager/wfm2Login.cgi?user=$user&pwd=$base64_encoded_password")
status=$(echo $ret | sed -e 's/.*"status":\(.*\)./\1/' | awk -F, '{print $1}')
sid=$(echo $ret | sed -e 's/.*"sid":\(.*\)./\1/' | awk -F\" '{print $2}')

if [ $status -ne 1 ]; then
    echo "Error: attempt to connect failed. Check password or username."
    exit 1
else
    echo "Login successful."
fi

# upload file
curl --form "fileupload=@$file" --url "https://$ip/cgi-bin/filemanager/utilRequest.cgi?func=upload&type=standard&sid=$sid&dest_path=$path&overwrite=1&progress=-"

# logout
curl "https://$ip/cgi-bin/filemanager/wfm2Logout.cgi"
