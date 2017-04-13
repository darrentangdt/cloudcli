#!/usr/bin/python

from subprocess import Popen,PIPE
import subprocess
import sys,os,time
import ConfigParser
import logging
import logging.handlers



LOCALE = 'LC_ALL=en_US.utf-8'
CONF_PATH='/home/ap/opscloud/conf'

def execute(command, interactive=False):
            """Function that execute **command** using english utf8 locale. The output
            is a list of three elements ([*status*, *stdout*, *stderr*]). *status* is
            *True* only if return code is equal to 0. When **interactive**, output is
            in real time and interactions (ie: inputs) are possible. In this case
            *stdout* and *stderr* are empty. Return code is put in the *return_code*
            attribute of the object."""
            command = '%s %s' % (LOCALE, command)
            if interactive:
                try:
                    return_code = subprocess.call(
                        command,
                        shell=True,
                        stderr=subprocess.STDOUT
                    )
                    return [
                        True if return_code == 0 else False,
                        '',
                        ''
                    ]
                except subprocess.CalledProcessError as proc_err:
                    return [False, '', '']
            else:
                try:
                    obj = subprocess.Popen(
                        command,
                        shell=True,
                        stdout = subprocess.PIPE,
                        stderr = subprocess.PIPE
                    )
                    stdout, stderr = obj.communicate()
                    return_code = obj.returncode
                    return [
                        True if return_code == 0 else False,
                        '\n'.join(stdout.split('\n')[:-1]),
                        '\n'.join(stderr.split('\n')[:-1])
                    ]
                except OSError as os_err:
                    return [False, stdout, stderr]


def row2line(rows):
    long_line = []
    for line in rows.split("\n"):
        long_line.append(line)
    return long_line



def fetch_active_hosts():
    command = r"curl -s -u admin:admin http://11.170.0.190:8161/admin/queueConsumers.jsp?JMSDestination=mcollective.nodes|grep mc_identity|awk -F \' '{print $2}'"
    result = execute(command)
    return str(result[1].split("\n"))



def check_host(host_file,field=False):
    hosts = fetch_active_hosts()
    flag = 0
    noactive_hosts = []
    active_hosts = []
    for line in open(host_file,'r').readlines():
        if field:
            host = line.split("::")[0]
        else:
            host = line
        if host.strip().lower() not in hosts:
            flag = flag + 1
            noactive_hosts.append(line +'\n')
        else:
            active_hosts.append(line + '\n')

    ok_host = open('activehosts_list.log','w')
    fail_host = open('noactivehosts_list.log','w')

    ok_host.writelines(active_hosts)
    fail_host.writelines(noactive_hosts)

    ok_host.close()
    fail_host.close()

    if flag == 0:
        return True
    else:
        return False


class Push(object):
    def __init__(self, host_file, destination, source, owner, mode):
        self.host_file = host_file
        self.dest_path= destination
        self.source_path=source
        self.owner = owner
        self.mode = mode

        self.log_file=os.path.join(os.getcwd(),'log.txt')
        self.handler = logging.handlers.RotatingFileHandler(self.log_file,maxBytes=1024*1024,backupCount=5)
        fmt = '%(asctime)s - %(levelname)s: %(message)s'

        self.formatter = logging.Formatter(fmt)
        self.handler.setFormatter(self.formatter)
	
    def push_file(self):
        logger = logging.getLogger('push')
        logger.addHandler(self.handler)
        logger.setLevel(logging.DEBUG)
        file_list = open(self.host_file,'r').readlines()
        try:
            for hostname in file_list:
                if not hostname.isspace():
                    p_common = r"mco shell 'puppet resource file " + self.dest_path + r" source=puppet://puppet" + self.source_path + " owner="+ self.owner +  " group=" +  self.owner +"  mode=" + self.mode + r" recurse=remote'  -I " + hostname.lower()
                else:
                    continue    
                if os.getlogin() != 'root':
                    p_common = "sudo "+ p_common
                result = execute(p_common)
                header = "[" + hostname.strip() + "]"
                if result[0] == True:
                    print header + " destribute OK"
                    logger.info( header + str(result[1].split("\n")) )
                elif result[0] == False:
                    print header + " destribute FAILED"
                    logger.error( header + result[2])
        except IOError:
            print "Error"


