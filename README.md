# qnap-file-upload
Simple script to upload a file to Qnap share using a POST request via curl. No big deal, but since I did not catch the idea on how to do this immediately and some people expressed their interest, I will share it here.

## usage

```
 Usage: ./q-upload.sh [-f FILE] [-p PATH] [-f FILE]
   -h  Help. Display this message and quit.
   -f  Specify file to upload FILE.
   -p  Specify remote path PATH
 ```

## further information

Further information on the HTTP API can be found [here](http://download.qnap.com/dev/QNAP_QTS_File_Station_API_v4.1.pdf). Maybe I will extend the features of the script to some stuff of this documentation like creating a directore on the share.
