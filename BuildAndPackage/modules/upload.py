#@upload.py
#
# Copyright 2011 Trae Santiago
# ================================================
#
# This file is part of BuildAndPackage
#
# BuildAndPackage is free software: you 
# can redistribute it and/or modify it under the 
# terms of the GNU General Public License as 
# published by the Free Software Foundation, 
# either version 3 of the License, or (at your 
# option) any later version.
# 
# BuildAndPackage is distributed in the
# hope that it will be useful, but WITHOUT ANY 
# WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR 
# PURPOSE. See the GNU General Public License 
# for more details.
# 
# You should have received a copy of the GNU 
# General Public License along with BuildAndPackage. 
# If not, see: <http://www.gnu.org/licenses/>.
# (T.S / T.B / Trae32566 / Trae Santiago)

class Credentials():
    def __init__(self, file):
        self.file = file
    
    def __get_pass__(self, verify = False):
        from getpass import getpass
        from whirlpool import Whirlpool

        pwd = getpass(prompt = 'Please enter your password: ')
        
        #Double check for their password
        if verify: 
            if getpass(prompt = 'Please re-enter your password: ') != pwd: self.get_pass(verify)
            
        key = Whirlpool(pwd)
        return int(key.hexdigest(), 16)
    
    def __validity_check__(self, data):
        pass

    def decrypt(self):
        key = self.__get_pass__()
        
        with open(self.file, 'w+b') as credFile:
            pass

    def encrypt(self):
        from os import sep
        from sys import byteorder
        
        cryptCred = int()  
        iv = int()
        key = self.__get_pass__(verify = True)
        
        with open(self.file, 'w+b') as credFile:
            plainText = int.from_bytes(credFile.read(64))

            #Get a random number as our initialization vector (this WILL NOT work on standard Win32!)
            with open('{0}dev{0}random'.format(sep), 'rb') as rng:
                #Crap to learn.
                pass

        print(cryptCred)
        
    def get_cred(self):
        key = self.__get_pass__()
        
        with open(self.file, 'rb') as credFile:
            pass

class Upload():
    def __init__(self, file, project = None, summary = None, labels = None):
        pass
    
    def google_code(self, file, password, project, summary, user, labels = None):
        from base64 import b64encode        
        from os.path import basename
        from http.client import HTTPSConnection 
    
        body = []
        ##Maybe we change this later...something nicer perhaps.
        boundary = '------------Googlecode_boundary_reindeer_flotilla'
    
        #Strip everything but the username(and not everyone has @ gmail, some people have @google!)
        if user.endswith('.com'): user = user[:user.find('@')]
    
        #If we have labels then format them
        if labels:
            finLabels = [('summary', summary)]
            for label in labels:
                finLabels.append(('label', label))
            labels = finLabels
    
            #Add metadata
            for metadata in labels: body.extend([boundary, 
                                                'Content-Disposition: form-data; name="{0}"'.format(metadata[0]), 
                                                '', 
                                                metadata[1]])
    
        #Add the file
        with open(file, 'rb') as content: 
            body.extend([boundary, 
                        'Content-Disposition: form-data; name="filename"; filename="{0}"'.format(basename(file)), 
                        'Content-Type: application/octet-stream', 
                        '',
                        str(content.read()), boundary + '--', 
                        ''])
    
        #Send files
        gCodeServ = HTTPSConnection(project + '.googlecode.com')
        gCodeServ.debuglevel = 1
        gCodeServ.request(
            'POST', 
            project + '.googlecode.com/files', 
            bytes(str(body), 'utf-8'),
            {
                'Authorization': 'Basic {0}'.format(str(b64encode(bytes('{0}:{1}'.format(user, password),'UTF-8')), 'UTF-8')),
                'User-Agent': 'BuildAndPackage upload.py',
                'Content-Type': 'multipart/form-data; boundary={0}'.format(boundary)})
    
        #Get response
        gCodeServ.response = gCodeServ.getresponse()
        
    def dropbox(self):
        pass