class exec_command(object):
    def __init__(self,command,host_file,role):
        self.command=command
        self.host_file=host_file
        self.role = role
        self.log_file=os.path.join(os.getcwd(),'log.txt')
        self.handler = logging.handlers.RotatingFileHandler(self.log_file,maxBytes=1024*1024,backupCount=5)
        fmt = '%(asctime)s - %(levelname)s: %(message)s'

        self.formatter = logging.Formatter(fmt)
        self.handler.setFormatter(self.formatter)



    def patrol_change_passwd(self):
        logger = logging.getLogger('patrol')
        logger.addHandler(self.handler)
        logger.setLevel(logging.DEBUG)

        file_list = open(self.host_file,'r').readlines()
        try:
            for line in file_list:
                if not line.isspace():
                    hostname,password = line.strip().split("::")
                else:
                    continue
                c_command = r"mco shell 'echo patrol:" + password.strip() + r"|chpasswd ' -I " + hostname.lower()
                if os.getlogin != 'root':
                    c_command = 'sudo ' + c_command
                result = execute(c_command)
                header = "[" + hostname.strip() + "]"
                if result[0] == True:
                    print header + " successful"
                    logger.info( header + str(result[1].split("\n")) )
                elif result[0] == False:
                    print header + " failed"
                    logger.error( header + result[2])
        except IOError:
            print "Error"


    def run(self):
        logger = logging.getLogger('run')
        logger.addHandler(self.handler)
        logger.setLevel(logging.DEBUG)
        host_list = open(self.host_file,'r').readlines()
        if self.role != 'root':
            p_command = r"mco shell 'su - " + self.role + " -c " + self.command + r"' -I "
        else:
            p_command = r"mco shell '" + self.command + r"' -I "
        
        if os.getlogin != 'root':
            p_command = 'sudo ' + p_command
        
        try:
            for host in host_list:
                if not host.isspace():
                    s_command = p_command + host.lower()
                else:
                    continue
                result = execute(s_command)
                header = "[" + host.strip() + "]"
                if result[0] == True:
                    print host + result[1] 
                    logger.info( header + str(result[1].split("\n")) )
                elif result[0] == False:
                    print host + result[2]
                    logger.error( header + result[2])
        except IOError:
            print "Error"


def patrol_question():
    cf = ConfigParser.RawConfigParser()
    cf.read(os.path.join(CONF_PATH,"command.conf"))
    dest_path = cf.get('patrol',"destination")
    source_path = cf.get('patrol',"source")
    owner = cf.get('patrol','owner')
    mode = cf.get('patrol','mode')
    command = cf.get('patrol','cmd')
    role = cf.get('patrol','role')
    print """
        1)push file to nodes
        2)change patrol password
        3)run command
        4)quit
    """
    while True:
        flag=input("please choice:")

        if flag == 1:
            while True:
                h_file = raw_input("input host list file:")
                if os.path.isfile(h_file):
                    break
                else:
                    print "file:"+h_file+"is not a file!,please input"
            print "Check host list file ...... \n"
            if check_host(h_file):
                print "Check status ok,passing ...... \n "
                print "Begin push file ......\n"
                Push(host_file=h_file, destination=dest_path, source=source_path, owner=owner, mode=mode).push_file()
            else:
                print "Check status failed"
                print "please see current dir: activehosts_list.log and noactivehosts_list.log \n"
                sys.exit(1)
        elif flag == 2:
            while True:
                h_file = raw_input("input host list file for change patrol password:")
                if os.path.isfile(h_file):
                    break
                else:
                    print "file:"+h_file+"is not a file!,please input"

            print "Check host list file ...... \n"
            if check_host(h_file,field=True):
                print "Check status ok,passing ...... \n "
                print "Begin change password command ......\n"
                exec_command(command="",host_file=h_file.strip(),role=role).patrol_change_passwd()
            else:
                print "Check status failed"
                print "please see current dir: activehosts_list.log and noactivehosts_list.log \n"
                sys.exit(1)
        elif flag == 3:
            while True:
                h_file = raw_input("input host list file for run ["+ command + "]:")
                if os.path.isfile(h_file):
                    break
                else:
                    print "file:"+h_file+"is not a file!,please input"
            print "Check host list file ..... \n"
            if check_host(h_file):
                print "Check status ok,passing ...... \n "
                print "Begin execute command ...... \n"
                exec_command(command=command,host_file=h_file.strip(),role=role).run()
            else:
                print "Check status failed"
                print "please see current dir: activehosts_list.log and noactivehosts_list.log \n"
                sys.exit(1)
        elif flag == 4:
            sys.exit(0)
        else:
            print "Error choise num"
            sys.exit(1)
def sa_question():
    #define log format,log file

    #parse config ,find sa content
    cf = ConfigParser.RawConfigParser()
    cf.read(os.path.join(CONF_PATH,"command.conf"))
    dest_path = cf.get('sa',"destination")
    source_path = cf.get('sa',"source")
    owner = cf.get('sa',"owner")
    mode = cf.get('sa',"mode")
    role = cf.get('sa',"role")
    floor = 0
    print """
        1)push file to nodes
        2)exec command
        3)see log
        4)quit
    """
    flag = input("please choice:")
    while True:
        if floor == 1:
            print """
            1)push file to nodes
            2)exec command
            3)see log
            4)quit
            """
            flag = input("please choice:")
        if flag == 1:
            host_file = raw_input("please provide a host_list file:")
            Push(host_file=host_file,destination=dest_path,source=source_path,owner=owner,mode=mode).push_file()
            floor = 1
        elif flag == 2:
            host_file = raw_input("please provide a host_list file:")
            if os.path.isfile(os.path.join(os.getcwd(), host_file)):
                command = cf.get('sa','cmd')
                exec_command(command=command,host_file=host_file,role=role).run()
                floor = 1
            else:
                print "you input file is not exist!!!"
        elif flag == 4:
            sys.exit(0)
        else:
            print "Error input!!!"



patrol_question()
