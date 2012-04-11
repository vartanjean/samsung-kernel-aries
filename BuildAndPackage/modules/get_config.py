#@get_config.py
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

class GetConfig:
    """Class that grabs the configuration from files

This class includes:

  o __sanitize__(depth, domElement):
     Cleans domElement of everything except true
     data at the tag level depth
     Returns domElement (cleaned)
     depth (integer -> tag depth): data depth of tags
     domElement (domElement object): domElement object

  o __get_config
    """
    devices = list()

    def __init__(self):
        from os import sep
        from sys import path

        self.mainPath = path[0]
        self.resources = '{0}{1}BuildAndPackage{1}resources{1}'.format(self.mainPath, sep)

        self.__get_config__()

    def __get_config__(self):
        from error import FileAccessError, UserSettingsError
        from os import sep
        from xml.dom import minidom
        from xml.parsers.expat import ExpatError

        newSettings = str()
        userSettings = '{0}{1}userSettings.xml'.format(self.resources, sep)

        try:
            with open(userSettings, 'r') as settings:
                newSettings = settings.read().format(sep, self.mainPath + sep)
        except IOError: raise FileAccessError(userSettings)

        try:
            with minidom.parseString(newSettings).documentElement as rawSettings:
                get_list = lambda tagName: self.__raw_to_list__(tagName, rawSettings)
                get_static = lambda tagName: rawSettings.getElementsByTagName('static').item(0).getElementsByTagName(tagName).item(0).childNodes.item(0).data
                rawSettings = self.__sanitize__(2, rawSettings)

                #Get all our depth 2 scopes
                self.defDevices, self.devices = get_list('devices')
                self.defToolchain, self.toolchains = get_list('toolchains')
                self.defToolchain = self.defToolchain[0]

                #Get our static variables
                self.defClean = get_static('clean')
                self.defPackage = get_static('package')
                self.defUpload = get_static('upload')
                self.initRAMDisk = get_static('initial')
                self.locCred = get_static('cred_location')
                self.recoRAMDisk = get_static('recovery')
                self.version = get_static('version')
                self.zImage = get_static('zImage')            

                if self.defClean == 'FALSE': self.defClean = False
                if self.defUpload == 'FALSE': self.defUpload = False
        except ExpatError as err: raise UserSettingsError(str(err)[str(err).find('g:') + 3:])

    def __raw_to_list__(self, elementName, parentElement):
        from error import UserSettingsError

        listData = list()
        listDefault = list()

        nodeList = parentElement.getElementsByTagName(elementName).item(0).childNodes

        for indNode in range(nodeList.length):
            node = nodeList.item(indNode)

            #Make sure there are no duplicates (except default)
            if indNode >= 0:
                data = node.tagName, node.childNodes.item(0).data          

                try: listData.index(data)
                except ValueError: listData.append(data)

        default = listData[0][1]
        listData = listData[1:]

        #Format default into a list
        indStart = 0
        while True: 
            indEnd = default[indStart:].find(' | ') + indStart

            #Separator was not found
            if indEnd < indStart:
                listDefault.append(default[indStart:])
                break
            else:
                listDefault.append(default[indStart: indEnd])
                indStart = indEnd + 3

        #Check for user errors
        for data in listDefault:
            names = list()
            for name in listData: names.append(name[0])

            try: names.index(data)
            except ValueError: 
                print(str(data) + 'was not found in ' + str(listData))
                raise UserSettingsError('your default tags')

        return listDefault, listData

    def __sanitize__(self, depth, domElement):
        #Lets focus on just this node
        currentNode = domElement.firstChild 

        for domIndex in range(domElement.childNodes.length):
            #Take a copy of the next node in case we have to remove the current one
            nextNode = currentNode.nextSibling

            #If the node name isn't custom remove it
            if currentNode.nodeName[0] == '#' and depth: domElement.removeChild(currentNode)
            else: currentNode = self.__sanitize__(depth - 1, currentNode)

            currentNode = nextNode

        return domElement