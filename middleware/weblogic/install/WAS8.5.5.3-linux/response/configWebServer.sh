#!/bin/sh

binDir=`dirname "$0"`
. "$binDir/setupCmdLine.sh"

IHS_HOME='/wasProgram/WebSphere/HTTPServer8'
IHS_PORT=80
PLG_HOME='/wasProgram/WebSphere/Plugin8'
WEBSERVER_NAME='#WEBSERVER_NAME#'
NODE_NAME='webservernode'

COMMAND_INVOKED="$0"

PROFILE_NAME_PARAMETER=
WSADMIN_USERID_PARAMETER=
WSADMIN_PASSWORD_PARAMETER=

printUsage()
{
        echo ""
        echo ""
        echo "Usage: $COMMAND_INVOKED"
        echo "    [ -profileName profile_name  ] "
        echo "    [ -user WAS_Admin_userID  ] "
        echo "    [ -password WAS_Admin_password ] "
        echo "    [ -help | -? ]"
        echo " "
        echo "Where:"
        echo "    \"profileName\" is the name of the profile in which "
        echo "    web server should be created"
        echo "    \"user\" is the WebSphere Administration userID"
        echo "    \"password\" is the WebSphere Administration password"
        echo " "
        echo "Example: "
        echo "    $COMMAND_INVOKED -profileName AppSrv01 -user admin -password admin1"
        echo " "
        echo " "

        exit 0
}

printError()
{
        echo "ERROR: $1"
        printUsage
}

while [ $# -gt 0 ]; do
    case $1 in
              -help|-?) printUsage 
                        exit 0                
                        ;;
          -profileName) shift
                        echo "Using the profile $1"
                        PROFILE_NAME_PARAMETER="-profileName $1"
                        ;;
                 -user) shift
                        echo "Using WAS admin userID $1"
                        WSADMIN_USERID_PARAMETER="-user $1"
                        ;;
             -password) shift
                        WSADMIN_PASSWORD_PARAMETER="-password $1"
                        ;;
                    -*) echo "Unsupported option"
                        echo "$1"
                        printUsage 
                        exit 0                
                        ;;
   esac
   shift
done

./wsadmin.sh $PROFILE_NAME_PARAMETER $WSADMIN_USERID_PARAMETER $WSADMIN_PASSWORD_PARAMETER -f $WAS_HOME/bin/configureWebserverDefinition.jacl $WEBSERVER_NAME IHS $IHS_HOME "$IHS_HOME/conf/httpd.conf" $IHS_PORT MAP_ALL $PLG_HOME unmanaged $NODE_NAME  webserverhost linux
