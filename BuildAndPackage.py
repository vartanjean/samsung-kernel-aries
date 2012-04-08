#!/usr/bin/env python3
#@BuildAndPackage.py
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

from os import sep
from sys import path

dirBAP = '{0}{1}BuildAndPackage'.format(path[0], sep)

def cli(config):
    try: from argparse import ArgumentParser, REMAINDER
    except ImportError: 
        print('WARNING: You are using an old version of Python; Command line options will be disabled, please consider moving to Python 3.2 or newer!')
        config.clean = False
        config.package = 2
        return config

    choiceClean = ['DIST', 'MRP', 'NORM']
    choicePack = ['HEIMDALL', 'HOC', 'ZIP', 'IMG']
    choiceUpload = ['GCODE']
    
    #Grab the names for easy use
    nameDevices = list()
    nameToolchains = list()
    
    for name in config.devices: nameDevices.append(name[0])
    for name in config.toolchains: nameToolchains.append(name[0])

    #Add description
    cliParser = ArgumentParser(description = 'Kernel compiling and packaging system.')

    #Clean
    cliParser.add_argument(
        '-clean',
        choices = choiceClean,
        default = config.defClean,
        help = 'Type of clean before build')

    #Alternate build types
    cliParser.add_argument(
        '-package',
        choices = choicePack, 
        default = config.defPackage,
        help = 'Type of packaging')

    #Toolchain to use
    cliParser.add_argument(
        '-toolchain',
        choices = nameToolchains,
        default = config.defToolchain,
        help = 'Toolchain to use when building')

    #Google code upload
    cliParser.add_argument(
        '-upload',
        choices = choiceUpload,
        default = config.defUpload,
        help = 'Site to upload to')

    #Devices to build for
    cliParser.add_argument(
        '-devices', 
        choices = ['ALL'] + nameDevices,
        default = config.defDevices,
        help = 'Devices to compile for (must be at the end)',
        nargs = REMAINDER)

    cliParser.parse_args(namespace = cliParser)

    #Transfer CLI variables to config class
    config.package = choicePack.index(cliParser.package)
    config.toolchain = config.toolchains[nameToolchains.index(cliParser.toolchain)][1]
    if cliParser.clean: config.clean = choiceClean.index(cliParser.clean) + 1
    else: config.clean = False
    if cliParser.upload: config.upload = choiceUpload.index(cliParser.upload) + 1
    else: config.upload = False

    #Build only requested devices
    if cliParser.devices != ['ALL']:
        newDevs = list()

        for device in config.devices:
            try: 
                cliParser.devices.index(device[0])
                newDevs.append(device)
            except ValueError:pass

        config.devices = newDevs

    #Remove all our defaults
    del config.defClean, config.defDevices, config.defPackage, config.defToolchain, config.defUpload
    del config.toolchains

    return config

def main():
    #Add our module directory to the path and import modules
    path.append('{0}{1}modules{1}'.format(dirBAP, sep))
    import get_config

    #Get config
    config = cli(get_config.GetConfig())

    #Start working!
    for device in config.devices:
        worker(config, device[0], device[1])

        #Remove the clean, we only want it once
        config.clean = False

def worker(config, nameDev, defDev):
    from os import pardir
    from os.path import isdir
    from shutil import rmtree
    from threading import Thread
    import make, package, upload

    cli_print = lambda cOut: print(cOut, end = '')
    config.threadUpload = list()
    dirDev = dirBAP + sep + nameDev

    #Tell them if we clean
    if config.clean == 1: print('NOTE: -clean NORM was chosen, build directory will be cleaned of all configurations!\n')
    elif config.clean == 2: print('NOTE: -clean MRP was chosen, build directory will be deep cleaned!\n')
    elif config.clean >= 3: print('NOTE: -clean NORM was chosen, build directory will be cleaned!\n')

    #Get revision number, start feedback
    config.revision = make.revision()
    if isdir(dirDev): rmtree(dirDev)
    print(nameDev + ':')

    #Start configuring, build
    cli_print('\t • Configuring...')
    make.configure(defDev, config.toolchain, clean = config.clean)
    cli_print('done\n\t • Building...')
    try: 
        config.modules
        make.build(dirDev + '.log', config.toolchain)
    except AttributeError: config.modules = make.build(dirDev + '.log', config.toolchain)

    #Make boot.img
    cli_print('done\n\t • Creating boot.img and copying kernel components...')
    package.prep_compilation(
        package.make_boot_img(
            config.initRAMDisk, 
            config.zImage, 
            config.recoRAMDisk),
        config, 
        dirBAP, 
        dirDev, 
        nameDev)
    if config.package != 2:
        print('done\n')
        return
    
    #Make the script
    cli_print('done\n\t • Making script...')
    package.make_script(nameDev, 
                        '{0}{1}META-INF{1}com{1}google{1}android{1}updater-script'.format(dirDev, sep), 
                        '{0}{1}resources{1}updater-script.template'.format(dirBAP, sep), 
                        config.version + '.' + config.revision)   

    #Zip
    cli_print('done\n\t • Zipping...')
    package.make_zip('{0}{1}{2}{1}[Kernel]-{3}-{4}.{5}.zip'.format(dirDev, sep, pardir, nameDev, config.version, config.revision), dirDev)

    #Clean
    cli_print('done\n\t • Cleaning...')
    rmtree(dirDev)

    #Upload
    if config.upload:
        cli_print('done\n\t • Beginning upload...')
        config.threadUpload += Thread(target = upload.google_code, args = ())

    #Finish feedback
    print('done\n')

main()